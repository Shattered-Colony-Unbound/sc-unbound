package logic;

class Bridge
{
  public function new(newDir : Direction, newLot : mapgen.Section,
                      newIsBroken : Bool) : Void
  {
    lot = new mapgen.Section(newLot.offset, newLot.limit);
    dir = newDir;
    spawnArea = lot.center().slice(mapgen.Util.opposite(dir), 1);
    isBroken = newIsBroken;
  }

  public function cleanup() : Void
  {
  }

  public function destroy() : Void
  {
    isBroken = true;
    Game.progress.destroyBridge(this);
    for (y in (lot.offset.y)...(lot.limit.y))
    {
      for (x in (lot.offset.x)...(lot.limit.x))
      {
        var cell = Game.map.getCell(x, y);
        while (cell.hasZombies())
        {
          var zombie = cell.getZombie();
          zombie.removeFromMap();
          zombie.cleanup();
        }
        cell.setBlocked();
        cell.setBackground(BackgroundType.WATER);
        Game.view.mini.updateCell(x, y);
      }
    }
    var place = new mapgen.PlaceBridge(dir, isBroken);
    place.place(lot);
    Game.view.window.fillRegion(lot.offset, lot.limit);
    Game.spawner.reduceZombies();
    Game.sprites.recalculateFov();
    Main.replay.addBox(lot.offset, lot.limit, Option.waterColor);
  }

  public function spawnPos() : Point
  {
    var xDelta = Lib.rand(spawnArea.limit.x - spawnArea.offset.x);
    var yDelta = Lib.rand(spawnArea.limit.y - spawnArea.offset.y);
    return new Point(spawnArea.offset.x + xDelta,
                     spawnArea.offset.y + yDelta);
  }

  public function spawnDir() : Direction
  {
    return dir;
  }

  public function explosionDir() : Direction
  {
    return mapgen.Util.opposite(dir);
  }

  public function getOffset() : Point
  {
    return lot.offset;
  }

  public function getLot() : mapgen.Section
  {
    return lot;
  }

  public function clear() : Void
  {
    mapgen.Util.fillClearTiles(lot);
  }

  function calculateFrame() : Int
  {
    var result = Lib.directionToIndex(dir) + 1;
    if (isBroken)
    {
      result += 4;
    }
    return result;
  }

  public static function saveS(current : Bridge) : Dynamic
  {
    return current.save();
  }

  public function save() : Dynamic
  {
    return { dir : Lib.directionToIndex(dir),
        lot : mapgen.Section.save(lot),
        isBroken : isBroken };
  }

  public static function load(input : Dynamic) : Bridge
  {
    return new Bridge(Lib.indexToDirection(input.dir),
                      mapgen.Section.load(input.lot),
                      input.isBroken);

  }

  var dir : Direction;
  var lot : mapgen.Section;
  var spawnArea : mapgen.Section;
  var isBroken : Bool;

  static var bridgeRadius = Option.cellPixels*MapGenerator.waterCount;
}
