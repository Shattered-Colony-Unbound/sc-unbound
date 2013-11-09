package ui;

class ResourceBar
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      newPayload : Resource, newX : Int, newY : Int,
                      newWidth : Int,
                      newClickAction : Resource -> Bool -> Void,
                      newHoverAction : Resource -> Bool -> String,
                      l : LayoutGame)
  {
    payload = newPayload;
    clickAction = newClickAction;
    hoverAction = newHoverAction;
    clip = new flash.display.Sprite();
    parent.addChild(clip);
    clip.x = newX;
    clip.y = newY;
    clip.visible = false;
    clip.addEventListener(flash.events.MouseEvent.CLICK, release);
    clip.addEventListener(flash.events.MouseEvent.ROLL_OVER, rollOver);
    clip.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, rollOver);
    clip.addEventListener(flash.events.MouseEvent.ROLL_OUT, rollOut);

    var barData = new flash.display.BitmapData(newWidth, Option.cellPixels,
                                               true, 0x00ffffff);
    bar = new flash.display.Bitmap(barData);
    clip.addChild(bar);
    bar.visible = true;
    bar.x = 0;
    bar.y = 0;
    bar.width = newWidth;
    bar.height = Option.cellPixels;

    text = ui.Util.createTextField(clip, new Point(0, 0),
                                   new Point(newWidth, Option.cellPixels));
    text.visible = true;
    text.border = false;
    text.background = false;

    var format = ui.Util.createTextFormat();
    format.align = flash.text.TextFormatAlign.RIGHT;
    format.size = FontSize.resourceBar;
    format.color = Color.resourceBarText;
    text.defaultTextFormat = format;

    survivorImages = null;
    if (payload == Resource.SURVIVORS)
    {
      survivorImages = [];
      for (i in 0...Animation.carryAmmo.getTypeCount())
      {
        var linkage = Sprite.getSurvivorLinkage(Resource.SURVIVORS, i);
        survivorImages[i] = new CenteredImage(clip, linkage);
        survivorImages[i].detach();
        survivorImages[i].setCenter(new Point(0, 0));
//        survivorImages[i].gotoFrame(TruckSprite.resourceFrame(i));
      }
    }

    var resourceIndex = Lib.resourceToIndex(payload);
    baseY = resourceRow[resourceIndex] * Option.cellPixels;
    sourceRect = new flash.geom.Rectangle(0, 0,
                                          Option.cellPixels,
                                          Option.cellPixels);
    truckLoad = Lib.truckLoad(payload);
    allowedWidth = newWidth;
    middle = Math.floor(allowedWidth/2);
  }

  public function cleanup() : Void
  {
    if (survivorImages != null)
    {
      for (image in survivorImages)
      {
        image.cleanup();
      }
      survivorImages = null;
    }
    text.parent.removeChild(text);
    text = null;
    bar.parent.removeChild(bar);
    bar.bitmapData.dispose();
    bar = null;
    clip.removeEventListener(flash.events.MouseEvent.CLICK, release);
    clip.removeEventListener(flash.events.MouseEvent.ROLL_OVER, rollOver);
    clip.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, rollOver);
    clip.removeEventListener(flash.events.MouseEvent.ROLL_OUT, rollOut);
    clip.parent.removeChild(clip);
    clip = null;
  }

  function release(event : flash.events.MouseEvent)
  {
    var pos = new Point(Math.floor(event.stageX),
                        Math.floor(event.stageY));
//    if (Game.view.tutorial.within(pos))
    {
      var isIncrease = event.localX >= middle;
      clickAction(payload, isIncrease);
    }
  }

  function rollOver(event : flash.events.MouseEvent)
  {
    var isIncrease = event.localX >= middle;
    Game.view.toolTip.show(hoverAction(payload, isIncrease));
  }

  function rollOut(event : flash.events.MouseEvent)
  {
  }

  public function getPayload() : Resource
  {
    return payload;
  }

  public function hide() : Void
  {
    clip.visible = false;
  }

  public function move(newX : Int, newY : Int) : Void
  {
    clip.x = newX;
    clip.y = newY;
  }

  public function show(stuff : Int, incoming : Int,
                       reserve : Int, ground : Int)
  {
    middle = calculateMiddle(stuff, incoming, reserve, payload, allowedWidth);
    clip.visible = true;
    bar.bitmapData.fillRect(new flash.geom.Rectangle(0, 0,
                                                     allowedWidth,
                                                     Option.cellPixels),
                            Color.resourceBarBorder);
    bar.bitmapData.fillRect(new flash.geom.Rectangle(1, 1,
                                                     middle,
                                                     Option.cellPixels - 2),
                            Color.resourceBarQuota);
    bar.bitmapData.fillRect(new flash.geom.Rectangle(middle, 1,
                                                     allowedWidth - 2,
                                                     Option.cellPixels - 2),
                            Color.resourceBarOverflow);
    if (ground > 0)
    {
      text.htmlText = Lib.resourceToString(payload) + " left: "
        + Std.string(ground);
    }
    else if (stuff == 0 && incoming == 0 && reserve == 0 && ground == 0)
    {
      text.htmlText = Lib.resourceToString(payload);
    }
    else
    {
      text.htmlText = "";
    }
    text.y = (Option.cellPixels - text.textHeight) / 2;
    var reserveSize = Math.ceil(reserve / truckLoad) + 1;
    var reserveStuff = Math.floor(Math.min(reserve, stuff));
    if (payload != Resource.SURVIVORS)
    {
      reserveSize -= 4*Math.floor(reserveStuff / groupSize);
    }
    var reserveIncoming = Math.floor(Math.min(reserve - reserveStuff,
                                              incoming));
    survivorOffset = 0;
    drawHalf(0, reserveSize, reserve, reserveStuff, reserveIncoming, middle);
    if (stuff + incoming > reserve)
    {
      var overflowTotal = stuff + incoming - reserve;
      var overflowSize = Math.ceil(overflowTotal/truckLoad) + 1;
      var overflowWidth = allowedWidth - middle;
      survivorOffset = Math.floor(reserve / truckLoad);
      if (stuff >= reserve)
      {
        if (payload != Resource.SURVIVORS)
        {
          overflowSize -= 4*Math.floor((stuff-reserve) / groupSize);
        }
        drawHalf(middle, overflowSize, overflowTotal, stuff - reserve,
                 incoming, overflowWidth);
      }
      else
      {
        drawHalf(middle, overflowSize, overflowTotal, 0, overflowTotal,
                 overflowWidth);
      }
    }
  }

  static var groupSize = Option.truckLoad*5;

  function drawHalf(start : Int, currentSize : Int, total : Int, stuff : Int,
                    incoming : Int, width : Int)
  {
    var totalLeft = total - stuff - incoming;
    var drawn = 0;
    var stuffFinal = stuff;
    if (payload != Resource.SURVIVORS)
    {
      var group = Math.floor(stuff / groupSize);
      drawGroup(group, STUFF, currentSize, start, width);
      drawn = group*truckLoad;
      stuffFinal = stuff - group*groupSize;
      if (group > 0 && stuffFinal > 0)
      {
        drawn += truckLoad;
        currentSize += 1;
      }
    }
    drawRegion(drawn, stuffFinal, STUFF, currentSize, start, width);
    drawn += stuff;
    drawRegion(drawn, incoming, INCOMING, currentSize, start, width);
    drawn += incoming;
    drawRegion(drawn, totalLeft, BACKGROUND, currentSize, start, width);
    drawn += totalLeft;
  }

  function drawGroup(count : Int, type : Int, currentSize : Int,
                     start : Int, width : Int) : Void
  {
    for (i in 0...count)
    {
      draw(i, 0, truckLoad, type, currentSize, start, width, true);
    }
  }

  function drawRegion(prevTotal : Int, count : Int, type : Int,
                      currentSize : Int, start : Int, width : Int) : Void
  {
    var num = Math.floor(prevTotal / truckLoad);
    var fraction = prevTotal % truckLoad;
    var current = count;
    while (current + fraction >= truckLoad)
    {
      draw(num, fraction, truckLoad, type, currentSize, start, width, false);
      current = current - truckLoad + fraction;
      ++num;
      fraction = 0;
    }
    draw(num, fraction, current + fraction, type, currentSize, start,
         width, false);
  }

  static var iconWidth = 24;

  // num is the icon location [0, maxSize] to draw at.
  // low is the fraction of the icon to start at.
  // high is the fraction of the icon to end at.
  // type is what kind of icon to draw.
  // currentSize is the number of icons total
  // start is the x value offset to start at
  // width is the total width of this bar
  // draw(4, 0, truckLoad, INCOMING) means draw in the fourth position
  // the entire icon of INCOMING.
  function draw(num : Int, low : Int, high : Int, type : Int,
                currentSize : Int, start : Int, width : Int,
                useGroup : Bool) : Void
  {
    sourceRect.x = Lib.cellToPixel(type);
    var height = Option.cellPixels - 8;
    var lower = Math.floor(low / truckLoad * height) + 4;
    var higher = Math.floor(high / truckLoad * height) + 4;
    sourceRect.y = baseY + (Option.cellPixels - higher);
    if (useGroup)
    {
      sourceRect.y += Option.cellPixels;
    }
//    var destX = Math.floor((width-8) / currentSize * num - 6) + start;
    var denom = currentSize - 1;
    var factor = num;
    if (payload == Resource.SURVIVORS)
    {
      denom = Math.ceil(currentSize/2)-1;
      factor = Math.floor(num/2);
    }
    if (denom == 0)
    {
      denom = 1;
      factor = 0;
    }
    var destX = Math.floor((width-iconWidth)/denom * factor) + start;
    if (destX > Lib.cellToPixel(factor) + start)
    {
      destX = Lib.cellToPixel(factor) + start;
    }

    sourceRect.height = higher - lower;
    if (payload == Resource.SURVIVORS && high-low > 0)
    {
#if AS3
      var offsetX = Math.floor(Option.cellPixels/2);
      var offsetY = Math.floor(Option.cellPixels/4);
      if (num % 2 == 1)
      {
        offsetY *= 3;
      }
#else
      var offsetX = 0;
      var offsetY = 0;
      if (num % 2 == 1)
      {
        offsetY = Math.floor(Option.cellPixels/2);
      }
#end
      var index = survivorOffset + num;
      var select = Game.select.getSelected();
      var tower = Game.map.getCell(select.x, select.y).getTower();
      var survivorType = tower.getSurvivorType(index);
      var color = null;
      if (type == BACKGROUND)
      {
        color = backgroundColor;
      }
      else if (type == INCOMING)
      {
        color = incomingColor;
      }
      Workaround.drawOverPixels(bar, survivorImages[survivorType].getImage(),
                                destX + offsetX, offsetY, color);
    }
    else
    {
      Workaround.copyOverPixels(bar, Game.view.barSource, sourceRect,
                                destX, Option.cellPixels - higher);
    }
  }

  static var margin = 35;
  static var evenOut = 1;

  public static function calculateMiddle(stuff : Int,
                                         incoming : Int,
                                         reserve : Int,
                                         payload : Resource,
                                         allowedWidth : Int) : Int
  {
    var load = Lib.truckLoad(payload);
    var weightedReserve = Math.ceil(reserve / load);
    var weightedResource = Math.ceil((stuff + incoming) / load);
    var total = Math.floor(Math.max(weightedResource, weightedReserve))
      + evenOut*2;
    var result = Math.floor(allowedWidth*((weightedReserve+evenOut)/total));
    var unpacked = (weightedReserve+1) * margin;
    result = Math.floor(Math.min(result, unpacked));
    result = Math.floor(Math.max(result, margin));
    result = Math.floor(Math.min(result, allowedWidth - margin));
    return result;
  }


  var clip : flash.display.DisplayObjectContainer;
  var bar : flash.display.Bitmap;
  var text : flash.text.TextField;
  var survivorImages : Array<CenteredImage>;

  var payload : Resource;
  var sourceRect : flash.geom.Rectangle;
  var baseY : Int;
  var truckLoad : Int;
  var allowedWidth : Int;
  var middle : Int;

  // The offset for finding the type of survivor for the num'th survivor.
  var survivorOffset : Int;

  var clickAction : Resource -> Bool -> Void;
  var hoverAction : Resource -> Bool -> String;

  static var BACKGROUND = 0;
  static var STUFF = 1;
  static var INCOMING = 2;

  static var resourceRow = [0, 2, 4, 0];
  static var backgroundColor = [0xff, 0xff, 0xff];
  static var incomingColor = [0x00, 0x77, 0x00];
}
