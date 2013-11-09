package mapgen;

class BlockStandard extends BlockRoot
{
  public function new() : Void
  {
  }

  override public function place(lot : Section) : Void
  {
    var sublots = new List<Section>();
    Util.subdivide(lot, Option.minGenericSize, sublots);
    for (child in sublots)
    {
      var building = Util.createBuilding(child);
      Util.drawBuilding(child, building);
    }
  }
}
