package mapgen;

class Terrain
{
  public function new(newTerrainFunc : EditType -> Bool,
                      newBlocked : Bool,
                      newBackground : BackgroundType,
                      newCorners : Array<Int>) : Void
  {
    terrainFunc = newTerrainFunc;
    blocked = newBlocked;
    background = newBackground;
    corners = newCorners;
  }

  public function isTerrain(type : EditType) : Bool
  {
    return terrainFunc(type);
  }

  public function isBlocked() : Bool
  {
    return blocked;
  }

  public function getBackground() : BackgroundType
  {
    return background;
  }

  public function getCorner(bits : Int) : Int
  {
    return corners[bits];
  }

  var terrainFunc : EditType -> Bool;
  var blocked : Bool;
  var background : BackgroundType;
  var corners : Array<Int>;
}
