package ui.menu;

class MainCampaign extends MenuRoot
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      screenSize : Point) : Void
  {
    super();
    clip = new MainCampaignClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;
    buttons = new ui.ButtonList(click, null, [clip.level1, clip.level2,
                                              clip.level3, clip.level4,
                                              clip.level5, clip.level6,
                                              clip.level7, clip.back]);
    levels = [clip.level1, clip.level2,
              clip.level3, clip.level4,
              clip.level5, clip.level6,
              clip.level7];
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
      click(7);
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
    var displayNext = true;
    var complete = getComplete();
    for (i in 0...(complete.length))
    {
      var current = levels[i];
      if (complete[i] == 1)
      {
        buttons.setGhosted(current);
      }
      else if (displayNext)
      {
        buttons.setGreen(current);
        displayNext = false;
      }
      else
      {
        buttons.setNormal(current);
      }
    }
  }

  override public function hide() : Void
  {
    clip.visible = false;
  }

  public static function getComplete() : Array<Int>
  {
    var disk = Main.gameDisk;
    var input = disk.data.campaign;
    var result : Array<Int> = [];
    if (input == null)
    {
      result = [0, 0, 0, 0, 0,
                0, 0];
      disk.data.campaign = result;
    }
    else
    {
      result = Load.loadArrayInt(input);
    }
    return result;
  }

  public static function setComplete(level : Int) : Void
  {
    var disk = Main.gameDisk;
    var complete = getComplete();
    if (level >= 0 && level < complete.length)
    {
      complete[level] = 1;
    }
    disk.data.campaign = complete;
//    disk.flush(1000000);
  }

  function click(choice : Int) : Void
  {
    ui.Util.success();
    if (choice == 7)
    {
      Main.menu.changeState(MainMenu.PLAY);
    }
    else
    {
      Main.menu.rateState = MainMenu.CAMPAIGN;
      WaitMenu.loadMap(ui.Text.levels[choice]);
      Main.menu.getSettings().setCampaign(choice);
    }
  }

  var clip : MainCampaignClip;
  var buttons : ui.ButtonList;
  var levels : Array<flash.display.MovieClip>;
}
