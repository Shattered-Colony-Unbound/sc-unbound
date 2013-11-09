package ui.menu;

class ScrollMenu
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      size : Point) : Void
  {
    arrows = [];
    for (dir in Lib.directions)
    {
      var newArrow = new ui.ScrollArrowClip();
      parent.addChild(newArrow);
      newArrow.rotation = Lib.directionToAngle(dir);
      newArrow.gotoAndStop(1);
      newArrow.addEventListener(flash.events.MouseEvent.ROLL_OVER, rollOver);
      newArrow.addEventListener(flash.events.MouseEvent.ROLL_OUT, rollOut);
      arrows.push(newArrow);
      if (! Game.settings.isEditor())
      {
        newArrow.visible = false;
      }
    }
    hoverDir = null;
    resize(size);
  }

  public function resize(size : Point) : Void
  {
    arrows[0].x = size.x / 2;
    arrows[0].y = 50;
    arrows[1].x = size.x / 2;
    arrows[1].y = size.y;
    arrows[2].x = size.x;
    arrows[2].y = size.y / 2;
    arrows[3].x = 0;
    arrows[3].y = size.y / 2;
  }

  public function cleanup() : Void
  {
    for (arrow in arrows)
    {
      arrow.removeEventListener(flash.events.MouseEvent.ROLL_OVER, rollOver);
      arrow.removeEventListener(flash.events.MouseEvent.ROLL_OUT, rollOut);
      arrow.parent.removeChild(arrow);
    }
  }

  public function hotkey(ch : String, code : Int) : Bool
  {
    var used = true;

    var dir = Direction.NORTH;
    var window = Game.view.window;
    if (code == 38 || code == 104)
    {
      dir = Direction.NORTH;
      window.scrollWindow(dir, 1);
//      mouseScroller.mouseClear();
    }
    else if (code == 40 || code == 98)
    {
      dir = Direction.SOUTH;
      window.scrollWindow(dir, 1);
//      mouseScroller.mouseClear();
    }
    else if (code == 39 || code == 102)
    {
      dir = Direction.EAST;
      window.scrollWindow(dir, 1);
//      mouseScroller.mouseClear();
    }
    else if (code == 37 || code == 100)
    {
      dir = Direction.WEST;
      window.scrollWindow(dir, 1);
//      mouseScroller.mouseClear();
    }
    else
    {
      used = false;
    }

    return used;
  }

  public function enterFrame() : Void
  {
    if (hoverDir != null)
    {
      Game.view.window.scrollWindow(hoverDir, 1);
    }
  }

  function rollOver(event : flash.events.MouseEvent) : Void
  {
    hoverDir = null;
    var index = 0;
    var found = false;
    for (arrow in arrows)
    {
      if (arrow == event.target)
      {
        arrow.gotoAndStop(2);
        found = true;
        break;
      }
      ++index;
    }
    if (found)
    {
      hoverDir = Lib.indexToDirection(index);
    }
  }

  function rollOut(event : flash.events.MouseEvent) : Void
  {
    if (hoverDir != null)
    {
      var index = Lib.directionToIndex(hoverDir);
      arrows[index].gotoAndStop(1);
      hoverDir = null;
    }
  }

  var arrows : Array<flash.display.MovieClip>;
  var hoverDir : Direction;
}
