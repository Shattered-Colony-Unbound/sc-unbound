class BridgeExplosionSound extends flash.media.Sound { }
class ButtonFailedSound extends flash.media.Sound { }
class ButtonSuccessSound extends flash.media.Sound { }
class SniperShoot1Sound extends flash.media.Sound { }
class SniperShoot2Sound extends flash.media.Sound { }
class SniperShoot3Sound extends flash.media.Sound { }
class TimerPipSound extends flash.media.Sound { }
class TowerAbandonSound extends flash.media.Sound { }
class TowerBuildSound extends flash.media.Sound { }
class TowerDestroySound extends flash.media.Sound { }
class TowerSupplySound extends flash.media.Sound { }
class TowerUpgradeSound extends flash.media.Sound { }
class ZombieBash1Sound extends flash.media.Sound { }
class ZombieBash2Sound extends flash.media.Sound { }
class ZombieBash3Sound extends flash.media.Sound { }
class ZombieBash4Sound extends flash.media.Sound { }
class ZombieBash5Sound extends flash.media.Sound { }
class ZombieBash6Sound extends flash.media.Sound { }
class ZombieDeathSound extends flash.media.Sound { }
class ZombieMoanCrowdSound extends flash.media.Sound { }
class ZombieMoan1Sound extends flash.media.Sound { }
class ZombieMoan2Sound extends flash.media.Sound { }
class ZombieMoan3Sound extends flash.media.Sound { }
class ZombieMoan4Sound extends flash.media.Sound { }

class SoundPlayer
{
  public static var BRIDGE_EXPLOSION = 0;
  public static var BUTTON_FAILED = 1;
  public static var BUTTON_SUCCESS = 2;
  public static var SNIPER_SHOOT = 3;
  public static var TIMER_PIP = 6;
  public static var TOWER_ABANDON = 7;
  public static var TOWER_BUILD = 8;
  public static var TOWER_DESTROY = 9;
  public static var TOWER_SUPPLY = 10;
  public static var TOWER_UPGRADE = 11;
  public static var ZOMBIE_BASH = 12;
  public static var ZOMBIE_DEATH = 18;
  public static var ZOMBIE_CROWD_MOAN = 19;
  public static var ZOMBIE_MOAN = 20;

  public static var sniperShootCount = 3;
  static var zombieBashCount = 6;
  static var zombieMoanCount = 4;

  public static var soundCount = 25;

  public function new(parent : flash.display.DisplayObjectContainer) : Void
  {
    sounds = [];
    sounds.push(new BridgeExplosionSound());
    sounds.push(new ButtonFailedSound());
    sounds.push(new ButtonSuccessSound());
    sounds.push(new SniperShoot1Sound());
    sounds.push(new SniperShoot2Sound());
    sounds.push(new SniperShoot3Sound());
    sounds.push(new TimerPipSound());
    sounds.push(new TowerAbandonSound());
    sounds.push(new TowerBuildSound());
    sounds.push(new TowerDestroySound());
    sounds.push(new TowerSupplySound());
    sounds.push(new TowerUpgradeSound());
    sounds.push(new ZombieBash1Sound());
    sounds.push(new ZombieBash2Sound());
    sounds.push(new ZombieBash3Sound());
    sounds.push(new ZombieBash4Sound());
    sounds.push(new ZombieBash5Sound());
    sounds.push(new ZombieBash6Sound());
    sounds.push(new ZombieDeathSound());
    sounds.push(new ZombieMoanCrowdSound());
    sounds.push(new ZombieMoan1Sound());
    sounds.push(new ZombieMoan2Sound());
    sounds.push(new ZombieMoan3Sound());
    sounds.push(new ZombieMoan4Sound());
    transform = new flash.media.SoundTransform();
  }

  public function cleanup() : Void
  {
    sounds = null;
  }

  public function play(which : Int)
  {
    try {
    if (which >= 0 && which < soundCount)
    {
      if (which == ZOMBIE_BASH)
      {
        which += Lib.rand(zombieBashCount);
      }
      else if (which == ZOMBIE_MOAN)
      {
        which += Lib.rand(zombieMoanCount);
      }
      transform.volume = Main.config.getProportion(Config.SOUND);
      sounds[which].play(0, 0, transform);
    }
    }
    catch (e : Dynamic) { }
  }

  public function setVolume(newVolume : Float) : Void
  {
    // Do nothing. In all likelyhood, no sounds will be playing when
    // the volume is changed.
  }

  var sounds : Array<flash.media.Sound>;
  var transform : flash.media.SoundTransform;
}
