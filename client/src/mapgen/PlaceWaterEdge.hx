package mapgen;

class PlaceWaterEdge extends PlaceRoot
{
  public function new(newDir : Direction) : Void
  {
    dir = newDir;
  }

  public function place(lot : Section) : Void
  {
    Util.fillBlocked(lot);
    Util.fillBackground(lot, BackgroundType.WATER);
    var current = lot;
    var index = 0;
    var dirIndex = Lib.directionToIndex(dir);
    while (current.dirSize(dir) > 0)
    {
      var strip = current.slice(dir, 1);
      Util.fillAddTile(strip, edge[dirIndex][index]);
      current = current.remainder(dir, 1);
      if (index < 2)
      {
        ++index;
      }
    }
  }

  var dir : Direction;

  static var edge = [
    // NORTH
    [161, 167, 147],
    // SOUTH
    [64, 127, 147],
    // EAST
    [80, 146, 147],
    // WEST
    [145, 148, 147]];
}
