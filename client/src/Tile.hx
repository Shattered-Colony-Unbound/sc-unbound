class Tile
{
  // --------------------------------------------------------------------------
  // Road Tiles
  // --------------------------------------------------------------------------
  public static var BEGIN = 0;
  public static var MIDDLE = 1;
  public static var END = 2;

  public static var roadVertical = [0, 20, 40];
  public static var alleyVertical = [13, 33, 53];
  public static var verticalFactor = 1;

  public static var roadHorizontal = [10, 11, 12];
  public static var alleyHorizontal = [17, 18, 19];
  public static var horizontalFactor = 20;

  public static var alley = 0;
  public static var twoLaneLeft = 1;
  public static var twoLaneRight = 2;
  /* Roads more than two tiles wide can be represented as the following tiles:
     A B* C D E* F (for even numbers)
     A B* G E* F (for odd numbers)

     Where A and F are the two sidewalk tiles, B and E are
     double-white lane tiles, and either C and D or E form the median.
  */
  public static var multiLaneA = 3;
  public static var multiLaneB = 4;
  public static var multiLaneC = 5;
  public static var multiLaneD = 6;
  public static var multiLaneE = 7;
  public static var multiLaneF = 8;
  public static var multiLaneG = 9;

  public static var alleyCrossTwoLeft = 0;
  public static var alleyCrossTwoRight = 1;
  public static var alleyCrossMultiLeft = 2;
  public static var alleyCrossMultiRight = 3;

  public static var nwCurve = 81;
  public static var neCurve = 83;
  public static var swCurve = 121;
  public static var seCurve = 123;

  public static var fadeFromNorth = 178;
  public static var fadeFromWest = 197;
  public static var fadeFromEast = 199;
  public static var fadeFromSouth = 218;

  public static var nwCornerFadeBoth = 177;
  public static var neCornerFadeBoth = 179;
  public static var swCornerFadeBoth = 217;
  public static var seCornerFadeBoth = 219;
  public static var centerRoad = 198;

  public static var fadeNorthWalkWest = 73;
  public static var fadeNorthWalkEast = 74;
  public static var fadeNorthAlleyWest = 75;
  public static var fadeNorthAlleyEast = 76;
  public static var walkWest = 93;
  public static var walkEast = 94;
  public static var alleyWest = 95;
  public static var alleyEast = 96;
  public static var fadeSouthWalkWest = 113;
  public static var fadeSouthWalkEast = 114;
  public static var fadeSouthAlleyWest = 115;
  public static var fadeSouthAlleyEast = 116;
  public static var fadeWestWalkNorth = 97;
  public static var fadeWestWalkSouth = 117;
  public static var fadeWestAlleyNorth = 137;
  public static var fadeWestAlleySouth = 157;
  public static var walkNorth = 98;
  public static var walkSouth = 118;
  public static var alleyNorth = 138;
  public static var alleySouth = 158;
  public static var fadeEastWalkNorth = 99;
  public static var fadeEastWalkSouth = 119;
  public static var fadeEastAlleyNorth = 139;
  public static var fadeEastAlleySouth = 159;

  public static var seCornerFadeSouth = 154;
  public static var neCornerFadeNorth = 134;
  public static var swCornerFadeSouth = 153;
  public static var nwCornerFadeNorth = 133;
  public static var neCornerFadeEast = 136;
  public static var nwCornerFadeWest = 135;
  public static var seCornerFadeEast = 156;
  public static var swCornerFadeWest = 155;

  // --------------------------------------------------------------------------
  // Park Tiles
  // --------------------------------------------------------------------------
  public static var nwPark = 66;
  public static var nPark = 67;
  public static var nePark = 68;
  public static var wPark = 86;
  public static var centerPark = 87;
  public static var ePark = 88;
  public static var swPark = 106;
  public static var sPark = 107;
  public static var sePark = 108;

  public static var parkTiles =
    [Tile.nwPark, Tile.nPark, Tile.nePark,
     Tile.wPark, Tile.centerPark, Tile.ePark,
     Tile.swPark, Tile.sPark, Tile.sePark];

  // --------------------------------------------------------------------------
  // Water Tiles
  // --------------------------------------------------------------------------
  public static var nwBeach = 60;
  public static var nBeachToDark = 61;
  public static var nBeachDark = 62;
  public static var nBeachFromDark = 63;
  public static var nBeach = 64;
  public static var neBeach = 65;
  public static var wBeach = 80;
  public static var wBeachToDark = 100;
  public static var wBeachDark = 120;
  public static var wBeachFromDark = 140;
  public static var eBeachToDark = 85;
  public static var eBeachDark = 105;
  public static var eBeachFromDark = 125;
  public static var eBeach = 145;
  public static var swBeach = 160;
  public static var sBeach = 161;
  public static var sBeachToDark = 162;
  public static var sBeachDark = 163;
  public static var sBeachFromDark = 164;
  public static var seBeach = 165;

  public static var nwShallows = 126;
  public static var nShallows = 127;
  public static var neShallows = 128;
  public static var wShallows = 146;
  public static var eShallows = 148;
  public static var swShallows = 166;
  public static var sShallows = 167;
  public static var seShallows = 168;

  public static var nShallowShore = 188;
  public static var sShallowShore = 208;
  public static var wShallowShore = 175;
  public static var eShallowShore = 176;

  public static var deepWater = 147;

  public static var lakes = [69, 89, 109, 129];
  public static var rocks = [149, 169, 189, 209];
  public static var trees = [440, 441, 445, 446, 580, 581, 585, 586];

  public static var obstacles = [trees, rocks, lakes];

  public static var OBSTACLE_START = 0;
  public static var OBSTACLE_LAKE = 2;

  public static var edgeRoof =
    [
      // North
      [1021, 1024, 1025, 1026, 1027, 1029, 1043, 1047, 1048,
       1049, 1050, 1051, 1060, 1061, 1080, 1081],
      // South
      [1023, 1024, 1025, 1026, 1027, 1031, 1041, 1045, 1048,
       1049, 1050, 1051, 1060, 1061, 1080, 1081],
      // East
      [1022, 1024, 1025, 1026, 1027, 1030, 1040, 1044, 1048,
       1049, 1050, 1051, 1060, 1061, 1080, 1081],
      // West
      [1020, 1024, 1025, 1026, 1027, 1028, 1042, 1046, 1048,
       1049, 1050, 1051, 1060, 1061, 1080, 1081]
    ];

  public static var cornerRoof =
    [1024, 1025, 1026, 1027, 1048, 1049, 1050, 1051, 1060, 1061, 1080, 1081];

  public static var centerRoof =
    [1020, 1021, 1022, 1023, 1024, 1025, 1026, 1027, 1028, 1029, 1030,
     1031, 1040, 1041, 1042, 1043, 1044, 1045, 1046, 1047, 1048, 1049,
     1050, 1051, 1060, 1061, 1080, 1081];

  public static var nBridgeLess = 186;
  public static var nBridgeGreater = 187;
  public static var sBridgeLess = 206;
  public static var sBridgeGreater = 207;
  public static var wBridgeLess = 293;
  public static var wBridgeGreater = 313;
  public static var eBridgeLess = 294;
  public static var eBridgeGreater = 314;
/*
  public static var nBrokenBridgeLess = 180;
  public static var nBrokenBridgeA = 181;
  public static var nBrokenBridgeC = 182;
  public static var nBrokenBridgeD = 183;
  public static var nBrokenBridgeF = 184;
  public static var nBrokenBridgeGreater = 185;
*/
  public static var nBrokenBridge = 180;
  public static var sBrokenBridge = 200;
  public static var wBrokenBridge = 173;
  public static var eBrokenBridge = 174;

  public static var EDGE = 1066;

  public static var X_COUNT = 20;
  public static var Y_COUNT = 65;

  public static var NO_TILE = -1;
}
