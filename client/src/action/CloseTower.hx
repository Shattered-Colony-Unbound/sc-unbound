package action;

class CloseTower implements Interface
{
  public function new(newX : Int, newY : Int) : Void
  {
    x = newX;
    y = newY;
  }

  public function run() : Void
  {
    Game.map.getCell(x, y).closeTower();
  }

  var x : Int;
  var y : Int;
}
