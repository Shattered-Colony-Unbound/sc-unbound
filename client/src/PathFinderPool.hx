class PathFinderPool
{
  public function new() : Void
  {
    newPaths = newArray();
    unstartedPaths = newArray();
    activePaths = newArray();
    finishedPaths = new List<PathFinder>();
  }

  public function newArray() : Array<List<PathFinder>>
  {
    var result = [];
    for (i in 0...PRIORITY_COUNT)
    {
      result.push(new List<PathFinder>());
    }
    return result;
  }

  public function step() : Void
  {
    var printTrace = false;
    if (newPaths[0].length + newPaths[1].length +
        unstartedPaths[0].length + unstartedPaths[1].length +
        activePaths[0].length + activePaths[1].length > 0)
    {
      printTrace = true;
    }
    var done = false;
    for (i in 0...PRIORITY_COUNT)
    {
      done = done || stepNewPaths(i);
      done = done || stepUnstartedPaths(i);
      done = done || stepActivePaths(i);
    }
    if (! finishedPaths.isEmpty())
    {
      finishedPaths.pop();
    }
    if (printTrace)
    {
//      Lib.trace("newPaths = " + Std.string(newPaths[0].length + newPaths[1].length) + ", " +
//                "unstartedPath = " + Std.string(unstartedPaths[0].length + unstartedPaths[1].length) + ", " +
//                "activePaths = " + Std.string(activePaths[0].length + activePaths[1].length));
    }
  }

  private function stepNewPaths(priority : Int) : Bool
  {
    var result = false;
    for (i in 0...Math.floor(Option.maxPathOperations/10.0))
    {
      if (! newPaths[priority].isEmpty())
      {
        var finder = newPaths[priority].first();
        newPaths[priority].pop();
        finder.setupVisit();
        unstartedPaths[priority].add(finder);
        result = true;
      }
      else
      {
        break;
      }
    }
    return result;
  }

  private function stepUnstartedPaths(priority : Int) : Bool
  {
    var result = false;
    for (i in 0...Math.floor(Option.maxPathOperations/10.0))
    {
      if (! unstartedPaths[priority].isEmpty())
      {
        var finder = unstartedPaths[priority].first();
        unstartedPaths[priority].pop();
        finder.startCalculation();
        activePaths[priority].add(finder);
        result = true;
      }
      else
      {
        break;
      }
    }
    return result;
  }

  private function stepActivePaths(priority : Int) : Bool
  {
    var result = false;
    if (! activePaths[priority].isEmpty())
    {
      var length = activePaths[priority].length;
      var finished = new List<PathFinder>();
//      for (finder in activePaths[priority])
      var finder = activePaths[priority].first();
      if (finder != null)
      {
//        var operations = Math.ceil(Option.maxPathOperations
//                                     / activePaths[priority].length);
        var operations = Option.maxPathOperations;
        finder.step(operations);
        if (finder.isDone())
        {
          finished.add(finder);
        }
      }
      for (finder in finished)
      {
        activePaths[priority].remove(finder);
        if (! finder.isZombie())
        {
          finishedPaths.add(finder);
        }
      }
      result = true;
    }
    return result;
  }

  public function getPath(source : Point, dest : Point,
                          ?optPriority : Null<Int>) : Path
  {
    var finder = getGeneralPath(source, dest, false, optPriority);
    return finder.getPath();
  }

  public function getZombiePath(source : Point,
                                ?optPriority : Null<Int>) : PathFinder
  {
    return getGeneralPath(source, new Point(0, 0), true, optPriority);
  }

  public function getGeneralPath(source : Point, dest : Point,
                                 isZombie : Bool,
                                 optPriority : Null<Int>) : PathFinder
  {
    var priority = HIGH;
    if (optPriority != null)
    {
      priority = optPriority;
    }
    if (priority >= PRIORITY_COUNT)
    {
      priority = PRIORITY_COUNT - 1;
    }
    if (priority < 0)
    {
      priority = 0;
    }
    var finder = null;
    var path = null;
    if (! isZombie)
    {
      path = new Path();
    }
    if (finishedPaths.isEmpty())
    {
      finder = new PathFinder(source, dest, isZombie, path);
      newPaths[priority].add(finder);
    }
    else
    {
      finder = finishedPaths.first();
      finishedPaths.pop();
      finder.reset(source, dest, isZombie, path);
      unstartedPaths[priority].add(finder);
    }
    return finder;
  }

  public function isActive() : Bool
  {
    var result = false;
    for (i in 0...PRIORITY_COUNT)
    {
      result = result || isActivePriority(i);
    }
    return result;
  }

  public function isActivePriority(priority : Int) : Bool
  {
    return !(newPaths[priority].isEmpty()
             && unstartedPaths[priority].isEmpty()
             && activePaths[priority].isEmpty());
  }

  public static var HIGH = 0;
  public static var LOW = 1;
  static var PRIORITY_COUNT = 2;

  // These paths do not yet have a visit grid. We need to run
  // setupVisit() on them.
  var newPaths : Array<List<PathFinder>>;

  // Paths which have a visit grid, but it is uninitialized. We need
  // to run startCalculation() on them.
  var unstartedPaths : Array<List<PathFinder>>;

  // Current paths which are finding a path. We run step() on them.
  var activePaths : Array<List<PathFinder>>;

  // Paths which have finished. We can recycle these into unstartedPaths.
  var finishedPaths : List<PathFinder>;
}
