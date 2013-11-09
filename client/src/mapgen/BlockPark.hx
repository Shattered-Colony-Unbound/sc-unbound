package mapgen;

class BlockPark extends BlockRoot
{
  public function new(? newAddTrees : Null<Bool>) : Void
  {
    addTrees = true;
    if (newAddTrees == false)
    {
      addTrees = false;
    }
  }

  override public function place(lot : Section) : Void
  {
    Util.fillWithBorder(lot, Tile.parkTiles);
    Util.fillUnblocked(lot);
    Util.fillBackground(lot, BackgroundType.PARK);
    if (addTrees)
    {
      Util.blockRandom(lot,
                       [Tile.trees, Tile.rocks, Tile.lakes],
                       [3, 1, 1]);
      Util.fillBlockedGaps(lot);
    }
  }
/*
  public function placeEditBox(lot : Section) : Void
  {
    Util.fillUnblocked(lot);
    Util.fillBackground(lot, BackgroundType.PARK);
    for (y in (lot.offset.y)...(lot.limit.y))
    {
      for (x in (lot.offset.x)...(lot.limit.x))
      {
        var index = checkCorners(x, y);
        Util.clearTiles(new Point(x, y));
        Util.addTile(new Point(x, y), corners[index]);
      }
    }
  }

  function checkCorners(x : Int, y : Int) : Int
  {
    var result = 0;
    for (i in 0...(PlaceRoot.CORNER_COUNT))
    {
      for (offset in cornerOffset[i])
      {
        var destX = x + offset.x;
        var destY = y + offset.y;
        var cell = Game.map.getCell(destX, destY);
        if (cell.edit == null || ! cell.edit.isParkFriendly())
        {
          result = (result | (1 << i));
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

  // 0001 == NORTHEAST
  // 0010 == NORTHWEST
  // 0100 == SOUTHEAST
  // 1000 == SOUTHWEST
  static var corners = [ 87, 215, 216,  67, 195,  88, 231,  68,
                        196, 232,  86,  66, 107, 108, 106, 246];
*/
  var addTrees : Bool;
}
