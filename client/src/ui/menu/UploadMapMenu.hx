package ui.menu;

class UploadMapMenu extends MenuRoot
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      screenSize : Point) : Void
  {
    super();
    clip = new UploadMapMenuClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;

    clip.url.selectable = true;
    clip.url.autoSize = flash.text.TextFieldAutoSize.NONE;
    clip.url.mouseEnabled = true;
    clip.url.multiline = false;
    clip.url.wordWrap = false;
    clip.url.alwaysShowSelection = true;

    buttons = new ui.ButtonList(click, null, [clip.back, clip.copyButton]);

    resize(screenSize);
  }

  override public function cleanup() : Void
  {
    buttons.cleanup();
    clip.parent.removeChild(clip);
    clip = null;
  }

  override public function resize(size : Point) : Void
  {
  }

  override public function hotkey(ch : String, code : Int) : Bool
  {
    var used = true;
    if (code == Keyboard.escapeCode)
    {
      click(0);
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
    clip.url.text = Game.settings.getUrl();
    clip.url.setSelection(0, clip.url.text.length);
    clip.stage.focus = clip.url;
  }

  override public function hide() : Void
  {
    clip.visible = false;
  }

  function click(choice : Int) : Void
  {
    ui.Util.success();
    if (choice == 0)
    {
      Game.view.centerMenu.changeState(CenterMenu.SYSTEM);
    }
    else if (choice == 1)
    {
      flash.system.System.setClipboard(clip.url.text);
    }
  }

  var clip : UploadMapMenuClip;
  var buttons : ui.ButtonList;
}
