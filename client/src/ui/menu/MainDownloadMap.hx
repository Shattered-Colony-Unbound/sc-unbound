package ui.menu;

class MainDownloadMap extends MenuRoot
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      screenSize : Point) : Void
  {
    super();
    clip = new MainDownloadMapClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;
    ui.Util.setupInputText(clip.url);

    buttons = new ui.ButtonList(click, null, [clip.loadButton, clip.back]);

    resize(screenSize);
  }

  override public function cleanup() : Void
  {
    buttons.cleanup();
    clip.parent.removeChild(clip);
  }

  override public function resize(size : Point) : Void
  {
    ui.Util.scaleToFit(clip.background, size);
  }

  override public function hotkey(ch : String, code : Int) : Bool
  {
    var used = true;
    if (code == Keyboard.escapeCode)
    {
      click(1);
    }
    else if (code == Keyboard.enterCode)
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
    clip.url.text = "";
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
      if (clip.url.text != "")
      {
        Main.menu.rateState = MainMenu.DOWNLOAD_MAP;
        Main.menu.getSettings().setUrl(clip.url.text);
        Main.menu.changeState(MainMenu.DOWNLOAD_MAP_WAIT);
      }
    }
    else if (choice == 1)
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
  }

  var clip : MainDownloadMapClip;
  var buttons : ui.ButtonList;
}
