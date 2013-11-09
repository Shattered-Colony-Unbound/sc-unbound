package ui;

class SniperSprite
{
  public function new(newPos : Point, newType : Int) : Void
  {
    if (newPos != null)
    {
      var pixel = newPos.toPixel();
      type = newType;
      shooter = new ui.Sprite(pixel, 0, type, ui.Animation.fireShotgun);
      idle = new ImageStack();
      idle.setPixel(pixel);
      idleHead = new VirtualImage(SpriteDisplay.SNIPER_LAYER, new Point(0, 0),
                                  Animation.headLinkage[type]);
      idleHead.setScale(Animation.sniperScale);
      idle.addImage(idleHead);

      idleBody = new VirtualImage(SpriteDisplay.BODY_LAYER, new Point(0, 0),
                                  Animation.bodyLinkage[type]);
      idleBody.setScale(Animation.sniperScale);
      idle.addImage(idleBody);

      shooter.hide();
      idle.show();
    }
  }

  public function cleanup() : Void
  {
    shooter.cleanup();
    shooter = null;
    idle.cleanup();
    idle = null;
    idleHead = null;
    idleBody = null;
  }

  public function shootStep(count : Int) : Int
  {
    return shooter.step(count);
  }

  public function rotateStep(count : Int, destAngle : Int) : Int
  {
    var used = 0;
    var left = count;

    if (left > 0)
    {
      var rotate = Option.sniperHeadRotate;
      used += Util.homeInCount(left, rotate, headAngle, destAngle);
      headAngle = Util.homeIn(left, rotate, headAngle, destAngle);
      idleHead.setRotationOffset(headAngle);
    }
    if (left > 0)
    {
      var rotate = Option.sniperBodyRotate;
      if (Util.angleDistance(headAngle, bodyAngle) >= 40)
      {
        used = 0;
      }
      left = count - used;
      used += Util.homeInCount(left, rotate, bodyAngle, destAngle);
      bodyAngle = Util.homeIn(left, rotate, bodyAngle, destAngle);
      idleBody.setRotationOffset(bodyAngle);
    }
    idle.update();
    return used;
  }

  public function startShooting() : Void
  {
    idle.hide();
    shooter.setRotationOffset(bodyAngle);
    shooter.show();
    shooter.resetWait();
  }

  public function stopShooting() : Void
  {
    idle.show();
    shooter.hide();
  }

  public static function saveS(current : SniperSprite) : Dynamic
  {
    return current.save();
  }

  public function save() : Dynamic
  {
    return { type : type,
        shooter : Save.maybe(shooter, Sprite.saveS),
        idle : idle.save(),
        idleHead : idleHead.save(),
        idleBody : idleBody.save(),
        headAngle : headAngle,
        bodyAngle : bodyAngle };
  }

  public static function load(input : Dynamic) : SniperSprite
  {
    var result = new SniperSprite(null, 0);
    result.type = input.type;
    result.shooter = Load.maybe(input.shooter, Sprite.load);
    result.idle = ImageStack.load(input.idle);
    result.idleHead = VirtualImage.load(input.idleHead);
    result.idleBody = VirtualImage.load(input.idleBody);
    result.idle.addImage(result.idleHead);
    result.idle.addImage(result.idleBody);
    result.headAngle = input.headAngle;
    result.bodyAngle = input.bodyAngle;
    return result;
  }

  var type : Int;
  var shooter : Sprite;
  var idle : ImageStack;
  var idleHead : VirtualImage;
  var idleBody : VirtualImage;
  var headAngle : Int;
  var bodyAngle : Int;
}
