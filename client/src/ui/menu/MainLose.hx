// Menu displayed on defeat
package ui.menu;

class MainLose extends MenuRoot
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      screenSize : Point) : Void
  {
    super();
    clip = new MainLoseClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;

    clip.rateLabel.mouseEnabled = false;
    buttons = new ui.ButtonList(click, null, [clip.replay, clip.loadGame,
                                              clip.retryMap, clip.mainMenu,
                                              clip.rateButton]);

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
    ui.Util.alignRight(clip.city, size);
    ui.Util.alignRight(clip.difficulty, size);
    ui.Util.alignRight(clip.time, size);
    ui.Util.alignBottom(clip.rateButton, size);
    ui.Util.alignLabel(clip.rateButton, clip.rateLabel);
  }

  override public function show() : Void
  {
    clip.visible = true;
    if (Main.canLoad())
    {
      buttons.setNormal(clip.loadGame);
    }
    else
    {
      buttons.setGhosted(clip.loadGame);
    }
    clip.city.text = Main.menu.getSettings().getCityName();
    clip.difficulty.text = Main.menu.getSettings().getDifficultyName();
    var time = Main.menu.getSettings().getPlayTime();
    clip.time.text = new ui.Time(time).toString();
    if (Main.menu.getSettings().getKey() == null)
    {
      clip.rateButton.visible = false;
      clip.rateLabel.visible = false;
    }
    else
    {
      clip.rateButton.visible = true;
      clip.rateLabel.visible = true;
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
      Main.beginReplay();
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
      Main.menu.changeState(MainMenu.GENERATE_MAP);
    }
    else if (choice == 3)
    {
      ui.Util.success();
      Main.menu.setSettings(new logic.GameSettings());
      Main.menu.changeState(MainMenu.START);
    }
    else if (choice == 4)
    {
      Main.menu.rateState = MainMenu.LOSE;
      Main.menu.changeState(MainMenu.RATE_MAP);
    }
  }

  var clip : MainLoseClip;
  var buttons : ui.ButtonList;
}
