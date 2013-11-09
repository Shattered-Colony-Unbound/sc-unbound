package ui.menu;

class MainTutorial extends MenuRoot
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      screenSize : Point) : Void
  {
    super();
    clip = new MainTutorialClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;

    buttons = new ui.ButtonList(click, null, [clip.playTutorial,
                                              clip.skipTutorial,
                                              clip.back]);
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
  }

  override public function hotkey(ch : String, code : Int)
  {
    var used = true;
    if (code == Keyboard.escapeCode)
    {
      click(2);
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
      Main.menu.rateState = MainMenu.CAMPAIGN;
      WaitMenu.loadMap(ui.Text.levels[0]);
      Main.menu.getSettings().setCampaign(0);
    }
    else if (choice == 1)
    {
      Main.menu.changeState(MainMenu.PLAY);
    }
    else if (choice == 2)
    {
      Main.menu.changeState(MainMenu.START);
    }
  }

  var clip : MainTutorialClip;
  var buttons : ui.ButtonList;
}
