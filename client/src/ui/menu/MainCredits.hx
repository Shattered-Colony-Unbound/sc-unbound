// Menu displaying credits information
package ui.menu;

class MainCredits extends MenuRoot
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      screenSize : Point) : Void
  {
    super();
    clip = new MainCreditsClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;

    buttons = new ui.ButtonList(returnClick, null, [clip.back]);
    var scrolls = [cast(clip.credits, flash.display.DisplayObject)];
    credits = new ui.ScrollingText(parent, scrolls, [-130], screenSize);

    resize(screenSize);
  }

  override public function cleanup() : Void
  {
    credits.cleanup();
    buttons.cleanup();
    clip.parent.removeChild(clip);
    clip = null;
  }

  override public function resize(size : Point) : Void
  {
    ui.Util.scaleToFit(clip.background, size);
    var begin = Math.floor(clip.back.x + clip.back.width);
    clip.credits.x = begin + ((size.x - begin - clip.credits.width) / 2);
    credits.resize(size);
  }

  override public function hotkey(ch : String, code : Int) : Bool
  {
    var used = true;
    if (code == Keyboard.escapeCode)
    {
      returnClick(0);
    }
    else
    {
      used = false;
    }
    return used;
  }

  override public function show() : Void
  {
    clip.visible = true;
    credits.begin();
  }

  override public function hide() : Void
  {
    clip.visible = false;
    credits.end();
  }

  function returnClick(choice : Int) : Void
  {
    ui.Util.success();
    Main.menu.changeState(MainMenu.START);
  }

  var clip : MainCreditsClip;
  var buttons : ui.ButtonList;
  var credits : ui.ScrollingText;
}
