package ui.menu;

class MainPlay extends MenuRoot
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      screenSize : Point) : Void
  {
    super();
    clip = new MainPlayClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;
    buttons = new ui.ButtonList(click, null, [clip.campaign, clip.randomMap,
                                              clip.browse,
                                              clip.downloadMap, clip.loadMap,
                                              clip.back]);
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
      click(5);
    }
    else
    {
      used = false;
    }
    return used;
  }

  override public function show() : Void
  {
    Main.menu.getSettings().clearEditor();
    clip.visible = true;
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
      Main.menu.changeState(MainMenu.CAMPAIGN);
    }
    else if (choice == 1)
    {
      Main.menu.changeState(MainMenu.DIFFICULTY);
    }
    else if (choice == 2)
    {
      Main.menu.changeState(MainMenu.BROWSE_WAIT);
    }
    else if (choice == 3)
    {
      Main.menu.changeState(MainMenu.DOWNLOAD_MAP);
    }
    else if (choice == 4)
    {
      Main.menu.changeState(MainMenu.PASTE_MAP);
    }
    else if (choice == 5)
    {
      Main.menu.changeState(MainMenu.START);
    }
  }

  var clip : MainPlayClip;
  var buttons : ui.ButtonList;
}
