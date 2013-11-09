// Menu displayed on victory
package ui.menu;

class MainWin extends MenuRoot
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      screenSize : Point) : Void
  {
    super();
    clip = new MainWinClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;

    clip.rateLabel.mouseEnabled = false;
    buttons = new ui.ButtonList(click, null, [clip.replay, clip.mainMenu,
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

    clip.mb2.x = size.x;
    clip.mb2.y = size.y;

  }

  override public function show() : Void
  {
    clip.visible = true;
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

  function hintText() : String
  {
    var result = "";
    var difficulty = Main.menu.getSettings().getDifficulty();
    mapgen.Util.seed(Main.menu.getSettings().getNormalName());
    if (difficulty == 1)
    {
      result = ui.Text.easter[0];
    }
    else if (difficulty == 2)
    {
      result = ui.Text.easter[1];
    }
    else if (difficulty >= 3)
    {
      var choice = mapgen.Util.rand(ui.Text.easter.length - 2);
      result = ui.Text.easter[choice + 2];
    }
    return result;
  }

  function click(choice : Int) : Void
  {
    ui.Util.success();
    if (choice == 0)
    {
      Main.beginReplay();
    }
    else if (choice == 1)
    {
      var next = MainMenu.START;
      if (Main.menu.getSettings().getCampaign() != -1)
      {
        next = MainMenu.CAMPAIGN;
      }
      Main.menu.setSettings(new logic.GameSettings());
      Main.menu.changeState(next);
    }
    else if (choice == 2)
    {
      Main.menu.rateState = MainMenu.WIN;
      Main.menu.changeState(MainMenu.RATE_MAP);
    }
  }

  var clip : MainWinClip;
  var buttons : ui.ButtonList;
}
