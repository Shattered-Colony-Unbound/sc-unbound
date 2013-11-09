class Workshop extends Tower
{
  public function new(newX : Int, newY : Int) : Void
  {
    type = Tower.WORKSHOP;
    super(new Point(newX, newY), Option.workshopLevelLimit,
          Option.workshopSpeed, Option.workshopCost);
    addReserve(Lib.survivorLoad);
  }

  override public function step(count : Int) : Void
  {
    wait();
    var cell = Game.map.getCell(mapPos.x, mapPos.y);
    sendToDepot(cell.hasRubble());
    if (countResource(Resource.SURVIVORS) > 0)
    {
      var payload = cell.getRubble(null);
      if (payload != null)
      {
        if (payload == Resource.SURVIVORS)
        {
          var survivorType = Lib.rand(ui.Animation.carryAmmo.getTypeCount());
          giveSurvivor(survivorType);
        }
        else
        {
          giveResource(new ResourceCount(payload, 1));
        }
        Game.map.noise(mapPos.x, mapPos.y, Option.towerNoise, zombieGuide);
      }
      else if (cell.mFeature != null)
      {
        var isDone = cell.mFeature.doWork();
        Game.update.changeStatus();
        if (isDone)
        {
          Game.map.noise(mapPos.x, mapPos.y, Option.explosionNoise,
                         zombieGuide);
        }
        else
        {
          Game.map.noise(mapPos.x, mapPos.y, Option.towerNoise, zombieGuide);
        }
      }
      if (! cell.hasRubble()
          && cell.mFeature == null
          && countResource(Resource.AMMO) == 0
          && countResource(Resource.BOARDS) == 0
          && countResource(Resource.FOOD) == 0)
      {
        Game.view.window.refresh();
        if (cell.getBuilding() != null)
        {
          cell.getBuilding().refreshMinimap();
        }
        Game.actions.push(new action.CloseTower(mapPos.x, mapPos.y));
      }
    }
  }

  override public function giveResource(payload : ResourceCount) : Void
  {
    super.giveResource(payload);
    normalizeLevel();
  }

  override public function takeResource(payload : ResourceCount) : Void
  {
    super.takeResource(payload);
    normalizeLevel();
  }

  override function normalizeLevel() : Void
  {
    super.normalizeLevel();
    speed = stuff.count(Resource.SURVIVORS) * Option.workshopSpeedFactor;
  }

  override public function getType() : Int
  {
    return Tower.WORKSHOP;
  }

  override public function saveTower() : Dynamic
  {
    return { parent : super.saveTowerGeneric() };
  }

  override public function load(input : Dynamic) : Void
  {
    super.load(input.parent);
  }
}
