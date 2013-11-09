package mapgen;

class BuildingChurch extends BuildingRoot
{
  static var corners =
    [
      // NORTHEAST
      [682, 686, 690, 694],
      // NORTHWEST
      [680, 684, 688, 692],
      // SOUTHEAST
      [722, 726, 730, 734],
      // SOUTHWEST
      [720, 724, 728, 732]];

  // First subscript is location of tile
  // Second subscript is direction of building
  static var edges =
    [
      // NORTH
      [723, 685, 689, 693],
      // SOUTH
      [721, 727, 729, 733],
      // EAST
      [702, 706, 731, 714],
      // WEST
      [700, 704, 708, 735]];

  static var center = [701, 705, 709, 713];

  public function new(newBuilding : Building)
  {
    super(newBuilding);
  }

  override function placeCorner(dest : Point, dir : Int,
                                vertical : Street, horizontal : Street,
                                color : Int) : Void
  {
    Util.addTile(dest, corners[dir][getDir()]);
  }

  override function placeEdge(lot : Section, dir : Int, street : Street,
                              color : Int) : Void
  {
    Util.addTile(lot.offset, edges[dir][getDir()]);
  }

  override function placeMiddle(lot : Section, color : Int) : Void
  {
    Util.addTile(lot.offset, center[getDir()]);
  }

  function getDir() : Int
  {
    return Lib.directionToIndex(building.getEntranceDir());
  }
}
