package ui.menu;

class CenterMenu
{
  public function new() : Void
  {
  }

  public function init(parent : flash.display.DisplayObjectContainer,
                       l : ui.LayoutGame) : Void
  {
    backdrop = new flash.display.Sprite();
    parent.addChild(backdrop);
    backdrop.visible = false;
    backdrop.mouseEnabled = true;
    backdrop.useHandCursor = false;
    state = NONE;
    oldState = NONE;
    var minSize = ui.Util.minSize(l.screenSize);
    var root = ui.Text.playPediaRoot;
    if (Game.settings.isEditor())
    {
      root = ui.Text.editPediaRoot;
    }
    menus = [];
    menus.push(new MenuRoot());
    menus.push(new CenterSystem(parent, minSize));
    menus.push(new CenterOptions(parent, minSize, true));
    menus.push(new CenterPedia(parent, minSize, root, true));
    menus.push(new WaitMenu(parent, minSize, WaitMenu.SAVE_GAME));
    menus.push(new StoryMenu(parent, minSize, StoryMenu.CENTER));
    menus.push(new MainFail(parent, minSize, true));
    menus.push(new SaveMapMenu(parent, minSize));
    menus.push(new WaitMenu(parent, minSize, WaitMenu.UPLOAD_MAP));
    menus.push(new UploadMapMenu(parent, minSize));

    drawBackdrop(l.screenSize);
  }

  public function cleanup() : Void
  {
    for (menu in menus)
    {
      menu.cleanup();
    }
    menus = null;
    backdrop.parent.removeChild(backdrop);
    backdrop = null;

  }

  public function resize(l : ui.LayoutGame) : Void
  {
    drawBackdrop(l.screenSize);
    var minSize = ui.Util.minSize(l.screenSize);
    for (menu in menus)
    {
      menu.resize(minSize);
    }
  }

  function drawBackdrop(size : Point) : Void
  {
    ui.Util.drawBase(backdrop.graphics, new Point(0, 0), size,
                     ui.Color.centerGhost,
                     ui.Color.centerGhostAlpha);
  }

  public function hotkey(ch : String, code : Int) : Bool
  {
    var originalState = state;
    menus[state].hotkey(ch, code);
    return originalState != NONE;
  }

  public function changeState(newState : Int) : Void
  {
    menus[state].hide();
    menus[newState].show();
    oldState = state;
    state = newState;
    Game.view.toolTip.hide();
    if (state == NONE)
    {
      Game.view.sideMenu.enableHover();
      backdrop.visible = false;
      Game.pause.systemResume();
    }
    else
    {
      Game.update.changeSelect(null);
      Game.view.sideMenu.disableHover();
      backdrop.visible = true;
      Game.pause.systemPause();
    }
  }

  public function revertState() : Void
  {
    changeState(oldState);
  }

  public function systemTutorial() : Void
  {
    changeState(SYSTEM);
    menus[state].showTutorial();
  }

  public function lookup(ref : String) : Void
  {
    changeState(PEDIA);
    menus[PEDIA].visitPage(ref);
  }

  var backdrop : flash.display.Sprite;
  var state : Int;
  var oldState : Int;
  var menus : Array<MenuRoot>;

  public static var NONE = 0;
  public static var SYSTEM = 1;
  public static var OPTIONS = 2;
  public static var PEDIA = 3;
  public static var SAVE_WAIT = 4;
  public static var BRIEFING = 5;
  public static var SAVE_MAP_FAIL = 6;
  public static var SAVE_MAP = 7;
  public static var UPLOAD_MAP_WAIT = 8;
  public static var UPLOAD_MAP = 9;
}
