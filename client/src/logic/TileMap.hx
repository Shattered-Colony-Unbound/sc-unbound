package logic;

interface TileMap
{
  public function getTiles(pos : Point) : List<Int>;
  public function addTile(pos : Point, tile : Int) : Void;
  public function clearTiles(pos : Point) : Void;

  public function setBackground(pos : Point,
                                background : BackgroundType) : Void;
  public function getBackground(pos : Point) : BackgroundType;

  public function setBlocked(pos : Point) : Void;
  public function clearBlocked(pos : Point) : Void;
  public function changeBlocked(pos : Point, isBlocked : Bool) : Void;
  public function isBlocked(pos : Point) : Bool;
}
