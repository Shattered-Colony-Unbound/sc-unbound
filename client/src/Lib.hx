class Lib
{
  private static var generator = new mtprng.MT();

  public static function reseed(seed : Array<UInt>)
  {
    generator = mtprng.MT.makeFromArray(seed);
  }

  public static function rand(num : Int) : Int
  {
    return generator.randomUInt() % num;
  }

  public static function shuffle<T>(list : Array<T>,
                                    ? optGen : mtprng.MT) : Void
  {
    var gen = optGen;
    if (gen == null)
    {
      gen = generator;
    }
    var j = list.length - 1;
    while (j > 0)
    {
      var k = gen.randomUInt()%(j+1);
      var temp = list[j];
      list[j] = list[k];
      list[k] = temp;
      --j;
    }
  }

  public static function randWeightedIndex(weights : Array<Int>,
                                           ? optGen : mtprng.MT) : Int
  {
    var gen = optGen;
    if (gen == null)
    {
      gen = generator;
    }
    var total = 0;
    for (pos in weights)
    {
      total += pos;
    }
    var choice = gen.randomUInt()%total;
    return weightedIndex(choice, weights);
  }

  public static function weightedIndex(num : Int, weights : Array<Int>) : Int
  {
    var result = 0;
    for (i in 0...(weights.length))
    {
      num -= weights[i];
      if (num < 0)
      {
        result = i;
        break;
      }
    }
    return result;
  }

  public static function randDirection(? optGen : mtprng.MT) : Direction
  {
    var gen = optGen;
    if (gen == null)
    {
      gen = generator;
    }
    var choice = gen.randomUInt()%4;
    if (choice == 0)
    {
      return Direction.NORTH;
    }
    else if (choice == 1)
    {
      return Direction.SOUTH;
    }
    else if (choice == 2)
    {
      return Direction.EAST;
    }
    else
    {
      return Direction.WEST;
    }
  }

  public static function intAbs(num : Int) : Int
  {
    if (num > 0)
    {
      return num;
    }
    else
    {
      return -num;
    }
  }

  public static function slopeToAngle(deltaX : Float, deltaY : Float) : Int
  {
    return Math.round(Math.atan2(deltaY, deltaX) * 180 / Math.PI);
  }

  public static function cellToPixel(coord : Int) : Int
  {
    return coord * Option.cellPixels;
  }

  public static function pixelToCell(coord : Int) : Int
  {
    return Math.floor(coord / Option.cellPixels);
  }

  public static function resourceToIndex(payload : Resource) : Int
  {
    var result = 0;
    switch (payload)
    {
    case AMMO:
      result = 0;
    case BOARDS:
      result = 1;
    case FOOD:
      result = 2;
    case SURVIVORS:
      result = 3;
    }
    return result;
  }

  public static function indexToResource(index : Int) : Resource
  {
    var result : Resource = null;
    if (index == 0)
    {
      result = Resource.AMMO;
    }
    else if (index == 1)
    {
      result = Resource.BOARDS;
    }
    else if (index == 2)
    {
      result = Resource.FOOD;
    }
    else if (index == 3)
    {
      result = Resource.SURVIVORS;
    }
    return result;
  }

  public static function resourceToString(payload : Resource) : String
  {
    var result = ui.Text.ammoLabel;
    switch(payload)
    {
    case AMMO:
      result = ui.Text.ammoLabel;
    case BOARDS:
      result = ui.Text.boardsLabel;
    case FOOD:
      result = ui.Text.foodLabel;
    case SURVIVORS:
      result = ui.Text.survivorsLabel;
    }
    return result;
  }

  public static function directionToIndex(dir : Direction) : Int
  {
    var result = 0;
    switch (dir)
    {
    case NORTH:
      result = 0;
    case SOUTH:
      result = 1;
    case EAST:
      result = 2;
    case WEST:
      result = 3;
    }
    return result;
  }

  public static function indexToDirection(index : Int) : Direction
  {
    var result = Direction.NORTH;
    switch (index)
    {
    case 0:
      result = Direction.NORTH;
    case 1:
      result = Direction.SOUTH;
    case 2:
      result = Direction.EAST;
    case 3:
      result = Direction.WEST;
    default:
      result = Direction.NORTH;
    }
    return result;
  }

  public static function directionToString(dir : Direction) : String
  {
    var result = ui.Text.northLabel;
    switch (dir)
    {
    case NORTH:
      result = ui.Text.northLabel;
    case SOUTH:
      result = ui.Text.southLabel;
    case EAST:
      result = ui.Text.eastLabel;
    case WEST:
      result = ui.Text.westLabel;
    }
    return result;
  }

  public static function directionToAngle(dir : Direction) : Int
  {
    var result = 0;
    switch (dir)
    {
/*
    case NORTH:
      result = 90;
    case SOUTH:
      result = -90;
    case EAST:
      result = 0;
    case WEST:
      result = 180;
*/
    case NORTH:
      result = 90;
    case SOUTH:
      result = -90;
    case EAST:
      result = 180;
    case WEST:
      result = 0;
    }
    return result;
  }

  public static var directions = [Direction.NORTH, Direction.SOUTH,
                                  Direction.EAST, Direction.WEST];

  public static var dirDeltas = [new Point(0, -1),
                                 new Point(0, 1),
                                 new Point(1, 0),
                                 new Point(-1, 0)];

  public static function directionToDelta(dir : Direction) : Point
  {
    return dirDeltas[directionToIndex(dir)];
  }

  public static function rotateCW(dir : Direction) : Direction
  {
    var result = Direction.NORTH;
    switch (dir)
    {
    case NORTH:
      result = Direction.EAST;
    case SOUTH:
      result = Direction.WEST;
    case EAST:
      result = Direction.SOUTH;
    case WEST:
      result = Direction.NORTH;
    }
    return result;
  }

  public static function rotateCCW(dir : Direction) : Direction
  {
    var result = Direction.NORTH;
    switch (dir)
    {
    case NORTH:
      result = Direction.WEST;
    case SOUTH:
      result = Direction.EAST;
    case EAST:
      result = Direction.NORTH;
    case WEST:
      result = Direction.SOUTH;
    }
    return result;
  }

  public static function backgroundTypeToIndex(type : BackgroundType) : Int
  {
    var result = 0;
    switch (type)
    {
    case BUILDING:
      result = 0;
    case ENTRANCE:
      result = 1;
    case PARK:
      result = 2;
    case STREET:
      result = 3;
    case ALLEY:
      result = 4;
    case BRIDGE:
      result = 5;
    case WATER:
      result = 6;
    case EDGE:
      result = 7;
    }
    return result;
  }

  public static function indexToBackgroundType(index : Int) : BackgroundType
  {
    var result = BackgroundType.BUILDING;
    switch (index)
    {
    case 0:
      result = BackgroundType.BUILDING;
    case 1:
      result = BackgroundType.ENTRANCE;
    case 2:
      result = BackgroundType.PARK;
    case 3:
      result = BackgroundType.STREET;
    case 4:
      result = BackgroundType.ALLEY;
    case 5:
      result = BackgroundType.BRIDGE;
    case 6:
      result = BackgroundType.WATER;
    default:
      result = BackgroundType.STREET;
    }
    return result;
  }

  public static function shadowColorToIndex(color : ShadowColor) : Int
  {
    var result = 0;
    switch (color)
    {
    case NORMAL:
      result = 0;
    case ALLOWED:
      result = 1;
    case FORBIDDEN:
      result = 2;
    case BUILD_SITE:
      result = 3;
    }
    return result;
  }

  public static function indexToShadowColor(index : Int) : ShadowColor
  {
    var result = ShadowColor.NORMAL;
    switch (index)
    {
    case 0:
      result = ShadowColor.NORMAL;
    case 1:
      result = ShadowColor.ALLOWED;
    case 2:
      result = ShadowColor.FORBIDDEN;
    case 3:
      result = ShadowColor.BUILD_SITE;
    default:
      result = ShadowColor.NORMAL;
    }
    return result;
  }

  public static function newResourceArray() : Array<Int>
  {
    var result = [];
    for (i in 0...(Option.resourceCount))
    {
      result.push(0);
    }
    return result;
  }

  static public function nearestZombie(sourceX : Int, sourceY : Int,
                                       range : Int) : Point
  {
    var point : Point = new Point(0, 0);
    for (i in 1...(range + 1))
    {
      for (j in (-i)...(i))
      {
        point.y = sourceY + j;

        point.x = sourceX - i;
        if (hasZombies(point))
        {
          return point;
        }
        point.x = sourceX + i;
        if (hasZombies(point))
        {
          return point;
        }

        //------------
        point.x = sourceX + j;

        point.y = sourceY - i;
        if (hasZombies(point))
        {
          return point;
        }

        point.y = sourceY + i;
        if (hasZombies(point))
        {
          return point;
        }
      }
    }
    return null;
  }

  static private function hasZombies(pos : Point) : Bool
  {
    return ! outsideMap(pos)
      && Game.map.getCell(pos.x, pos.y).hasZombies();
  }

  static public function outsideMap(point : Point) : Bool
  {
    return point.x < 0 || point.x >= Game.map.sizeX()
      || point.y < 0 || point.y >= Game.map.sizeY();
  }

  static public function adjacentZombie(pos : Point) : Bool
  {
    var result = false;
    result = result || Game.map.getCell(pos.x, pos.y).hasZombies();
    for (dir in delta)
    {
      var current = new Point(pos.x + dir.x, pos.y + dir.y);
      if (! outsideMap(current))
      {
        result = result || Game.map.getCell(current.x, current.y).hasZombies();
      }
    }
    return result;
  }

  static public var delta = [new Point(-1, 0), new Point(1, 0),
                             new Point(0, -1), new Point(0, 1)];

  static public function truckLoad(payload : Resource) : Int
  {
    if (payload == Resource.SURVIVORS)
    {
      return 1;
    }
    else
    {
      return Option.truckLoad;
    }
  }

  // Get the color of a building based on how many zombies are in it.
  static public function zombieColor(count : Int) : Int
  {
    var result = Option.emptyBuildingMiniColor;
    if (count > 0)
    {
      var index = weightedIndex(count, Option.zombieBuildingMiniWeights);
      result = Option.zombieBuildingMiniColor[index];
    }
    return result;
  }

  static public var survivorLoad =
    new ResourceCount(Resource.SURVIVORS,
                      truckLoad(Resource.SURVIVORS));
  static public var ammoLoad =
    new ResourceCount(Resource.AMMO,
                      truckLoad(Resource.AMMO));
  static public var boardLoad =
    new ResourceCount(Resource.BOARDS,
                      truckLoad(Resource.BOARDS));
  static public var foodLoad =
    new ResourceCount(Resource.FOOD,
                      truckLoad(Resource.FOOD));

  static public var resource = [Resource.AMMO, Resource.BOARDS,
                                Resource.FOOD, Resource.SURVIVORS];
  static public var resourceLoad = [ammoLoad, boardLoad,
                                    foodLoad, survivorLoad];

  static public function trace(arg : Dynamic) : Void
  {
    native.NativeBase.nativeTrace(arg);
  }

  static public function getAngle(source : Point, dest : Point) : Int
  {
    var radians = Math.atan2(source.y - dest.y, source.x - dest.x);
    return Math.round(radians * 180 / Math.PI);
  }

  static public function getOffset(first : Point, second : Point) : Point
  {
    return new Point(Math.floor(Math.min(first.x, second.x)),
                     Math.floor(Math.min(first.y, second.y)));
  }

  static public function getLimit(first : Point, second : Point) : Point
  {
    return new Point(Math.floor(Math.max(first.x, second.x)) + 1,
                     Math.floor(Math.max(first.y, second.y)) + 1);
  }
}
