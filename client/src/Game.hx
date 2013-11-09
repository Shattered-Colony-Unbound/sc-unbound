class Game
{
  public static function init(newSettings : logic.GameSettings) : Void
  {
    Lib.reseed(null);
    actorList = null;
    update = null;
    progress = null;
    sprites = null;
    select = null;
    floater = null;
    pause = null;
    map = null;
    actions = null;
    tracker = null;
    spawner = null;
    pathPool = null;
    view = null;
    loadMap = null;
    settings = newSettings.clone();

    view = new ui.View(Main.getRoot());

    actorList = new ActorList();

    update = new Update();
    map = new Map(settings.getSize());
    sprites = new SpriteDisplay(view.window.getClip());
    progress = new Progress();
    select = new Select(Main.getRoot());
    // floater must come after window
    floater = new ui.MouseFloater(Main.getRoot());
    pause = new Pause(Main.getRoot());

    actions = new ActionQueue();
    pathPool = new PathFinderPool();
    tracker = new ZombieTracker();
    spawner = new ZombieSpawner(Main.getRoot(), settings);
    view.initMenus(Main.getRoot());

    if (settings.isEditor())
    {
      editor = new mapgen.Editor(Main.getRoot());
    }
    else
    {
      editor = null;
    }

    view.initCenter(Main.getRoot());

    script = new logic.Script(view.scriptSprite);
    logic.ScriptParse.parse(settings.getScript(), script);

    Main.getRoot().addEventListener(flash.events.Event.ENTER_FRAME,
                                    enterFrame);
    Main.clearFirstGame();

    gameState = GameOver.CONTINUE;
    mustSave = false;
    isFast = false;
  }

  public static function newGame(newSettings : logic.GameSettings) : Void
  {
    init(newSettings);

    var generator : MapGenerator = new MapGenerator(map, settings);
    if (settings.isCustom() && settings.isEditor())
    {
      mapgen.Editor.createEdges();
      editor.loadMap(settings.getMap());
    }
    else if (settings.isEditor())
    {
      mapgen.Editor.createEdges();
      editor.createBorders();
    }
    else if (settings.isCustom())
    {
      mapgen.Editor.createEdges();
      var boxes = new List<mapgen.EditBox>();
      mapgen.EditLoader.loadMap(settings.getMap(), boxes);
      tracker.addBuildings();
    }
    else
    {
      generator.resetMap();
      tracker.addBuildings();
      view.window.fillBitmap();
    }

    view.window.moveWindowCenter(settings.getStart().x,
                                 settings.getStart().y);
    view.mini.update();

    Main.replay.addBeginPlay();
    script.takeAction();
  }

  public static function cleanup() : Void
  {
    Main.getRoot().removeEventListener(flash.events.Event.ENTER_FRAME,
                                       enterFrame);
    if (editor != null)
    {
      editor.cleanup();
      editor = null;
    }
    spawner.cleanup();
    spawner = null;
    tracker.cleanup();
    tracker = null;
    pathPool = null;
    actions = null;

    pause.cleanup();
    pause = null;

    floater.cleanup();
    floater = null;
    select.cleanup();
    select = null;

    progress.cleanup();
    progress = null;

    sprites.cleanup();
    sprites = null;
    map.cleanup();
    map = null;
    update = null;
    view.cleanup();
    view = null;
  }

  static function enterFrame(event : flash.events.Event) : Void
  {
    var frames = 1;
    if (isFast)
    {
      frames = Option.fastFrames;
    }
    for (i in 0...frames)
    {
      actions.runAll();
      if (!pause.isPaused() && !settings.isEditor())
      {
        actorList.enterFrame();
        actions.runAll();
        pathPool.step();
        spawner.step();
        settings.incrementPlayTime();
      }
      update.commit();
      view.enterFrame();
      if (checkEndGame())
      {
        break;
      }
      checkSave();
    }
  }

  static function checkEndGame() : Bool
  {
    var result = true;
    switch (gameState)
    {
    case RESTART:
      Main.endPlay(ui.menu.MainMenu.GENERATE_MAP, settings.clone());
    case RESTART_LOAD:
      Main.endPlay(ui.menu.MainMenu.LOAD_WAIT, new logic.GameSettings());
    case END:
      if (settings.isTesting())
      {
        endEditMap(ui.menu.MainMenu.GENERATE_MAP);
      }
      else if (settings.getKey() != null)
      {
        Main.endPlay(ui.menu.MainMenu.RATE_MAP, settings.clone());
      }
      else
      {
        Main.endPlay(ui.menu.MainMenu.START, new logic.GameSettings());
      }
    case WIN:
      if (! settings.isCustom() && Main.kongregate != null)
      {
        Main.kongregate.stats.submit(settings.getDifficultyName(), 1);
      }
      if (settings.getCampaign() == 6 && Main.kongregate != null)
      {
        Main.kongregate.stats.submit("Radio Silence", 1);
      }
      if (settings.isTesting())
      {
        endEditMap(ui.menu.MainMenu.STORY_WIN);
      }
      else
      {
        Main.replay.setState(ui.menu.MainMenu.WIN);
        Main.endPlay(ui.menu.MainMenu.STORY_WIN, settings.clone());
      }
    case LOSE:
      if (settings.isTesting())
      {
        endEditMap(ui.menu.MainMenu.STORY_LOSE);
      }
      else
      {
        Main.replay.setState(ui.menu.MainMenu.LOSE);
        Main.endPlay(ui.menu.MainMenu.STORY_LOSE, settings.clone());
      }
    case LOAD_MAP:
      var newSettings = new logic.GameSettings();
      newSettings.beginLoadEdit(loadMap, "", "");
      Main.endPlay(ui.menu.MainMenu.GENERATE_MAP, newSettings);
    case TRY_MAP:
      var newSettings = new logic.GameSettings();
      newSettings.beginLoadTest(loadMap);
      newSettings.setStart(view.window.getCenter());
      Main.endPlay(ui.menu.MainMenu.STORY_BRIEFING, newSettings);
    case EDIT_MAP:
      endEditMap(ui.menu.MainMenu.GENERATE_MAP);
    default:
      result = false;
    }
    return result;
  }

  static function endEditMap(state : Int) : Void
  {
    var newSettings = new logic.GameSettings();
    newSettings.beginLoadEdit(settings.saveMap(), settings.getWinText(),
                              settings.getLoseText());
    Main.endPlay(state, newSettings);
  }

  static function checkSave() : Void
  {
    if (mustSave)
    {
      view.centerMenu.changeState(ui.menu.CenterMenu.SAVE_WAIT);
      mustSave = false;
    }
  }

  public static function endGame(newState : GameOver) : Void
  {
    gameState = newState;
  }

  public static function attemptSave() : Void
  {
    mustSave = true;
  }

  public static function toggleFast() : Void
  {
    isFast = !isFast;
  }

  public static function resize() : Void
  {
    var stage = Main.getRoot().stage;
    view.layout = new ui.LayoutGame(stage.stageWidth,
                                    stage.stageHeight,
                                    settings);

    var l = view.layout;
    sprites.resize(l);
    select.resize(l);
    view.resize();
    pause.resize(l);
    floater.resize(l);
  }

  public static function saveGame() : Void
  {
    while (pathPool.isActive())
    {
      pathPool.step();
    }
    var out = Main.gameDisk;
    out.clear();
    out.data.done = false;

    out.data.settings = settings.save();
    out.data.explosions = Save.saveList(view.explosions, ui.Explosion.saveS);

    out.data.mainReplay = Main.replay.save();
    out.data.windowOffset = view.window.getCenter().save();
    out.data.actorList = actorList.save();
    out.data.map = map.save();
    out.data.tracker = tracker.save();
    out.data.spawner = spawner.save();
    out.data.pause = pause.save();
    out.data.progress = progress.save();
    out.data.script = script.save();
    out.data.done = true;
    out.data.version = VERSION;
    out.flush(1000000);
    view.centerMenu.changeState(ui.menu.CenterMenu.NONE);
  }

  public static function loadGame() : Void
  {
    var input = Main.gameDisk;
    if (input.data.done == true && input.data.version == VERSION)
    {
      var newSettings = new logic.GameSettings();
      newSettings.load(input.data.settings);
      Main.replay.load(input.data.mainReplay);
      init(newSettings);
      mapgen.Util.seed(settings.getNormalName());

      update.clear();
      map.load(input.data.map);
      actorList.load(input.data.actorList);
      tracker.load(input.data.tracker);
      spawner.load(input.data.spawner);
      progress.load(input.data.progress);
      script.load(input.data.script);
      pause.load(input.data.pause);

      view.window.fillBitmap();
      view.window.moveWindowCenter(input.data.windowOffset.x,
                                   input.data.windowOffset.y);

      var temp = Load.loadList(input.data.explosions, ui.Explosion.load);
      view.mini.update();
      update.buttons();
      update.changeStatus();
    }
  }

  public static var actorList : ActorList;
  public static var update : Update;
  public static var progress : Progress;
  public static var sprites : SpriteDisplay;
  public static var select : Select;
  public static var floater : ui.MouseFloater;
  public static var pause : Pause;
  public static var map : Map;
  public static var actions : ActionQueue;
  public static var tracker : ZombieTracker;
  public static var spawner : ZombieSpawner;
  public static var pathPool : PathFinderPool;
  public static var editor : mapgen.Editor;
  public static var script : logic.Script;

  public static var view : ui.View;
  public static var loadMap : String;
  public static var settings : logic.GameSettings;

  static var gameState : GameOver;
  static var mustSave : Bool;
  static var isFast : Bool;

  public static var VERSION = 3;
}
