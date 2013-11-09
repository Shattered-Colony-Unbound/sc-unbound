package mapgen;

class BuildingApartment extends BuildingRoot
{
  static var STOPS = 0;
  static var EXTENDS = 1;
  static var EXTENDS_HORIZ = 1;
  static var EXTENDS_VERT = 2;
  static var EXTENDS_BOTH = 3;

  static var corners = [
    // Northeast
    [944, 943, 964, 960],
    // Northwest
    [942, 943, 962, 961],
    // Southeast
    [984, 983, 964, 940],
    // Southwest
    [982, 983, 962, 941]];

  static var edges = [
    // North
    [943, 963],
    // South
    [983, 963],
    // East
    [964, 963],
    // West
    [962, 963]];

  static var middle = 963;

  public function new(newBuilding : Building)
  {
    super(newBuilding);
    dirs = [];
  }

  public function setDirs(newDirs : Array<Direction>) : Void
  {
    dirs = newDirs;
  }

  function doesExtend(testDir : Direction) : Bool
  {
    var result = false;
    for (dir in dirs)
    {
      if (testDir == dir)
      {
        result = true;
      }
    }
    return result;
  }

  override function placeCorner(dest : Point, dir : Int,
                                vertical : Street, horizontal : Street,
                                color : Int) : Void
  {
    var extendIndex = STOPS;
    if (doesExtend(PlaceRoot.cornerToVert(dir)))
    {
      extendIndex = extendIndex | EXTENDS_VERT;
    }
    if (doesExtend(PlaceRoot.cornerToHoriz(dir)))
    {
      extendIndex = extendIndex | EXTENDS_HORIZ;
    }
    Util.addTile(dest, corners[dir][extendIndex]);
  }

  override function placeEdge(lot : Section, dir : Int, street : Street,
                              color : Int) : Void
  {
    var extendIndex = STOPS;
    if (doesExtend(Lib.indexToDirection(dir)))
    {
      extendIndex = EXTENDS;
    }
    Util.fillAddTile(lot, edges[dir][extendIndex]);
  }

  override function placeMiddle(lot : Section, color : Int) : Void
  {
    Util.fillAddTile(lot, middle);
  }

  var dirs : Array<Direction>;
}
