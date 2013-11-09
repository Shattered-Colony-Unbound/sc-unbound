package logic.mission;

class ReturnMission extends Mission
{
  static function isValid(newDest : Point, newPayload : Resource,
                          newAmount : Int) : Bool
  {
    var destTower = Game.map.getCell(newDest.x, newDest.y).getTower();
    return destTower != null;
  }

  public static function create(newSource : Point,
                                newDest : Point,
                                newPayload : Resource,
                                newAmount : Int,
                                newType : Int)
  {
    var result : Mission = null;
    var hq = Game.progress.getRandomDepot();
    if (isValid(newDest, newPayload, newAmount))
    {
      result = new ReturnMission(newSource, newDest, newPayload, newAmount,
                                 newType);
    }
    else if (hq != null && isValid(hq, newPayload, newAmount))
    {
      result = new ReturnMission(newSource, hq, newPayload, newAmount,
                                 newType);
    }
    return result;
  }

  private function new(newSource : Point,
                       newDest : Point,
                       newPayload : Resource,
                       newAmount : Int,
                       newType : Int)
  {
    super(newSource, newDest, newPayload);
    survivorType = newType;
    amount = newAmount;
    if (newSource != null)
    {
      if (payload != Resource.SURVIVORS)
      {
        destTower.addIncoming(new ResourceCount(payload, amount));
      }
      destTower.addIncomingSurvivor(survivorType);
    }
    type = Mission.RETURN;
  }

  override public function dropLoad(x : Int, y : Int) : Void
  {
    if (payload != Resource.SURVIVORS)
    {
      Game.map.getCell(x, y).addRubble(payload, amount);
    }
  }

  override public function cleanup() : Void
  {
    if (destExists())
    {
      if (payload != Resource.SURVIVORS)
      {
        destTower.removeIncoming(new ResourceCount(payload, amount));
      }
      destTower.removeIncomingSurvivor(survivorType);
    }
  }

  override public function complete() : Mission
  {
    var result : Mission = null;
    if (destExists())
    {
      cleanup();
      if (payload != Resource.SURVIVORS)
      {
        destTower.giveResource(new ResourceCount(payload, amount));
      }
      destTower.giveSurvivor(survivorType);
    }
    else
    {
      result = fail();
    }
    return result;
  }

  override public function fail() : Mission
  {
    var result : Mission = null;
    var hq = Game.progress.getRandomDepot();
    if (hq != null)
    {
      result = create(source, hq, payload, amount, survivorType);
    }
    cleanup();
    return result;
  }

  override public function takeFood() : Int
  {
//    var base = Option.truckSpeedMin + Lib.rand(Option.truckSpeedRange);
//    return base*Option.foodBoost;
    return Option.returnTruckSpeedMin + Lib.rand(Option.returnTruckSpeedRange);
  }

  override public function save() : Dynamic
  {
    return { parent : super.save(),
             amount : amount };
  }

  public static function load(input : Dynamic) : ReturnMission
  {
    var result = new ReturnMission(null, null, null, 0, 0);
    result.amount = input.amount;
    return result;
  }

  var amount : Int;
}
