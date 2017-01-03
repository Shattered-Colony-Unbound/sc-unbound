// Keeps track of which buildings and which map cells have zombies in
// them. Used by the spawner to choose zombies on the map to send
// waves as.

class ZombieTracker
{
  public function new() : Void
  {
    cellList = [];
    cellToIndex = new haxe.ds.IntMap<Int>();
    buildingList = [];
  }

  public function cleanup() : Void
  {
  }

  public function addCell(pos : Point) : Void
  {
    var posInt = pos.x + (pos.y * Game.map.sizeX());
    if (! cellToIndex.exists(posInt))
    {
      cellList.push(posInt);
      cellToIndex.set(posInt, cellList.length - 1);
      var dest = Lib.rand(cellList.length);
      swapCell(cellList.length - 1, dest);
    }
  }

  public function removeCell(pos : Point) : Void
  {
    var posInt = pos.x + (pos.y * Game.map.sizeX());
    if (cellToIndex.exists(posInt))
    {
      var index = cellToIndex.get(posInt);
      swapCell(cellList.length - 1, index);
      cellToIndex.remove(posInt);
      cellList.pop();
    }
  }

  public function getCell() : Point
  {
    var result = null;
    if (cellList.length > 0)
    {
      var posInt = cellList[cellList.length - 1];
      result = new Point(posInt % Game.map.sizeX(),
                         Math.floor(posInt / Game.map.sizeX()));
      var dest = Lib.rand(cellList.length);
      swapCell(cellList.length - 1, dest);
    }
    return result;
  }

  // Swaps the cells at two indices of cellList. Updates cellToIndex
  // appropriately.
  function swapCell(first : Int, second : Int)
  {
    cellToIndex.set(cellList[first], second);
    cellToIndex.set(cellList[second], first);
    var temp = cellList[first];
    cellList[first] = cellList[second];
    cellList[second] = temp;
  }

  public function addBuildings() : Void
  {
    for (building in Game.map.getBuildings())
    {
      buildingList.push(building);
      var dest = Lib.rand(buildingList.length);
      swapBuilding(buildingList.length - 1, dest);
    }
  }

  public function getBuilding() : Building
  {
    var result = null;
    while (result == null && buildingList.length > 0)
    {
      var current = buildingList[buildingList.length - 1];
      if (current.hasZombies())
      {
        result = buildingList[buildingList.length - 1];
        var dest = Lib.rand(buildingList.length);
        swapBuilding(buildingList.length - 1, dest);
      }
      else
      {
        buildingList.pop();
      }
    }
    return result;
  }

  function swapBuilding(first : Int, second : Int)
  {
    var temp = buildingList[first];
    buildingList[first] = buildingList[second];
    buildingList[second] = temp;
  }

  public function save() : Dynamic
  {
    return { cellList : cellList.copy(),
             entrances : saveEntrances() };
  }

  function saveEntrances() : Array<Dynamic>
  {
    var result = new Array<Dynamic>();
    for (building in buildingList)
    {
      result.push(building.getEntrance().save());
    }
    return result;
  }

  public function load(input : Dynamic) : Void
  {
    cellList = [];
    cellToIndex = new haxe.ds.IntMap<Int>();
    buildingList = [];

    for (i in 0...(input.cellList.length))
    {
      cellList.push(input.cellList[i]);
      cellToIndex.set(input.cellList[i], i);
    }
    for (i in 0...(input.entrances.length))
    {
      var pos = Point.load(input.entrances[i]);
      var current = Game.map.getCell(pos.x, pos.y).getBuilding();
      buildingList.push(current);
    }
  }

  // A list of cell positions. Each int represents the position as a
  // single number.
  var cellList : Array<Int>;
  // Maps cell positions to their index in cellList.
  var cellToIndex : haxe.ds.IntMap<Int>;
  // List of buildings which may have zombies.
  var buildingList : Array<Building>;
}
