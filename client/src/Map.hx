class Map
{
  public function new(size : Point) : Void
  {
    blocked = new List<Route>();
    buildings = new List<Building>();
    cellMap = new Grid<MapCell>(size.x, size.y);
    for (y in 0...size.y)
    {
      for (x in 0...size.x)
      {
          cellMap.set(x, y, new MapCell());
      }
    }
    cityLot = null;
  }

  public function cleanup() : Void
  {
    cellMap = null;
    blocked = null;
  }

  public function getCell(x : Int, y : Int) : MapCell
  {
    return cellMap.get(x, y);
  }

  public function sizeX() : Int
  {
    return cellMap.sizeX();
  }

  public function sizeY() : Int
  {
    return cellMap.sizeY();
  }

  public function size() : Point
  {
    return new Point(sizeX(), sizeY());
  }

  public function findTowers(x : Int, y : Int, range : Int) : List<Point>
  {
    var result = new List<Point>();
    var minX = cast(Math.max(0, x - range), Int);
    var maxX = cast(Math.min(sizeX(), x + range + 1), Int);
    var minY = cast(Math.max(0, y - range), Int);
    var maxY = cast(Math.min(sizeY(), y + range + 1), Int);
    for (yPos in minY...maxY)
    {
      for (xPos in minX...maxX)
      {
        if (getCell(xPos, yPos).hasTower())
        {
          result.push(new Point(xPos, yPos));
        }
      }
    }
    return result;
  }

  // x and y are in cells, range is in cells
  public function noise(x : Int, y : Int, range : Int,
                        guide : PathFinder) : Void
  {
    var source : Point = new Point(x, y);

    var minX = cast(Math.max(0, x - range), Int);
    var maxX = cast(Math.min(sizeX(), x + range + 1), Int);
    var minY = cast(Math.max(0, y - range), Int);
    var maxY = cast(Math.min(sizeY(), y + range + 1), Int);
    for (yPos in minY...maxY)
    {
      for (xPos in minX...maxX)
      {
/*
        var loudness : Int = (range + 1)
          - Math.floor(Math.max(Math.abs(y - yPos),
                                Math.abs(x - xPos)));
*/
        var loudness = range;
        getCell(xPos, yPos).makeNoise(source, loudness, guide);
      }
    }
  }

  public function addBuilding(newBuilding : Building) : Void
  {
    buildings.add(newBuilding);
  }

  public function getBuildings() : List<Building>
  {
    return buildings;
  }

  public function addBlocked(newBlocked : Route) : Void
  {
/*
    newBlocked.blocked = true;
    blocked.add(newBlocked);
*/
  }

  public function clearBlocked() : Void
  {
/*
    for (route in blocked)
    {
      route.blocked = false;
    }
    blocked.clear();
*/
  }

  public function setCityLot(newLot : mapgen.Section)
  {
    cityLot = new mapgen.Section(newLot.offset, newLot.limit);
  }

  public function getCityLot() : mapgen.Section
  {
    return cityLot;
  }
/*
  public function getTiles(pos : Point) : List<Int>
  {
    if (Lib.outside(pos))
    {
      return new List<Int>();
    }
    else
    {
      return getCell(pos.x, pos.y).getTiles();
    }
  }

  public function addTile(pos : Point, tile : Int) : Void
  {
    if (! Lib.outsideMap(pos))
    {
      getCell(pos.x, pos.y).addTile(tile);
    }
  }

  public function clearTiles(pos : Point) : Void
  {
    if (! Lib.outsideMap(pos))
    {
      getCell(pos.x, pos.y).clearTiles();
    }
  }

  public function setBackground(pos : Point,
                                background : BackgroundType) : Void
  {
    if (! Lib.outsideMap(pos))
    {
      getCell(pos.x, pos.y).setBackgroundType(background);
    }
  }

  public function getBackground(pos : Point) : BackgroundType
  {
    var result = BackgroundType.EDGE;
    if (! Lib.outsideMap(pos))
    {
      result = getCell(pos.x, pos.y).getBackgroundType();
    }
    return result;
  }

  public function setBlocked(pos : Point) : Void
  {
    if (! Lib.outsideMap(pos))
    {
      cell.setBlocked();
    }
  }

  public function clearBlocked(pos : Point) : Void
  {
    if (! Lib.outsideMap(pos))
    {
      cell.clearBlocked();
    }
  }

  public function changeBlocked(pos : Point, isBlocked : Bool) : Void
  {
    if (! Lib.outsideMap(pos))
    {
      var cell = getCell(pos.x, pos.y);
      if (isBlocked)
      {
        cell.setBlocked();
      }
      else
      {
        cell.clearBlocked();
      }
    }
  }

  public function isBlocked(pos : Point) : Bool
  {
    var result = true;
    if (! Lib.outsideMap(pos))
    {
      result = getCell(pos.x, pos.y).isBlocked();
    }
    return result;
  }
*/
  public function save() : Dynamic
  {
    return { cellMap : cellMap.save(MapCell.save),
        buildings : Save.saveList(buildings, Building.saveS),
        cityLot : Save.maybe(cityLot, mapgen.Section.save) };
  }

  public function load(input : Dynamic) : Void
  {
    for (y in 0...sizeY())
    {
      for (x in 0...sizeX())
      {
        var inputCell = input.cellMap.mBuffer[x + y*sizeX()];
        cellMap.get(x, y).load(inputCell);
      }
    }
    buildings = Load.loadList(input.buildings, Building.load);
    cityLot = Load.maybe(input.cityLot, mapgen.Section.load);
  }

  var cellMap : Grid<MapCell>;
  var blocked : List<Route>;
  var buildings : List<Building>;
  var cityLot : mapgen.Section;
}
