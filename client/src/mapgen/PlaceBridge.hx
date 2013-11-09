package mapgen;

class PlaceBridge
{
  public function new(newDir : Direction, newIsBroken : Bool) : Void
  {
    dir = newDir;
    isBroken = newIsBroken;
  }


  static var leftTile = [206, 186, 294, 293];
  static var rightTile = [207, 187, 314, 313];

  public function place(base : Section) : Void
  {
    var water = new PlaceTerrain();
    water.place(base, PlaceTerrain.shallowWater);
    var perp = Lib.rotateCW(dir);
    if (perp == Direction.SOUTH)
    {
      perp = Direction.NORTH;
    }
    if (perp == Direction.EAST)
    {
      perp = Direction.WEST;
    }
    var left = base.slice(perp, 1);
    var right = base.slice(Util.opposite(perp), 1);
    var inside = base.remainder(perp, 1).remainder(Util.opposite(perp), 1);
    Util.fillBlocked(left);
    Util.fillBlocked(right);
    if (isBroken)
    {
      placeBrokenEdge(base, dir);
    }
    else
    {
      Util.fillBackground(inside, BackgroundType.BRIDGE);
      Util.fillUnblocked(inside);
      var dirIndex = Lib.directionToIndex(dir);
      Util.fillAddTile(left, leftTile[dirIndex]);
      Util.fillAddTile(right, rightTile[dirIndex]);
      placeInside(inside);
      Main.replay.addBox(inside.offset, inside.limit, Option.roadMiniColor);
    }
  }

  static var threeBroken = [1207, 1186, 1206, 1187];
  static var randBroken = [[1207,1247], [1186,1226], [1206,1246], [1187,1227]];

  static var firstBegin = [200, 180, 173, 174];
  static var secondBegin = [201, 181, 193, 194];
  static var firstCenter = [202, 182, 213, 214];
  static var secondCenter = [203, 183, 233, 234];
  static var firstEnd = [204, 184, 253, 254];
  static var secondEnd = [205, 185, 273, 274];

  function placeBrokenEdge(base : Section, brokenDir : Direction) : Void
  {
    var dirIndex = Lib.directionToIndex(brokenDir);
    var edge = base.slice(brokenDir, 1);
    var i = 0;
    var end = Math.floor(Math.max(edge.getSize().x, edge.getSize().y)) - 1;
    var pos = new Point(0, 0);
    for (y in edge.offset.y...edge.limit.y)
    {
      for (x in edge.offset.x...edge.limit.x)
      {
        var tile = Tile.NO_TILE;
        if (i == 1 && end == 2)
        {
          tile = threeBroken[dirIndex];
        }
        else if (i == 0)
        {
          tile = firstBegin[dirIndex];
        }
        else if (i == 1)
        {
          tile = secondBegin[dirIndex];
        }
        else if (i == end - 1)
        {
          tile = firstEnd[dirIndex];
        }
        else if (i == end)
        {
          tile = secondEnd[dirIndex];
        }
        else if ((end+1)%2 == 0 && i == Math.floor((end+1)/2) - 1)
        {
          tile = firstCenter[dirIndex];
        }
        else if ((end+1)%2 == 0 && i == Math.floor((end+1)/2))
        {
          tile = secondCenter[dirIndex];
        }
        else
        {
          var randList = randBroken[dirIndex];
          tile = randList[Util.rand(randList.length)];
        }
        pos.x = x;
        pos.y = y;
        Util.addTile(pos, tile);
        ++i;
      }
    }
  }

  function placeInside(base : Section) : Void
  {
    var isVertical = (dir == Direction.NORTH || dir == Direction.SOUTH);
    var size = base.getSize();
    var width = size.x;
    var height = size.y;
    if (! isVertical)
    {
      width = size.y;
      height = size.x;
    }
    var street = new Street(base.offset, width, height, isVertical,
                            null, null);
    street.draw(Game.map, false);
  }

  public function intersectStreet(base : Section) : Void
  {
    var source = base.edge(Util.opposite(dir));
    var road = base.getStreet(Util.opposite(dir));
    if (road != null)
    {
      switch (dir)
      {
      case NORTH:
        road.addLess(source.offset, 4, CrossStreet.ROAD);
      case SOUTH:
        road.addGreater(source.offset, 4, CrossStreet.ROAD);
      case EAST:
        road.addGreater(source.offset, 4, CrossStreet.ROAD);
      case WEST:
        road.addLess(source.offset, 4, CrossStreet.ROAD);
      }
    }
  }

  var isBroken : Bool;
  var dir : Direction;
}
/*
  function placeArea(lot : Section, base : Array<Array<Int>>,
                     overlay : Array<Array<Int>>) : Void
  {
    for (y in 0...lot.getSize().y)
    {
      for (x in 0...lot.getSize().x)
      {
        var relX = x;
        var relY = y;
        if (dir == Direction.WEST)
        {
          relX = lot.getSize().x - x - 1;
        }
        if (dir == Direction.NORTH)
        {
          relY = lot.getSize().y - y - 1;
        }
        var pos = new Point(x + lot.offset.x, y + lot.offset.y);
        if (relY >= base.length)
        {
          relY = base.length - 1;
        }
        if (relX >= base[relY].length)
        {
          relX = base[relY].length - 1;
        }
        Util.clearTiles(pos);
        Util.addTile(pos, base[relY][relX]);
        if (overlay != null && overlay[relY][relX] != -1)
        {
          Util.addTile(pos, overlay[relY][relX]);
        }
      }
    }
  }
*/

/*
  static var northBrokenBase =
    [[64, 188, 188, 188, 188, 64],
     [127, 127, 127, 127, 127, 127],
     [147, 147, 147, 147, 147, 147]];

  static var northBrokenOverlay =
    [[180, 181, 182, 183, 184, 185],
     [-1, -1, -1, -1, -1, -1],
     [-1, -1, -1, -1, -1, -1]];

  static var southBrokenBase =
    [[161, 208, 208, 208, 208, 161],
     [167, 167, 167, 167, 167, 167],
     [147, 147, 147, 147, 147, 147]];

  static var southBrokenOverlay =
    [[200, 201, 202, 203, 204, 205],
     [-1, -1, -1, -1, -1, -1],
     [-1, -1, -1, -1, -1, -1]];

  static var eastBrokenBase =
    [[145, 148, 147],
     [176, 148, 147],
     [176, 148, 147],
     [176, 148, 147],
     [176, 148, 147],
     [145, 148, 147]];

  static var eastBrokenOverlay =
    [[174, -1, -1],
     [194, -1, -1],
     [214, -1, -1],
     [234, -1, -1],
     [254, -1, -1],
     [274, -1, -1]];

  static var westBrokenBase =
    [[80, 146, 147],
     [175, 146, 147],
     [175, 146, 147],
     [175, 146, 147],
     [175, 146, 147],
     [80, 146, 147]];

  static var westBrokenOverlay =
    [[173, -1, -1],
     [193, -1, -1],
     [213, -1, -1],
     [233, -1, -1],
     [253, -1, -1],
     [273, -1, -1]];

  static var northBridgeBase =
    [[ 64, 43, 45, 46, 48,  64],
     [127, 23, 25, 26, 28, 127],
     [147, 23, 25, 26, 28, 147]];

  static var northBridgeOverlay =
    [[186, -1, -1, -1, -1, 187],
     [186, -1, -1, -1, -1, 187],
     [186, -1, -1, -1, -1, 187]];

  static var southBridgeBase =
    [[161,  3,  5,  6,  8, 161],
     [167, 23, 25, 26, 28, 167],
     [147, 23, 25, 26, 28, 147]];

  static var southBridgeOverlay =
    [[206, -1, -1, -1, -1, 207],
     [206, -1, -1, -1, -1, 207],
     [206, -1, -1, -1, -1, 207]];

  static var eastBridgeBase =
    [[145, 148, 147],
     [ 70,  71, 71],
     [110, 111, 111],
     [130, 131, 131],
     [170, 171, 171],
     [145, 148, 147]];

  static var eastBridgeOverlay =
    [[294, 294, 294],
     [ -1,  -1,  -1],
     [ -1,  -1,  -1],
     [ -1,  -1,  -1],
     [ -1,  -1,  -1],
     [314, 314, 314]];

  static var westBridgeBase =
    [[80, 146, 147],
     [72, 71, 71],
     [112, 111, 111],
     [132, 131, 131],
     [172, 171, 171],
     [80, 146, 147]];

  static var westBridgeOverlay =
    [[293, 293, 293],
     [ -1,  -1,  -1],
     [ -1,  -1,  -1],
     [ -1,  -1,  -1],
     [ -1,  -1,  -1],
     [313, 313, 313]];
*/
/*
  public function place(base : Section) : Void
  {
    Util.fillClearTiles(base);
    Util.fillBlocked(base);
    Util.fillBackground(base, BackgroundType.WATER);
[*
    if (isBroken)
    {
      switch (dir)
      {
      case NORTH:
        placeArea(base, northBrokenBase, northBrokenOverlay);
      case SOUTH:
        placeArea(base, southBrokenBase, southBrokenOverlay);
      case EAST:
        placeArea(base, eastBrokenBase, eastBrokenOverlay);
      case WEST:
        placeArea(base, westBrokenBase, westBrokenOverlay);
      }
    }
    else
    {
      var edge = null;
      switch (dir)
      {
      case NORTH:
        placeArea(base, northBridgeBase, northBridgeOverlay);
        edge = base.edge(Direction.SOUTH);
      case SOUTH:
        placeArea(base, southBridgeBase, southBridgeOverlay);
        edge = base.edge(Direction.NORTH);
      case EAST:
        placeArea(base, eastBridgeBase, eastBridgeOverlay);
        edge = base.edge(Direction.WEST);
      case WEST:
        placeArea(base, westBridgeBase, westBridgeOverlay);
        edge = base.edge(Direction.EAST);
      }
      var center = base.center();
      Util.fillUnblocked(center);
      Util.fillBackground(center, BackgroundType.BRIDGE);
      Util.fillUnblocked(edge);
      Util.fillBackground(edge, BackgroundType.BRIDGE);
    }
*]
    switch (dir)
    {
    case NORTH:
      placeArea(base, northBrokenBase, null);
    case SOUTH:
      placeArea(base, southBrokenBase, null);
    case EAST:
      placeArea(base, eastBrokenBase, null);
    case WEST:
      placeArea(base, westBrokenBase, null);
    }
  }
*/
