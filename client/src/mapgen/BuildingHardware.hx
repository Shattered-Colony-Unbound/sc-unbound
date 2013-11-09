package mapgen;

class BuildingHardware extends BuildingRoot
{
  // NORTH SOUTH EAST and WEST are 0-3
  static var LUMBER = 4;

  static var corners =
    [
      // NORTHEAST
      [752, 758, 755, 698],
      // NORTHWEST
      [750, 756, 753, 696],
      // SOUTHEAST
      [792, 798, 795, 738],
      // SOUTHWEST
      [790, 796, 793, 736]
    ];

  static var lumberCorners = [659, 658, 679, 678];

  static var edges =
    [
      // NORTH
      [751, 757, 754, 697],
      // SOUTH
      [791, 797, 794, 737],
      // EAST
      [772, 778, 775, 718],
      // WEST
      [770, 776, 773, 716]
    ];

  static var lumberEdges = [[699, 739], [719, 759], [612, 749], [632, 806]];

  static var centers =
    [771, 777, 774, 717];

  static var signCorners =
    [
      // NORTH
      [876, 877],
      // SOUTH
      [878, 879],
      // EAST
      [839, 859],
      // WEST
      [838, 858]
      ];

  static var signMiddle =
    [
      // NORTH
      [851, 852, 853],
      // SOUTH
      [873, 874, 875],
      // EAST
      [815, 835, 855],
      // WEST
      [814, 834, 854]
      ];

  static var entrance =
    [
      // NORTH
      779,
      // SOUTH
      799,
      // EAST
      819,
      // WEST
      818
      ];

  public function new(newBuilding : Building) : Void
  {
    super(newBuilding);
    orientation = 0;
  }

  override public function place(lot : Section) : Void
  {
    super.setupMap(lot);
    var dir = building.getEntranceDir();
    orientation = Lib.directionToIndex(dir);
    var buildingLot = lot.slice(dir, 3);
    setupTiles(buildingLot);
    var lumberDir = Util.opposite(dir);
    var lumberLot = lot.slice(lumberDir, lot.dirSize(lumberDir) - 3);
    while (lumberLot.dirSize(lumberDir) > 0)
    {
      lumberLot = placeLumber(lumberLot, lumberDir);
    }
  }

  function placeLumber(lot : Section, dir : Direction) : Section
  {
    var result = lot.slice(Util.opposite(dir), lot.dirSize(dir) - 1);
    var lumberLot = lot.slice(dir, 1);
    var dirIndex = Lib.directionToIndex(dir);
    for (y in (lumberLot.offset.y)...(lumberLot.limit.y))
    {
      for (x in (lumberLot.offset.x)...(lumberLot.limit.x))
      {
        var choice = Util.rand(2);
        Util.addTile(new Point(x, y), lumberEdges[dirIndex][choice]);
      }
    }
    Util.addTile(lumberLot.offset, lumberCorners[PlaceRoot.lessCorner(dir)]);
    Util.addTile(new Point(lumberLot.limit.x - 1, lumberLot.limit.y - 1),
                 lumberCorners[PlaceRoot.greaterCorner(dir)]);
    return result;
  }

  override function placeCorner(dest : Point, dir : Int,
                                vertical : Street, horizontal : Street,
                                color : Int) : Void
  {
    Util.addTile(dest, corners[dir][orientation]);
    var vert = PlaceRoot.cornerToVert(dir);
    var horiz = PlaceRoot.cornerToHoriz(dir);
    var entrance = building.getEntranceDir();
    var other : Direction = null;
    if (vert == entrance)
    {
      other = horiz;
    }
    else if (horiz == entrance)
    {
      other = vert;
    }
    if (other != null)
    {
      var tile = -1;
      if (other == Direction.NORTH || other == Direction.WEST)
      {
        tile = signCorners[Lib.directionToIndex(entrance)][0];
      }
      else
      {
        tile = signCorners[Lib.directionToIndex(entrance)][1];
      }
      Util.addTile(dest, tile);
    }
  }

  override function placeEdge(lot : Section, dir : Int, street : Street,
                              color : Int) : Void
  {
    Util.fillAddTile(lot, edges[dir][orientation]);
    if (Lib.indexToDirection(dir) == building.getEntranceDir())
    {
      Util.addTile(building.getEntrance(), entrance[dir]);
      Util.fillAddTile(lot, signMiddle[dir][Util.rand(3)]);
    }
  }

  override function placeMiddle(lot : Section, color : Int) : Void
  {
    Util.fillAddTile(lot, centers[orientation]);
  }

  var orientation : Int;
}
