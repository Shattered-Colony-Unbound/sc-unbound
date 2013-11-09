package mapgen;

class PlacePlaza extends PlaceRoot
{
  public function new() : Void
  {
  }

  public function place(lot : Section) : Void
  {
    Util.fillAddTile(lot, 872);
    Util.fillUnblocked(lot);
    Util.fillBackground(lot, BackgroundType.STREET);
  }
}
