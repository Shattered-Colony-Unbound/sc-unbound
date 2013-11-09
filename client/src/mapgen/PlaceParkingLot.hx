package mapgen;

class PlaceParkingLot
{
  static var VERT = 0;
  static var HORIZ = 1;

  static var BEGIN_ROAD = 0;
  static var BEGIN_BUILDING = 1;
  static var MIDDLE = 2;
  static var END_ROAD = 3;
  static var END_BUILDING = 4;

  static var NORMAL = 0;
  static var ENTRANCE = 1;

  // First vertical, then horizontal.
  static var verticalLot =
    [
      // begin road
      [[357, 355], [417, 415], [418, 358], [359, 356], [419, 416]],
      // begin building
      [[317, 315], [257, 255], [318, 258], [319, 316], [259, 256]],
      // middle
      [[377, 375], [277, 275], [378, 378], [379, 376], [279, 276]],
      // end road
      [[397, 395], [437, 435], [438, 398], [399, 396], [439, 436]],
      // end bulding
      [[337, 335], [297, 295], [338, 298], [339, 336], [299, 296]]
    ];

  // First horizontal, then vertical
  static var horizontalLot =
    [
      // begin road
      [[517, 617], [515, 615], [535, 537], [557, 637], [555, 635]],
      // begin building
      [[455, 575], [457, 577], [475, 477], [495, 595], [497, 597]],
      // middle
      [[518, 618], [458, 578], [478, 478], [558, 638], [498, 598]],
      // end road
      [[519, 619], [516, 616], [536, 539], [559, 639], [556, 636]],
      // end building
      [[456, 576], [459, 579], [476, 479], [496, 596], [499, 599]]
    ];

  public function new() : Void
  {
  }

  public function place(lot : Section, inEntrances : List<Point>,
                        doPlaceRubble : Bool, ? placeDir : Direction) : Void
  {
    var entrances = new List<Point>();
    var ent : Point = null;
    for (pos in inEntrances)
    {
      ent = pos;
      entrances.add(pos.clone());
    }
    if (placeDir == null)
    {
      if (ent != null)
      {
        if (ent.y == lot.offset.y || ent.y == lot.limit.y - 1)
        {
          placeDir = Direction.NORTH;
        }
        else
        {
          placeDir = Direction.WEST;
        }
      }
      else
      {
        placeDir = Direction.NORTH;
      }
    }
    Util.fillClearTiles(lot);
    Util.fillUnblocked(lot);
    Util.fillBackground(lot, BackgroundType.STREET);
//    if (lot.getSize().x > lot.getSize().y)
    if (placeDir == Direction.NORTH || placeDir == Direction.SOUTH)
    {
      placeHorizontal(lot, entrances);
    }
    else
    {
      placeVertical(lot, entrances);
    }
    if (doPlaceRubble)
    {
      placeRubble(lot);
    }
  }

  function placeHorizontal(lot : Section,
                           entrances : List<Point>) : Void
  {
    var withArray = createWithArray(lot.getSize().x, lot.west, lot.east);
    var crossArray = createCrossArray(lot.getSize().y, lot.north, lot.south);
    placeTiles(lot.offset.x, lot.limit.x, withArray,
               lot.offset.y, lot.limit.y, crossArray,
               horizontalLot, true, entrances);
  }

  function placeVertical(lot : Section,
                         entrances : List<Point>) : Void
  {
    var withArray = createWithArray(lot.getSize().y, lot.north, lot.south);
    var crossArray = createCrossArray(lot.getSize().x, lot.west, lot.east);
    placeTiles(lot.offset.y, lot.limit.y, withArray,
               lot.offset.x, lot.limit.x, crossArray,
               verticalLot, false, entrances);
  }

  function createWithArray(size : Int, lesser : Street,
                           greater : Street) : Array<Int>
  {
    var result = [];
    for (i in 0...size)
    {
      result.push(MIDDLE);
    }
    fixEdges(result, lesser, greater);
    return result;
  }

  function createCrossArray(size : Int, lesser : Street,
                            greater : Street) : Array<Int>
  {
    var result = [];
    var remaining = size;
    if (remaining % 3 != 0)
    {
      result.push(BEGIN_BUILDING);
      result.push(END_BUILDING);
      remaining -= 2;
    }
    while (remaining >= 3)
    {
      result.push(BEGIN_BUILDING);
      result.push(MIDDLE);
      result.push(END_BUILDING);
      remaining -= 3;
    }
    if (remaining == 2)
    {
      result.push(BEGIN_BUILDING);
      result.push(END_BUILDING);
    }
    fixEdges(result, lesser, greater);
    return result;
  }

  function fixEdges(result : Array<Int>, lesser : Street,
                    greater : Street) : Void
  {
    if (lesser == null)
    {
      result[0] = BEGIN_BUILDING;
    }
    else
    {
      result[0] = BEGIN_ROAD;
    }
    if (greater == null)
    {
      result[result.length-1] = END_BUILDING;
    }
    else
    {
      result[result.length-1] = END_ROAD;
    }
  }

  function placeTiles(withBegin : Int, withEnd : Int, withArray : Array<Int>,
                      crossBegin : Int, crossEnd : Int, cross : Array<Int>,
                      lotArray : Array<Array<Array<Int>>>,
                      isHorizontal : Bool, entrances : List<Point>) : Void
  {
    addEntrances(withBegin, withEnd, crossBegin, crossEnd, cross,
                 isHorizontal, entrances);
    for (i in withBegin...withEnd)
    {
      var withIndex = i - withBegin;
      for (j in crossBegin...crossEnd)
      {
        var crossIndex = j - crossBegin;
        var first = withArray[withIndex];
        var second = cross[crossIndex];
        var third = entranceIndex(i, j, isHorizontal, entrances);
        placeSingleTile(i, j, lotArray[first][second][third], isHorizontal);
      }
    }
  }

  function placeSingleTile(withIndex : Int, cross : Int, tile : Int,
                           isHorizontal : Bool) : Void
  {
    var x = withIndex;
    var y = cross;
    if (! isHorizontal)
    {
      x = cross;
      y = withIndex;
    }
    Util.addTile(new Point(x, y), tile);
  }

  function addEntrances(withBegin : Int, withEnd : Int,
                        crossBegin : Int, crossEnd : Int, cross : Array<Int>,
                        isHorizontal : Bool, entrances : List<Point>) : Void
  {
    var withMiddle = Math.floor((withBegin + withEnd)/2);
    for (i in 1...(cross.length-1))
    {
      if (cross[i] == BEGIN_BUILDING || cross[i] == END_BUILDING)
      {
        entrances.add(getPoint(withMiddle, crossBegin + i, isHorizontal));
      }
    }
  }

  function getPoint(with : Int, cross : Int, isHorizontal : Bool) : Point
  {
    var result = new Point(with, cross);
    if (! isHorizontal)
    {
      result.x = cross;
      result.y = with;
    }
    return result;
  }

  function entranceIndex(withIndex : Int, cross : Int, isHorizontal : Bool,
                         entrances : List<Point>) : Int
  {
    var x = withIndex;
    var y = cross;
    if (! isHorizontal)
    {
      x = cross;
      y = withIndex;
    }
    var result = NORMAL;
    for (entrance in entrances)
    {
      if (x == entrance.x && y == entrance.y)
      {
        result = ENTRANCE;
        break;
      }
    }
    return result;
  }

  public static function addCrossStreet(lot : Section,
                                        entrance : Point,
                                        dir : Direction,
                                        cross : CrossStreet) : Void
  {
    if (dir == Direction.NORTH && lot.north != null)
    {
      lot.north.addGreater(entrance, 1, cross);
    }
    else if (dir == Direction.SOUTH && lot.south != null)
    {
      lot.south.addLess(entrance, 1, cross);
    }
    else if (dir == Direction.EAST && lot.east != null)
    {
      lot.east.addLess(entrance, 1, cross);
    }
    else if (dir == Direction.WEST && lot.west != null)
    {
      lot.west.addGreater(entrance, 1, cross);
    }
  }

  function placeRubble(lot : Section)
  {
    var size = lot.getSize();
    var max = Math.ceil(size.x * size.y * Parameter.rubbleStreetFactor) + 1;
    var count = Util.rand(max);
    for (i in 0...count)
    {
      var x = lot.offset.x + Util.rand(size.x);
      var y = lot.offset.y + Util.rand(size.y);
      Util.placeSingleSalvage(Game.map, x, y);
    }
  }

  static var insideCorner = [210, 235, 212, 211];

  static var outsideCorner = [
    // NORTHEAST
    [657, 616, 653, 655],
    // NORTHWEST
    [656, 615, 652, 654],
    // SOUTHEAST
    [677, 636, 673, 675],
    // SOUTHWEST
    [676, 635, 672, 674]
    ];

  static var entranceCorner = [
    // NORTHEAST
    [279, 458],
    // NORTHWEST
    [277, 458],
    // SOUTHEAST
    [279, 498],
    // SOUTHWEST
    [277, 498]
    ];

  public static function fixCorner(inside : Section, outside : Section,
                                   entrance : Section, cornerDir : Int,
                                   isVert) : Void
  {
    Util.addTile(inside.offset, insideCorner[cornerDir]);
    var vertDir = PlaceRoot.cornerToVert(cornerDir);
    var horizDir = PlaceRoot.cornerToHoriz(cornerDir);
    var index = 0;
    if (outside.getStreet(vertDir) != null)
    {
      index += 2;
    }
    if (outside.getStreet(horizDir) != null)
    {
      index += 1;
    }
    Util.addTile(outside.offset, outsideCorner[cornerDir][index]);

    index = 0;
    if (!isVert)
//    if (entrance.getStreet(vertDir) != null)
    {
      index = 1;
    }
    Util.addTile(entrance.offset, entranceCorner[cornerDir][index]);
  }
}
