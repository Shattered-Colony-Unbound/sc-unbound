class ReplayStep
{
  public function new(newLower : Point, newUpper : Point, newColor : Int,
                      newType : Int) : Void
  {
    if (newLower != null)
    {
      lower = newLower.clone();
    }
    else
    {
      lower = null;
    }
    if (newUpper != null)
    {
      upper = newUpper.clone();
    }
    else
    {
      upper = null;
    }
    color = newColor;
    type = newType;
  }

  public static function saveS(step : ReplayStep) : Dynamic
  {
    return step.save();
  }

  public function save() : Dynamic
  {
    return { lower : Save.maybe(lower, Point.saveS),
             upper : Save.maybe(upper, Point.saveS),
             color : color,
             type : type };
  }

  static public function load(input : Dynamic) : ReplayStep
  {
    return new ReplayStep(Load.maybe(input.lower, Point.load),
                          Load.maybe(input.upper, Point.load),
                          input.color, input.type);
  }

  public var lower : Point;
  public var upper : Point;
  public var color : Int;
  public var type : Int;
}
