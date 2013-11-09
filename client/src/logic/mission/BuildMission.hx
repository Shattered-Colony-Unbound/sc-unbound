package logic.mission;

class BuildMission extends Mission
{
  // Creates a new mission and allocates resources if necessary. If
  // the resources don't exits, returns null.
  public static function create(newSource : Point,
                                newDest : Point,
                                newPayload : Resource,
                                newBuildType : Int) : Mission
  {
    var result : Mission = null;
    if (Mission.sourceHasPayload(newSource, newPayload)
        && ! Game.map.getCell(newDest.x, newDest.y).hasTower())
    {
      result = new BuildMission(newSource, newDest, newPayload, newBuildType);
    }
    return result;
  }

  private function new(newSource : Point,
                       newDest : Point,
                       newPayload : Resource,
                       newBuildType : Int) : Void
  {
    super(newSource, newDest, newPayload);
    buildType = newBuildType;
    shadow = null;

    if (newSource != null)
    {
      takePayload();
      shadow = Game.map.getCell(dest.x, dest.y).setShadow(buildType);
      if (buildType == Tower.BARRICADE)
      {
        sourceTower.addIncomingSurvivor(survivorType);
      }
    }

    type = Mission.BUILD;
  }

  override public function canSucceed() : Bool
  {
    return Game.map.getCell(dest.x, dest.y).getShadow() == shadow;
  }

  override public function cleanup() : Void
  {
    if (shadow == Game.map.getCell(dest.x, dest.y).getShadow())
    {
      Game.map.getCell(dest.x, dest.y).clearShadow();
    }
    if (buildType == Tower.BARRICADE)
    {
      sourceTower.removeIncomingSurvivor(survivorType);
    }
  }

  override public function complete() : Mission
  {
    var result : Mission = null;
    var destCell = Game.map.getCell(dest.x, dest.y);
    if (! destCell.hasZombies() && ! destCell.hasTower()
        && destCell.hasShadow())
    {
      cleanup();
      destCell.createTower(buildType);
      destTower = destCell.getTower();
      if (sourceExists())
      {
        sourceTower.addTradeLink(dest);
      }
      Game.map.noise(dest.x, dest.y, Option.buildNoise,
                     destTower.getZombieGuide());
      Main.sound.play(SoundPlayer.TOWER_BUILD);
      if (buildType == Tower.BARRICADE)
      {
        destTower.giveResource(new ResourceCount(payload,
                                                 Lib.truckLoad(payload)));
        result = ReturnMission.create(dest, source, Resource.SURVIVORS,
                                      Lib.truckLoad(Resource.SURVIVORS),
                                      survivorType);
      }
      else
      {
        destTower.giveSurvivor(survivorType);
      }
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
    return { parent : super.save(),
             buildType : buildType };
  }

  public static function load(input : Dynamic) : BuildMission
  {
    var result = new BuildMission(null, null, null, 0);
    result.buildType = input.buildType;
    result.shadow = Game.map.getCell(input.parent.dest.x,
                                     input.parent.dest.y).getShadow();
    return result;
  }

  var buildType : Int;
  var shadow : ui.TowerSprite;
}
