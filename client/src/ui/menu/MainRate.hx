package ui.menu;

class MainRate extends MenuRoot
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      screenSize : Point) : Void
  {
    super();
    difficulty = 1;
    fun = 1;
    clip = new MainRateClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;

    buttons = new ui.ButtonList(click, null,
                                [clip.back, clip.submitButton,
                                 clip.difficultyDown, clip.difficultyUp,
                                 clip.funDown, clip.funUp]);
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
    difficulty = 1;
    fun = 1;
    updateDifficulty();
    updateFun();
  }

  override public function hide() : Void
  {
    clip.visible = false;
  }

  function updateDifficulty() : Void
  {
    clip.difficulty.barText.text = difficultyRatings[difficulty];
    var num = difficulty;
    var denom = 2;
    clip.difficulty.bar.width = num / denom * Option.statusBarSize;
    if (difficulty == 0)
    {
      buttons.setGhosted(clip.difficultyDown);
    }
    else
    {
      buttons.setNormal(clip.difficultyDown);
    }
    if (difficulty == 2)
    {
      buttons.setGhosted(clip.difficultyUp);
    }
    else
    {
      buttons.setNormal(clip.difficultyUp);
    }
  }

  function updateFun() : Void
  {
    clip.fun.barText.text = funRatings[fun];
    var num = fun;
    var denom = 2;
    clip.fun.bar.width = num / denom * Option.statusBarSize;
    if (fun == 0)
    {
      buttons.setGhosted(clip.funDown);
    }
    else
    {
      buttons.setNormal(clip.funDown);
    }
    if (fun == 2)
    {
      buttons.setGhosted(clip.funUp);
    }
    else
    {
      buttons.setNormal(clip.funUp);
    }
  }

  function click(choice : Int) : Void
  {
    if (choice == 0)
    {
      Main.menu.revertState();
    }
    else if (choice == 1)
    {
      Main.menu.rateFun = funLabels[fun];
      Main.menu.rateDifficulty = difficultyLabels[difficulty];
      Main.menu.changeState(MainMenu.RATE_MAP_WAIT);
    }
    else if (choice == 2)
    {
      if (difficulty > 0)
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
    else if (choice == 3)
    {
      if (difficulty < 2)
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
    else if (choice == 4)
    {
      if (fun > 0)
      {
        --fun;
        ui.Util.success();
      }
      else
      {
        ui.Util.failure();
      }
      updateFun();
    }
    else if (choice == 5)
    {
      if (fun < 2)
      {
        ++fun;
        ui.Util.success();
      }
      else
      {
        ui.Util.failure();
      }
      updateFun();
    }
  }

  var clip : MainRateClip;
  var buttons : ui.ButtonList;
  var difficulty : Int;
  var fun : Int;

  static var funRatings = [ui.Text.rateBad, ui.Text.rateOk, ui.Text.rateGood];
  static var funLabels = ["bad", "ok", "good"];
  static var difficultyRatings = [ui.Text.rateEasy, ui.Text.rateMedium,
                                  ui.Text.rateHard];
  static var difficultyLabels = ["easy", "medium", "hard"];
}
