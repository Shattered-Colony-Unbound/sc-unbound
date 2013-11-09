class Range
{
  // Note: The assumption is that the parent is the root of the
  // window, and that this will be offset by Game.view.mapOffset
  public function new(parent : flash.display.DisplayObjectContainer,
                      newColor : Int, newOpacity : Float) : Void
  {
    clip = new flash.display.Shape();
    parent.addChild(clip);
    clip.visible = false;

    color = newColor;
    opacity = newOpacity;
    resize(Game.view.layout);
  }

  public function cleanup() : Void
  {
    clip.parent.removeChild(clip);
    clip = null;
    squares = null;
  }

  public function resize(l : ui.LayoutGame) : Void
  {
    clip.x = l.mapOffset.x;
    clip.y = l.mapOffset.y;
    squares = new Grid<Int>(l.windowSize.x, l.windowSize.y);
    changed = true;
    clear();
  }

  public function clear() : Void
  {
    clip.graphics.clear();
    clip.visible = false;
    for (y in 0...squares.sizeY())
    {
      for (x in 0...squares.sizeX())
      {
        squares.set(x, y, 0);
      }
    }
    changed = true;
  }

  public function draw() : Void
  {
    clip.visible = true;
    if (changed)
    {
      changed = false;
      clip.graphics.clear();
      for (y in 0...squares.sizeY())
      {
        for (x in 0...squares.sizeX())
        {
          if (squares.get(x, y) > 0)
          {
            var totalOpacity = opacity
              + (squares.get(x, y) - 1) * Option.rangeOpacityIncrement;
            clip.graphics.beginFill(color, totalOpacity);
            var top = Lib.cellToPixel(y);
            var left = Lib.cellToPixel(x);
            var bottom = top + Option.cellPixels;
            var right = left + Option.cellPixels;
            clip.graphics.moveTo(left, top);
            clip.graphics.lineTo(right, top);
            clip.graphics.lineTo(right, bottom);
            clip.graphics.lineTo(left, bottom);
            clip.graphics.lineTo(left, top);
            clip.graphics.endFill();
          }
        }
      }
    }
  }

  // x and y are in absolute cells
  public function set(x : Int, y : Int) : Void
  {
    var l = Game.view.layout;
    changed = true;
    var pos = Game.view.window.toRelative(x, y);
    if (pos.x >= 0 && pos.x < l.windowSize.x
        && pos.y >= 0 && pos.y < l.windowSize.y)
    {
      squares.set(pos.x, pos.y, squares.get(pos.x, pos.y) + 1);
    }
  }

  var clip : flash.display.Shape;
  var color : Int;
  var opacity : Float;
  var squares : Grid<Int>;
  var changed : Bool;
}
