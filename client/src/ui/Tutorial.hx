package ui;

class Tutorial
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      l : LayoutGame) : Void
  {
    usingTutorial = false;
    state = 0;
    steps = [];

    clip = new TutorialClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;
    clip.back.mouseEnabled = false;
    clip.back.mouseChildren = false;

    buttons = new ButtonList(click, null, [clip.next]);
    clip.next.mouseEnabled = true;
    clip.next.mouseChildren = false;

    clip.text.wordWrap = true;
    clip.text.autoSize = flash.text.TextFieldAutoSize.LEFT;
    clip.text.addEventListener(flash.events.TextEvent.LINK, link);

    var sheet = new flash.text.StyleSheet();
    sheet.parseCSS(Text.tutorialStyleSheet);
    clip.text.styleSheet = sheet;

    clip.arrow.mouseEnabled = false;
    clip.arrow.mouseChildren = false;
    clip.arrow.visible = false;
/*
    guide = new ArrowClip();
    parent.addChild(guide);
    guide.visible = false;
    guide.mouseEnabled = false;
    guide.mouseChildren = false;
*/
    isPlacing = false;
    showNext = false;
    screen = null;

    resize(l);
  }

  public function cleanup() : Void
  {
/*
    guide.parent.removeChild(guide);
    guide = null;
*/
    clearScreen();
    buttons.cleanup();
    clip.text.removeEventListener(flash.events.TextEvent.LINK, link);
    clip.parent.removeChild(clip);
    clip = null;
  }

  public function resize(l : ui.LayoutGame) : Void
  {
    sniperBuildClick.x = l.sideMenuOffset.x + 311 - 20;
    sniperBuildClick.y = l.sideMenuOffset.y + 425;
    barricadeBuildClick.x = l.sideMenuOffset.x + 361 - 20;
    barricadeBuildClick.y = l.sideMenuOffset.y + 425;
    depotBuildClick.x = l.sideMenuOffset.x + 361 - 20;
    depotBuildClick.y = l.sideMenuOffset.y + 470;
    workshopBuildClick.x = l.sideMenuOffset.x + 311 - 20;
    workshopBuildClick.y = l.sideMenuOffset.y + 470;
    shootClick.x = l.sideMenuOffset.x + 320 - 20;
    shootClick.y = l.sideMenuOffset.y + 463;
    barricadeDestroyClick.x = l.sideMenuOffset.x + 385 - 10;
    barricadeDestroyClick.y = l.sideMenuOffset.y + 558;
    workshopIncreaseClick.x = l.sideMenuOffset.x + 375 - 10;
    workshopIncreaseClick.y = l.sideMenuOffset.y + 394;
    sideOffset.x = l.sideMenuOffset.x;
    sideOffset.y = l.sideMenuOffset.y;
    timerOffset.x = l.countDownOffset.x + l.countDownSize.x;
    timerOffset.y = 0;

    clip.back.x = l.tutorialBoxOffset.x;
    clip.back.y = l.tutorialBoxOffset.y;

    clip.text.x = l.tutorialTextOffset.x;
    clip.text.y = l.tutorialTextOffset.y;
    clip.text.width = l.tutorialSize.x;

    commitState();
  }

  public function trigger(type : Int, ? pos : Point) : Void
  {
    if (usingTutorial)
    {
      var typeOk = checkType(type, pos);
      if (type == CLICK_NEXT
          || (typeOk && checkSelected() && checkPlacing()
              && checkSelectedType()))
      {
        if ((type & CLICK) != 0)
        {
          ++state;
          clearScreen();
          isPlacing = false;
          showNext = (state < steps.length
                      && ((steps[state].type & DISPLAY_NEXT) != 0));
          if (state == HORDE_START)
          {
            Game.spawner.startTutorialCountDown();
          }
        }
        else
        {
          showNext = true;
          if (state == HORDE_START)
          {
            Game.spawner.endTutorialCountDown();
          }
          commitState();
        }
      }
      else if (checkSelected() && ! checkPlacing()
               && checkSelectedType() && typeOk)
      {
        isPlacing = true;
      }
      if (type == CHANGE_SELECT || type == CANCEL_MODE)
      {
        isPlacing = false;
      }
      commitState();
    }
  }

  function checkType(type : Int, pos : Point) : Bool
  {
    var testType = steps[state].type;
    var testPos = steps[state].pos;
    if (isPlacing)
    {
      testType = steps[state].placeType;
      testPos = steps[state].place;
    }
    return ((type & TEST_MASK) == (testType & TEST_MASK)
            && ((testType & CHECK_POS) == 0
                || (testType & IS_MAP_POS) == 0
                || Point.isEqual(pos, testPos)));
  }

  function checkSelected() : Bool
  {
    var select = Game.select.getSelected();
    return ((steps[state].type & CHECK_POS) == 0
            || steps[state].select == null
            || Point.isEqual(steps[state].select, select));

  }

  function checkPlacing() : Bool
  {
    return (steps[state].place == null || isPlacing);
  }

  function checkSelectedType() : Bool
  {
    var tower = getTowerType(Game.select.getSelected());
    var check = getCheckType();
    return (check == -1 || tower == check);
  }

  function getTowerType(select : Point) : Int
  {
    var result = -1;
    if (select != null)
    {
      var tower = Game.map.getCell(select.x, select.y).getTower();
      if  (tower != null)
      {
        result = tower.getType();
      }
    }
    return result;
  }

  function getCheckType() : Int
  {
    var result = -1;
    var type = steps[state].type;
    if ((type & CHECK_SNIPER) != 0)
    {
      result = Tower.SNIPER;
    }
    else if ((type & CHECK_BARRICADE) != 0)
    {
      result = Tower.BARRICADE;
    }
    else if ((type & CHECK_WORKSHOP) != 0)
    {
      result = Tower.WORKSHOP;
    }
    else if ((type & CHECK_DEPOT) != 0)
    {
      result = Tower.DEPOT;
    }
    return result;
  }

  static var dirToScrollText = [Text.moveWindowNorth,
                                Text.moveWindowSouth,
                                Text.moveWindowEast,
                                Text.moveWindowWest];

  function updateGuide(pos : Point, isMap : Bool) : Void
  {
    if (pos == null)
    {
      hideArrow();
    }
    else
    {
      if (isMap)
      {
        var screenSize = Game.view.layout.screenSize;
        var middle = new Point(Math.floor(screenSize.x / 2),
                               Math.floor(screenSize.y / 2));
        var dirToPos = [new Point(middle.x, 0),
                        new Point(middle.x, screenSize.y),
                        new Point(screenSize.x, middle.y),
                        new Point(0, middle.y)];

        var winDir = Game.view.window.getDir(pos);
        if (winDir == null)
        {
          pos = Game.view.window.toRelative(pos.x, pos.y).toPixel();
          pos.x += Option.halfCell;
          pos.y += Option.halfCell;
        }
        else
        {
          var index = Lib.directionToIndex(winDir);
          pos = dirToPos[index];
        }
      }
      showArrow(pos);
    }
  }

  function hideArrow() : Void
  {
    clip.arrow.visible = false;
  }

  function showArrow(pos : Point) : Void
  {
    clip.arrow.visible = true;
    clip.arrow.x = pos.x;
    clip.arrow.y = pos.y;
    var deltaX = pos.x - (clip.text.x + clip.text.width/2);
    var deltaY = pos.y - (clip.text.y + clip.text.height/2);
    var angle = Lib.slopeToAngle(deltaX, deltaY);
    clip.arrow.rotation = 180 + angle;
    clip.arrow.tail.width = Math.sqrt(deltaX*deltaX + deltaY*deltaY);
  }

  function commitState() : Void
  {
    if (usingTutorial)
    {
      if (state < steps.length)
      {
        setText(calculateText());
        setGuide();
        setScreen();
      }
      else
      {
        usingTutorial = false;
        clip.visible = false;
        hideArrow();
      }
    }
  }

  function setText(newText : String) : Void
  {
    clip.text.htmlText = newText;
    var textWidth = Math.floor(clip.text.width);
    var textHeight = Math.floor(clip.text.height);
    if (showNext && checkSelected() && checkSelectedType())
    {
      clip.next.visible = true;
      clip.next.x = clip.text.x;
      clip.next.y = clip.text.y + textHeight + 5;
      textHeight += 5 + Math.floor(clip.next.height);
    }
    else
    {
      clip.next.visible = false;
    }
    var boxSize = new Point(textWidth + 10, textHeight + 10);
    clip.back.graphics.clear();
    clip.back.graphics.lineStyle(borderThickness, Color.tutorialBorder, 1.0,
                                 false, flash.display.LineScaleMode.NONE);
    clip.back.graphics.beginFill(Color.tutorialBackground,
                                 Color.tutorialAlpha);
    clip.back.graphics.drawRoundRect(0, 0,
                                     boxSize.x, boxSize.y,
                                     10, 10);
    clip.back.graphics.endFill();
  }

  function calculateText() : String
  {
    var result = Text.tutorial[state];
    if (! checkSelected() || ! checkSelectedType())
    {
      var type = getCheckType();
      if (type != -1)
      {
        result = clickTowerText[type];
      }
    }
    else if ((steps[state].type & DISPLAY_NEXT) != 0
             && steps[state].linkage != "")
    {
      result = Text.clickNext;
    }
    return result;
  }

  function setGuide() : Void
  {
    if (! checkSelected() || ! checkSelectedType())
    {
      if (canSelect())
      {
        updateGuide(steps[state].select, true);
      }
      else
      {
        updateGuide(null, false);
      }
    }
    else if (! isPlacing)
    {
      if ((steps[state].type & DISPLAY_GUIDE) != 0)
      {
        updateGuide(steps[state].pos, false);
      }
      else
      {
        updateGuide(null, false);
      }
    }
    else
    {
      if (canPlace())
      {
        updateGuide(steps[state].place, true);
      }
      else
      {
        updateGuide(null, false);
      }
    }
  }

  function canSelect() : Bool
  {
    var tower = getTowerType(steps[state].select);
    var check = getCheckType();
    return (check == -1 || tower == check);
  }

  function canPlace() : Bool
  {
    var result = false;
    var type = steps[state].type;
    var towerType = -1;
    if (type == CLICK_SNIPER)
    {
      towerType = Tower.SNIPER;
    }
    else if (type == CLICK_BARRICADE)
    {
      towerType = Tower.BARRICADE;
    }
    else if (type == CLICK_WORKSHOP)
    {
      towerType = Tower.WORKSHOP;
    }
    else if (type == CLICK_DEPOT)
    {
      towerType = Tower.DEPOT;
    }
    if (towerType != -1)
    {
      var place = steps[state].place;
      result = Tower.canPlace(towerType, place.x, place.y);
    }
    return result;
  }

  function setScreen() : Void
  {
    if ((steps[state].type & DISPLAY_SCREEN) != 0
        && steps[state].linkage != "")
    {
      showScreen(steps[state].linkage, steps[state].pos);
      if (checkSelected() && checkSelectedType())
      {
        screen.visible = true;
      }
      else
      {
        screen.visible = false;
      }
    }
  }

  function showScreen(linkage : String, pos : Point) : Void
  {
    if (screen == null)
    {
      screen = Workaround.attach(linkage);
      clip.addChild(screen);
      screen.mouseEnabled = false;
      screen.mouseChildren = false;
    }
    screen.x = pos.x;
    screen.y = pos.y;
  }

  function clearScreen() : Void
  {
    if (screen != null)
    {
      screen.parent.removeChild(screen);
      screen = null;
    }
  }

  function click(choice : Int) : Void
  {
    if (choice == 0)
    {
      Util.success();
      trigger(CLICK_NEXT);
    }
  }

  function link(event : flash.events.TextEvent) : Void
  {
    ui.Util.success();
    Game.view.centerMenu.lookup(event.text);
  }

  public function isUsingTutorial() : Bool
  {
    return usingTutorial;
  }

  var usingTutorial : Bool;
  var state : Int;
  var steps : Array<TutorialStep>;

  var clip : TutorialClip;
  var screen : flash.display.MovieClip;

  var buttons : ButtonList;

  // Is the click mode on the third substep
  var isPlacing : Bool;
  var showNext : Bool;

  // Wait for a simple event without any context
  function simpleStep(newType : Int) : TutorialStep
  {
    return null;
  }

  // Wait for an event to happen on a particular map square
  function mapStep(newType : Int, mapPos : Point) : TutorialStep
  {
    return null;
  }

  // Wait for a button to be clicked on a particular tower
  function clickStep(newType : Int, newPos : Point, newDir : Direction,
                     newSelect : Point) : TutorialStep
  {
    return null;
  }

  // Wait for a particular build order to be clicked on a particular tower.
  function buildStep(newType : Int, newPos : Point, newDir : Direction,
                     newSelect : Point, newPlaceType : Int,
                     newPlace : Point) : TutorialStep
  {
    return null;
  }

  function nextStep(newPos : Point, linkage : String,
                    select : Point, checkFlag : Int) : TutorialStep
  {
    var dir = Direction.EAST;
    if (select == null)
    {
      dir = null;
    }
    var result = new TutorialStep(CLICK_NEXT | checkFlag, newPos, dir, select);
    result.linkage = linkage;
    return result;
  }

  public function start() : Void
  {
    Lib.reseed([0, 0, 0, 0]);
    clip.visible = true;
    usingTutorial = true;
    state = 0;
/*
    var l = Game.view.layout;
    var sniperPos = new Point(l.sideMenuOffset.x + 311 - 20,
                              l.sideMenuOffset.y + 425);
    var barricadePos = new Point(l.sideMenuOffset.x + 361 - 20,
                                 l.sideMenuOffset.y + 425);
    var depotPos = new Point(l.sideMenuOffset.x + 361 - 20,
                             l.sideMenuOffset.y + 470);
    var workshopPos = new Point(l.sideMenuOffset.x + 311 - 20,
                                l.sideMenuOffset.y + 470);
    var shootPos = new Point(l.sideMenuOffset.x + 320 - 20,
                             l.sideMenuOffset.y + 463);
    var pausePos = new Point(121, 64);
    var destroyBarricadePos = new Point(l.sideMenuOffset.x + 385 - 20,
                                        l.sideMenuOffset.y + 558);
    var increaseQuotaPos = new Point(l.sideMenuOffset.x + 375 - 20,
                                     l.sideMenuOffset.y + 394);
*/
    var depotMapPos = new Point(24, 37);
    var sniperMapPos = new Point(24, 30);
    // 0
    steps = [nextStep(new Point(0, 0), "", null, 0),
             new TutorialStep(MOVE_WINDOW),
             nextStep(sideOffset, Label.depotBuildScreen, depotMapPos,
                      CHECK_DEPOT),
             new TutorialStep(CLICK_SNIPER, sniperBuildClick, Direction.EAST,
                              depotMapPos, PLAN_SNIPER, sniperMapPos),
             new TutorialStep(BUILD_SNIPER, sniperMapPos),
             // 5
             new TutorialStep(CLICK_SNIPER, sniperBuildClick, Direction.EAST,
                              depotMapPos, PLAN_SNIPER, new Point(21, 30)),
             new TutorialStep(ADD_AMMO, new Point(21, 30)),
             nextStep(sideOffset, Label.sniperScreen, sniperMapPos,
                      CHECK_SNIPER),
             new TutorialStep(CLICK_SHOOT, shootClick, Direction.EAST,
                              sniperMapPos),
             new TutorialStep(ZOMBIE_CLEAR),
             // 10
             nextStep(sideOffset, Label.depotResourceScreen, depotMapPos,
                      CHECK_DEPOT),
             new TutorialStep(CLICK_BARRICADE, barricadeBuildClick,
                              Direction.EAST,
                              depotMapPos, PLAN_BARRICADE, new Point(24, 28)),
             new TutorialStep(CLICK_BARRICADE, barricadeBuildClick,
                              Direction.EAST,
                              depotMapPos, PLAN_BARRICADE, new Point(23, 27)),
             new TutorialStep(CLICK_BARRICADE, barricadeBuildClick,
                              Direction.EAST,
                              depotMapPos, PLAN_BARRICADE, new Point(22, 28)),
             new TutorialStep(CLICK_BARRICADE, barricadeBuildClick,
                              Direction.EAST,
                              depotMapPos, PLAN_BARRICADE, new Point(21, 28)),
             // 15
             nextStep(timerOffset, Label.timerScreen, null, 0),
             new TutorialStep(ZOMBIE_HORDE_END),
             nextStep(sideOffset, Label.barricadeScreen, new Point(23, 27),
                      CHECK_BARRICADE),
             new TutorialStep(DESTROY_BARRICADE, barricadeDestroyClick,
                              Direction.EAST, new Point(23, 27)),
             new TutorialStep(CLOSE_TOWER, new Point(23, 27)),
             // 20
             new TutorialStep(CLICK_DEPOT, depotBuildClick, Direction.EAST,
                              depotMapPos, PLAN_DEPOT, new Point(23, 25)),
             nextStep(sideOffset, Label.depotMiscScreen, depotMapPos,
                      CHECK_DEPOT),
             new TutorialStep(CLICK_WORKSHOP, workshopBuildClick,
                              Direction.EAST,
                              depotMapPos, PLAN_WORKSHOP, new Point(25, 36)),
             new TutorialStep(CLICK_WORKSHOP, workshopBuildClick,
                              Direction.EAST,
                              depotMapPos, PLAN_WORKSHOP, new Point(20, 33)),
             new TutorialStep(CLICK_WORKSHOP, workshopBuildClick,
                              Direction.EAST,
                              depotMapPos, PLAN_WORKSHOP, new Point(25, 33)),
             // 25
             new TutorialStep(ISLAND_CLEAR),
             new TutorialStep(CLICK_WORKSHOP, workshopBuildClick,
                              Direction.EAST,
                              new Point(23, 25), PLAN_WORKSHOP | CHECK_POS,
                              new Point(23, 8)),
             new TutorialStep(BUILD_WORKSHOP | CHECK_POS, new Point(23, 8)),
             nextStep(sideOffset, Label.workshopScreen, new Point(23, 8),
                      CHECK_WORKSHOP),
             new TutorialStep(INCREASE_QUOTA_WORKSHOP | CHECK_POS,
                              workshopIncreaseClick,
                              Direction.EAST, new Point(23, 8))
      ];
    showNext = (state < steps.length
                && ((steps[state].type & DISPLAY_NEXT) != 0));
    isPlacing = false;
    commitState();
  }

  static var HORDE_START = 16;
  static var HORDE_END = 17;

  public function enterFrame() : Void
  {
    if (usingTutorial)
    {
      if (Game.progress.getZombieCount() <= 17)
      {
        trigger(ZOMBIE_CLEAR);
      }
      if (Game.progress.getZombieCount() == 0)
      {
        trigger(ISLAND_CLEAR);
      }
    }
  }

  static var TEST_MASK =       0x000fff;
  static var IS_MAP_POS =      0x001000;
  static var DISPLAY_GUIDE =   0x002000;
  static var CHECK_POS =       0x004000;
  static var DISPLAY_NEXT =    0x008000;
  static var DISPLAY_SCREEN =  0x010000;
  static var CHECK_SNIPER =    0x020000;
  static var CHECK_WORKSHOP =  0x040000;
  static var CHECK_BARRICADE = 0x080000;
  static var CHECK_DEPOT =     0x100000;
  static var CLICK =           0x200000;

  public static var MOVE_WINDOW = 0;
  public static var CLICK_SHOOT = 1 | DISPLAY_GUIDE | CHECK_SNIPER | CLICK;
  public static var CLICK_PAUSE = 2 | DISPLAY_GUIDE | CLICK;
  public static var ZOMBIE_CLEAR = 3;
  public static var ISLAND_CLEAR = 4;
  public static var ZOMBIE_HORDE_END = 5;
  public static var CANCEL_MODE = 6 | CLICK;
  public static var DESTROY_BARRICADE = 7 | DISPLAY_GUIDE | CHECK_BARRICADE | CLICK;
  public static var INCREASE_QUOTA_WORKSHOP = 8 | DISPLAY_GUIDE | CHECK_WORKSHOP | CLICK;
  public static var CLICK_SNIPER = 9 | DISPLAY_GUIDE | CHECK_DEPOT | CLICK;
  public static var CLICK_BARRICADE = 10 | DISPLAY_GUIDE | CHECK_DEPOT | CLICK;
  public static var CLICK_DEPOT = 11 | DISPLAY_GUIDE | CHECK_DEPOT | CLICK;
  public static var CLICK_WORKSHOP = 12 | DISPLAY_GUIDE | CHECK_DEPOT | CLICK;
  public static var BUILD_SNIPER = 13 /*| CHECK_POS*/ | IS_MAP_POS;
  public static var BUILD_BARRICADE = 14 /*| CHECK_POS*/ | IS_MAP_POS;
  public static var BUILD_DEPOT = 15 /*| CHECK_POS*/ | IS_MAP_POS;
  public static var BUILD_WORKSHOP = 16 /*| CHECK_POS*/ | IS_MAP_POS;
  public static var CHANGE_SELECT = 17 | IS_MAP_POS /*| CHECK_POS*/
    | DISPLAY_GUIDE | CLICK;
  public static var PLAN_SNIPER = 18 | IS_MAP_POS /*| CHECK_POS*/ | DISPLAY_GUIDE | CLICK;
  public static var PLAN_BARRICADE = 19 | IS_MAP_POS /*| CHECK_POS*/
    | DISPLAY_GUIDE | CLICK;
  public static var PLAN_DEPOT = 20 | IS_MAP_POS /*| CHECK_POS*/ | DISPLAY_GUIDE | CLICK;
  public static var PLAN_WORKSHOP = 21 | IS_MAP_POS /*| CHECK_POS*/
    | DISPLAY_GUIDE | CLICK;
  public static var ADD_AMMO = 22 | IS_MAP_POS /*| CHECK_POS*/;
  public static var CLOSE_TOWER = 23 | IS_MAP_POS /*| CHECK_POS*/;
  public static var CLICK_NEXT = 24 | DISPLAY_NEXT | DISPLAY_SCREEN | CLICK;

  static var sniperBuildClick = new Point(0, 0);
  static var barricadeBuildClick = new Point(0, 0);
  static var depotBuildClick = new Point(0, 0);
  static var workshopBuildClick = new Point(0, 0);
  static var shootClick = new Point(0, 0);
  static var barricadeDestroyClick = new Point(0, 0);
  static var workshopIncreaseClick = new Point(0, 0);
  static var sideOffset = new Point(0, 0);
  static var timerOffset = new Point(0, 0);

  static var borderThickness = 2;

  static var clickTowerText = [Text.clickBarricade, Text.clickSniper,
                               Text.clickDepot, Text.clickWorkshop];
}
