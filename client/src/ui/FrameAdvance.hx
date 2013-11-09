// A hacky way to advance certain animations at a fixed rate rather
// than depending on building/zombie/survivor speed.

// TODO: Save/load

package ui;

class FrameAdvance
{
  public function new() : Void
  {
    frames = [];
  }

  public function fixedStep() : Void
  {
    for (frame in frames)
    {
      frame.fixedStep();
    }
  }

  public function add(newFrame : AbstractFrame) : Void
  {
    frames.push(newFrame);
  }

  public function remove(oldFrame : AbstractFrame) : Void
  {
    frames.remove(oldFrame);
  }

  var frames : Array<AbstractFrame>;
}
