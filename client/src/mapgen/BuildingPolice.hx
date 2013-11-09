package mapgen;

//                     <-- leg dir
//  <------> size
//  +------+------+---------+
//  |      |      |         |
//  | Leg  | Walk | Parking | | base dir
//  |      |      |         | |
//  |      |      |         | v
//  |      |      |         |
//  |      +------+         |
//  |      |Entr  |         |
//  |      |  ance|         |
//  +------+--+---+---------+ ^
//  |         |             | |
//  | Corner  |        Base | | size
//  |         |             | |
//  +-----------------------+ v

class BuildingPolice extends BuildingRoot
{
  public function new(newBuilding : Building,
                      ? newPlaceRubble : Bool,
                      ? newPrimary : Direction,
                      ? newSecondary : Direction) : Void
  {
    super(newBuilding);
    placeRubble = true;
    if (newPlaceRubble == false)
    {
      placeRubble = false;
    }
    baseDir = newPrimary;
    legDir = newSecondary;
  }

  override public function place(lot : Section) : Void
  {
    setDirections(lot);
    divideAndPlace(lot);
    building.attach();
  }

  function setDirections(lot : Section) : Void
  {
    if (baseDir == null || legDir == null)
    {
      var baseDirList = [];
      for (dir in Lib.directions)
      {
        if (lot.getStreet(dir) != null)
        {
          baseDirList.push(dir);
        }
      }
      if (baseDirList.length == 0)
      {
        baseDirList = Lib.directions.copy();
      }
      baseDir = Util.opposite(baseDirList[Util.rand(baseDirList.length)]);
      legDir = Lib.rotateCW(baseDir);
      if (Util.rand(2) == 0)
      {
        legDir = Lib.rotateCCW(baseDir);
      }
    }
  }

  function divideAndPlace(lot : Section) : Void
  {
    var size = 2;
    var base = lot.slice(baseDir, size);
    var outside = lot.remainder(baseDir, size);

    var corner = base.slice(legDir, size);
    base = base.remainder(legDir, size);

    var leg = outside.slice(legDir, size);
    outside = outside.remainder(legDir, size);
    placePolice(corner, leg, base);

    var longDir = baseDir;
    var shortDir = legDir;
    if (outside.dirSize(legDir) > outside.dirSize(baseDir))
    {
      longDir = legDir;
      shortDir = baseDir;
    }
    placeOutside(outside, longDir, shortDir);
  }

  function placePolice(corner : Section, leg : Section, base : Section) : Void
  {
    // Indices of the directions from lot A to lot B
    var cornerBase = Lib.directionToIndex(Util.opposite(legDir));
    var cornerLeg = Lib.directionToIndex(Util.opposite(baseDir));
    var legSize = Util.rand(leg.dirSize(baseDir) + 1);
    var baseSize = Util.rand(base.dirSize(legDir) + 1);

    var baseLevel = placeLeg(base, baseSize, legDir);
    var legLevel = placeLeg(leg, legSize, baseDir);

    // CORNER
    // How each side ends (end of the first floor, end of the second
    // floor, end of both.
    var endings = [GROUND, GROUND, GROUND, GROUND];
    endings[cornerBase] = baseLevel;
    endings[cornerLeg] = legLevel;
    placePoliceSection(corner, FLOOR_2, endings);

    placeHelipad(corner);
  }

  function placeLeg(lot : Section, sizeSecond : Int,
                    cornerDir : Direction) : Int
  {
    var cornerIndex = Lib.directionToIndex(cornerDir);
    var oppIndex = Lib.directionToIndex(Util.opposite(cornerDir));
    var second = lot.slice(cornerDir, sizeSecond);
    var first = lot.remainder(cornerDir, sizeSecond);
    var firstLevel = GROUND;
    if (sizeSecond < lot.dirSize(cornerDir))
    {
      firstLevel = FLOOR_1;
      var endings = [GROUND, GROUND, GROUND, GROUND];
      endings[cornerIndex] = FLOOR_2;
      placePoliceSection(first, firstLevel, endings);
    }
    if (sizeSecond > 0)
    {
      var endings = [GROUND, GROUND, GROUND, GROUND];
      endings[cornerIndex] = FLOOR_2;
      endings[oppIndex] = firstLevel;
      placePoliceSection(second, FLOOR_2, endings);
    }

    var floorResult = FLOOR_2;
    if (sizeSecond == 0)
    {
      floorResult = FLOOR_1;
    }
    return floorResult;
  }

  function placePoliceSection(lot : Section, nextLevel : Int,
                              endings : Array<Int>) : Void
  {
    currentEndings = endings;
    currentLevel = nextLevel;
    setupMap(lot);
    if (lot.dirSize(baseDir) > 1 && lot.dirSize(legDir) > 1)
    {
      setupTiles(lot);
    }
    else
    {
      var dir = legDir;
      if (lot.dirSize(baseDir) == 1)
      {
        dir = baseDir;
      }
      if (getEnd(dir) != GROUND)
      {
        dir = Util.opposite(dir);
      }
      var corner = PlaceRoot.lessCorner(dir);
      placeCorner(lot.corner(corner), corner, null, null, 0);
      corner = PlaceRoot.greaterCorner(dir);
      placeCorner(lot.corner(corner), corner, null, null, 0);
      placeEdge(lot.edge(dir), Lib.directionToIndex(dir), null, 0);
    }
    building.addLot(lot);
  }

  function getEnd(dir : Direction)
  {
    return currentEndings[Lib.directionToIndex(dir)];
  }

  function placeHelipad(lot : Section)
  {
    for (y in 0...2)
    {
      for (x in 0...2)
      {
        Util.addTile(new Point(lot.offset.x + x,
                               lot.offset.y + y), helipad[y][x]);
      }
    }
  }

  override function placeCorner(dest : Point, dir : Int,
                                vertical : Street, horizontal : Street,
                                color : Int) : Void
  {
    var vertDir = PlaceRoot.cornerToVert(dir);
    var vert = getEnd(vertDir);
    var horizDir = PlaceRoot.cornerToHoriz(dir);
    var horiz = getEnd(horizDir);
    var tile = corners[dir][currentLevel][vert][horiz];
    Util.addTile(dest, tile);
  }

  override function placeEdge(lot : Section, dir : Int,
                              street : Street, color : Int) : Void
  {
    var next = currentEndings[dir];
    Util.fillAddTile(lot, edges[dir][currentLevel][next]);
  }

  override function placeMiddle(lot : Section, color : Int) : Void
  {
    Util.fillAddTile(lot, centers[currentLevel]);
  }

  function placeOutside(outside : Section, longDir : Direction,
                        shortDir : Direction) : Void
  {
    var walk = outside.slice(longDir, 1);
    var parking = outside.remainder(longDir, 1);

    var entrance = walk.slice(shortDir, 1);
    walk = walk.remainder(shortDir, 1);
    placeWalk(walk);
    placeParking(parking);
    placeEntrance(entrance);
  }

  function placeWalk(lot : Section) : Void
  {
    Util.fillAddTile(lot, walkTile);
    Util.fillBackground(lot, BackgroundType.STREET);
    Util.fillUnblocked(lot);
  }

  function placeParking(lot : Section) : Void
  {
    if (lot.dirSize(baseDir) > 1 && lot.dirSize(legDir) > 1)
    {
      var park = Util.createBuilding(lot, Util.PARKING_LOT);
      Util.drawBuilding(lot, park, placeRubble);
    }
    else
    {
      placeWalk(lot);
    }
  }

  function placeEntrance(lot : Section) : Void
  {
    var base = Lib.directionToIndex(baseDir);
    var leg = Lib.directionToIndex(legDir);
    Util.fillAddTile(lot, entrances[base][leg]);
    Util.fillBackground(lot, BackgroundType.ENTRANCE);
    Util.fillUnblocked(lot);
    building.addLot(lot);
    building.setEntrance(lot.offset, Util.opposite(baseDir));
  }

  var placeRubble : Bool;
  var baseDir : Direction;
  var legDir : Direction;
  // Current endings
  var currentEndings : Array<Int>;
  var currentLevel : Int;

  static var GROUND = 0;
  static var FLOOR_1 = 1;
  static var FLOOR_2 = 2;

  static var edges =
    [
      // NORTH
      [[-1, -1, -1], [870, 890, 890], [1014, 971, 991]],
      // SOUTH
      [[-1, -1, -1], [910, 890, 890], [974, 1011, 991]],
      // EAST
      [[-1, -1, -1], [891, 890, 890], [993, 992, 991]],
      // WEST
      [[-1, -1, -1], [889, 890, 890], [995, 990, 991]]];

  static var corners =
    [
      // NORTHEAST
      [[[-1, -1, -1], [-1, -1, -1], [-1, -1, -1]],
       [[871, 870, 870], [891, 950, 950], [891, 950, 950]],
       [[935, 893, 1014], [895, 897, 958], [993, 918, 1013]]],
      // NORTHWEST
      [[[-1, -1, -1], [-1, -1, -1], [-1, -1, -1]],
       [[869, 870, 870], [889, 951, 951], [889, 951, 951]],
       [[934, 892, 1014], [894, 896, 959], [995, 919, 1015]]],
      // SOUTHEAST
      [[[-1, -1, -1], [-1, -1, -1], [-1, -1, -1]],
       [[911, 910, 910], [891, 930, 930], [891, 930, 930]],
       [[955, 913, 974], [915, 917, 938], [993, 898, 973]]],
      // SOUTHWEST
      [[[-1, -1, -1], [-1, -1, -1], [-1, -1, -1]],
       [[909, 910, 910], [889, 931, 931], [889, 931, 931]],
       [[954, 912, 974], [914, 916, 939], [995, 899, 975]]]
    ];

  static var centers = [-1, 890, 991];

  static var entrances =
    [
      // NORTH
      [-1, -1, 952, 953],
      // SOUTH
      [-1, -1, 932, 933],
      // EAST
      [952, 932, -1, -1],
      // WEST
      [953, 933, -1, -1]];

  static var walkTile = 872;

  static var helipad =
    [[967, 968],
     [987, 988]];
}
