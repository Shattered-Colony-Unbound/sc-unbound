class Path
{
  public function new() : Void
  {
    generating = true;
    steps = new Array<Point>();
    reset();
  }

  public function reset() : Void
  {
    generating = true;
    found = false;
    steps = [];
  }

  public function addStep(nextStep : Point) : Void
  {
    steps.push(nextStep);
  }

  // Call after addStep() has been called enough.
  public function succeed() : Void
  {
    found = true;
    generating = false;
    steps.reverse();
  }

  public function fail() : Void
  {
    generating = false;
    found = false;
  }

  public function getStepCount() : Int
  {
    return steps.length;
  }

  public function getStep(stepIndex : Int) : Point
  {
    return steps[stepIndex];
  }

  public function isGenerating() : Bool
  {
    return generating;
  }

  public function isFound() : Bool
  {
    return found;
  }

  public static function saveS(path : Path) : Dynamic
  {
    return path.save();
  }

  public function save() : Dynamic
  {
    var result = null;
    if (! generating && found)
    {
      result = new Array<Dynamic>();
      for (step in steps)
      {
        result.push(step.save());
      }
    }
    return result;
  }

  static public function load(input : Dynamic) : Path
  {
    var result = new Path();
    result.generating = false;
    result.found = true;
    for (i in 0...(input.length))
    {
      result.steps.push(Point.load(input[i]));
    }
    return result;
  }

  var generating : Bool;
  var found : Bool;
  var steps : Array<Point>;
}
