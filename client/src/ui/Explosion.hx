package ui;

class Explosion implements AbstractFrame
{
  public function new(newBridge : logic.Bridge) : Void
  {
    imageStacks = [];
    if (newBridge != null)
    {
      bigImages = [];
      smallImages = [];
      bridge = newBridge;
      frame = 0;
      setupPoints();
      setupBridgeClip();
      Main.sound.play(SoundPlayer.BRIDGE_EXPLOSION);
    }

    Game.view.frameAdvance.add(this);
    Game.view.explosions.add(this);

    if (! Game.settings.isCustom() && Main.kongregate != null)
    {
      Main.kongregate.stats.submit("Bridge", 1);
    }
  }

  public function cleanup() : Void
  {
    for (stack in imageStacks)
    {
      stack.cleanup();
    }
    Game.view.frameAdvance.remove(this);
    Game.view.explosions.remove(this);
    cleanupBridgeBitmap();
  }

  public function cleanupBridgeBitmap() : Void
  {
    if (bridgeBitmap != null)
    {
      bridgeBitmap.bitmapData.dispose();
      bridgeBitmap.parent.removeChild(bridgeBitmap);
      bridgeBitmap = null;
      bridgeClip.parent.removeChild(bridgeClip);
      bridgeClip = null;
    }
  }

  function setupBridgeClip() : Void
  {
    var parent = Game.sprites.getLayer(SpriteDisplay.BRIDGE_LAYER);
    bridgeClip = new flash.display.MovieClip();
    parent.addChild(bridgeClip);
    bridgeClip.mouseEnabled = false;
    bridgeClip.mouseChildren = false;
    bridgeClip.cacheAsBitmap = true;
    var size = bridge.getLot().getSize();
    bridgeTiles = new flash.display.BitmapData(Lib.cellToPixel(size.x),
                                               Lib.cellToPixel(size.y),
                                               true, 0x00ffffff);
    bridgeBitmap = new flash.display.Bitmap(bridgeTiles);
    bridgeClip.addChild(bridgeBitmap);
    Game.view.window.fillBitmapRegion(bridgeBitmap, bridge.getOffset(),
                                      bridge.getLot().offset,
                                      bridge.getLot().limit, false);
    moveWindow();
  }

  public function fixedStep() : Void
  {
    --frame;
    var done = true;
    for (image in bigImages)
    {
      if (image.getFrame() != bigFrameCount)
      {
        image.advanceFrame();
        image.update();
        done = false;
      }
    }
    for (image in smallImages)
    {
      if (image.getFrame() != smallFrameCount)
      {
        image.advanceFrame();
        image.update();
        done = false;
      }
    }

    if (smallPoints.length > 0)
    {
      addSmallExplosion(smallPoints.pop());
      frame = 21;
    }
    else if (bigPoints.length > 0)
    {
      if (frame <= 0)
      {
        addBigExplosion(bigPoints.pop());
        frame = 3;
        if (bigPoints.length == 0)
        {
          frame = 10;
        }
      }
    }
    else if (frame == 0)
    {
      bridge.destroy();
      cleanupBridgeBitmap();
      bridge = null;
    }
    else if (done)
    {
      cleanup();
    }
  }

  public function moveWindow() : Void
  {
    if (bridgeClip != null)
    {
      var rel = Game.view.window.toRelative(bridge.getOffset().x,
                                            bridge.getOffset().y);
      bridgeClip.x = Lib.cellToPixel(rel.x);
      bridgeClip.y = Lib.cellToPixel(rel.y);
    }
  }

  function setupPoints() : Void
  {
    var size = bridge.getLot().getSize();
    var forwardSize = size.x;
    var sideSize = size.y;
    if (bridge.spawnDir() == Direction.NORTH
        || bridge.spawnDir() == Direction.SOUTH)
    {
      forwardSize = size.y;
      sideSize = size.x;
    }
    // Small Explosions
    //
    //    Forward -->
    //
    //     01234567
    //    0........
    // S  1.*.*.*.*
    // i  2........
    // d  3........
    // e  4........
    // |  5.*.*.*.*
    // |
    // v

    smallPoints = [];
    var smallX = 1;
    while (smallX < forwardSize)
    {
      smallPoints.push(new Point(smallX, 1));
      smallPoints.push(new Point(smallX, sideSize-1));
      smallX += 2;
    }
/*
    smallPoints = [new Point(1, 1),
                   new Point(3, 1),
                   new Point(5, 1),
                   new Point(7, 1),
                   new Point(1, 5),
                   new Point(3, 5),
                   new Point(5, 5),
                   new Point(7, 5)];
*/
    Lib.shuffle(smallPoints);

    // Big Explosions
    //
    //    Forward -->
    //
    //     01234567
    //    0........
    // S  1...*....
    // i  2.*....*.
    // d  3........
    // e  4..*..*..
    // |  5........
    // |
    // v
    bigPoints = [];
    for (y in 0...(sideSize-1))
    {
      for (x in 0...forwardSize)
      {
        if (y%2 == 1 && (x+y)%3 == 2)
        {
          bigPoints.push(new Point(x, y));
        }
      }
    }
/*
    bigPoints = [new Point(1, 2),
                 new Point(2, 4),
                 new Point(3, 1),
                 new Point(5, 4),
                 new Point(6, 2)];
*/
    Lib.shuffle(bigPoints);
  }

  // delta is the position if the bridge were on the east. In the
  // other directions, things may be rotated or mirrored.
  function addBigExplosion(delta : Point) : Void
  {
    var stack = new ImageStack(bigRadius);
    var image = new VirtualImage(SpriteDisplay.EXPLOSION_LAYER,
                                 new Point(0, 0),
                                 ui.Label.largeExplosion);
    stack.addImage(image);
    stack.setPixel(getExplosionPos(delta, false));
    stack.update();
    imageStacks.push(stack);
    bigImages.push(image);
  }

  function addSmallExplosion(delta : Point) : Void
  {
    var stack = new ImageStack(smallRadius);
    var image = new VirtualImage(SpriteDisplay.SMALL_EXPLOSION_LAYER,
                                 new Point(0, 0),
                                 ui.Label.smallExplosion);
    stack.addImage(image);
    stack.setPixel(getExplosionPos(delta, true));
    stack.update();
    imageStacks.push(stack);
    smallImages.push(image);
  }

  function getExplosionPos(delta : Point, useHalf : Bool) : Point
  {
    var index = Lib.directionToIndex(bridge.explosionDir());
    var forward = forwardTable[index];
    var side = sideTable[index];
    var offset = bridge.getOffset();
    var x = offset.x + delta.x*forward.x + delta.y*side.x;
    var y = offset.y + delta.x*forward.y + delta.y*side.y;
    var result = new Point(x, y).toPixel();
    if (useHalf)
    {
      result.x -= Option.halfCell;
      result.y -= Option.halfCell;
    }
    return result;
  }

  public static function saveS(current : Explosion) : Dynamic
  {
    return current.save();
  }

  public function save() : Dynamic
  {
    return { bigImages : Save.saveArray(bigImages, VirtualImage.saveS),
        smallImages : Save.saveArray(smallImages, VirtualImage.saveS),
        bridge : Save.maybe(bridge, logic.Bridge.saveS),
        frame : frame,
        bigPoints : Save.saveArray(bigPoints, Point.saveS),
        smallPoints : Save.saveArray(smallPoints, Point.saveS) };
  }

  public static function load(input : Dynamic) : Explosion
  {
    var result = new Explosion(null);
    result.bigImages = Load.loadArray(input.bigImages, VirtualImage.load);
    for (i in 0...(result.bigImages.length))
    {
      var stack = new ImageStack(bigRadius);
      stack.setPixel(result.bigImages[i].getPos());
      stack.addImage(result.bigImages[i]);
      stack.update();
      result.imageStacks.push(stack);
    }
    result.smallImages = Load.loadArray(input.smallImages, VirtualImage.load);
    for (i in 0...(result.smallImages.length))
    {
      var stack = new ImageStack(smallRadius);
      stack.setPixel(result.smallImages[i].getPos());
      stack.addImage(result.smallImages[i]);
      stack.update();
      result.imageStacks.push(stack);
    }
    result.bridge = Load.maybe(input.bridge, logic.Bridge.load);
    if (result.bridge != null)
    {
      Game.progress.addBridge(result.bridge, false);
      result.setupBridgeClip();
    }
    result.frame = input.frame;
    result.bigPoints = Load.loadArray(input.bigPoints, Point.load);
    result.smallPoints = Load.loadArray(input.smallPoints, Point.load);
    return result;
  }

  var imageStacks : Array<ImageStack>;
  var bigImages : Array<VirtualImage>;
  var smallImages : Array<VirtualImage>;
  var bridgeClip : flash.display.MovieClip;
  var bridgeBitmap : flash.display.Bitmap;
  var bridgeTiles : flash.display.BitmapData;
  var bridge : logic.Bridge;
  var frame : Int;

  var bigPoints : Array<Point>;
  var smallPoints : Array<Point>;

  static var bigFrameCount = 90;
  static var smallFrameCount = 36;
  static var bigRadius = 375;
  static var smallRadius = 40;

  static var forwardTable = [new Point(0, 1),
                             new Point(0, 1),
                             new Point(1, 0),
                             new Point(1, 0)];

  static var sideTable = [new Point(1, 0),
                          new Point(1, 0),
                          new Point(0, 1),
                          new Point(0, 1)];
}
