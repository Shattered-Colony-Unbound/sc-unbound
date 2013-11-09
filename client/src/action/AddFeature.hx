package action;

class AddFeature implements Interface
{
  public function new(newMapPos : Point, newFeature : feature.Root) : Void
  {
    mapPos = newMapPos;
    feature = newFeature;
  }

  public function run() : Void
  {
    Game.map.getCell(mapPos.x, mapPos.y).mFeature = feature;
  }

  var mapPos : Point;
  var feature : feature.Root;
}
