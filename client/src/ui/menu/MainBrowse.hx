package ui.menu;

class MainBrowse extends MenuRoot
{
  public static var FUN = 0;
  public static var RECENT = 1;
  public static var HARD = 2;
  public static var MEDIUM = 3;
  public static var EASY = 4;
  public static var TYPE_COUNT = 5;

  public static var typeToString = ["fun", "recent", "hard", "medium", "easy"];
  public static var typeToButton = ["Most Fun", "Most Recent", "Hardest",
                                    "Moderate", "Easiest"];

  public function new(parent : flash.display.DisplayObjectContainer,
                      screenSize : Point) : Void
  {
    super();
    clip = new MainBrowseClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;
    clip.sortText.mouseEnabled = false;
    buttons = new ui.ButtonList(click, null, [clip.level1, clip.level2,
                                              clip.level3, clip.level4,
                                              clip.level5, clip.prev,
                                              clip.next, clip.sort,
                                              clip.back]);

    levels = [clip.level1, clip.level2, clip.level3, clip.level4, clip.level5];
    names = [clip.name1, clip.name2, clip.name3, clip.name4, clip.name5];
    cursor = 0;
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
      click(8);
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
    parse();
    cursor = 0;
    update();
  }

  override public function hide() : Void
  {
    clip.visible = false;
  }

  function click(choice : Int) : Void
  {
    if (choice == 5)
    {
      if (cursor > 0)
      {
        cursor -= cursorLength;
        update();
      }
      else if (start > 0)
      {
        start -= LOAD_STEP;
        Main.menu.changeState(MainMenu.BROWSE_WAIT);
      }
    }
    else if (choice == 6)
    {
      if (cursor < maxCursor - cursorLength)
      {
        cursor += cursorLength;
        update();
      }
      else if (cursor == maxCursor - cursorLength)
      {
        start += maxCursor;
        Main.menu.changeState(MainMenu.BROWSE_WAIT);
      }
    }
    else if (choice == 7)
    {
      type = (type + 1) % TYPE_COUNT;
      start = 0;
      Main.menu.changeState(MainMenu.BROWSE_WAIT);
    }
    else if (choice == 8)
    {
      Main.menu.changeState(MainMenu.PLAY);
    }
    else
    {
      var key = dbKeys[cursor + choice];
      Main.menu.rateState = MainMenu.BROWSE;
      Main.menu.getSettings().setUrl("http://auriga-squad.appspot.com/get/"
                                     + key);
      Main.menu.changeState(MainMenu.DOWNLOAD_MAP_WAIT);
    }
  }

  function update() : Void
  {
    if (cursor == 0 && start == 0)
    {
      buttons.setGhosted(clip.prev);
    }
    else
    {
      buttons.setNormal(clip.prev);
    }
    if (cursor + cursorLength > maxCursor)
    {
      buttons.setGhosted(clip.next);
    }
    else
    {
      buttons.setNormal(clip.next);
    }
    clip.sortText.text = typeToButton[type];
    var active = Math.floor(Math.min(cursorLength, maxCursor - cursor));
    clip.page.text = Std.string(start + cursor + 1) + " - "
      + Std.string(start + cursor + active);
    for (i in 0...active)
    {
      names[i].visible = true;
      levels[i].visible = true;
      names[i].text = dbNames[i + cursor];
    }
    for (i in active...cursorLength)
    {
      names[i].visible = false;
      levels[i].visible = false;
    }
  }

  function parse() : Void
  {
    dbNames = [];
    dbKeys = [];
    var data = new flash.net.URLVariables(dbValues);
    var size = Reflect.field(data, "size");
    for (i in 0...size)
    {
      dbNames.push(Reflect.field(data, "name" + Std.string(i)));
      dbKeys.push(Reflect.field(data, "key" + Std.string(i)));
    }
    maxCursor = size;
  }

  var clip : MainBrowseClip;
  var buttons : ui.ButtonList;
  var names : Array<flash.text.TextField>;
  var levels : Array<flash.display.MovieClip>;
  var cursor : Int;
  var maxCursor : Int;
  var dbNames : Array<String>;
  var dbKeys : Array<String>;

  public static var type : Int = FUN;
  public static var start : Int = 0;
  public static var dbValues : String;

  public static var LOAD_STEP = 5;
  static var cursorLength = 5;
}
