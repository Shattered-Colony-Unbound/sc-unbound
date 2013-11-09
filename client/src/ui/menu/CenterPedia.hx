package ui.menu;

class CenterPedia extends MenuRoot
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      screenSize : Point, newRoot : String,
                      newIsCenter : Bool) : Void
  {
    super();
    root = newRoot;
    isCenter = newIsCenter;
    clip = new PediaMenuClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;

    buttons = new ui.ButtonList(click, null, [clip.back, clip.up, clip.forward,
                                              clip.returnToMenu]);
    clip.entry.multiline = true;
    clip.entry.wordWrap = true;
    clip.entry.autoSize = flash.text.TextFieldAutoSize.NONE;
    clip.entry.addEventListener(flash.events.TextEvent.LINK, link);

    var style = new flash.text.StyleSheet();
    style.parseCSS(ui.Text.pediaStyleSheet);
    clip.entry.styleSheet = style;

    history = [new Bookmark(root, 1)];
    current = 0;
    moveCursor(0);

    if (isCenter)
    {
      clip.background.visible = false;
      clip.splash.visible = false;
    }

    resize(screenSize);
  }

  override public function cleanup() : Void
  {
    clip.entry.removeEventListener(flash.events.TextEvent.LINK, link);
    clip.removeEventListener(flash.events.Event.ENTER_FRAME,
                             componentUpdate);
    buttons.cleanup();
    clip.parent.removeChild(clip);
    clip = null;
  }

  override public function resize(size : Point) : Void
  {
    ui.Util.centerHorizontally(clip.returnToMenu, size);
    ui.Util.alignBottom(clip.returnToMenu, size);
    ui.Util.scaleToFit(clip.background, size);
    ui.Util.scaleToFit(clip.splash, size);
    var width = size.x - 60;
    if (width > 600)
    {
      width = 600;
    }
    clip.entry.x = (size.x - width) / 2 - 10;
    clip.entry.width = width;
    clip.entry.height = size.y - 200;
    clip.scrollBar.x = clip.entry.x + clip.entry.width + 5;
    clip.scrollBar.height = size.y - 200;
    clip.scrollBar.update();

    clip.addEventListener(flash.events.Event.ENTER_FRAME,
                          componentUpdate);
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
  }

  override public function hide() : Void
  {
    clip.visible = false;
  }

  override public function showTutorial() : Void
  {
    show();
  }

  function click(choice : Int) : Void
  {
    var didSucceed = true;
    if (choice == 0)
    {
      didSucceed = moveCursor(-1);
    }
    else if (choice == 1)
    {
      if (history[current].name == root)
      {
        exitPedia();
      }
      else
      {
        visitPage(root);
      }
    }
    else if (choice == 2)
    {
      didSucceed = moveCursor(1);
    }
    else if (choice == 3)
    {
      exitPedia();
    }
    if (didSucceed)
    {
      ui.Util.success();
    }
    else
    {
      ui.Util.failure();
    }
  }

  function exitPedia() : Void
  {
    if (isCenter)
    {
      Game.view.centerMenu.revertState();
    }
    else
    {
      Main.menu.revertState();
    }
  }

  function link(event : flash.events.TextEvent) : Void
  {
    ui.Util.success();
    visitPage(event.text);
  }

  function componentUpdate(event : flash.events.Event) : Void
  {
    clip.scrollBar.update();
    clip.removeEventListener(flash.events.Event.ENTER_FRAME,
                             componentUpdate);
  }

  override public function visitPage(key : String) : Void
  {
    var start = current - maxHistory + 1;
    if (start < 0)
    {
      start = 0;
    }
    var end = Math.floor(Math.min(current + 1, start + maxHistory));
    history = history.slice(start, end);
    history.push(new Bookmark(key, 1));
    current = current - start;
    moveCursor(1);
  }

  function moveCursor(delta : Int) : Bool
  {
    var result = true;
    if (current + delta >= 0 && current + delta < history.length)
    {
      history[current].pos = clip.entry.scrollV;

      current = current + delta;
      clip.entry.htmlText = hash.lookup(history[current].name);
      clip.entry.scrollV = history[current].pos;
      clip.scrollBar.update();
    }
    else
    {
      result = false;
    }
    if (current == 0)
    {
      buttons.setGhosted(clip.back);
    }
    else
    {
      buttons.setNormal(clip.back);
    }
    if (current == history.length - 1)
    {
      buttons.setGhosted(clip.forward);
    }
    else
    {
      buttons.setNormal(clip.forward);
    }
    return result;
  }

  var clip : PediaMenuClip;
  var buttons : ui.ButtonList;
  var root : String;
  var isCenter : Bool;

  var history : Array<Bookmark>;
  var current : Int;

  static var hash = new PediaHash();
  static var maxHistory = 20;
}
