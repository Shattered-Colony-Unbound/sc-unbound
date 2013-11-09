package mapgen;

class BuildingPlant extends BuildingRoot
{
  public function new(newBuilding : Building,
                      ? newIgnoreStreets : Null<Bool>) : Void
  {
    super(newBuilding);
    ignoreStreets = false;
    if (newIgnoreStreets == true)
    {
      ignoreStreets = true;
    }
  }

  static var colors = [0, 5, 10];

  static var corners =
    [
      // NORTHEAST
      464,
      // NORTHWEST
      462,
      // SOUTHEAST
      504,
      // SOUTHWEST
      502
      ];

  static var BEGIN_SHRUB = 0;
  static var END_SHRUB = 1;
  static var DOUBLE_SHRUB = 2;
  static var SINGLE_SHRUB = 3;
  static var NARROW_ENTRANCE = 4;
  static var WIDE_ENTRANCE = 5;
  static var SIMPLE = 6;

  static var edgeWeights = [1, 0, 1, 1, 0, 0, 6];

  static var edges =
    [
      // NORTH
      [522, 523, 524, 562, 563, 564, 463],
      // SOUTH
      [542, 543, 544, 582, 583, 584, 503],
      // EAST
      [461, 481, 501, 521, 541, 561, 484],
      // WEST
      [460, 480, 500, 520, 540, 560, 482]
      ];

  static var center = 483;

  override function placeCorner(dest : Point, dir : Int,
                                vertical : Street, horizontal : Street,
                                color : Int) : Void
  {
    Util.addTile(dest, corners[dir] + colors[color]);
    Util.addRoofOverlay(dest, Tile.cornerRoof);
  }

  override function placeEdge(lot : Section, dir : Int, street : Street,
                              color : Int) : Void
  {
    var prev = SIMPLE;
    for (y in (lot.offset.y)...(lot.limit.y))
    {
      for (x in (lot.offset.x)...(lot.limit.x))
      {
        var dest = new Point(x, y);
        var isLast = (y == lot.limit.y - 1 && x == lot.limit.x - 1);
        prev = findEdge(dest, building.getEntrance(), prev, street, isLast);
        var tile = edges[dir][prev] + colors[color];
        Util.addTile(dest, tile);
        if (prev == SIMPLE)
        {
          Util.addRoofOverlay(dest, Tile.edgeRoof[dir]);
        }
      }
    }
  }

  function findEdge(dest : Point, entrance : Point, prev : Int,
                    street : Street, isLast : Bool) : Int
  {
    var result = SIMPLE;
    if (Point.isEqual(dest, entrance))
    {
      result = NARROW_ENTRANCE + Util.rand(2);
    }
    else if (prev == BEGIN_SHRUB)
    {
      result = END_SHRUB;
    }
    else if (prev == NARROW_ENTRANCE || prev == WIDE_ENTRANCE
             && (street != null || ignoreStreets))
    {
      result = Util.randWeightedIndex(edgeWeights);
      if (result != BEGIN_SHRUB)
      {
        result = SIMPLE;
      }
    }
    else if (Point.isAdjacent(dest, entrance))
    {
      result = SIMPLE;
    }
    else if (prev == SIMPLE && (street != null || ignoreStreets))
    {
      result = Util.randWeightedIndex(edgeWeights);
    }
    else
    {
      result = SIMPLE;
    }

    if (isLast && result == BEGIN_SHRUB)
    {
      result = SIMPLE;
    }
    return result;
  }

  override function placeMiddle(lot : Section, color : Int) : Void
  {
    Util.fillAddTile(lot, center + colors[color]);
    for (y in (lot.offset.y)...(lot.limit.y))
    {
      for (x in (lot.offset.x)...(lot.limit.x))
      {
        Util.addRoofOverlay(new Point(x, y), Tile.centerRoof);
      }
    }
  }

  override function getColorCount() : Int
  {
    return colors.length;
  }

  var ignoreStreets : Bool;
}
