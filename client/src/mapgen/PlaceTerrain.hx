package mapgen;

class PlaceTerrain extends PlaceRoot
{
  // 0001 == NORTHEAST
  // 0010 == NORTHWEST
  // 0100 == SOUTHEAST
  // 1000 == SOUTHWEST
  public static var park =
    new Terrain(isPark, false, BackgroundType.PARK,
                // 0000 0001 0010 0011 0100 0101 0110 0111
                [    87, 215, 216,  67, 195,  88, 231,  68,
                // 1000 1001 1010 1011 1100 1101 1110 1111
                    196, 232,  86,  66, 107, 108, 106, 246]);

  public static var shallowWater =
    new Terrain(isWater, true, BackgroundType.WATER,
                // 0000 0001 0010 0011 0100 0101 0110 0111
                [   989, 160, 165, 161,  60,  80, 949, 1119,
                // 1000 1001 1010 1011 1100 1101 1110 1111
                    65 , 969, 145, 1118, 64, 1139, 1138, 929]);

  public static var deepWater =
    new Terrain(isDeepWater, true, BackgroundType.WATER,
                // 0000 0001 0010 0011 0100 0101 0110 0111
                [   147, 166, 168, 167, 126, 146, 1082, 1097,
                // 1000 1001 1010 1011 1100 1101 1110 1111
                    128, 1086, 148, 1096, 127, 1077, 1095, 994]);

  public function new() : Void
  {
  }

  public function place(lot : Section, terrain : Terrain) : Void
  {
    Util.fillChangeBlocked(lot, terrain.isBlocked());
    Util.fillBackground(lot, terrain.getBackground());
    Util.fillClearTiles(lot);
    var pos = new Point(0, 0);
    for (y in (lot.offset.y)...(lot.limit.y))
    {
      for (x in (lot.offset.x)...(lot.limit.x))
      {
        pos.x = x;
        pos.y = y;
        var index = checkCorners(pos, terrain);
        Util.addTile(pos, terrain.getCorner(index));
      }
    }
  }

  function checkCorners(pos : Point, terrain : Terrain) : Int
  {
    var result = 0;
    var dest = new Point(0, 0);
    for (i in 0...(PlaceRoot.CORNER_COUNT))
    {
      for (offset in cornerOffset[i])
      {
        dest.x = pos.x + offset.x;
        dest.y = pos.y + offset.y;
        if (! Lib.outsideMap(dest))
        {
          var cell = Game.map.getCell(dest.x, dest.y);
          if ((cell.edit == null || ! terrain.isTerrain(cell.edit.getType()))
              && (cell.getBackground() != terrain.getBackground()
                  || terrain != shallowWater)
              && cell.getBackground() != BackgroundType.EDGE)
          {
            result = (result | (1 << i));
          }
        }
      }
    }
    return result;
  }

  static var cornerOffset = [
    // NORTHEAST
    [new Point(0, -1), new Point(1, -1), new Point(1, 0)],
    // NORTHWEST
    [new Point(0, -1), new Point(-1, -1), new Point(-1, 0)],
    // SOUTHEAST
    [new Point(0, 1), new Point(1, 1), new Point(1, 0)],
    // SOUTHWEST
    [new Point(0, 1), new Point(-1, 1), new Point(-1, 0)]
    ];

  static function isPark(type : EditType) : Bool
  {
    return type == EditBox.SHALLOW_WATER || type == EditBox.CHURCH
      || type == EditBox.HOUSE || type == EditBox.PARK
      || type == EditBox.BRIDGE;
  }

  static function isWater(type : EditType) : Bool
  {
    return type == EditBox.SHALLOW_WATER || type == EditBox.DEEP_WATER
      || type == EditBox.BRIDGE;
  }

  static function isDeepWater(type : EditType) : Bool
  {
    return type == EditBox.DEEP_WATER;
  }
}
