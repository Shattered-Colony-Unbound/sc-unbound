package mapgen;

class PlaceIntersection extends PlaceRoot
{
  public function new() : Void
  {
  }

  public function place(lot : Section) : Void
  {
    Util.fillUnblocked(lot);
    Util.fillBackground(lot, BackgroundType.STREET);
    Util.fillClearTiles(lot);
    var size = lot.getSize();
    if (size.x <= 1 || size.y <= 1)
    {
      Util.fillAddTile(lot, 1064);
    }
    else
    {
      Util.fillAddTile(lot.center(), 198);
      placeAllCorners(lot);
      placeAllEdges(lot);
    }
  }

  function placeAllCorners(lot : Section) : Void
  {
    for (dir in 0...PlaceRoot.CORNER_COUNT)
    {
      placeCorner(lot.corner(dir), dir);
    }

  }

  function placeCorner(pos : Point, dir : Int) : Void
  {
    var vert = getType(pos, PlaceRoot.cornerToVert(dir));
    var horiz = getType(pos, PlaceRoot.cornerToHoriz(dir));
    var tile = corners[dir][vert][horiz];
    Util.addTile(pos, tile);
  }

  function placeAllEdges(lot : Section) : Void
  {
    for (dir in Lib.directions)
    {
      Util.setArea(lot.edge(dir), placeEdgeTile, dir);
    }
  }

  function placeEdgeTile(pos : Point, dir : Direction) : Void
  {
    var dirIndex = Lib.directionToIndex(dir);
    var type = getType(pos, dir);
    var transition = getTransition(pos, dir);
    var tile = edges[dirIndex][type][transition];
    Util.addTile(pos, tile);
  }

  // Returns the type of the tile in direction dir from pos.
  function getType(pos : Point, dir : Direction) : Int
  {
    var dest = hop(pos, dir);
    var result = BUILDING;
    var edit = getEdit(dest);
    if (edit != null)
    {
      if (edit.getType() == EditBox.INTERSECTION)
      {
        result = INTERSECTION;
      }
      else if (edit.getType() == EditBox.STREET
               || edit.getType() == EditBox.CORNER
               || edit.getType() == EditBox.STREET_H
               || edit.getType() == EditBox.STREET_V)
      {
        if (edit.isAlley())
        {
          result = ALLEY;
        }
        else
        {
          result = STREET;
        }
      }
    }
    return result;
  }

  function hop(pos : Point, dir : Direction) : Point
  {
    var delta = Lib.directionToDelta(dir);
    return new Point(pos.x + delta.x, pos.y + delta.y);
  }

  function getEdit(pos : Point) : EditBox
  {
    var result = null;
    if (! Lib.outsideMap(pos))
    {
      result = Game.map.getCell(pos.x, pos.y).edit;
    }
    return result;
  }

  function getTransition(pos : Point, dir : Direction) : Int
  {
    var result = MIDDLE;
    var lessDir = Direction.WEST;
    var greaterDir = Direction.EAST;
    if (dir == Direction.EAST || dir == Direction.WEST)
    {
      lessDir = Direction.NORTH;
      greaterDir = Direction.SOUTH;
    }
    var center = hop(pos, dir);
    var less = hop(center, lessDir);
    var greater = hop(center, greaterDir);

    var centerEdit = getEdit(center);
    if (centerEdit != getEdit(less))
    {
      result = BEGIN;
    }
    else if (centerEdit != getEdit(greater))
    {
      result = END;
    }
    return result;
  }

  static var INTERSECTION = 0;
  static var ALLEY = 1;
  static var BUILDING = 2;
  static var STREET = 3;

  static var corners =
    [
      // NORTHEAST
      [[1181, 96, 94, 136],
       [138, 1189, 1229, 139],
       [98, 1189, 1221, 99],
       [134, 76, 74, 179]],
      // NORTHWEST
      [[1180, 95, 93, 135],
       [138, 1188, 1188, 137],
       [98, 1228, 1220, 97],
       [133, 75, 73, 177]],
      // SOUTHEAST
      [[1201, 96, 94, 156],
       [158, 1209, 1209, 159],
       [118, 1249, 1241, 119],
       [154, 116, 114, 219]],
      // SOUTHWEST
      [[1200, 95, 93, 155],
       [158, 1208, 1248, 157],
       [118, 1208, 1240, 117],
       [153, 115, 113, 217]]];

  static var BEGIN = 0;
  static var MIDDLE = 1;
  static var END = 2;

  static var edges =
    [
      // NORTH
      [[1200, 198, 1201],
       [138, 138, 138],
       [98, 98, 98],
       [133, 178, 134]],
      // SOUTH
      [[1220, 198, 1221],
       [158, 158, 158],
       [118, 118, 118],
       [153, 218, 154]],
      // EAST
      [[1201, 198, 1221],
       [96, 96, 96],
       [94, 94, 94],
       [136, 199, 156]],
      // WEST
      [[1200, 198, 1220],
       [95, 95, 95],
       [93, 93, 93],
       [135, 197, 155]]];

}
