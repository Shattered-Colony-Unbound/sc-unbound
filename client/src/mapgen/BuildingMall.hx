package mapgen;

class BuildingMall extends BuildingRoot
{
  public function new(newBuilding : Building, lot : Section)
  {
    super(newBuilding);
    center = new Point(0, 0);
    var offset = lot.offset;
    var limit = lot.limit;
    var entrance = newBuilding.getEntrance();
    if (entrance.x > offset.x && entrance.x < limit.x - 1)
    {
      center.x = entrance.x;
    }
    else
    {
      var xLimit = limit.x - offset.x - 4;
      center.x = Util.rand(xLimit) + offset.x + 2;
    }
    if (entrance.y > offset.y && entrance.y < limit.y - 1)
    {
      center.y = entrance.y;
    }
    else
    {
      var yLimit = limit.y - offset.y - 4;
      center.y = Util.rand(yLimit) + offset.y + 2;
    }
  }

  static var BEFORE = 0;
  static var BEGIN = 1;
  static var MIDDLE = 2;
  static var END = 3;
  static var AFTER = 4;

  static var corners = [745, 740, 845, 840];

  static var edges =
    [
      // NORTH
      [741, 742, 743, 744, 741],
      // SOUTH
      [841, 842, 843, 844, 841],
      // EAST
      [765, 785, 805, 825, 765],
      // WEST
      [760, 780, 800, 820, 760]
    ];

  // First index is north-to-south. Second index is west-to-east.
  static var centerTiles =
    [
      // BEFORE
      [761, 762, 763, 764, 761],
      // BEGIN
      [781, 782, 783, 784, 781],
      // MIDDLE
      [801, 802, 803, 804, 801],
      // END
      [821, 822, 823, 824, 821],
      // AFTER
      [761, 762, 763, 764, 761]
    ];

  override function placeCorner(dest : Point, dir : Int, vertical : Street,
                                horizontal : Street, color : Int) : Void
  {
    Util.addTile(dest, corners[dir]);
  }

  override function placeEdge(lot : Section, dir : Int, street : Street,
                              color : Int) : Void
  {
    for (y in (lot.offset.y)...(lot.limit.y))
    {
      for (x in (lot.offset.x)...(lot.limit.x))
      {
        var index = 0;
        if (dir == PlaceRoot.NORTH || dir == PlaceRoot.SOUTH)
        {
          index = findIndex(x, center.x);
        }
        else
        {
          index = findIndex(y, center.y);
        }
        Util.addTile(new Point(x, y), edges[dir][index]);
      }
    }
  }

  override function placeMiddle(lot : Section, color : Int) : Void
  {
    for (y in (lot.offset.y)...(lot.limit.y))
    {
      for (x in (lot.offset.x)...(lot.limit.x))
      {
        var xIndex = findIndex(x, center.x);
        var yIndex = findIndex(y, center.y);
        Util.addTile(new Point(x, y), centerTiles[yIndex][xIndex]);
      }
    }
  }

  function findIndex(candidate : Int, target : Int) : Int
  {
    var result = BEFORE;
    var diff = candidate - target;
    if (diff < -1)
    {
      result = BEFORE;
    }
    else if (diff == -1)
    {
      result = BEGIN;
    }
    else if (diff == 0)
    {
      result = MIDDLE;
    }
    else if (diff == 1)
    {
      result = END;
    }
    else
    {
      result = AFTER;
    }
    return result;
  }

  // The center of the skylight
  var center : Point;
}
