package ui;

class SpawnDisplay
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      l : LayoutGame) : Void
  {
    oldCount = 0;
    timer = new TimerClip();
    parent.addChild(timer);
    if (Game.settings.isEditor())
    {
      timer.visible = false;
    }
    timer.mouseChildren = false;
    timer.addEventListener(flash.events.MouseEvent.CLICK, click);
    timer.addEventListener(flash.events.MouseEvent.ROLL_OVER, rollOver);
    timer.addEventListener(flash.events.MouseEvent.ROLL_OUT, rollOut);
    timer.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, mouseMove);
    resize(l);
    setPlay();
  }

  public function cleanup() : Void
  {
    timer.removeEventListener(flash.events.MouseEvent.CLICK, click);
    timer.removeEventListener(flash.events.MouseEvent.ROLL_OVER, rollOver);
    timer.removeEventListener(flash.events.MouseEvent.ROLL_OUT, rollOut);
    timer.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, mouseMove);
    timer.parent.removeChild(timer);
    timer = null;
  }

  public function resize(l : LayoutGame) : Void
  {
    timer.x = l.countDownOffset.x;
    timer.y = l.countDownOffset.y;
    timer.width = l.countDownSize.x;
    timer.height = l.countDownSize.y;
  }

  function click(event : flash.events.MouseEvent) : Void
  {
    Game.pause.toggle();
    updateTip(event.localX, event.localY);
  }

  function mouseMove(event : flash.events.MouseEvent) : Void
  {
    updateTip(event.localX, event.localY);
  }

  function rollOver(event : flash.events.MouseEvent) : Void
  {
    updateTip(event.localX, event.localY);
  }

  function rollOut(event : flash.events.MouseEvent) : Void
  {
    Game.view.toolTip.hide();
  }

  function updateTip(x : Float, y : Float) : Void
  {
    if (x < 115)
    {
      Game.view.toolTip.show(ui.Text.countDownTip);
    }
    else if (Game.pause.isPaused())
    {
      Game.view.toolTip.show(ui.Text.unpauseTip);
    }
    else
    {
      Game.view.toolTip.show(ui.Text.pauseTip);
    }
  }

  public function setPlay() : Void
  {
    timer.isPause.visible = false;
    timer.isPlay.visible = true;
  }

  public function setPause() : Void
  {
    timer.isPause.visible = true;
    timer.isPlay.visible = false;
  }

  public function update() : Void
  {
    var waveCount = Game.spawner.getWaveCount();
    if (Game.settings.getEasterEgg() != logic.GameSettings.FIDDLERSGREEN
        && (waveCount > 0 || ! Game.spawner.getIsCounting()))
    {
      timer.minutes.visible = false;
      timer.tens.visible = false;
      timer.seconds.visible = false;
    }
    else
    {
      timer.minutes.visible = true;
      timer.tens.visible = true;
      timer.seconds.visible = true;
      var frameCount = Game.spawner.getFramesLeft();
      var count = Math.floor(frameCount / Option.fps);
      if (count <= 10 && count != oldCount)
      {
        Main.sound.play(SoundPlayer.TIMER_PIP);
      }
      oldCount = count;
      if (Game.settings.getEasterEgg() != logic.GameSettings.FIDDLERSGREEN)
      {
        outputTime(frameCount);
      }
      else
      {
        outputTime(Math.floor(Game.settings.getPlayTime() / 60));
      }
    }
  }

  function outputTime(frameCount : Int)
  {
    var timeLeft = new Time(frameCount);
    if (timeLeft.minutes + 1 != timer.minutes.currentFrame)
    {
      timer.minutes.gotoAndStop(timeLeft.minutes + 1);
    }
    if (timeLeft.tens + 1 != timer.tens.currentFrame)
    {
      timer.tens.gotoAndStop(timeLeft.tens + 1);
    }
    if (timeLeft.seconds + 1 != timer.seconds.currentFrame)
    {
      timer.seconds.gotoAndStop(timeLeft.seconds + 1);
    }
  }

  public function step() : Void
  {
    update();
  }

  public function showAnnounce() : Void
  {
  }

  var timer : TimerClip;
  var oldCount : Int;
}
