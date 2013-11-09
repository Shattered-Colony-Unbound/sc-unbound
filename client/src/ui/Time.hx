package ui;

class Time
{
  public function new(frameCount : Int) : Void
  {
    var count = Math.floor(frameCount / Option.fps);
    minutes = Math.floor(count / 60);
    count = count % 60;
    tens = Math.floor(count / 10);
    seconds = count % 10;
  }

  public function toString() : String
  {
    return ui.Text.timeLabel(Std.string(minutes), Std.string(tens),
                             Std.string(seconds));
  }

  public var minutes : Int;
  public var tens : Int;
  public var seconds : Int;
}
