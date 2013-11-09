package ui;

class FailWarning
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      size : Point) : Void
  {
    clip = new FailClip();
    clip.mouseEnabled = false;
    clip.mouseChildren = false;
    parent.addChild(clip);
    clip.visible = false;
    clip.fail.wordWrap = true;
    clip.fail.autoSize = flash.text.TextFieldAutoSize.LEFT;

    frame = maxFrame + 1;
    resize(size);
  }

  public function cleanup() : Void
  {
    clip.parent.removeChild(clip);
  }

  public function resize(size : Point) : Void
  {
    ui.Util.centerHorizontally(clip.fail, size);
    ui.Util.centerVertically(clip.fail, size);
  }

  public function enterFrame() : Void
  {
    if (frame < alphaFrame)
    {
      clip.visible = true;
      clip.alpha = 1.0;
      ++frame;
    }
    else if (frame < maxFrame)
    {
      clip.visible = true;
      clip.alpha = (maxFrame - frame)/(maxFrame - alphaFrame);
      ++frame;
    }
    else if (frame == maxFrame)
    {
      clip.visible = false;
      ++frame;
    }
  }

  public function show(message : String) : Void
  {
    if (message != null)
    {
      clip.fail.text = message;
      resize(Game.view.layout.screenSize);
      frame = 0;
      clip.visible = true;
      clip.alpha = 1.0;
    }
  }

  var clip : FailClip;
  var frame : Int;

  static var alphaFrame = 10;
  static var maxFrame = 15;
}
