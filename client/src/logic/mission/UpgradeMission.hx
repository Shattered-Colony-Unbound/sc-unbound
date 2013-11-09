package logic.mission;

class UpgradeMission extends Mission
{
  public static function create(newSource : Point,
                                newDest : Point,
                                newPayload : Resource) : Mission
  {
    var result : Mission = null;
    var destTower = Game.map.getCell(newDest.x, newDest.y).getTower();
    if (Mission.sourceHasPayload(newSource, newPayload)
        && destTower != null
        && destTower.canUpgrade())
    {
      result = new UpgradeMission(newSource, newDest, newPayload);
    }
    return result;
  }

  private function new(newSource : Point,
                       newDest : Point,
                       newPayload : Resource) : Void
  {
    super(newSource, newDest, newPayload);
    if (newSource != null)
    {
      takePayload();
      sourceTower.addIncomingSurvivor(survivorType);

      destTower.reserveUpgrade();
    }
    type = Mission.UPGRADE;
  }

  override public function cleanup() : Void
  {
    if (sourceExists())
    {
      sourceTower.removeIncomingSurvivor(survivorType);
    }
    if (destExists())
    {
      destTower.freeUpgrade();
    }
  }

  override public function complete() : Mission
  {
    var result : Mission = null;
    if (destExists())
    {
      cleanup();
      destTower.upgrade();
      payload = Resource.SURVIVORS;
      result = ReturnMission.create(dest, source, Resource.SURVIVORS, 1,
                                    survivorType);
    }
    else
    {
      result = fail();
    }
    return result;
  }

  override public function fail() : Mission
  {
    cleanup();
    var amount = Option.truckLoad;
    if (payload == Resource.SURVIVORS)
    {
      amount = 1;
    }
    return ReturnMission.create(dest, source, payload, amount, survivorType);
  }

  override public function save() : Dynamic
  {
    return { parent : super.save() };
  }

  public static function load(input : Dynamic) : UpgradeMission
  {
    var result = new UpgradeMission(null, null, null);
    return result;
  }
}
