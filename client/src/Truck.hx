class Truck extends Actor implements ui.AbstractFrame
{
  public static function createBuildTruck(source : Point, dest : Point,
                                          buildType : Int) : Truck
  {
    var newGoal = null;
    if (Tower.getBuildCost(buildType) == 0)
    {
      newGoal = logic.mission.BuildMission.create(source, dest,
                                                  Resource.SURVIVORS,
                                                  buildType);
    }
    else
    {
      newGoal = logic.mission.BuildMission.create(source, dest,
                                                  Resource.BOARDS,
                                                  buildType);
    }
    if (newGoal != null)
    {
      return new Truck(newGoal, null);
    }
    else
    {
      Lib.trace("New Build Mission Failed");
      return null;
    }
  }

  public static function createUpgradeTruck(newRoute : Route) : Truck
  {
    var newGoal = logic.mission.UpgradeMission.create(newRoute.source,
                                                      newRoute.dest,
                                                      Resource.BOARDS);
    if (newGoal != null)
    {
      return new Truck(newGoal, newRoute);
    }
    else
    {
      Lib.trace("New Upgrade Mission Failed");
      return null;
    }
  }

  public static function createWorkshopUpgradeTruck(source : Point,
                                                    dest : Point) : Truck
  {
    var newGoal = logic.mission.UpgradeMission.create(source, dest,
                                                      Resource.BOARDS);
    if (newGoal != null)
    {
      return new Truck(newGoal, null);
    }
    else
    {
      Lib.trace("New Upgrade Workshop Mission Failed");
      return null;
    }
  }

  public static function createSupplyTruck(newSource : Point,
                                           newDest : Point,
                                           newPayload : Resource,
                                           newAmount : Int,
                                           newRoute : Route) : Truck
  {
    var newGoal = logic.mission.SupplyMission.create(newSource, newDest,
                                                     newPayload, newAmount);
    if (newGoal != null)
    {
      return new Truck(newGoal, newRoute);
    }
    else
    {
      Lib.trace("New Supply Mission Failed");
      return null;
    }
  }

  public static function createFleeingTruck(newType : Int,
                                            newRoute : Route) : Truck
  {
    var cell = Game.map.getCell(newRoute.source.x, newRoute.source.y);
    var newGoal = logic.mission.ReturnMission.create(newRoute.source,
                                                     newRoute.dest,
                                                     Resource.SURVIVORS, 1,
                                                     newType);
    if (newGoal != null)
    {
      return new Truck(newGoal, newRoute);
    }
    else
    {
      return null;
    }
  }

  public static function createClosingTruck(newType : Int, newRoute : Route,
                                            newPayload : Resource) : Truck
  {
    var amount = Option.truckLoad;
    if (newPayload == Resource.SURVIVORS)
    {
      amount = 1;
    }
    var cell = Game.map.getCell(newRoute.source.x, newRoute.source.y);
    var newGoal = logic.mission.ReturnMission.create(newRoute.source,
                                                     newRoute.dest,
                                                     newPayload, amount,
                                                     newType);
    if (newGoal != null)
    {
      return new Truck(newGoal, newRoute);
    }
    else
    {
      return null;
    }
  }

  public function new(newGoal : logic.mission.Mission, newRoute : Route) : Void
  {
    var newSpeed = 100;
    if (newGoal != null)
    {
      newSpeed = newGoal.takeFood();
    }
    super(newSpeed);
    retries = 0;
    waitCounter = 0;
    goal = newGoal;
    current = null;
    path = null;
    pathIndex = 0;
    route = null;
    isDead = false;
    deathFrame = Option.survivorDeathFrameCount;
    if (goal != null)
    {
      current = goal.getSource().clone();
      sprite = new ui.Sprite(current.toPixel(), 0,
                             goal.getSurvivorType(),
                             ui.Animation.carry(goal.getPayload()));
      sprite.update();
      route = newRoute;
      resetPath();

      Game.map.getCell(current.x, current.y).addTruck(this);
    }
  }

  override public function cleanup() : Void
  {
    super.cleanup();
    sprite.cleanup();
    if (goal != null)
    {
      goal.cleanup();
    }
    Game.map.getCell(current.x, current.y).removeTruck(this);
    if (isDead)
    {
      Game.view.frameAdvance.remove(this);
    }
  }

  public function fixedStep() : Void
  {
    if (deathFrame > 0)
    {
      var alpha = deathFrame / Option.survivorDeathFrameCount;
      sprite.setAlpha(alpha);
      sprite.update();
      --deathFrame;
    }
    else
    {
      cleanup();
    }
  }

  override public function step(count : Int) : Void
  {
    if (! isDead)
    {
      var used = sprite.step(count);
      if (used < count)
      {
        if (Point.isEqual(current, goal.getDest()))
        {
          completeMission();
        }
        else if (isPanic())
        {
          movePanic();
        }
        else
        {
          continueMission();
        }
      }
    }
  }

  private function continueMission() : Void
  {
    if (path.isGenerating())
    {
      wait();
    }
    else if (! isPathGood())
    {
      retryMission();
    }
    else
    {
      var next = path.getStep(pathIndex);
      var future = null;
      if (pathIndex < path.getStepCount() - 1)
      {
        future = path.getStep(pathIndex + 1).toPixel();
      }

      var inNextSquare = move(next, future);
      if (inNextSquare)
      {
        ++pathIndex;
      }
    }
  }

  private function isPathGood() : Bool
  {
    var result = true;
    if (pathIndex >= path.getStepCount())
    {
      result = false;
    }
    else if (! path.isGenerating() && ! path.isFound())
    {
      result = false;
    }
    else if (goal == null || ! goal.canSucceed())
    {
      result = false;
    }
    else
    {
      // The path has more steps
      var next = path.getStep(pathIndex);
      var blockedByTower = (! Point.isEqual(next, goal.getDest())
                            && Game.map.getCell(next.x, next.y).hasTower());
      var blockedByZombie = (Lib.adjacentZombie(next)
                             && ! Point.isEqual(next, goal.getDest()))
        || Game.map.getCell(next.x, next.y).hasZombies();
      if (blockedByTower || blockedByZombie)
      {
        // The next step is blocked by a tower or a zombie
        result = false;
      }
    }
    return result;
  }

  function move(next : Point, future : Point) : Bool
  {
    var inNextSquare = sprite.travelCurve(current.toPixel(), next.toPixel(),
                                          future);
    if (inNextSquare)
    {
      Game.map.getCell(current.x, current.y).removeTruck(this);
      current = next;
      Game.map.getCell(current.x, current.y).addTruck(this);
    }
    waitCounter = 0;
    return inNextSquare;
  }

  function isPanic() : Bool
  {
    return Lib.adjacentZombie(current);
  }

  function movePanic() : Void
  {
    var deltas : Array<Point> = [new Point(0, 1), new Point(1, 0),
                                 new Point(0, -1), new Point(-1, 0)];
    var candidates = [];
    for (delta in deltas)
    {
      var pos = current.clone();
      pos.plusEquals(delta);
      var cell = Game.map.getCell(pos.x, pos.y);
      if (! cell.hasZombies() && ! cell.isBlocked() && ! cell.hasTower()
          && cell.getBackground() != BackgroundType.BRIDGE)
      {
        candidates.push(pos);
      }
    }
    if (candidates.length > 0)
    {
      var index = Lib.rand(candidates.length);
      move(candidates[index], null);
    }
    if (! isPanic())
    {
      resetPath();
    }
  }

  public function retryMission() : Void
  {

    if (route != null && route.path != null && route.path == path)
    {
      route.path = null;
      route = null;
//      route.path = Game.pathPool.getPath(route.source, route.dest);
    }
    if (retries >= Option.truckRetries || ! goal.canSucceed())
    {
      retries = 0;
      goal = goal.fail();
      if (goal == null)
      {
        cleanup();
      }
      else
      {
        resetPath();
        displayPayload(goal.getPayload());
      }
    }
    else
    {
      resetPath();
      wait();
      ++retries;
    }
  }

  private function completeMission() : Void
  {
    goal = goal.complete();
    if (goal == null)
    {
      cleanup();
    }
    else
    {
      resetPath();
      displayPayload(goal.getPayload());
    }
  }

  public function dropLoad() : Void
  {
    if (goal != null)
    {
      goal.dropLoad(current.x, current.y);
    }
  }

  public function spawnZombie() : Void
  {
    if (! isDead)
    {
      var newZombie = new Zombie(current.x, current.y, sprite.getRotation(),
                                 current.x, current.y, Zombie.ATTACK_SPAWN);
      newZombie.setPixel(sprite.getPos());
      if (goal.getDest() != null
          && ! Point.isEqual(goal.getDest(), current))
      {
        var destTower = Game.map.getCell(goal.getDest().x,
                                         goal.getDest().y).getTower();
        if (destTower != null)
        {
          newZombie.makeNoise(goal.getDest(), 0, destTower.getZombieGuide());
        }
      }
      isDead = true;
      Game.view.frameAdvance.add(this);
      Main.sound.play(SoundPlayer.ZOMBIE_MOAN);

      if (Main.kongregate != null)
      {
        Main.kongregate.stats.submit("Turncoat", 1);
      }
    }
  }

  public function getPixel() : Point
  {
    return sprite.getPos();
  }

  function displayPayload(newPayload : Resource) : Void
  {
    sprite.changeAnimation(ui.Animation.carry(newPayload));
  }

  private function resetPath() : Void
  {
    if (route != null
        && Point.isEqual(route.source, goal.getDest())
        && Point.isEqual(route.dest, current))
    {
      var sourceTower = Game.map.getCell(current.x, current.y).getTower();
      if (sourceTower != null)
      {
        route = sourceTower.getRoute(goal.getDest());
      }
    }

    if (route != null && route.path != null
        && Point.isEqual(route.source, current)
        && Point.isEqual(route.dest, goal.getDest()))
    {
      path = route.path;
    }
    else
    {
      path = Game.pathPool.getPath(current, goal.getDest());
    }
    pathIndex = 0;
  }

  override public function saveTruck() : Dynamic
  {
    return { parent : super.save(),
             waitCounter : waitCounter,
             goal : goal.save(),
             current : current.save(),
             path : Save.maybe(path, Path.saveS),
             pathIndex : pathIndex,
             route : Save.maybe(route, Route.saveS),
             retries : retries,
             isDead : isDead,
             deathFrame : deathFrame,
             sprite : sprite.save() };
  }

  override public function load(input : Dynamic) : Void
  {
    super.load(input.parent);
    waitCounter = input.waitCounter;
    goal = logic.mission.Mission.loadMission(input.goal);
    current = Point.load(input.current);
    pathIndex = input.pathIndex;
    if (input.route == null)
    {
      route = null;
      path = Load.maybe(input.path, Path.load);
    }
    else
    {
      var source = Point.load(input.route.source);
      var sourceTower = Game.map.getCell(source.x, source.y).getTower();
      var dest = Point.load(input.route.dest);
      if (sourceTower != null)
      {
        route = sourceTower.getRoute(dest);
        if (route != null)
        {
          path = route.path;
        }
        else
        {
          path = Path.load(input.path);
        }
      }
    }
    if (path == null)
    {
      path = Game.pathPool.getPath(current,
                                   goal.getDest());
      pathIndex = 0;
    }
    retries = input.retries;
    isDead = input.isDead;
    deathFrame = input.deathFrame;
    sprite = ui.Sprite.load(input.sprite);
    if (isDead)
    {
      Game.view.frameAdvance.add(this);
    }
    else
    {
      Game.map.getCell(current.x, current.y).loadAddTruck(this);
    }
  }


  public static function loadS(input : Dynamic) : Truck
  {
    var result = new Truck(null, null);
    result.load(input);
    return result;
  }

  var waitCounter : Int;
  var goal : logic.mission.Mission;
  var current : Point;
  var path : Path;
  var pathIndex : Int;
  var route : Route;
  var retries : Int;
  var isDead : Bool;
  var deathFrame : Int;

  var sprite : ui.Sprite;
}
