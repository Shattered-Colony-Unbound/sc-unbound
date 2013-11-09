package mapgen;

class BlockHouses extends BlockRoot
{
  public function new() : Void
  {
  }

  override public function place(lot : Section) : Void
  {
    Util.fillWithBorder(lot, Tile.parkTiles);
    Util.fillUnblocked(lot);
    Util.fillBackground(lot, BackgroundType.PARK);
    var sublots = new List<Section>();
    Util.subdivide(lot, Option.minHouseSize, sublots);
    for (child in sublots)
    {
      var buildLot = child.randSublot(new Point(Option.minHouseSize,
                                                Option.minHouseSize));
//      var buildLot = middleLot(child);
      var building = Util.createBuilding(buildLot, Util.HOUSE);
      Util.drawBuilding(buildLot, building);
      addDriveway(buildLot.offset, building.getEntranceDir(), lot);
    }
    Util.fillBlockedGaps(lot);
  }

  function middleLot(lot : Section) : Section
  {
    var center = lot.centerPoint();
    var result = new Section(center, new Point(center.x + 2, center.y + 2));
    result.north = lot.north;
    result.south = lot.south;
    result.east = lot.east;
    result.west = lot.west;
    return result;
  }

  public static function placeEditBox(lot : Section,
                                      primary : Direction,
                                      secondary : Direction) : Building
  {
    var place = new PlaceTerrain();
    place.place(lot, PlaceTerrain.park);
    var houseLot = lot.slice(Util.opposite(primary), 2);
    houseLot = houseLot.slice(Util.opposite(secondary), 2);
    var building = Util.createBuilding(houseLot, Util.HOUSE, primary);
    Util.drawBuilding(houseLot, building);
    addDriveway(houseLot.offset, primary, lot);
    return building;
  }

  static var drivewayTiles = [683, 687, 691, 695];

  static var startOffsets = [new Point(0, -1),
                             new Point(1, 2),
                             new Point(2, 0),
                             new Point(-1, 1)];

  static function addDriveway(housePos : Point, dir : Direction,
                                     lot : Section) : Void
  {
    var dirIndex = Lib.directionToIndex(dir);
    var pos = new Point(housePos.x + startOffsets[dirIndex].x,
                        housePos.y + startOffsets[dirIndex].y);
    while (lot.contains(pos))
    {
      Util.addTile(pos, drivewayTiles[dirIndex]);
      pos.x += Lib.directionToDelta(dir).x;
      pos.y += Lib.directionToDelta(dir).y;
    }
  }
}
