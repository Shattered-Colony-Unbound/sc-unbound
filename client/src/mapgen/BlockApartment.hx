package mapgen;

class BlockApartment extends BlockRoot
{
  public function new(? newBaseDir : Direction,
                      ? newPrimaryDir : Direction,
                      ? newSecondaryDir : Direction,
                      ? newDoPlaceRubble) : Void
  {
    baseDir = newBaseDir;
    primaryDir = newPrimaryDir;
    secondaryDir = newSecondaryDir;
    doPlaceRubble = true;
    if (newDoPlaceRubble == false)
    {
      doPlaceRubble = false;
    }
  }

  override public function place(lot : Section) : Void
  {
    placeBuilding(lot);
  }

  public function placeBuilding(lot : Section) : Building
  {
    setDirections(lot);
    setLots(lot);
    var building = placeApartment();
    placeEntrance();
    placeParking();
    return building;
  }

  function setDirections(lot : Section) : Void
  {
    if (baseDir == null || primaryDir == null)
    {
      var dirs = [[Direction.NORTH, Direction.SOUTH],
                  [Direction.EAST, Direction.WEST]];
      Util.shuffle(dirs);
      for (item in dirs)
      {
        Util.shuffle(item);
      }
      baseDir = dirs[0][0];
      primaryDir = dirs[1][0];
      secondaryDir = dirs[1][1];
    }
    if (lot.dirSize(primaryDir) < 8)
    {
      secondaryDir = null;
    }
  }

  function setLots(lot : Section) : Void
  {
    var baseSize = 2;
    if (lot.dirSize(baseDir) > 5)
    {
      baseSize = 3;
    }
    var wingSize = 3;
    var left = lot;
    var right = left.slice(primaryDir, wingSize);
    primaryCornerLot = right.slice(baseDir, baseSize);
    primaryLot = right.remainder(baseDir, baseSize);
    left = left.remainder(primaryDir, wingSize);

    secondaryLot = null;
    secondaryCornerLot = null;
    if (secondaryDir != null)
    {
      var right = left.slice(secondaryDir, wingSize);
      secondaryCornerLot = right.slice(baseDir, baseSize);
      secondaryLot = right.remainder(baseDir, baseSize);
      left = left.remainder(secondaryDir, wingSize);
    }

    baseLot = left.slice(baseDir, baseSize);
    left = left.remainder(baseDir, baseSize);

    right = left.slice(baseDir, 1);
    entranceLot = right.slice(primaryDir, 1);
    walkLot = right.remainder(primaryDir, 1);
    left = left.remainder(baseDir, 1);

    parkingLot = left;
  }

  function placeApartment() : Building
  {
    var otherDir = Util.opposite(baseDir);
    var lots = [baseLot, primaryLot, primaryCornerLot, secondaryLot,
                secondaryCornerLot, entranceLot];
    var building = new Building(Util.APARTMENT);
    for (lot in lots)
    {
      if (lot != null)
      {
        building.addLot(lot);
      }
    }
    building.setEntrance(entranceLot.offset, otherDir);
    Game.map.addBuilding(building);
    building.attach();
    var placement = new BuildingApartment(building);
    var dirs = [primaryDir];
    if (secondaryDir != null)
    {
      dirs.push(secondaryDir);
    }
    placement.setDirs(dirs);
    placement.place(baseLot);

    placement.setDirs([baseDir]);
    placement.place(primaryLot);

    placement.setDirs([otherDir, Util.opposite(primaryDir)]);
    placement.place(primaryCornerLot);

    if (secondaryDir != null)
    {
      placement.setDirs([baseDir]);
      placement.place(secondaryLot);

      placement.setDirs([otherDir, Util.opposite(secondaryDir)]);
      placement.place(secondaryCornerLot);
    }
    return building;
  }

  static var entrances = [
    // North
    [-1, -1, 923, 881],
    // South
    [-1, -1, 863, 901],
    // East
    [885, 927, -1, -1],
    // West
    [888, 926, -1, -1]];

  static var shorts = [
    // North
    [-1, -1, 924, 880],
    // South
    [-1, -1, 864, 900],
    // East
    [865, 947, -1, -1],
    // West
    [868, 946, -1, -1]];

  static var longs = [
    // North
    [-1, -1, 903, 861],
    // South
    [-1, -1, 883, 921],
    // East
    [886, 928, -1, -1],
    // West
    [887, 925, -1, -1]];

  static var corners = [
    // North
    [-1, -1, 904, 860],
    // South
    [-1, -1, 884, 920],
    // East
    [866, 948, -1, -1],
    // West
    [867, 945, -1, -1]];

  static var trees = [
    // North
    [-1, -1, 922, 882],
    // South
    [-1, -1, 862, 902],
    // East
    [905, 907, -1, -1],
    // West
    [908, 906, -1, -1]];

  static var tiling = 872;

  function placeEntrance() : Void
  {
    var entrance = entranceLot.offset;
    var short = primaryLot.slice(baseDir,
                                 1).slice(Util.opposite(primaryDir), 1).offset;
    var long = baseLot.slice(primaryDir,
                             1).slice(Util.opposite(baseDir), 1).offset;
    var corner = primaryCornerLot.slice(Util.opposite(baseDir),
                                        1).slice(Util.opposite(primaryDir),
                                                 1).offset;
    var i = Lib.directionToIndex(baseDir);
    var j = Lib.directionToIndex(primaryDir);
    Util.addTile(entrance, entrances[i][j]);
    Util.addTile(short, shorts[i][j]);
    Util.addTile(long, longs[i][j]);
    Util.addTile(corner, corners[i][j]);
    Util.setArea(walkLot, placeWalkTile, new Point(i, j));
  }

  function placeWalkTile(pos : Point, index : Point) : Void
  {
    if (Util.rand(2) == 0)
    {
      Util.addTile(pos, trees[index.x][index.y]);
      Util.changeBlocked(pos, true);
    }
    else
    {
      Util.addTile(pos, tiling);
      Util.changeBlocked(pos, false);
    }
    Util.setBackground(pos, BackgroundType.STREET);
  }

  function placeParking() : Void
  {
    var park = Util.createBuilding(parkingLot, Util.PARKING_LOT);
    var edge = parkingLot.slice(Util.opposite(baseDir), 1);
    var size = edge.getSize();
    var entrance = new Point(edge.offset.x + Math.floor(size.x / 2),
                             edge.offset.y + Math.floor(size.y / 2));
    park.setEntrance(entrance, Util.opposite(baseDir));
    Util.drawBuilding(parkingLot, park, doPlaceRubble);
  }

  // Directions of the wings of the apartment. base is the bottom of
  // the 'U', and primary and secondary are the wings. The entrance is
  // in the corner of the base and the primary wing. There is no
  // secondary wing if the block isn't big enough.
  var baseDir : Direction;
  var primaryDir : Direction;
  var secondaryDir : Direction;

  var baseLot : Section;
  var primaryLot : Section;
  var primaryCornerLot : Section;
  var secondaryLot : Section;
  var secondaryCornerLot : Section;
  var entranceLot : Section;
  var walkLot : Section;
  var parkingLot : Section;

  var doPlaceRubble : Bool;
}
