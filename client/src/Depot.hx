class Depot extends Tower
{
  public function new(newX : Int, newY : Int) : Void
  {
    type = Tower.DEPOT;
    super(new Point(newX, newY), Option.depotLevelLimit, Option.depotSpeed,
          Option.depotCost);
    addReserve(Lib.boardLoad);
    addReserve(Lib.ammoLoad);
    addReserve(Lib.survivorLoad);
    addReserve(Lib.survivorLoad);
    useFood = false;
    sand = Lib.newResourceArray();
    buildReserve = Lib.newResourceArray();
  }

  override public function step(count : Int) : Void
  {
#if TEST_LOAD
#else
    wait();
#end
    sendTrucks();
    updateSand();
  }

  public static var supplyButton = 0;
  public static var endSupplyButton = 1;
  public static var upgradeButton = 2;
  public static var toggleFoodButton = 3;
  public static var buildSniperButton = 4;
  public static var buildBarricadeButton = 5;
  public static var buildDepotButton = 6;
  public static var buildWorkshopButton = 7;

  override function normalizeLevel() : Void
  {
    super.normalizeLevel();
    if (useFood)
    {
      speed *= 2;
    }
  }

  override public function getType() : Int
  {
    return Tower.DEPOT;
  }

  override public function shouldUseFood() : Bool
  {
    return useFood;
  }

  override public function toggleFood() : Void
  {
    useFood = !useFood;
  }

  override public function getTruckSpeed() : Int
  {
    return Option.depotTruckSpeedMin[level]
      + Lib.rand(Option.depotTruckSpeedRange[level]);
  }

  function sendTrucks() : Void
  {
    var done = false;
    while (! done
           && countResource(Resource.SURVIVORS)
              - buildReserve[survivorIndex] > 0)
    {
      var sent = tryNeed();
      if (!sent)
      {
        sent = tryOverflow();
      }
      if (sent)
      {
        Game.map.noise(mapPos.x, mapPos.y, Option.towerNoise, zombieGuide);
      }
      done = !sent;
    }
  }

  function tryNeed() : Bool
  {
    var sent = false;
    var best = null;
    var bestRoute = null;
    var bestType = 0;
    for (dest in links)
    {
      var destTower = Game.map.getCell(dest.dest.x, dest.dest.y).getTower();
      if (destTower != null && dest.shouldSend())
      {
        var current = tryNeedTower(destTower);
        if (current != null
            && (best == null || getWeight(current) > getWeight(best)))
        {
          best = current;
          bestRoute = dest;
          bestType = destTower.getType();
        }
      }
    }
    if (best != null)
    {
      var amount = stuff.count(best.resource);
      if (bestType == Tower.DEPOT)
      {
        var index = Lib.resourceToIndex(best.resource);
        var afterReserve = stuff.count(best.resource)
          + stuff.incoming(best.resource)
          - stuff.reserve(best.resource)
          - buildReserve[index];
        amount = Math.floor(Math.min(amount, afterReserve));
      }
      var cargo = new ResourceCount(best.resource, amount);
      createSupplyTruck(bestRoute.dest, cargo, bestRoute);
      sent = true;
    }
    return sent;
  }

  function tryNeedTower(destTower : Tower) : ResourceCount
  {
    var result = null;
    var needList = destTower.getNeeds();
    for (need in needList)
    {
      var index = Lib.resourceToIndex(need.resource);
      var available = stuff.count(need.resource)
        + stuff.incoming(need.resource) - buildReserve[index];
      if (destTower.getType() == Tower.DEPOT)
      {
        available -= stuff.reserve(need.resource);
      }
      if (available > 0
          && stuff.count(need.resource) > 0
          && (result == null || getWeight(need) > getWeight(result)))
      {
        result = need;
      }
    }
    return result;
  }

  function tryOverflow() : Bool
  {
    var sent = false;
    var best = null;
    var bestRoute = null;
    for (dest in links)
    {
      var destTower = Game.map.getCell(dest.dest.x, dest.dest.y).getTower();
      if (destTower != null && destTower.getType() == Tower.DEPOT
          && dest.shouldSend())
      {
        var current = tryOverflowTower(destTower);
        if (current != null
            && (best == null || getWeight(current) < getWeight(best)))
        {
          best = current;
          bestRoute = dest;
        }
      }
    }
    if (best != null)
    {
      var cargo = new ResourceCount(best.resource,
                                    Lib.truckLoad(best.resource));
      createSupplyTruck(bestRoute.dest, cargo, bestRoute);
      sent = true;
    }
    return sent;
  }

  function tryOverflowTower(destTower : Tower) : ResourceCount
  {
    var result = null;
    var overflowList = destTower.getOverflow();
    for (overflow in overflowList)
    {
      var index = Lib.resourceToIndex(overflow.resource);
      var available = stuff.count(overflow.resource)
        + stuff.incoming(overflow.resource)
        - stuff.reserve(overflow.resource)
        - buildReserve[index];
      var hasMore = (/*(available - overflow.count
                      >= 2*Lib.truckLoad(overflow.resource))
                      ||*/
                        (/*available > overflow.count
                           &&*/ available >= Lib.truckLoad(overflow.resource)
                         && countSand(overflow.resource)
                            < destTower.countSand(overflow.resource)));
      if (hasMore
          && stuff.count(overflow.resource) >= Lib.truckLoad(overflow.resource)
          && (result == null || getWeight(overflow) < getWeight(result)))
      {
        result = overflow;
      }
    }
    return result;
  }

  function updateSand() : Void
  {
    for (i in 0...Option.resourceCount)
    {
      var resource = Lib.indexToResource(i);
      updateSandResource(resource);
    }
  }

  function updateSandResource(resource : Resource) : Void
  {
    var index = Lib.resourceToIndex(resource);
    var needs = countNeeds(resource);
    var neighbors = getSandLinks(resource);
    if (needs > 0)
    {
      sand[index] = reduce(sand[index]) + needs;
      if (resource != Resource.SURVIVORS)
      {
        sand[Lib.resourceToIndex(Resource.SURVIVORS)] += 1;
      }
    }
    else
    {
      var max = reduce(sand[index]);
      for (neighbor in neighbors)
      {
        var current = reduce(reduce(neighbor.countSand(resource)));
        if (current > max)
        {
          max = current;
        }
      }
      sand[index] = max;
    }
  }

  function reduce(val : Int) : Int
  {
    return Math.floor(val*sandFactor);
  }

  // Return the total number of resources needed.
  function countNeeds(resource : Resource) : Int
  {
    var count = stuff.reserve(resource) - stuff.count(resource)
      - stuff.incoming(resource);
    if (count > 0)
    {
      return getWeight(new ResourceCount(resource, count));
    }
    else
    {
      return 0;
    }
  }

  function getSandLinks(resource : Resource) : List<Tower>
  {
    var result = new List<Tower>();
    for (route in links)
    {
      var destTower = Game.map.getCell(route.dest.x, route.dest.y).getTower();
      if (destTower != null && destTower.usesSand())
      {
        result.add(destTower);
      }
    }
    return result;
  }

  override function usesSand() : Bool
  {
    return true;
  }

  override function countSand(resource : Resource) : Int
  {
    var index = Lib.resourceToIndex(resource);
    return sand[index];
  }

  override function addSand(payload : ResourceCount) : Void
  {
    var index = Lib.resourceToIndex(payload.resource);
    sand[index] += payload.count;
  }

  static var boardIndex = Lib.resourceToIndex(Resource.BOARDS);
  static var survivorIndex = Lib.resourceToIndex(Resource.SURVIVORS);

  override public function reserveBuildResource(type : Int) : Void
  {
    var cost = Tower.getBuildCost(type) * Lib.truckLoad(Resource.BOARDS);
    buildReserve[boardIndex] = cost;
    buildReserve[survivorIndex] = Lib.truckLoad(Resource.SURVIVORS);
  }

  override public function freeBuildResource() : Void
  {
    buildReserve[boardIndex] = 0;
    buildReserve[survivorIndex] = 0;
  }

  override public function saveTower() : Dynamic
  {
    return { parent : super.saveTowerGeneric(),
             useFood : useFood,
             sand : sand.copy(),
             buildReserve : buildReserve.copy() };
  }

  override public function load(input : Dynamic) : Void
  {
    super.load(input.parent);
    useFood = input.useFood;
    for (i in 0...Option.resourceCount)
    {
      sand[i] = input.sand[i];
    }
    for (i in 0...Option.resourceCount)
    {
      buildReserve[i] = input.buildReserve[i];
    }
  }

  // Sand is multiplied by this amount every tick and rounded down.
  static var sandFactor = 0.9;

  var useFood : Bool;
  var sand : Array<Int>;
  var buildReserve : Array<Int>;
}
