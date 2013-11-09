package mapgen;

class Section
{
  public function new(newOffset : Point, newLimit : Point) : Void
  {
    offset = newOffset.clone();
    limit = newLimit.clone();
    north = null;
    south = null;
    east = null;
    west = null;
  }

  public function clone() : Section
  {
    var result = new Section(offset, limit);
    result.north = north;
    result.south = south;
    result.east = east;
    result.west = west;
    return result;
  }

  public function contains(pos : Point) : Bool
  {
    return pos.x >= offset.x && pos.x < limit.x
      && pos.y >= offset.y && pos.y < limit.y;
  }

  public function isNear(pos : Point, distance : Int) : Bool
  {
    var xDist = 0;
    if (pos.x < offset.x)
    {
      xDist = offset.x - pos.x;
    }
    else if (pos.x >= limit.x)
    {
      xDist = pos.x - limit.x + 1;
    }

    var yDist = 0;
    if (pos.y < offset.y)
    {
      yDist = offset.y - pos.y;
    }
    else if (pos.y >= limit.y)
    {
      yDist = pos.y - limit.y + 1;
    }

    return xDist < distance && yDist < distance;
  }

  // Returns a slice of size count from the dir direction. For
  // example, slice(Direction.NORTH, 5) would return a section as wide
  // as the current one but containing only the northmost 5 rows.
  //
  // The section returned will have count rows/columns regardless of
  // how many were in the original section.
  public function slice(dir : Direction, count : Int) : Section
  {
    var result = null;
    switch (dir)
    {
    case NORTH:
      result = new Section(offset, new Point(limit.x, offset.y + count));
    case SOUTH:
      result = new Section(new Point(offset.x, limit.y - count), limit);
    case EAST:
      result = new Section(new Point(limit.x - count, offset.y), limit);
    case WEST:
      result = new Section(offset, new Point(offset.x + count, limit.y));
    }
    result.north = north;
    result.south = south;
    result.east = east;
    result.west = west;
    result.setStreet(Util.opposite(dir), null);
    return result;
  }

  // Returns the remainder of the lot after a slice operation would
  // have been done.
  public function remainder(dir : Direction, count : Int) : Section
  {
    return slice(Util.opposite(dir), dirSize(dir) - count);
  }

  public function extend(dir : Direction, count : Int) : Section
  {
    var result = null;
    switch (dir)
    {
    case NORTH:
      result = new Section(new Point(offset.x, offset.y - count), limit);
    case SOUTH:
      result = new Section(offset, new Point(limit.x, limit.y + count));
    case EAST:
      result = new Section(offset, new Point(limit.x + count, limit.y));
    case WEST:
      result = new Section(new Point(offset.x - count, offset.y), limit);
    }
    return result;
  }

  // Returns the edge in a direction minus the corners.
  public function edge(dir : Direction) : Section
  {
    var result = null;
    switch(dir)
    {
    case NORTH:
      result = new Section(new Point(offset.x + 1, offset.y),
                           new Point(limit.x - 1, offset.y + 1));
      result.north = north;
    case SOUTH:
      result = new Section(new Point(offset.x + 1, limit.y - 1),
                           new Point(limit.x - 1, limit.y));
      result.south = south;
    case EAST:
      result = new Section(new Point(limit.x - 1, offset.y + 1),
                           new Point(limit.x, limit.y - 1));
      result.east = east;
    case WEST:
      result = new Section(new Point(offset.x, offset.y + 1),
                           new Point(offset.x + 1, limit.y - 1));
    }
    return result;
  }

  public function center() : Section
  {
    return new Section(new Point(offset.x + 1, offset.y + 1),
                       new Point(limit.x - 1, limit.y - 1));
  }

  public function northeast() : Point
  {
    return new Point(limit.x - 1, offset.y);
  }

  public function northwest() : Point
  {
    return offset.clone();
  }

  public function southeast() : Point
  {
    return new Point(limit.x - 1, limit.y - 1);
  }

  public function southwest() : Point
  {
    return new Point(offset.x, limit.y - 1);
  }

  public function corner(dir : Int) : Point
  {
    var result = null;
    if (dir == PlaceRoot.NORTHEAST)
    {
      result = northeast();
    }
    else if (dir == PlaceRoot.NORTHWEST)
    {
      result = northwest();
    }
    else if (dir == PlaceRoot.SOUTHEAST)
    {
      result = southeast();
    }
    else if (dir == PlaceRoot.SOUTHWEST)
    {
      result = southwest();
    }
    return result;
  }

  public function getStreet(dir : Direction) : Street
  {
    var result = north;
    switch (dir)
    {
    case NORTH:
      result = north;
    case SOUTH:
      result = south;
    case EAST:
      result = east;
    case WEST:
      result = west;
    }
    return result;
  }

  public function setStreet(dir : Direction, street : Street) : Void
  {
    switch (dir)
    {
    case NORTH:
      north = street;
    case SOUTH:
      south = street;
    case EAST:
      east = street;
    case WEST:
      west = street;
    }
  }

  public function getSize() : Point
  {
    return new Point(limit.x - offset.x, limit.y - offset.y);
  }

  public function dirSize(dir : Direction) : Int
  {
    var result = 0;
    if (dir == Direction.NORTH || dir == Direction.SOUTH)
    {
      result = limit.y - offset.y;
    }
    else
    {
      result = limit.x - offset.x;
    }
    return result;
  }

  public function randSublot(size : Point) : Section
  {
    var x = Util.rand(limit.x - offset.x - size.x + 1);
    var y = Util.rand(limit.y - offset.y - size.y + 1);
    var result =  new Section(new Point(offset.x + x, offset.y + y),
                              new Point(offset.x + x + size.x,
                                        offset.y + y + size.y));
    result.north = north;
    result.south = south;
    result.east = east;
    result.west = west;
    return result;
  }

  public function centerPoint() : Point
  {
    var sumX = limit.x + offset.x - 1;//Util.rand(2);
    var sumY = limit.y + offset.y - 1;//Util.rand(2);
    return new Point(Math.floor(sumX/2),
                     Math.floor(sumY/2));
  }

  public static function save(section : Section) : Dynamic
  {
    return { offset : section.offset.save(),
             limit : section.limit.save() };
  }

  public static function load(input : Dynamic) : Section
  {
    return new Section(Point.load(input.offset),
                       Point.load(input.limit));
  }

  public var offset : Point;
  public var limit : Point;
  public var north : Street;
  public var south : Street;
  public var east : Street;
  public var west : Street;
}
