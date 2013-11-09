package ui;

class Util
{
  public static
    function createTextField(parent : flash.display.DisplayObjectContainer,
                             offset : Point, size : Point)
    : flash.text.TextField
  {
    var result = new flash.text.TextField();
    parent.addChild(result);
    resizeText(result, offset, size);
    result.htmlText = "";
    result.type = flash.text.TextFieldType.DYNAMIC;
    result.selectable = false;
    result.wordWrap = true;
    result.autoSize = flash.text.TextFieldAutoSize.LEFT;
    result.embedFonts = true;
    result.mouseEnabled = false;
    result.antiAliasType = flash.text.AntiAliasType.ADVANCED;
    result.defaultTextFormat = createTextFormat();
    return result;
  }

  public static function createTextFormat() : flash.text.TextFormat
  {
    var result = new flash.text.TextFormat();
    result.align = flash.text.TextFormatAlign.LEFT;
//    result.font = new DejaVuSans().fontName;
    return result;
  }

  public static var NAME_MAX_CHARS = 100;
  public static var SIZE_MAX_CHARS = 3;

  public static function setupInputText(input : flash.text.TextField,
                                        ? restriction : String,
                                        ? maxChars : Null<Int>) : Void
  {
    input.selectable = true;
    input.autoSize = flash.text.TextFieldAutoSize.NONE;
    input.type = flash.text.TextFieldType.INPUT;
    input.mouseEnabled = true;
    input.multiline = false;
    input.wordWrap = false;
    input.alwaysShowSelection = true;
    if (restriction != null)
    {
      input.restrict = restriction;
    }
    if (maxChars != null)
    {
      input.maxChars = maxChars;
    }
  }

  public static
    function createTitleField(parent : flash.display.DisplayObjectContainer,
                              offset : Point, size : Point)
    : flash.text.TextField
  {
    var result = createTextField(parent, offset, size);
    var format = createTextFormat();
    format.color = Color.menuTitle;
    format.size = 24;
    format.align = flash.text.TextFormatAlign.CENTER;
    result.defaultTextFormat = format;
    return result;
  }

  public static function resizeText(text : flash.text.TextField,
                                    offset : Point, size : Point) : Void
  {
    text.x = offset.x;
    text.y = offset.y;
    text.width = size.x;
    text.height = size.y;
  }

  public static function drawBase(shape : flash.display.Graphics,
                                  offset : Point, size : Point,
                                  color : Int, alpha : Float) : Void
  {
    shape.clear();
    shape.beginFill(color, alpha);
    shape.drawRect(offset.x, offset.y, size.x, size.y);
    shape.endFill();
  }

  public static function fleeClick() : Void
  {
    var select = Game.select.getSelected();
    if (select != null)
    {
      Game.script.trigger(logic.Script.CLICK_FLEE, select);
      Game.map.getCell(select.x, select.y).fleeTower();
      Main.sound.play(SoundPlayer.TOWER_ABANDON);
      Game.update.changeSelect(null);
    }
  }

  public static function fleeHover() : String
  {
    return Text.fleeTip;
  }

  public static
    function createResourceBars(parent : flash.display.DisplayObjectContainer,
                                offset : Point, size : Point, delta : Point,
                                types : Array<Resource>,
                                barClick : Resource -> Bool -> Void,
                                barHover : Resource -> Bool -> String,
                                l : LayoutGame) : Array<ResourceBar>
  {
    var result = [];
    var current = offset.clone();
    for (payload in types)
    {
      result.push(new ResourceBar(parent, payload, current.x, current.y,
                                  size.x, barClick, barHover, l));
      current.y += delta.y;
    }
    return result;
  }

  public static function showResourceBars(bars : Array<ResourceBar>) : Void
  {
    for (bar in bars)
    {
      showOneResourceBar(bar);
    }
  }

  public static function showOneResourceBar(bar : ResourceBar) : Void
  {
    var payload = bar.getPayload();
    var select = Game.select.getSelected();
    if (select != null && Game.map.getCell(select.x, select.y).hasTower())
    {
      var tower = Game.map.getCell(select.x, select.y).getTower();
      var ground = Game.map.getCell(select.x,
                                    select.y).getRubbleCount(payload);
      bar.show(tower.countResource(payload),
               tower.countIncoming(payload),
               tower.countReserve(payload),
               ground);
    }
    else
    {
      throw new flash.errors.Error("ResourceBar shown when there is no valid tower.");
    }
  }

  public static function towerMenuHotkey(ch : String, code : Int) : Bool
  {
    var used = true;
    if (code == Keyboard.deleteCode || code == Keyboard.backSpaceCode)
    {
      ui.Util.fleeClick();
      success();
    }
    else
    {
      used = false;
    }
    return used;
  }

  public static function noTip() : String
  {
    return null;
  }

  public static function centerMenu(size : Point, screenSize : Point) : Point
  {
    return new Point(Math.floor((screenSize.x - size.x)/2),
                     Math.floor((screenSize.y - size.y)/2));
  }

  public static function attachButton(name : String)
    : flash.display.SimpleButton
  {
    var cl = Type.resolveClass(name);
    return Type.createInstance(cl, []);
  }

  public static var difficultyText =
    [ui.Text.tutorialText,
     ui.Text.noviceText,
     ui.Text.veteranText,
     ui.Text.expertText,
     ui.Text.quartermasterText];

  public static function success() : Void
  {
    Main.sound.play(SoundPlayer.BUTTON_SUCCESS);
  }

  public static function failure() : Void
  {
    Main.sound.play(SoundPlayer.BUTTON_FAILED);
  }

  public static function angleDistance(first : Int, second : Int) : Int
  {
    var a = (first + 360) % 360;
    var b = (second + 360) % 360;
    return Math.floor(Math.min(Lib.intAbs(a-b),
                               360-Lib.intAbs((a-b))));
  }

  public static function homeIn(count : Int, step : Int,
                                currentAngle : Int, destAngle : Int) : Int
  {
    var result = currentAngle;
    var delta = angleDistance(currentAngle, destAngle);
    if (delta >= count * step)
    {
      // The destination is further than our reach. Go as far as we
      // can in the proper direction.
      if (angleDistance(currentAngle + 1, destAngle) < delta)
      {
        result = currentAngle + count*step;
      }
      else
      {
        result = currentAngle - count*step;
      }
    }
    else
    {
      // The destination is less than count steps away. Just set the
      // angle to the destination.
      result = destAngle;
    }
    // If the distance is less than step, just skip to destAngle.
    delta = angleDistance(result, destAngle);
    if (delta < step)
    {
      result = destAngle;
    }
    return result;
  }

  public static function homeInCount(count : Int, step : Int,
                                     currentAngle : Int, destAngle : Int) : Int
  {
    var delta = angleDistance(currentAngle, destAngle);
    var steps = Math.floor(delta / step);
    return Math.floor(Math.min(count, steps));
  }

  public static function scaleToFit(clip : flash.display.DisplayObject,
                                    size : Point) : Void
  {
    var scaleX = size.x / 640.0;
    var scaleY = size.y / 480.0;
    if (scaleX >= scaleY)
    {
      clip.scaleX = scaleY;
      clip.scaleY = scaleY;
    }
    else
    {
      clip.scaleX = scaleX;
      clip.scaleY = scaleX;
    }
  }

  public static function minSize(size : Point) : Point
  {
    return new Point(Math.floor(Math.min(size.x, size.y*4/3)),
                     Math.floor(Math.min(size.x*3/4, size.y)));
  }

  public static function alignRight(clip : flash.display.DisplayObject,
                                    size : Point) : Void
  {
    clip.x = size.x - clip.width - 5;
  }

  public static function alignBottom(clip : flash.display.DisplayObject,
                                     size : Point) : Void
  {
    clip.y = size.y - clip.height - 5;
  }

  public static function centerHorizontally(clip : flash.display.DisplayObject,
                                            size : Point) : Void
  {
    clip.x = (size.x - clip.width)/2;
  }

  public static function centerVertically(clip : flash.display.DisplayObject,
                                          size : Point) : Void
  {
    clip.y = (size.y - clip.height)/2;
  }

  public static function alignLabel(clip : flash.display.DisplayObject,
                                    text : flash.text.TextField) : Void
  {
    text.x = clip.x + 34.6;
    text.y = clip.y + 6.7;
  }
}
