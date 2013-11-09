package mapgen;

class BlockMall extends BlockRoot
{
  public function new(? newPlaceRubble, ? newPrimary : Direction,
                      ? newSecondary : Direction) : Void
  {
    placeRubble = true;
    if (newPlaceRubble == false)
    {
      placeRubble = false;
    }
    primary = newPrimary;
    secondary = newSecondary;
  }

  static var horizDirs = [Direction.EAST, Direction.WEST,
                          Direction.EAST, Direction.WEST];
  static var vertDirs = [Direction.NORTH, Direction.NORTH,
                         Direction.SOUTH, Direction.SOUTH];

  override public function place(lot : Section) : Void
  {
    placeBuilding(lot);
  }

  public function placeBuilding(lot : Section) : Building
  {
    var horiz = primary;
    var vert = secondary;
    if (primary == Direction.NORTH || primary == Direction.SOUTH)
    {
      horiz = secondary;
      vert = primary;
    }
    var cornerDir = 0;
    if (primary == null || secondary == null)
    {
      cornerDir = Util.rand(4);
      horiz = horizDirs[cornerDir];
      vert = vertDirs[cornerDir];
    }
    else
    {
      cornerDir = PlaceRoot.lessCorner(horiz);
      if (vert == Direction.SOUTH)
      {
        cornerDir = PlaceRoot.greaterCorner(horiz);
      }
    }
    var currentLot = lot;
    currentLot = placeParkingLots(currentLot, cornerDir, horiz, vert);
    currentLot = setupTiles(currentLot, horiz, vert);
    var mall = placeMall(currentLot, horiz, vert);
    placeTiles(currentLot, mall, horiz, vert);
    return mall;
  }

  // The directions point towards the corner where the mall is.

  function placeParkingLots(lot : Section, cornerDir : Int,
                            horiz : Direction, vert : Direction) : Section
  {
    var result = lot;
    var dir = null;
    var other = null;
    if (lot.getSize().x > lot.getSize().y)
    {
      dir = vert;
      other = horiz;
    }
    else
    {
      dir = horiz;
      other = vert;
    }

    result = placeParkingStrip(result, dir, other, true,
                               getParkingSize(lot.dirSize(dir)),
                               getParkingSize(lot.dirSize(other)));
    result = placeParkingStrip(result, other, dir, false,
                               getParkingSize(lot.dirSize(other)),
                               getParkingSize(lot.dirSize(dir)));

    var xPark = getParkingSize(lot.getSize().x);
    var yPark = getParkingSize(lot.getSize().y);
    if (xPark == 2 && yPark == 2)
    {
      var first = lot.slice(Util.opposite(dir),
                            getParkingSize(lot.dirSize(dir)));
      var corner = first.slice(Util.opposite(other), 2);
      var inside = corner.slice(other, 1);
      inside = inside.slice(dir, 1);
      var outside = corner.slice(Util.opposite(other), 1);
      var entrance = outside.slice(dir, 1);
      outside = outside.slice(Util.opposite(dir), 1);

      PlaceParkingLot.fixCorner(inside, outside, entrance,
                                PlaceRoot.oppositeCorner(cornerDir),
                                dir == vert);
    }
    return result;
  }

  function placeParkingStrip(lot : Section, dir : Direction, other : Direction,
                             isFirst : Bool, parkSize : Int,
                             otherParkSize : Int) : Section
  {
    var result = lot;
    var totalSize = lot.dirSize(dir);
    if (parkSize > 0)
    {
      var parkLot = result.slice(Util.opposite(dir), parkSize);
      result = result.slice(dir, totalSize - parkSize);
      var parking = new PlaceParkingLot();
      var entrances = new List<Point>();

      if (otherParkSize > 0)
      {
        if (isFirst)
        {
          var entranceLot = parkLot.slice(Util.opposite(other), 2);
          entranceLot = entranceLot.slice(other, 1);
          entranceLot = entranceLot.slice(dir, 1);
          entrances.add(entranceLot.offset);
        }
        else if (parkSize == 3)
        {
          var entranceLot = parkLot.slice(Util.opposite(other), 1);
          entranceLot = entranceLot.slice(dir, 2);
          entranceLot = entranceLot.slice(Util.opposite(dir), 1);
          entrances.add(entranceLot.offset);
        }
        else if (parkSize == 2)
        {
          // This works but is brittle. The only way flow can reach
          // here is if there is a 2-wide parking lot intersecting
          // with a 2-tall parking lot. In that case, we need to fix
          // up the 2x2 intersection after making both of them. But we
          // need to make this first parking lot extend into that area
          // so that there aren't parking-lot dividers between them.
          parkLot = parkLot.slice(other,
                                  parkLot.dirSize(other) + 1);
        }
      }

      if (parkSize == 3)
      {
        var entranceLot = parkLot.slice(other, 1);
        entranceLot = entranceLot.slice(dir, 2);
        entranceLot = entranceLot.slice(Util.opposite(dir), 1);
        entrances.add(entranceLot.offset);
        PlaceParkingLot.addCrossStreet(entranceLot, entranceLot.offset, other,
                                       CrossStreet.PARKING_ENTRANCE);
      }
      else
      {
        var entranceLot = parkLot.slice(other, 1);
        var first = entranceLot.slice(dir, 1);
        entrances.add(first.offset);
        var second = entranceLot.slice(Util.opposite(dir), 1);
        entrances.add(second.offset);
        if (first.offset.x < second.offset.x
            || first.offset.y < second.offset.y)
        {
          PlaceParkingLot.addCrossStreet(first, first.offset, other,
                                         CrossStreet.BEGIN_PARKING_ENTRANCE);
          PlaceParkingLot.addCrossStreet(second, second.offset, other,
                                         CrossStreet.END_PARKING_ENTRANCE);
        }
        else
        {
          PlaceParkingLot.addCrossStreet(first, first.offset, other,
                                         CrossStreet.END_PARKING_ENTRANCE);
          PlaceParkingLot.addCrossStreet(second, second.offset, other,
                                         CrossStreet.BEGIN_PARKING_ENTRANCE);
        }
      }
      parking.place(parkLot, entrances, placeRubble, dir);
    }
    return result;
  }

  function getParkingSize(size : Int) : Int
  {
    if (size <= 6)
    {
      return 0;
    }
    else if (size <= 9)
    {
      return 2;
    }
    else
    {
      return 3;
    }
  }

  static var tileTile = 746;

  function setupTiles(lot : Section, horiz : Direction,
                      vert : Direction) : Section
  {
    var result = lot;
    horizTileLot = null;
    vertTileLot = null;
    if (result.getSize().x > 5)
    {
      horizTileLot = result.slice(Util.opposite(horiz), 1);
      result = result.slice(horiz, result.getSize().x - 1);
    }
    if (result.getSize().y > 5)
    {
      vertTileLot = result.slice(Util.opposite(vert), 1);
      result = result.slice(vert, result.getSize().y - 1);
    }
    return result;
  }

  function placeMall(lot : Section, horiz : Direction,
                     vert : Direction) : Building
  {
    var entranceList = [horiz, vert];
    var entranceDir = Util.opposite(entranceList[Util.rand(2)]);
    if (primary != null)
    {
      entranceDir = Util.opposite(primary);
    }
    var mall = Util.createBuilding(lot, Util.MALL, entranceDir);
    Util.drawBuilding(lot, mall);
    return mall;
  }

  // NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST
  static var mallCornerTile = [768, 767, 788, 787];
  static var tileCornerTile = 746;
  static var horizCornerTile = [769, 766, 789, 786];
  static var vertCornerTile = [748, 747, 808, 807];

  function placeTiles(mallLot : Section, mall : Building, horiz : Direction,
                      vert : Direction) : Void
  {
    placeEdgeTiles(horizTileLot, Util.opposite(horiz), mall.getEntrance());
    placeEdgeTiles(vertTileLot, Util.opposite(vert), mall.getEntrance());
    if (horizTileLot != null && vertTileLot != null)
    {
      var corner = getCornerIndex(Util.opposite(horiz),
                                  Util.opposite(vert));
      var mallCorner = mallLot;//new Section(mall.getOffset(), mall.getLimit());
      mallCorner = mallCorner.slice(Util.opposite(horiz), 1);
      mallCorner = mallCorner.slice(Util.opposite(vert), 1);
      Util.addTile(mallCorner.offset, mallCornerTile[corner]);

      var horizPair = horizTileLot.slice(Util.opposite(vert), 2);
      var tileCorner = horizPair.slice(Util.opposite(vert), 1);
      Util.addTile(tileCorner.offset, tileCornerTile);

      var horizCorner = horizPair.slice(vert, 1);
      Util.addTile(horizCorner.offset, horizCornerTile[corner]);

      var vertCorner = vertTileLot.slice(Util.opposite(horiz), 1);
      Util.addTile(vertCorner.offset, vertCornerTile[corner]);
    }
  }

  function getCornerIndex(horiz : Direction, vert : Direction) : Int
  {
    var result = PlaceRoot.NORTHEAST;
    if (vert == Direction.NORTH && horiz == Direction.WEST)
    {
      result = PlaceRoot.NORTHWEST;
    }
    else if (vert == Direction.SOUTH && horiz == Direction.EAST)
    {
      result = PlaceRoot.SOUTHEAST;
    }
    else if (vert == Direction.SOUTH && horiz == Direction.WEST)
    {
      result = PlaceRoot.SOUTHWEST;
    }
    return result;
  }

  static var EDGE_CORNER = 0;
  static var EDGE_BEGIN = 1;
  static var EDGE_MIDDLE = 2;
  static var EDGE_END = 3;

  static var edges =
    [
      // North
      [746, 826, 827, 828],
      // South
      [746, 846, 847, 848],
      // East
      [746, 810, 830, 850],
      // West
      [746, 809, 829, 849]
    ];

  function placeEdgeTiles(lot : Section, dir : Direction, entrance : Point)
  {
    if (lot != null)
    {
      Util.fillClearTiles(lot);
      Util.fillUnblocked(lot);
      Util.fillBackground(lot, BackgroundType.STREET);
      var dirIndex = Lib.directionToIndex(dir);
      for (y in (lot.offset.y)...(lot.limit.y))
      {
        for (x in (lot.offset.x)...(lot.limit.x))
        {
          var index = findEdgeIndex(x, y, lot, dir, entrance);
          Util.addTile(new Point(x, y), edges[dirIndex][index]);
        }
      }
    }
  }

  function findEdgeIndex(x : Int, y : Int, lot : Section, dir : Direction,
                         entrance : Point) : Int
  {
    var result = EDGE_CORNER;
    if (Lib.intAbs(x - entrance.x) <= 1
        && Lib.intAbs(y - entrance.y) <= 1)
    {
      if (dir == Direction.NORTH || dir == Direction.SOUTH)
      {
        result = edgeEntranceIndex(x, entrance.x);
      }
      else
      {
        result = edgeEntranceIndex(y, entrance.y);
      }
    }
    else if (dir == Direction.NORTH || dir == Direction.SOUTH)
    {
      result = edgeNormalIndex(x, lot.offset.x, lot.limit.x);
    }
    else
    {
      result = edgeNormalIndex(y, lot.offset.y, lot.limit.y);
    }
    return result;
  }

  function edgeEntranceIndex(current : Int, entrance : Int) : Int
  {
    if (current < entrance)
    {
      return EDGE_END;
    }
    else if (current > entrance)
    {
      return EDGE_BEGIN;
    }
    else
    {
      return EDGE_CORNER;
    }
  }

  function edgeNormalIndex(current : Int, offset : Int, limit : Int) : Int
  {
    if (current == offset)
    {
      return EDGE_BEGIN;
    }
    else if (current == limit - 1)
    {
      return EDGE_END;
    }
    else
    {
      return EDGE_MIDDLE;
    }
  }

  var horizTileLot : Section;
  var vertTileLot : Section;
  var placeRubble : Bool;
  var primary : Direction;
  var secondary : Direction;
}
