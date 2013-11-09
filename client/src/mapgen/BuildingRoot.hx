package mapgen;

class BuildingRoot extends PlaceRoot
{
  public function new(newBuilding : Building) : Void
  {
    building = newBuilding;
  }

  public function place(lot : Section) : Void
  {
    setupMap(lot);
    setupTiles(lot);
  }

  function setupMap(lot : Section) : Void
  {
    Util.fillBackground(lot, BackgroundType.BUILDING);
    Util.fillBlocked(lot);

    var entrance = building.getEntrance();
    if (entrance != null)
    {
      Util.setBackground(entrance, BackgroundType.ENTRANCE);
      Util.changeBlocked(entrance, false);
    }
  }

  function setupTiles(lot : Section) : Void
  {
    var color = Util.rand(getColorCount());
    placeCorner(lot.northwest(), PlaceRoot.NORTHWEST, lot.north, lot.west,
                color);
    placeCorner(lot.northeast(), PlaceRoot.NORTHEAST, lot.north, lot.east,
                color);
    placeCorner(lot.southwest(), PlaceRoot.SOUTHWEST, lot.south, lot.west,
                color);
    placeCorner(lot.southeast(), PlaceRoot.SOUTHEAST, lot.south, lot.east,
                color);
    var north = Direction.NORTH;
    var south = Direction.SOUTH;
    var east = Direction.EAST;
    var west = Direction.WEST;

    placeEdge(lot.edge(north), PlaceRoot.NORTH, lot.north, color);
    placeEdge(lot.edge(south), PlaceRoot.SOUTH, lot.south, color);
    placeEdge(lot.edge(east), PlaceRoot.EAST, lot.east, color);
    placeEdge(lot.edge(west), PlaceRoot.WEST, lot.west, color);

    placeMiddle(lot.center(), color);

    placeOverlay(lot.centerPoint());
  }

  function placeCorner(dest : Point, dir : Int,
                       vertical : Street, horizontal : Street,
                       color : Int) : Void
  {
  }

  function placeEdge(lot : Section, dir : Int, street : Street,
                     color : Int) : Void
  {
  }

  function placeMiddle(lot : Section, color : Int) : Void
  {
  }

  function placeOverlay(center : Point) : Void
  {
  }

  function getColorCount() : Int
  {
    return 1;
  }

  var building : Building;
}
