package mapgen;

class EditLoader
{
  public static var ZOMBIE = 128;
  public static var RUBBLE = 129;
  public static var TOWER = 130;
  public static var SUPPLY_LINE = 131;
  public static var OBSTACLE = 132;

  public static function saveMap(output : flash.utils.ByteArray,
                                 boxes : List<EditBox>) : Void
  {
    for (box in boxes)
    {
      box.saveMap(output);
    }
    var sources = [];
    var dests = [];
    for (y in 0...Game.map.sizeY())
    {
      for (x in 0...Game.map.sizeX())
      {
        var cell = Game.map.getCell(x, y);
        saveCell(x, y, cell, output, sources, dests);
      }
    }
    for (i in 0...sources.length)
    {
      output.writeByte(SUPPLY_LINE);
      savePos(sources[i].x, sources[i].y, output);
      savePos(dests[i].x, dests[i].y, output);
    }
  }

  static function saveCell(x : Int, y : Int, cell : MapCell,
                           output : flash.utils.ByteArray,
                           sources : Array<Point>, dests : Array<Point>) : Void
  {
    if (cell.hasZombies())
    {
      output.writeByte(ZOMBIE);
      savePos(x, y, output);
      output.writeByte(cell.zombieCount());
    }
    if (cell.hasRubble() && cell.getBackground() != BackgroundType.ENTRANCE)
    {
      output.writeByte(RUBBLE);
      savePos(x, y, output);
      saveResources(cell.getAllRubbleCounts(), output);
    }
    if (cell.hasTower())
    {
      var tower = cell.getTower();
      output.writeByte(TOWER);
      savePos(x, y, output);
      output.writeByte(tower.getType());
      output.writeByte(tower.getLevel());
      tower.saveEditResources(output);

      var links = tower.getTradeLinks();
      for (link in links)
      {
        addSaveLink(link, sources, dests);
      }
    }
    if (cell.hasObstacle())
    {
      output.writeByte(OBSTACLE);
      savePos(x, y, output);
      output.writeByte(cell.getObstacle());
    }
  }

  static function addSaveLink(link : Route, sources : Array<Point>,
                              dests : Array<Point>) : Void
  {
    var found = false;
    for (i in 0...sources.length)
    {
      if ((Point.isEqual(link.source, sources[i])
           && Point.isEqual(link.dest, dests[i]))
          || (Point.isEqual(link.source, dests[i])
              && Point.isEqual(link.dest, sources[i])))
      {
        found = true;
        break;
      }
    }
    if (!found)
    {
      sources.push(link.source);
      dests.push(link.dest);
    }
  }

  public static function savePos(x : Int, y : Int,
                                 output : flash.utils.ByteArray) : Void
  {
    output.writeByte(x);
    output.writeByte(y);
  }

  public static function saveResources(resources : Array<Int>,
                                       output : flash.utils.ByteArray) : Void
  {
    for (i in 0...resources.length)
    {
      var payload = Lib.indexToResource(i);
      if (payload != Resource.FOOD)
      {
        var count = Math.floor(resources[i] / Lib.truckLoad(payload));
        output.writeByte(count);
      }
    }
  }

  public static function loadMap(input : flash.utils.ByteArray,
                                 boxes : List<EditBox>) : Void
  {
    isLoading = true;
    var mapLot = new Section(new Point(Editor.edgeCount, Editor.edgeCount),
                             new Point(Game.map.size().x - Editor.edgeCount,
                                       Game.map.size().y - Editor.edgeCount));
    Util.fillBlocked(mapLot);
    Util.fillBackground(mapLot, BackgroundType.STREET);
    var hasShown = false;
    while (input.bytesAvailable > 0)
    {
      var typeNumber = input.readUnsignedByte();
      var type = EditBox.intToType(typeNumber);
      if (! hasShown
          && (typeNumber == ZOMBIE || typeNumber == RUBBLE
              || typeNumber == TOWER || typeNumber == SUPPLY_LINE
              || typeNumber == OBSTACLE))
      {
        for (box in boxes)
        {
          box.show();
        }
        hasShown = true;
      }
      if (typeNumber == ZOMBIE)
      {
        loadZombie(input);
      }
      else if (typeNumber == RUBBLE)
      {
        loadRubble(input);
      }
      else if (typeNumber == TOWER)
      {
        loadTower(input);
      }
      else if (typeNumber == SUPPLY_LINE)
      {
        loadSupplyLine(input);
      }
      else if (typeNumber == OBSTACLE)
      {
        loadObstacle(input);
      }
      else if (type == EditBox.UNKNOWN || type == EditBox.STREET_H
               || type == EditBox.STREET_V || type == EditBox.PARKING_LOT
               || type == EditBox.PARK || type == EditBox.PLAZA
               || type == EditBox.SHALLOW_WATER || type == EditBox.DEEP_WATER
               || type == EditBox.BRIDGE || type == EditBox.STREET
               || type == EditBox.CORNER || type == EditBox.INTERSECTION)
      {
        loadSimple(type, input, boxes);
      }
      else if (EditBox.isBuilding(type))
      {
        loadStandardBuilding(type, input, boxes);
      }
    }
    if (! hasShown)
    {
      for (box in boxes)
      {
        box.show();
      }
    }
    sanityCheck();
    isLoading = false;
    for (box in boxes)
    {
      box.showObstacles();
    }
    drawPixels(boxes);
    Game.sprites.recalculateFov();
  }

  static function loadSimple(type : EditType, input : flash.utils.ByteArray,
                             boxes : List<EditBox>) : Void
  {
    var section = loadSection(input);
    if (! Lib.outsideMap(section.offset)
        && section.limit.x <= Game.map.sizeX()
        && section.limit.y <= Game.map.sizeY())
    {
      var newBox = new EditBox(section.offset, section.limit);
      boxes.add(newBox);
      newBox.bind();
      newBox.changeType(type, true);
      if (type == EditBox.BRIDGE)
      {
        newBox.setBroken(loadBool(input), true);
      }
      loadDirections(type, newBox, input);
    }
    else
    {
      if (type == EditBox.BRIDGE)
      {
        loadBool(input);
      }
      if (EditBox.hasDirection(type))
      {
        input.readUnsignedByte();
      }
    }
  }

  static function loadStandardBuilding(type : EditType,
                                       input : flash.utils.ByteArray,
                                       boxes : List<EditBox>) : Void
  {
    var section = loadSection(input);
    var entrance = loadPos(input);
    var zombieCount = input.readUnsignedByte();
    var resources = loadResources(input);
    if (! Lib.outsideMap(section.offset)
        && section.limit.x <= Game.map.sizeX()
        && section.limit.y <= Game.map.sizeY())
    {
      var newBox = new EditBox(section.offset, section.limit);
      boxes.add(newBox);
      newBox.changeType(type, true);
      newBox.bind();
      newBox.setEntrance(entrance, true);
      newBox.addZombies(zombieCount);
      for (i in 0...resources.length)
      {
        if (resources[i] > 0)
        {
          var payload = Lib.indexToResource(i);
          newBox.addResources(payload, resources[i]);
        }
      }
      loadDirections(type, newBox, input);
    }
    else
    {
      if (EditBox.hasDirection(type))
      {
        input.readUnsignedByte();
      }
    }
  }

  static function loadZombie(input : flash.utils.ByteArray) : Void
  {
    var pos = loadPos(input);
    var count = input.readUnsignedByte();
    if (! Lib.outsideMap(pos))
    {
      EditChange.addZombie(pos, count);
    }
  }

  static function loadRubble(input : flash.utils.ByteArray) : Void
  {
    var pos = loadPos(input);
    var resources = loadResources(input);
    if (! Lib.outsideMap(pos))
    {
      EditChange.createRubble(pos, resources);
    }
  }

  static function loadTower(input : flash.utils.ByteArray) : Void
  {
    var pos = loadPos(input);
    var type = input.readUnsignedByte();
    var upgrade = input.readUnsignedByte();
    var stock = loadResources(input);
    var quota = loadResources(input);
    if (! Lib.outsideMap(pos))
    {
      EditChange.createTower(pos, type, upgrade, stock, quota);
    }
  }

  static function loadSupplyLine(input : flash.utils.ByteArray) : Void
  {
    var source = loadPos(input);
    var dest = loadPos(input);
    if (! Lib.outsideMap(source) && ! Lib.outsideMap(dest))
    {
      var sourceTower = Game.map.getCell(source.x, source.y).getTower();
      var destTower = Game.map.getCell(dest.x, dest.y).getTower();
      if (sourceTower != null && destTower != null)
      {
        sourceTower.addTradeLink(dest);
      }
    }
  }

  static function loadObstacle(input : flash.utils.ByteArray) : Void
  {
    var pos = loadPos(input);
    var type = input.readUnsignedByte();
    if (! Lib.outsideMap(pos))
    {
      EditChange.addObstacle(pos, type);
    }
  }

  static function loadPos(input : flash.utils.ByteArray,
                          ? isSize : Null<Bool>) : Point
  {
    var x = input.readUnsignedByte();
    var y = input.readUnsignedByte();
    if (! Game.settings.doesHaveEdges() && isSize != true)
    {
      x += 5;
      y += 5;
    }
    return new Point(x, y);
  }

  static function loadSection(input : flash.utils.ByteArray) : Section
  {
    var offset = loadPos(input);
    var limit = offset.clone();
    limit.plusEquals(loadPos(input, true));
    return new Section(offset, limit);
  }

  static function loadResources(input : flash.utils.ByteArray) : Array<Int>
  {
    var result = Lib.newResourceArray();
    for (i in 0...result.length)
    {
      if (i != Lib.resourceToIndex(Resource.FOOD))
      {
        result[i] = input.readUnsignedByte();
      }
    }
    return result;
  }

  static function loadDirections(type : EditType, box : EditBox,
                                 input : flash.utils.ByteArray) : Void
  {
    if (EditBox.hasDirection(type))
    {
      var dirByte = input.readUnsignedByte();
      var primaryIndex = (dirByte & 0x3);
      var secondaryIndex = ((dirByte >> 2) & 0x3);
      box.setDirections(Lib.indexToDirection(primaryIndex),
                        Lib.indexToDirection(secondaryIndex));
    }
  }

  public static function saveDirections(type : EditType, primary : Direction,
                                        secondary : Direction,
                                        output : flash.utils.ByteArray) : Void
  {
    if (EditBox.hasDirection(type))
    {
      var primaryIndex = Lib.directionToIndex(primary);
      var secondaryIndex = Lib.directionToIndex(secondary);
      var outByte = (primaryIndex & 0x3);
      outByte = (outByte | ((secondaryIndex & 0x3) << 2));
      output.writeByte(outByte);
    }
  }

  static function loadBool(input : flash.utils.ByteArray) : Bool
  {
    var value = input.readUnsignedByte();
    if (value == 0)
    {
      return false;
    }
    else
    {
      return true;
    }
  }

  public static function saveBool(value : Bool,
                                  output : flash.utils.ByteArray) : Void
  {
    if (value)
    {
      output.writeByte(1);
    }
    else
    {
      output.writeByte(0);
    }
  }

  static function sanityCheck() : Void
  {
    var mapLot = new Section(new Point(0, 0), Game.map.size().clone());
    for (dir in Lib.directions)
    {
      var lot = mapLot.slice(dir, 1);
      Util.fillBlocked(lot);
    }
    var source = Game.progress.getRandomDepot();
    if (source != null)
    {
      var guide = new PathFinder(source, null, true, null);
      guide.setupVisit();
      guide.startCalculation();
      while (! guide.isDone())
      {
        guide.step(100);
      }
      cleanupMap(guide);
    }
  }

  static function cleanupMap(guide : PathFinder) : Void
  {
    var pos = new Point(0, 0);
    for (y in 0...Game.map.sizeY())
    {
      for (x in 0...Game.map.sizeX())
      {
        pos.x = x;
        pos.y = y;
        if (! guide.isVisited(pos))
        {
          cleanupMapSquare(pos);
        }
        checkRubble(pos);
      }
    }
  }

  static function cleanupMapSquare(pos : Point) : Void
  {
    var cell = Game.map.getCell(pos.x, pos.y);
    if (cell.hasTower())
    {
      cell.destroyTower();
    }
    if (cell.hasRubble())
    {
      cell.clearRubble();
    }
    while (cell.hasZombies())
    {
      var zombie = cell.getZombie();
      if (zombie != null)
      {
        cell.removeZombie(zombie);
        zombie.cleanup();
      }
    }
    if (cell.getBackground() == BackgroundType.ENTRANCE)
    {
      var building = cell.getBuilding();
      building.clearZombies();
      var salvage = building.getSalvage();
      for (resource in Lib.resource)
      {
        var count = salvage.getResourceCount(resource);
        salvage.addResource(resource, -count);
      }
    }
    cell.setBlocked();
  }

  static function checkRubble(pos : Point) : Void
  {
    var cell = Game.map.getCell(pos.x, pos.y);
    if (cell.hasRubble())
    {
      var allZero = true;
      for (current in cell.getAllRubbleCounts())
      {
        if (current != 0)
        {
          allZero = false;
          break;
        }
      }
      if (allZero)
      {
        cell.clearRubble();
      }
    }
  }

  static function drawPixels(boxes : List<EditBox>) : Void
  {
    if (Game.settings.isEditor())
    {
      for (box in boxes)
      {
        box.drawPixels();
      }
    }
    else
    {
      Game.view.window.fillBitmap();
    }
  }

  public static var isLoading = false;
}
