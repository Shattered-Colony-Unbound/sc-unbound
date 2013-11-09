package ui.menu;

class MainStart extends MenuRoot
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      screenSize : Point) : Void
  {
    super();
    clip = new MainStartClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;

    var buttonArray = [clip.newGame, clip.loadGame,
                       clip.pedia, clip.options,
                       clip.editor, clip.credits];
    if (Sponsor.type == Sponsor.ANDKON)
    {
      clip.andkonLabel.mouseEnabled = false;
      buttonArray.push(clip.andkonButton);
    }
    else
    {
      clip.andkonButton.visible = false;
      clip.andkonLabel.visible = false;
    }

    buttons = new ui.ButtonList(click, null, buttonArray);
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
    ui.Util.scaleToFit(clip.background, size);
    var begin = Math.floor(clip.newGame.x + clip.newGame.width);
    clip.title.x = begin + ((size.x - begin - clip.title.width) / 2) + 10;

    if (Sponsor.type == Sponsor.ANDKON)
    {
      clip.andkon.x = size.x - 110;
      clip.andkon.y = size.y - 110;
    }
    if (Sponsor.type == Sponsor.BOMB)
    {
      clip.mb2.x = size.x;
      clip.mb2.y = size.y;
    }
    else if (Sponsor.type == Sponsor.ARMOR)
    {
      clip.armor.x = size.x - clip.armor.width - 10;
      clip.armor.y = size.y - clip.armor.height - 10;
      clip.facebook.x = size.x - clip.facebook.width - 148;
      clip.facebook.y = size.y - clip.facebook.height - 80;
      clip.twitter.x = size.x - clip.twitter.width - 34;
      clip.twitter.y = size.y - clip.twitter.height - 80;
    }
  }

  override public function show() : Void
  {
    if (Main.menu != null)
    {
      Main.menu.setSettings(new logic.GameSettings());
    }
    clip.visible = true;
    if (Main.canLoad())
    {
      buttons.setNormal(clip.loadGame);
    }
    else
    {
      buttons.setGhosted(clip.loadGame);
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
      ui.Util.success();
      Main.menu.getSettings().clearEditor();
      if (Main.firstGame())
      {
        Main.menu.changeState(MainMenu.TUTORIAL);
      }
      else
      {
        Main.menu.changeState(MainMenu.PLAY);
      }
    }
    else if (choice == 1)
    {
      if (Main.canLoad())
      {
        ui.Util.success();
        Main.menu.changeState(MainMenu.LOAD_WAIT);
      }
      else
      {
        ui.Util.failure();
      }
    }
    else if (choice == 2)
    {
      ui.Util.success();
      Main.menu.changeState(MainMenu.PEDIA);
    }
    else if (choice == 3)
    {
      ui.Util.success();
      Main.menu.changeState(MainMenu.OPTIONS);
    }
    else if (choice == 4)
    {
      ui.Util.success();
      Main.menu.changeState(MainMenu.EDIT_SELECT);
    }
    else if (choice == 5)
    {
      ui.Util.success();
      Main.menu.changeState(MainMenu.CREDITS);
    }
    else if (choice == 6)
    {
      native.NativeBase.navigateToURL(new flash.net.URLRequest("http://www.andkon.com/arcade/"));
    }
  }

  var clip : MainStartClip;
  var buttons : ui.ButtonList;
}
