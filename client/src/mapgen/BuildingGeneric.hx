// Randomly selects between one of several generic building plans.

package mapgen;

class BuildingGeneric extends BuildingRoot
{
  public function new(newBuilding : Building) : Void
  {
    super(newBuilding);
  }

  override public function place(base : Section) : Void
  {
    var options = [new BuildingFringe(building),
                   new BuildingPlant(building)];
    var choice = Util.rand(options.length);
    options[choice].place(base);
  }
}
