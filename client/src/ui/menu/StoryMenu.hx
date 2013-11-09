package ui.menu;

class StoryMenu extends MenuRoot
{
  public static var WIN = 0;
  public static var LOSE = 1;
  public static var BRIEFING = 2;
  public static var CENTER = 3;

  public function new(parent : flash.display.DisplayObjectContainer,
                      screenSize : Point, newContext : Int) : Void
  {
    super();
    context = newContext;
    clip = new StoryMenuClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;

    buttons = new ui.ButtonList(click, null, [clip.okButton]);

    clip.briefing.multiline = true;
    clip.briefing.wordWrap = true;
    clip.briefing.autoSize = flash.text.TextFieldAutoSize.NONE;

    resize(screenSize);
  }

  override public function cleanup() : Void
  {
    clip.removeEventListener(flash.events.Event.ENTER_FRAME,
                             componentUpdate);
    buttons.cleanup();
    clip.parent.removeChild(clip);
    clip = null;
  }

  override public function resize(size : Point) : Void
  {
    ui.Util.centerHorizontally(clip.okButton, size);
    ui.Util.alignBottom(clip.okButton, size);
    ui.Util.scaleToFit(clip.background, size);
    ui.Util.scaleToFit(clip.splash, size);
    ui.Util.scaleToFit(clip.splashWin, size);
    ui.Util.scaleToFit(clip.splashLose, size);
    var width = size.x - 60;
    if (width > 600)
    {
      width = 600;
    }
    clip.briefing.x = (size.x - width) / 2 - 10;
    clip.briefing.width = width;
    clip.briefing.height = size.y - 140;
    clip.scrollBar.x = clip.briefing.x + clip.briefing.width + 5;
    clip.scrollBar.height = size.y - 140;
    clip.scrollBar.update();

    clip.addEventListener(flash.events.Event.ENTER_FRAME,
                          componentUpdate);
  }

  override public function hotkey(ch : String, code : Int) : Bool
  {
    var used = true;
    if (code == Keyboard.escapeCode || code == Keyboard.enterCode)
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
    clip.splash.visible = false;
    clip.splashWin.visible = false;
    clip.splashLose.visible = false;
    if (context == WIN)
    {
      MainCampaign.setComplete(Main.menu.getSettings().getCampaign());
      clip.splashWin.visible = true;
      clip.briefing.text = Main.menu.getSettings().getWinText();
    }
    else if (context == LOSE)
    {
      clip.splashLose.visible = true;
      clip.briefing.text = Main.menu.getSettings().getLoseText();
    }
    else if (context == BRIEFING)
    {
      clip.splash.visible = true;
      clip.briefing.text = Main.menu.getSettings().getBriefingText();
    }
    else if (context == CENTER)
    {
      clip.background.visible = false;
      clip.briefing.text = Game.settings.getBriefingText();
    }
    clip.scrollBar.update();

    clip.addEventListener(flash.events.Event.ENTER_FRAME,
                          componentUpdate);
  }

  override public function hide() : Void
  {
    clip.visible = false;
  }

  function click(choice : Int) : Void
  {
    ui.Util.success();
    if (context == WIN)
    {
      if (Main.menu.getSettings().isEditor())
      {
        Main.menu.changeState(MainMenu.GENERATE_MAP);
      }
      else
      {
        Main.menu.changeState(MainMenu.WIN);
      }
    }
    else if (context == LOSE)
    {
      if (Main.menu.getSettings().isEditor())
      {
        Main.menu.changeState(MainMenu.GENERATE_MAP);
      }
      else
      {
        Main.menu.changeState(MainMenu.LOSE);
      }
    }
    else if (context == BRIEFING)
    {
      Main.menu.changeState(MainMenu.GENERATE_MAP);
    }
    else if (context == CENTER)
    {
      Game.view.centerMenu.revertState();
    }
  }

  function componentUpdate(event : flash.events.Event) : Void
  {
    clip.scrollBar.update();
    clip.removeEventListener(flash.events.Event.ENTER_FRAME,
                             componentUpdate);
  }

  var clip : StoryMenuClip;
  var buttons : ui.ButtonList;
  var context : Int;
}
