// Object which tracks the players progress through the game.
// TODO: Load/save bridges and broken bridges and depot positions

class Progress
{
  public function new() : Void
  {
    resources = Lib.newResourceArray();
    zombies = 0;
    bridges = new List<logic.Bridge>();
    brokenBridges = new List<logic.Bridge>();
    depots = new Array<Point>();
  }

  public function cleanup() : Void
  {
    cleanupBridges();
    cleanupBrokenBridges();
  }

  function cleanupBridges() : Void
  {
    for (bridge in bridges)
    {
      bridge.cleanup();
    }
  }

  function cleanupBrokenBridges() : Void
  {
    for (brokenBridge in brokenBridges)
    {
      brokenBridge.cleanup();
    }
  }

  public function addResources(payload : Resource, amount : Int) : Void
  {
    var index = Lib.resourceToIndex(payload);
    resources[index] += amount;
    Game.update.progress();
  }

  public function removeResources(payload : Resource, amount : Int) : Void
  {
    var index = Lib.resourceToIndex(payload);
    resources[index] -= amount;
    Game.update.progress();
  }

  public function addZombies(amount : Int) : Void
  {
    zombies += amount;
    Game.update.progress();
  }

  public function removeZombies(amount : Int) : Void
  {
    zombies -= amount;
    Game.update.progress();
    if (zombies <= 0)
    {
      Game.script.trigger(logic.Script.ZOMBIE_CLEAR);
    }
    if (bridges.length <= 0)
    {
      Game.script.trigger(logic.Script.BRIDGE_CLEAR);
    }
    checkForWin();
  }

  public function addBridge(bridge : logic.Bridge, isBroken : Bool) : Void
  {
    if (isBroken)
    {
      brokenBridges.add(bridge);
    }
    else
    {
      bridges.add(bridge);
    }
    Game.update.progress();
  }

  public function destroyBridge(bridge : logic.Bridge) : Void
  {
    bridges.remove(bridge);
    brokenBridges.add(bridge);
    Game.update.progress();
    if (zombies <= 0)
    {
      Game.script.trigger(logic.Script.ZOMBIE_CLEAR);
    }
    if (bridges.length <= 0)
    {
      Game.script.trigger(logic.Script.BRIDGE_CLEAR);
    }
    checkForWin();
  }

  public function clearBridge(bridge : logic.Bridge) : Void
  {
    if (bridge != null)
    {
      bridges.remove(bridge);
      brokenBridges.remove(bridge);
      bridge.cleanup();
      Game.update.progress();
    }
  }

  function checkForWin() : Void
  {
/*
    if (bridges.length <= 0 && zombies <= 0
        && Game.settings.getEasterEgg() != logic.GameSettings.FIDDLERSGREEN
        && ! Game.settings.isEditor())
    {
      Game.endGame(GameOver.WIN);
    }
*/
  }

  public function addDepot(pos : Point) : Void
  {
    depots.push(pos);
    Game.update.progress();
  }

  public function removeDepot(pos : Point) : Void
  {
    var target = null;
    for (depot in depots)
    {
      if (Point.isEqual(pos, depot))
      {
        target = depot;
        break;
      }
    }
    if (target != null)
    {
      depots.remove(target);
    }

    Game.update.progress();
    if (depots.length == 0 && ! Game.settings.isEditor())
    {
      Game.settings.setLoseText(ui.Text.mainLoseText);
      Game.endGame(GameOver.LOSE);
    }
  }

  public function getResourceCount(payload : Resource) : Int
  {
    var index = Lib.resourceToIndex(payload);
    return resources[index];
  }

  public function getAllResourceCounts() : Array<Int>
  {
    return resources;
  }

  public function getZombieCount() : Int
  {
    return zombies;
  }

  public function getBridgeCount() : Int
  {
    return bridges.length;
  }

  public function getRandomBridge() : logic.Bridge
  {
    var result = null;
    if (bridges.length > 0)
    {
      var index = Lib.rand(bridges.length);
      for (bridge in bridges)
      {
        if (index == 0)
        {
          result = bridge;
          break;
        }
        --index;
      }
    }
    return result;
  }

  public function getDepotCount() : Int
  {
    return depots.length;
  }

  public function getRandomDepot() : Point
  {
    var result = null;
    if (depots.length > 0)
    {
      var index = Lib.rand(depots.length);
      result = depots[index];
    }
    return result;
  }

  public function save() : Dynamic
  {
    return { resources : resources.copy(),
        zombies : zombies,
        brokenBridges : Save.saveList(brokenBridges, logic.Bridge.saveS),
        depots : Save.saveArray(depots, Point.saveS) };
  }

  public function load(input : Dynamic) : Void
  {
    for (i in 0...Option.resourceCount)
    {
      resources[i] = input.resources[i];
    }
    zombies = input.zombies;
    // Do not load bridges. They will be repopulated when loading Dynamite.
    brokenBridges = Load.loadList(input.brokenBridges, logic.Bridge.load);
    depots = Load.loadArray(input.depots, Point.load);
  }

  var resources : Array<Int>;
  var zombies : Int;
  var bridges : List<logic.Bridge>;
  var brokenBridges : List<logic.Bridge>;
  var depots : Array<Point>;
}
