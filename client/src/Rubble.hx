class Rubble
{
  public function new(newX : Int, newY : Int) : Void
  {
    x = newX;
    y = newY;
    sprite = null;
    salvage = new Salvage();
  }

  public function cleanup() : Void
  {
    if (sprite != null)
    {
      sprite.cleanup();
    }
  }

  public function getSalvage() : Salvage
  {
    return salvage;
  }

  public function addResource(payload : Resource, amount : Int,
                              frame : Null<Int>)
  {
    salvage.addResource(payload, amount);
    addSprite(frame);
  }

  function addSprite(optFrame : Null<Int>) : Void
  {
    if (sprite == null)
    {
      sprite = new ui.Sprite(new Point(x, y).toPixel(), 0, 0,
                             ui.Animation.rubble);
    }
    var frame = 0;
    if (optFrame != null)
    {
      frame = optFrame;
    }
    else
    {
      frame = 1;
      if (salvage.getResourceCount(Resource.AMMO) > 0
          && salvage.getResourceCount(Resource.BOARDS) > 0)
      {
        frame = 3;
      }
      else if (salvage.getResourceCount(Resource.AMMO) > 0)
      {
        frame = 2;
      }
    }
    if (frame > 3)
    {
      var dir = Lib.indexToDirection(mapgen.Util.rand(4));
      sprite.setRotationOffset(Lib.directionToAngle(dir));
    }

    sprite.setFrame(frame);
    sprite.update();
  }

  public static function save(rubble : Rubble) : Dynamic
  {
    return { x : rubble.x,
        y : rubble.y,
        sprite : Save.maybe(rubble.sprite, ui.Sprite.saveS),
        salvage : rubble.salvage.save() };
  }

  static public function load(input : Dynamic) : Rubble
  {
    var result = new Rubble(input.x, input.y);
    result.salvage = Salvage.load(input.salvage);
    result.sprite = Load.maybe(input.sprite, ui.Sprite.load);
    return result;
  }

  var x : Int;
  var y : Int;
  var sprite : ui.Sprite;
  var salvage : Salvage;

  public static var rubbleCount = 19;
}
