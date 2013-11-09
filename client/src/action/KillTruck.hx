package action;

class KillTruck implements Interface
{
  public function new(newTruck : Truck) : Void
  {
    deadTruck = newTruck;
  }

  public function run() : Void
  {
    deadTruck.dropLoad();
    deadTruck.spawnZombie();
  }

  var deadTruck : Truck;
}
