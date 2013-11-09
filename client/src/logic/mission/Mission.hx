package logic.mission;

class Mission
{
  public function new(newSource : Point,
                      newDest : Point,
                      newPayload : Resource) : Void
  {
    source = null;
    sourceTower = null;
    dest = null;
    destTower = null;
    payload = null;
    if (newSource != null)
    {
      source = new Point(newSource.x, newSource.y);
      sourceTower = Game.map.getCell(source.x, source.y).getTower();
      dest = new Point(newDest.x, newDest.y);
      destTower = Game.map.getCell(dest.x, dest.y).getTower();
      payload = newPayload;
    }
    type = 0;
  }

  public function canSucceed() : Bool
  {
    return destExists();
  }

  // Add the current load to the rubble. Does not cleanup.
  public function dropLoad(x : Int, y : Int) : Void
  {
    if (payload != Resource.SURVIVORS)
    {
      Game.map.getCell(x, y).addRubble(payload, Option.truckLoad);
    }
  }

  // Cleanup any state this mission touches. Call this when a mission
  // is being destroyed by an external factor.
  public function cleanup() : Void
  {
  }

  // Complete the mission if possible. If the mission completes
  // successfully or retry is impossible, null is returned. If the
  // mission fails, but a new mission might recover the situation, a
  // new mission is returned. Regardless, the state the mission has
  // touched is cleaned up as with the cleanup() function. The new
  // mission may need to be cleaned up at a later time.
  public function complete() : Mission
  {
    return null;
  }

  // The mission has failed. Cleanup its state. Return a new mission
  // if possible. If no new mission is possible, return null.
  public function fail() : Mission
  {
    return null;
  }

  public function getSource() : Point
  {
    return source;
  }

  public function getDest() : Point
  {
    return dest;
  }

  public function getPayload() : Resource
  {
    return payload;
  }

  // Returns the speed used by the truck running this mission.
  public function takeFood() : Int
  {
    var speed = 0;
    if (sourceTower != null)
    {
      speed = sourceTower.getTruckSpeed();
      if (sourceTower.shouldUseFood())
      {
        var payload = new ResourceCount(Resource.FOOD,
                                        sourceTower.getFoodCost());
        if (sourceTower.hasResource(payload))
        {
          sourceTower.takeResource(payload);
          speed = Option.foodTruckSpeedMin
            + Lib.rand(Option.foodTruckSpeedRange);
//          speed *= Option.foodBoost;
        }
      }
    }
    return speed;
  }

  public function getSurvivorType() : Int
  {
    return survivorType;
  }

  function takePayload() : Void
  {
    if (payload != Resource.SURVIVORS)
    {
      sourceTower.takeResource(new ResourceCount(payload,
                                                 Lib.truckLoad(payload)));
    }
    survivorType = sourceTower.takeSurvivor();
  }

  function sourceExists() : Bool
  {
    return sourceTower != null
      && Game.map.getCell(source.x, source.y).getTower() == sourceTower;
  }

  function destExists() : Bool
  {
    return destTower != null
      && Game.map.getCell(dest.x, dest.y).getTower() == destTower;
  }

  static function sourceHasPayload(theSource : Point,
                                   thePayload : Resource) : Bool
  {
    var theTower = Game.map.getCell(theSource.x, theSource.y).getTower();
    return (theTower != null
            && theTower.hasResource(new ResourceCount(thePayload,
                                                   Lib.truckLoad(thePayload)))
            && theTower.hasResource(Lib.survivorLoad));
  }

  public function save() : Dynamic
  {
    return { source : source.save(),
        dest : dest.save(),
        payload : Lib.resourceToIndex(payload),
        type : type,
        survivorType : survivorType};
  }

  public static function loadMission(input : Dynamic) : Mission
  {
    var result : Mission = null;
    if (input.parent.type == BUILD)
    {
      result = BuildMission.load(input);
    }
    else if (input.parent.type == RETURN)
    {
      result = ReturnMission.load(input);
    }
    else if (input.parent.type == SUPPLY)
    {
      result = SupplyMission.load(input);
    }
    else // input.parent.type == UPGRADE
    {
      result = UpgradeMission.load(input);
    }
    result.source = Point.load(input.parent.source);
    result.sourceTower = Game.map.getCell(result.source.x,
                                          result.source.y).getTower();
    result.dest = Point.load(input.parent.dest);
    result.destTower = Game.map.getCell(result.dest.x,
                                        result.dest.y).getTower();
    result.payload = Lib.indexToResource(input.parent.payload);
    result.type = input.parent.type;
    result.survivorType = input.parent.survivorType;
    return result;
  }

  var source : Point;
  var sourceTower : Tower;
  var dest : Point;
  var destTower : Tower;
  var payload : Resource;
  var type : Int;
  var survivorType : Int;

  public static var BUILD = 0;
  public static var RETURN = 1;
  public static var SUPPLY = 2;
  public static var UPGRADE = 3;
}
