package mapgen;

class EditBox
{
  public static var UNKNOWN = new EditType(0, 1, ui.Text.editUnknown);
  public static var STREET_H = new EditType(1, 1, ui.Text.editStreetH);
  public static var STREET_V = new EditType(2, 1, ui.Text.editStreetV);

  public static var FRINGE = new EditType(32, 3, ui.Text.editFringe);
  public static var PLANT = new EditType(33, 3, ui.Text.editPlant);
  public static var HARDWARE = new EditType(34, 3, ui.Text.editHardware);
  public static var HOSPITAL = new EditType(35, 3, ui.Text.editHospital);
  public static var APARTMENT = new EditType(36, 5, ui.Text.editApartment);
  public static var CHURCH = new EditType(37, 3, ui.Text.editChurch);
  public static var HOUSE = new EditType(38, 2, ui.Text.editHouse);
  public static var MALL = new EditType(39, 5, ui.Text.editMall);
  public static var POLICE = new EditType(40, 3, ui.Text.editPolice);

  public static var PARKING_LOT = new EditType(3, 2, ui.Text.editParking);
  public static var PARK = new EditType(4, 1, ui.Text.editPark);
  public static var PLAZA = new EditType(5, 1, ui.Text.editPlaza);
  public static var SHALLOW_WATER = new EditType(6, 1,
                                                 ui.Text.editShallowWater);
  public static var DEEP_WATER = new EditType(7, 1, ui.Text.editDeepWater);
  public static var BRIDGE = new EditType(8, 3, ui.Text.editBridge);
  public static var STREET = new EditType(9, 1, ui.Text.editStreet);
  public static var CORNER = new EditType(10, 1, ui.Text.editCorner);
  public static var INTERSECTION = new EditType(11, 1,
                                                ui.Text.editIntersection);

  public static var BUILDING_BEGIN = FRINGE.number;
  public static var BUILDING_END = POLICE.number;

  public static var typeList = [UNKNOWN, STREET_H, STREET_V, INTERSECTION,
                                CORNER,
                                FRINGE, PLANT, HARDWARE, HOSPITAL, APARTMENT,
                                CHURCH, HOUSE, MALL, POLICE, PARKING_LOT, PARK,
                                PLAZA, SHALLOW_WATER, DEEP_WATER, BRIDGE];

  public static function intToType(num : Int) : EditType
  {
    var result = null;
    for (type in typeList)
    {
      if (num == type.number)
      {
        result = type;
        break;
      }
    }
    return result;
  }

  public function new(offset : Point, limit : Point) : Void
  {
    color = (0x808080 | Util.rand(256*256*256));
    type = UNKNOWN;
    lot = new Section(offset, limit);
    building = null;
    bridge = null;
    dynamitePos = null;
    street = null;

    zombies = 0;
    resources = Lib.newResourceArray();
    entrance = null;
    primary = Util.randDirection();
    secondary = Lib.rotateCW(primary);
    isBroken = false;
    checkEntrance();
  }

  function checkEntrance() : Void
  {
    if (entrance != null && ! lot.contains(entrance))
    {
      entrance = null;
    }
    if (entrance == null)
    {
      entrance = Util.chooseEntrance(lot, Lib.randDirection(), Util.STANDARD);
    }
  }

  public function bind() : Void
  {
    for (y in (lot.offset.y)...(lot.limit.y))
    {
      for (x in (lot.offset.x)...(lot.limit.x))
      {
        Game.map.getCell(x, y).edit = this;
      }
    }
  }

  public function free() : Void
  {
    for (y in (lot.offset.y)...(lot.limit.y))
    {
      for (x in (lot.offset.x)...(lot.limit.x))
      {
        Game.map.getCell(x, y).edit = null;
      }
    }
  }

  function clear() : Void
  {
    Util.fillClearTiles(lot);
    Util.fillBlocked(lot);
    Util.fillBackground(lot, BackgroundType.STREET);
    if (building != null)
    {
      Game.map.getBuildings().remove(building);
      building.clearZombies();
      building.detach();
      building = null;
    }
    if (bridge != null)
    {
      Game.progress.clearBridge(bridge);
      bridge = null;
    }
    if (dynamitePos != null)
    {
      Game.actions.push(new action.RemoveFeature(dynamitePos));
      dynamitePos = null;
    }
  }

  public function show() : Void
  {
    clear();
//    Util.seed(Game.settings.getNormalName(), lot.offset, lot.limit);
    if (type == STREET_H)
    {
      street = new Street(lot.offset, lot.limit.y - lot.offset.y,
                          lot.limit.x - lot.offset.x, false, null, null);
      setIntersections(street);
      street.draw(Game.map, false);
    }
    else if (type == STREET_V)
    {
      street = new Street(lot.offset, lot.limit.x - lot.offset.x,
                          lot.limit.y - lot.offset.y, true, null, null);
      setIntersections(street);
      street.draw(Game.map, false);
    }
    else if (type == PARKING_LOT)
    {
      createBuilding(Util.PARKING_LOT);
      var place = new PlaceParkingLot();
      var edge = lot.edge(primary);
      var square = edge.randSublot(new Point(1, 1));
      var entranceList = new List<Point>();
      entranceList.push(square.offset);
      place.place(lot, entranceList, false);
    }
    else if (type == PARK)
    {
      var place = new PlaceTerrain();
      place.place(lot, PlaceTerrain.park);
    }
    else if (type == PLAZA)
    {
      var place = new PlacePlaza();
      place.place(lot);
    }
    else if (type == SHALLOW_WATER)
    {
      var place = new PlaceTerrain();
      place.place(lot, PlaceTerrain.shallowWater);
    }
    else if (type == DEEP_WATER)
    {
      var place = new PlaceTerrain();
      place.place(lot, PlaceTerrain.deepWater);
    }
    else if (type == BRIDGE)
    {
/*
      var place = new PlaceWaterEdge(primary);
      place.place(lot);
      var bridgeLot = findBridgeLot(primary, secondary);
      var placement = new mapgen.PlaceBridge(Util.opposite(primary), isBroken);
      placement.place(bridgeLot);
*/
      var placement = new mapgen.PlaceBridge(primary, isBroken);
      placement.place(lot);
      bridge = new logic.Bridge(primary, lot, isBroken);
      Game.progress.addBridge(bridge, isBroken);
      if (! isBroken)
      {
        var dynamiteLot = lot.extend(primary, 1);
        dynamiteLot = dynamiteLot.slice(primary, 1);
        dynamitePos = dynamiteLot.centerPoint();
        if (Lib.outsideMap(dynamitePos))
        {
          dynamitePos = null;
        }
        else
        {
          var dynamite = new feature.Dynamite(dynamitePos, Option.dynamiteWork,
                                              bridge);
        }
      }
    }
    else if (type == INTERSECTION)
    {
      var place = new PlaceIntersection();
      place.place(lot);
    }
    else if (type == CORNER)
    {
      var place = new PlaceStreetCorner();
      place.place(lot, primary);
    }
    else if (type == FRINGE)
    {
      createBuilding(Util.STANDARD);
      var place = new BuildingFringe(building);
      place.place(lot);
    }
    else if (type == PLANT)
    {
      createBuilding(Util.STANDARD);
      var place = new BuildingPlant(building, true);
      place.place(lot);
    }
    else if (type == HARDWARE)
    {
      createBuilding(Util.HARDWARE_STORE);
      var place = new BuildingHardware(building);
      place.place(lot);
    }
    else if (type == HOSPITAL)
    {
      createBuilding(Util.HOSPITAL);
      var place = new BuildingHospital(building);
      place.place(lot);
    }
    else if (type == APARTMENT)
    {
      var place = new BlockApartment(primary, secondary,
                                     Util.opposite(secondary), false);
      building = place.placeBuilding(lot);
      populateBuilding();
    }
    else if (type == CHURCH)
    {
      var place = new BlockChurch(false, primary);
      building = place.placeEditBox(lot);
      populateBuilding();
    }
    else if (type == HOUSE)
    {
      building = BlockHouses.placeEditBox(lot, primary, secondary);
      populateBuilding();
    }
    else if (type == MALL)
    {
      var place = new BlockMall(false, primary, secondary);
      building = place.placeBuilding(lot);
      populateBuilding();
    }
    else if (type == POLICE)
    {
      createBuilding(Util.POLICE_STATION);
      var place = new BuildingPolice(building, false, primary, secondary);
      place.place(lot);
    }
    showObstacles();
    drawPixels();
    if (! EditLoader.isLoading)
    {
      Game.sprites.recalculateFov();
    }
  }

  public function showObstacles() : Void
  {
    for (y in (lot.offset.y)...(lot.limit.y))
    {
      for (x in (lot.offset.x)...(lot.limit.x))
      {
        var cell = Game.map.getCell(x, y);
        var obstacle = cell.getObstacle();
        if (obstacle != null)
        {
          var images = Tile.obstacles[obstacle];
          var choice = Util.rand(images.length);
          cell.addTile(images[choice]);
          cell.setBlocked();
          if (obstacle == Tile.OBSTACLE_LAKE)
          {
            cell.setBackground(BackgroundType.WATER);
          }
        }
      }
    }
  }

  public function drawPixels() : Void
  {
    if (! EditLoader.isLoading)
    {
      if (type == UNKNOWN)
      {
        Game.view.window.fillSolid(lot.offset.toPixel(), lot.limit.toPixel(),
                                   color);
      }
      else
      {
        Game.view.window.fillEdit(lot.offset, lot.limit);
      }
    }
  }

  function findBridgeLot(first : Direction, second : Direction) : Section
  {
    var bridgeLot = lot.slice(primary, 8);
    bridgeLot = bridgeLot.slice(secondary, 6);
    return bridgeLot;
  }

  function setIntersections(street : Street) : Void
  {
    for (i in 0...street.getLength())
    {
      addIntersection(i, -1, street.addLess);
      addIntersection(i, street.getWidth(), street.addGreater);
    }
    var hasLess = true;
    var hasGreater = true;
    for (i in 0...street.getWidth())
    {
      if (! isStreet(-1, i))
      {
        hasLess = false;
      }
      if (! isStreet(street.getLength(), i))
      {
        hasGreater = false;
      }
    }
    if (hasLess)
    {
      street.setDrawLess();
    }
    if (hasGreater)
    {
      street.setDrawGreater();
    }
  }

  function isStreet(row : Int, col : Int) : Bool
  {
    var result = false;
    var pos = new Point(lot.offset.x + col, lot.offset.y + row);
    if (type == STREET_H)
    {
      pos.x = lot.offset.x + row;
      pos.y = lot.offset.y + col;
    }
    if (! Lib.outsideMap(pos) && Game.map.getCell(pos.x, pos.y).edit != null)
    {
      var otherBox = Game.map.getCell(pos.x, pos.y).edit;
      result = ((type == STREET_H && otherBox.type == STREET_V)
                || (type == STREET_V && otherBox.type == STREET_H)
                || otherBox.type == INTERSECTION);
    }
    return result;
  }

  function addIntersection(row : Int, col : Int,
                           add : Point -> Int -> CrossStreet -> Void) : Void
  {
    var pos = new Point(lot.offset.x + col, lot.offset.y + row);
    if (type == STREET_H)
    {
      pos.x = lot.offset.x + row;
      pos.y = lot.offset.y + col;
    }
    if (! Lib.outsideMap(pos) && Game.map.getCell(pos.x, pos.y).edit != null)
    {
      var otherBox = Game.map.getCell(pos.x, pos.y).edit;
      if (otherBox.doesIntersect(type))
      {
        var cross = otherBox.getCrossStreet(pos);
        add(pos, 1, cross);
      }
    }
  }

  function doesIntersect(other : EditType) : Bool
  {
    var result = false;
    result = result || (type == STREET_H && other == STREET_V);
    result = result || (type == STREET_V && other == STREET_H );
    result = result || (type == BRIDGE && other == STREET_H
                        && (primary == Direction.NORTH
                            || primary == Direction.SOUTH));
    result = result || (type == BRIDGE && other == STREET_V
                        && (primary == Direction.EAST
                            || primary == Direction.WEST));
    return result;
  }

  function getCrossStreet(pos : Point) : CrossStreet
  {
    var result = CrossStreet.NONE;
    if (type == STREET_V)
    {
      result = CrossStreet.ROAD;
      if (lot.getSize().x == 1)
      {
        result = CrossStreet.ALLEY;
      }
    }
    else if (type == STREET_H)
    {
      result = CrossStreet.ROAD;
      if (lot.getSize().y == 1)
      {
        result = CrossStreet.ALLEY;
      }
    }
    else if (type == BRIDGE && lot.edge(primary).contains(pos))
    {
      result = CrossStreet.ROAD;
    }
    return result;
  }

  public function refreshStreets() : Void
  {
//    if (type == STREET_H || type == STREET_V || force == true)
    {
      var streets = new List<EditBox>();
      for (i in (lot.offset.x-1)...(lot.limit.x+1))
      {
        addRefreshStreet(i, lot.offset.y - 1, streets);
        addRefreshStreet(i, lot.limit.y, streets);
      }
      for (i in (lot.offset.y)...(lot.limit.y))
      {
        addRefreshStreet(lot.offset.x - 1, i, streets);
        addRefreshStreet(lot.limit.x, i, streets);
      }
      for (current in streets)
      {
        current.show();
      }
    }
  }

  function addRefreshStreet(x : Int, y : Int, streets : List<EditBox>) : Void
  {
    var pos = new Point(x, y);
    if (! Lib.outsideMap(pos) && Game.map.getCell(x, y).edit != null)
    {
      var otherBox = Game.map.getCell(x, y).edit;
//      if (otherBox.type == STREET_H || otherBox.type == STREET_V)
      {
        streets.remove(otherBox);
        streets.add(otherBox);
      }
    }
  }

  function createBuilding(buildingType : Int) : Void
  {
    building = new Building(buildingType);
    var dir = Util.calculateDir(entrance, lot);
    if (buildingType != Util.POLICE_STATION)
    {
      building.addLot(lot);
      building.setEntrance(entrance, dir);
    }
    if (buildingType != Util.PARKING_LOT)
    {
      Game.map.addBuilding(building);
      if (buildingType != Util.POLICE_STATION)
      {
        building.attach();
      }
    }
    populateBuilding();
  }

  function populateBuilding() : Void
  {
    if (zombies > 0)
    {
      building.addZombies(zombies);
    }
    for (i in 0...Option.resourceCount)
    {
      var payload = Lib.indexToResource(i);
      if (resources[i] > 0)
      {
        building.getSalvage().addResource(payload, resources[i]);
      }
    }
  }

  public function resize(newOffset : Point, newLimit : Point)
  {
    Game.view.window.fillSolid(lot.offset.toPixel(), lot.limit.toPixel(),
                               ui.Color.editEmpty);
    free();
    clear();
    refreshStreets();
    lot = new Section(newOffset, newLimit);
    checkEntrance();
    bind();
    show();
    refreshStreets();
  }

  public function rotate() : Void
  {
    primary = Lib.rotateCW(primary);
    secondary = Lib.rotateCW(secondary);
    show();
    refreshStreets();
  }

  public function reflect() : Void
  {
    primary = Util.opposite(primary);
    show();
    refreshStreets();
  }

  public function setDirections(newPrimary : Direction,
                                newSecondary : Direction) : Void
  {
    primary = newPrimary;
    secondary = newSecondary;
  }

  public function changeType(newType : EditType,
                             ? stayHidden : Null<Bool>) : Void
  {
    var oldType = type;
    type = newType;
    if (stayHidden != true)
    {
      show();
      refreshStreets();
    }
  }

  public function getOffset() : Point
  {
    return lot.offset;
  }

  public function getLimit() : Point
  {
    return lot.limit;
  }

  public function getType() : EditType
  {
    return type;
  }

  public static function isBuilding(test : EditType) : Bool
  {
    return test.number >= BUILDING_BEGIN && test.number <= BUILDING_END;
  }

  public function isAlley() : Bool
  {
    if (type == STREET_H)
    {
      return lot.dirSize(Direction.NORTH) == 1;
    }
    else if (type == STREET_V)
    {
      return lot.dirSize(Direction.EAST) == 1;
    }
    else
    {
      return false;
    }
  }

  public static function hasDirection(test : EditType) : Bool
  {
    return test == BRIDGE || test == PARKING_LOT || test == CHURCH
      || test == HOUSE || test == APARTMENT || test == MALL || test == POLICE
      || test == STREET || test == CORNER;
  }

  public function canSetEntrance() : Bool
  {
    return type == FRINGE || type == PLANT || type == HARDWARE
      || type == HOSPITAL;
  }

  public function addZombies(count : Int)
  {
    zombies += count;
    if (building != null)
    {
      building.addZombies(count);
    }
    if (zombies < 0)
    {
      zombies = 0;
    }
  }

  public function getZombies() : Int
  {
    return zombies;
  }

  public function addResources(payload : Resource, loads : Int)
  {
    var index = Lib.resourceToIndex(payload);
    var count = Lib.truckLoad(payload) * loads;
    resources[index] += count;
    if (building != null)
    {
      building.getSalvage().addResource(payload, count);
    }
  }

  public function removeResources(payload : Resource, loads : Int)
  {
    var index = Lib.resourceToIndex(payload);
    var count = Lib.truckLoad(payload) * loads;
    resources[index] -= count;
    if (resources[index] < 0)
    {
      resources[index] = 0;
    }
    if (building != null)
    {
      building.getSalvage().addResource(payload, -count);
    }
  }

  public function getResources(payload : Resource) : Int
  {
    var index = Lib.resourceToIndex(payload);
    return resources[index];
  }

  public function setEntrance(pos : Point, ? stayHidden : Null<Bool>) : Void
  {
    if (pos != null)
    {
      entrance = pos.clone();
      if (stayHidden != true)
      {
        show();
      }
    }
  }

  public function toggleBroken() : Void
  {
    isBroken = ! isBroken;
    show();
  }

  public function setBroken(newBroken : Bool, ? stayHidden : Null<Bool>) : Void
  {
    isBroken = newBroken;
    if (stayHidden != true)
    {
      show();
    }
  }

  public function remove() : Void
  {
    Game.view.window.fillSolid(lot.offset.toPixel(), lot.limit.toPixel(),
                               ui.Color.editEmpty);
    free();
    clear();
    Game.editor.clickSquare(null);
    Game.editor.removeBoxFromList(this);
    Game.view.window.refresh();
    refreshStreets();
  }

  public function saveMap(output : flash.utils.ByteArray) : Void
  {
    output.writeByte(type.number);
    EditLoader.savePos(lot.offset.x, lot.offset.y, output);
    EditLoader.savePos(lot.getSize().x, lot.getSize().y, output);
    if (isBuilding(type))
    {
      EditLoader.savePos(entrance.x, entrance.y, output);
      output.writeByte(zombies);
      EditLoader.saveResources(resources, output);
    }
    if (type == BRIDGE)
    {
      EditLoader.saveBool(isBroken, output);
    }
    EditLoader.saveDirections(type, primary, secondary, output);
  }

  var color : Int;
  var type : EditType;
  var lot : Section;

  var building : Building;
  var bridge : logic.Bridge;
  var street : Street;

  var dynamitePos : Point;
  var zombies : Int;
  var resources : Array<Int>;
  var entrance : Point;
  var primary : Direction;
  var secondary : Direction;

  var isBridge : Bool;
  var isBroken : Bool;
  var isSpawnPoint : Bool;
  var isBreakable : Bool;
  var hasTwoEnds : Bool;
}
