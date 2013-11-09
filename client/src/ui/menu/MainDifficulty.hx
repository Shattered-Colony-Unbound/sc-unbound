package ui.menu;

class MainDifficulty extends MenuRoot
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      screenSize : Point) : Void
  {
    super();
    clip = new MainDifficultyClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;

    buttons = new ui.ButtonList(click, null, [clip.novice, clip.veteran,
                                              clip.expert, clip.quartermaster,
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
      click(4);
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

  public static function tutorialClick() : Void
  {
/*
    Main.menu.getSettings().setDifficulty(0);
    Main.menu.getSettings().setCityName("tutorial");
    Main.menu.changeState(MainMenu.GENERATE_MAP);
*/
  }

  function click(choice : Int) : Void
  {
    ui.Util.success();
    if (choice == 4)
    {
      Main.menu.changeState(MainMenu.PLAY);
    }
    else
    {
      Main.menu.getSettings().setDifficulty(choice + 1);
      Main.menu.changeState(MainMenu.NAME);
    }
  }

  var clip : MainDifficultyClip;
  var buttons : ui.ButtonList;
}
