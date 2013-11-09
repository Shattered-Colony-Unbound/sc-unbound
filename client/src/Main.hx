class Main
{
  public function new() : Void
  {
  }

  function init(newRoot : flash.display.DisplayObjectContainer) : Void
  {
    error = "";
    logic.ScriptParse.init();
    theRoot = newRoot;
    theRoot.x = 0;
    theRoot.y = 0;
    var stage = theRoot.stage;
    stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
    stage.addEventListener(flash.events.FullScreenEvent.FULL_SCREEN,
                           fullScreenHandler);
    stage.addEventListener(flash.events.Event.RESIZE,
                           resizeHandler);
    ui.MouseScroller.trackMouse();
    key = new Keyboard(stage);
    replay = null;

    configDisk = flash.net.SharedObject.getLocal(ui.Label.configDisk);
    configDisk.addEventListener(flash.events.AsyncErrorEvent.ASYNC_ERROR,
                                asyncHandler);
    configDisk.addEventListener(flash.events.NetStatusEvent.NET_STATUS,
                                netStatusHandler);
    configDisk.addEventListener(flash.events.SyncEvent.SYNC,
                                syncHandler);
    editSave = configDisk.data.editSave;
    gameDisk = flash.net.SharedObject.getLocal(ui.Label.gameDisk);
    gameDisk.addEventListener(flash.events.AsyncErrorEvent.ASYNC_ERROR,
                              asyncHandler);
    gameDisk.addEventListener(flash.events.NetStatusEvent.NET_STATUS,
                              netStatusHandler);
    gameDisk.addEventListener(flash.events.SyncEvent.SYNC,
                              syncHandler);
    config = new Config();
    layout = new ui.LayoutMain(theRoot.stage.stageWidth,
                               theRoot.stage.stageHeight);
    menu = new ui.menu.MainMenu(theRoot, layout);
    music = new ui.MusicPlayer();
    sound = new SoundPlayer(Main.getRoot());
    BitstreamVeraSans.init();
    ui.Animation.init();
    state = MENU;
  }

  static function main(newRoot : flash.display.DisplayObjectContainer) : Void
  {
    var initObj = new Main();
    initObj.init(newRoot);
  }

  static function asyncHandler(event : flash.events.AsyncErrorEvent)
  {
  }

  static function netStatusHandler(event : flash.events.NetStatusEvent)
  {
  }

  static function syncHandler(event : flash.events.SyncEvent)
  {
  }

  public static function beginPlay() : Void
  {
    var settings = menu.getSettings().clone();
    menu.cleanup();
    menu = null;
    replay = new Replay();
    Game.newGame(settings);
    if (settings.isEditor())
    {
      music.stop();
    }
    else
    {
      music.changeMusic(ui.MusicPlayer.QUIET, true);
    }
    state = PLAY;
  }

  public static function endPlay(startState : Int,
                                 settings : logic.GameSettings) : Void
  {
    Game.cleanup();
    menu = new ui.menu.MainMenu(theRoot, layout);
    menu.setSettings(settings);
    if (startState == ui.menu.MainMenu.RATE_MAP)
    {
      menu.rateState = ui.menu.MainMenu.START;
    }
    menu.changeState(startState);
    if (startState != ui.menu.MainMenu.GENERATE_MAP)
    {
      music.changeMusic(ui.MusicPlayer.MAIN_INTRO, true);
    }
    state = MENU;
  }

  public static function loadGame() : Void
  {
    menu.cleanup();
    menu = null;
    replay = new Replay();
    Game.loadGame();
    if (Game.spawner.getWaveCount() == 0)
    {
      music.changeMusic(ui.MusicPlayer.QUIET, true);
    }
    else
    {
      Main.music.changeMusic(ui.MusicPlayer.randomWave(), true);
    }
    state = PLAY;
  }

  public static function beginReplay() : Void
  {
    var settings = menu.getSettings();
    menu.cleanup();
    menu = null;
    replay.start(layout, settings);
    state = REPLAY;
  }

  public static function endReplay(startState : Int,
                                   settings : logic.GameSettings) : Void
  {
    replay.cleanup();
    menu = new ui.menu.MainMenu(theRoot, layout);
    menu.setSettings(settings);
    menu.changeState(startState);
    state = MENU;
  }

  public static function getRoot() : flash.display.DisplayObjectContainer
  {
    return theRoot;
  }

  public static function canLoad() : Bool
  {
    return gameDisk != null && gameDisk.data.done == true
      && gameDisk.data.version == Game.VERSION;
  }

  public static function firstGame() : Bool
  {
    return gameDisk != null && gameDisk.data.hasPlayed == null;
  }

  public static function clearFirstGame() : Void
  {
    gameDisk.data.hasPlayed = true;
  }

  function fullScreenHandler(event : flash.events.FullScreenEvent) : Void
  {
    resize();
  }

  function resizeHandler(event : flash.events.Event) : Void
  {
    resize();
  }

  function resize() : Void
  {
    layout = new ui.LayoutMain(theRoot.stage.stageWidth,
                               theRoot.stage.stageHeight);
    if (state == PLAY)
    {
      Game.resize();
    }
    else
    {
      if (state == MENU)
      {
        menu.resize(layout);
      }
      else if (state == REPLAY)
      {
        replay.resize(layout);
      }
    }
  }

  public static function getEditSave() : String
  {
    return editSave;
  }

  public static function setEditSave(newEditSave : String) : Void
  {
    editSave = newEditSave;
    configDisk.data.editSave = newEditSave;
  }

  public static var theRoot : flash.display.DisplayObjectContainer;
  public static var key : Keyboard;
  public static var menu : ui.menu.MainMenu;
  public static var replay : Replay;
  public static var configDisk : flash.net.SharedObject;
  public static var gameDisk : flash.net.SharedObject;
  public static var config : Config;
  public static var music : ui.MusicPlayer;
  public static var sound : SoundPlayer;
  public static var error : String;
  public static var kongregate : Dynamic;
  static var layout : ui.LayoutMain;
  static var state : Int;
  static var editSave : String;

  static var MENU = 0;
  static var PLAY = 1;
  static var REPLAY = 2;
}
