class Barricade extends Tower
{
  static var BOARDS = Resource.BOARDS;

  public function new(newX : Int, newY : Int) : Void
  {
    type = Tower.BARRICADE;
    super(new Point(newX, newY),
          Option.barricadeLevelLimit, Option.barricadeSpeed,
          Option.barricadeCost);
    updateCanTakeHit();
    addReserve(Lib.boardLoad);
  }

  override public function step(count : Int) : Void
  {
    if (stuff.count(Resource.SURVIVORS) > 0
        && stuff.count(Resource.BOARDS) > 0)
    {
      if (stuff.reserve(Resource.BOARDS) > 0)
      {
        sendToDepot(true);
      }
      else
      {
        sendToDepot(false);
      }
      updateCanTakeHit();
    }
    else if (stuff.count(Resource.SURVIVORS) > 0
             && stuff.count(Resource.BOARDS) == 0)
    {
      Game.view.window.refresh();
      Game.actions.push(new action.CloseTower(mapPos.x, mapPos.y));
    }
    updateReserve();
  }

  override public function attack() : Bool
  {
    var result = true;
    if (countResource(BOARDS) >= Option.barricadeHitCost)
    {
      Main.sound.play(SoundPlayer.ZOMBIE_BASH);
      takeResource(new ResourceCount(BOARDS,
                                     Option.barricadeHitCost));
      result = false;
    }
    else
    {
      result = super.attack();
    }
    updateCanTakeHit();
    return result;
  }

  override public function getType() : Int
  {
    return Tower.BARRICADE;
  }

  override public function giveResource(payload : ResourceCount) : Void
  {
    super.giveResource(payload);
    updateCanTakeHit();
  }

  override public function updateBlocked() : Void
  {
    var finalDir : Direction = getProtectedDir();
    if (finalDir == null)
    {
      finalDir = getSupplyDir();
    }
    if (finalDir == null)
    {
      finalDir = getUnblockedDir();
    }
    if (finalDir == null)
    {
      finalDir = Direction.NORTH;
    }
    sprite.rotate(Lib.directionToAngle(finalDir) - 90);
    sprite.update();
  }

  function updateReserve() : Void
  {
    var reserve = stuff.reserve(Resource.BOARDS);
    var count = stuff.count(Resource.BOARDS);
    if (reserve == 0
        || reserve <= count - Lib.truckLoad(Resource.BOARDS))
    {
      if (stuff.reserve(Resource.SURVIVORS) == 0)
      {
        addReserve(Lib.survivorLoad);
      }
    }
    else
    {
      if (stuff.reserve(Resource.SURVIVORS) > 0)
      {
        removeReserve(Lib.survivorLoad);
      }
    }
  }

  function getProtectedDir() : Direction
  {
    var result = null;
    var protectedDirs = getProtectedList();
    for (dir in protectedDirs)
    {
      var opposite = mapgen.Util.opposite(dir);
      if (! isBlocked(opposite))
      {
        result = opposite;
        break;
      }
    }
    return result;
  }

  function getProtectedList() : List<Direction>
  {
    var result = new List<Direction>();
    for (dir in Lib.directions)
    {
      var delta = Lib.directionToDelta(dir);
      var x = mapPos.x + delta.x;
      var y = mapPos.y + delta.y;
      var tower = Game.map.getCell(x, y).getTower();
      if (tower != null
          && tower.getType() != Tower.BARRICADE)
      {
        result.add(dir);
      }
    }
    return result;
  }

  function getSupplyDir() : Direction
  {
    var result = null;
    if (! links.isEmpty())
    {
      var supplierPos = links.first().dest;
      var diffX = mapPos.x - supplierPos.x;
      var dirX = Direction.EAST;
      if (diffX < 0)
      {
        dirX = Direction.WEST;
      }
      var diffY = mapPos.y - supplierPos.y;
      var dirY = Direction.SOUTH;
      if (diffY < 0)
      {
        dirY = Direction.NORTH;
      }
      if (isBlocked(dirX) && ! isBlocked(dirY))
      {
        result = dirY;
      }
      else if (! isBlocked(dirX) && isBlocked(dirY))
      {
        result = dirX;
      }
      else if (! isBlocked(dirX) && ! isBlocked(dirY))
      {
        if (Math.abs(diffX) > Math.abs(diffY))
        {
          result = dirX;
        }
        else if (Math.abs(diffX) == Math.abs(diffY))
        {
          result = dirX;
        }
        else if (Math.abs(diffX) < Math.abs(diffY))
        {
          result = dirY;
        }
      }
    }
    return result;
  }

  function getUnblockedDir() : Direction
  {
    var result = null;
    for (dir in Lib.directions)
    {
      if (! isBlocked(dir))
      {
        result = dir;
        break;
      }
    }
    return result;
  }

  function isBlocked(dir : Direction) : Bool
  {
    var delta = Lib.directionToDelta(dir);
    var posX = mapPos.x + delta.x;
    var posY = mapPos.y + delta.y;
    var cell = Game.map.getCell(posX, posY);
    return cell.isBlocked() || cell.hasTower();
  }

  private function updateCanTakeHit() : Void
  {
    var canOperate = countResource(BOARDS) >= Option.barricadeHitCost;
    sprite.changeCanOperate(canOperate);
    sprite.update();
  }

  override public function saveTower() : Dynamic
  {
    return { parent : super.saveTowerGeneric() };
  }

  override public function load(input : Dynamic) : Void
  {
    super.load(input.parent);
  }
}
