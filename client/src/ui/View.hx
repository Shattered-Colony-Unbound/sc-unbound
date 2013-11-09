package ui;

// A container for all of the user-interface objects during a game.
class View
{
  public function new(parent : flash.display.DisplayObjectContainer) : Void
  {
    frameAdvance = new FrameAdvance();
    imageList = new List<ImageStack>();
    initBarSource();
    layout = new LayoutGame(parent.stage.stageWidth,
                            parent.stage.stageHeight,
                            Game.settings);
//    mouseScroller = new MouseScroller(parent);

    window = new Window(parent, layout);
    explosions = new List<Explosion>();
  }

  public function initMenus(parent : flash.display.DisplayObjectContainer)
    : Void
  {
    spawner = new SpawnDisplay(parent, layout);
    mini = new MiniMap(parent, layout);
    buildMenu = new ui.menu.BuildMenu(parent, layout);
    quickMenu = new ui.menu.Quick(parent, layout);
    sideMenu = new ui.menu.SideBar(parent, layout);
    totals = new TotalResource(parent, layout);
    scrollMenu = new ui.menu.ScrollMenu(parent, layout.screenSize);
    scriptSprite = new ScriptView(parent, layout);
    toolTip = new ToolTip(parent, layout);
    warning = new FailWarning(parent, layout.screenSize);
    centerMenu = new ui.menu.CenterMenu();
    fpsCounter = new FpsCounter(parent, layout);

    Main.key.addHandler(centerMenu.hotkey);
    Main.key.addHandler(buildMenu.hotkey);
    if (! Game.settings.isEditor())
    {
      Main.key.addHandler(sideMenu.hotkey);
      Main.key.addHandler(quickMenu.hotkey);
    }
    Main.key.addHandler(scrollMenu.hotkey);
    Main.key.addHandler(hotkey);
  }

  public function initCenter(parent : flash.display.DisplayObjectContainer)
    : Void
  {
    centerMenu.init(parent, layout);
  }

  public function cleanup() : Void
  {
    Main.key.clearHandlers();
    fpsCounter.cleanup();
    fpsCounter = null;
    centerMenu.cleanup();
    centerMenu = null;
    warning.cleanup();
    warning = null;
    toolTip.cleanup();
    toolTip = null;
    scriptSprite.cleanup();
    scriptSprite = null;
    scrollMenu.cleanup();
    scrollMenu = null;
    totals.cleanup();
    totals = null;
    sideMenu.cleanup();
    sideMenu = null;
    quickMenu.cleanup();
    quickMenu = null;
    buildMenu.cleanup();
    buildMenu = null;
    mini.cleanup();
    mini = null;
    spawner.cleanup();
    spawner = null;
    window.cleanup();
    window = null;
//    mouseScroller.cleanup();
//    mouseScroller = null;
    layout = null;
    cleanupBarSource();
  }

  public function resize() : Void
  {
    toolTip.hide();
    scriptSprite.resize(layout);
    mini.resize(layout);
    window.resize(layout);
    spawner.resize(layout);
    quickMenu.resize(layout);
    sideMenu.resize(layout);
    buildMenu.resize(layout);
    centerMenu.resize(layout);
    warning.resize(layout.screenSize);
    totals.resize(layout);
    scrollMenu.resize(layout.screenSize);
  }

  public function enterFrame() : Void
  {
    fpsCounter.enterFrame();
    spawner.step();
    if (! Game.pause.isPaused())
    {
      frameAdvance.fixedStep();
    }
    toolTip.enterFrame();
    sideMenu.enterFrame();
    warning.enterFrame();
    scrollMenu.enterFrame();
  }

  public function updateImageList() : Void
  {
    for (current in imageList)
    {
      current.update();
    }
  }

  public function hotkey(ch : String, code : Int) : Bool
  {
    var used = true;

    if (code == Keyboard.escapeCode)
    {
      ui.Util.success();
      if (Game.select.getSelected() != null)
      {
        Game.update.changeSelect(null);
      }
      else
      {
        centerMenu.changeState(ui.menu.CenterMenu.SYSTEM);
      }
    }
    else if (ch == '`')
    {
      Game.toggleFast();
    }
    else if (ch == ';')
    {
      var pos = new Point(Math.floor(Main.getRoot().stage.mouseX),
                          Math.floor(Main.getRoot().stage.mouseY));
      var mapPos = Game.view.window.toAbsolute(Lib.pixelToCell(pos.x),
                                               Lib.pixelToCell(pos.y));
      Lib.trace("Mouse Pos: " + pos.toString());
      Lib.trace("Map Pos: " + mapPos.toString());
    }
    else if (ch == '1')
    {
      Game.spawner.startHorde();
    }
    else if (ch == '2')
    {
      var bridge = Game.progress.getRandomBridge();
      Game.actions.push(new action.DestroyBridge(bridge));
    }
    else
    {
      used = false;
    }
    return used;
  }

  public function changeSelect(dest : Point) : Void
  {
    if (dest == null)
    {
      Game.update.changeSelect(null);
    }
    else
    {
      var cell = Game.map.getCell(dest.x, dest.y);
      if (cell.hasTower() || cell.hasShadow())
      {
        if (! Game.settings.isEditor()
            || Point.isEqual(Game.editor.getSelectedSquare(), dest))
        {
          Game.update.changeSelect(dest);
        }
        else
        {
          Game.update.changeSelect(null);
        }
      }
      else
      {
        Game.update.changeSelect(null);
      }
    }
  }

  function initBarSource() : Void
  {
    var tempClip = Workaround.attach("resourcetiles");
    var width = Lib.cellToPixel(3);
    var height = Lib.cellToPixel(6);

    barSource = new flash.display.BitmapData(width, height, true, 0);
    barSource.draw(tempClip);
    tempClip = null;

  }

  function cleanupBarSource() : Void
  {
    barSource.dispose();
    barSource = null;
  }

  public var imageList : List<ImageStack>;
  public var barSource : flash.display.BitmapData;
  public var layout : LayoutGame;
//  public var mouseScroller : MouseScroller;
  public var window : Window;
  public var spawner : SpawnDisplay;
  public var mini : MiniMap;
  public var quickMenu : ui.menu.Quick;
  public var sideMenu : ui.menu.SideBar;
  public var centerMenu : ui.menu.CenterMenu;
  public var buildMenu : ui.menu.BuildMenu;
  public var toolTip : ToolTip;
  public var scriptSprite : ScriptView;
  public var frameAdvance : FrameAdvance;
  public var fpsCounter : FpsCounter;
  public var explosions : List<Explosion>;
  public var warning : FailWarning;
  public var totals : TotalResource;
  public var scrollMenu : ui.menu.ScrollMenu;
}
