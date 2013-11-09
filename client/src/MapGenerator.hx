class MapGenerator
{
  public static var waterCount = 8;

  public function new(newMap : Map, newSettings : logic.GameSettings) : Void
  {
    map = newMap;
    settings = newSettings;
    biasRegions = [];
    mapgen.Util.seed(settings.getNormalName());
    for (y in 0...settings.getSize().y)
    {
      for (x in 0...settings.getSize().x)
      {
        map.getCell(x, y).init(x, y);
      }
    }
  }

  public function resetMap() : Void
  {
    box(new Point(0, 0), settings.getSize().clone(), Option.roadMiniColor);

    var offset = new Point(0, 0);
    var limit = settings.getSize().clone();
    box(offset, limit, Option.waterColor);
    placeWater(offset, limit, waterCount);

    offset = new Point(waterCount, waterCount);
    limit = new Point(settings.getSize().x - waterCount,
                      settings.getSize().y - waterCount);
    if (settings.getNormalName().indexOf("tutorial") != -1)
    {
      placeTutorial(offset, limit);
    }
    else
    {
      placeIsland(offset, limit);
    }
    for (building in map.getBuildings())
    {
      building.drawReplay();
    }
  }

  // --------------------------------------------------------------------------

  private function shrinkSize(offset : Point, limit : Point) : Void
  {
    offset.x++;
    offset.y++;
    limit.x--;
    limit.y--;
  }

  // --------------------------------------------------------------------------

  private function expandSize(offset : Point, limit : Point) : Void
  {
    offset.x--;
    offset.y--;
    limit.x++;
    limit.y++;
  }

  // --------------------------------------------------------------------------

  function placeWithBorder(offset : Point, limit : Point,
                           tiles /*: Array<Int>*/,
                           background : BackgroundType, isBlocked : Bool)
  {
    fillWith(offset, new Point(offset.x + 1, offset.y + 1),
             tiles[0], background, isBlocked);
    fillWith(new Point(offset.x + 1, offset.y),
             new Point(limit.x - 1, offset.y + 1),
             tiles[1], background, isBlocked);
    fillWith(new Point(limit.x - 1, offset.y),
             new Point(limit.x, offset.y + 1),
             tiles[2], background, isBlocked);
    fillWith(new Point(offset.x, offset.y + 1),
             new Point(offset.x + 1, limit.y - 1),
             tiles[3], background, isBlocked);
    if (tiles[4] != Tile.NO_TILE)
    {
      fillWith(new Point(offset.x + 1, offset.y + 1),
               new Point(limit.x - 1, limit.y - 1),
               tiles[4], background, isBlocked);
    }
    fillWith(new Point(limit.x - 1, offset.y + 1),
             new Point(limit.x, limit.y - 1),
             tiles[5], background, isBlocked);
    fillWith(new Point(offset.x, limit.y - 1),
             new Point(offset.x + 1, limit.y),
             tiles[6], background, isBlocked);
    fillWith(new Point(offset.x + 1, limit.y - 1),
             new Point(limit.x - 1, limit.y),
             tiles[7], background, isBlocked);
    fillWith(new Point(limit.x - 1, limit.y - 1), limit,
             tiles[8], background, isBlocked);
  }

  // --------------------------------------------------------------------------

  static var deepWaterTiles
    = [Tile.deepWater, Tile.deepWater, Tile.deepWater,
       Tile.deepWater, Tile.NO_TILE, Tile.deepWater,
       Tile.deepWater, Tile.deepWater, Tile.deepWater];
  static var shallowWaterTiles
  /*
    = [Tile.nwShallows, Tile.nShallows, Tile.neShallows,
       Tile.wShallows, Tile.NO_TILE, Tile.eShallows,
       Tile.swShallows, Tile.sShallows, Tile.seShallows];
  */
    = [989, 989, 989, 989, 989, 989, 989, 989, 989];
  static var beachTiles
    = [Tile.nwBeach, Tile.nBeach, Tile.neBeach,
       Tile.wBeach, Tile.NO_TILE, Tile.eBeach,
       Tile.swBeach, Tile.sBeach, Tile.seBeach];

  private function placeWater(offset : Point, limit : Point,
                              count : Int) : Void
  {
    for (i in 0...(count - 2))
    {
      placeWithBorder(offset, limit, shallowWaterTiles,
                      BackgroundType.WATER, true);
      shrinkSize(offset, limit);
    }

    placeWithBorder(offset, limit, shallowWaterTiles,
                    BackgroundType.WATER, true);
    shrinkSize(offset, limit);

    placeWithBorder(offset, limit, beachTiles,
                    BackgroundType.WATER, true);
    shrinkSize(offset, limit);
  }

  function placeTutorial(offset : Point, limit : Point) : Void
  {
    // TODO: Fix this. We shouldn't be mucking with offset and limit anyhow.
    var mapOffset = offset.clone();
    var mapLimit = limit.clone();
    box(offset, limit, Option.waterColor);
    fillWith(offset, limit, Tile.deepWater, BackgroundType.WATER, true);
    var width = 14;
    var height = 34;
    offset = new Point(offset.x + Math.floor((limit.x - offset.x - width)/2),
                       offset.y + Math.floor((limit.y - offset.y - height)/2));
    limit = new Point(offset.x + width, offset.y + height);
    placeWater(offset, limit, 2);
    box(offset, limit, Option.roadMiniColor);
    var middle = new mapgen.Street(new Point(offset.x + 3, offset.y), 4,
                                   limit.y - offset.y, true, null, null);

    var left = new mapgen.Section(offset, new Point(offset.x + 3, limit.y));
    left.east = middle;

    var right = new mapgen.Section(new Point(offset.x + 7, offset.y),
                                   new Point(offset.x + 10, limit.y));
    right.west = middle;

    var top = new mapgen.Section(new Point(offset.x + 2, mapOffset.y),
                                 new Point(offset.x + 8, offset.y));
    var topPos = new Point(offset.x + 5, offset.y);
    var bottom = new mapgen.Section(new Point(offset.x + 2, limit.y),
                                    new Point(offset.x + 8, mapLimit.y));
    var bottomPos = new Point(offset.x + 6, limit.y - 1);
    placeSingleBridge(top, topPos, Direction.NORTH, false, false);
    placeSingleBridge(bottom, bottomPos, Direction.SOUTH, true, true);

    placeBlock(left);
    placeBlock(right);

    biasRegions = [];

    middle.draw(map);

    placeZombies();
    placeSalvage();
  }

  private function placeIsland(offset : Point, limit : Point)
  {
//    box(offset, limit, Option.waterColor);
//    placeWater(offset, limit, waterCount);

    placeStreetCorners(offset, limit);
    box(offset, limit, Option.roadMiniColor);
    mapgen.Util.fillBackground(new mapgen.Section(offset, limit),
                               BackgroundType.STREET);

    var base = new mapgen.Section(offset, limit);
    map.setCityLot(base);
    base.west = new mapgen.Street(new Point(offset.x, offset.y + 2),
                           2, limit.y - offset.y - 4, true, null, null);
    base.east = new mapgen.Street(new Point(limit.x - 2, offset.y + 2),
                           2, limit.y - offset.y - 4, true, null, null);
    base.north = new mapgen.Street(new Point(offset.x + 2, offset.y),
                            2, limit.x - offset.y - 4, false, null, null);
    base.south = new mapgen.Street(new Point(offset.x + 2, limit.y - 2),
                            2, limit.x - offset.y - 4, false, null, null);
    shrinkSize(base.offset, base.limit);
    shrinkSize(base.offset, base.limit);

    placeCity(base);
    base.west.draw(map);
    base.east.draw(map);
    base.north.draw(map);
    base.south.draw(map);
  }

  function placeStreetCorners(offset : Point, limit : Point) : Void
  {
    var x = [offset.x, limit.x - 2, offset.x, limit.x - 2];
    var y = [offset.y, offset.y, limit.y - 2, limit.y - 2];
    var source = [Tile.nwCurve, Tile.neCurve, Tile.swCurve, Tile.seCurve];
    for (i in 0...4)
    {
      for (col in 0...2)
      {
        for (row in 0...2)
        {
          var cell = map.getCell(x[i] + col, y[i] + row);
          var tile = source[i] + col + row*(Tile.X_COUNT);
          cell.clearTiles();
          cell.addTile(tile);
          cell.setBackground(BackgroundType.STREET);
          cell.clearBlocked();
        }
      }
    }
  }

  // -------------------------------------------------------------------------

  private function placeCity(base : mapgen.Section) : Void
  {
    var div = new mapgen.Division(Option.minGenericSize);
    div.split(base, 4);
    var top = new mapgen.Division(Option.minGenericSize);
    top.split(div.getTop(), 4);
    var bottom = new mapgen.Division(Option.minGenericSize);
    bottom.split(div.getBottom(), 4);

    placeBridges(top, bottom);

    placeRegion(top.getLeft());
    placeRegion(top.getRight());
    placeRegion(bottom.getLeft());
    placeRegion(bottom.getRight());

    biasRegions = [top.getLeft(), top.getRight(), bottom.getLeft(),
                   bottom.getRight()];
    mapgen.Util.shuffle(biasRegions);

    top.getMiddle().draw(map);
    bottom.getMiddle().draw(map);
    div.getMiddle().draw(map);

    if (settings.getEasterEgg() != logic.GameSettings.FIDDLERSGREEN)
    {
      placeZombies();
    }
    placeSalvage();
  }

  // --------------------------------------------------------------------------

  private function fillWith(offset : Point, limit : Point, tile : Int,
                            background : BackgroundType, blocked : Bool)
  {
    for (y in (offset.y)...(limit.y))
    {
      for (x in (offset.x)...(limit.x))
      {
        map.getCell(x, y).addTile(tile);
        map.getCell(x, y).setBackground(background);
        if (blocked)
        {
          map.getCell(x, y).setBlocked();
        }
        else
        {
          map.getCell(x, y).clearBlocked();
        }
      }
    }
  }


  // --------------------------------------------------------------------------

  private function placeRegion(base : mapgen.Section) : Void
  {
    if (base.limit.x - base.offset.x <= Option.blockThreshold
        && base.limit.y - base.offset.y <= Option.blockThreshold)
    {
      placeBlock(base);
    }
    else
    {
      var div = new mapgen.Division(Option.minGenericSize);
      div.split(base, findStreetWidth(base.offset, base.limit));
      placeRegion(div.getLeft());
      placeRegion(div.getRight());
      div.getMiddle().draw(map);
    }
  }

  private function findStreetWidth(offset : Point, limit : Point) : Int
  {
    var result = 3;
    var xDelta = limit.x - offset.x;
    var yDelta = limit.y - offset.y;
    if (xDelta < 10 || yDelta < 10)
    {
      result = 1;
    }
    else if (xDelta < 20 || yDelta < 20)
    {
      result = 2;
    }
    return result;
  }

  // --------------------------------------------------------------------------

//  static var totalBlockCount = 0;
//  static var bigBlockCount = 0;

  private function placeBlock(base : mapgen.Section) : Void
  {
//    ++totalBlockCount;
    var choice = 0;
    if (base.isNear(settings.getStart(), Option.hqInfluence))
    {
      choice = mapgen.Util.randWeightedIndex(Option.hqBlockDistribution);
    }
    else if (base.getSize().x >= 5 && base.getSize().y >= 5)
    {
//      ++bigBlockCount;
//      trace(base.getSize().toString());
      if (settings.getEasterEgg() == logic.GameSettings.MONROEVILLE)
      {
        choice = 3;
      }
      else
      {
        choice = mapgen.Util.randWeightedIndex(Option.largeBlockDistribution);
      }
    }
    else
    {
      choice = mapgen.Util.randWeightedIndex(Option.smallBlockDistribution);
    }
//    trace(Std.string(bigBlockCount) + " / " + Std.string(totalBlockCount));

    var placement : mapgen.BlockRoot = null;
    if (choice == 1)
    {
      placement = new mapgen.BlockPark();
    }
    else if (choice == 2)
    {
      placement = new mapgen.BlockChurch();
    }
    else if (choice == 3)
    {
      placement = new mapgen.BlockMall();
    }
    else if (choice == 4)
    {
      placement = new mapgen.BlockHouses();
    }
    else if (choice == 5)
    {
      placement = new mapgen.BlockApartment();
    }
    else
    {
      placement = new mapgen.BlockStandard();
    }
    placement.place(base);
  }

  // --------------------------------------------------------------------------

  function placeBridges(top : mapgen.Division, bottom : mapgen.Division) : Void
  {
    var bridgeDirs = [Direction.NORTH, Direction.SOUTH,
                      Direction.EAST, Direction.WEST];
    mapgen.Util.shuffle(bridgeDirs);

    var brokenCount = 4 - settings.getBridgeCount();
    if (settings.getEasterEgg() == logic.GameSettings.RACCOONCITY
        || settings.getEasterEgg() == logic.GameSettings.FIDDLERSGREEN)
    {
      brokenCount = 4;
    }
    var hqIndex = -1;
    if (brokenCount > 0
        && settings.getEasterEgg() != logic.GameSettings.FIDDLERSGREEN)
    {
      hqIndex = mapgen.Util.rand(brokenCount);
    }

    for (i in 0...4)
    {
      var lot = getBridgeLot(bridgeDirs[i], top, bottom);
      var itemPos = null;
      var dir = bridgeDirs[i];
      if (i == hqIndex)
      {
        itemPos = getHqPos(dir, top, bottom);
      }
      else
      {
        itemPos = getDynamitePos(dir, top, bottom);
      }
      var isBroken = (i < brokenCount);
      var isHq = (i == hqIndex);
      placeSingleBridge(lot, itemPos, mapgen.Util.opposite(dir),
                        isBroken, isHq);
    }

    if (hqIndex == -1)
    {
      placeHq(getCenterHqPos(top, bottom));
    }
  }

  function placeSingleBridge(lot : mapgen.Section, itemPos : Point,
                             bridgeDir : Direction, isBroken : Bool,
                             isHq : Bool) : Void
  {
    var placement = new mapgen.PlaceBridge(bridgeDir, isBroken);
    placement.place(lot);
    placement.intersectStreet(lot);
    var bridge = new logic.Bridge(bridgeDir, lot, isBroken);
    Game.progress.addBridge(bridge, isBroken);
    if (! isBroken)
    {
      var dynamite = new feature.Dynamite(itemPos, Option.dynamiteWork,
                                          bridge);
    }
    if (isHq)
    {
      if (! isBroken)
      {
        var realPos = new Point(itemPos.x + 1, itemPos.y);
        placeHq(realPos);
      }
      else
      {
        placeHq(itemPos);
      }
    }
  }

  function getBridgeLot(dir : Direction, top : mapgen.Division,
                        bottom : mapgen.Division) : mapgen.Section
  {
    var result = null;
    switch (dir)
    {
    case NORTH:
      result = new mapgen.Section(new Point(top.getLeft().limit.x - 1,
                                            top.getLeft().offset.y
                                              - waterCount - 2),
                                  new Point(top.getRight().offset.x + 1,
                                            top.getLeft().offset.y - 2));
      result.south = top.getLeft().north;
    case SOUTH:
      result = new mapgen.Section(new Point(bottom.getLeft().limit.x - 1,
                                            bottom.getLeft().limit.y + 2),
                                  new Point(bottom.getRight().offset.x + 1,
                                            bottom.getLeft().limit.y
                                              + waterCount + 2));
      result.north = bottom.getLeft().south;
    case EAST:
      result = new mapgen.Section(new Point(top.getRight().limit.x + 2,
                                            top.getRight().limit.y - 1),
                                  new Point(top.getRight().limit.x
                                              + waterCount + 2,
                                            bottom.getRight().offset.y + 1));
      result.west = top.getRight().east;
    case WEST:
      result = new mapgen.Section(new Point(top.getLeft().offset.x
                                              - waterCount - 2,
                                            top.getLeft().limit.y - 1),
                                  new Point(top.getLeft().offset.x - 2,
                                            bottom.getLeft().offset.y + 1));
      result.east = top.getLeft().west;
    }
    return result;
  }

  function getHqPos(dir : Direction, top : mapgen.Division,
                    bottom : mapgen.Division) : Point
  {
    var result = null;
    switch (dir)
    {
    case NORTH:
      result = new Point(top.getLeft().limit.x + mapgen.Util.rand(4),
                         top.getLeft().offset.y - 1);
    case SOUTH:
      result = new Point(bottom.getLeft().limit.x + mapgen.Util.rand(4),
                         bottom.getLeft().limit.y);
    case EAST:
      result = new Point(top.getRight().limit.x,
                         top.getRight().limit.y + mapgen.Util.rand(4));
    case WEST:
      result = new Point(top.getLeft().offset.x - 1,
                         top.getRight().limit.y + mapgen.Util.rand(4));
    }
    return result;
  }

  function getCenterHqPos(top : mapgen.Division,
                          bottom : mapgen.Division) : Point
  {
    var less = Math.floor(Math.min(top.getLeft().limit.x,
                                   bottom.getLeft().limit.x));
    var greater = Math.floor(Math.max(top.getRight().offset.x,
                                      bottom.getRight().offset.x));
    var x = Math.floor((less + greater)/2) - 1 + mapgen.Util.rand(3);
    var y = top.getRight().limit.y + 1 + mapgen.Util.rand(2);
    return new Point(x, y);
  }

  function getDynamitePos(dir : Direction, top : mapgen.Division,
                          bottom : mapgen.Division) : Point
  {
    var result = null;
    switch (dir)
    {
    case NORTH:
      result = new Point(top.getLeft().limit.x + mapgen.Util.rand(4),
                         top.getLeft().offset.y - 2);
    case SOUTH:
      result = new Point(bottom.getLeft().limit.x + mapgen.Util.rand(4),
                         bottom.getLeft().limit.y + 1);
    case EAST:
      result = new Point(top.getRight().limit.x + 1,
                         top.getRight().limit.y + mapgen.Util.rand(4));
    case WEST:
      result = new Point(top.getLeft().offset.x - 2,
                         top.getLeft().limit.y + mapgen.Util.rand(4));
    }
    return result;
  }

  private function placeHq(hqPos : Point) : Void
  {
    settings.setStart(hqPos);

    map.getCell(settings.getStart().x,
                settings.getStart().y).createTower(Tower.DEPOT);

    var hqTower = map.getCell(settings.getStart().x,
                              settings.getStart().y).getTower();

    var resources = [Resource.AMMO, Resource.BOARDS, Resource.SURVIVORS];
    var isLow = [false, false, false];
    for (i in 0...settings.getScarceCount())
    {
      isLow[i] = true;
    }
    mapgen.Util.shuffle(isLow);
    for (i in 0...Option.startingResources)
    {
      for (j in 0...(resources.length))
      {
        var give = true;
        if (isLow[j])
        {
          give = (i % 2 == 0);
        }
        if (give)
        {
          if (resources[j] == Resource.SURVIVORS)
          {
            var type = mapgen.Util.rand(ui.Animation.carryAmmo.getTypeCount());
            hqTower.giveSurvivor(type);
          }
          else
          {
            var resourceCount = new ResourceCount(resources[j],
                                                  Lib.truckLoad(resources[j]));
            hqTower.giveResource(resourceCount);
          }
        }
      }
    }
  }

  // --------------------------------------------------------------------------

  private function fillRandom(offset : Point, limit : Point,
                              tiles : Array<Int>, weights : Array<Int>) : Void
  {
    var trials = Math.floor((limit.x - offset.x)*(limit.y - offset.y)/3);
    for (i in 0...trials)
    {
      var x = mapgen.Util.rand(limit.x - offset.x) + offset.x;
      var y = mapgen.Util.rand(limit.y - offset.y) + offset.y;
      if (map.getCell(x, y).getTiles().length <= 1)
      {
        map.getCell(x, y).setBlocked();
        var choice = mapgen.Util.randWeightedIndex(weights);
        map.getCell(x, y).addTile(tiles[choice]);
      }
    }
  }

  // --------------------------------------------------------------------------

  private function placeZombies() : Void
  {
    for (building in map.getBuildings())
    {
      var count = 0;
      for (i in 0...(settings.getZombieMultiplier()))
      {
        count += mapgen.Util.rand(Option.zombieChance[building.getType()]);
      }
      placeBuildingZombies(building, count);
    }
  }

  // --------------------------------------------------------------------------

  private function placeBuildingZombies(building : Building,
                                        count : Int) : Void
  {
    if (! nearHq(building.getLots()))
    {
//      expandSize(offset, limit);
      building.addZombies(count);
/*
      var entrance = building.getEntrance();
      for (i in 0...count)
      {
//        var x = mapgen.Util.rand(limit.x - offset.x) + offset.x;
//        var y = mapgen.Util.rand(limit.y - offset.y) + offset.y;
        placeSingleZombie(entrance.x, entrance.y);
      }
*/
    }
  }

  // --------------------------------------------------------------------------

  private function nearHq(lots : List<mapgen.Section>) : Bool
  {
    var result = false;
    for (lot in lots)
    {
      if (lot.isNear(settings.getStart(), Option.hqInfluence))
      {
        result = true;
        break;
      }
    }
    return result;
  }

  // --------------------------------------------------------------------------

  private function placeSalvage() : Void
  {
    for (building in map.getBuildings())
    {
      var count = 0;
      for (i in 0...(settings.getResourceMultiplier()))
      {
        count += mapgen.Util.rand(Option.salvageChance[building.getType()]);
      }
      placeBuildingSalvage(building.getEntrance(), count, building);
    }
  }

  // --------------------------------------------------------------------------

  private function placeBuildingSalvage(entrance : Point, count : Int,
                                        building : Building) : Void
  {
    var biasResource = findBiasResource(entrance);
    for (i in 0...count)
    {
      var doBias = true;
#if NOFOOD
      doBias = false;
#end
      if (doBias && biasResource != null
          && mapgen.Util.rand(100) < Option.biasSalvage
          && (building.getType() == mapgen.Util.STANDARD
              || building.getType() == mapgen.Util.HOUSE))
      {
        mapgen.Util.placeSingleSalvage(map, entrance.x, entrance.y,
                                       biasResource);
      }
      else
      {
        mapgen.Util.placeSingleSalvage(map, entrance.x, entrance.y);
      }
    }
  }

  function findBiasResource(offset : Point) : Resource
  {
    for (i in 0...biasRegions.length)
    {
      if (biasRegions[i] == null)
      {
        trace(i);
      }
      if (biasRegions[i].contains(offset))
      {
        return Lib.indexToResource(i);
      }
    }
    return null;
  }

  // --------------------------------------------------------------------------

  private function box(offset : Point, limit : Point, color : Int)
  {
    Main.replay.addBox(offset, limit, color);
  }

  // --------------------------------------------------------------------------

  var map : Map;
  var settings : logic.GameSettings;
  var biasRegions : Array<mapgen.Section>;
}
