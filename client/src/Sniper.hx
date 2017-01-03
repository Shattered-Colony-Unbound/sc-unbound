class Sniper extends Tower implements ui.AbstractFrame
{
  public static var maxSurvivors = 11;

  static var FOOD = Resource.FOOD;
  static var AMMO = Resource.AMMO;
  static var SURVIVORS = Resource.SURVIVORS;
  static var BOARDS = Resource.BOARDS;

  public function new(newX : Int, newY : Int) : Void
  {
    type = Tower.SNIPER;
    shooter = null;

    holdFire = false;
    isShooting = false;
    idleCount = 0;
    idleAngle = Lib.rand(360);
    range = 0;
    visibleSquares = [];
    shootType = SoundPlayer.SNIPER_SHOOT
      + Lib.rand(SoundPlayer.sniperShootCount);

    super(new Point(newX, newY), Option.sniperLevelLimit, Option.sniperSpeed,
          Option.sniperCost);
    addReserve(Lib.ammoLoad);
    addReserve(Lib.survivorLoad);
    for (i in 0...Option.sniperBuildCost)
    {
      addReserve(Lib.boardLoad);
    }
    updateCanShoot();
    updateBlocked();
  }

  override public function cleanup() : Void
  {
    if (shooter != null)
    {
      Game.view.frameAdvance.remove(this);
      shooter.cleanup();
    }
    super.cleanup();
  }

  public function fixedStep() : Void
  {
/*
    var used = shooter.shootStep(1);
    if (used == 0)
    {
      isShooting = false;
      shooter.stopShooting();
      Game.view.frameAdvance.remove(this);
    }
*/
  }

  override public function step(count : Int) : Void
  {
//    wait();
    if (isShooting)
    {
      var used = shooter.shootStep(count);
      if (used < count)
      {
        isShooting = false;
        shooter.stopShooting();
        Game.view.frameAdvance.remove(this);
      }
    }
    else
    {
      sendToDepot(true);
    }
    if (! isShooting && shooter != null)
    {
      var target : Point = findTarget();
      if (target != null)
      {
        var zombieSprite = Game.map.getCell(target.x, target.y).getZombie();
        var pixel = mapPos.toPixel();
        var zombiePixel = zombieSprite.getPixel();
        var angle = Lib.getAngle(pixel, zombiePixel) + 90;
        var used = shooter.rotateStep(count, angle);
        if (used == 0)
        {
          attemptShot(target, zombieSprite);
        }
      }
      else if (idleCount == 0)
      {
        var used = shooter.rotateStep(count, idleAngle);
        if (used == 0)
        {
          idleCount = Lib.rand(Option.sniperIdleRange) + Option.sniperIdleMin;
        }
      }
      else
      {
        --idleCount;
        if (idleCount == 0)
        {
          idleAngle = Lib.rand(360);
        }
      }
    }
    if (canWasteShot())
    {
      Game.map.noise(mapPos.x, mapPos.y, Option.towerNoise, zombieGuide);
    }
  }

  function attemptShot(target : Point, zombieSprite : Zombie) : Void
  {
    if (canWasteShot() && !holdFire)
    {
      var accuracy = getAccuracy(zombieSprite);
      if (countResource(FOOD) >= Option.foodShootCost)
      {
        takeResource(new ResourceCount(FOOD, Option.foodShootCost));
      }
      shootSideEffect();
      var roll = Lib.rand(Option.accuracyMax);
      if (roll < accuracy)
      {
        Game.map.getCell(target.x, target.y).attackZombie(mapPos);
      }
    }
  }

  override public function giveResource(payload : ResourceCount) : Void
  {
    super.giveResource(payload);
    updateShooter();
    updateCanShoot();
  }

  override public function takeResource(payload : ResourceCount) : Void
  {
    super.takeResource(payload);
    updateShooter();
    updateCanShoot();
  }

  override function normalizeLevel() : Void
  {
    super.normalizeLevel();
    range = Option.sniperRange[level];
    Game.update.changeRange(mapPos);
    updateVisibility();
  }

  override public function getType() : Int
  {
    return Tower.SNIPER;
  }

  private function shootSideEffect() : Void
  {
    Main.sound.play(shootType);
    Game.map.noise(mapPos.x, mapPos.y, Option.shootNoise, zombieGuide);
    takeResource(new ResourceCount(AMMO, Option.shootCost));
    updateCanShoot();
    Game.update.resourceChange(mapPos);
    if (shooter != null)
    {
      shooter.startShooting();
      Game.view.frameAdvance.add(this);
      isShooting = true;
//      wait();
    }
  }

  override public function updateVisibility() : Void
  {
    visibleSquares = [];
    if (range > 0)
    {
      PermissiveFov.permissiveFov(mapPos.x, mapPos.y, range, isBlocked,
                                  addVisibleSquare);
      visibleSquares.sort(sortByDistance);
    }
    Game.view.window.updateRanges();
  }

  public static function isBlocked(xPos : Int, yPos  : Int) : Bool
  {
    var result = true;
    if (! Lib.outsideMap(new Point(xPos, yPos)))
    {
      var cell = Game.map.getCell(xPos, yPos);
      result = cell.isBlocked()
        && cell.getBackground() != BackgroundType.WATER
        && cell.getBackground() != BackgroundType.BRIDGE;
    }
    return result;
  }

  private function addVisibleSquare(xPos : Int, yPos : Int) : Void
  {
    if (! isBlocked(xPos, yPos))
    {
      visibleSquares.push(new Point(xPos, yPos));
    }
  }

  private function sortByDistance(left : Point, right : Point) : Int
  {
    return getDistance(left) - getDistance(right);
  }

  private function getDistance(dest : Point) : Int
  {
    return Math.floor(Math.abs(mapPos.x - dest.x)
                      + Math.abs(mapPos.y - dest.y));
  }

  private function findTarget() : Point
  {
    var result = null;
    for (dest in visibleSquares)
    {
      if (Game.map.getCell(dest.x, dest.y).hasZombies())
      {
        result = dest;
        break;
      }
    }
    return result;
  }

  override public function getRange() : Int
  {
    return range;
  }

  override public function showVisibility(range : Range) : Void
  {
    for (dest in visibleSquares)
    {
      range.set(dest.x, dest.y);
    }
  }

  override public function canWasteShot() : Bool
  {
    return (countResource(AMMO) >= Option.shootCost
            && countResource(SURVIVORS) >= Lib.truckLoad(SURVIVORS)
            && countResource(BOARDS) >=
                  Lib.truckLoad(BOARDS)*Option.sniperBuildCost);
  }

  override public function wasteShot() : Void
  {
    if (canWasteShot())
    {
      shootSideEffect();
    }
  }

  private function updateCanShoot() : Void
  {
    sprite.changeCanOperate(canWasteShot() && !holdFire);
    sprite.update();
  }

  function updateShooter() : Void
  {
    if (shooter == null && countResource(Resource.SURVIVORS) > 0)
    {
      // Add a shooter graphic
      var type = getSurvivorType(0);
      shooter = new ui.SniperSprite(mapPos, type);
//      shooter = new ui.Sprite(mapPos.toPixel(), 0, type,
//                              ui.Animation.fireShotgun);
    }
    else if (shooter != null && countResource(Resource.SURVIVORS) == 0)
    {
      // Remove a shooter graphic
      Game.view.frameAdvance.remove(this);
      shooter.cleanup();
      shooter = null;
      isShooting = false;
    }
  }

  override public function getAccuracy(? zombieSprite : Zombie) : Int
  {
    var result = Option.sniperAccuracy[level];
    var survivors = countResource(SURVIVORS);
    var food = countResource(FOOD);
    if (survivors == 0)
    {
      result = 0;
    }
    else
    {
      result += (survivors-1) * Option.survivorBonus;
      if (food >= Option.foodShootCost)
      {
        result += Option.foodBonus;
        result += (survivors-1) * Option.survivorFoodBonus;
      }
    }
    if (zombieSprite != null && zombieSprite.isVulnerable())
    {
      result += Option.vulnerableBonus;
    }
    if (result > 100)
    {
      result = 100;
    }
    return result;
  }

  override public function toggleHoldFire() : Void
  {
    holdFire = !holdFire;
    updateCanShoot();
  }

  override public function isHoldingFire() : Bool
  {
    return holdFire;
  }

  // Blocked sets a bit to one.
  // Least significant
  // --
  // NORTH
  // SOUTH
  // EAST
  // WEST
  // --
  // Most significant
  override public function updateBlocked() : Void
  {
    var index = 0;
    var multiplier = 1;
    var pos = new Point(0, 0);
    for (delta in Lib.dirDeltas)
    {
      pos.x = mapPos.x + delta.x;
      pos.y = mapPos.y + delta.y;
      var cell = Game.map.getCell(pos.x, pos.y);
      if (cell.isBlocked() || cell.hasTower())
      {
        index += multiplier;
      }
      multiplier *= 2;
    }
    sprite.changeUpgrade(index);
  }

  override public function saveTower() : Dynamic
  {
    return { parent : super.saveTowerGeneric(),
        shooter : Save.maybe(shooter, ui.SniperSprite.saveS),
        holdFire : holdFire,
        isShooting : isShooting,
        idleCount : idleCount,
        idleAngle : idleAngle,
        shootType : shootType};
  }

  override public function load(input : Dynamic) : Void
  {
    super.load(input.parent);
    shooter = Load.maybe(input.shooter, ui.SniperSprite.load);
    holdFire = input.holdFire;
    isShooting = input.isShooting;
    idleCount = input.idleCount;
    idleAngle = input.idleAngle;
    shootType = input.shootType;
    if (isShooting)
    {
      Game.view.frameAdvance.add(this);
    }
    Game.sprites.addSniper(this);
  }

  var shooter : ui.SniperSprite;
  var visibleSquares : Array<Point>;
  var range : Int;
  var holdFire : Bool;
  var isShooting : Bool;
  var idleCount : Int;
  var idleAngle : Int;
  var shootType : Int;
}
