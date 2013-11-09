package ui;

class LayoutMain
{
  public function new(sizeX : Int, sizeY : Int) : Void
  {
    screenSize = new Point(sizeX, sizeY);
  }

  public var screenSize : Point;
}
