package action;

class DestroyBridge implements Interface
{
  public function new(newBridge : logic.Bridge) : Void
  {
    bridge = newBridge;
  }

  public function run() : Void
  {
    var explosion = new ui.Explosion(bridge);
  }

  var bridge : logic.Bridge;
}
