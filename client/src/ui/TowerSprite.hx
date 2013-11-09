package ui;

class TowerSprite
{
  public function new(pos : Point, newType : Int, newRotation : Int) : Void
  {
    needs = [];
    for (i in 0...Option.resourceCount)
    {
      needs.push(false);
    }
    if (pos != null)
    {
      stack = new ImageStack();
      stack.setPixel(new Point(Lib.cellToPixel(pos.x),
                               Lib.cellToPixel(pos.y)));
      image = new VirtualImage(SpriteDisplay.TOWER_LAYER, new Point(0, 0),
                               ui.Label.tower);
      image.setRotationOffset(newRotation);
      overlay = new VirtualImage(SpriteDisplay.OVERLAY_LAYER, new Point(0, 0),
                                 ui.Label.towerNeed);
      stack.addImage(image);
      stack.addImage(overlay);
      towerType = newType;
      upgradeOffset = 0;
      if (towerType == Tower.BARRICADE)
      {
        upgradeOffset = Lib.rand(barricadeCount);
      }
      update();
    }
  }

  public function cleanup() : Void
  {
    stack.cleanup();
  }

  public function upgrade() : Void
  {
    ++upgradeOffset;
    update();
  }

  public function changeUpgrade(newUpgradeOffset : Int) : Void
  {
    upgradeOffset = newUpgradeOffset;
    update();
  }

  public function changeSupplyTarget(newIsTarget : Bool) : Void
  {
    overlay.changeSupplyTarget(newIsTarget);
  }

  public function changeCanOperate(newCanOperate : Bool) : Void
  {
    overlay.changeOperate(newCanOperate);
  }

  public function changeColor(newColor : ShadowColor) : Void
  {
    image.setOverlayColor(newColor);
  }

  public function goto(newPos : Point) : Void
  {
    stack.setPixel(newPos);
  }

  public function rotate(newRotation : Int) : Void
  {
    image.setRotationOffset(newRotation);
  }

  public function addNeed(newNeed : Resource) : Void
  {
    var index = Lib.resourceToIndex(newNeed);
    if (needs[index] == false)
    {
      needs[index] = true;
      update();
    }
  }

  public function removeNeed(oldNeed : Resource) : Void
  {
    var index = Lib.resourceToIndex(oldNeed);
    if (needs[index] == true)
    {
      needs[index] = false;
      update();
    }
  }

  public function update() : Void
  {
    var frame = towerFrames[towerType] + upgradeOffset;
    image.setFrame(frame);
    overlay.setFrame(getNeedFrame());
    stack.update();
  }

  function getNeedFrame() : Int
  {
    var result = 1;
    var power = 1;
    for (resource in [Resource.AMMO, Resource.BOARDS, Resource.SURVIVORS])
    {
      var index = Lib.resourceToIndex(resource);
      if (needs[index])
      {
        result += power;
      }
      power *= 2;
    }
    return result;
  }

  public static function saveS(current : TowerSprite) : Dynamic
  {
    return current.save();
  }

  public function save() : Dynamic
  {
    return { stack : stack.save(),
        image : image.save(),
        overlay : overlay.save(),
        towerType : towerType,
        upgradeOffset : upgradeOffset,
        needs : needs.copy() };
  }

  public static function load(input : Dynamic) : TowerSprite
  {
    var result = new TowerSprite(null, 0, 0);
    result.stack = ImageStack.load(input.stack);
    result.image = VirtualImage.load(input.image);
    result.overlay = VirtualImage.load(input.overlay);
    result.stack.addImage(result.image);
    result.stack.addImage(result.overlay);
    result.towerType = input.towerType;
    result.upgradeOffset = input.upgradeOffset;
    for (i in 0...Option.resourceCount)
    {
      result.needs[i] = input.needs[i];
    }
    result.update();
    return result;
  }

  static var barricadeCount = 3;
  static var towerFrames = [2, 5, 21, 23];

  var stack : ImageStack;
  var image : VirtualImage;
  var overlay : VirtualImage;
  var towerType : Int;
  var upgradeOffset : Int;
  var needs : Array<Bool>;
}
