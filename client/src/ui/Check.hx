package ui;

// Functions to check various ui requests.
class Check
{
  public static var ADD_OK = 0;
  public static var ADD_SAME = 1;
  public static var ADD_EXISTS = 2;
  public static var ADD_NO_DEST = 3;
  public static var ADD_NO_SELECT = 4;

  public static function checkAddSupply(dest : Point) : Int
  {
    var select = Game.select.getSelected();
    if (select == null)
    {
      return ADD_NO_SELECT;
    }
    var sourceTower = Game.map.getCell(select.x, select.y).getTower();
    var destTower = Game.map.getCell(dest.x, dest.y).getTower();
    if (sourceTower == null)
    {
      return ADD_NO_SELECT;
    }
    else if (destTower == null)
    {
      return ADD_NO_DEST;
    }
    else if (sourceTower == destTower)
    {
      return ADD_SAME;
    }
    else if (sourceTower.getRoute(dest) != null)
    {
      return ADD_EXISTS;
    }
    else
    {
      return ADD_OK;
    }
  }

  public static var REMOVE_OK = 0;
  public static var REMOVE_NO_SUPPLY = 1;
  public static var REMOVE_NO_DEST = 2;
  public static var REMOVE_NO_SELECT = 3;

  public static function checkRemoveSupply(dest : Point) : Int
  {
    var select = Game.select.getSelected();
    if (select == null)
    {
      return REMOVE_NO_SELECT;
    }
    var sourceTower = Game.map.getCell(select.x, select.y).getTower();
    var destTower = Game.map.getCell(dest.x, dest.y).getTower();
    if (sourceTower == null)
    {
      return REMOVE_NO_SELECT;
    }
    else if (destTower == null)
    {
      return REMOVE_NO_DEST;
    }
    else if (sourceTower.getRoute(dest) == null)
    {
      return REMOVE_NO_SUPPLY;
    }
    else
    {
      return REMOVE_OK;
    }
  }
}
