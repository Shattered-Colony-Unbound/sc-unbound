package mapgen;

class BuildingHouse extends BuildingRoot
{
  static var colors = [600, 604];

  static var corner =
    [
      // NORTHEAST
      [1, 3, 41, 43],
      // NORTHWEST
      [0, 2, 40, 42],
      // SOUTHEAST
      [21, 23, 61, 63],
      // SOUTHWEST
      [20, 22, 60, 62]];

  public function new(newBuilding : Building) : Void
  {
    super(newBuilding);
  }

  override function placeCorner(dest : Point, dir : Int,
                                vertical : Street, horizontal : Street,
                                color : Int) : Void
  {
    var buildingDir = Lib.directionToIndex(building.getEntranceDir());
    Util.addTile(dest, corner[dir][buildingDir] + colors[color]);
  }

  override function getColorCount() : Int
  {
    return colors.length;
  }
}
