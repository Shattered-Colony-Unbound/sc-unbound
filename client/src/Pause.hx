class Pause
{
  public function new(parent : flash.display.DisplayObjectContainer) : Void
  {
    var l = Game.view.layout;
    paused = false;
    systemPaused = false;
    tutorialPaused = false;

    clip = flash.Lib.attach(ui.Label.pause);
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseChildren = false;
    clip.mouseEnabled = false;
    resize(l);
  }

  public function cleanup() : Void
  {
    clip.parent.removeChild(clip);
    clip = null;
  }

  public function resize(l : ui.LayoutGame) : Void
  {
    ui.Util.centerHorizontally(clip, l.screenSize);
    clip.y = l.screenSize.y - 130;
  }
  public function setText(newText : String)
  {
  }

  public function systemPause() : Void
  {
    systemPaused = true;
  }

  public function systemResume() : Void
  {
    systemPaused = false;
  }

  public function tutorialPause(newPause : Bool) : Void
  {
  }

  public function toggle() : Void
  {
    clip.visible = ! clip.visible;
    paused = ! paused;
    if (paused)
    {
      Game.view.spawner.setPause();
    }
    else
    {
      Game.view.spawner.setPlay();
    }
  }

  public function isPaused() : Bool
  {
    return paused || systemPaused || tutorialPaused;
  }

  public function isSystemPaused() : Bool
  {
    return systemPaused;
  }

  public function save() : Dynamic
  {
    return paused;
  }

  public function load(input : Dynamic) : Void
  {
    paused = input;
    clip.visible = paused;
  }

  var clip : flash.display.MovieClip;
  var paused : Bool;
  var systemPaused : Bool;
  var tutorialPaused : Bool;
}
