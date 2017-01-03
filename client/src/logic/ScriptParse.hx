package logic;

class ScriptParse
{
  public function new() : Void
  {
  }

  static var stringToTransition = new haxe.ds.StringMap<Int>();
  static var stringToAction = new haxe.ds.StringMap<Int>();
  static var stringToButton = new haxe.ds.StringMap<Int>();

  public static function init() : Void
  {
    var t = stringToTransition;
    t.set("move-window", Script.MOVE_WINDOW);

    t.set("select-sniper", Script.SELECT_SNIPER);
    t.set("select-barricade", Script.SELECT_BARRICADE);
    t.set("select-depot", Script.SELECT_DEPOT);
    t.set("select-workshop", Script.SELECT_WORKSHOP);
    t.set("select-nothing", Script.SELECT_NOTHING);

    t.set("start-build-sniper", Script.START_BUILD_SNIPER);
    t.set("start-build-barricade", Script.START_BUILD_BARRICADE);
    t.set("start-build-depot", Script.START_BUILD_DEPOT);
    t.set("start-build-workshop", Script.START_BUILD_WORKSHOP);
    t.set("cancel-build", Script.CANCEL_BUILD);

    t.set("build-sniper", Script.BUILD_SNIPER);
    t.set("build-barricade", Script.BUILD_BARRICADE);
    t.set("build-depot", Script.BUILD_DEPOT);
    t.set("build-workshop", Script.BUILD_WORKSHOP);
    t.set("destroy-sniper", Script.DESTROY_SNIPER);
    t.set("destroy-barricade", Script.DESTROY_BARRICADE);
    t.set("destroy-depot", Script.DESTROY_DEPOT);
    t.set("destroy-workshop", Script.DESTROY_WORKSHOP);

    t.set("create-trade-source", Script.CREATE_TRADE_SOURCE);
    t.set("create-trade-dest", Script.CREATE_TRADE_DEST);
    t.set("zombie-horde-begin", Script.ZOMBIE_HORDE_BEGIN);
    t.set("zombie-horde-end", Script.ZOMBIE_HORDE_END);
    t.set("zombie-clear", Script.ZOMBIE_CLEAR);
    t.set("bridge-clear", Script.BRIDGE_CLEAR);
    t.set("countdown-complete", Script.COUNTDOWN_COMPLETE);

    t.set("click-add-ammo", Script.CLICK_ADD_AMMO);
    t.set("click-remove-ammo", Script.CLICK_REMOVE_AMMO);
    t.set("click-add-boards", Script.CLICK_ADD_BOARDS);
    t.set("click-remove-boards", Script.CLICK_REMOVE_BOARDS);
    t.set("click-add-survivors", Script.CLICK_ADD_SURVIVORS);
    t.set("click-remove-survivors", Script.CLICK_REMOVE_SURVIVORS);
    t.set("click-shoot", Script.CLICK_SHOOT);
    t.set("click-hold-fire", Script.CLICK_HOLD_FIRE);
    t.set("click-upgrade", Script.CLICK_UPGRADE);
    t.set("click-flee", Script.CLICK_FLEE);

    t.set("click-next", Script.CLICK_NEXT);
    t.set("click-skip", Script.CLICK_SKIP);

    var a = stringToAction;
    a.set("win", ScriptAction.WIN);
    a.set("lose", ScriptAction.LOSE);
    a.set("countdown", ScriptAction.COUNTDOWN);
    a.set("horde", ScriptAction.HORDE);
    a.set("move-map", ScriptAction.MOVE_MAP);
    a.set("add-state", ScriptAction.ADD_STATE);

    var b = stringToButton;
    b.set("timer", ScriptState.TIMER);
    b.set("minimap", ScriptState.MINIMAP);
    b.set("system", ScriptState.SYSTEM);
    b.set("zombipedia", ScriptState.PEDIA);
    b.set("range", ScriptState.RANGE);
    b.set("build-sniper", ScriptState.BUILD_SNIPER);
    b.set("build-barricade", ScriptState.BUILD_BARRICADE);
    b.set("build-workshop", ScriptState.BUILD_WORKSHOP);
    b.set("build-depot", ScriptState.BUILD_DEPOT);
    b.set("depot-flee", ScriptState.DEPOT_FLEE);
    b.set("depot-resource", ScriptState.DEPOT_RESOURCE);
    b.set("barricade-increase", ScriptState.BARRICADE_INCREASE);
    b.set("barricade-decrease", ScriptState.BARRICADE_DECREASE);
    b.set("workshop-increase", ScriptState.WORKSHOP_INCREASE);
    b.set("workshop-decrease", ScriptState.WORKSHOP_DECREASE);
    b.set("workshop-flee", ScriptState.WORKSHOP_FLEE);
    b.set("workshop-extract", ScriptState.WORKSHOP_EXTRACT);
    b.set("sniper-shoot", ScriptState.SNIPER_SHOOT);
    b.set("sniper-hold-fire", ScriptState.SNIPER_HOLD_FIRE);
    b.set("sniper-upgrade", ScriptState.SNIPER_UPGRADE);
    b.set("sniper-flee", ScriptState.SNIPER_FLEE);
    b.set("sniper-resource", ScriptState.SNIPER_RESOURCE);
    b.set("sniper-increase-ammo", ScriptState.SNIPER_INCREASE_AMMO);
    b.set("sniper-increase-survivors", ScriptState.SNIPER_INCREASE_SURVIVORS);
    b.set("sniper-decrease-ammo", ScriptState.SNIPER_DECREASE_AMMO);
    b.set("sniper-decrease-survivors", ScriptState.SNIPER_DECREASE_SURVIVORS);
    b.set("depot-increase-ammo", ScriptState.DEPOT_INCREASE_AMMO);
    b.set("depot-decrease-ammo", ScriptState.DEPOT_DECREASE_AMMO);
    b.set("depot-increase-boards", ScriptState.DEPOT_INCREASE_BOARDS);
    b.set("depot-decrease-boards", ScriptState.DEPOT_DECREASE_BOARDS);
    b.set("depot-increase-survivors", ScriptState.DEPOT_INCREASE_SURVIVORS);
    b.set("depot-decrease-survivors", ScriptState.DEPOT_DECREASE_SURVIVORS);
    b.set("total-resources", ScriptState.TOTAL_RESOURCES);
  }

  public static function parse(scriptText : String, script : Script) : Void
  {
    var text = scriptText;
    if (Game.settings.isEditor())
    {
      text = editScript;
    }
    if (text == null)
    {
      text = defaultScript;
    }
    var node = new flash.xml.XML(text);
    var states = node.child("state");
    for (i in 0...states.length())
    {
      var newState = parseState(states[i]);
      script.addState(newState);
    }
    var isOk = script.checkStates();
    if (! isOk)
    {
      Lib.trace("Failed sanity check");
    }
  }

  static function parseState(node : flash.xml.XML) : ScriptState
  {
    var current = node.attribute("name");
    var name = Std.string(current);

    current = node.elements("text");
    var text = null;
    if (current.length() > 0)
    {
      text = Std.string(current);
    }

    var pos = calculatePoint(node.attribute("posX"),
                             node.attribute("posY"));

    var isNext = false;
    current = node.child("next");
    if (current.length() > 0)
    {
      isNext = true;
    }

    var button = ScriptState.NO_BUTTON;
    current = node.attribute("button");
    if (current.length() > 0)
    {
      var buttonText = Std.string(current);
      if (stringToButton.exists(buttonText))
      {
        button = stringToButton.get(buttonText);
      }
    }

    var result = new ScriptState(name, text, pos, button, isNext);
    var edges = node.child("edge");
    for (i in 0...edges.length())
    {
      var newEdge = parseEdge(edges[i]);
      result.addEdge(newEdge);
    }
    var actions = node.child("action");
    for (i in 0...actions.length())
    {
      var newAction = parseAction(actions[i]);
      result.addAction(newAction);
    }
    return result;
  }

  static function parseEdge(node : flash.xml.XML) : ScriptEdge
  {
    var current = node.attribute("type");
    var type = stringToTransition.get(Std.string(current));

    var offset = calculatePoint(node.attribute("offsetX"),
                                node.attribute("offsetY"));
    var limit = calculatePoint(node.attribute("limitX"),
                               node.attribute("limitY"));
    if (offset != null && limit == null)
    {
      limit = new Point(offset.x + 1, offset.y + 1);
    }

    var area = null;
    if (offset != null)
    {
      area = new mapgen.Section(offset, limit);
    }

    current = node.attribute("next");
    var next = Std.string(current);
    var result = new ScriptEdge(type, area, next);
    return result;
  }

  static function parseAction(node : flash.xml.XML) : ScriptAction
  {
    var current = node.attribute("type");
    var type = stringToAction.get(Std.string(current));

    var arg = null;
    current = node.attribute("arg");
    if (current.length() > 0)
    {
      arg = Std.string(current);
    }
    else
    {
      current = node.elements("arg");
      if (current.length() > 0)
      {
        arg = Std.string(current);
      }
    }

    var result = new ScriptAction(type, arg);
    return result;
  }

  static function calculatePoint(x : flash.xml.XMLList,
                                 y : flash.xml.XMLList) : Point
  {
    var pos = null;
    if (x.length() > 0 && y.length() > 0)
    {
      var intX = Std.parseInt(Std.string(x));
      var intY = Std.parseInt(Std.string(y));
      if (intX != null && intY != null)
      {
        pos = new Point(intX, intY);
      }
    }
    return pos;
  }

  public static var editScript = '<script></script>';
/*
  public static var defaultScript = '
<script>
  <state name="start">
    <edge type="build-workshop" next="win" />
    <edge type="build-sniper" next="lose" />
  </state>
  <state name="win">
    <action type="win" />
  </state>
  <state name="lose">
    <action type="lose" />
  </state>
</script>
';
*/
  public static var defaultScript = '
<script>
  <state name="start">
    <action type="add-state" arg="countdown" />
    <edge type="bridge-clear" next="bridge"/>
    <edge type="zombie-clear" next="zombie" />
  </state>
  <state name="bridge">
    <edge type="zombie-clear" next="bridge-zombie" />
  </state>
  <state name="zombie">
    <edge type="bridge-clear" next="bridge-zombie" />
    <edge type="zombie-horde-begin" next="start" />
  </state>
  <state name="bridge-zombie">
    <action type="win" />
  </state>
  <state name="countdown">
    <action type="countdown" arg="150" />
    <edge type="countdown-complete" next="horde" />
  </state>
  <state name="horde">
    <action type="horde" />
    <edge type="zombie-horde-end" next="countdown" />
  </state>
</script>
';
}
