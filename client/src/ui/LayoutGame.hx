package ui;

class LayoutGame
{
  public function new(sizeX : Int, sizeY : Int,
                      settings : logic.GameSettings) : Void
  {
    screenSize = new Point(sizeX, sizeY);
    margin = 10;
    scrollMargin = 5;
    scrollOutMargin = 100;

    initMiniMap(settings);
    initWindow(settings);
    initFpsCounter();
    initMenu();
    initQuick();
    initZombieSpawner();
    initToolTip();
    initTutorial();
  }

  public var screenSize : Point;
  public var margin : Int;
  public var scrollMargin : Int;
  public var scrollOutMargin : Int;

  // -----------------------------------------------------------------
  // Window
  // -----------------------------------------------------------------
  function initWindow(settings : logic.GameSettings) : Void
  {
    windowSize = new Point(Math.ceil(screenSize.x / Option.cellPixels),
                           Math.ceil(screenSize.y / Option.cellPixels));
    if (windowSize.x > settings.getSize().x)
    {
      windowSize.x = settings.getSize().x;
    }
    if (windowSize.y > settings.getSize().y)
    {
      windowSize.y = settings.getSize().y;
    }
    mapOffset = new Point(0, 0);
    mapSize = new Point(Lib.cellToPixel(windowSize.x),
                        Lib.cellToPixel(windowSize.y));
    windowCenter = new Point(Math.floor(windowSize.x / 2),
                             Math.floor(windowSize.y / 2));
  }

  public var windowSize : Point;
  public var mapOffset : Point;
  public var mapSize : Point;
  public var windowCenter : Point;

  // -----------------------------------------------------------------
  // FPS Counter
  // -----------------------------------------------------------------
  function initFpsCounter() : Void
  {
    fpsSize = new Point(60, 15);
    fpsOffset = new Point(0, screenSize.y - fpsSize.y);
  }

  public var fpsOffset : Point;
  public var fpsSize : Point;

  // -----------------------------------------------------------------
  // Menu
  // -----------------------------------------------------------------
  function initMenu() : Void
  {
    sideMenuOffset = new Point(screenSize.x - 400, screenSize.y - 600);
    resourceHiddenOffset = 565;
    resourceShownOffset = 525;
  }
  public var sideMenuOffset : Point;
  public var resourceHiddenOffset : Int;
  public var resourceShownOffset : Int;

  // -----------------------------------------------------------------
  // Quick Menu
  // -----------------------------------------------------------------
  function initQuick() : Void
  {
    quickOffset = new Point(0, screenSize.y);
    totalResourceOffset = new Point(Math.floor(screenSize.x/2), 0);
    buildMenuOffset = new Point(0, quickOffset.y - 20);
  }

  public var quickOffset : Point;
  public var totalResourceOffset : Point;
  public var buildMenuOffset : Point;

  // -----------------------------------------------------------------
  // MiniMap
  // -----------------------------------------------------------------
  function initMiniMap(settings : logic.GameSettings) : Void
  {
    miniCellSize = 2;
    if (settings.getSize().x > 65 && settings.getSize().y > 65
        /*&& screenSize.x < 800*/)
    {
      miniCellSize = 1;
    }
/*
    else if (screenSize.x >= 1024)
    {
      miniCellSize = 3;
    }
*/
    var margin = 10;

    miniSize = new Point(settings.getSize().x * miniCellSize,
                         settings.getSize().y * miniCellSize);
    miniScreenSize = new Point(160, 160);
    monitorScaleX = miniSize.x / miniScreenSize.x;
    monitorScaleY = miniSize.y / miniScreenSize.y;
    monitorSize = new Point(Math.ceil(245*monitorScaleX),
                            Math.ceil(217*monitorScaleY));
    monitorOffset = new Point(screenSize.x - monitorSize.x + margin, -margin);
    miniOffset = new Point(Math.ceil(27*monitorScaleX) + monitorOffset.x,
                           Math.ceil(30*monitorScaleY) + monitorOffset.y);
  }

  public var miniCellSize : Int;
  public var miniSize : Point;
  public var miniScreenSize : Point;
  public var miniOffset : Point;
  public var monitorSize : Point;
  public var monitorOffset : Point;
  public var monitorScaleX : Float;
  public var monitorScaleY : Float;

  // -----------------------------------------------------------------
  // ZombieSpawner
  // -----------------------------------------------------------------
  function initZombieSpawner() : Void
  {
    playToggleOffset = new Point(157, 39);
    pauseToggleOffset = new Point(160, 60);

    countDownSize = new Point(221, 140);
    if (screenSize.x < 800)
    {
      countDownSize = new Point(166, 105);
    }
    countDownOffset = new Point(0, 0);
  }

  public var playToggleOffset : Point;
  public var pauseToggleOffset : Point;

  public var countDownOffset : Point;
  public var countDownSize : Point;

  // -----------------------------------------------------------------
  // Tool Tip text box
  // -----------------------------------------------------------------
  function initToolTip() : Void
  {
    tipWidth = Math.floor(screenSize.x / 3);
    if (tipWidth > 200)
    {
      tipWidth = 200;
    }
  }

  public var tipWidth : Int;

  // -----------------------------------------------------------------
  // Tutorial text box
  // -----------------------------------------------------------------
  function initTutorial() : Void
  {
    tutorialBoxOffset = new Point(5, 200);
    tutorialTextOffset = new Point(tutorialBoxOffset.x + 10,
                                   tutorialBoxOffset.y + 10);
    tutorialSize = new Point(200, 50);
  }

  public var tutorialBoxOffset : Point;
  public var tutorialTextOffset : Point;
  public var tutorialSize : Point;
}
