package mapgen;

class BuildingHospital extends BuildingRoot
{
  // Used only for edge tiles
  static var BUILDING = 0;
  static var BEFORE_ENTRANCE = 1;
  static var ENTRANCE = 2;
  static var AFTER_ENTRANCE = 3;

  // These two are used only for non-entrance corner tiles.
  static var ROAD_NONE = 0;
  static var ROAD_BOTH = 1;

  // These two are used only for entrance corner tiles.
  static var ROAD_BOTH_VERT = 0;
  static var ROAD_BOTH_HORIZ = 1;

  // These two are always used.
  static var ROAD_VERT = 2;
  static var ROAD_HORIZ = 3;

  static var corners =
    [
      // NORTHEAST
      [[227, 224, 286, 221],
       [-1, 252, -1, 292],
       [-1, -1, -1, -1],
       [288, -1, 290, -1]],
      // NORTHWEST
      [[225, 222, 282, 220],
       [287, 251, 289, 291],
       [-1, -1, -1, -1],
       [-1, -1, -1, -1]],
      // SOUTHEAST
      [[267, 264, 306, 301],
       [-1, -1, -1, -1],
       [-1, -1, -1, -1],
       [308, 272, 310, 312]],
      // SOUTHWEST
      [[265, 262, 302, 300],
       [307, -1, 309, -1],
       [-1, -1, -1, -1],
       [-1, 271, -1, 311]]
      ];

  static var ROAD_NONE_EDGE = 0;
  static var ROAD_BOTH_EDGE = 1;

  static var edges =
    [
      // NORTH
      [[226, 223],
       [283, 283],
       [284, 284],
       [285, 285]],
      // SOUTH
      [[266, 263],
       [303, 303],
       [304, 304],
       [305, 305]],
      // EAST
      [[247, 244],
       [241, 241],
       [261, 261],
       [281, 281]],
      // WEST
      [[245, 242],
       [240, 240],
       [260, 260],
       [280, 280]]
      ];

  static var center = 243;

  static var overlay = 228;

  public function new(newBuilding : Building) : Void
  {
    super(newBuilding);
  }

  override function placeCorner(dest : Point, dir : Int,
                                vertical : Street, horizontal : Street,
                                color : Int) : Void
  {
    var road = ROAD_NONE;
    if (vertical != null && horizontal != null)
    {
      road = ROAD_BOTH;
    }
    else if (vertical != null)
    {
      road = ROAD_VERT;
    }
    else if (horizontal != null)
    {
      road = ROAD_HORIZ;
    }

    var type = BUILDING;
    if (Point.isVerticallyAdjacent(dest, building.getEntrance()))
    {
      if (road == ROAD_BOTH)
      {
        road = ROAD_BOTH_HORIZ;
      }
      else
      {
        road = ROAD_HORIZ;
      }
      if (dir == PlaceRoot.NORTHWEST || dir == PlaceRoot.NORTHEAST)
      {
        type = BEFORE_ENTRANCE;
      }
      else
      {
        type = AFTER_ENTRANCE;
      }
    }
    else if (Point.isHorizontallyAdjacent(dest, building.getEntrance()))
    {
      if (road == ROAD_BOTH)
      {
        road = ROAD_BOTH_VERT;
      }
      else
      {
        road = ROAD_VERT;
      }
      if (dir == PlaceRoot.NORTHWEST || dir == PlaceRoot.SOUTHWEST)
      {
        type = BEFORE_ENTRANCE;
      }
      else
      {
        type = AFTER_ENTRANCE;
      }
    }
    Util.addTile(dest, corners[dir][type][road]);
  }

  override function placeEdge(lot : Section, dir : Int, street : Street,
                              color : Int) : Void
  {
    var road = ROAD_NONE_EDGE;
    var type = BUILDING;
    if (Point.isEqual(lot.offset, building.getEntrance()))
    {
      type = BEFORE_ENTRANCE;
    }
    if (street != null)
    {
      road = ROAD_BOTH_EDGE;
    }
    for (y in (lot.offset.y)...(lot.limit.y))
    {
      for (x in (lot.offset.x)...(lot.limit.x))
      {
        var dest = new Point(x, y);
        type = getNextEdgeType(dest, type);
        Util.addTile(dest, edges[dir][type][road]);
      }
    }
  }

  function getNextEdgeType(dest : Point, type : Int) : Int
  {
    var result = BUILDING;
    if (type == BEFORE_ENTRANCE)
    {
      result = ENTRANCE;
    }
    else if (type == ENTRANCE)
    {
      result = AFTER_ENTRANCE;
    }
    else if (type == BUILDING && Point.isAdjacent(dest, building.getEntrance()))
    {
      result = BEFORE_ENTRANCE;
    }
    return result;
  }

  override function placeMiddle(lot : Section, color : Int) : Void
  {
    Util.fillAddTile(lot, center);
  }

  override function placeOverlay(center : Point)
  {
    var corner = new Point(center.x - 1, center.y - 1);
    for (dy in 0...3)
    {
      for (dx in 0...3)
      {
        var tile = overlay + dy * Tile.X_COUNT + dx;
        Util.addTile(new Point(corner.x + dx, corner.y + dy),
                     tile);
      }
    }
  }
}
