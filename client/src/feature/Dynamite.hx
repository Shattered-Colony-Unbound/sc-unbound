package feature;

class Dynamite extends feature.Root
{
  public function new(newMapPos : Point, newCount : Int,
                      newBridge : logic.Bridge) : Void
  {
    super(newMapPos, newCount);
    type = Root.DYNAMITE;
    bridge = newBridge;
  }

  override function getAction() : action.Interface
  {
    return new action.DestroyBridge(bridge);
  }

  override public function getHoverTip() : String
  {
    return ui.Text.hoverDynamiteTip;
  }

  override public function getWorkshopTip() : String
  {
    return ui.Text.workshopDynamiteTip;
  }

  override public function getBuildTip() : String
  {
    return ui.Text.backgroundBuildDynamiteTip;
  }

  override public function save() : Dynamic
  {
    return { parent : super.save(),
             bridge : bridge.save() };
  }

  override public function load(input : Dynamic) : Void
  {
    super.load(input.parent);
    bridge = logic.Bridge.load(input.bridge);
    Game.progress.addBridge(bridge, false);
  }

  var bridge : logic.Bridge;
}
