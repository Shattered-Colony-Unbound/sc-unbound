class ActorList
{
  public function new() : Void
  {
    list = new List<Actor>();
    reaper = new List<Actor>();
  }

  public function add(actor : Actor) : Void
  {
    list.add(actor);
  }

  public function remove(actor : Actor) : Void
  {
    reaper.add(actor);
  }

  public function enterFrame() : Void
  {
    var danceMod = Game.settings.getPlayTime() % Option.dancePeriod;
    var easterEgg = Game.settings.getEasterEgg();
    var shouldDance = easterEgg == logic.GameSettings.EASTLOSANGELES
      && danceMod == Option.dancePeriod - 1;
    var isPositive = true;
    if (shouldDance && Lib.rand(2) == 0)
    {
      isPositive = false;
    }
    tidyList();
    for (actor in list)
    {
      if (! listContains(reaper, actor))
      {
        if (shouldDance)
        {
          actor.dance(isPositive);
        }
        actor.enterFrame();
      }
    }
    tidyList();
  }

  function listContains<T>(list : List<T>, key : T) : Bool
  {
    var result = false;
    for (current in list)
    {
      if (current == key)
      {
        result = true;
        break;
      }
    }
    return result;
  }

  function tidyList() : Void
  {
    for (current in reaper)
    {
      list.remove(current);
    }
    reaper.clear();
  }

  public function save() : Dynamic
  {
    return { towers : Save.saveList(list, Actor.saveTowerS),
             zombies : Save.saveList(list, Actor.saveZombieS),
             trucks : Save.saveList(list, Actor.saveTruckS) };
  }

  public function load(input : Dynamic) : Void
  {
    var towers = Load.loadList(input.towers, Tower.loadS);
    var zombies = Load.loadList(input.zombies, Zombie.loadS);
    var trucks = Load.loadList(input.trucks, Truck.loadS);
  }

  var list : List<Actor>;
  var reaper : List<Actor>;
}
