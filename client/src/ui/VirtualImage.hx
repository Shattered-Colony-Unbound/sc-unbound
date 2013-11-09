// Wraps up a CenteredImage and the information required to display
// it. When the image is on screen, it makes sure to pull a new one
// from the pool and display it. When not on screen, it just updates
// the internal state.

package ui;

class VirtualImage
{
  public function new(newLayer : Int, newCenter : Point,
                      newLinkage : String) : Void
  {
    image = null;
    layer = newLayer;

    frame = 1;
    linkage = newLinkage;
    frameChanged = true;

    scale = 1.0;
    scaleChanged = true;

    overlayColor = ShadowColor.NORMAL;
    canOperate = true;
    isSupplyTarget = false;
    overlayChanged = true;

    center = newCenter.clone();
    centerChanged = true;

    pos = new Point(0, 0);
    windowPos = null;
    positionChanged = true;

    rotation = 0;
    rotationOffset = 0;
    rotationChanged = true;

    alpha = 1.0;
    alphaChanged = true;

    visible = true;
    visibleChanged = true;

    glowFilter = null;
    glowFilterChanged = true;

    isPermanent = false;
  }

  public function cleanup() : Void
  {
    releaseClip();
  }

  // TODO: Remove double update when window moves
  public function inside(newWindowPos : Point) : Void
  {
    if (image == null)
    {
      image = Game.sprites.getSpriteClip(layer, linkage);
      image.show();
      frameChanged = true;
      scaleChanged = true;
      overlayChanged = true;
      centerChanged = true;
      positionChanged = true;
      rotationChanged = true;
      alphaChanged = true;
      visibleChanged = true;
      glowFilterChanged = true;
    }
    if (! Point.isEqual(newWindowPos, windowPos))
    {
      windowPos = newWindowPos;
      positionChanged = true;
    }
    update();
  }

  public function outside(newWindowPos : Point) : Void
  {
    if (! isPermanent)
    {
      releaseClip();
    }
    else
    {
      inside(newWindowPos);
    }
  }

  public function releaseClip() : Void
  {
    if (image != null)
    {
      Game.sprites.releaseSpriteClip(image, layer);
      image = null;
    }
  }

  // --------------------------------------------------------------------------
  // Frame
  // --------------------------------------------------------------------------

  public function setFrame(newFrame : Int) : Void
  {
    if (frame != newFrame)
    {
      frame = newFrame;
      frameChanged = true;
    }
  }

  public function advanceFrame() : Void
  {
    setFrame(frame + 1);
  }

  public function getFrame() : Int
  {
    return frame;
  }

  // TODO: Remove double update when linkage is changed.
  public function changeLinkage(newLinkage : String)
  {
    if (linkage != newLinkage)
    {
      linkage = newLinkage;
      if (image != null)
      {
        releaseClip();
        inside(windowPos);
      }
    }
  }

  // --------------------------------------------------------------------------
  // Scale
  // --------------------------------------------------------------------------

  public function setScale(newScale : Float) : Void
  {
    if (scale != newScale)
    {
      scale = newScale;
      scaleChanged = true;
    }
  }

  // --------------------------------------------------------------------------
  // Overlay
  // --------------------------------------------------------------------------

  public function setOverlayColor(newColor : ShadowColor) : Void
  {
    if (overlayColor != newColor)
    {
      overlayColor = newColor;
      overlayChanged = true;
    }
  }

  public function changeOperate(newCanOperate : Bool) : Void
  {
    if (canOperate != newCanOperate)
    {
      canOperate = newCanOperate;
      overlayChanged = true;
    }
  }

  public function changeSupplyTarget(newIsSupplyTarget : Bool) : Void
  {
    if (isSupplyTarget != newIsSupplyTarget)
    {
      isSupplyTarget = newIsSupplyTarget;
      overlayChanged = true;
    }
  }

  // --------------------------------------------------------------------------
  // Position
  // --------------------------------------------------------------------------

  public function setPos(newPos : Point) : Void
  {
    if (! Point.isEqual(pos, newPos))
    {
      pos = newPos;
      positionChanged = true;
    }
  }

  public function getPos() : Point
  {
    return pos;
  }

  // --------------------------------------------------------------------------
  // Rotation
  // --------------------------------------------------------------------------

  public function setRotation(newRotation : Int) : Void
  {
    if (rotation != newRotation)
    {
      rotation = newRotation;
      rotationChanged = true;
    }
  }

  public function setRotationOffset(newOffset : Int) : Void
  {
    if (rotationOffset != newOffset)
    {
      rotationOffset = newOffset;
      rotationChanged = true;
    }
  }

  public function getRotation() : Int
  {
    return rotation;
  }

  // --------------------------------------------------------------------------
  // Alpha
  // --------------------------------------------------------------------------

  public function setAlpha(newAlpha : Float) : Void
  {
    if (alpha != newAlpha)
    {
      alpha = newAlpha;
      alphaChanged = true;
    }
  }

  // --------------------------------------------------------------------------
  // Visible
  // --------------------------------------------------------------------------

  public function show() : Void
  {
    if (! visible)
    {
      visible = true;
      visibleChanged = true;
    }
  }

  public function hide() : Void
  {
    if (visible)
    {
      visible = false;
      visibleChanged = true;
    }
  }

  // --------------------------------------------------------------------------
  // Glow Filter
  // --------------------------------------------------------------------------

  public function setGlowFilter(newFilter : flash.filters.GlowFilter) : Void
  {
    glowFilter = newFilter;
    glowFilterChanged = true;
  }

  // --------------------------------------------------------------------------
  // Permanent Images
  // --------------------------------------------------------------------------
  public function setPermanent() : Void
  {
    isPermanent = true;
    var newPos = windowPos;
    windowPos = null;
    inside(newPos);
  }

  public function getClip() : flash.display.MovieClip
  {
    var result = null;
    if (isPermanent)
    {
      result = image.getClip();
    }
    return result;
  }

  // --------------------------------------------------------------------------
  // Update
  // --------------------------------------------------------------------------

  public function update() : Void
  {
    if (image != null)
    {
      if (frameChanged)
      {
        image.gotoFrame(frame);
        frameChanged = false;
      }
      if (scaleChanged)
      {
        image.setScale(scale);
        scaleChanged = false;
      }
      if (overlayChanged)
      {
        image.clear();
        drawShadow();
        drawCannotOperate();
        drawSupplyTarget(pos);
        overlayChanged = false;
      }
      if (centerChanged)
      {
        image.setCenter(center);
        centerChanged = false;
      }
      if (positionChanged)
      {
        image.goto(pos.x - windowPos.x, pos.y - windowPos.y);
        positionChanged = false;
      }
      if (rotationChanged)
      {
        image.rotate(rotation + rotationOffset);
        rotationChanged = false;
      }
      if (alphaChanged)
      {
        image.setAlpha(alpha);
        alphaChanged = false;
      }
      if (visibleChanged)
      {
        if (visible)
        {
          image.show();
        }
        else
        {
          image.hide();
        }
        visibleChanged = false;
      }
      if (glowFilterChanged)
      {
        image.setGlowFilter(glowFilter);
        glowFilterChanged = false;
      }
    }
  }

  function drawShadow() : Void
  {
    var transform : flash.geom.ColorTransform = null;
    switch (overlayColor)
    {
    case NORMAL:
      transform = Color.normalTransform;
    case ALLOWED:
      transform = Color.allowTransform;
    case FORBIDDEN:
      transform = Color.denyTransform;
    case BUILD_SITE:
      transform = Color.plannedTransform;
    }
    image.setTransform(transform);
  }

  static var noShootRadius = 10;
  static var noShootThickness = 4;

  function drawCannotOperate() : Void
  {
    if (!canOperate)
    {
      image.drawLine(Color.noShoot, noShootThickness, true,
                     new Point(- noShootRadius,
                               - noShootRadius),
                     new Point(noShootRadius,
                               noShootRadius));
      image.drawLine(Color.noShoot, noShootThickness, true,
                     new Point(noShootRadius,
                               - noShootRadius),
                     new Point(- noShootRadius,
                               noShootRadius));
    }
  }

  static var supplyArrowAngle = Math.PI / 5;
  static var supplyCenterLength = 32;
  static var supplySideLength = 8;
  static var supplyArrowThickness = 5;

  function drawSupplyTarget(pos : Point) : Void
  {
    if (isSupplyTarget)
    {
      var selected = Game.select.getSelected();
      var myType = Game.map.getCell(Lib.pixelToCell(pos.x),
                                    Lib.pixelToCell(pos.y)).getTower().getType();
      var selectTower = Game.map.getCell(selected.x,
                                         selected.y).getTower();
      var selectType = selectTower.getType();
      var color = Color.supplyOtherLine;
      if (myType == Tower.DEPOT && selectType == Tower.DEPOT)
      {
        color = Color.supplyDepotLine;
      }
/*
      if (route != null && route.path != null && ! route.path.isFound())
      {
        color = Color.supplyInterruptedLine;
      }
*/
      var delta = new Point(Lib.cellToPixel(selected.x) - pos.x,
                            Lib.cellToPixel(selected.y) - pos.y);
      var theta = Math.PI/2 - Math.atan2(delta.x, delta.y);
      drawSupplyLeg(theta, supplyCenterLength, color);
      drawSupplyLeg(theta - supplyArrowAngle, supplySideLength, color);
      drawSupplyLeg(theta + supplyArrowAngle, supplySideLength, color);
    }
  }

  function drawSupplyLeg(angle : Float, length : Int, color : Int)
  {
    var dest = new Point(Math.round(Math.cos(angle) * length),
                         Math.round(Math.sin(angle) * length));
    image.drawLine(color, supplyArrowThickness, true,
                   new Point(0, 0), dest);
  }

  public static function saveS(current : VirtualImage) : Dynamic
  {
    return current.save();
  }

  public function save() : Dynamic
  {
    return { layer : layer,
        frame : frame,
        linkage : linkage,
        scale : scale,
        overlayColor : Lib.shadowColorToIndex(overlayColor),
        canOperate : canOperate,
        isSupplyTarget : isSupplyTarget,
        center : center.save(),
        pos : pos.save(),
        rotation : rotation,
        rotationOffset : rotationOffset,
        alpha : alpha,
        visible : visible
        // No glowFilter
        };
  }

  public static function load(input : Dynamic) : VirtualImage
  {
    var result = new VirtualImage(input.layer, Point.load(input.center),
                                  input.linkage);
    result.setFrame(input.frame);
    result.setScale(input.scale);
    result.setOverlayColor(Lib.indexToShadowColor(input.overlayColor));
    result.changeOperate(input.canOperate);
    result.changeSupplyTarget(input.isSupplyTarget);
    result.setPos(Point.load(input.pos));
    result.setRotation(input.rotation);
    result.setRotationOffset(input.rotationOffset);
    result.setAlpha(input.alpha);
    if (input.visible)
    {
      result.show();
    }
    else
    {
      result.hide();
    }
    return result;
  }

  var image : CenteredImage;
  var layer : Int;

  var frame : Int;
  var linkage : String;
  var frameChanged : Bool;

  var scale : Float;
  var scaleChanged : Bool;

  var overlayColor : ShadowColor;
  var canOperate : Bool;
  var isSupplyTarget : Bool;
  var overlayChanged : Bool;

  var center : Point;
  var centerChanged : Bool;

  var pos : Point;
  var windowPos : Point;
  var positionChanged : Bool;

  var rotation : Int;
  var rotationOffset : Int;
  var rotationChanged : Bool;

  var alpha : Float;
  var alphaChanged : Bool;

  var visible : Bool;
  var visibleChanged : Bool;

  var glowFilter : flash.filters.GlowFilter;
  var glowFilterChanged : Bool;

  var isPermanent : Bool;
}
