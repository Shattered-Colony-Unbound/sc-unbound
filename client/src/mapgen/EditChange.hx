package mapgen;

class EditChange
{
  public static function canAddLevel(pos : Point) : Bool
  {
    var tower = Game.map.getCell(pos.x, pos.y).getTower();
    return (tower != null && tower.canUpgrade());
  }

  public static function addLevel(pos : Point) : Void
  {
    if (canAddLevel(pos))
    {
      var tower = Game.map.getCell(pos.x, pos.y).getTower();
      tower.upgradeLevel();
    }
  }

  public static function canRemoveLevel(pos : Point) : Bool
  {
    var tower = Game.map.getCell(pos.x, pos.y).getTower();
    return (tower != null && tower.canDowngrade());
  }

  public static function removeLevel(pos : Point) : Void
  {
    if (canRemoveLevel(pos))
    {
      var tower = Game.map.getCell(pos.x, pos.y).getTower();
      tower.downgrade();
    }
  }

  public static function canAddResource(pos : Point) : Bool
  {
    var cell = Game.map.getCell(pos.x, pos.y);
    var rubble = (cell.hasRubble()
                  && cell.getBackground() != BackgroundType.ENTRANCE);
    return (rubble || cell.hasTower());
  }

  // amount is in truck loads
  public static function addResource(pos : Point, payload : Resource,
                                     amount : Int) : Void
  {
    if (canAddResource(pos))
    {
      if (Game.map.getCell(pos.x, pos.y).hasTower())
      {
        addResourceTower(pos, payload, amount);
      }
      else
      {
        addResourceRubble(pos, payload, amount);
      }
    }
  }

  // amount is in truck loads
  public static function addResourceRubble(pos : Point, payload : Resource,
                                           amount : Int,
                                           ? frame : Null<Int>) : Void
  {
    var cell = Game.map.getCell(pos.x, pos.y);
    if (cell.hasRubble())
    {
      cell.addRubble(payload, amount * Lib.truckLoad(payload), frame);
    }
  }

  // amount is in truck loads
  public static function addResourceTower(pos : Point, payload : Resource,
                                          amount : Int) : Void
  {
    var tower = Game.map.getCell(pos.x, pos.y).getTower();
    if (tower != null)
    {
      if (payload == Resource.SURVIVORS)
      {
        for (i in 0...amount)
        {
          var type = mapgen.Util.rand(ui.Animation.carryAmmo.getTypeCount());
          tower.giveSurvivor(type);
        }
      }
      else
      {
        var resourceLoad = new ResourceCount(payload,
                                             amount * Lib.truckLoad(payload));
        tower.giveResource(resourceLoad);
      }
    }
  }

  public static function canCreateRubble(pos : Point) : Bool
  {
    var cell = Game.map.getCell(pos.x, pos.y);
    return (! cell.isBlocked() && ! cell.hasTower() && ! cell.hasRubble()
            && cell.getBackground() != BackgroundType.ENTRANCE);
  }

  public static function createRubble(pos : Point,
                                      ? resources : Array<Int>) : Void
  {
    if (EditChange.canCreateRubble(pos))
    {
//      Util.seed(Game.settings.getNormalName(), pos, pos);
      var frame = Util.randWeightedIndex(Parameter.rubbleWeight);
      Game.map.getCell(pos.x, pos.y).addRubble(Resource.AMMO, 0);
      if (resources != null)
      {
        for (i in 0...resources.length)
        {
          addResourceRubble(pos, Lib.indexToResource(i), resources[i], frame);
        }
      }
    }
  }

  public static function canAddZombie(pos : Point) : Bool
  {
    var cell = Game.map.getCell(pos.x, pos.y);
    return (! cell.isBlocked() && ! cell.hasTower()
            && cell.getBackground() != BackgroundType.ENTRANCE);
  }

  public static function addZombie(pos : Point, count : Int) : Void
  {
    if (canAddZombie(pos))
    {
      var max = Math.round(Math.abs(count));
      for (i in 0...max)
      {
        if (count > 0)
        {
          Util.forcePlaceZombie(pos.x, pos.y);
        }
        else
        {
          var cell = Game.map.getCell(pos.x, pos.y);
          var zombie = cell.getZombie();
          if (zombie != null)
          {
            cell.removeZombie(zombie);
            zombie.cleanup();
          }
        }
      }
    }
  }

  public static function canCreateTower(pos : Point, type : Int) : Bool
  {
    return Tower.canPlace(type, pos.x, pos.y, true);
  }

  public static function createTower(pos : Point, type : Int,
                                     ? upgrade : Null<Int>,
                                     ? stock : Array<Int>,
                                     ? quota : Array<Int>) : Void
  {
    if (canCreateTower(pos, type))
    {
      var cell = Game.map.getCell(pos.x, pos.y);
      cell.createTower(type);
      var tower = cell.getTower();
      while (upgrade != null && tower.getLevel() < upgrade
             && tower.canUpgrade())
      {
        tower.upgradeLevel();
      }
      if (stock != null && quota != null)
      {
        for (i in 0...Option.resourceCount)
        {
          var payload = Lib.indexToResource(i);
          addResourceTower(pos, payload, stock[i]);
          var currentStock = tower.countReserve(payload);
          var newStock = Lib.truckLoad(payload) * quota[i];
          tower.addReserve(new ResourceCount(payload,
                                             newStock - currentStock));
        }
      }
    }
  }

  public static function canRemove(pos : Point) : Bool
  {
    var cell = Game.map.getCell(pos.x, pos.y);
    return ((cell.hasRubble()
             && cell.getBackground() != BackgroundType.ENTRANCE)
            || cell.hasTower()
            || cell.hasObstacle());
  }

  public static function remove(pos : Point) : Void
  {
    if (canRemove(pos))
    {
      var cell = Game.map.getCell(pos.x, pos.y);
      if (cell.hasTower())
      {
        cell.destroyTower();
      }
      else if (cell.hasRubble())
      {
        cell.clearRubble();
      }
      else if (cell.hasObstacle())
      {
        cell.removeObstacle();
      }
    }
  }

  public static function canAddObstacle(pos : Point) : Bool
  {
    var cell = Game.map.getCell(pos.x, pos.y);
    return (! cell.isBlocked() && ! cell.hasRubble() && ! cell.hasObstacle()
            && ! cell.hasZombies() && ! cell.hasTower()
            && cell.getBackground() != BackgroundType.ENTRANCE
            && cell.getBackground() != BackgroundType.BUILDING);
  }

  public static function addObstacle(pos : Point, ? optType : Null<Int>) : Void
  {
    var type = Tile.OBSTACLE_START;
    if (optType != null)
    {
      type = optType;
    }
    if (canAddObstacle(pos))
    {
      var cell = Game.map.getCell(pos.x, pos.y);
      cell.addObstacle(type);
    }
  }

  public static function canChangeObstacle(pos : Point) : Bool
  {
    var cell = Game.map.getCell(pos.x, pos.y);
    return cell.hasObstacle();
  }

  public static function changeObstacle(pos : Point) : Void
  {
    if (canChangeObstacle(pos))
    {
      var cell = Game.map.getCell(pos.x, pos.y);
      var current = cell.getObstacle();
      var next = (current + 1) % Tile.obstacles.length;
      cell.removeObstacle();
      cell.addObstacle(next);
    }
  }
}
