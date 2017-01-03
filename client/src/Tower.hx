class Tower extends Actor
{

  public static var BARRICADE = 0;
  public static var SNIPER = 1;
  public static var DEPOT = 2;
  public static var WORKSHOP = 3;

  public function new(newMapPos : Point, newLevelLimit : Int,
                      newSpeedTable : Array<Int>,
                      newUpgradeCostTable : Array<Int>)
  {
    super(newSpeedTable[0]);
    mapPos = newMapPos.clone();
    sprite = new ui.TowerSprite(mapPos, type, 0);
    stuff = new Storage();
    survivors = [];
    incomingSurvivors = [];
    level = 0;
    reservedUpgrade = 0;
    committedUpgrade = 0;
    links = new List<Route>();
    zombieGuide = Game.pathPool.getZombiePath(mapPos, PathFinderPool.LOW);

    levelLimit = newLevelLimit;
    speedTable = newSpeedTable;
    upgradeCostTable = newUpgradeCostTable;
    normalizeLevel();
  }

  override public function cleanup() : Void
  {
    removeAllTrade();
    sprite.cleanup();
    super.cleanup();
  }

  // --------------------------------------------------------------------------
  // Interface
  // --------------------------------------------------------------------------

  public function getMapPos() : Point
  {
    return mapPos.clone();
  }

  public function getZombieGuide() : PathFinder
  {
    return zombieGuide;
  }

  public function removeAllTrade() : Void
  {
    while (! links.isEmpty())
    {
      removeTradeLink(links.first().dest);
    }
  }

  // --------------------------------------------------------------------------

  public function getLevel() : Int
  {
    return level;
  }

  // --------------------------------------------------------------------------

  public function canUpgrade() : Bool
  {
    return level < levelLimit;
  }

  // --------------------------------------------------------------------------

  public function isUpgrading() : Bool
  {
    return reservedUpgrade > 0;
  }

  // --------------------------------------------------------------------------

  public function upgrade() : Void
  {
    if (canUpgrade())
    {
      ++committedUpgrade;
      if (committedUpgrade >= upgradeCostTable[level+1])
      {
        Main.sound.play(SoundPlayer.TOWER_UPGRADE);
        upgradeLevel();
      }
      Game.update.changeStatus();
    }
  }

  // --------------------------------------------------------------------------

  public function upgradeLevel() : Void
  {
    if (canUpgrade())
    {
      committedUpgrade = 0;
      level += 1;
      normalizeLevel();
    }
  }

  // --------------------------------------------------------------------------

  public function canDowngrade() : Bool
  {
    return level > 0;
  }

  // --------------------------------------------------------------------------

  public function downgrade() : Void
  {
    if (canDowngrade())
    {
      level -= 1;
      normalizeLevel();
      Game.update.changeStatus();
    }
  }

  // --------------------------------------------------------------------------

  public function reserveUpgrade() : Void
  {
    if (canUpgrade() && reservedUpgrade + committedUpgrade < getUpgradeCost())
    {
      ++reservedUpgrade;
    }
  }

  // --------------------------------------------------------------------------

  public function freeUpgrade() : Void
  {
    if (reservedUpgrade > 0)
    {
      --reservedUpgrade;
    }
  }

  // --------------------------------------------------------------------------

  public function getUpgradeLeft() : Int
  {
    return getUpgradeCost() - committedUpgrade;
  }

  // --------------------------------------------------------------------------

  public function getUpgradeLeftText() : String
  {
    return Std.string(getUpgradeLeft()*Lib.truckLoad(Resource.BOARDS));
  }

  // --------------------------------------------------------------------------

  public function getInfrastructureBoards() : Int
  {
    var total = 0;
    for (i in 0...(level+1))
    {
      total += upgradeCostTable[i];
    }
    return total;
  }

  public function giveResource(payload : ResourceCount) : Void
  {
    stuff.give(payload);
    updateLow(payload.resource);
    Game.progress.addResources(payload.resource, payload.count);
    Game.update.resourceChange(mapPos);
  }

  public function giveSurvivor(type : Int) : Void
  {
    survivors.push(type);
    giveResource(Lib.survivorLoad);
  }

  public function takeResource(payload : ResourceCount) : Void
  {
    stuff.take(payload);
    updateLow(payload.resource);
    Game.progress.removeResources(payload.resource, payload.count);
    Game.update.resourceChange(mapPos);
  }

  public function takeSurvivor() : Int
  {
    takeResource(Lib.survivorLoad);
    return survivors.pop();
  }

  public function hasResource(payload : ResourceCount) : Bool
  {
    return stuff.count(payload.resource) >= payload.count;
  }

  public function countResource(payload : Resource) : Int
  {
    return stuff.count(payload);
  }

  public function addIncoming(payload : ResourceCount) : Void
  {
    stuff.addIncoming(payload);
    updateLow(payload.resource);
    Game.progress.addResources(payload.resource, payload.count);
    Game.update.resourceChange(mapPos);
  }

  public function addIncomingSurvivor(type : Int) : Void
  {
    addIncoming(Lib.survivorLoad);
    incomingSurvivors.push(type);
  }

  public function removeIncoming(payload : ResourceCount) : Void
  {
    stuff.removeIncoming(payload);
    updateLow(payload.resource);
    Game.progress.removeResources(payload.resource, payload.count);
    Game.update.resourceChange(mapPos);
  }

  public function removeIncomingSurvivor(type : Int) : Void
  {
    removeIncoming(Lib.survivorLoad);
    incomingSurvivors.remove(type);
  }

  public function removeAllResources() : Void
  {
    for (i in 0...Option.resourceCount)
    {
      var payload = Lib.indexToResource(i);
      var count = stuff.count(payload);
      Game.progress.removeResources(payload, count);
      count = stuff.incoming(payload);
      Game.progress.removeResources(payload, count);
      count = stuff.reserve(payload);
      Game.progress.addResources(payload, count);
    }
  }

  public function countIncoming(payload : Resource) : Int
  {
    return stuff.incoming(payload);
  }

  public function addReserve(payload : ResourceCount) : Void
  {
    stuff.addReserve(payload);
    updateLow(payload.resource);
    Game.update.resourceChange(mapPos);
    Game.progress.removeResources(payload.resource, payload.count);
  }

  public function removeReserve(payload : ResourceCount) : Void
  {
    if (stuff.reserve(payload.resource) >= payload.count)
    {
      stuff.removeReserve(payload);
      updateLow(payload.resource);
      Game.update.resourceChange(mapPos);
      Game.progress.addResources(payload.resource, payload.count);
    }
  }

  public function countReserve(payload : Resource) : Int
  {
    return stuff.reserve(payload);
  }

  public function getTradeLinks() : List<Route>
  {
    return links;
  }

  public function addTradeLink(dest : Point) : Void
  {
    var found = getRoute(dest);
    var destTower = Game.map.getCell(dest.x, dest.y).getTower();
    if (found == null && destTower != null
        && (mapPos.x != dest.x || mapPos.y != dest.y))
    {
      Game.script.trigger(logic.Script.CREATE_TRADE_SOURCE, mapPos);
      Game.script.trigger(logic.Script.CREATE_TRADE_DEST, dest);
      Main.replay.addLine(mapPos, dest);
      var forwardPath = new Route(mapPos, dest);
      links.add(forwardPath);
      var backPath = new Route(dest, mapPos);
      destTower.links.add(backPath);
      Game.update.supplyLine(mapPos, dest);
    }
  }

  public function removeTradeLink(dest : Point) : Void
  {
    Main.replay.removeLine(mapPos, dest);
    Main.replay.removeLine(dest, mapPos);
    removeHalfLink(dest);
    sprite.changeSupplyTarget(false);
    var destTower =  Game.map.getCell(dest.x, dest.y).getTower();
    if (destTower != null)
    {
      destTower.removeHalfLink(mapPos);
      destTower.sprite.changeSupplyTarget(false);
    }
    Game.update.supplyLine(mapPos, dest);
  }

  // Remove just the local state for a link with destination dest.
  function removeHalfLink(dest : Point) : Void
  {
    var result = getRoute(dest);
    if (result != null)
    {
      links.remove(result);
    }
  }

  public function addTradeTargets() : Void
  {
    for (partner in links)
    {
      var tower = Game.map.getCell(partner.dest.x,
                                   partner.dest.y).getTower();
      tower.sprite.changeSupplyTarget(true);
      tower.sprite.update();
    }
  }

  public function removeTradeTargets() : Void
  {
    for (partner in links)
    {
      var tower = Game.map.getCell(partner.dest.x,
                                   partner.dest.y).getTower();
      tower.sprite.changeSupplyTarget(false);
      tower.sprite.update();
    }
  }

  public function removeTarget() : Void
  {
    sprite.changeSupplyTarget(false);
    sprite.update();
  }

  public function getRoute(dest : Point) : Route
  {
    var result = null;
    for (candidate in links)
    {
      if (Point.isEqual(candidate.dest, dest))
      {
        result = candidate;
      }
    }
    return result;
  }

  public function getUpgradeCost() : Int
  {
    return upgradeCostTable[level+1];
  }

  public function getUpgradeSupplier() : Point
  {
    var result = null;
    var boardCost = getUpgradeCost() * Lib.truckLoad(Resource.BOARDS);
    var survivorCost = getUpgradeCost() * Lib.truckLoad(Resource.SURVIVORS);
/*
    if (stuff.count(Resource.BOARDS) >= boardCost)
    {
      result = mapPos;
    }
    else
*/
    {
      for (source in links)
      {
        var sourceTower = Game.map.getCell(source.dest.x,
                                           source.dest.y).getTower();
        var boardCount = sourceTower.countResource(Resource.BOARDS);
//        var foodCost = getUpgradeCost() * sourceTower.getFoodCost();
//        var foodCount = sourceTower.countResource(Resource.FOOD);
        var survivorCount = sourceTower.countResource(Resource.SURVIVORS);
        if (sourceTower != null
            && boardCount >= boardCost
//            && foodCount >= foodCost
            && survivorCount >= survivorCost)
        {
          result = source.dest;
          break;
        }
      }
    }
    if (result != null)
    {
      return result.clone();
    }
    else
    {
      return result;
    }
  }

  public function hasBuildResource(type : Int) : Bool
  {
    var cost = getBuildCost(type) * Lib.truckLoad(Resource.BOARDS);
    return (hasResource(new ResourceCount(Resource.BOARDS, cost))
            && hasResource(Lib.survivorLoad));
  }

  public function getBuildShortage(type : Int) : Resource
  {
    var cost = getBuildCost(type) * Lib.truckLoad(Resource.BOARDS);
    if (! hasResource(Lib.survivorLoad))
    {
      return Resource.SURVIVORS;
    }
    else if (! hasResource(new ResourceCount(Resource.BOARDS, cost)))
    {
      return Resource.BOARDS;
    }
    else
    {
      return null;
    }
  }

  public function takeBuildResource(type : Int) : Void
  {
    var cost = getBuildCost(type) * Lib.truckLoad(Resource.BOARDS);
    takeResource(new ResourceCount(Resource.BOARDS, cost));
    takeResource(Lib.survivorLoad);
  }

  public function giveBuildResource(type : Int) : Void
  {
    var cost = getBuildCost(type) * Lib.truckLoad(Resource.BOARDS);
    giveResource(new ResourceCount(Resource.BOARDS, cost));
    giveResource(Lib.survivorLoad);
  }

  public function reserveBuildResource(type : Int) : Void
  {
  }

  public function freeBuildResource() : Void
  {
  }

  public function getSurvivorType(index : Int) : Int
  {
    if (index < survivors.length)
    {
      return survivors[index];
    }
    else if (index < survivors.length + incomingSurvivors.length)
    {
      return incomingSurvivors[index - survivors.length];
    }
    else
    {
      return 0;
    }
  }

  // --------------------------------------------------------------------------
  // Overridable functions
  // --------------------------------------------------------------------------

  public function updateBlocked() : Void
  {
  }

  public function showVisibility(range : Range) : Void
  {
  }

  public function updateVisibility() : Void
  {
  }

  public function getAccuracy(? zombieSprite : Zombie) : Int
  {
    return 0;
  }

  // Returns true if tower is destroyed
  public function attack() : Bool
  {
    Main.sound.play(SoundPlayer.TOWER_DESTROY);
    return true;
  }

  // Derived classes should call super.normalizeLevel()
  public function normalizeLevel() : Void
  {
    speed = speedTable[level];
  }

  public function getRange() : Int
  {
    return 0;
  }

  public function canWasteShot() : Bool
  {
    return false;
  }

  public function wasteShot() : Void
  {
  }

  public function canBuildGarden() : Bool
  {
    return false;
  }

  public function buildGarden() : Void
  {
  }

  public function shouldUseFood() : Bool
  {
    return false;
  }

  public function toggleFood() : Void
  {
  }

  public function getFoodCost() : Int
  {
    return Option.foodTransportCost;
  }

  public function getTruckSpeed() : Int
  {
    return Option.truckSpeedMin + Lib.rand(Option.truckSpeedRange);
  }

  public function usesSand() : Bool
  {
    return false;
  }

  public function countSand(resource : Resource) : Int
  {
    return 0;
  }

  public function addSand(payload : ResourceCount) : Void
  {
  }

  public function toggleHoldFire() : Void
  {
  }

  public function isHoldingFire() : Bool
  {
    return false;
  }

  // --------------------------------------------------------------------------
  // Implementation
  // --------------------------------------------------------------------------
  public function startUpgradeTruck() : Bool
  {
    var success = false;
    var supplier = getUpgradeSupplier();
    if (supplier != null && Point.isEqual(supplier, mapPos)
        && canUpgrade() && ! isUpgrading())
    {
      for (i in 0...(getUpgradeCost()))
      {
        takeResource(Lib.boardLoad);
        upgrade();
      }
      success = true;
    }
    else if (canUpgrade() && ! isUpgrading() && supplier != null)
    {
      for (i in 0...(getUpgradeCost()))
      {
        var transport = null;
        if (getType() == Tower.WORKSHOP)
        {
          transport = Truck.createWorkshopUpgradeTruck(new Point(supplier.x,
                                                                 supplier.y),
                                                       mapPos);
        }
        else
        {
          var supplierTower = Game.map.getCell(supplier.x,
                                               supplier.y).getTower();
          var route = supplierTower.getRoute(mapPos);
          transport = Truck.createUpgradeTruck(route);
        }
      }
      success = true;
    }
    return success;
  }

  public static function canPlace(newType : Int, x : Int, y : Int,
                                  ? ignoreSupplied : Null<Bool>) : Bool
  {
    var bBridge = BackgroundType.BRIDGE;
    var bBuilding = BackgroundType.BUILDING;
    var bEntrance = BackgroundType.ENTRANCE;
    var result = false;
    var cell = Game.map.getCell(x, y);
    if (! cell.hasTower() && ! cell.hasShadow() && ! cell.hasZombies()
        && ! cell.isBlocked() && cell.getBackground() != bBridge
        && (ignoreSupplied == true || isSupplied(x, y) || Game.settings.isEditor()))
    {
      if (newType == WORKSHOP
          && (cell.hasRubble() || cell.mFeature != null)
          && (cell.getBuilding() == null || ! cell.getBuilding().hasZombies()))
      {
        result = true;
      }
      else if (newType != WORKSHOP
               && ! cell.hasRubble()
               && cell.mFeature == null
               && cell.getBackground() != bBuilding
               && cell.getBackground() != bEntrance)
      {
        result = true;
      }
    }
    return result;
  }

  public static function isSupplied(x : Int, y : Int) : Bool
  {
    var result = false;
    var posList = Game.map.findTowers(x, y, Option.supplyRange);
    for (pos in posList)
    {
      var tower = Game.map.getCell(pos.x, pos.y).getTower();
      if (tower.getType() == DEPOT)
      {
        result = true;
        break;
      }
    }
    return result;
  }

  public function getType() : Int
  {
    return DEPOT;
  }

  public static function getBuildCost(type : Int) : Int
  {
    if (type == BARRICADE)
    {
      return Option.barricadeCost[0];
    }
    else if (type == SNIPER)
    {
      return Option.sniperCost[0];
    }
    else if (type == DEPOT)
    {
      return Option.depotCost[0];
    }
    else // type == WORKSHOP
    {
      return Option.workshopCost[0];
    }
  }

  function updateLow(resource : Resource) : Void
  {
    if (countReserve(resource) > countResource(resource)
        + countIncoming(resource))
    {
      sprite.addNeed(resource);
    }
    else
    {
      sprite.removeNeed(resource);
    }
  }

  // --------------------------------------------------------------------------
  // Supply Line Code
  // --------------------------------------------------------------------------

  // Send a truck with extra resources back to a depot. Optionally
  // ensure that you only send a full truckload of resources.
  function sendToDepot(fullLoad : Bool) : Void
  {
    var destPos = null;
    var route = null;
    for (dest in links)
    {
      var newTower = Game.map.getCell(dest.dest.x, dest.dest.y).getTower();
      if (newTower != null && newTower.getType() == DEPOT && dest.shouldSend())
      {
        destPos = dest.dest;
        route = dest;
        break;
      }
    }
    var load = null;
    var bestWeight = 0;
    for (i in 0...Option.resourceCount)
    {
      var resource = Lib.indexToResource(i);
      var count = stuff.count(resource) - stuff.reserve(resource);
      if (count > 0)
      {
        var newLoad = new ResourceCount(resource, count);
        if (getWeight(newLoad) > bestWeight)
        {
          load = newLoad;
          bestWeight = getWeight(load);
        }
      }
    }
    if (destPos != null && load != null && route != null
        && (!fullLoad || load.count >= Lib.truckLoad(load.resource))
        && stuff.count(Resource.SURVIVORS) >= Lib.truckLoad(Resource.SURVIVORS))
    {
      createSupplyTruck(destPos, load, route);
    }
  }

  function createSupplyTruck(dest : Point, need : ResourceCount,
                             route : Route) : Void
  {
    var amount = Math.floor(Math.min(need.count,
                                     Lib.truckLoad(need.resource)));
    var transport = Truck.createSupplyTruck(mapPos, dest,
                                            need.resource, amount,
                                            route);
  }

  function getWeight(payload : ResourceCount) : Int
  {
    if (payload.resource == Resource.SURVIVORS)
    {
      return payload.count * Option.truckLoad;
    }
    else
    {
      return payload.count;
    }
  }

  public function getNeeds() : List<ResourceCount>
  {
    var result = new List<ResourceCount>();
    for (i in 0...Option.resourceCount)
    {
      var payload = Lib.indexToResource(i);
      var need = stuff.reserve(payload) -
        (stuff.count(payload) + stuff.incoming(payload));
      if (need > 0)
      {
        result.add(new ResourceCount(payload, need));
      }
    }
    return result;
  }

  public function getOverflow() : List<ResourceCount>
  {
    var result = new List<ResourceCount>();
    for (i in 0...Option.resourceCount)
    {
      var payload = Lib.indexToResource(i);
      var greed = stuff.count(payload) + stuff.incoming(payload)
        - stuff.reserve(payload);
      if (greed >= 0)
      {
        result.add(new ResourceCount(payload, greed));
      }
    }
    return result;
  }

  public function saveEditResources(output : flash.utils.ByteArray) : Void
  {
    stuff.saveEditResources(output);
  }

  public static function saveStatic(tower : Tower) : Dynamic
  {
    return tower.save();
  }

  public function saveTowerGeneric() : Dynamic
  {
    return { parent : super.save(),
             sprite : ui.TowerSprite.saveS(sprite),
             mapPos : mapPos.save(),
             stuff : stuff.save(),
             survivors : survivors.copy(),
             incomingSurvivors : incomingSurvivors.copy(),
             level : level,
             reservedUpgrade : reservedUpgrade,
             committedUpgrade : committedUpgrade,
             links : Save.saveList(links, Route.saveS),
             type : type,
             zombieGuide : zombieGuide.save() };
  }

  override public function load(input : Dynamic) : Void
  {
    super.load(input.parent);
    sprite.cleanup();
    sprite = ui.TowerSprite.load(input.sprite);
    mapPos = Point.load(input.mapPos);
    stuff.load(input.stuff);

    survivors = Load.loadArrayInt(input.survivors);
    incomingSurvivors = Load.loadArrayInt(input.incomingSurvivors);

    level = input.level;
    reservedUpgrade = input.reservedUpgrade;
    committedUpgrade = input.committedUpgrade;
    links = Load.loadList(input.links, Route.load);
    zombieGuide = PathFinder.load(input.zombieGuide);
  }

  public static function loadS(input : Dynamic) : Tower
  {
    // input is the derived type so input.parent is this class.
    var result : Tower = null;
    if (input.parent.type == BARRICADE)
    {
      result = new Barricade(input.parent.mapPos.x, input.parent.mapPos.y);
    }
    else if (input.parent.type == SNIPER)
    {
      result = new Sniper(input.parent.mapPos.x, input.parent.mapPos.y);
    }
    else if (input.parent.type == DEPOT)
    {
      result = new Depot(input.parent.mapPos.x, input.parent.mapPos.y);
    }
    else // input.type == WORKSHOP
    {
      result = new Workshop(input.parent.mapPos.x, input.parent.mapPos.y);
    }
    result.load(input);
    result.normalizeLevel();
    Game.map.getCell(result.mapPos.x, result.mapPos.y).loadAddTower(result);
    return result;
  }

  var sprite : ui.TowerSprite;

  var mapPos : Point;

  var stuff : Storage;
  var survivors : Array<Int>;
  var incomingSurvivors : Array<Int>;

  var level : Int;
  var reservedUpgrade : Int;
  var committedUpgrade : Int;
  var links : List<Route>;
  var type : Int;
  var zombieGuide : PathFinder;

  var levelLimit : Int;
  var speedTable : Array<Int>;
  var upgradeCostTable : Array<Int>;
}
