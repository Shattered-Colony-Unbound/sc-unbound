class Route
{
  public function new(newSource : Point, newDest : Point)
  {
    source = null;
    dest = null;
    path = null;
    if (newSource != null)
    {
      source = newSource.clone();
      dest = newDest.clone();
      path = Game.pathPool.getPath(source, dest);
    }
  }

  public function shouldSend() : Bool
  {
    if (path == null || (! path.isGenerating() && ! path.isFound()))
    {
      path = Game.pathPool.getPath(source, dest, PathFinderPool.LOW);
    }
    return (! path.isGenerating() && path.isFound());
  }

  public static function saveS(route : Route) : Dynamic
  {
    return route.save();
  }

  public function save() : Dynamic
  {
    return { source : source.save(),
             dest : dest.save(),
             path : path.save() };
  }

  public static function load(input : Dynamic) : Route
  {
    var result = new Route(null, null);
    result.source = Point.load(input.source);
    result.dest = Point.load(input.dest);
    result.path = Load.maybe(input.path, Path.load);
    if (result.path == null)
    {
      result.path = Game.pathPool.getPath(result.source, result.dest);
    }
    return result;
  }

  public var source : Point;
  public var dest : Point;
  public var path : Path;
}
