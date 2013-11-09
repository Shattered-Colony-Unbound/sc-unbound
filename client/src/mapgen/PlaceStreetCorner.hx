package mapgen;

class PlaceStreetCorner extends PlaceRoot
{
  public function new() : Void
  {
  }

  public function place(lot : Section, primary : Direction) : Void
  {
    Util.fillUnblocked(lot);
    Util.fillBackground(lot, BackgroundType.STREET);
    Util.fillClearTiles(lot);
    var corner = PlaceRoot.clockwiseCorner(primary);
    var size = lot.getSize();
    var minSize = Math.floor(Math.min(size.x, size.y));
    var current = lot;
    var totalSize = minSize;
    var index = 0;
    while (minSize > 0)
    {
      current = placeNext(current, corner, index, totalSize);
      size = current.getSize();
      minSize = Math.floor(Math.min(size.x, size.y));
      ++index;
    }
  }

  function placeNext(lot : Section, corner : Int, current : Int,
                     totalSize : Int) : Section
  {
    var vertDir = PlaceRoot.cornerToVert(corner);
    var horizDir = PlaceRoot.cornerToHoriz(corner);
    var vert = lot.slice(horizDir, 1).remainder(vertDir, 1);
    var horiz = lot.slice(vertDir, 1).remainder(horizDir, 1);
    var cornerPos = lot.corner(corner);

    if (current == 0 && totalSize > 1)
    {
      var vertTrans = vert.slice(vertDir, 1);
      vert = vert.remainder(vertDir, 1);
      var horizTrans = horiz.slice(horizDir, 1);
      horiz = horiz.remainder(horizDir, 1);
      placeTransition(vertTrans, horizDir, corner, totalSize);
      placeTransition(horizTrans, vertDir, corner, totalSize);
    }

    placeEdge(vert, horizDir, current, totalSize);
    placeEdge(horiz, vertDir, current, totalSize);
    placeCorner(cornerPos, corner, current, totalSize);

    var result = lot.remainder(horizDir, 1).remainder(vertDir, 1);
    return result;
  }

  function placeEdge(lot : Section, dir : Direction,
                     current : Int, total : Int) : Void
  {
    var type = getType(current, total);
    if (dir == Direction.EAST || dir == Direction.SOUTH)
    {
      type = getType(total - current - 1, total);
    }
    var vertIndex = VERTICAL;
    if (dir == Direction.SOUTH || dir == Direction.NORTH)
    {
      vertIndex = HORIZONTAL;
    }
    var tile = edges[vertIndex][type];
    Util.fillAddTile(lot, tile);
  }

  function placeCorner(pos : Point, corner : Int,
                       current : Int, total : Int) : Void
  {
    var type = getType(current, total);
    var tile = corners[corner][type];
    Util.addTile(pos, tile);
  }

  function placeTransition(lot : Section, dir : Direction,
                           corner : Int, total : Int) : Void
  {
    var vertIndex = VERTICAL;
    if (dir == Direction.NORTH || dir == Direction.SOUTH)
    {
      vertIndex = HORIZONTAL;
    }
    var sizeIndex = SMALL_ROAD;
    if (total > 2)
    {
      sizeIndex = LARGE_ROAD;
    }
    var tile = transitions[corner][vertIndex][sizeIndex];
    Util.fillAddTile(lot, tile);
  }

  function getType(current : Int, total : Int) : Int
  {
    var result = Tile.NO_TILE;
    if (total <= 4)
    {
      result = types[total-1][current];
    }
    else
    {
      var isEven = (total % 2 == 0);
      if (current == 0)
      {
        result = MULTI_A;
      }
      else if (current == total - 1)
      {
        result = MULTI_F;
      }
      else if (isEven && current == Math.floor(total/2) - 1)
      {
        result = MULTI_C;
      }
      else if (isEven && current == Math.floor(total/2))
      {
        result = MULTI_D;
      }
      else if (! isEven && current == Math.floor(total/2))
      {
        result = MULTI_G;
      }
      else if (current < Math.floor(total/2))
      {
        if (current > 1)
        {
          result = MULTI_PATCH;
        }
        else
        {
          result = MULTI_B;
        }
      }
      else // current > Math.floor(total/2)
      {
        result = MULTI_E;
      }
    }
    return result;
  }

  static var ALLEY = 0;
  static var TWO_LEFT = 1;
  static var TWO_RIGHT = 2;
  static var MULTI_A = 3;
  static var MULTI_B = 4;
  static var MULTI_C = 5;
  static var MULTI_D = 6;
  static var MULTI_E = 7;
  static var MULTI_F = 8;
  static var MULTI_G = 9;
  static var THREE_MIDDLE = 10;
  static var MULTI_PATCH = 11;
  static var FOUR_MIDDLE = 12;

  static var VERTICAL = 0;
  static var HORIZONTAL = 1;

  static var SMALL_ROAD = 0;
  static var LARGE_ROAD = 1;

  static var types = [[ALLEY],
                      [TWO_LEFT, TWO_RIGHT],
                      [MULTI_A, THREE_MIDDLE, MULTI_F],
                      [MULTI_A, FOUR_MIDDLE, MULTI_D, MULTI_F]];

  static var corners =
    [
      // NORTHEAST
      [1141, 84,  103, 84,  1151, 1204, 1155, 1157, 1153, 1159, 1143, 1204, 1149],
      // NORTHWEST
      [1140, 81,  102, 81,  1150, 1203, 1154, 1156, 1152, 1158, 1142, 1203, 1148],
      // SOUTHEAST
      [1161, 144, 123, 144, 1171, 1224, 1175, 1177, 1173, 1179, 1163, 1224, 1169],
      // SOUTHWEST
      [1160, 141, 122, 141, 1170, 1223, 1174, 1176, 1172, 1178, 1162, 1223, 1168]];

  static var edges =
    [
      // VERTICAL
      [20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 29, 24, 25],
      // HORIZONTAL
      [11, 31, 51, 71, 91, 111, 131, 151, 171, 191, 191, 91, 111]
      ];

  // [VERTICAL, HORIZONTAL]
  static var transitions =
    [
      // NORTHEAST
      [[104, 1145], [83, 1147]],
      // NORTHWEST
      [[101, 1146], [82, 1144]],
      // SOUTHEAST
      [[124, 1167], [143, 1165]],
      // SOUTHWEST
      [[121, 1164], [142, 1166]]];
}
