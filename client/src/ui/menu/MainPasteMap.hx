package ui.menu;

class MainPasteMap extends MenuRoot
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      screenSize : Point) : Void
  {
    super();
    clip = new MainPasteMapClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;

    clip.loadLabel.mouseEnabled = false;

    buttons = new ui.ButtonList(click, null, [clip.back, clip.loadButton]);

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
    ui.Util.alignBottom(clip.back, size);
    ui.Util.alignBottom(clip.loadButton, size);
    ui.Util.centerHorizontally(clip.loadButton, size);
    ui.Util.alignLabel(clip.loadButton, clip.loadLabel);
    ui.Util.scaleToFit(clip.background, size);
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
    else if (code == Keyboard.enterCode)
    {
      click(1);
    }
    else
    {
      used = false;
    }
    return used;
  }

  public static var shouldContinue : Bool = false;

  override public function show() : Void
  {
    Main.error = "";
    clip.visible = true;
    clip.entry.text = "";
    if (shouldContinue)
    {
      clip.entry.text = Main.getEditSave();
      shouldContinue = false;
    }
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
      if (Main.menu.getSettings().isEditor())
      {
        Main.menu.changeState(MainMenu.EDIT_SELECT);
      }
      else
      {
        Main.menu.changeState(MainMenu.PLAY);
      }
    }
    else if (choice == 1)
    {
      Main.menu.rateState = MainMenu.PASTE_MAP;
      WaitMenu.loadMap(clip.entry.text);
    }
  }

  function componentUpdate(event : flash.events.Event) : Void
  {
    clip.scrollBar.update();
    clip.removeEventListener(flash.events.Event.ENTER_FRAME,
                             componentUpdate);
  }

  var clip : MainPasteMapClip;
  var buttons : ui.ButtonList;
}
