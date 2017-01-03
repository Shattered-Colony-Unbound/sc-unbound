package logic;

class ScriptState
{
  public static var NO_BUTTON = -1;
  public static var TIMER = 0;
  public static var MINIMAP = 1;
  public static var SYSTEM = 2;
  public static var PEDIA = 3;
  public static var RANGE = 4;
  public static var BUILD_SNIPER = 5;
  public static var BUILD_BARRICADE = 6;
  public static var BUILD_WORKSHOP = 7;
  public static var BUILD_DEPOT = 8;
  public static var DEPOT_FLEE = 9;
  public static var DEPOT_RESOURCE = 10;
  public static var BARRICADE_INCREASE = 11;
  public static var BARRICADE_DECREASE = 12;
  public static var WORKSHOP_INCREASE = 13;
  public static var WORKSHOP_DECREASE = 14;
  public static var WORKSHOP_FLEE = 15;
  public static var WORKSHOP_EXTRACT = 16;
  public static var SNIPER_SHOOT = 17;
  public static var SNIPER_HOLD_FIRE = 18;
  public static var SNIPER_UPGRADE = 19;
  public static var SNIPER_FLEE = 20;
  public static var SNIPER_RESOURCE = 21;
  public static var SNIPER_INCREASE_AMMO = 22;
  public static var SNIPER_INCREASE_SURVIVORS = 23;
  public static var SNIPER_DECREASE_AMMO = 24;
  public static var SNIPER_DECREASE_SURVIVORS = 25;
  public static var DEPOT_INCREASE_AMMO = 26;
  public static var DEPOT_DECREASE_AMMO = 27;
  public static var DEPOT_INCREASE_BOARDS = 28;
  public static var DEPOT_DECREASE_BOARDS = 29;
  public static var DEPOT_INCREASE_SURVIVORS = 30;
  public static var DEPOT_DECREASE_SURVIVORS = 31;
  public static var TOTAL_RESOURCES = 32;

  public function new(newName : String, newText : String, newMapPos : Point,
                      newButtonPos : Int, newHasNext : Bool) : Void
  {
    name = newName;
    text = newText;
    mapPos = newMapPos;
    buttonPos = newButtonPos;
    hasNext = newHasNext;
    edges = new Array<ScriptEdge>();
    actions = new Array<ScriptAction>();
  }

  // Returns true if all edges check out ok.
  public function checkEdges(states : haxe.ds.StringMap<ScriptState>) : Bool
  {
    var result = true;
    for (edge in edges)
    {
      var next = edge.getNext();
      if (next != "")
      {
        var nextState = states.get(next);
        if (nextState == null)
        {
          result = false;
          break;
        }
      }
    }
    return result;
  }

  public function getName() : String
  {
    return name;
  }

  public function getText() : String
  {
    return text;
  }

  public function getPos() : Point
  {
    var result = null;
    if (isMapPos())
    {
      result = mapPos;
    }
    else if (buttonPos != NO_BUTTON)
    {
      result = new Point(0, 0);
      var l = Game.view.layout;
      if (buttonPos == TIMER)
      {
        result.x = l.countDownOffset.x + Math.floor(l.countDownSize.x/2);
        result.y = l.countDownOffset.y + l.countDownSize.y - 30;
      }
      else if (buttonPos == MINIMAP)
      {
        result.x = l.miniOffset.x + Math.floor(l.miniSize.x/2);
        result.y = l.miniOffset.y + l.miniSize.y;
      }
      else if (buttonPos == SYSTEM)
      {
        result.x = l.quickOffset.x + 30;
        result.y = l.quickOffset.y - 30 - 20;
      }
      else if (buttonPos == PEDIA)
      {
        result.x = l.quickOffset.x + 80;
        result.y = l.quickOffset.y - 30 - 20;
      }
      else if (buttonPos == RANGE)
      {
        result.x = l.quickOffset.x + 130;
        result.y = l.quickOffset.y - 30 - 20;
      }
      else if (buttonPos == BUILD_SNIPER)
      {
        result.x = l.buildMenuOffset.x + 43;
        result.y = l.buildMenuOffset.y - 106 - 20;
      }
      else if (buttonPos == BUILD_BARRICADE)
      {
        result.x = l.buildMenuOffset.x + 103;
        result.y = l.buildMenuOffset.y - 106 - 20;
      }
      else if (buttonPos == BUILD_WORKSHOP)
      {
        result.x = l.buildMenuOffset.x + 43;
        result.y = l.buildMenuOffset.y - 61 - 20;
      }
      else if (buttonPos == BUILD_DEPOT)
      {
        result.x = l.buildMenuOffset.x + 103;
        result.y = l.buildMenuOffset.y - 61 - 20;
      }
      else if (buttonPos == DEPOT_FLEE)
      {
        result.x = l.sideMenuOffset.x + 370 - 15;
        result.y = l.sideMenuOffset.y + 520 - 15;
      }
      else if (buttonPos == DEPOT_RESOURCE)
      {
        result.x = l.sideMenuOffset.x + 30 + 150;
        result.y = l.sideMenuOffset.y + 525;
      }
      else if (buttonPos == BARRICADE_INCREASE)
      {
        result.x = l.sideMenuOffset.x + 385 - 8;
        result.y = l.sideMenuOffset.y + 538;
      }
      else if (buttonPos == BARRICADE_DECREASE)
      {
        result.x = l.sideMenuOffset.x + 385 - 8;
        result.y = l.sideMenuOffset.y + 558;
      }
      else if (buttonPos == WORKSHOP_INCREASE)
      {
        result.x = l.sideMenuOffset.x + 375 - 8;
        result.y = l.sideMenuOffset.y + 510;
      }
      else if (buttonPos == WORKSHOP_DECREASE)
      {
        result.x = l.sideMenuOffset.x + 375 - 8;
        result.y = l.sideMenuOffset.y + 530;
      }
      else if (buttonPos == WORKSHOP_FLEE)
      {
        result.x = l.sideMenuOffset.x + 368 - 15;
        result.y = l.sideMenuOffset.y + 568 - 15;
      }
      else if (buttonPos == WORKSHOP_EXTRACT)
      {
        result.x = l.sideMenuOffset.x + 183 + 30;
        result.y = l.sideMenuOffset.y + 515 - 15;
      }
      else if (buttonPos == SNIPER_SHOOT)
      {
        result.x = l.sideMenuOffset.x + 320 - 15;
        result.y = l.sideMenuOffset.y + 463 - 15;
      }
      else if (buttonPos == SNIPER_HOLD_FIRE)
      {
        result.x = l.sideMenuOffset.x + 365 - 15;
        result.y = l.sideMenuOffset.y + 463 - 15;
      }
      else if (buttonPos == SNIPER_UPGRADE)
      {
        result.x = l.sideMenuOffset.x + 365 - 15;
        result.y = l.sideMenuOffset.y + 508 - 15;
      }
      else if (buttonPos == SNIPER_FLEE)
      {
        result.x = l.sideMenuOffset.x + 365 - 15;
        result.y = l.sideMenuOffset.y + 568 - 15;
      }
      else if (buttonPos == SNIPER_RESOURCE)
      {
        result.x = l.sideMenuOffset.x + 12 + 220;
        result.y = l.sideMenuOffset.y + 525 - 10;
      }
      else if (buttonPos == SNIPER_INCREASE_AMMO)
      {
        result.x = l.sideMenuOffset.x + 12 + 159 - 8;
        result.y = l.sideMenuOffset.y + 525 + 45 - 8;
      }
      else if (buttonPos == SNIPER_INCREASE_SURVIVORS)
      {
        result.x = l.sideMenuOffset.x + 12 + 219 - 8;
        result.y = l.sideMenuOffset.y + 525 + 45 - 8;
      }
      else if (buttonPos == SNIPER_DECREASE_AMMO)
      {
        result.x = l.sideMenuOffset.x + 12 + 159 - 8;
        result.y = l.sideMenuOffset.y + 525 + 65 - 8;
      }
      else if (buttonPos == SNIPER_DECREASE_SURVIVORS)
      {
        result.x = l.sideMenuOffset.x + 12 + 219 - 8;
        result.y = l.sideMenuOffset.y + 525 + 65 - 8;
      }
      else if (buttonPos == DEPOT_INCREASE_AMMO)
      {
        result.x = l.sideMenuOffset.x + 30 + 104 - 8;
        result.y = l.sideMenuOffset.y + 525 + 45 - 8;
      }
      else if (buttonPos == DEPOT_DECREASE_AMMO)
      {
        result.x = l.sideMenuOffset.x + 30 + 104 - 8;
        result.y = l.sideMenuOffset.y + 525 + 65 - 8;
      }
      else if (buttonPos == DEPOT_INCREASE_BOARDS)
      {
        result.x = l.sideMenuOffset.x + 30 + 159 - 8;
        result.y = l.sideMenuOffset.y + 525 + 45 - 8;
      }
      else if (buttonPos == DEPOT_DECREASE_BOARDS)
      {
        result.x = l.sideMenuOffset.x + 30 + 159 - 8;
        result.y = l.sideMenuOffset.y + 525 + 65 - 8;
      }
      else if (buttonPos == DEPOT_INCREASE_SURVIVORS)
      {
        result.x = l.sideMenuOffset.x + 30 + 219 - 8;
        result.y = l.sideMenuOffset.y + 525 + 45 - 8;
      }
      else if (buttonPos == DEPOT_DECREASE_SURVIVORS)
      {
        result.x = l.sideMenuOffset.x + 30 + 219 - 8;
        result.y = l.sideMenuOffset.y + 525 + 65 - 8;
      }
      else if (buttonPos == TOTAL_RESOURCES)
      {
        result.x = l.totalResourceOffset.x;
        result.y = l.totalResourceOffset.y + 40;
      }
    }
    return result;
  }

  public function shouldShowText() : Bool
  {
    return text != null;
  }

  public function shouldShowNext() : Bool
  {
    return hasNext;
  }

  public function shouldShowArrow() : Bool
  {
    return mapPos != null || buttonPos != NO_BUTTON;
  }

  public function isMapPos() : Bool
  {
    return buttonPos == NO_BUTTON;
  }

  public function addEdge(newEdge : ScriptEdge) : Void
  {
    edges.push(newEdge);
  }

  public function addAction(newAction : ScriptAction) : Void
  {
    actions.push(newAction);
  }

  public function trigger(type : Int, pos : Point) : String
  {
    var result = null;
    for (edge in edges)
    {
      result = edge.trigger(type, pos);
      if (result != null)
      {
        break;
      }
    }
    return result;
  }

  public function takeAction() : Void
  {
    for (current in actions)
    {
      Game.actions.push(current);
    }
  }

  var name : String;
  var text : String;
  var mapPos : Point;
  var buttonPos : Int;
  var hasNext : Bool;
  var edges : Array<ScriptEdge>;
  var actions : Array<ScriptAction>;
}
