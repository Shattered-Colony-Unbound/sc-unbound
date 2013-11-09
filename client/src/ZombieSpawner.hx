class ZombieSpawner
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      newSettings : logic.GameSettings) : Void
  {
    extraZombies = 0;
    hordeCount = 0;
    wandering = 0;
    currentWaveCount = 0;
    isCounting = false;
    settings = newSettings;
  }

  public function cleanup() : Void
  {
  }

  public function startCountDown(? newCountdown : Null<Int>) : Void
  {
    if (newCountdown == null || newCountdown <= 0)
    {
      isCounting = false;
    }
    else
    {
      isCounting = true;
      wandering = newCountdown * Option.fps;
    }
  }

  public function getIsCounting() : Bool
  {
    return isCounting;
  }

  public function addToWave() : Void
  {
    currentWaveCount += 1;
  }

  public function removeFromWave() : Void
  {
    currentWaveCount -= 1;
    if (currentWaveCount == 0)
    {
      Main.music.changeMusic(ui.MusicPlayer.WAVE_END, false);
      Game.script.trigger(logic.Script.ZOMBIE_HORDE_END);
    }
  }

  public function getWaveCount() : Int
  {
    return currentWaveCount;
  }

  public function reduceZombies() : Void
  {
    hordeCount = Math.floor(hordeCount / 2);
  }

  public function getFramesLeft() : Int
  {
    return wandering;
  }

  public function step() : Void
  {
    if (isCounting && currentWaveCount == 0 && ! Game.pause.isPaused())
    {
      --wandering;
      if (wandering <= 0)
      {
        wandering = 0;
        isCounting = false;
        Game.script.trigger(logic.Script.COUNTDOWN_COMPLETE);
      }
    }
  }

  public function startHorde(? count : Null<Int>, ? spawnPos : Point) : Void
  {
    Game.script.trigger(logic.Script.ZOMBIE_HORDE_BEGIN);
    var zombieCount = getNextWaveSize();
    if (count != null)
    {
      zombieCount = count;
    }
    var source = Lib.rand(1 + Game.progress.getBridgeCount());
    if (Game.progress.getZombieCount() == 0 || count != null)
    {
      source = Lib.rand(Game.progress.getBridgeCount()) + 1;
    }
    if (settings.getEasterEgg() != logic.GameSettings.FIDDLERSGREEN)
    {
      var bridge = Game.progress.getRandomBridge();
      extraZombies = Math.floor(extraZombies / 2);
      for (i in 0...Math.floor(zombieCount))
      {
        spawnZombie(source, bridge, spawnPos);
      }
    }
    else
    {
      spawnZombiesFromWater(zombieCount);
    }
    if (count == null)
    {
      ++hordeCount;
    }
    Main.sound.play(SoundPlayer.ZOMBIE_CROWD_MOAN);
    Main.music.changeMusic(ui.MusicPlayer.randomWave(), true);
  }

  public function addZombie() : Void
  {
    ++extraZombies;
  }

  private function spawnZombie(source : Int, bridge : logic.Bridge,
                               spawnPos : Point) : Void
  {
    var dest = Game.progress.getRandomDepot();
    var guide = Game.map.getCell(dest.x, dest.y).getTower().getZombieGuide();
    var newZombie : Zombie = null;
    if (spawnPos != null)
    {
      spawnSingleZombie(spawnPos, dest, guide, Lib.randDirection());
    }
    else if (source == 0)
    {
      var flip = Lib.rand(2);
      if (flip == 0)
      {
        // Zombie in building
        var building = Game.tracker.getBuilding();
        if (building != null)
        {
          building.spawn(dest, guide);
        }
      }
      else
      {
        // Zombie on the ground
        var pos = Game.tracker.getCell();
        if (pos != null)
        {
          Game.map.getCell(pos.x, pos.y).spawn(dest, guide);
        }
      }
    }
    else
    {
      if (bridge != null)
      {
        var pos = bridge.spawnPos();
        var dir = bridge.spawnDir();
        spawnSingleZombie(pos, dest, guide, dir);
      }
    }
  }

  function spawnZombiesFromWater(count : Int)
  {
    var dir = Lib.randDirection();
    var lot = Game.map.getCityLot().slice(dir, 1);
    var size = lot.getSize();
    for (i in 0...count)
    {
      var dest = Game.progress.getRandomDepot();
      var guide = Game.map.getCell(dest.x, dest.y).getTower().getZombieGuide();
      var pos = new Point(Lib.rand(size.x) + lot.offset.x,
                          Lib.rand(size.y) + lot.offset.y);
      spawnSingleZombie(pos, dest, guide, mapgen.Util.opposite(dir));
    }
  }

  function spawnSingleZombie(pos : Point, dest : Point, guide : PathFinder,
                             dir : Direction) : Void
  {
    var newZombie : Zombie = new Zombie(pos.x, pos.y,
                                        Lib.directionToAngle(dir),
                                        dest.x, dest.y,
                                        Zombie.WAVE_SPAWN);
    newZombie.makeNoise(dest, 0, guide);
    newZombie.addToWave();
  }

  public function getNextWaveSize() : Int
  {
    var bridges = Game.progress.getBridgeCount() + 1;
    if (settings.getEasterEgg() == logic.GameSettings.RACCOONCITY
        || settings.getEasterEgg() == logic.GameSettings.FIDDLERSGREEN)
    {
      bridges = settings.getBridgeCount();
    }
    var increment = Option.wanderingZombieIncrement * hordeCount * bridges;
    return Option.wanderingZombieBase + increment;
  }

  public function save() : Dynamic
  {
    return { extraZombies : extraZombies,
        hordeCount : hordeCount,
        wandering : wandering,
        currentWaveCount : currentWaveCount,
        isCounting : isCounting };

  }

  public function load(input : Dynamic) : Void
  {
    extraZombies = input.extraZombies;
    hordeCount = input.hordeCount;
    wandering = input.wandering;
    currentWaveCount = input.currentWaveCount;
    isCounting = input.isCounting;
  }

  var extraZombies : Int;
  var hordeCount : Int;
  var wandering : Int;
  var currentWaveCount : Int;
  var isCounting : Bool;
  var settings : logic.GameSettings;
}
