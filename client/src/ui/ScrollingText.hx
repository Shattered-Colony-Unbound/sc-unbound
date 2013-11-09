package ui;

class ScrollingText
{
  public function new(newParent : flash.display.DisplayObjectContainer,
                      newClips : Array<flash.display.DisplayObject>,
                      newStarts : Array<Int>, size : Point)
  {
    parent = newParent;
    clips = newClips;
    starts = newStarts;
    height = size.y;
    reset();
  }

  public function cleanup() : Void
  {
    end();
  }

  public function resize(size : Point) : Void
  {
    height = size.y;
    update();
  }

  public function begin() : Void
  {
    parent.addEventListener(flash.events.Event.ENTER_FRAME, enterFrame);
    reset();
  }

  public function end() : Void
  {
    parent.removeEventListener(flash.events.Event.ENTER_FRAME, enterFrame);
  }

  function reset() : Void
  {
    offset = 0.0;
    update();
  }

  public function update() : Void
  {
    for (i in 0...(clips.length))
    {
      clips[i].y = (height + starts[i]) + offset;
    }
  }

  public function skip() : Void
  {
    offset -= skipDelta;
    update();
  }

  function enterFrame(event : flash.events.Event) : Void
  {
    offset -= delta;
    update();
  }

  var parent : flash.display.DisplayObjectContainer;
  var clips : Array<flash.display.DisplayObject>;
  var starts : Array<Int>;
  var offset : Float;
  var height : Int;

  static var delta = 1.0;
  static var skipDelta = 100.0;
}
