package ui.menu;

class MainName extends MenuRoot
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      screenSize : Point) : Void
  {
    super();
    clip = new MainNameClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;

    ui.Util.setupInputText(clip.cityName, ui.Text.nameConstraint,
                           ui.Util.NAME_MAX_CHARS);

    buttons = new ui.ButtonList(click, null, [clip.playGame, clip.back]);
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
    ui.Util.alignRight(clip.notice, size);
    ui.Util.alignBottom(clip.difficulty, size);
    ui.Util.centerHorizontally(clip.difficulty, size);
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
    clip.cityName.setSelection(0, 0);
    var cityIndex = Lib.rand(ui.Text.cities.length);
    clip.cityName.text = ui.Text.cities[cityIndex];
    var last = clip.cityName.text.length;
    clip.cityName.setSelection(0, last);
    clip.stage.focus = clip.cityName;
    clip.difficulty.text = Main.menu.getSettings().getDifficultyName();
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
      Main.menu.getSettings().setCityName(clip.cityName.text);
      Main.menu.changeState(MainMenu.STORY_BRIEFING);
    }
    else if (choice == 1)
    {
      Main.menu.changeState(MainMenu.DIFFICULTY);
    }
  }

  var clip : MainNameClip;
  var buttons : ui.ButtonList;
}
