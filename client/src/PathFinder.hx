class PathFinder
{
  public function new(newSource : Point, newDest : Point,
                      newIsZombie : Bool, newPath : Path) : Void
  {
    source = newSource.clone();
    dest = null;
    if (newDest != null)
    {
      dest = newDest.clone();
    }
    queue = null;
    visit = null;
    zombie = newIsZombie;
    started = false;
    path = newPath;
    if (path != null)
    {
      path.reset();
    }
  }

  public function setupVisit() : Void
  {
    if (visit == null)
    {
      queue = new PathHeap(dest);
      visit = new Grid<Int>(Game.map.sizeX(), Game.map.sizeY());
    }
  }

  public function reset(newSource : Point, newDest : Point,
                        newIsZombie : Bool, newPath : Path) : Void
  {
    queue.clear();
    source = newSource.clone();
    dest = null;
    if (newDest != null)
    {
      dest = newDest.clone();
    }
    zombie = newIsZombie;
    started = false;
    path = newPath;
    if (path != null)
    {
      path.reset();
    }
  }

  public function startCalculation() : Void
  {
    for (y in 0...visit.sizeY())
    {
      for (x in 0...visit.sizeX())
      {
        visit.set(x, y, -1);
      }
    }
    queue.push(source.clone(), 0);
    visit.set(source.x, source.y, 0);
    started = true;
  }

  public function isDone() : Bool
  {
    return started && queue.isEmpty();
  }

  public function isZombie() : Bool
  {
    return zombie;
  }

  public function step(count : Int) : Void
  {
    for (i in 0...count)
    {
      stepOnce();
      if (isDone())
      {
        break;
      }
    }
  }

  static var next = new Point(0, 0);

  private function stepOnce() : Void
  {
    if (! queue.isEmpty())
    {
      var found = false;
      var current = queue.pop();
      var weight = visit.get(current.x, current.y) + 1;
      for (dir in Lib.delta)
      {
        next.x = current.x + dir.x;
        next.y = current.y + dir.y;
        if (Lib.outsideMap(next))
        {
          continue;
        }
        if (! isVisited(next)
            || visit.get(next.x, next.y) > weight)
        {
          if (! isBlocked(next))
          {
            var firstVisit = ! isVisited(next);
            visit.set(next.x, next.y, weight);
            if (firstVisit)
            {
              queue.push(next.clone(), weight);
            }
            else
            {
              queue.update(next, weight);
            }
          }
        }
        if (!zombie
            && (Point.isEqual(next, dest)
                || dest == null && isTower(next)))
        {
          dest = next.clone();
          found = true;
          break;
        }
      } // end offset loop

      if (found)
      {
        completePath();
        Game.update.supplyLine(source, dest);
      }
      else if (queue.isEmpty() && path != null)
      {
        path.fail();
        Game.update.supplyLine(source, dest);
      }
    }
  }

  function completePath() : Void
  {
    if (path != null)
    {
      var current = dest.clone();
      while (! Point.isEqual(current, source))
      {
        path.addStep(current);
        current = getParent(current);
      }
      queue.clear();
      path.succeed();
    }
  }

  private function isBlocked(pos : Point) : Bool
  {
    if (Lib.outsideMap(pos))
    {
      return true;
    }
    var cell = Game.map.getCell(pos.x, pos.y);
    if (zombie)
    {
      return cell.isBlocked();
    }
    else
    {
      var adjacentZombie = Lib.adjacentZombie(pos);
      return cell.isBlocked() || cell.hasTower() || adjacentZombie
        || cell.getBackground() == BackgroundType.BRIDGE;
    }
  }

  function isTower(pos : Point) : Bool
  {
    return Game.map.getCell(pos.x, pos.y).getTower() != null;
  }

  public function isVisited(pos : Point) : Bool
  {
    return visit.get(pos.x, pos.y) != -1;
  }

  public function getParent(pos : Point, ? favor : Point) : Point
  {
    var result = null;
    if (started)
    {
      var smallest = 1000000000;
      var parentList = [];
      for (dir in Lib.delta)
      {
        var candidate = visit.get(pos.x + dir.x, pos.y + dir.y);
        if (candidate != -1
            && candidate <= smallest)
        {
          var newPoint = new Point(pos.x + dir.x, pos.y + dir.y);
          if (candidate == smallest)
          {
            parentList.push(newPoint);
          }
          else
          {
            parentList = [newPoint];
          }
          smallest = candidate;
        }
      }
      if (favor != null && visit.get(favor.x, favor.y) == smallest)
      {
        result = favor;
      }
      else if (parentList.length > 0)
      {
        var index = Lib.rand(parentList.length);
        result = parentList[index];
      }
    }
    return result;
  }

  public function getPath() : Path
  {
    return path;
  }

  public static function saveS(guide : PathFinder) : Dynamic
  {
    return guide.save();
  }

  public function save() : Dynamic
  {
    if (! zombie)
    {
      throw new flash.errors.Error("ERROR: Saving non-zombie path");
    }
    return { source : source.save(),
             dest : Save.maybe(dest, Point.saveS),
             queue : Save.maybe(queue, PathHeap.saveS),
             visit : Save.maybe(visit, Save.saveGridInt),
             started : started };
  }

  public static function load(input : Dynamic) : PathFinder
  {
    var newSource = Point.load(input.source);
    var newDest = Point.load(input.dest);
    var result = new PathFinder(newSource, newDest, true, null);
    result.queue = Load.maybe(input.queue, PathHeap.load);
    result.visit = Load.maybe(input.visit, Load.loadGridInt);
    result.zombie = true;
    result.started = input.started;
    result.path = null;
    return result;
  }

  var source : Point;
  var dest : Point;
  var queue : PathHeap;
  var visit : Grid<Int>;
  var zombie : Bool;
  var started : Bool;
  var path : Path;
}
