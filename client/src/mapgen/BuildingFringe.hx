package mapgen;

class BuildingFringe extends BuildingRoot
{
  static var colors = [0, 5, 10];

  static var FRINGE = 0;
  static var ROAD = 1;
  static var BUILDING = 2;
  static var ENTRANCE = 3;

  static var start = 320;

  static var corner =
    [
      // NORTHEAST
      [[4, 64, 104, 4],
       [1, 4, 4, 4],
       [61, 4, 4, 4],
       [4, 4, 4, 4]],
      // NORTHWEST
      [[2, 62, 102, 2],
       [0, 2, 2, 2],
       [60, 2, 2, 2],
       [2, 2, 2, 2]],
      // SOUTHEAST
      [[44, 84, 124, 44],
       [41, 44, 44, 44],
       [101, 44, 44, 44],
       [44, 44, 44, 44]],
      // SOUTHWEST
      [[42, 82, 122, 42],
       [40, 42, 42, 42],
       [100, 42, 42, 42],
       [42, 42, 42, 42]]
    ];

  static var edge =
    [
      // NORTH
      [63, 3, 3, 103],
      // SOUTH
      [83, 43, 43, 123],
      // EAST
      [21, 24, 24, 81],
      // WEST
      [20, 22, 22, 80],
    ];

  static var center = 23;

  public function new(newBuilding : Building) : Void
  {
    super(newBuilding);
  }

  override function placeCorner(dest : Point, dir : Int,
                                vertical : Street, horizontal : Street,
                                color : Int) : Void
  {
    var vIndex = BUILDING;
    if (building.getEntrance().y == dest.y)
    {
      vIndex = FRINGE;
    }
    else if (vertical != null)
    {
      vIndex = ROAD;
    }
    var hIndex = BUILDING;
    if (building.getEntrance().x == dest.x)
    {
      hIndex = FRINGE;
    }
    else if (horizontal != null)
    {
      hIndex = ROAD;
    }
    var tile = start + colors[color] + corner[dir][vIndex][hIndex];
    Util.addTile(dest, tile);
    if (vIndex != FRINGE && hIndex != FRINGE)
    {
      Util.addRoofOverlay(dest, Tile.cornerRoof);
    }
  }

  override function placeEdge(base : Section, dir : Int, street : Street,
                              color : Int) : Void
  {
    var normal = BUILDING;
    if (base.contains(building.getEntrance()))
    {
      normal = FRINGE;
    }
    else if (street != null)
    {
      normal = ROAD;
    }
    for (y in (base.offset.y)...(base.limit.y))
    {
      for (x in (base.offset.x)...(base.limit.x))
      {
        var dest = new Point(x, y);
        var tile = Tile.NO_TILE;
        if (Point.isEqual(dest, building.getEntrance()))
        {
          tile = start + colors[color] + edge[dir][ENTRANCE];
        }
        else
        {
          tile = start + colors[color] + edge[dir][normal];
        }
        Util.addTile(dest, tile);
        if (normal != FRINGE)
        {
          Util.addRoofOverlay(dest, Tile.edgeRoof[dir]);
        }
      }
    }
  }

  override function placeMiddle(lot : Section, color : Int) : Void
  {
    var tile = start + colors[color] + center;
    Util.fillAddTile(lot, tile);
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
}
