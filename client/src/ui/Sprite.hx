package ui;

class Sprite
{
  // pos is in absolute pixels
  public function new(pos : Point, initialRotation : Int, newType : Int,
                      newAnim : Animation) : Void
  {
    anim = newAnim;
    type = newType;

    if (pos != null)
    {
      maxWait = 0;
      toWait = 0;
      toMove = 0;

      stack = new ImageStack();
      image = new VirtualImage(anim.getLayer(), new Point(0, 0),
                               anim.getLinkage(type));
      image.setScale(anim.getScale());
      image.setFrame(1);
      updateGlowFilter();
      stack.addImage(image);
      stack.rotate(initialRotation);
      offset = new Point(0, 0);
      setOffset();
      if (anim.shouldRotate())
      {
        stack.allowRotation();
      }
      else
      {
        stack.forbidRotation();
      }
      if (pos != null)
      {
        stack.setPixel(pos.plus(offset));
      }
      resetWait();
    }
  }

  public function cleanup() : Void
  {
    stack.cleanup();
  }

  public function step(count : Int) : Int
  {
    var used = 0;
    if (anim.shouldFace() || stack.isDancing())
    {
      used += stack.faceEnemy(count - used);
    }
    if (count > used)
    {
      used += move(count - used);
    }
    if (used > 0)
    {
      stack.update();
    }
    return used;
  }

  public function move(count : Int) : Int
  {
    var frameCount = anim.getFrameCount();
    var frame = currentFrame;

    // While we haven't used up count frames.
    while (count > toMove + toWait
           && (! anim.shouldWait() || maxWait > 0))
    {
      toWait += anim.getWait(frame);
      maxWait -= anim.getWait(frame);
      toMove += anim.getMove(frame);
      frame = (frame + 1) % frameCount;
    }
    var waitUsed = Math.floor(Math.min(toWait, count));
    toWait -= waitUsed;
    var moveUsed = 0;
    if (! anim.shouldWait() && waitUsed < count)
    {
      moveUsed = stack.step(count - waitUsed);
      toMove -= moveUsed;
    }
    if (frame != currentFrame)
    {
      var finalFrame = frame;
      if (finalFrame == 0)
      {
        finalFrame = anim.getFrameCount();
      }
      if (anim.shouldReverse() && finalFrame > Math.floor(frameCount / 2))
      {
        finalFrame = frameCount - finalFrame + 1;
      }
      image.setFrame(finalFrame);
    }
    currentFrame = frame;
    return waitUsed + moveUsed;
  }

  public function setFrame(newFrame : Int) : Void
  {
    currentFrame = newFrame;
    image.setFrame(newFrame);
  }

  public function travelSimple(inDest : Point, ? inMiddle : Point)
  {
    var dest = inDest.plus(offset);
    var middle = inMiddle;
    if (middle != null)
    {
      middle.plusEquals(offset);
    }
    stack.travel(anim.getMoveCount(), dest, middle);
  }

  public function travelCurve(inCurrent : Point, inNext : Point,
                              inFuture : Point) : Bool
  {
    var current = inCurrent.plus(offset);
    var next = inNext.plus(offset);
    var future = inFuture;
    if (future != null)
    {
      future.plusEquals(offset);
    }
    var inNextSquare = true;
    var averageNext = averagePos(current, next);

    if (future == null)
    {
      // At the end of the path
      stack.travel(Math.floor(anim.getMoveCount()/2), next);
    }
    else if (Point.isEqual(stack.getPixel(), averageNext))
    {
      // In the middle of the path
      stack.travel(anim.getMoveCount(), averagePos(next, future), next);
    }
    else if (Point.isEqual(stack.getPixel(), current))
    {
      // Middle of the square
      stack.travel(Math.floor(anim.getMoveCount()/2),
                   averageNext, current);
      inNextSquare = false;
    }
    else
    {
      // Somewhere else in the square
      stack.travel(anim.getMoveCount(), averageNext, current);
      inNextSquare = false;
    }
    return inNextSquare;
  }

  public function dance(isPositive : Bool) : Void
  {
    var num = Option.danceMoves.length - 1;
    if (! isPositive)
    {
      num = -num;
    }
    stack.startDance(num);
  }

  public function update() : Void
  {
    stack.update();
  }

  public function show() : Void
  {
    stack.show();
  }

  public function hide() : Void
  {
    stack.hide();
  }

  function averagePos(first : Point, second : Point) : Point
  {
    return new Point(Math.floor((first.x + second.x)/2),
                     Math.floor((first.y + second.y)/2));
  }

  public function getPos() : Point
  {
    return stack.getPos().minus(offset);
  }

  public function setPos(newPos : Point) : Void
  {
    stack.setPixel(newPos.plus(offset));
  }

  public function getRotation() : Int
  {
    return image.getRotation();
  }

  public function setRotationOffset(newRotation : Int) : Void
  {
    image.setRotationOffset(newRotation);
  }

  public function setAlpha(newAlpha : Float) : Void
  {
    image.setAlpha(newAlpha);
  }

  public function resetWait() : Void
  {
    if (anim.shouldWait())
    {
      maxWait = anim.getMoveCount();
      toWait = 0;
      toMove = 0;
      currentFrame = 0;
      image.setFrame(1);
      stack.update();
    }
    else
    {
      maxWait = 0;
    }
  }

  public function changeAnimation(newAnim : Animation) : Void
  {
    if (anim != newAnim)
    {
      var oldAnim = anim;
      anim = newAnim;
      if (! oldAnim.shouldOffset())
      {
        setOffset();
      }
      currentFrame = 0;
      if (anim.shouldRotate())
      {
        stack.allowRotation();
      }
      else
      {
        stack.forbidRotation();
      }
      resetWait();
      image.changeLinkage(anim.getLinkage(type));
    }
  }

  public static function getSurvivorLinkage(payload : Resource,
                                            type : Int) : String
  {
    return ui.Animation.carry(payload).getLinkage(type);
  }

  function updateGlowFilter() : Void
  {
    if (anim == Animation.zombieDeath || anim == Animation.zombieShamble
        || anim == Animation.attackTower || anim == Animation.attackSurvivor)
    {
      image.setGlowFilter(new flash.filters.GlowFilter(0xff0000,
                                                       1.0, 8, 8, 1.0));
    }
  }

  function setOffset() : Void
  {
    if (anim.shouldOffset())
    {
      offset.x = mapgen.Util.rand(7) - 3;
      offset.y = mapgen.Util.rand(7) - 3;
    }
  }

  public static function saveS(current : Sprite) : Dynamic
  {
    return current.save();
  }

  public function save() : Dynamic
  {
    return { animNumber : anim.getNumber(),
        type : type,
        stack : stack.save(),
        image : image.save(),
        offset : offset.save(),
        currentFrame : currentFrame,
        maxWait : maxWait,
        toWait : toWait,
        toMove : toMove };
  }

  public static function load(input : Dynamic) : Sprite
  {
    var result = new Sprite(null, 0, input.type,
                            Animation.animations[input.animNumber]);
    result.stack = ImageStack.load(input.stack);
    result.image = VirtualImage.load(input.image);
    result.stack.addImage(result.image);
    result.offset = Point.load(input.offset);
    result.currentFrame = input.currentFrame;
    result.maxWait = input.maxWait;
    result.toWait = input.toWait;
    result.toMove = input.toMove;
    return result;
  }

  var anim : Animation;
  var type : Int;

  var stack : ImageStack;
  var image : VirtualImage;

  var offset : Point;

  var currentFrame : Int;
  var maxWait : Int;
  var toWait : Int;
  var toMove : Int;
}
