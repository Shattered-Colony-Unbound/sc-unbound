// A map feature is a location on the map which causes a special
// action to happen when it is invoked. It requires a workshop to be
// created, and the workshop must do some amount of work to invoke the
// action.

package feature;

class Root
{
  public function new(newMapPos : Point, newCount : Int) : Void
  {
    type = 0;
    mapPos = newMapPos;
    counter = newCount;
    max = newCount;
    display = new ui.Sprite(newMapPos.toPixel(), 0, 0, ui.Animation.feature);
    display.update();
    Game.actions.push(new action.AddFeature(mapPos, this));
  }

  public function cleanup() : Void
  {
    display.cleanup();
  }

  public function maxWork() : Int
  {
    return max;
  }

  public function workLeft() : Int
  {
    return counter;
  }

  public function doWork() : Bool
  {
    var result = false;
    if (counter > 0)
    {
      --counter;
    }
    if (counter == 0)
    {
      var newAction = getAction();
      if (newAction != null)
      {
        Game.actions.push(new action.RemoveFeature(mapPos));
        Game.actions.push(newAction);
      }
      result = true;
    }
    return result;
  }

  function getAction() : action.Interface
  {
    return null;
  }

  public function getHoverTip() : String
  {
    return ui.Text.hoverFeatureTip;
  }

  public function getWorkshopTip() : String
  {
    return ui.Text.workshopFeatureTip;
  }

  public function getBuildTip() : String
  {
    return ui.Text.backgroundBuildFeatureTip;
  }

  public static function saveS(current : Root) : Dynamic
  {
    return current.save();
  }

  public function save() : Dynamic
  {
    return { type : type,
        mapPos : mapPos.save(),
        counter : counter,
        max : max,
        display : display.save()
    };
  }

  public function load(input : Dynamic) : Void
  {
    max = input.max;
    display = ui.Sprite.load(input.display);
  }

  public static function loadS(input : Dynamic) : Root
  {
    var result : Root = null;
    if (input.parent.type == DYNAMITE)
    {
      result = new Dynamite(Point.load(input.parent.mapPos),
                            input.parent.max, null);
      result.load(input);
    }
    return result;
  }

  static var DYNAMITE = 0;

  var type : Int;
  var mapPos : Point;
  var counter : Int;
  var max : Int;
  var display : ui.Sprite;
}
