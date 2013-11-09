// This is the class which manages the side bar which contains info on
// the currently selected tower and provides menu options.
package ui.menu;

class SideBar
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      l : ui.LayoutGame) : Void
  {
    state = NONE;
    sideBars = [];
    sideBars.push(new SideBarricade(parent, l));
    sideBars.push(new SideSniper(parent, l));
    sideBars.push(new SideDepot(parent, l));
    sideBars.push(new SideWorkshop(parent, l));
    sideBars.push(new SidePlan(parent, l));
    sideBars.push(new SideRoot(null));
    useHover = true;
  }

  public function cleanup() : Void
  {
    for (menu in sideBars)
    {
      menu.cleanup();
    }
    sideBars = null;
  }

  public function resize(l : ui.LayoutGame) : Void
  {
    for (menu in sideBars)
    {
      menu.resize(l);
    }
  }

  public function hotkey(ch : String, code : Int) : Bool
  {
    return sideBars[state].hotkey(ch, code);
  }

  public function clickTower(dest : Point) : Void
  {
    changeState(sideBars[state].tower(dest));
  }

  public function hoverTower(dest : Point) : Void
  {
    if (useHover)
    {
      sideBars[state].hoverTower(dest);
    }
  }

  public function clickBackground(dest : Point) : Void
  {
    changeState(sideBars[state].background(dest));
  }

  public function hoverBackground(dest : Point) : Void
  {
    if (useHover)
    {
      sideBars[state].hoverBackground(dest);
    }
  }

  public function enterFrame() : Void
  {
    for (i in 0...(sideBars.length))
    {
      if (i == state)
      {
        sideBars[i].stepShow();
      }
      else
      {
        sideBars[i].stepHide();
      }
    }
  }

  public function show() : Void
  {
    sideBars[state].show();
  }

  public function changeSelect() : Void
  {
    var newState = NONE;
    var select = Game.select.getSelected();
    if (select != null)
    {
      var cell = Game.map.getCell(select.x, select.y);
      if (cell.hasTower())
      {
        newState = cell.getTower().getType();
      }
      else if (cell.hasShadow())
      {
        newState = PLAN;
      }
    }
    changeState(newState);
  }

  function changeState(newState : Int)
  {
    if (newState != state)
    {
      sideBars[state].hide();
      sideBars[newState].show();
      state = newState;
    }
  }

  public function enableHover() : Void
  {
    useHover = true;
  }

  public function disableHover() : Void
  {
    useHover = false;
  }

  var state : Int;
  var sideBars : Array<SideRoot>;
  var useHover : Bool;

  public static var BARRICADE = 0;//Tower.BARRICADE;
  public static var SNIPER = 1;//Tower.SNIPER;
  public static var DEPOT = 2;//Tower.DEPOT;
  public static var WORKSHOP = 3;//Tower.WORKSHOP;
  public static var PLAN = 4;
  public static var NONE = 5;
}
