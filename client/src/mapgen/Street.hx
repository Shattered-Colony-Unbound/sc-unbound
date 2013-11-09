package mapgen;

class Street
{
  public function new(newStart : Point, newWidth : Int, newLength : Int,
                      newVertical : Bool, lessStreet : Street,
                      greaterStreet : Street)
  {
    start = newStart.clone();
    width = newWidth;
    length = newLength;
    isVertical = newVertical;
    less = [];
    greater = [];
    for (i in 0...length)
    {
      less.push(CrossStreet.NONE);
      greater.push(CrossStreet.NONE);
    }
    var cross = CrossStreet.NONE;
    if (width == 1)
    {
      cross = CrossStreet.ALLEY;
    }
    else if (width > 1)
    {
      cross = CrossStreet.ROAD;
    }

    if (lessStreet != null)
    {
      lessStreet.addGreater(start, width, cross);
    }
    if (greaterStreet != null)
    {
      greaterStreet.addLess(start, width, cross);
    }
    drawLessEnd = lessStreet != null;
    drawGreaterEnd = greaterStreet != null;
  }

  public function setDrawLess() : Void
  {
    drawLessEnd = true;
  }

  public function setDrawGreater() : Void
  {
    drawGreaterEnd = true;
  }

  public function addLess(childStart : Point, childWidth : Int,
                          val : CrossStreet) : Void
  {
    addChild(childStart, childWidth, val, less);
  }

  public function addGreater(childStart : Point, childWidth : Int,
                             val : CrossStreet) : Void
  {
    addChild(childStart, childWidth, val, greater);
  }

  public function addChild(childStart : Point, childWidth : Int,
                           val : CrossStreet, dest : Array<CrossStreet>) : Void
  {
    var index = 0;
    if (isVertical)
    {
      index = childStart.y - start.y;
    }
    else
    {
      index = childStart.x - start.x;
    }
    for (i in index...(index + childWidth))
    {
      dest[i] = val;
    }
  }

  public function getWidth() : Int
  {
    return width;
  }

  public function getLength() : Int
  {
    return length;
  }

  public function draw(map : Map, ? doAddStuff : Null<Bool>) : Void
  {
    for (i in 0...length)
    {
      for (j in 0...width)
      {
        drawTile(map, i, j);
      }
    }
    if (doAddStuff != false)
    {
      fillStreet(map, Parameter.rubbleStreetFactor, placeUnbiasedSalvage);
      if (Game.settings.getEasterEgg() != logic.GameSettings.FIDDLERSGREEN)
      {
        fillStreet(map, Parameter.zombieStreetFactor, Util.placeSingleZombie);
      }
    }
  }

  function placeUnbiasedSalvage(map : Map, x : Int, y : Int) : Void
  {
    Util.placeSingleSalvage(map, x, y);
  }

  function fillStreet(map : Map, maxProportion : Float,
                      placeSingle : Map -> Int -> Int -> Void) : Void
  {
    var max = Math.ceil(length * width * maxProportion) + 1;
    var count = Util.rand(max);
    for (i in 0...count)
    {
      var x = 0;
      var y = 0;
      if (isVertical)
      {
        x = start.x + Util.rand(width);
        y = start.y + Util.rand(length);
      }
      else
      {
        x = start.x + Util.rand(length);
        y = start.y + Util.rand(width);
      }
      placeSingle(map, x, y);
    }
  }

  function drawTile(map : Map, row : Int, col : Int) : Void
  {
    var tile = calculateTile(row, col);
    var x = 0;
    var y = 0;
    if (isVertical)
    {
      x = start.x + col;
      y = start.y + row;
    }
    else
    {
      x = start.x + row;
      y = start.y + col;
    }
    map.getCell(x, y).clearTiles();
    map.getCell(x, y).addTile(tile);
    var lessOverlay = Tile.NO_TILE;
    var greaterOverlay = Tile.NO_TILE;
    if (width > 1)
    {
      lessOverlay = calculateOverlay(row, col);
    }
    else
    {
      lessOverlay = calculateLessOverlay(row, col);
      greaterOverlay = calculateGreaterOverlay(row, col);
    }
    if (lessOverlay != Tile.NO_TILE)
    {
      map.getCell(x, y).addTile(lessOverlay);
    }
    if (greaterOverlay != Tile.NO_TILE)
    {
      map.getCell(x, y).addTile(greaterOverlay);
    }
    if (width > 1)
    {
      map.getCell(x, y).setBackground(BackgroundType.STREET);
    }
    else
    {
      map.getCell(x, y).setBackground(BackgroundType.ALLEY);
    }
    map.getCell(x, y).clearBlocked();
  }

  function calculateOverlay(row : Int, col : Int) : Int
  {
    var result = calculateLessOverlay(row, col);
    if (result == Tile.NO_TILE)
    {
      result = calculateGreaterOverlay(row, col);
    }
    return result;
  }

  function calculateLessOverlay(row : Int, col : Int) : Int
  {
    var result = Tile.NO_TILE;
    if (col == 0)
    {
      var delta = 0;
      if (isVertical)
      {
        delta = 2;
      }
      result = genericOverlay(less[row], delta);
    }
    return result;
  }

  function calculateGreaterOverlay(row : Int, col : Int) : Int
  {
    var result = Tile.NO_TILE;
    if (col == width - 1)
    {
      var delta = 0;
      if (isVertical)
      {
        delta = 2;
      }
      result = genericOverlay(greater[row], delta + 1);
    }
    return result;
  }

  static var parkingOverlay = [
    // North
    [590, 591, 236],
    // South
    [450, 451, 238],
    // West
    [651, 671, 239],
    // East
    [611, 631, 237]
    ];

  static var parkingAlleyOverlay = [
    // North
    [649, 650, 648],
    // South
    [669, 670, 668],
    // West
    [609, 629, 628],
    // East
    [610, 630, 608]
    ];

  function genericOverlay(cross : CrossStreet, dirIndex : Int) : Int
  {
    var crossIndex = 0;
    var overlay = parkingOverlay;
    if (width == 1)
    {
      overlay = parkingAlleyOverlay;
    }
    if (cross == CrossStreet.BEGIN_PARKING_ENTRANCE)
    {
      crossIndex = 0;
    }
    else if (cross == CrossStreet.END_PARKING_ENTRANCE)
    {
      crossIndex = 1;
    }
    else if (cross == CrossStreet.PARKING_ENTRANCE)
    {
      crossIndex = 2;
    }
    else
    {
      return Tile.NO_TILE;
    }
    return overlay[dirIndex][crossIndex];
  }

  function calculateTile(row : Int, col : Int) : Int
  {
    var result = 0;
    if (row == 0)
    {
      if (drawLessEnd)
      {
        result = getNormal(row, col, Tile.BEGIN);
      }
      else
      {
        result = getNormal(row, col, Tile.MIDDLE);
      }
    }
    else if (row == length - 1)
    {
      if (drawGreaterEnd)
      {
        result = getNormal(row, col, Tile.END);
      }
      else
      {
        result = getNormal(row, col, Tile.MIDDLE);
      }
    }
    else if (! isCrossed(row) && ! isCrossed(row-1) && isCrossed(row+1))
    {
      // Transitioning into an intersection
      if (! crossedBy(row, CrossStreet.BEGIN_PARKING_ENTRANCE)
          && ! crossedBy(row, CrossStreet.PARKING_ENTRANCE))
      {
        result = getNormal(row, col, Tile.END);
      }
      else
      {
        result = getNormal(row, col, Tile.MIDDLE);
      }
    }
    else if (! isCrossed(row) && ! isCrossed(row+1) && isCrossed(row-1))
    {
      // Transitioning out of an intersection
      if (! crossedBy(row, CrossStreet.END_PARKING_ENTRANCE)
          && ! crossedBy(row, CrossStreet.PARKING_ENTRANCE))
      {
        result = getNormal(row, col, Tile.BEGIN);
      }
      else
      {
        result = getNormal(row, col, Tile.MIDDLE);
      }
    }
    else if (isCrossed(row) || isCrossed(row-1) || isCrossed(row+1))
    {
      result = calculateIntersection(row, col);
    }
    else
    {
      result = getNormal(row, col, Tile.MIDDLE);
    }
    return result;
  }

  function calculateIntersection(row : Int, col : Int) : Int
  {
    if (! isCrossed(row-1) && ! isCrossed(row-2))
    {
      return calculateCol(row, col, Tile.BEGIN);
    }
    else if (! isCrossed(row+1) && ! isCrossed(row+2))
    {
      return calculateCol(row, col, Tile.END);
    }
    else
    {
      return calculateCol(row, col, Tile.MIDDLE);
    }
  }

  public function calculateCol(row : Int, col : Int, pos : Int)
  {
    if (col == 0)
    {
      if (isVertical)
      {
        return edgeCol(row, pos, lessEdgeVert, less);
      }
      else
      {
        return edgeCol(row, pos, lessEdgeHoriz, less);
      }
    }
    else if (col == width-1)
    {
      if (isVertical)
      {
        return edgeCol(row, pos, greaterEdgeVert, greater);
      }
      else
      {
        return edgeCol(row, pos, greaterEdgeHoriz, greater);
      }
    }
    else
    {
      if (isVertical)
      {
        return centerVert[pos];
      }
      else
      {
        return centerHoriz[pos];
      }
    }
  }

  public function edgeCol(row : Int, pos : Int, edgeTable, crossTable)
  {
    if (isRoad(row, crossTable) && ! isRoad(row-1, crossTable))
    {
      return edgeTable[pos][0];
    }
    else if (isRoad(row, crossTable) && ! isRoad(row+1, crossTable))
    {
      return edgeTable[pos][1];
    }
    else if (isRoad(row, crossTable))
    {
      return edgeTable[pos][2];
    }
    else if (crossTable[row] == CrossStreet.ALLEY)
    {
      return edgeTable[pos][4];
    }
    else
    {
      return edgeTable[pos][3];
    }
  }

  static var centerVert = [Tile.fadeFromNorth,
                           Tile.centerRoad,
                           Tile.fadeFromSouth];

  // Each table has five entries:
  // (1) Crossroad where previous space was not a crossroad.
  // (2) Crossroad where next space is not a crossroad.
  // (3) Crossroad where both next and previous spaces are also crossroads.
  // (4) Sidewalk
  // (5) Alley
  static var lessEdgeVert = [[Tile.nwCornerFadeBoth,
                              Tile.nwCornerFadeBoth,
                              Tile.nwCornerFadeBoth,
                              Tile.fadeNorthWalkWest,
                              Tile.fadeNorthAlleyWest],
                             [Tile.nwCornerFadeWest,
                              Tile.swCornerFadeWest,
                              Tile.fadeFromWest,
                              Tile.walkWest,
                              Tile.alleyWest],
                             [Tile.swCornerFadeBoth,
                              Tile.swCornerFadeBoth,
                              Tile.swCornerFadeBoth,
                              Tile.fadeSouthWalkWest,
                              Tile.fadeSouthAlleyWest]];

  static var greaterEdgeVert = [[Tile.neCornerFadeBoth,
                                 Tile.neCornerFadeBoth,
                                 Tile.neCornerFadeBoth,
                                 Tile.fadeNorthWalkEast,
                                 Tile.fadeNorthAlleyEast],
                                [Tile.neCornerFadeEast,
                                 Tile.seCornerFadeEast,
                                 Tile.fadeFromEast,
                                 Tile.walkEast,
                                 Tile.alleyEast],
                                [Tile.seCornerFadeBoth,
                                 Tile.seCornerFadeBoth,
                                 Tile.seCornerFadeBoth,
                                 Tile.fadeSouthWalkEast,
                                 Tile.fadeSouthAlleyEast]];

  static var centerHoriz = [Tile.fadeFromWest,
                            Tile.centerRoad,
                            Tile.fadeFromEast];

  static var lessEdgeHoriz = [[Tile.nwCornerFadeBoth,
                               Tile.nwCornerFadeBoth,
                               Tile.nwCornerFadeBoth,
                               Tile.fadeWestWalkNorth,
                               Tile.fadeWestAlleyNorth],
                              [Tile.nwCornerFadeNorth,
                               Tile.neCornerFadeNorth,
                               Tile.fadeFromNorth,
                               Tile.walkNorth,
                               Tile.alleyNorth],
                              [Tile.neCornerFadeBoth,
                               Tile.neCornerFadeBoth,
                               Tile.neCornerFadeBoth,
                               Tile.fadeEastWalkNorth,
                               Tile.fadeEastAlleyNorth]];

  static var greaterEdgeHoriz = [[Tile.swCornerFadeBoth,
                                  Tile.swCornerFadeBoth,
                                  Tile.swCornerFadeBoth,
                                  Tile.fadeWestWalkSouth,
                                  Tile.fadeWestAlleySouth],
                                 [Tile.swCornerFadeSouth,
                                  Tile.seCornerFadeSouth,
                                  Tile.fadeFromSouth,
                                  Tile.walkSouth,
                                  Tile.alleySouth],
                                 [Tile.seCornerFadeBoth,
                                  Tile.seCornerFadeBoth,
                                  Tile.seCornerFadeBoth,
                                  Tile.fadeEastWalkSouth,
                                  Tile.fadeEastAlleySouth]];

  function getNormal(row : Int, col : Int, pos : Int) : Int
  {
    var base = 0;
    var offset = 0;
    var factor = 0;
    if (hasAlley(row, col))
    {
      offset = getAlleyOffset(col);
      if (isVertical)
      {
        base = Tile.alleyVertical[pos];
        factor = Tile.verticalFactor;
      }
      else
      {
        base = Tile.alleyHorizontal[pos];
        factor = Tile.horizontalFactor;
      }
    }
    else
    {
      if (width <= 4)
      {
        offset = road[width - 1][col];
      }
      else
      {
        offset = roadTile(width, col);
      }
      if (isVertical)
      {
        base = Tile.roadVertical[pos];
        factor = Tile.verticalFactor;
      }
      else
      {
        base = Tile.roadHorizontal[pos];
        factor = Tile.horizontalFactor;
      }
    }
    return base + offset*factor;
  }

  function hasAlley(row : Int, col : Int) : Bool
  {
    return ((col == 0 && less[row] == CrossStreet.ALLEY)
            || (col == width - 1 && greater[row] == CrossStreet.ALLEY));
  }

  function getAlleyOffset(col : Int) : Int
  {
    var result = 0;
    if (col == 0)
    {
      if (width == 2)
      {
        result = Tile.alleyCrossTwoLeft;
      }
      else
      {
        result = Tile.alleyCrossMultiLeft;
      }
    }
    else // col == width - 1
    {
      if (width == 2)
      {
        result = Tile.alleyCrossTwoRight;
      }
      else
      {
        result = Tile.alleyCrossMultiRight;
      }
    }
    return result;
  }

  function isCrossed(row : Int) : Bool
  {
    return less[row] == CrossStreet.ROAD || greater[row] == CrossStreet.ROAD;
  }

  function isRoad(row : Int, table : Array<CrossStreet>) : Bool
  {
    return table[row] == CrossStreet.ROAD;
  }

  function crossedBy(row : Int, type : CrossStreet)
  {
    return less[row] == type || greater[row] == type;
  }

  var start : Point;
  var width : Int;
  var length : Int;
  var isVertical : Bool;
  var less : Array<CrossStreet>;
  var greater : Array<CrossStreet>;
  var drawLessEnd : Bool;
  var drawGreaterEnd : Bool;

  static var road = [[Tile.alley],
                     [Tile.twoLaneLeft,
                      Tile.twoLaneRight],
                     [Tile.multiLaneA,
                      Tile.multiLaneG,
                      Tile.multiLaneF],
                     [Tile.multiLaneA,
                      Tile.multiLaneC,
                      Tile.multiLaneD,
                      Tile.multiLaneF]];

  function roadTile(width : Int, col : Int) : Int
  {
    var result = Tile.multiLaneG;
    var isEven = (width % 2 == 0);
    if (col == 0)
    {
      result = Tile.multiLaneA;
    }
    else if (col == width - 1)
    {
      result = Tile.multiLaneF;
    }
    else if (isEven && col == Math.floor(width/2) - 1)
    {
      result = Tile.multiLaneC;
    }
    else if (isEven && col == Math.floor(width/2))
    {
      result = Tile.multiLaneD;
    }
    else if (! isEven && col == Math.floor(width/2))
    {
      result = Tile.multiLaneG;
    }
    else if (col < Math.floor(width/2))
    {
      result = Tile.multiLaneB;
    }
    else // col > Math.floor(width/2)
    {
      result = Tile.multiLaneE;
    }
    return result;
  }
}
