// This is the menu at the bottom of the screen which provides several
// quick options.
package ui.menu;

class Quick
{
  static var SYSTEM = 0;
  static var HELP = 1;
  static var RANGE_OFF = 2;
  static var RANGE_ON = 3;

  public function new(parent : flash.display.DisplayObjectContainer,
                      l : ui.LayoutGame)
  {
    clip = new QuickClip();
    parent.addChild(clip);
    clip.visible = true;
    clip.mouseEnabled = false;
    clip.rangeOn.visible = false;
    if (Game.settings.isEditor())
    {
      clip.rangeOff.visible = false;
      clip.rangeOn.visible = false;
    }
    buttonList = new ui.ButtonList(click, hover,
                                   [clip.system, clip.help, clip.rangeOff,
                                    clip.rangeOn]);
    clip.addEventListener(flash.events.MouseEvent.ROLL_OVER, rollOver);
    resize(l);
  }

  public function cleanup() : Void
  {
    clip.removeEventListener(flash.events.MouseEvent.ROLL_OVER, rollOver);
    buttonList.cleanup();
    clip.parent.removeChild(clip);
    clip = null;
  }

  public function resize(l : ui.LayoutGame)
  {
    clip.x = l.quickOffset.x;
    clip.y = l.quickOffset.y;
  }

  public function hotkey(ch : String, code : Int) : Bool
  {
    var used = true;
    if (ch == '/' || ch == '?')
    {
      click(HELP);
    }
    else if (ch == ' ')
    {
      Game.pause.toggle();
    }
    else if (ch == 'v')
    {
      click(RANGE_ON);
    }
    else
    {
      used = false;
    }
    return used;
  }

  function rollOver(event : flash.events.MouseEvent) : Void
  {
    Game.view.toolTip.hide();
  }

  function click(select : Int) : Void
  {
    ui.Util.success();
    if (select == SYSTEM)
    {
      Game.view.centerMenu.changeState(CenterMenu.SYSTEM);
    }
    else if (select == HELP)
    {
      Game.view.centerMenu.changeState(CenterMenu.PEDIA);
    }
    else if (select == RANGE_ON || select == RANGE_OFF)
    {
      Game.view.window.toggleRanges();
    }
  }

  function hover(select : Int) : String
  {
    var result = null;
    if (select == SYSTEM)
    {
      result = ui.Text.systemTip;
    }
    else if (select == HELP)
    {
      result = ui.Text.pediaTip;
    }
    else if (select == RANGE_ON || select == RANGE_OFF)
    {
      if (Game.view.window.isShowingRanges())
      {
        result = ui.Text.hideRangeTip;
      }
      else
      {
        result = ui.Text.showRangeTip;
      }
    }
    return result;
  }

  public function updateView(isShowing : Bool) : Void
  {
    if (isShowing)
    {
      clip.rangeOn.visible = true;
      clip.rangeOff.visible = false;
    }
    else
    {
      clip.rangeOn.visible = false;
      clip.rangeOff.visible = true;
    }
  }

  private function centerOn(x : Int, y : Int) : Void
  {
    var l = Game.view.layout;
    Game.view.window.moveWindow(x - l.windowCenter.x, y - l.windowCenter.y);
  }

  private function findDepot(start : Point) : Point
  {
    var pos = start.clone();
    if (hasDepot(pos))
    {
      return pos;
    }
    var size = Math.floor(Math.max(Game.map.sizeX(), Game.map.sizeY()));
    for (i in 1...size)
    {
      for (j in (-i)...(i))
      {
        pos.y = start.y + j;
        pos.x = start.x - i;
        if (hasDepot(pos))
        {
          return pos;
        }
        pos.x = start.x + i;
        if (hasDepot(pos))
        {
          return pos;
        }

        pos.x = start.x + j;
        pos.y = start.y - i;
        if (hasDepot(pos))
        {
          return pos;
        }

        pos.y = start.y + i;
        if (hasDepot(pos))
        {
          return pos;
        }
      }
    }
    return null;
  }

  private function hasDepot(pos : Point) : Bool
  {
    var result = false;
    if (! Lib.outsideMap(pos))
    {
      var tower = Game.map.getCell(pos.x, pos.y).getTower();
      if (tower != null && tower.getType() == Tower.DEPOT)
      {
        result = true;
      }
    }
    return result;
  }

  var clip : QuickClip;
  var buttonList : ui.ButtonList;
}
