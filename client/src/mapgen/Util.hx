package mapgen;

class Util
{
  private static var generator : mtprng.MT = null;

  public static function rand(num : Int) : Int
  {
    return generator.randomUInt() % num;
  }

  public static function shuffle<T>(list : Array<T>) : Void
  {
    Lib.shuffle(list, generator);
  }

  public static function randWeightedIndex(weights : Array<Int>) : Int
  {
    return Lib.randWeightedIndex(weights, generator);
  }

  public static function randDirection() : Direction
  {
    return Lib.randDirection(generator);
  }

  public static function getNormal(name : String, difficulty : Int) : String
  {
    var a = "a".charCodeAt(0);
    var z = "z".charCodeAt(0);
    var zero = "0".charCodeAt(0);
    var nine = "9".charCodeAt(0);
    var base = name.toLowerCase() + Std.string(difficulty);
    var result = new StringBuf();
    for (i in 0...base.length)
    {
      var current = base.charCodeAt(i);
      if ((current >= a && current <= z)
          || (current >= zero && current <= nine))
      {
        result.addChar(current);
      }
    }
    return result.toString();
  }

  public static function seed(normalName : String, ? offset : Point,
                              ? limit : Point) : Void
  {
    var fullName = normalName;
    if (offset != null)
    {
      fullName += offset.toString();
    }
    if (limit != null)
    {
      fullName += limit.toString();
    }
    var seeds : Array<UInt>= [];
    var md5 = haxe.crypto.Md5.encode(fullName);
    for (i in 0...4)
    {
      var start = i*4;
      var hexBuf = "0x" + md5.substr(start, 4);
      var nextSeed = Std.parseInt(hexBuf);
      if (nextSeed == null)
      {
        Lib.trace("nextSeed is null: " + hexBuf);
      }
      else
      {
        seeds.push(nextSeed);
      }
    }
    generator = mtprng.MT.makeFromArray(seeds);
  }

  public static function addTile(pos : Point, tile : Int) : Void
  {
    Game.map.getCell(pos.x, pos.y).addTile(tile);
  }

  public static function addRandTile(pos : Point, tiles : Array<Int>) : Void
  {
    var choice = Util.rand(tiles.length);
    addTile(pos, tiles[choice]);
  }

  public static function clearTiles(pos : Point) : Void
  {
    Game.map.getCell(pos.x, pos.y).clearTiles();
  }

  public static function setBackground(pos : Point,
                                       background : BackgroundType) : Void
  {
    Game.map.getCell(pos.x, pos.y).setBackground(background);
  }

  public static function changeBlocked(pos : Point, blocked : Bool) : Void
  {
    if (blocked)
    {
      Game.map.getCell(pos.x, pos.y).setBlocked();
    }
    else
    {
      Game.map.getCell(pos.x, pos.y).clearBlocked();
    }
  }

  public static function setArea<T>(lot : Section, func : Point -> T -> Void,
                                    val : T) : Void
  {
    for (y in (lot.offset.y)...(lot.limit.y))
    {
      for (x in (lot.offset.x)...(lot.limit.x))
      {
        var pos = new Point(x, y);
        func(pos, val);
      }
    }
  }

  public static function fillAddTile(lot : Section, tile : Int) : Void
  {
    setArea(lot, addTile, tile);
  }

  public static function fillClearTiles(lot : Section) : Void
  {
    for (y in (lot.offset.y)...(lot.limit.y))
    {
      for (x in (lot.offset.x)...(lot.limit.x))
      {
        clearTiles(new Point(x, y));
      }
    }
  }

  // tiles is an array showing which tiles are on which borders and
  // the center like so:
  //
  // array = [nw, n, ne,
  //           w, c,  e,
  //          sw, s, se];
  public static function fillWithBorder(lot : Section, tiles : Array<Int>)
  {
    fillClearTiles(lot);

    // Corners
    addTile(lot.northwest(), tiles[0]);
    addTile(lot.northeast(), tiles[2]);
    addTile(lot.southwest(), tiles[6]);
    addTile(lot.southeast(), tiles[8]);

    // Edges
    fillAddTile(lot.edge(Direction.NORTH), tiles[1]);
    fillAddTile(lot.edge(Direction.WEST), tiles[3]);
    fillAddTile(lot.edge(Direction.EAST), tiles[5]);
    fillAddTile(lot.edge(Direction.SOUTH), tiles[7]);

    // Center
    if (tiles[4] != Tile.NO_TILE)
    {
      fillAddTile(lot.center(), tiles[4]);
    }
  }

  public static function fillBackground(lot : Section,
                                        background : BackgroundType) : Void
  {
    setArea(lot, setBackground, background);
  }

  public static function fillBlocked(lot : Section) : Void
  {
    setArea(lot, changeBlocked, true);
  }

  public static function fillUnblocked(lot : Section) : Void
  {
    setArea(lot, changeBlocked, false);
  }

  public static function fillChangeBlocked(lot : Section,
                                           blocked : Bool) : Void
  {
    setArea(lot, changeBlocked, blocked);
  }

  public static function opposite(dir : Direction) : Direction
  {
    var result = Direction.SOUTH;
    switch (dir)
    {
    case NORTH:
      result = Direction.SOUTH;
    case SOUTH:
      result = Direction.NORTH;
    case EAST:
      result = Direction.WEST;
    case WEST:
      result = Direction.EAST;
    }
    return result;
  }

  public static function blockRandom(lot : Section, tiles : Array<Array<Int>>,
                                     weights : Array<Int>) : Void
  {
    var area = (lot.limit.x - lot.offset.x)*(lot.limit.y - lot.offset.y);
    var trials = Math.floor(area/3);
    for (i in 0...trials)
    {
      var x = Util.rand(lot.limit.x - lot.offset.x) + lot.offset.x;
      var y = Util.rand(lot.limit.y - lot.offset.y) + lot.offset.y;
      if (Game.map.getCell(x, y).getTiles().length <= 1)
      {
        var dest = new Point(x, y);
        var choice = Util.randWeightedIndex(weights);
        addRandTile(dest, tiles[choice]);
        changeBlocked(dest, true);
      }
    }
  }

  public static function subdivide(lot : Section, minBuildingSize : Int,
                                   results : List<Section>) : Void
  {
      var div = new mapgen.Division(minBuildingSize);
      div.split(lot, 0);
      if (div.getLeft() == null || div.getRight() == null)
      {
        results.add(lot);
      }
      else
      {
        subdivide(div.getLeft(), minBuildingSize, results);
        subdivide(div.getRight(), minBuildingSize, results);
      }
  }

  public static function createBuilding(lot : Section,
                                        ? optionalType : Null<Int>,
                                        ? optionalEntranceDir : Direction)
  : Building
  {
    var type = chooseBuildingType(lot, optionalType);
    var building = new Building(type);

    var entranceDir = optionalEntranceDir;
    if (entranceDir == null)
    {
      entranceDir = chooseEntranceDir(lot);
    }

    var entrance = chooseEntrance(lot, entranceDir, type);

    if (type != POLICE_STATION)
    {
      building.addLot(lot);
      building.setEntrance(entrance, entranceDir);
    }

    if (type != PARKING_LOT)
    {
      Game.map.addBuilding(building);
      if (type != POLICE_STATION)
      {
        building.attach();
      }
    }
    return building;
  }

  static function chooseBuildingType(lot : Section, newType : Null<Int>) : Int
  {
    var type = STANDARD;
    if (newType == null)
    {
      if (lot.isNear(Game.settings.getStart(), Option.hqInfluence))
      {
        type = Util.randWeightedIndex(Option.hqBuildingDistribution);
      }
      else
      {
        if (Game.settings.getEasterEgg() == logic.GameSettings.CUMBERLAND
            && Util.rand(10) < 2)
        {
          type = HOSPITAL;
        }
        else
        {
          type = Util.randWeightedIndex(Option.buildingDistribution);
          if (type == STANDARD
              && Game.settings.getEasterEgg() == logic.GameSettings.RACCOONCITY)
          {
            type = Util.randWeightedIndex(Option.buildingDistribution);
          }
        }
      }
    }
    else
    {
      type = newType;
    }
    return type;
  }

  static function chooseEntranceDir(lot : Section) : Direction
  {
    var streets = [lot.north, lot.south, lot.east, lot.west];
    var dirs = [Direction.NORTH, Direction.SOUTH, Direction.EAST,
                Direction.WEST];
    var result = [];
    var maxWidth = 0;
    for (i in 0...(streets.length))
    {
      if (streets[i] != null)
      {
        if (streets[i].getWidth() > maxWidth)
        {
          while (result.length > 0)
          {
            result.pop();
          }
          maxWidth = streets[i].getWidth();
        }
        if (streets[i].getWidth() >= maxWidth)
        {
          result.push(i);
        }
      }
    }
    var index = result[Util.rand(result.length)];
    return dirs[index];
  }

  public static function calculateDir(entrance : Point,
                                      lot : Section) : Direction
  {
    var result = Direction.EAST;
    if (entrance != null)
    {
      if (entrance.x == lot.offset.x)
      {
        result = Direction.WEST;
      }
      else if (entrance.y == lot.offset.y)
      {
        result = Direction.NORTH;
      }
      else if (entrance.y == lot.limit.y - 1)
      {
        result = Direction.SOUTH;
      }
    }
    return result;
  }

  static var churchEntrances = [new Point(1, 0),
                                new Point(1, 2),
                                new Point(2, 1),
                                new Point(0, 1)];
  static var houseEntrances = [new Point(1, 0),
                               new Point(0, 1),
                               new Point(1, 1),
                               new Point(0, 0)];

  public static function chooseEntrance(lot : Section, dir : Direction,
                                 type : Int) : Point
  {
    var index = Lib.directionToIndex(dir);
    var delta = null;
    if (type == CHURCH)
    {
      delta = churchEntrances[index];
    }
    else if (type == HOUSE)
    {
      delta = houseEntrances[index];
    }
    else if (type == MALL)
    {
      delta = chooseRandEntrance(lot, dir, 2);
    }
    else
    {
      delta = chooseRandEntrance(lot, dir, 1);
    }
    return new Point(lot.offset.x + delta.x, lot.offset.y + delta.y);
  }

  static function chooseRandEntrance(lot : Section, dir : Direction,
                                     edgeDistance : Int) : Point
  {
    if (dir == Direction.NORTH)
    {
      return new Point(Util.rand(lot.limit.x - lot.offset.x - edgeDistance*2)
                       + edgeDistance, 0);
    }
    else if (dir == Direction.SOUTH)
    {
      return new Point(Util.rand(lot.limit.x - lot.offset.x - edgeDistance*2)
                       + edgeDistance,
                       lot.limit.y - lot.offset.y - 1);
    }
    else if (dir == Direction.EAST)
    {
      return new Point(lot.limit.x - lot.offset.x - 1,
                       Util.rand(lot.limit.y - lot.offset.y - edgeDistance*2)
                       + edgeDistance);
    }
    else // dir == Direction.EAST
    {
      return new Point(0, Util.rand(lot.limit.y - lot.offset.y - edgeDistance*2)
                       + edgeDistance);
    }
  }

  public static function drawBuilding(lot : Section,
                                      building : Building,
                                      ? optPlaceRubble : Bool) : Void
  {
    var placeRubble = true;
    if (optPlaceRubble == false)
    {
      placeRubble = false;
    }
    var type = building.getType();
    if (type == PARKING_LOT)
    {
      var parkingLot = new PlaceParkingLot();
      var ent = building.getEntrance();
      var dir = building.getEntranceDir();
      var newEntrance = null;
      if (ent.x == lot.limit.x - 1
          && (dir == Direction.NORTH || dir == Direction.SOUTH))
      {
        newEntrance = new Point(lot.offset.x, ent.y);
      }
      if (ent.y == lot.limit.y - 1
          && (dir == Direction.EAST || dir == Direction.WEST))
      {
        newEntrance = new Point(ent.x, lot.offset.y);
      }
      var entrances = new List<Point>();
      entrances.add(ent);
      if (newEntrance == null)
      {
        PlaceParkingLot.addCrossStreet(lot, ent, dir,
                                       CrossStreet.PARKING_ENTRANCE);
      }
      else
      {
        entrances.add(newEntrance);
        PlaceParkingLot.addCrossStreet(lot, newEntrance, dir,
                                       CrossStreet.BEGIN_PARKING_ENTRANCE);
        PlaceParkingLot.addCrossStreet(lot, ent, dir,
                                       CrossStreet.END_PARKING_ENTRANCE);
      }
      var perp = Lib.rotateCW(dir);
      var perpSize = lot.dirSize(perp);
      if (perpSize == 2 || perpSize == 3)
      {
        parkingLot.place(lot, entrances, placeRubble, Lib.rotateCW(dir));
      }
      else
      {
        parkingLot.place(lot, entrances, placeRubble, dir);
      }
    }
    else
    {
      var placement : BuildingRoot = null;

      if (type == CHURCH)
      {
        placement = new BuildingChurch(building);
      }
      else if (type == HOSPITAL)
      {
        placement = new BuildingHospital(building);
      }
      else if (type == HOUSE)
      {
        placement = new BuildingHouse(building);
      }
      else if (type == MALL)
      {
        placement = new BuildingMall(building, lot);
      }
      else if (type == HARDWARE_STORE)
      {
        placement = new BuildingHardware(building);
      }
      else if (type == POLICE_STATION)
      {
        placement = new BuildingPolice(building);
      }
      else
      {
        placement = new BuildingGeneric(building);
      }

      placement.place(lot);
    }
  }

  // Fill in any inaccessible little gaps generated by random obstacle
  // generation.
  public static function fillBlockedGaps(lot : Section) : Void
  {
    var offset = new Point(lot.offset.x, lot.offset.y);
    var size = new Point(lot.getSize().x, lot.getSize().y);
    var mark = new Grid<Bool>(size.x, size.y);
    for (y in 0...(size.y))
    {
      for (x in 0...(size.x))
      {
        mark.set(x, y, false);
      }
    }
    var queue = new List<Point>();
    setupGapQueue(lot, size, queue, mark);
    markGaps(offset, size, queue, mark);
    fillInGaps(offset, size, mark);
  }

  static function setupGapQueue(oldLot : Section, size : Point,
                                queue : List<Point>, mark : Grid<Bool>) : Void
  {
    var lot = oldLot.clone();
    lot.limit = oldLot.getSize();
    lot.offset = new Point(0, 0);
    for (dir in Lib.directions)
    {
      if (lot.getStreet(dir) != null)
      {
        var area = lot.edge(dir);
        for (y in (area.offset.y)...(area.limit.y))
        {
          for (x in (area.offset.x)...(area.limit.x))
          {
            addToGapQueue(new Point(x, y), queue, mark);
          }
        }
      }
    }
    if (lot.north != null || lot.west != null)
    {
      addToGapQueue(lot.northwest(), queue, mark);
    }
    if (lot.north != null || lot.east != null)
    {
      addToGapQueue(lot.northeast(), queue, mark);
    }
    if (lot.south != null || lot.west != null)
    {
      addToGapQueue(lot.southwest(), queue, mark);
    }
    if (lot.south != null || lot.east != null)
    {
      addToGapQueue(lot.southeast(), queue, mark);
    }
  }

  static function addToGapQueue(pos : Point, queue : List<Point>,
                                mark : Grid<Bool>) : Void
  {
    mark.set(pos.x, pos.y, true);
    queue.add(pos);
  }

  static function markGaps(offset : Point, size : Point, queue : List<Point>,
                           mark : Grid<Bool>) : Void
  {
    var delta = [new Point(0, -1), new Point(0, 1),
                 new Point(1, 0), new Point(-1, 0)];
    while (! queue.isEmpty())
    {
      var current = queue.pop();
      for (i in 0...4)
      {
        var x = current.x + delta[i].x;
        var y = current.y + delta[i].y;
        if (x >= 0 && x < size.x
            && y >= 0 && y < size.y
            && neitherTouchBlockedGap(x, y, offset, mark))
        {
          mark.set(x, y, true);
          queue.add(new Point(x, y));
        }
      }
    }
  }

  static function neitherTouchBlockedGap(x : Int, y : Int,
                                         offset : Point,
                                         mark : Grid<Bool>) : Bool
  {
    return (! mark.get(x, y) && ! Game.map.getCell(x + offset.x,
                                                   y + offset.y).isBlocked());
  }

  static function fillInGaps(offset, size, mark)
  {
    for (y in 1...(size.y - 1))
    {
      for (x in 1...(size.x - 1))
      {
        if (neitherTouchBlockedGap(x, y, offset, mark))
        {
          var pos = new Point(x + offset.x, y + offset.y);
          addRandTile(pos, Tile.trees);
          changeBlocked(pos, true);
        }
      }
    }
  }

  public static function addRoofOverlay(dest : Point,
                                        tiles : Array<Int>) : Void
  {
    if (rand(100) < Parameter.roofOverlayChance)
    {
      var index = rand(tiles.length);
      Util.addTile(dest, tiles[index]);
    }
  }


  public static function placeSingleSalvage(map : Map, x : Int, y : Int,
                                            ? biasResource : Resource)
  {
    var building = map.getCell(x, y).getBuilding();
    var distribution = Option.groundSalvageDistribution;
    if (building != null)
    {
      distribution = Option.salvageDistribution[building.getType()];
    }
    var index = randWeightedIndex(distribution);
    var payload = Lib.indexToResource(index);
    if (biasResource != null)
    {
      index = Lib.resourceToIndex(biasResource);
      payload = biasResource;
    }
    var count = Lib.truckLoad(payload);
    if (building != null)
    {
      building.getSalvage().addResource(payload, count);
    }
    else if (! map.getCell(x, y).isBlocked()
             && payload != Resource.SURVIVORS
             && ! map.getCell(x, y).hasTower())
    {
      var frame = randWeightedIndex(Parameter.rubbleWeight);
      map.getCell(x, y).addRubble(payload, count, frame);
    }
  }

  public static function placeSingleZombie(map : Map, x : Int, y : Int)
  {
    var start = Game.settings.getStart();
    var distX = Math.floor(Math.abs(x - start.x));
    var distY = Math.floor(Math.abs(y - start.y));
    if (distX > Option.hqInfluence || distY > Option.hqInfluence)
    {
      if (map.getCell(x, y).getBuilding() != null)
      {
        map.getCell(x, y).getBuilding().addZombies(1);
      }
      else if (! map.getCell(x, y).isBlocked())
      {
        forcePlaceZombie(x, y);
      }
    }
  }

  public static function forcePlaceZombie(x : Int, y : Int) : Void
  {
    var rotation = Lib.directionToAngle(mapgen.Util.randDirection());
    var newZombie = new Zombie(x, y, rotation, x, y, Zombie.START_SPAWN);
  }

  public static var STANDARD = 0;
  public static var APARTMENT = 1;
  public static var SUPERMARKET = 2;
  public static var POLICE_STATION = 3;
  public static var HARDWARE_STORE = 4;
  public static var CHURCH = 5;
  public static var HOSPITAL = 6;
  public static var MALL = 7;
  public static var HOUSE = 8;
  public static var PARKING_LOT = 9;
}
