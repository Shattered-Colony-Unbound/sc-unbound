package ui;

class MainIntroMusic extends flash.media.Sound { }
class MainLoopMusic extends flash.media.Sound { }
class Wave1Music extends flash.media.Sound { }
class Wave2Music extends flash.media.Sound { }
class Wave3Music extends flash.media.Sound { }
class WaveEndMusic extends flash.media.Sound { }
class QuietMusic extends flash.media.Sound { }
class AmbientMusic extends flash.media.Sound { }

class MusicPlayer
{
  public function new() : Void
  {
    pos = MAIN_INTRO;
    transform = new flash.media.SoundTransform();
    advance();
  }

  public function cleanup() : Void
  {
    stop();
  }

  public function stop() : Void
  {
#if MUSIC
    if (channel != null)
    {
//      Main.getRoot().removeEventListener(flash.events.Event.ENTER_FRAME,
//                                         enterFrame);
      channel.removeEventListener(flash.events.Event.SOUND_COMPLETE, complete);
      channel.stop();
      channel = null;
    }
#end
  }

  public function changeMusic(newPos : Int, newCrossFade : Bool)
  {
    pos = newPos;
    if (newCrossFade)
    {
      advance();
    }
  }

  function advance(? optStart : Null<Float>) : Void
  {
    try {
#if MUSIC
    var start = 0.0;
    if (optStart != null)
    {
      start = optStart;
    }
    stop();
//    Main.getRoot().addEventListener(flash.events.Event.ENTER_FRAME,
//                                    enterFrame);
    currentMusic = musicList[pos];
    transform.volume = Main.config.getProportion(Config.MUSIC);
    channel = currentMusic.play(start, 0, transform);
    channel.addEventListener(flash.events.Event.SOUND_COMPLETE, complete);
    pos = nextMusic[pos];
#end
    } catch (e : Dynamic) {}
  }

  function complete(event : flash.events.Event) : Void
  {
    advance();
  }

  static var bufferLength = 1000.0;

  function enterFrame(event : flash.events.Event) : Void
  {
    if (pos == MAIN_INTRO || pos == MAIN_LOOP)
    {
      if (channel.position > currentMusic.length - bufferLength)
      {
        Lib.trace("within buffer");
        var oldChannel = channel;
        stop();
        var fromEnd = musicList[pos].length - oldChannel.position;
        var newStart = bufferLength - fromEnd;
        advance(newStart);
      }
    }
  }

  public static function randomWave() : Int
  {
    return Lib.rand(3) + WAVE_1;
  }

  public function setVolume(newVolume : Float) : Void
  {
    if (channel != null)
    {
      transform.volume = newVolume;
      channel.soundTransform = transform;
    }
  }

  var pos : Int;
  var channel : flash.media.SoundChannel;
  var currentMusic : flash.media.Sound;
  var transform : flash.media.SoundTransform;

  static var nextMusic = [MAIN_LOOP,
                          MAIN_INTRO, WAVE_2, WAVE_3,
                          WAVE_1, QUIET, AMBIENT, QUIET];

  static var musicList = [new MainIntroMusic(),
                          new MainLoopMusic(),
                          new Wave1Music(), new Wave2Music(),
                          new Wave3Music(), new WaveEndMusic(),
                          new QuietMusic(), new AmbientMusic()];

  public static var MAIN_INTRO = 0;
  public static var MAIN_LOOP = 1;
  public static var WAVE_1 = 2;
  public static var WAVE_2 = 3;
  public static var WAVE_3 = 4;
  public static var WAVE_END = 5;
  public static var QUIET = 6;
  public static var AMBIENT = 7;
}
