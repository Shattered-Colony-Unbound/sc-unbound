package logic;

class Script
{
  public static var MOVE_WINDOW = 0;

  public static var SELECT_SNIPER = 1;
  public static var SELECT_BARRICADE = 2;
  public static var SELECT_DEPOT = 3;
  public static var SELECT_WORKSHOP = 4;
  public static var SELECT_NOTHING = 5;

  public static var START_BUILD_SNIPER = 10;
  public static var START_BUILD_BARRICADE = 11;
  public static var START_BUILD_DEPOT = 12;
  public static var START_BUILD_WORKSHOP = 13;
  public static var CANCEL_BUILD = 14;

  public static var BUILD_SNIPER = 20;
  public static var BUILD_BARRICADE = 21;
  public static var BUILD_DEPOT = 22;
  public static var BUILD_WORKSHOP = 23;
  public static var DESTROY_SNIPER = 24;
  public static var DESTROY_BARRICADE = 25;
  public static var DESTROY_DEPOT = 26;
  public static var DESTROY_WORKSHOP = 27;

  public static var CREATE_TRADE_SOURCE = 30;
  public static var CREATE_TRADE_DEST = 31;
  public static var ZOMBIE_HORDE_BEGIN = 32;
  public static var ZOMBIE_HORDE_END = 33;
  public static var ZOMBIE_CLEAR = 34;
  public static var BRIDGE_CLEAR = 35;
  public static var COUNTDOWN_COMPLETE = 36;

  public static var CLICK_ADD_AMMO = 40;
  public static var CLICK_REMOVE_AMMO = 41;
  public static var CLICK_ADD_BOARDS = 42;
  public static var CLICK_REMOVE_BOARDS = 43;
  public static var CLICK_ADD_SURVIVORS = 44;
  public static var CLICK_REMOVE_SURVIVORS = 45;
  public static var CLICK_SHOOT = 46;
  public static var CLICK_HOLD_FIRE = 47;
  public static var CLICK_UPGRADE = 48;
  public static var CLICK_FLEE = 49;

  public static var CLICK_NEXT = 60;
  public static var CLICK_SKIP = 61;

  public function new(newSprite : ui.ScriptView) : Void
  {
    sprite = newSprite;
    states = new haxe.ds.StringMap<ScriptState>();
    current = new Array<ScriptState>();
    sprite.setButtons(clickNext, clickSkip);
    sprite.update(current);
  }

  public function addState(newState : ScriptState) : Void
  {
    states.set(newState.getName(), newState);
    if (newState.getName() == "start")
    {
      current.push(newState);
      sprite.update(current);
    }
  }

  // Returns true if all states check out ok.
  public function checkStates() : Bool
  {
    var result = true;
    for (state in states)
    {
      result = state.checkEdges(states);
      if (!result)
      {
        break;
      }
    }
    return result;
  }

  public function trigger(type : Int, ? pos : Point) : Void
  {
    var i = 0;
    while (i < current.length)
    {
      var nextString = current[i].trigger(type, pos);
      if (nextString == null)
      {
        ++i;
      }
      else
      {
        var next = states.get(nextString);
        if (next != null)
        {
          current[i] = next;
          current[i].takeAction();
          ++i;
        }
        else
        {
          current.splice(i, 1);
        }
      }
    }
    if (type == MOVE_WINDOW)
    {
      sprite.redraw();
    }
    else
    {
      sprite.update(current);
    }
  }

  public function addCurrentState(name : String) : Void
  {
    var newState = states.get(name);
    if (newState != null)
    {
      current.push(newState);
      newState.takeAction();
    }
  }

  public function takeAction() : Void
  {
    for (state in current)
    {
      state.takeAction();
    }
  }

  function clickNext() : Void
  {
    trigger(CLICK_NEXT);
  }

  function clickSkip() : Void
  {
    trigger(CLICK_SKIP);
  }

  public function save() : Dynamic
  {
    return { current : Save.saveArray(current, saveState) };
  }

  public static function saveState(state : ScriptState) : String
  {
    return state.getName();
  }

  public function load(input : Dynamic) : Void
  {
    current = Load.loadArray(input.current, loadState);
  }

  function loadState(input : Dynamic) : ScriptState
  {
    var name = Std.string(input);
    return states.get(name);
  }

  var sprite : ui.ScriptView;
  var states : haxe.ds.StringMap<ScriptState>;
  var current : Array<ScriptState>;
}
