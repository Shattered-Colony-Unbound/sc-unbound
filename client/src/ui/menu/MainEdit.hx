package ui.menu;

class MainEdit extends MenuRoot
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      screenSize : Point) : Void
  {
    super();
    difficulty = 1;
    clip = new MainEditClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;

    ui.Util.setupInputText(clip.cityName, ui.Text.nameConstraint,
                           ui.Util.NAME_MAX_CHARS);
    ui.Util.setupInputText(clip.widthText, ui.Text.sizeConstraint,
                           ui.Util.SIZE_MAX_CHARS);
    ui.Util.setupInputText(clip.heightText, ui.Text.sizeConstraint,
                           ui.Util.SIZE_MAX_CHARS);
    clip.cityName.tabEnabled = true;
    clip.cityName.tabIndex = 1;
    clip.widthText.tabEnabled = true;
    clip.widthText.tabIndex = 2;
    clip.heightText.tabEnabled = true;
    clip.heightText.tabIndex = 3;

    clip.newMapLabel.mouseEnabled = false;

    buttons = new ui.ButtonList(click, null,
                                [clip.difficultyDown, clip.difficultyUp,
                                 clip.newMap, clip.back]);
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

  override public function hotkey(ch : String, code : Int) : Bool
  {
    var used = true;
    if (code == Keyboard.escapeCode)
    {
      click(3);
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
    difficulty = 1;
    clip.cityName.setSelection(0, 0);
    var cityIndex = Lib.rand(ui.Text.cities.length);
    clip.cityName.text = ui.Text.cities[cityIndex];
    var last = clip.cityName.text.length;
    clip.cityName.setSelection(0, last);
    clip.stage.focus = clip.cityName;

    clip.widthText.setSelection(0, 0);
    clip.widthText.text = "50";
    clip.widthText.setSelection(0, last);

    clip.heightText.setSelection(0, 0);
    clip.heightText.text = "50";
    clip.heightText.setSelection(0, last);
    updateDifficulty();
  }

  override public function hide() : Void
  {
    clip.visible = false;
  }

  function updateDifficulty() : Void
  {
    clip.difficulty.barText.text
      = logic.GameSettings.getDifficultyNameS(difficulty);
    var num = difficulty;
    var denom = logic.GameSettings.getDifficultyLimit() - 1;
    clip.difficulty.bar.width = num / denom * Option.statusBarSize;
    if (difficulty == 0)
    {
      buttons.setGhosted(clip.difficultyDown);
    }
    else
    {
      buttons.setNormal(clip.difficultyDown);
    }
    if (difficulty == logic.GameSettings.getDifficultyLimit() - 1)
    {
      buttons.setGhosted(clip.difficultyUp);
    }
    else
    {
      buttons.setNormal(clip.difficultyUp);
    }
  }

  function click(choice : Int) : Void
  {
    if (choice == 0)
    {
      if (difficulty > 1)
      {
        --difficulty;
        ui.Util.success();
      }
      else
      {
        ui.Util.failure();
      }
      updateDifficulty();
    }
    else if (choice == 1)
    {
      if (difficulty < logic.GameSettings.getDifficultyLimit() - 1)
      {
        ++difficulty;
        ui.Util.success();
      }
      else
      {
        ui.Util.failure();
      }
      updateDifficulty();
    }
    else if (choice == 2)
    {
      ui.Util.success();
      var optWidth = Std.parseInt(clip.widthText.text);
      var width = 0;
      if (optWidth != null)
      {
        width = optWidth;
      }
      var optHeight = Std.parseInt(clip.heightText.text);
      var height = 0;
      if (optHeight != null)
      {
        height = optHeight;
      }
      var newSettings = new logic.GameSettings();
      newSettings.beginNewEdit(difficulty, clip.cityName.text,
                               new Point(width, height));
      Main.menu.setSettings(newSettings);
      Main.menu.changeState(MainMenu.EDIT_WAIT);
    }
    else if (choice == 3)
    {
      ui.Util.success();
      Main.menu.changeState(MainMenu.EDIT_SELECT);
    }
  }

  var difficulty : Int;
  var clip : MainEditClip;
  var buttons : ui.ButtonList;
}
