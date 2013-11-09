package ui;

class FpsCounter
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      l : LayoutGame) : Void
  {
#if TEST_LOAD
    counter = Util.createTextField(parent, l.fpsOffset, l.fpsSize);
    counter.background = true;
    counter.backgroundColor = Color.fpsCounterBackground;
    lastTime = haxe.Timer.stamp();
    timeCount = 1;
#end
  }

  public function cleanup() : Void
  {
#if TEST_LOAD
    counter.parent.removeChild(counter);
#end
  }

  public function enterFrame() : Void
  {
#if TEST_LOAD
    if (timeCount % 10 == 0)
    {
      var newTime = haxe.Timer.stamp();
      var fps = 10/(newTime - lastTime);
      counter.text = "FPS: " + Std.string(Math.round(fps));
      lastTime = newTime;
    }
    ++timeCount;
#end
  }

  var lastTime : Float;
  var timeCount : Int;
  var counter : flash.text.TextField;
}
