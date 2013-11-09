package action;

// Used to update the appearance of towers which change state based on
// the blocked-ness of adjacent squares.

class UpdateBlocked implements Interface
{
  public function new(newMapPos : Point) : Void
  {
    mapPos = newMapPos.clone();
  }

  public function run() : Void
  {
    for (delta in Lib.delta)
    {
      var currentX = mapPos.x + delta.x;
      var currentY = mapPos.y + delta.y;
      updateBlocked(currentX, currentY);
    }
    updateBlocked(mapPos.x, mapPos.y);
  }

  function updateBlocked(currentX : Int, currentY : Int) : Void
  {
    var tower = Game.map.getCell(currentX, currentY).getTower();
    if (tower != null)
    {
      tower.updateBlocked();
    }
  }

  var mapPos : Point;
}
