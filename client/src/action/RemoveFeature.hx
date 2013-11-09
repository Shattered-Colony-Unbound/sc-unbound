package action;

class RemoveFeature implements Interface
{
  public function new(newMapPos : Point) : Void
  {
    mapPos = newMapPos;
  }

  public function run() : Void
  {
    var cell = Game.map.getCell(mapPos.x, mapPos.y);
    if (cell.mFeature != null)
    {
      cell.mFeature.cleanup();
      cell.mFeature = null;
    }
  }

  var mapPos : Point;
}
