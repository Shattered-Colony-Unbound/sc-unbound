class Replay
{
  public function new() : Void
  {
    pos = null;
    currentLines = new List<ReplayStep>();
    frame = 0;

    lineClip = null;
    boxClip = null;
    actions = new List<ReplayStep>();
    menuState = ui.menu.MainMenu.START;
    settings = null;
    speed = 1;

    menu = null;
    buttons = null;
  }

  public function cleanup() : Void
  {
    if (boxClip != null)
    {
      Main.getRoot().removeEventListener(flash.events.Event.ENTER_FRAME,
                                         onEnterFrame);
      buttons.cleanup();
      menu.parent.removeChild(menu);
      menu = null;
      lineClip.parent.removeChild(lineClip);
      lineClip = null;
      boxClip.parent.removeChild(boxClip);
      boxClip = null;
    }
  }

  public function resize(l : ui.LayoutMain) : Void
  {
    if (lineClip != null && boxClip != null)
    {
      var min = Math.min(l.screenSize.x, l.screenSize.y);
      var scale = Math.min(l.screenSize.x / settings.getSize().x,
                           l.screenSize.y / settings.getSize().y);
      resizeClip(lineClip, min, l.screenSize.x, scale);
      resizeClip(boxClip, min, l.screenSize.x, scale);
    }
  }

  function resizeClip(clip : flash.display.DisplayObject, min : Float,
                      sizeX : Int, scale : Float) : Void
  {
    clip.scaleX = scale;
    clip.scaleY = scale;
    clip.x = sizeX - min;
  }

  public function setState(newState : Int) : Void
  {
    menuState = newState;
  }

  public function start(l : ui.LayoutMain,
                        newSettings : logic.GameSettings) : Void
  {
    settings = newSettings;
    boxClip = new flash.display.Shape();
    Main.getRoot().addChild(boxClip);
    boxClip.visible = true;
//    boxClip.graphics.beginFill(0xffffff);
//    boxClip.graphics.drawRect(0, 0, size.x, size.y);
//    boxClip.graphics.endFill();

    lineClip = new flash.display.Shape();
    Main.getRoot().addChild(lineClip);
    lineClip.visible = true;
    lineClip.graphics.lineStyle(Option.supplyThickness, Option.supplyColor);

    menu = new ui.menu.ReplayMenuClip();
    Main.getRoot().addChild(menu);
    menu.mouseEnabled = false;
    buttons = new ui.ButtonList(click, null,
                                [menu.slow, menu.fast, menu.back]);

    resize(l);
    Main.getRoot().addEventListener(flash.events.Event.ENTER_FRAME,
                                    onEnterFrame);
    pos = actions.iterator();
    currentLines.clear();
    frame = 0;
    menu.speed.barText.text = ui.Text.replaySpeedBarLabel;
    setSpeed(startSpeed);
  }

  public function addBox(lower : Point, upper : Point, color : Int)
  {
    actions.add(new ReplayStep(lower, upper, color, ADD_BOX));
  }

  public function addLine(lower : Point, upper : Point)
  {
    actions.add(new ReplayStep(lower, upper, 0, ADD_LINE));
  }

  public function addBeginPlay()
  {
    actions.add(new ReplayStep(null, null, 0, ADD_BEGIN_PLAY));
  }

  public function removeLine(lower : Point, upper : Point)
  {
    actions.add(new ReplayStep(lower, upper, 0, REMOVE_LINE));
  }

  function click(choice : Int) : Void
  {
    if (choice == 0)
    {
      setSpeed(speed - 1);
    }
    else if (choice == 1)
    {
      setSpeed(speed + 1);
    }
    else if (choice == 2)
    {
      ui.Util.success();
      Main.endReplay(menuState, settings);
    }
  }

  function setSpeed(newSpeed : Int) : Void
  {
    if (newSpeed >= 0 && newSpeed < speedAdd.length)
    {
      speed = newSpeed;
      var proportion = speed / (speedAdd.length - 1);
      menu.speed.bar.width = proportion * Option.statusBarSize;
      ui.Util.success();
    }
    else
    {
      ui.Util.failure();
    }
    if (speed > 0)
    {
      buttons.setNormal(menu.slow);
    }
    else
    {
      buttons.setGhosted(menu.slow);
    }
    if (speed < speedAdd.length - 1)
    {
      buttons.setNormal(menu.fast);
    }
    else
    {
      buttons.setGhosted(menu.fast);
    }
  }

  function onEnterFrame(event : flash.events.Event) : Void
  {
    frame += speedAdd[speed];
    while (pos.hasNext() && frame >= speedSub)
    {
      frame -= speedSub;
      var current = pos.next();
      if (current.type == ADD_BOX)
      {
        boxClip.graphics.beginFill(current.color);
        var sizeX = current.upper.x - current.lower.x;
        var sizeY = current.upper.y - current.lower.y;
        boxClip.graphics.drawRect(current.lower.x, current.lower.y,
                                  sizeX, sizeY);
        boxClip.graphics.endFill();
      }
      else if (current.type == ADD_LINE)
      {
        drawLine(current);
        currentLines.add(current);
      }
      else if (current.type == REMOVE_LINE)
      {
        var old = findLine(current);
        if (old != null)
        {
          currentLines.remove(old);
          lineClip.graphics.clear();
          lineClip.graphics.lineStyle(Option.supplyThickness,
                                      Option.supplyColor);
          for (line in currentLines)
          {
            drawLine(line);
          }
        }
      }
/*
      else if (current.type == ADD_BEGIN_PLAY)
      {
        speed = Option.replayPlaySpeed;
        frame = 1;
      }
*/
    }
  }

  function drawLine(current : ReplayStep) : Void
  {
    lineClip.graphics.moveTo(current.lower.x + 0.5,
                             current.lower.y + 0.5);
    lineClip.graphics.lineTo(current.upper.x + 0.5,
                             current.upper.y + 0.5);
  }

  function findLine(key : ReplayStep) : ReplayStep
  {
    var result = null;
    for (candidate in currentLines)
    {
      if (Point.isEqual(key.lower, candidate.lower)
          && Point.isEqual(key.upper, candidate.upper))
      {
        result = candidate;
        break;
      }
    }
    return result;
  }

  public function save() : Dynamic
  {
    return Save.saveList(actions, ReplayStep.saveS);
  }

  public function load(input : Dynamic) : Void
  {
    actions = Load.loadList(input,
                            ReplayStep.load);
  }

  var pos : Iterator<ReplayStep>;
  var currentLines : List<ReplayStep>;
  var frame : Int;

  var lineClip : flash.display.Shape;
  var boxClip : flash.display.Shape;
  var actions : List<ReplayStep>;

  var menu : ui.menu.ReplayMenuClip;
  var buttons : ui.ButtonList;

  // Information to keep the menu consistent between replays
  var menuState : Int;
  var settings : logic.GameSettings;

  var speed : Int;

  static var speedAdd = [0, 1, 2, 4, 8, 16];
  static var speedSub = 8;

  static var startSpeed = 2;

  static var ADD_BOX = 0;
  static var ADD_LINE = 1;
  static var REMOVE_LINE = 2;
  static var ADD_BEGIN_PLAY = 3;
}
