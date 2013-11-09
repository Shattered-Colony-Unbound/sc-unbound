class SpriteDisplay
{
  public static var SMALL_EXPLOSION_LAYER = 0;
  public static var BRIDGE_LAYER = 1;
  public static var FLOOR_LAYER = 2;
  public static var SURVIVOR_LAYER = 3;
  public static var TOWER_LAYER = 4;
  public static var BODY_LAYER = 5;
  public static var SNIPER_LAYER = 6;
  public static var OVERLAY_LAYER = 7;
  public static var CREATURE_LAYER = 8;
  public static var EXPLOSION_LAYER = 9;
  public static var LAYER_COUNT = 10;

  public function new(parent : flash.display.DisplayObjectContainer) : Void
  {
    layerClips = [];
    maxFreeClips = [];
    freeSpriteClips = [];
    var l = Game.view.layout;
    for (i in 0...LAYER_COUNT)
    {
      layerClips.push(new flash.display.Sprite());
      parent.addChild(layerClips[i]);
      layerClips[i].x = l.mapOffset.x;
      layerClips[i].y = l.mapOffset.y;
      layerClips[i].visible = true;
      maxFreeClips.push(0);
      freeSpriteClips.push(new List<CenteredImage>());
    }

    shadowRange = new Range(parent, Option.shadowRangeColor,
                            Option.shadowRangeOpacity);
    snipers = new List<Tower>();
    showingRange = false;
  }

  public function cleanup() : Void
  {
    shadowRange.cleanup();

    for (i in 0...LAYER_COUNT)
    {
      while (! freeSpriteClips[i].isEmpty())
      {
        freeSpriteClips[i].first().cleanup();
        freeSpriteClips[i].pop();
      }
      layerClips[i].parent.removeChild(layerClips[i]);
    }
    layerClips = null;
  }

  public function resize(l : ui.LayoutGame) : Void
  {
    shadowRange.resize(l);
  }

  private function normalizeLayer(layer : Int) : Int
  {
    var result = layer;
    if (result < 0)
    {
      result = 0;
    }
    if (result >= LAYER_COUNT)
    {
      result = LAYER_COUNT - 1;
    }
    return result;
  }
#if TEST_LOAD
  static var debugCount = 0;
#end

  public function getSpriteClip(layer : Int,
                                linkage : String) : CenteredImage
  {
    layer = normalizeLayer(layer);
    var result = new CenteredImage(layerClips[layer], linkage);
#if TEST_LOAD
      ++debugCount;
      trace(Std.string(debugCount));
#end
    return result;
  }

  public function releaseSpriteClip(clip : CenteredImage, layer : Int) : Void
  {
    layer = normalizeLayer(layer);
    clip.cleanup();
  }

  public function getLayer(layer : Int) : flash.display.DisplayObjectContainer
  {
    return layerClips[layer];
  }

  public function addSniper(newSniper : Tower) : Void
  {
    snipers.add(newSniper);
  }

  public function removeSniper(oldSniper : Tower) : Void
  {
    snipers.remove(oldSniper);
  }

  public function showAllVisibility() : Void
  {
    showingRange = true;
    shadowRange.clear();
    for (sniper in snipers)
    {
      sniper.showVisibility(shadowRange);
    }
    shadowRange.draw();
  }

  public function clearAllVisibility() : Void
  {
    showingRange = false;
    shadowRange.clear();
  }

  public function recalculateFov() : Void
  {
    for (sniper in snipers)
    {
      sniper.updateVisibility();
    }
    if (Game.view.window.isShowingRanges())
    {
      showAllVisibility();
      Game.select.update();
    }
  }

  var layerClips : Array<flash.display.DisplayObjectContainer>;
  var maxFreeClips : Array<Int>;
  var freeSpriteClips : Array< List<CenteredImage> >;

  var shadowRange : Range;
  var showingRange : Bool;
  var snipers : List<Tower>;
}
