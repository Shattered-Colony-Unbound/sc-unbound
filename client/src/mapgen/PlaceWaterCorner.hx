package mapgen;

class PlaceWaterCorner extends PlaceRoot
{
  public function new(newPrimary : Direction, newSecondary : Direction) : Void
  {
    if (newPrimary == Direction.NORTH || newPrimary == Direction.SOUTH)
    {
      primary = newPrimary;
      secondary = newSecondary;
    }
    else
    {
      primary = newSecondary;
      secondary = newPrimary;
    }
    if (secondary == Direction.EAST)
    {
      cornerIndex = PlaceRoot.greaterCorner(primary);
    }
    else
    {
      cornerIndex = PlaceRoot.lessCorner(primary);
    }
  }

  public function place(lot : Section) : Void
  {
    Util.fillBlocked(lot);
    Util.fillBackground(lot, BackgroundType.WATER);
    var current = lot;
    var index = 0;
    while (current.dirSize(primary) > 0)
    {
      var strip = current.slice(primary, 1);
      placeStrip(strip, index);
      current = current.remainder(primary, 1);
      if (index < 2)
      {
        ++index;
      }
    }
  }

  function placeStrip(lot : Section, pIndex : Int) : Void
  {
    var current = lot;
    var sIndex = 0;
    while (current.dirSize(secondary) > 0)
    {
      var square = current.slice(secondary, 1);
      Util.fillAddTile(square, corner[cornerIndex][pIndex][sIndex]);
      current = current.remainder(secondary, 1);
      if (sIndex < 2)
      {
        ++sIndex;
      }
    }
  }

  var primary : Direction;
  var secondary : Direction;
  var cornerIndex : Int;

  static var corner = [
    // NORTHEAST
    [[160, 146, 147],
     [167, 166, 147],
     [147, 147, 147]],
    // NORTHWEST
    [[165, 148, 147],
     [167, 168, 147],
     [147, 147, 147]],
    // SOUTHEAST
    [[60, 146, 147],
     [127, 126, 147],
     [147, 147, 147]],
    // SOUTHWEST
    [[65, 148, 147],
     [127, 128, 147],
     [147, 147, 147]]
    ];
}
