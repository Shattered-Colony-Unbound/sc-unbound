class MapCell
{
  public function new()
  {
    mTile = new List<Int>();
    mIsBlocked = false;
    mTower = null;
    x = 0;
    y = 0;
    mZombies = new List<Zombie>();
    mTrucks = new List<Truck>();
    mShadow = null;
    mRubble = null;
    mBuilding = null;
    mBackground = BackgroundType.STREET;

    scent = null;
    obstacle = null;
    mFeature = null;
    edit = null;
  }

  public function init(newX : Int, newY : Int) : Void
  {
    x = newX;
    y = newY;
  }

  public function addTile(newTile : Int) : Void
  {
    mTile.add(newTile);
  }

  public function clearTiles() : Void
  {
    mTile.clear();
  }

  public function getTiles() : List<Int>
  {
    return mTile;
  }

  public function setBlocked() : Void
  {
    mIsBlocked = true;
  }

  public function clearBlocked() : Void
  {
    mIsBlocked = false;
  }

  public function isBlocked() : Bool
  {
    return mIsBlocked;
  }

  public function hasTower() : Bool
  {
    return mTower != null;
  }

  public function createTower(type : Int)
  {
    if (! hasTower())
    {
      var color = 0;
      if (type == Tower.DEPOT)
      {
        mTower = new Depot(x, y);
        color = ui.Color.depotReplay;
        Game.progress.addDepot(new Point(x, y));
        Game.script.trigger(logic.Script.BUILD_DEPOT, new Point(x, y));
      }
      else if (type == Tower.WORKSHOP)
      {
        mTower = new Workshop(x, y);
        color = ui.Color.workshopReplay;
        Game.script.trigger(logic.Script.BUILD_WORKSHOP, new Point(x, y));
      }
      else if (type == Tower.BARRICADE)
      {
        mTower = new Barricade(x, y);
        color = ui.Color.barricadeReplay;
        Game.script.trigger(logic.Script.BUILD_BARRICADE, new Point(x, y));
      }
      else if (type == Tower.SNIPER)
      {
        mTower = new Sniper(x, y);
        color = ui.Color.sniperReplay;
        Game.sprites.addSniper(mTower);
        Game.script.trigger(logic.Script.BUILD_SNIPER, new Point(x, y));
      }
      Main.replay.addBox(new Point(x, y), new Point(x + 1, y + 1), color);
      Game.update.newTower(new Point(x, y));
      Game.actions.push(new action.UpdateBlocked(new Point(x, y)));
    }
  }

  public function destroyTower() : Void
  {
    if (hasTower())
    {
      Main.replay.addBox(new Point(x, y), new Point(x + 1, y + 1),
                         Option.roadMiniColor);
      if (mTower.getType() == Tower.DEPOT)
      {
        Game.script.trigger(logic.Script.DESTROY_DEPOT, new Point(x, y));
      }
      else if (mTower.getType() == Tower.BARRICADE)
      {
        Game.script.trigger(logic.Script.DESTROY_BARRICADE, new Point(x, y));
      }
      else if (mTower.getType() == Tower.SNIPER)
      {
        Game.sprites.removeSniper(mTower);
        Game.view.window.updateRanges();
        Game.script.trigger(logic.Script.DESTROY_SNIPER, new Point(x, y));
      }
      else if (mTower.getType() == Tower.WORKSHOP)
      {
        Game.script.trigger(logic.Script.DESTROY_WORKSHOP, new Point(x, y));
      }
      mTower.removeAllResources();
      mTower.cleanup();
      mTower = null;
      Game.update.destroyTower(new Point(x, y));
      Game.actions.push(new action.UpdateBlocked(new Point(x, y)));
    }
  }

  public function fleeTower()
  {
    if (hasTower())
    {
      if (mTower.getType() == Tower.DEPOT)
      {
        Game.progress.removeDepot(new Point(x, y));
      }
      var fleeRoute = getReturnRoute();
      var survivorCount = mTower.countResource(Resource.SURVIVORS);
      for (i in 0...survivorCount)
      {
        var newType = mTower.takeSurvivor();
        if (fleeRoute != null)
        {
          var newTruck = Truck.createFleeingTruck(newType, fleeRoute);
        }
      }
    }
    for (i in 0...(Option.resourceCount))
    {
      var payload = Lib.indexToResource(i);
      var amount = mTower.countResource(payload);
      if (amount > 0)
      {
        addRubble(payload, amount);
      }
    }
    if (mTower.getType() != Tower.BARRICADE)
    {
      addRubble(Resource.BOARDS,
                Option.truckLoad * mTower.getInfrastructureBoards());
    }
    destroyTower();
  }

  public function closeTower()
  {
    if (hasTower() && (mTower.getType() == Tower.WORKSHOP
                       || mTower.getType() == Tower.BARRICADE))
    {
      if (mTower.getType() == Tower.DEPOT)
      {
        Game.progress.removeDepot(new Point(x, y));
      }
      var returnRoute = getReturnRoute();
      var survivorCount = mTower.countResource(Resource.SURVIVORS);
      for (i in 0...survivorCount)
      {
        var newType = mTower.takeSurvivor();
        if (returnRoute != null)
        {
          var payload = Resource.SURVIVORS;
          if (mTower.canDowngrade())
          {
            payload = Resource.BOARDS;
            mTower.downgrade();
          }
          var newTruck = Truck.createClosingTruck(newType, returnRoute,
                                                  Resource.SURVIVORS);
        }
      }
      destroyTower();
    }
  }

  function getReturnRoute() : Route
  {
    var result = null;
    if (! mTower.getTradeLinks().isEmpty())
    {
      for (test in mTower.getTradeLinks())
      {
        var tower = Game.map.getCell(test.dest.x, test.dest.y).getTower();
        if (tower.getType() == Tower.DEPOT)
        {
          result = test;
          break;
        }
      }
    }
    if (result == null)
    {
      var dest = Game.progress.getRandomDepot();
      if (dest != null)
      {
        result = new Route(new Point(x, y), dest);
      }
    }
    return result;
  }

  public function getTower() : Tower
  {
    return mTower;
  }

  public function attackTower() : Void
  {
    if (hasTower())
    {
      var isDestroyed = mTower.attack();
      if (isDestroyed)
      {
        fleeTower();
      }
    }
  }

  public function attackSurvivor() : Point
  {
    var result = null;
    if (! mTrucks.isEmpty())
    {
      result = mTrucks.first().getPixel();
      Game.actions.push(new action.KillTruck(mTrucks.first()));
      removeTruck(mTrucks.first());
      Game.update.cellState(new Point(x, y));
    }
    return result;
  }

  public function addZombie(newZombie : Zombie) : Void
  {
    if (mZombies.isEmpty())
    {
      Game.tracker.addCell(new Point(x, y));
    }
    mZombies.add(newZombie);
    while (! mTrucks.isEmpty())
    {
      Game.actions.push(new action.KillTruck(mTrucks.first()));
      removeTruck(mTrucks.first());
    }
    Game.update.cellState(new Point(x, y));
  }

  public function destroyAllTrucks() : Void
  {
    while (! mTrucks.isEmpty())
    {
      var truck = mTrucks.first();
      removeTruck(truck);
      truck.cleanup();
    }
  }

  public function removeZombie(oldZombie : Zombie) : Void
  {
    mZombies.remove(oldZombie);
    if (mZombies.isEmpty())
    {
      Game.tracker.removeCell(new Point(x, y));
    }
    Game.update.cellState(new Point(x, y));
  }

  public function hasZombies() : Bool
  {
    return ! mZombies.isEmpty();
  }

  public function spawn(dest : Point, guide : PathFinder) : Void
  {
    if (! mZombies.isEmpty())
    {
      mZombies.first().makeNoise(dest, 0, guide);
      mZombies.first().addToWave();
    }
  }

  public function attackZombie(source : Point) : Void
  {
    if (! mZombies.isEmpty())
    {
      mZombies.first().kill(source);
    }
  }

  public function getZombie() : Zombie
  {
    if (! mZombies.isEmpty())
    {
      return mZombies.first();
    }
    else
    {
      return null;
    }
  }

  public function zombieCount() : Int
  {
    return mZombies.length;
  }

  public function makeNoise(source : Point, loudness : Int,
                            guide : PathFinder) : Void
  {
    for (zombie in mZombies)
    {
      zombie.makeNoise(source, loudness, guide);
    }
    if (mBuilding != null)
    {
      mBuilding.makeNoise(source, loudness, guide);
    }
  }

  public function addTruck(newTruck : Truck) : Void
  {
    addScents();
    mTrucks.add(newTruck);
    if (hasZombies())
    {
      Game.actions.push(new action.KillTruck(newTruck));
      removeTruck(newTruck);
    }
    Game.update.cellState(new Point(x, y));
  }

  public function removeTruck(oldTruck : Truck) : Void
  {
    mTrucks.remove(oldTruck);
    Game.update.cellState(new Point(x, y));
  }

  public function hasTrucks() : Bool
  {
    return ! mTrucks.isEmpty();
  }

  public function setShadow(newType : Int) : ui.TowerSprite
  {
    if (mShadow != null)
    {
      clearShadow();
    }
    mShadow = new ui.TowerSprite(new Point(x, y),
                                 newType, 0);
//    mShadow.init(Lib.cellToPixel(x), Lib.cellToPixel(y), 0, 100, false,
//                 Tower.typeToString(newType), SpriteDisplay.TOWER_LAYER);
    var color = ShadowColor.BUILD_SITE;
    mShadow.changeColor(color);
    mShadow.update();
    return mShadow;
  }

  public function getShadow() : ui.TowerSprite
  {
    return mShadow;
  }

  public function clearShadow() : Void
  {
    if (mShadow != null)
    {
      mShadow.cleanup();
      mShadow = null;
    }
  }

  public function hasShadow() : Bool
  {
    return mShadow != null;
  }

  public function addRubble(payload : Resource, amount : Int,
                            ? frame : Null<Int>) : Void
  {
    if (mRubble == null)
    {
      mRubble = new Rubble(x, y);
    }
    mRubble.addResource(payload, amount, frame);
  }

  public function getRubble(needs : List<ResourceCount>) : Resource
  {
    var result = null;
    if (mRubble != null)
    {
      result = mRubble.getSalvage().getResource(needs);
      if (mRubble.getSalvage().getTotalCount() <= 0)
      {
        mRubble.cleanup();
        mRubble = null;
      }
    }
    if (result == null && mBuilding != null
        && mBackground == BackgroundType.ENTRANCE)
    {
      result = mBuilding.getSalvage().getResource(needs);
    }
    return result;
  }

  public function clearRubble() : Void
  {
    if (mRubble != null)
    {
      mRubble.cleanup();
      mRubble = null;
    }
  }

  public function hasRubble() : Bool
  {
    return mRubble != null
      || (mBuilding != null && mBackground == BackgroundType.ENTRANCE
          && mBuilding.getSalvage().getTotalCount() > 0);
  }

  public function getRubbleCount(payload : Resource) : Int
  {
    var result = 0;
    if (mRubble != null)
    {
      result += mRubble.getSalvage().getResourceCount(payload);
    }
    if (mBuilding != null && mBackground == BackgroundType.ENTRANCE)
    {
      result += mBuilding.getSalvage().getResourceCount(payload);
    }
    return result;
  }

  public function getAllRubbleCounts() : Array<Int>
  {
    var result = Lib.newResourceArray();
    for (i in 0...(Option.resourceCount))
    {
      result[i] = getRubbleCount(Lib.indexToResource(i));
    }
    return result;
  }

  public function setBuilding(newBuilding : Building) : Void
  {
    mBuilding = newBuilding;
  }

  public function getBuilding() : Building
  {
    return mBuilding;
  }

  public function buildingHasZombies() : Bool
  {
    return mBuilding != null && mBuilding.hasZombies();
  }

  public function getBackground() : BackgroundType
  {
    return mBackground;
  }

  public function setBackground(newBackground : BackgroundType) : Void
  {
    mBackground = newBackground;
  }

  function addScents() : Void
  {
    for (i in 0...(Lib.directions.length))
    {
      var destX = x + Lib.dirDeltas[i].x;
      var destY = y + Lib.dirDeltas[i].y;
      var toHere = mapgen.Util.opposite(Lib.directions[i]);
      Game.map.getCell(destX, destY).scent = toHere;
      scent = null;
    }
  }

  public function getScent() : Direction
  {
    return scent;
  }

  public function hasObstacle() : Bool
  {
    return obstacle != null;
  }

  public function removeObstacle() : Void
  {
    obstacle = null;
  }

  public function addObstacle(type : Int) : Void
  {
    obstacle = type;
  }

  public function getObstacle() : Null<Int>
  {
    return obstacle;
  }

  public static function save(current : MapCell) : Dynamic
  {
    var saveScent : Null<Int> = null;
    if (current.scent != null)
    {
      saveScent = Lib.directionToIndex(current.scent);
    }
    return { mTile : Save.saveList(current.mTile, Save.saveInt),
             mIsBlocked : current.mIsBlocked,
             // mTower is saved from ActorList
             x : current.x,
             y : current.y,
             // mZombies is saved from ActorList
             // mTrucks is saved from ActorList
             mShadow : Save.maybe(current.mShadow, ui.TowerSprite.saveS),
             mRubble : Save.maybe(current.mRubble, Rubble.save),
             // mBuilding is saved in building list
             mBackground : Lib.backgroundTypeToIndex(current.mBackground),
             scent : saveScent,
             feature : Save.maybe(current.mFeature, feature.Root.saveS) };
  }

  public function load(input : Dynamic) : Void
  {
    mTile = Load.loadList(input.mTile, Load.loadInt);
    mIsBlocked = input.mIsBlocked;
    x = input.x;
    y = input.y;
    mShadow = Load.maybe(input.mShadow, ui.TowerSprite.load);
    mRubble = Load.maybe(input.mRubble, Rubble.load);
    mBackground = Lib.indexToBackgroundType(input.mBackground);
    if (input.scent != null)
    {
      scent = Lib.indexToDirection(input.scent);
    }
    mFeature = Load.maybe(input.feature, feature.Root.loadS);
  }

  public function loadAddTower(newTower : Tower) : Void
  {
    mTower = newTower;
  }

  public function loadAddZombie(newZombie : Zombie) : Void
  {
    mZombies.add(newZombie);
  }

  public function loadAddTruck(newTruck : Truck) : Void
  {
    mTrucks.add(newTruck);
  }

  var mTile : List<Int>;
  var mIsBlocked : Bool;
  var mTower : Tower;
  var x : Int;
  var y : Int;
  var mZombies : List<Zombie>;
  var mTrucks : List<Truck>;
  var mShadow : ui.TowerSprite;
  var mRubble : Rubble;
  var mBuilding : Building;
  var mBackground : BackgroundType;

  var scent : Direction;
  var obstacle : Null<Int>;
  public var mFeature : feature.Root;
  public var edit : mapgen.EditBox;
}
