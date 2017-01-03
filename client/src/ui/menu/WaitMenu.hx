package ui.menu;

class WaitMenu extends MenuRoot
{
  public static var GENERATE_MAP = 0;
  public static var LOAD_GAME = 1;
  public static var SAVE_GAME = 2;
  public static var EDIT_MAP = 3;
  public static var DOWNLOAD_MAP = 4;
  public static var UPLOAD_MAP = 5;
  public static var RATE_MAP = 6;
  public static var BROWSE = 7;

  public function new(parent : flash.display.DisplayObjectContainer,
                      size : Point, newUsage : Int) : Void
  {
    super();
    usage = newUsage;
    clip = new WaitMenuClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;
    clip.message.text = waitText[usage];
    frame = 0;

    loader = new flash.net.URLLoader();
    loader.dataFormat = flash.net.URLLoaderDataFormat.VARIABLES;
    loader.addEventListener(flash.events.HTTPStatusEvent.HTTP_STATUS,
                            status);
    loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR,
                            ioError);
    loader.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR,
                            securityError);
    loader.addEventListener(flash.events.Event.COMPLETE,
                            complete);
    resize(size);
  }

  override public function cleanup() : Void
  {
    loader.removeEventListener(flash.events.HTTPStatusEvent.HTTP_STATUS,
                               status);
    loader.removeEventListener(flash.events.IOErrorEvent.IO_ERROR,
                               ioError);
    loader.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR,
                               securityError);
    loader.removeEventListener(flash.events.Event.COMPLETE,
                               complete);
    clip.removeEventListener(flash.events.Event.ENTER_FRAME, enterFrame);
    clip.parent.removeChild(clip);
    clip = null;
  }

  override public function resize(size : Point) : Void
  {
    ui.Util.scaleToFit(clip.background, size);
    ui.Util.alignBottom(clip.message, size);
    ui.Util.centerHorizontally(clip.message, size);
  }

  override public function show() : Void
  {
    clip.visible = true;
    clip.addEventListener(flash.events.Event.ENTER_FRAME, enterFrame);
    frame = frameWait;
  }

  override public function hide() : Void
  {
    clip.visible = false;
    clip.removeEventListener(flash.events.Event.ENTER_FRAME, enterFrame);
  }

  function enterFrame(event : flash.events.Event) : Void
  {
    --frame;
    if (frame == 0)
    {
      var request = new flash.net.URLRequest();
      if (usage == GENERATE_MAP)
      {
        Main.beginPlay();
      }
      else if (usage == LOAD_GAME)
      {
        Main.loadGame();
      }
      else if (usage == SAVE_GAME)
      {
        Game.saveGame();
        Game.view.centerMenu.changeState(CenterMenu.SYSTEM);
      }
      else if (usage == EDIT_MAP)
      {
        Main.beginPlay();
      }
      else if (usage == DOWNLOAD_MAP)
      {
        Main.error = "Map Download Failed:\n";
        request.url = Main.menu.getSettings().getUrl();
        loader.load(request);
      }
      else if (usage == UPLOAD_MAP)
      {
        var secret = 'men judge generally more by the eye than by the hand, because it belongs to everybody to see you, to few to come in touch with you.';
        Main.error = "Map Upload Failed:\n";
        request.method = flash.net.URLRequestMethod.POST;
        var args = new flash.net.URLVariables();
        var mapString = Game.settings.saveMap();
        args.name = Game.settings.getCityName();
        args.map = mapString;
        args.verify = haxe.crypto.Md5.encode(secret + mapString);
        request.data = args;
        request.url = "http://auriga-squad.appspot.com/upload";
//        request.url = "http://localhost:8080/upload";
        loader.load(request);
      }
      else if (usage == RATE_MAP)
      {
        Main.error = "Map Rate Failed:\n";
        request.method = flash.net.URLRequestMethod.POST;
        var key = Main.menu.getSettings().getKey();
        var args = new flash.net.URLVariables();
        args.fun = Main.menu.rateFun;
        args.difficulty = Main.menu.rateDifficulty;
        request.data = args;
        request.url = "http://auriga-squad.appspot.com/rate/" + key;
        loader.load(request);
      }
      else if (usage == BROWSE)
      {
        Main.error = "Download Map List Failed:\n";
        request.method = flash.net.URLRequestMethod.POST;
        var args = new flash.net.URLVariables();
        args.type = MainBrowse.typeToString[MainBrowse.type];
        args.start = Std.string(MainBrowse.start);
        args.count = Std.string(MainBrowse.LOAD_STEP);
        request.data = args;
        request.url = "http://auriga-squad.appspot.com/find";
        loader.load(request);
      }
    }
  }

  function status(event : flash.events.HTTPStatusEvent) : Void
  {
    if (event.status != 200)
    {
      Main.error += "HTML Status: " + Std.string(event.status) + "\n";
    }
  }

  function ioError(event : flash.events.IOErrorEvent) : Void
  {
    Main.error += "Could not access network (IO Error)\n";
    errorSwitch(usage);
  }

  function securityError(event : flash.events.SecurityErrorEvent) : Void
  {
    Main.error += "Could not access network (Security Error)\n";
    errorSwitch(usage);
  }

  function complete(event : flash.events.Event) : Void
  {
    var response : flash.net.URLVariables = loader.data;
    var error = response.error;
    var result = response.result;
    if (error != null)
    {
      Main.error += "Server Error: " + error + "\n";
      errorSwitch(usage);
    }
    else if (usage == RATE_MAP)
    {
      Main.menu.changeState(Main.menu.rateState);
    }
    else if (result == null)
    {
      Main.error += "No Result From Server\n";
    }
    else if (usage == DOWNLOAD_MAP)
    {
      loadMap(result, response.key);
    }
    else if (usage == UPLOAD_MAP)
    {
      Game.settings.setUrl(result);
      Game.view.centerMenu.changeState(CenterMenu.UPLOAD_MAP);
    }
    else if (usage == BROWSE)
    {
      MainBrowse.dbValues = result;
      Main.menu.changeState(MainMenu.BROWSE);
    }
  }

  static function errorSwitch(usage : Int) : Void
  {
    if (usage == DOWNLOAD_MAP || usage == RATE_MAP || usage == BROWSE)
    {
      Main.menu.changeState(MainMenu.LOAD_MAP_FAIL);
    }
    else if (usage == UPLOAD_MAP)
    {
      Game.view.centerMenu.changeState(CenterMenu.SAVE_MAP_FAIL);
    }
  }

  public static function loadMap(map : String, ? key : String) : Void
  {
    try
    {
      if (Main.menu.getSettings().isEditor())
      {
        Main.menu.setSettings(new logic.GameSettings());
        Main.menu.getSettings().beginLoadEdit(map, "", "");
        Main.menu.changeState(MainMenu.EDIT_WAIT);
      }
      else
      {
        Main.menu.setSettings(new logic.GameSettings());
        Main.menu.getSettings().setKey(key);
        Main.menu.getSettings().beginNewCustom(map);
        Main.menu.changeState(MainMenu.STORY_BRIEFING);
      }
    }
    catch (e : flash.errors.Error)
    {
      Main.error += "Failed to load map: " + e.message + "\n";
      errorSwitch(DOWNLOAD_MAP);
    }
  }

  var usage : Int;
  var clip : WaitMenuClip;
  var frame : Int;
  var loader : flash.net.URLLoader;

  static var frameWait = 2;

  static var waitText = [ui.Text.waitGenerateMap,
                         ui.Text.waitLoadGame,
                         ui.Text.waitSaveGame,
                         ui.Text.waitEditMap,
                         ui.Text.waitDownloadMap,
                         ui.Text.waitUploadMap,
                         ui.Text.waitRateMap,
                         ui.Text.waitBrowse];
}
