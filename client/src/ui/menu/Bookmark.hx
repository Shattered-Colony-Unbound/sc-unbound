package ui.menu;

class Bookmark
{
  public function new(newName : String, newPos : Int) : Void
  {
    name = newName;
    pos = newPos;
  }

  public var name : String;
  public var pos : Int;
}
