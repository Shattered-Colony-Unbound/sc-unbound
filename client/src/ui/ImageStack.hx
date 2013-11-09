// Maintains the position and rotation of a stack of images on the
// canvas. An ImageStack also keeps track of whether the images are
// within the game window or not and whether they should be
// shown. ImageStack also manages the coordinated movement of its
// images.

package ui;

class ImageStack
{
  static var stepDenom = Math.floor(Option.cellPixels/2);

  public function new(? newMaxRadius : Null<Int>) : Void
  {
    shouldShow = true;
    images = new List<VirtualImage>();
    pixel = new Point(0, 0);
    shouldRotate = true;
    rotation = 0;
    source = new Point(0, 0);
    dest = new Point(0, 0);
    control = new Point(0, 0);
    stepNum = 1;
    totalSteps = 1;
    maxRadius = Option.cellPixels;
    danceCounter = 0;
    danceBase = 0;
    if (newMaxRadius != null)
    {
      maxRadius = newMaxRadius;
    }
    Game.view.imageList.add(this);
  }

  public function cleanup() : Void
  {
    for (current in images)
    {
      current.cleanup();
    }
    images = null;
    Game.view.imageList.remove(this);
  }

  // A new image is added to the top of the stack.
  public function addImage(newImage : VirtualImage) : Void
  {
    images.add(newImage);
  }

  public function show() : Void
  {
    shouldShow = true;
    update();
  }

  public function hide() : Void
  {
    shouldShow = false;
    update();
  }

  // Allow or forbid rotation while moving.
  public function allowRotation() : Void
  {
    shouldRotate = true;
  }

  public function forbidRotation() : Void
  {
    shouldRotate = false;
  }

  // TODO: Figure out whether show()/hide() should remove sprites or
  // just make them invisible.
  public function update() : Void
  {
    var l = Game.view.layout;
    var window = Game.view.window.toAbsolute(0, 0).toPixel();
    var relative = new Point(pixel.x - window.x, pixel.y - window.y);
    if (!shouldShow
        || relative.x <= - maxRadius
        || relative.x >= Lib.cellToPixel(l.windowSize.x) + maxRadius
        || relative.y <= - maxRadius
        || relative.y >= Lib.cellToPixel(l.windowSize.y) + maxRadius)
    {
      for (current in images)
      {
        current.setPos(pixel);
        current.setRotation(rotation);
        current.outside(window);
      }
    }
    else
    {
      for (current in images)
      {
        current.setPos(pixel);
        current.setRotation(rotation);
        current.inside(window);
      }
    }
  }

  // Parametric equations for the bezier curve:
  // f(t) = at^2 + bt + c
  //
  // a = dest - 2*control + source
  // b = 2*control - 2*source
  // c = source
  function findScalar(t : Float, sourceNum : Float,
                      controlNum : Float, destNum : Float) : Float
  {
    var a = destNum - 2*controlNum + sourceNum;
    var b = 2*controlNum - 2*sourceNum;
    var c = sourceNum;
    return a*t*t + b*t + c;
//    var invT = 1-t;
//    return Math.floor(invT*invT*sourceNum + 2*t*invT*controlNum + t*t*destNum);
  }

  // Returns the number of steps used to travel to destination (up to
  // count steps).
  public function step(count : Int) : Int
  {
    var used = 0;
    var x = findScalarX(stepNum - 1);
    var y = findScalarY(stepNum - 1);
    var nextX = findScalarX(stepNum);
    var nextY = findScalarY(stepNum);
    var next = new Point(Math.floor(nextX), Math.floor(nextY));
    while (used < count && stepNum <= totalSteps)
    {
      nextX = findScalarX(stepNum);
      nextY = findScalarY(stepNum);
      next.x = Math.floor(nextX);
      next.y = Math.floor(nextY);
      var rotated = false;
      if (shouldRotate && ! Point.isEqual(pixel, next))
      {
        rotated = stepRotate(x, y, nextX, nextY);
      }
      if (! rotated)
      {
        pixel = next;
        ++stepNum;
        x = nextX;
        y = nextY;
      }
      ++used;
    }
    return used;
/*
    var currentStep = 0;
    var stepComplete = stepSingle();
    if (!stepComplete)
    {
      ++currentStep;
    }
    while (! stepComplete && currentStep < count)
    {
      stepComplete = stepSingle();
      if (! stepComplete)
      {
        ++currentStep;
      }
    }
    return currentStep;
*/
  }

  function findScalarX(step : Int) : Float
  {
    if (step >= 0)
    {
      return findScalar(step / totalSteps, source.x, control.x, dest.x);
    }
    else
    {
      return source.x;
    }
  }

  function findScalarY(step : Int) : Float
  {
    if (step >= 0)
    {
      return findScalar(step / totalSteps, source.y, control.y, dest.y);
    }
    else
    {
      return source.y;
    }
  }
/*
  function getNextPos() : Point
  {
    var t = stepNum / totalSteps;
    return  new Point(findScalar(t, source.x, control.x, dest.x),
                      findScalar(t, source.y, control.y, dest.y));
  }
*/
  // Returns true if at destination. False if step taken.
/*
  public function stepSingle() : Bool
  {
    // TODO: Refactor
    var result = true;
    var totalStepCount = denomFactor;
    if (stepNum < totalStepCount)
    {
      var t = stepNum / totalSteps;
      var oldX : Float = source.x;
      var oldY : Float = source.y;
      if (stepNum > 0)
      {
        var oldT = (stepNum-1)/totalStepCount;
        oldX = findScalar(oldT, source.x, control.x, dest.x);
        oldY = findScalar(oldT, source.y, control.y, dest.y);
      }
      var x = findScalar(t, source.x, control.x, dest.x);
      var y = findScalar(t, source.y, control.y, dest.y);
      var next = new Point(Math.floor(x), Math.floor(y));
//      if (shouldAdvance)
      {
        pixel = next;
        ++stepNum;
      }
      result = false;
    }
    else if (stepNum == totalStepCount)
    {
      pixel = dest;
      ++stepNum;
      result = false;
    }
    return result;
  }
*/

  public function isDancing() : Bool
  {
    return danceCounter != 0;
  }

  public function faceEnemy(count : Int) : Int
  {
    var used = 0;
    var rotated = true;
    while (used < count && rotated)
    {
      rotated = stepRotate(source.x, source.y, control.x, control.y);
      if (rotated)
      {
        ++used;
      }
    }
    return used;
  }

  // TODO: Use the more accurate Uti.homeIn() functions.
  public function stepRotate(x : Float, y : Float,
                             nextX : Float, nextY : Float) : Bool
  {
    var used = false;
    while (true)
    {
      var newRotation = 0;
      if (danceCounter == 0)
      {
        newRotation = Lib.slopeToAngle(x - nextX, y - nextY);
      }
      else if (danceCounter > 0)
      {
        newRotation = (danceBase + Option.danceMoves[danceCounter]
                       + 360) % 360;
      }
      else
      {
        newRotation = (danceBase - Option.danceMoves[-danceCounter]
                       + 360) % 360;
      }
      used = tryRotate(newRotation);
      if (used)
      {
        break;
      }
      else
      {
        if (danceCounter > 0)
        {
          --danceCounter;
        }
        else if (danceCounter < 0)
        {
          ++danceCounter;
        }
        else
        {
          break;
        }
      }
    }
    return used;
/*
    if (isDancing)
    {
      var pos = (newRotation + 120) % 360;
      var neg = (newRotation + 240) % 350;
      if (Util.angleDistance(pos, rotation) > Util.angleDistance(neg, rotation))
      {
        newRotation = pos;
      }
      else
      {
        newRotation = neg;
      }
    }
*/
  }

  public function tryRotate(newRotation : Int) : Bool
  {
    var used = false;
    var delta = Util.angleDistance(rotation, newRotation);
    if (Util.angleDistance(rotation, newRotation) < Option.rotateStep)
    {
      rotate(newRotation);
    }
    else if (Util.angleDistance(rotation + Option.rotateStep,
                                newRotation) < delta)
    {
      rotate(rotation + Option.rotateStep);
      used = true;
    }
    else
    {
      rotate(rotation - Option.rotateStep);
      used = true;
    }
    return used;
  }

  public function getPos() : Point
  {
    return pixel.clone();
  }

  // newControl is an optional control point for travelling in a curve
  // to the destination.
  public function travel(newDenomFactor : Int,
                         newDest : Point, ? newControl : Point) : Void
  {
    totalSteps = newDenomFactor;
    source = pixel.clone();
    dest = newDest.clone();
    if (newControl == null)
    {
//      control = dest.clone();
      control = new Point(Math.floor((dest.x + source.x)/2),
                          Math.floor((dest.y + source.y)/2));
    }
    else
    {
      control = newControl.clone();
    }
    stepNum = 0;
  }

  public function setPixel(newPixel : Point)
  {
    pixel = newPixel.clone();
    dest = newPixel.clone();
    control = newPixel.clone();
  }

  public function getPixel() : Point
  {
    return pixel;
  }

  public function rotate(newRotation : Int)
  {
    rotation = newRotation;
    if (rotation > 180)
    {
      rotation -= 360;
    }
    if (rotation <= -180)
    {
      rotation += 360;
    }
  }

  public function startDance(newCounter : Int)
  {
    danceCounter = newCounter;
    danceBase = rotation;
  }

  public function save() : Dynamic
  {
    return { shouldShow : shouldShow,
        pixel : pixel.save(),
        shouldRotate : shouldRotate,
        rotation : rotation,
        stepNum : stepNum,
        totalSteps : totalSteps,
        source : source.save(),
        dest : dest.save(),
        control : control.save(),
        maxRadius : maxRadius,
        danceCounter : danceCounter,
        danceBase : danceBase
        };
  }

  public static function load(input : Dynamic) : ImageStack
  {
    var result = new ImageStack();
    result.shouldShow = input.shouldShow;
    result.pixel = Point.load(input.pixel);
    result.shouldRotate = input.shouldRotate;
    result.rotation = input.rotation;
    result.stepNum = input.stepNum;
    result.totalSteps = input.totalSteps;
    result.source = Point.load(input.source);
    result.dest = Point.load(input.dest);
    result.control = Point.load(input.control);
    result.maxRadius = input.maxRadius;
    result.danceCounter = input.danceCounter;
    result.danceBase = input.danceBase;
    return result;
  }

  var shouldShow : Bool;
  var images : List<VirtualImage>;

  var pixel : Point;
  var shouldRotate : Bool;
  // Current rotation in degrees
  var rotation : Int;

  var stepNum : Int;
  var totalSteps : Int;
  var source : Point;
  var dest : Point;
  var control : Point;
  var maxRadius : Int;

  var danceCounter : Int;
  var danceBase : Int;
}
