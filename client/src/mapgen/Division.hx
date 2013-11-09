// Create a division to separate a section into two parts separated by a road.

package mapgen;

class Division
{
  public function new(newMinBuildingSize : Int) : Void
  {
    left = null;
    right = null;
    middle = null;
    minBuildingSize = newMinBuildingSize;
  }

  public function split(base : Section, width : Int) : Void
  {
    left = null;
    right = null;
    middle = null;
    var minSize = width + minBuildingSize * 2;
    var xSize = base.limit.x - base.offset.x;
    var ySize = base.limit.y - base.offset.y;
    if (xSize <= ySize && ySize >= minSize
        && (base.west != null || base.east != null
            || (base.north != null && base.south != null)))
    {
      // Split vertically
      left = base.clone();
      right = base.clone();
      var divider = randSplit(base.offset.y, base.limit.y, width);
      if (width > 0)
      {
        middle = new Street(new Point(base.offset.x, divider), width,
                            base.limit.x - base.offset.x, false,
                            base.west, base.east);
      }
      left.limit.y = divider;
      left.south = middle;
      right.offset.y = divider + width;
      right.north = middle;
    }
    else if (xSize >= minSize
             && (base.north != null || base.south != null
                 || (base.east != null && base.west != null)))
    {
      // Split horizontally
      left = base.clone();
      right = base.clone();
      var divider = randSplit(base.offset.x, base.limit.x, width);
      if (width > 0)
      {
        middle = new Street(new Point(divider, base.offset.y), width,
                            base.limit.y - base.offset.y, true,
                            base.north, base.south);
      }
      left.limit.x = divider;
      left.east = middle;
      right.offset.x = divider + width;
      right.west = middle;
    }
  }

  public function getTop() : Section
  {
    return left;
  }

  public function getLeft() : Section
  {
    return left;
  }

  public function getBottom() : Section
  {
    return right;
  }

  public function getRight() : Section
  {
    return right;
  }

  public function getMiddle() : Street
  {
    return middle;
  }

  function randSplit(offset : Int, limit : Int, width : Int) : Int
  {
    var max = limit - offset - 2*minBuildingSize - width;
    var choice = 0;
    if (Game.settings.getEasterEgg() == logic.GameSettings.SALTLAKECITY)
    {
      choice = Math.floor(max/2);
    }
    else
    {
      var trialMax = Math.floor(max / width);
      var remainderMax = max % width + width;
      for (i in 0...width)
      {
        choice += Util.rand(trialMax);
      }
      choice += Util.rand(remainderMax);
    }
//    var choice = Util.rand(limit - offset - 2*minBuildingSize - width + 1);
    return choice + offset + minBuildingSize;
  }

  var left : Section;
  var right : Section;
  var middle : Street;

  var minBuildingSize : Int;
}
