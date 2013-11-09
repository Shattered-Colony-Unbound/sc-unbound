package ui.menu;

class MainMenu
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      l : ui.LayoutMain) : Void
  {
    rateState = WIN;
    rateFun = "";
    rateDifficulty = "";
    Main.key.addHandler(hotkey);

    var minSize = ui.Util.minSize(l.screenSize);

    oldState = START;
    state = START;
    menus = [];
    menus.push(new MainStart(parent, minSize));
    menus.push(new MainDifficulty(parent, minSize));
    menus.push(new MainName(parent, minSize));
    menus.push(new MainCredits(parent, minSize));
    menus.push(new MainWin(parent, minSize));
    menus.push(new MainLose(parent, minSize));
    menus.push(new MainTutorial(parent, minSize));
    menus.push(new CenterOptions(parent, minSize, false));
    menus.push(new CenterPedia(parent, minSize, ui.Text.playPediaRoot, false));
    menus.push(new WaitMenu(parent, minSize, WaitMenu.GENERATE_MAP));
    menus.push(new WaitMenu(parent, minSize, WaitMenu.LOAD_GAME));
    menus.push(new WaitMenu(parent, minSize, WaitMenu.EDIT_MAP));
    menus.push(new MainEdit(parent, minSize));
    menus.push(new CenterPedia(parent, minSize, ui.Text.editPediaRoot, false));
    menus.push(new MainPlay(parent, minSize));
    menus.push(new StoryMenu(parent, minSize, StoryMenu.BRIEFING));
    menus.push(new StoryMenu(parent, minSize, StoryMenu.WIN));
    menus.push(new StoryMenu(parent, minSize, StoryMenu.LOSE));
    menus.push(new MainDownloadMap(parent, minSize));
    menus.push(new WaitMenu(parent, minSize, WaitMenu.DOWNLOAD_MAP));
    menus.push(new MainEditSelect(parent, minSize));
    menus.push(new MainFail(parent, minSize, false));
    menus.push(new MainPasteMap(parent, minSize));
    menus.push(new MainRate(parent, minSize));
    menus.push(new WaitMenu(parent, minSize, WaitMenu.RATE_MAP));
    menus.push(new MainCampaign(parent, minSize));
    menus.push(new MainBrowse(parent, minSize));
    menus.push(new WaitMenu(parent, minSize, WaitMenu.BROWSE));
    menus[state].show();
    settings = new logic.GameSettings();
  }

  public function cleanup() : Void
  {
    for (menu in menus)
    {
      menu.cleanup();
    }
    menus = null;
    Main.key.clearHandlers();
  }

  public function resize(l : ui.LayoutMain) : Void
  {
    var minSize = ui.Util.minSize(l.screenSize);
    for (menu in menus)
    {
      menu.resize(minSize);
    }
  }

  public function hotkey(ch : String, code : Int) : Bool
  {
    return menus[state].hotkey(ch, code);
  }

  public function changeState(newState : Int) : Void
  {
    oldState = state;
    menus[state].hide();
    menus[newState].show();
    state = newState;
  }

  public function revertState() : Void
  {
    changeState(oldState);
  }

  public function setSettings(newSettings : logic.GameSettings) : Void
  {
    settings = newSettings;
  }

  public function getSettings() : logic.GameSettings
  {
    return settings;
  }

  var oldState : Int;
  var state : Int;
  var menus : Array<MenuRoot>;
  var settings : logic.GameSettings;
  public var rateState : Int;
  public var rateFun : String;
  public var rateDifficulty : String;

  public static var START = 0;
  public static var DIFFICULTY = 1;
  public static var NAME = 2;
  public static var CREDITS = 3;
  public static var WIN = 4;
  public static var LOSE = 5;
  public static var TUTORIAL = 6;
  public static var OPTIONS = 7;
  public static var PEDIA = 8;
  public static var GENERATE_MAP = 9;
  public static var LOAD_WAIT = 10;
  public static var EDIT_WAIT = 11;
  public static var EDIT = 12;
  public static var EDIT_PEDIA = 13;
  public static var PLAY = 14;
  public static var STORY_BRIEFING = 15;
  public static var STORY_WIN = 16;
  public static var STORY_LOSE = 17;
  public static var DOWNLOAD_MAP = 18;
  public static var DOWNLOAD_MAP_WAIT = 19;
  public static var EDIT_SELECT = 20;
  public static var LOAD_MAP_FAIL = 21;
  public static var PASTE_MAP = 22;
  public static var RATE_MAP = 23;
  public static var RATE_MAP_WAIT = 24;
  public static var CAMPAIGN = 25;
  public static var BROWSE = 26;
  public static var BROWSE_WAIT = 27;
}
