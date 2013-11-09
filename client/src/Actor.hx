class Actor
{
  public function new(newSpeed : Int) : Void
  {
    speed = newSpeed;
    speedCounter = -Option.startDelay;
    Game.actorList.add(this);
  }

  public function cleanup() : Void
  {
    Game.actorList.remove(this);
    speedCounter = 0;
  }

  // Called by main whenever a new frame happens.
  public function enterFrame() : Void
  {
    speedCounter += speed;
    var stepCount = 0;
    if (speedCounter > 0)
    {
      stepCount = Math.ceil(speedCounter  / Option.frameDelay);
    }
    speedCounter -= stepCount * Option.frameDelay;
    if (stepCount > 0)
    {
      step(stepCount);
    }
  }

  // Called whenever speed permits. Override as needed.
  public function step(count : Int) : Void
  {
  }

  public function dance(isPositive : Bool) : Void
  {
  }

  function wait() : Void
  {
    speedCounter -= Option.waitDelay;
  }

  public function saveTower() : Dynamic
  {
    return null;
  }

  public function saveZombie() : Dynamic
  {
    return null;
  }

  public function saveTruck() : Dynamic
  {
    return null;
  }

  public static function saveTowerS(current : Actor) : Dynamic
  {
    return current.saveTower();
  }

  public static function saveZombieS(current : Actor) : Dynamic
  {
    return current.saveZombie();
  }

  public static function saveTruckS(current : Actor) : Dynamic
  {
    return current.saveTruck();
  }

  public function save() : Dynamic
  {
    return { speed : speed,
        speedCounter : speedCounter };
  }

  public function load(input : Dynamic) : Void
  {
    speed = input.speed;
    speedCounter = input.speedCounter;
  }

  var speed : Int;
  var speedCounter : Int;
}
