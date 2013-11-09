package logic.mission;

class SupplyMission extends Mission
{
  public static function create(newSource : Point,
                                newDest : Point,
                                newPayload : Resource,
                                newAmount : Int) : Mission
  {
    var result : Mission = null;
    var sourceTower = Game.map.getCell(newSource.x, newSource.y).getTower();
    var destTower = Game.map.getCell(newDest.x, newDest.y).getTower();
    if (sourceTower.countResource(newPayload) >= newAmount
        && sourceTower.hasResource(Lib.survivorLoad)
        && destTower != null)
    {
      result = new SupplyMission(newSource, newDest, newPayload, newAmount);
    }
    else
    {
      if (sourceTower.countResource(newPayload) < newAmount)
      {
        Lib.trace("Source tower does not have resources");
      }
      if (! sourceTower.hasResource(Lib.survivorLoad))
      {
        Lib.trace("Source tower does not have a survivor");
      }
      if (destTower == null)
      {
        Lib.trace("No Dest Tower");
      }
    }
    return result;
  }

  private function new(newSource : Point,
                       newDest : Point,
                       newPayload : Resource,
                       newAmount : Int) : Void
  {
    super(newSource, newDest, newPayload);
    amount = newAmount;
    if (newSource != null)
    {
      if (payload != Resource.SURVIVORS)
      {
        sourceTower.takeResource(new ResourceCount(payload, amount));
      }
      survivorType = sourceTower.takeSurvivor();

      if (payload == Resource.SURVIVORS)
      {
        destTower.addIncomingSurvivor(survivorType);
      }
      else
      {
        destTower.addIncoming(new ResourceCount(payload, amount));
        sourceTower.addIncomingSurvivor(survivorType);
      }
    }
    type = Mission.SUPPLY;
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
    if (payload == Resource.SURVIVORS)
    {
      if (destExists())
      {
        destTower.removeIncomingSurvivor(survivorType);
      }
    }
    else
    {
      if (destExists())
      {
        destTower.removeIncoming(new ResourceCount(payload, amount));
      }
      if (sourceExists())
      {
        sourceTower.removeIncomingSurvivor(survivorType);
      }
    }
  }

  override public function complete() : Mission
  {
    var result : Mission = null;
    if (destExists())
    {
      cleanup();
      if (payload == Resource.SURVIVORS)
      {
        destTower.giveSurvivor(survivorType);
      }
      else
      {
        destTower.giveResource(new ResourceCount(payload, amount));
      }
      if (payload != Resource.SURVIVORS)
      {
        payload = Resource.SURVIVORS;
        result = ReturnMission.create(dest, source, Resource.SURVIVORS, 1,
                                      survivorType);
      }
      Main.sound.play(SoundPlayer.TOWER_SUPPLY);
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
      result = ReturnMission.create(source, hq, payload, amount,
                                    survivorType);
    }
    cleanup();
    return result;
  }

  override public function save() : Dynamic
  {
    return { parent : super.save(),
             amount : amount };
  }

  public static function load(input : Dynamic) : SupplyMission
  {
    var result = new SupplyMission(null, null, null, 0);
    result.amount = input.amount;
    return result;
  }

  var amount : Int;
}
