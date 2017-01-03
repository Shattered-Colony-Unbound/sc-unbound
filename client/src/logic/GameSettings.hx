package logic;

class GameSettings
{
  public static var NO_EASTER_EGG = 0;
  public static var LONDON = 1;
  public static var MONROEVILLE = 2;
  public static var CUMBERLAND = 3;
  public static var RACCOONCITY = 4;
  public static var FIDDLERSGREEN = 5;
  public static var SALTLAKECITY = 6;
  public static var EASTLOSANGELES = 7;

  public function new()
  {
    difficulty = 0;
    cityName = "";
    playTime = 0;
    customMap = null;
    editor = false;
    testing = false;
    hasEdges = true;
    custom = false;
    size = new Point(0, 0);
    start = new Point(0, 0);
    key = null;
    url = null;
    script = null;
    campaign = -1;
    briefingText = ui.Text.mainIntroText;
    winText = "";
    loseText = "";
    normalize();
  }

  function normalize() : Void
  {
    updateDifficulty();
    updateName();
    updateEasterEgg();
  }

  function updateDifficulty() : Void
  {
    if (cityName.toLowerCase().indexOf("tutorial") != -1)
    {
      difficulty = 0;
    }
    if (! custom && ! editor)
    {
      size = new Point(sizeList[difficulty],
                       sizeList[difficulty]);
    }
    if (size.x < 15)
    {
      size.x = 15;
    }
    if (size.x > 90)
    {
      size.x = 90;
    }
    if (size.y < 15)
    {
      size.y = 15;
    }
    if (size.y > 90)
    {
      size.y = 90;
    }
  }

  function updateName() : Void
  {
    normalName = mapgen.Util.getNormal(cityName, difficulty);
  }

  function updateEasterEgg() : Void
  {
    if (custom)
    {
      easterEgg = NO_EASTER_EGG;
    }
    else if (normalName.indexOf("london") != -1)
    {
      // Fast zombies
      easterEgg = LONDON;
    }
    else if (normalName.indexOf("monroeville") != -1)
    {
      // Lots of malls
      easterEgg = MONROEVILLE;
    }
    else if (normalName.indexOf("cumberland") != -1)
    {
      // Lots of hospitals
      easterEgg = CUMBERLAND;
    }
    else if (normalName.indexOf("raccooncity") != -1)
    {
      // No bridges
      // Lots of special buildings
      easterEgg = RACCOONCITY;
    }
    else if (normalName.indexOf("fiddlersgreen") != -1)
    {
      // No bridges
      // No zombies initially
      // No checks for win condition
      // Zombies come from the water. Survive as long as you can
      // Waves still come as normal (they increase as if they had starting
      //     number of bridges for that level)
      // Timer counts up from 0 rather than down to next wave
      // Timer still pips when close to end
      // Loss screen must show total time
      easterEgg = FIDDLERSGREEN;
    }
    else if (normalName.indexOf("saltlakecity") != -1)
    {
      // Grid streets
      easterEgg = SALTLAKECITY;
    }
    else if (normalName.indexOf("eastlosangeles") != -1)
    {
      // Thriller zombies
      easterEgg = EASTLOSANGELES;
    }
    else
    {
      easterEgg = NO_EASTER_EGG;
    }
    if (easterEgg != NO_EASTER_EGG && Main.kongregate != null)
    {
      Main.kongregate.stats.submit("Easter Egg", 1);
    }
  }

  public function clone() : GameSettings
  {
    var result = new GameSettings();
    result.difficulty = difficulty;
    result.cityName = cityName;
    result.playTime = playTime;
    var map = getMap();
    if (map == null)
    {
      result.customMap = null;
    }
    else
    {
      result.customMap = new flash.utils.ByteArray();
      result.customMap.writeBytes(map);
    }
    result.editor = editor;
    result.testing = testing;
    result.hasEdges = hasEdges;
    result.custom = custom;
    result.size = size.clone();
    result.start = start.clone();
    result.key = key;
    result.url = url;
    result.script = script;
    result.campaign = campaign;
    result.briefingText = briefingText;
    result.winText = winText;
    result.loseText = loseText;
    result.normalize();
    return result;
  }

  public function beginNewEdit(newDifficulty : Int,
                               newCityName : String,
                               newSize : Point) : Void
  {
    difficulty = newDifficulty;
    cityName = newCityName;
    playTime = 0;
    customMap = null;
    editor = true;
    testing = false;
    custom = false;
    size = newSize.clone();
    key = null;
    url = null;
    script = null;
    normalize();
  }

  public function beginLoadEdit(newMap : String, newWinText : String,
                                newLoseText : String) : Void
  {
    playTime = 0;
    editor = true;
    testing = false;
    custom = true;
    winText = newWinText;
    loseText = newLoseText;
    loadMap(newMap);
  }

  public function beginLoadTest(newMap : String)
  {
    playTime = 0;
    editor = false;
    testing = true;
    custom = true;
    loadMap(newMap);
  }

  public function beginNewCustom(newMap : String)
  {
    playTime = 0;
    editor = false;
    testing = false;
    custom = true;
    loadMap(newMap);
  }

  public function beginNewRandom(newDifficulty : Int,
                                 newCityName : String)
  {
    difficulty = newDifficulty;
    cityName = newCityName;
    playTime = 0;
    customMap = null;
    editor = false;
    testing = false;
    custom = false;
    normalize();
  }

  public function getMap() : flash.utils.ByteArray
  {
    if (customMap != null)
    {
      customMap.position = 0;
    }
    return customMap;
  }

  public function setMap(newMap : flash.utils.ByteArray) : Void
  {
    customMap = newMap;
  }

  public function saveMap() : String
  {
    var result = '<map name="' + cityName + '" ';
    result += 'difficulty="' + Std.string(difficulty) + '" ';
    result += 'sizeX="' + Std.string(size.x) + '" ';
    result += 'sizeY="' + Std.string(size.y) + '" ';
    result += 'startX="' + Std.string(start.x) + '" ';
    result += 'startY="' + Std.string(start.y) + '" ';
    result += '>\n';

    if (briefingText != ui.Text.mainIntroText)
    {
      result += "<briefing>\n";
      result += briefingText + "\n";
      result += "</briefing>\n";
    }

    if (customMap != null)
    {
      result += '<terrain>\n';
      result += getCustomMap();
      result += '\n</terrain>\n';
    }
    if (script != null)
    {
      result += script;
    }
    result += "</map>\n";
    return result;
  }

  function getCustomMap() : String
  {
    var result = null;
    if (customMap != null)
    {
      var raw = new flash.utils.ByteArray();
//      raw.writeUTF(cityName);
//      raw.writeByte(difficulty);
//      raw.writeByte(size.x);
//      raw.writeByte(size.y);
//      raw.writeByte(start.x);
//      raw.writeByte(start.y);
      raw.writeBytes(customMap);

//      Lib.trace("Before compression: " + raw.length);
      raw.compress();
//      Lib.trace("After compression: " + raw.length);
      var encoder = new haxe.crypto.BaseCode(baseBytes);
      var encodedBytes = encoder.encodeBytes(haxe.io.Bytes.ofData(raw));
      var encoded = encodedBytes.toString();
      var hash = haxe.crypto.Md5.encode(encoded);
      var oneLine = hash + "." + encoded;
      var lines = [];
      var start = 0;
      var inc = 50;
      while (start < oneLine.length)
      {
        lines.push(oneLine.substr(start, inc));
        start += inc;
      }
      result = lines.join("\n");
    }
    return result;
  }

  public function loadMap(newMap : String) : Void
  {
    if (newMap.indexOf('<') == -1)
    {
      hasEdges = false;
      loadCustomMap(newMap, true);
      script = null;
    }
    else
    {
      var node = new flash.xml.XML(newMap);
      if (node.attribute("name").length() == 0
          || node.attribute("sizeX").length() == 0
          || node.attribute("sizeY").length() == 0
          || node.attribute("startX").length() == 0
          || node.attribute("startY").length() == 0
          || node.attribute("difficulty").length() == 0)
      {
        throw new flash.errors.Error("Could not find required tag.\n"
                                     + "Every map must have: name, sizeX, sizeY, "
                                     + "startX, startY, difficulty");
      }
      cityName = Std.string(node.attribute("name"));
      size = new Point(Std.parseInt(Std.string(node.attribute("sizeX"))),
                       Std.parseInt(Std.string(node.attribute("sizeY"))));
      start = new Point(Std.parseInt(Std.string(node.attribute("startX"))),
                        Std.parseInt(Std.string(node.attribute("startY"))));
      difficulty = Std.parseInt(Std.string(node.attribute("difficulty")));
      var briefList = node.elements("briefing");
      if (briefList.length() > 0)
      {
        briefingText = Std.string(briefList.text());
      }
      else
      {
        briefingText = ui.Text.mainIntroText;
      }
      if (node.elements("terrain").length() > 0)
      {
        loadCustomMap(Std.string(node.elements("terrain")), false);
      }
      script = null;
      var scriptXml = node.elements("script");
      if (scriptXml.length() > 0)
      {
        script = scriptXml.toXMLString();
      }
    }
  }

  function loadCustomMap(newMap : String, hasSettings : Bool) : Void
  {
    if (newMap == null)
    {
      customMap = null;
      normalize();
    }
    else
    {
      var whole = native.NativeBase.removeWhitespace(newMap);
      var halves = whole.split(".");
      if (halves.length != 2)
      {
        throw new flash.errors.Error("Could not find hash in terrain");
      }
      var hash = halves[0];
      var encoded = halves[1];
      var checkHash = haxe.crypto.Md5.encode(encoded);
      if (hash != checkHash)
      {
        throw new flash.errors.Error("Could not verify terrain.\n"
                                     + "Specified Hash: " + hash + "\n"
                                     + "Calculated Hash: " + checkHash);
      }
      var encodedBytes = haxe.io.Bytes.ofString(encoded);
      var decoder = new haxe.crypto.BaseCode(baseBytes);
      var compressed = decoder.decodeBytes(encodedBytes).getData();
      compressed.uncompress();
      var raw = compressed;
      if (hasSettings)
      {
        cityName = raw.readUTF();
        difficulty = raw.readUnsignedByte();
        size.x = raw.readUnsignedByte() + mapgen.Editor.edgeCount*2;
        size.y = raw.readUnsignedByte() + mapgen.Editor.edgeCount*2;
        start.x = raw.readUnsignedByte();
        start.y = raw.readUnsignedByte();
      }
      customMap = new flash.utils.ByteArray();
      raw.readBytes(customMap);
      normalize();
    }
  }

  public function setDifficulty(newDifficulty : Int) : Void
  {
    difficulty = newDifficulty;
    normalize();
  }

  public function getDifficulty() : Int
  {
    return difficulty;
  }

  public function getDifficultyName() : String
  {
    return difficultyText[difficulty];
  }

  public function setCityName(newName : String) : Void
  {
    cityName = newName;
    normalize();
  }

  public function getCityName() : String
  {
    return cityName;
  }

  public function getNormalName() : String
  {
    return normalName;
  }

  public function getEasterEgg() : Int
  {
    return easterEgg;
  }

  public function setEditor() : Void
  {
    editor = true;
  }

  public function clearEditor() : Void
  {
    editor = false;
  }

  public function isEditor() : Bool
  {
    return editor;
  }

  public function isTesting() : Bool
  {
    return testing;
  }

  public function isCustom() : Bool
  {
    return custom;
  }

  public function doesHaveEdges() : Bool
  {
    return hasEdges;
  }

  public function incrementPlayTime() : Void
  {
    ++playTime;
  }

  public function getPlayTime() : Int
  {
    return playTime;
  }

  public function getZombieSpeed() : Int
  {
    var result = zombieSpeed[difficulty];
    if (easterEgg == LONDON)
    {
      result *= 2;
    }
    return result;
  }

  public function getZombieMultiplier() : Int
  {
    return zombieMultiplier[difficulty];
  }

  public function getResourceMultiplier() : Int
  {
    return resourceMultiplier[difficulty];
  }

  public function getBridgeCount() : Int
  {
    return bridgeCount[difficulty];
  }

  public function getScarceCount() : Int
  {
    return scarceCount[difficulty];
  }

  public function getSize() : Point
  {
    return size;
  }

  public function setStart(newStart : Point) : Void
  {
    start = newStart.clone();
  }

  public function getStart() : Point
  {
    return start;
  }

  public function getKey() : String
  {
    return key;
  }

  public function setKey(newKey : String) : Void
  {
    key = newKey;
  }

  public function getUrl() : String
  {
    return url;
  }

  public function setUrl(newUrl : String) : Void
  {
    url = newUrl;
  }

  public function getScript() : String
  {
    return script;
  }

  public function getCampaign() : Int
  {
    return campaign;
  }

  public function setCampaign(newCampaign : Int) : Void
  {
    campaign = newCampaign;
  }

  public function getBriefingText() : String
  {
    return briefingText;
  }

  public function getWinText() : String
  {
    return winText;
  }

  public function setWinText(newText : String)
  {
    winText = newText;
  }

  public function getLoseText() : String
  {
    return loseText;
  }

  public function setLoseText(newText : String)
  {
    loseText = newText;
  }

  public function save() : Dynamic
  {
    return { difficulty : difficulty,
        cityName : cityName,
        playTime : playTime,
        map : saveMap(),
        editor : editor,
        testing : testing,
        hasEdges : hasEdges,
        custom : custom,
        size : size.save(),
        start : start.save(),
        key : key,
        url : url,
        script : script,
        campaign : campaign,
        briefingText : briefingText,
        winText : winText,
        loseText : loseText };
  }

  public function load(input : Dynamic) : Void
  {
    difficulty = input.difficulty;
    cityName = input.cityName;
    playTime = input.playTime;
    editor = input.editor;
    testing = input.testing;
    hasEdges = input.hasEdges;
    custom = input.custom;
    size = Point.load(input.size);
    start = Point.load(input.start);
    key = input.key;
    url = input.url;
    script = input.script;
    campaign = input.campaign;
    briefingText = input.briefingText;
    winText = input.winText;
    loseText = input.loseText;
    loadMap(input.map);
  }

  var difficulty : Int;
  var cityName : String;
  var playTime : Int;
  var customMap : flash.utils.ByteArray;
  var editor : Bool;
  var testing : Bool;
  var hasEdges : Bool;
  var custom : Bool;

  var normalName : String;
  var easterEgg : Int;

  var size : Point;
  var start : Point;

  var key : String;
  var url : String;
  var script : String;
  var campaign : Int;
  var briefingText : String;
  var winText : String;
  var loseText : String;

  // Gameplay changes based on difficulty
  static var zombieSpeed =        [ 80,  80, 104, 135, 175];
  // Map generation options based on difficulty
  static var zombieMultiplier =   [  1,   1,   2,   2,   3];
  static var resourceMultiplier = [  3,   3,   3,   3,   3];
  static var bridgeCount =        [  1,   1,   2,   3,   4];
  static var scarceCount =        [  0,   0,   1,   1,   2];
  static var sizeList =           [ 46,  46,  56,  66,  76];

  public static function getDifficultyNameS(index : Int) : String
  {
    return difficultyText[index];
  }

  public static function getDifficultyLimit() : Int
  {
    return difficultyText.length;
  }

  static var difficultyText =
    [ui.Text.tutorialText,
     ui.Text.noviceText,
     ui.Text.veteranText,
     ui.Text.expertText,
     ui.Text.quartermasterText];

  static var baseString
    = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
  static var baseBytes = haxe.io.Bytes.ofString(baseString);
}
