package ui;

class ToolTip
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      l : LayoutGame) : Void
  {
    clip = new ToolTipClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.stage.addEventListener(flash.events.MouseEvent.MOUSE_MOVE,
                                mouseMove);
    clip.mouseEnabled = false;
    clip.mouseChildren = false;

    clip.text.wordWrap = true;
    clip.text.autoSize = flash.text.TextFieldAutoSize.LEFT;

    var sheet = new flash.text.StyleSheet();
    sheet.parseCSS(Text.toolTipStyleSheet);
    clip.text.styleSheet = sheet;

    shouldShow = false;
    framesLeft = 0;
  }

  public function cleanup() : Void
  {
    clip.stage.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE,
                                   mouseMove);
    clip.parent.removeChild(clip);
  }

  static var margin = 40;

  public function show(newText : String) : Void
  {
    shouldShow = true;
    if (newText != null)
    {
      var l = Game.view.layout;
      clip.text.width = l.tipWidth;
      clip.text.htmlText = newText;
      var mouse = new Point(Math.floor(clip.stage.mouseX),
                            Math.floor(clip.stage.mouseY));
      clip.x = mouse.x + margin;
      if (clip.x + clip.text.width > l.screenSize.x)
      {
        clip.x = mouse.x - margin - clip.text.width;
      }
      clip.y = mouse.y + margin;
      if (clip.y + clip.text.height > l.screenSize.y)
      {
        clip.y = mouse.y - margin - clip.text.height;
      }

      clip.back.graphics.clear();
      clip.back.graphics.beginFill(Color.toolTip, Color.textBoxAlpha);
      clip.back.graphics.drawRoundRect(0, 0,
                                       clip.text.width, clip.text.height,
                                       10, 10);
      clip.back.graphics.endFill();
    }
    else
    {
      shouldShow = false;
    }
    refresh();
  }

  public function refresh() : Void
  {
    if (shouldShow && framesLeft <= 0)
    {
      clip.visible = true;
    }
    else
    {
      clip.visible = false;
    }
  }

  public function hide() : Void
  {
    shouldShow = false;
    clip.visible = false;
  }

  function mouseMove(event : flash.events.MouseEvent) : Void
  {
    framesLeft = Option.toolTipDelay;
  }

  public function enterFrame() : Void
  {
    --framesLeft;
    if (framesLeft <= 0)
    {
      refresh();
    }
  }

  var clip : ToolTipClip;
  var shouldShow : Bool;
  var framesLeft : Int;
}
