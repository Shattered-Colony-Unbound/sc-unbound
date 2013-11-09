package ui.menu;

class SaveMapMenu extends MenuRoot
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      screenSize : Point) : Void
  {
    super();
    clip = new SaveMapMenuClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;

    clip.copyLabel.mouseEnabled = false;

    buttons = new ui.ButtonList(click, null, [clip.back, clip.copyButton]);

    clip.entry.multiline = true;
    clip.entry.wordWrap = true;
    clip.entry.autoSize = flash.text.TextFieldAutoSize.NONE;

    resize(screenSize);
  }


  override public function cleanup() : Void
  {
    clip.removeEventListener(flash.events.Event.ENTER_FRAME,
                             componentUpdate);
    buttons.cleanup();
    clip.parent.removeChild(clip);
    clip = null;
  }

  override public function resize(size : Point) : Void
  {
    ui.Util.centerHorizontally(clip.back, size);
    ui.Util.alignBottom(clip.back, size);
    ui.Util.alignBottom(clip.copyButton, size);
    ui.Util.alignLabel(clip.copyButton, clip.copyLabel);
    var width = size.x - 60;
    if (width > 600)
    {
      width = 600;
    }
    clip.entry.x = (size.x - width) / 2 - 10;
    clip.entry.width = width;
    clip.entry.height = size.y - 140;
    clip.scrollBar.x = clip.entry.x + clip.entry.width + 5;
    clip.scrollBar.height = size.y - 140;
    clip.scrollBar.update();

    clip.addEventListener(flash.events.Event.ENTER_FRAME,
                          componentUpdate);
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
    clip.entry.text = Game.settings.saveMap();
    clip.scrollBar.update();

    clip.addEventListener(flash.events.Event.ENTER_FRAME,
                          componentUpdate);
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
      flash.system.System.setClipboard(clip.entry.text);
    }
  }

  function componentUpdate(event : flash.events.Event) : Void
  {
    clip.scrollBar.update();
    clip.removeEventListener(flash.events.Event.ENTER_FRAME,
                             componentUpdate);
  }

  var clip : SaveMapMenuClip;
  var buttons : ui.ButtonList;
}
