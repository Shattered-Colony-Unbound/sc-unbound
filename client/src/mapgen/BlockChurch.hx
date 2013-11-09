package mapgen;

class BlockChurch extends BlockRoot
{
  public function new(? newFillGaps : Bool, ? newPrimary : Direction) : Void
  {
    fillGaps = true;
    if (newFillGaps == false)
    {
      fillGaps = false;
    }
    primary = newPrimary;
  }

  override public function place(lot : Section) : Void
  {
    placeBuilding(lot);
  }

  public function placeBuilding(lot : Section) : Building
  {
    Util.fillUnblocked(lot);
    Util.fillBackground(lot, BackgroundType.PARK);
    var church = placeChurch(lot);
    placeScenery(lot, church);
    if (fillGaps)
    {
      Util.fillBlockedGaps(lot);
    }
    return church;
  }

  public function placeEditBox(lot : Section) : Building
  {
    var park = new PlaceTerrain();
    park.place(lot, PlaceTerrain.park);
    var churchLot = lot.slice(Util.opposite(primary), 3);
    churchLot = churchLot.randSublot(new Point(3, 3));
    var building = Util.createBuilding(churchLot, Util.CHURCH, primary);
    Util.drawBuilding(churchLot, building);
    for (y in (lot.offset.y)...(lot.limit.y))
    {
      for (x in (lot.offset.x)...(lot.limit.x))
      {
        var pos = new Point(x, y);
        addOverlay(pos, building);
      }
    }
    return building;
  }

  function placeChurch(lot : Section) : Building
  {
    var churchLot = findChurchLot(lot);
    var churchDir = primary;
    if (churchDir == null)
    {
      churchDir = findChurchDir(lot, churchLot);
    }
    var church = Util.createBuilding(churchLot, Util.CHURCH, churchDir);
    Util.drawBuilding(churchLot, church);
    return church;
  }

  function placeScenery(lot : Section, church : Building) : Void
  {
    for (y in (lot.offset.y)...(lot.limit.y))
    {
      for (x in (lot.offset.x)...(lot.limit.x))
      {
        var pos = new Point(x, y);
        addPark(pos);
        addOverlay(pos, church);
      }
    }
  }

  function findChurchLot(lot : Section) : Section
  {
    var result = lot.randSublot(new Point(3, 3));
    if (result.offset.x == lot.offset.x + 1
      || result.limit.x == lot.limit.x - 1)
    {
      var delta = randAdjust();
      result.offset.x += delta;
      result.limit.x += delta;
    }
    if (result.offset.y == lot.offset.y + 1
      || result.limit.y == lot.limit.y - 1)
    {
      var delta = randAdjust();
      result.offset.y += delta;
      result.limit.y += delta;
    }
    return result;
  }

  function findChurchDir(lot : Section, churchLot : Section) : Direction
  {
    var result = Direction.NORTH;
    var score = boxDiff(lot, churchLot, result);

    for (i in 0...4)
    {
      var dir = Lib.indexToDirection(i);
      var current = boxDiff(lot, churchLot, dir);
      if (current > score)
      {
        result = dir;
        score = current;
      }
    }
    return result;
  }

  function boxDiff(outer : Section, inner : Section, dir : Direction) : Int
  {
    var result = 0;
    switch (dir)
    {
    case Direction.NORTH:
      result = inner.offset.y - outer.offset.y;
    case Direction.SOUTH:
      result = outer.limit.y - inner.limit.y;
    case Direction.EAST:
      result = outer.limit.x - inner.limit.x;
    case Direction.WEST:
      result = inner.offset.x - outer.offset.x;
    }
    return result;
  }

  function randAdjust() : Int
  {
    var result = 0;
    var choice = Util.rand(2);
    if (choice == 0)
    {
      result = 1;
    }
    else
    {
      result = -1;
    }
    return result;
  }

  function addOverlay(pos : Point, church : Building) : Void
  {
    var back = Game.map.getCell(pos.x, pos.y).getBackground();
    if (back == BackgroundType.PARK)
    {
      if (isPath(pos, church))
      {
        addPath(pos, church);
      }
      else if (fillGaps && Util.rand(100) < 30)
      {
        addBlocked(pos);
      }
    }
  }

  function isPath(pos : Point, church : Building) : Bool
  {
    var result = false;
    var dir = church.getEntranceDir();
    var entrance = church.getEntrance();
    switch (dir)
    {
    case Direction.NORTH:
      result = pos.x == entrance.x && pos.y < entrance.y;
    case Direction.SOUTH:
      result = pos.x == entrance.x && pos.y > entrance.y;
    case Direction.EAST:
      result = pos.x > entrance.x && pos.y == entrance.y;
    case Direction.WEST:
      result = pos.x < entrance.x && pos.y == entrance.y;
    }
    return result;
  }

  static var pathTiles = [703, 707, 711, 715];

  function addPath(pos : Point, church : Building) : Void
  {
    var index = Lib.directionToIndex(church.getEntranceDir());
    Util.addTile(pos, pathTiles[index]);
  }

  function addBlocked(pos : Point) : Void
  {
    Util.addRandTile(pos, Tile.trees);
    Util.changeBlocked(pos, true);
  }

  static var NORTH = 0;
  static var SOUTH = 1;
  static var EAST = 0;
  static var WEST = 1;
  static var NEITHER = 2;

  static var parkEdgeTiles =
    [
      // NORTH
      [68, 66, 67],
      // SOUTH
      [108, 106, 107],
      // NEITHER
      [88, 86, 87]];

  static var parkCornerTiles =
    [
      // NORTHEAST
      215,
      // NORTHWEST
      216,
      // SOUTHEAST
      195,
      // SOUTHWEST
      196];

  static var parkCornerDelta =
    [
      new Point(1, -1),
      new Point(-1, -1),
      new Point(1, 1),
      new Point(-1, 1)];

  function addPark(pos : Point) : Void
  {
    if (Game.map.getCell(pos.x, pos.y).getBackground() == BackgroundType.PARK)
    {
      var vert = NEITHER;
      if (! isPark(pos, Direction.NORTH))
      {
        vert = NORTH;
      }
      else if (! isPark(pos, Direction.SOUTH))
      {
        vert = SOUTH;
      }

      var horiz = NEITHER;
      if (! isPark(pos, Direction.EAST))
      {
        horiz = EAST;
      }
      else if (! isPark(pos, Direction.WEST))
      {
        horiz = WEST;
      }

      var tile = parkEdgeTiles[vert][horiz];
      if (vert == NEITHER && horiz == NEITHER)
      {
        tile = getCornerPark(pos);
      }
      Util.addTile(pos, tile);
    }
  }

  function isPark(pos : Point, dir : Direction) : Bool
  {
    return isParkDelta(pos, Lib.directionToDelta(dir));
  }

  function isParkDelta(pos : Point, delta : Point) : Bool
  {
    var cell = Game.map.getCell(pos.x + delta.x, pos.y + delta.y);
    return cell.getBackground() == BackgroundType.PARK;
  }

  function getCornerPark(pos : Point) : Int
  {
    var tile = 87;
    for (i in 0...4)
    {
      if (! isParkDelta(pos, parkCornerDelta[i]))
      {
        tile = parkCornerTiles[i];
      }
    }
    return tile;
  }

  var fillGaps : Bool;
  var primary : Direction;
}
