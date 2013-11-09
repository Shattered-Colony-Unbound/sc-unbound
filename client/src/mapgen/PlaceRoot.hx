package mapgen;

class PlaceRoot
{
  public static var NORTHEAST = 0;
  public static var NORTHWEST = 1;
  public static var SOUTHEAST = 2;
  public static var SOUTHWEST = 3;
  public static var CORNER_COUNT = 4;

  static function lessCorner(dir : Direction) : Int
  {
    var result = NORTHWEST;
    switch (dir)
    {
    case Direction.NORTH:
      result = NORTHWEST;
    case Direction.SOUTH:
      result = SOUTHWEST;
    case Direction.EAST:
      result = NORTHEAST;
    case Direction.WEST:
      result = NORTHWEST;
    }
    return result;
  }

  static function greaterCorner(dir : Direction) : Int
  {
    var result = NORTHEAST;
    switch (dir)
    {
    case Direction.NORTH:
      result = NORTHEAST;
    case Direction.SOUTH:
      result = SOUTHEAST;
    case Direction.EAST:
      result = SOUTHEAST;
    case Direction.WEST:
      result = SOUTHWEST;
    }
    return result;
  }

  static function clockwiseCorner(dir : Direction) : Int
  {
    var result = NORTHEAST;
    switch (dir)
    {
    case Direction.NORTH:
      result = NORTHEAST;
    case Direction.SOUTH:
      result = SOUTHWEST;
    case Direction.EAST:
      result = SOUTHEAST;
    case Direction.WEST:
      result = NORTHWEST;
    }
    return result;
  }

  public static function cornerToVert(cornerDir : Int) : Direction
  {
    if (cornerDir == NORTHEAST || cornerDir == NORTHWEST)
    {
      return Direction.NORTH;
    }
    else
    {
      return Direction.SOUTH;
    }
  }

  public static function cornerToHoriz(cornerDir : Int) : Direction
  {
    if (cornerDir == NORTHEAST || cornerDir == SOUTHEAST)
    {
      return Direction.EAST;
    }
    else
    {
      return Direction.WEST;
    }
  }

  static var oppositeCornerTable = [SOUTHWEST, SOUTHEAST,
                                    NORTHWEST, NORTHEAST];

  public static function oppositeCorner(cornerDir : Int) : Int
  {
    return oppositeCornerTable[cornerDir];
  }

  static var NORTH = 0;
  static var SOUTH = 1;
  static var EAST = 2;
  static var WEST = 3;
}
