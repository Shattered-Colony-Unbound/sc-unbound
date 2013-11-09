class CenteredImage
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      linkage : String)
  {
    image = flash.Lib.attach(linkage);
    parent.addChild(image);
    image.visible = true;
    image.useHandCursor = false;
    image.cacheAsBitmap = true;
    image.mouseEnabled = false;
    image.mouseChildren = false;
    image.stop();

    baseX = 0.0;
    baseY = 0.0;
    rotation = 0.0;
    clearCenter();
  }

  public function cleanup() : Void
  {
    detach();
    image = null;
  }

  public function getClip() : flash.display.MovieClip
  {
    return image;
  }

  public function detach() : Void
  {
    if (image.parent != null)
    {
      image.parent.removeChild(image);
    }
  }

  public function getImage() : flash.display.MovieClip
  {
    return image;
  }

  public function setScale(newScale : Float) : Void
  {
    image.scaleX = newScale;
    image.scaleY = newScale;
  }

  public function setAlpha(newAlpha : Float) : Void
  {
    image.alpha = newAlpha;
  }

  public function setFrame(frame : String) : Void
  {
    image.gotoAndStop(1);
    image.gotoAndStop(frame);
  }

  public function gotoFrame(frame : Int) : Void
  {
    image.gotoAndStop(1);
    image.gotoAndStop(frame);
  }

  public function goto(x : Int, y : Int)
  {
    baseX = x;
    baseY = y;
    moveClip();
  }

  public function rotate(newRotation : Int)
  {
    rotation = newRotation;
    moveClip();
  }

  public function getRotation() : Int
  {
    return Math.floor(rotation);
  }

  public function setTransform(newTransform : flash.geom.ColorTransform) : Void
  {
    image.transform.colorTransform = newTransform;
  }

  public function setGlowFilter(newFilter : flash.filters.GlowFilter) : Void
  {
    if (newFilter == null)
    {
      image.filters = [];
    }
    else
    {
      image.filters = [newFilter];
    }
  }

  public function hide() : Void
  {
    image.visible = false;
  }

  public function clear() : Void
  {
    image.graphics.clear();
  }

  public function show() : Void
  {
    image.visible = true;
  }

  public function drawBox(color : Int, opacity : Float,
                          offset : Point, size : Point) : Void
  {
    image.graphics.beginFill(color, opacity);
    image.graphics.moveTo(offset.x, offset.y);
    image.graphics.lineTo(offset.x, offset.y + size.y);
    image.graphics.lineTo(offset.x + size.x, offset.y + size.y);
    image.graphics.lineTo(offset.x + size.x, offset.y);
    image.graphics.lineTo(offset.x, offset.y);
    image.graphics.endFill();
  }

  public function drawLine(color : Int, thickness : Int, roundedEdge : Bool,
                           first : Point, second : Point) : Void
  {
    var edge = flash.display.CapsStyle.ROUND;
    if (! roundedEdge)
    {
      edge = flash.display.CapsStyle.NONE;
    }
    image.graphics.lineStyle(thickness, color, 1.0, true,
                             flash.display.LineScaleMode.NORMAL, edge);
    image.graphics.moveTo(first.x, first.y);
    image.graphics.lineTo(second.x, second.y);
  }

  public function clearCenter() : Void
  {
    setCenter(new Point(Math.floor(Option.cellPixels / 2),
                        Math.floor(Option.cellPixels / 2)));
  }

  public function setCenter(newCenter : Point) : Void
  {
    center = newCenter.clone();
    diagDistance = Math.sqrt(center.x*center.x + center.y*center.y);
  }

  function moveClip() : Void
  {
    var rad = rotation * Math.PI / 180 + Math.PI / 4;
    var deltaX = Math.cos(rad) * diagDistance;// / 2;
    var deltaY = Math.sin(rad) * diagDistance;// / 2;
    image.x = baseX - deltaX + center.x;// - Option.cellPixels / 2;
    image.y = baseY - deltaY + center.y;// - Option.cellPixels / 2;
#if AS3
    if (center.x == 0 && center.y == 0)
    {
      image.x += Option.cellPixels / 2;
      image.y += Option.cellPixels / 2;
    }
#end
    image.rotation = rotation;
  }

  var image : flash.display.MovieClip;

  var baseX : Float;
  var baseY : Float;
  var rotation : Float;
  var center : Point;
  var diagDistance : Float;
}
