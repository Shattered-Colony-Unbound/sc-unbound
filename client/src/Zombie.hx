class Zombie extends Actor implements ui.AbstractFrame
{
  public static var START_SPAWN = 0;
  public static var BUILDING_SPAWN = 1;
  public static var WAVE_SPAWN = 2;
  public static var ATTACK_SPAWN = 3;

  public function new(sourceX : Int, sourceY : Int, optRotation : Null<Int>,
                      newDestX : Int, newDestY : Int,
                      spawnState : Int, ? isLoading : Bool) : Void
  {
    var zombieSpeed : Int = Game.settings.getZombieSpeed()
      + mapgen.Util.rand(Option.zombieSpeedRange);
    super(zombieSpeed);
    if (isLoading == null || isLoading == false)
    {
      var newRotation = Lib.directionToAngle(mapgen.Util.randDirection());
      if (optRotation != null)
      {
        newRotation = optRotation;
      }
      isDead = false;
      current = new Point(sourceX, sourceY);
      dest = new Point(newDestX, newDestY);

      destLoudness = 0;
      isAttacking = false;

      var shamble = ui.Animation.zombieShamble;
      if (Game.settings.getEasterEgg() != logic.GameSettings.EASTLOSANGELES)
      {
        var typeCount = shamble.getTypeCount() - 1;
        type = mapgen.Util.rand(typeCount);
      }
      else
      {
        type = shamble.getTypeCount() - 1;
      }
      sprite = new ui.Sprite(current.toPixel(), newRotation, type,
                             shamble);
      sprite.setRotationOffset(90);
      headShot = null;
      inWave = false;
      guide = null;
      lastPos = current.clone();
      deathFrame = ui.Animation.zombieDeathWait;
      if (spawnState == START_SPAWN)
      {
        spawnFrame = -1;
        Game.map.getCell(current.x, current.y).addZombie(this);
        sprite.setAlpha(1.0);
        sprite.update();
      }
      else
      {
        sprite.setAlpha(0.0);
        spawnFrame = Option.spawnFrameCount;
      }
      if (spawnState != BUILDING_SPAWN)
      {
        Game.progress.addZombies(1);
      }
    }
  }

  override public function cleanup() : Void
  {
    super.cleanup();
    sprite.cleanup();
    if (headShot != null)
    {
      headShot.cleanup();
    }
    if (isDead)
    {
      Game.view.frameAdvance.remove(this);
    }
  }

  public function fixedStep() : Void
  {
    var spriteUsed = sprite.step(1);
    var headShotUsed = headShot.step(1);
/*
    if (spriteUsed == 0 && headShotUsed == 0)
    {
      cleanup();
    }
*/
    if (deathFrame == 0)
    {
      Main.sound.play(SoundPlayer.ZOMBIE_DEATH);
    }
    if (deathFrame < 0)
    {
      var alpha = 1.0 + deathFrame * 0.01;
      sprite.setAlpha(alpha);
      sprite.update();
    }
    --deathFrame;
    if (deathFrame < -100)
    {
      cleanup();
    }
  }

  public function isInWave() : Bool
  {
    return inWave;
  }

  public function addToWave() : Void
  {
    if (! inWave)
    {
      inWave = true;
      Game.spawner.addToWave();
    }
  }

  function removeFromWave() : Void
  {
    if (inWave)
    {
      inWave = false;
      Game.spawner.removeFromWave();
    }
  }

  override public function step(count : Int) : Void
  {
    if (spawnFrame == 0)
    {
      Game.map.getCell(current.x, current.y).addZombie(this);
      sprite.setAlpha(1.0);
      sprite.update();
      --spawnFrame;
    }
    else if (spawnFrame > 0)
    {
      var alpha = 1.0 - spawnFrame / Option.spawnFrameCount;//;0.02;
      sprite.setAlpha(alpha);
      sprite.update();
      --spawnFrame;
    }
    else if (! isDead)
    {
      var used = sprite.step(count);
      if (used < count)
      {
        plan();
      }
    }
  }

  function plan() : Void
  {
    if (isAttacking)
    {
      isAttacking = false;
      wait();
    }
    else
    {
//      var destCell = Game.map.getCell(dest.x, dest.y);
      var scent = Game.map.getCell(current.x, current.y).getScent();
      if (Point.isEqual(current, dest)
          && scent != null)
      {
        var index = Lib.directionToIndex(scent);
        dest = new Point(current.x + Lib.dirDeltas[index].x,
                         current.y + Lib.dirDeltas[index].y);
        destLoudness = 0;
        guide = null;
      }
      if (Point.isEqual(current, dest))
/*
          || (Point.isAdjacent(current, dest)
              && ! destCell.hasTrucks()
              && ! destCell.hasTower())
*/
      {
        wait();
        destLoudness = 0;
        guide = null;
        removeFromWave();
      }
      else
      {
        moveToNext();
      }
    }
  }

  public function removeFromMap() : Void
  {
    if (! isDead)
    {
      var cell = Game.map.getCell(current.x, current.y);
      cell.removeZombie(this);
      removeFromWave();
      Game.progress.removeZombies(1);
      isDead = true;
      var limit = new Point(current.x + 1, current.y + 1);
      Main.replay.addBox(current, limit, Option.zombieMiniColor);
      if (cell.getBuilding() != null)
      {
        var count = cell.getBuilding().getZombieCount();
        Main.replay.addBox(current, limit, Lib.zombieColor(count));
      }
      else
      {
        Main.replay.addBox(current, limit, Option.roadMiniColor);
      }
    }
  }

  public function kill(source : Point) : Void
  {
    if (! isDead)
    {
      removeFromMap();
      sprite.changeAnimation(ui.Animation.zombieDeath);
      Game.view.frameAdvance.add(this);
      var headShotAngle = Lib.getAngle(getPixel(), source.toPixel()) - 90;
      headShot = new ui.Sprite(getPixel(), headShotAngle, 0,
                               ui.Animation.headShot);
    }
  }

  public function makeNoise(source : Point, loudness : Int,
                            newGuide : PathFinder) : Void
  {
    if (Point.isEqual(current, dest)
        || loudness > destLoudness
        || destLoudness == 0)
    {
      dest = source.clone();
      destLoudness = loudness;
      guide = newGuide;
    }
  }

  public function getPixel() : Point
  {
    return sprite.getPos();
  }

  public function setPixel(newPixel : Point) : Void
  {
    sprite.setPos(newPixel);
  }

  public function getDest() : Point
  {
    return dest;
  }

  public function isVulnerable() : Bool
  {
    return isAttacking;
  }

  override public function dance(isPositive : Bool) : Void
  {
    if (! isAttacking && ! isDead && spawnFrame <= 0)
    {
      sprite.dance(isPositive);
    }
  }

  function moveToNext() : Void
  {
    var next = getNext();
    if (next == null)
    {
      wait();
    }
    else
    {
      var cell : MapCell = Game.map.getCell(next.x, next.y);
      if (cell.hasTower())
      {
        isAttacking = true;
        sprite.changeAnimation(ui.Animation.attackTower);
        sprite.travelSimple(current.toPixel(), next.toPixel());
        cell.attackTower();
      }
      else if (cell.hasTrucks())
      {
        isAttacking = true;
        var destPos = cell.attackSurvivor();
        sprite.changeAnimation(ui.Animation.attackSurvivor);
        sprite.travelSimple(sprite.getPos(), destPos);
      }
      else
      {
        sprite.changeAnimation(ui.Animation.zombieShamble);
        sprite.travelSimple(next.toPixel());
        Game.map.getCell(current.x, current.y).removeZombie(this);
        cell.addZombie(this);
        lastPos = current;
        current = next;
      }
    }
  }

  function getNext() : Point
  {
    var result = null;
    if (guide != null)
    {
      var favor = null;
      var dir = Game.map.getCell(current.x, current.y).getScent();
      if (dir != null)
      {
        favor = current.clone();
        favor.plusEquals(Lib.dirDeltas[Lib.directionToIndex(dir)]);
      }
      else
      {
        favor = getForwardPos(current, lastPos);
      }
      result = guide.getParent(current, favor);
    }
    else if (Point.isAdjacent(current, dest))
    {
      result = dest;
    }
    return result;
  }

  function getForwardPos(now : Point, before : Point) : Point
  {
    var result = null;
    if (now.x > before.x)
    {
      result = new Point(now.x + 1, now.y);
    }
    else if (now.x < before.x)
    {
      result = new Point(now.x - 1, now.y);
    }
    else if (now.y > before.y)
    {
      result = new Point(now.x, now.y + 1);
    }
    else if (now.y < before.y)
    {
      result = new Point(now.x, now.y - 1);
    }
    return result;
  }

  override public function saveZombie() : Dynamic
  {
    var saveGuide = null;
    if (Game.map.getCell(dest.x, dest.y).getTower() == null)
    {
      saveGuide = guide;
    }
    return { parent : super.save(),
        sprite : sprite.save(),
        headShot : Save.maybe(headShot, ui.Sprite.saveS),
        type : type,
        isDead : isDead,
        current : current.save(),
        dest : dest.save(),
        destLoudness : destLoudness,
        isAttacking : isAttacking,
        inWave : inWave,
        guide : Save.maybe(saveGuide, PathFinder.saveS),
        lastPos : lastPos.save(),
        deathFrame : deathFrame,
        spawnFrame : spawnFrame };
  }

  override public function load(input : Dynamic) : Void
  {
    super.load(input.parent);
    sprite = ui.Sprite.load(input.sprite);
    headShot = Load.maybe(input.headShot, ui.Sprite.load);
    type = input.type;
    isDead = input.isDead;
    current = Point.load(input.current);
    dest = Point.load(input.dest);
    destLoudness = input.destLoudness;
    isAttacking = input.isAttacking;
    inWave = input.inWave;
    var tower = Game.map.getCell(dest.x, dest.y).getTower();
    if (tower == null)
    {
      guide = Load.maybe(input.guide, PathFinder.load);
    }
    else
    {
      guide = tower.getZombieGuide();
    }
    lastPos = Point.load(input.lastPos);
    deathFrame = input.deathFrame;
    spawnFrame = input.spawnFrame;
    if (isDead)
    {
      Game.view.frameAdvance.add(this);
    }
    else if (spawnFrame < 0)
    {
      Game.map.getCell(current.x, current.y).loadAddZombie(this);
    }
  }

  public static function loadS(input : Dynamic) : Zombie
  {
    var result = new Zombie(input.current.x, input.current.y, 0,
                            input.dest.x, input.dest.y, 0, true);
    result.load(input);
    return result;
  }

  var sprite : ui.Sprite;
  var headShot : ui.Sprite;
  var type : Int;
  var isDead : Bool;
  var current : Point;
  var dest : Point;
  var destLoudness : Int;
  var isAttacking : Bool;
  var inWave : Bool;
  var guide : PathFinder;
  var lastPos : Point;
  var deathFrame : Int;
  var spawnFrame : Int;
}
