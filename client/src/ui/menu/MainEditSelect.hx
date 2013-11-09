package ui.menu;

class MainEditSelect extends MenuRoot
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      screenSize : Point) : Void
  {
    super();
    clip = new MainEditSelectClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;

    buttons = new ui.ButtonList(click, null, [clip.newMap, clip.continueMap,
                                              clip.downloadMap,
                                              clip.loadMap, clip.instructions,
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
    clip.visible = true;
    Main.menu.getSettings().setEditor();
    if (Main.getEditSave() == null)
    {
      buttons.setGhosted(clip.continueMap);
    }
    else
    {
      buttons.setNormal(clip.continueMap);
    }
  }

  override public function hide() : Void
  {
    clip.visible = false;
  }

  function click(choice : Int) : Void
  {
    if (choice == 0)
    {
      Main.menu.changeState(MainMenu.EDIT);
      ui.Util.success();
    }
    if (choice == 1)
    {
      if (Main.getEditSave() != null)
      {
        MainPasteMap.shouldContinue = true;
        Main.menu.changeState(MainMenu.PASTE_MAP);
      }
      ui.Util.success();
    }
    else if (choice == 2)
    {
      Main.menu.changeState(MainMenu.DOWNLOAD_MAP);
      ui.Util.success();
    }
    else if (choice == 3)
    {
      Main.menu.changeState(MainMenu.PASTE_MAP);
      ui.Util.success();
    }
    else if (choice == 4)
    {
      Main.menu.changeState(MainMenu.EDIT_PEDIA);
      ui.Util.success();
    }
    else if (choice == 5)
    {
      Main.menu.changeState(MainMenu.START);
      ui.Util.success();
    }
  }

  var clip : MainEditSelectClip;
  var buttons : ui.ButtonList;
}
