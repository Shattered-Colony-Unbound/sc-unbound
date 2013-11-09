class Option
{
  public static var fps = 20;
#if TEST_LOAD
  public static var startingResources = 100;
#else
  public static var startingResources = 30;
#end
  public static var foodTransportCost = 2;
  public static var foodShootCost = 2;
//  public static var foodBoost = 2;

  public static var resourceCount = 4;
  public static var colorCount = 3;

  // Map
  public static var tileCells = 3;
  public static var cellPixels = 32;
  public static var halfCell = 16;

  // Map generation parameters
#if NOFOOD
  public static var salvageDistribution = [
    //                    ammo, boards, food, survivors
    /* Standard */       [  50,     28,   0,        16],
    /* Apartment     */  [  50,     28,   0,        16],
    /* Supermarket */    [   2,      2,   0,         2],
    /* Police Station */ [  94,      2,   0,         2],
    /* Hardware Store */ [   2,     94,   0,         2],
    /* Church */         [   2,      2,   0,        94],
    /* Hospital */       [  60,     33,   0,         1],
    /* Mall */           [  50,     28,   0,        16],
    /* House */          [  60,     40,   0,        10],
    /* Parking Lot */    [   1,      1,   0,         1]];
#else
  public static var salvageDistribution = [
    //                    ammo, boards, food, survivors
    /* Standard */       [  28,     28,   28,        16],
    /* Apartment     */  [  28,     28,   28,        16],
    /* Supermarket */    [   2,      2,   94,         2],
    /* Police Station */ [  94,      2,    2,         2],
    /* Hardware Store */ [   2,     94,    2,         2],
    /* Church */         [   2,      2,    2,        94],
    /* Hospital */       [  33,     33,   33,         1],
    /* Mall */           [  28,     28,   28,        16],
    /* House */          [  35,     40,   15,        10],
    /* Parking Lot */    [   1,      1,    1,         1]];
#end
  public static var biasSalvage = 20;

#if NOFOOD
  public static var groundSalvageDistribution = [
//  ammo, boards, food, survivors
    50,   50,     0,   0];
#else
  public static var groundSalvageDistribution = [
//  ammo, boards, food, survivors
    60,   20,     20,   0];
#end

  public static var buildingDistribution = [
    /* Standard */       70,
    /* Apartment */       8,
#if NOFOOD
    /* Supermarket */     0,
#else
    /* Supermarket */     4,
#end
    /* Police Station */  4,
    /* Hardware Store */  4,
    /* Church */          0,
    /* Hospital */        4,
    /* Mall   */          0,
    /* House */           0,
    /* Parking Lot */     2];

  // Distribution for buildings near the HQ.
  public static var hqBuildingDistribution = [
    /* Standard */       98,
    /* Apartment */       0,
    /* Supermarket */     0,
    /* Police Station */  0,
    /* Hardware Store */  0,
    /* Church */          0,
    /* Hospital */        0,
    /* Mall   */          0,
    /* House */           0,
    /* Parking Lot */     2];

  public static var salvageChance = [
    /* Standard */        4,
    /* Apartment */       8,
    /* Supermarket */    16,
    /* Police Station */ 16,
    /* Hardware Store */ 16,
    /* Church */         16,
    /* Hospital */        4,
    /* Mall */           16,
    /* House */           3,
    /* Parking Lot */     1];

  public static var zombieChance = [
    /* Standard */       3,
    /* Apartment */      5,
    /* Supermarket */    9,
    /* Police Station */ 9,
    /* Hardware Store */ 9,
    /* Church */         9,
    /* Hospital */      12,
    /* Mall */          10,
    /* House */          2,
    /* Parking Lot */    1];

  public static var smallBlockDistribution = [
    /* Normal */    70,
    /* Park */      10,
    /* Church */     0,
    /* Mall */       0,
    /* House */     20,
    /* Apartment */  0];

  public static var largeBlockDistribution = [
    /* Normal */    71,
    /* Park */       5,
    /* Church */     4,
    /* Mall */       4,
    /* House */      6,
    /* Apartment */  6];

  // Distribution for blocks near HQ.
  public static var hqBlockDistribution = [
    /* Normal */    85,
    /* Park */       5,
    /* Church */     0,
    /* Mall */       0,
    /* House */     10,
    /* Apartment */  0];

  public static var blockThreshold = 12;
  public static var buildingThreshold = 5;

  public static var hqInfluence = 11;

  public static var minHouseSize = 2;
  public static var minGenericSize = 3;

  public static var countDownTextColor = 0x00cccc;
  public static var countDownBackgroundColor = 0x330000;
  public static var announceFrameCount = fps*2;

  // Noise in cells
  public static var explosionNoise = 15;
  public static var shootNoise = 10;
  public static var buildNoise = 4;
  public static var truckNoise = 2;
  public static var towerNoise = 3;

  public static var soundCount = 8;

  // Chance to disturb a zombie in a building per cell
  public static var disturbChance = 4;

  public static var barricadeHitCost = 1;
  public static var shootCost = 1;
  public static var foodTime = 300;

  public static var truckLoad = 10;
  public static var moderateResource = 10;
  public static var lowResource = 5;
  public static var maxTruckWait = 50;
  public static var truckLook = 2; // In squares
  public static var truckRetries = 2;

  public static var hqIndustryFactor = truckLoad;
  public static var hqIndustryTime = 60*15;

  public static var gardenTime = 10;

  //                                       ammo, boards, food, survivors
  public static var barricadeMaxInit =    [   0,     15,   0,         0];
  public static var sniperMaxInit =       [  15,      0,   0,         1];
  public static var depotMaxInit =        [  40,     40,   30,        4];
  public static var workshopMaxInit =     [  10,     10,   10,        2];

  public static var barricadeMaxUpgrade = [   0,     10,   0,         0];
  public static var sniperMaxUpgrade =    [   5,      0,   0,         0];
  public static var depotMaxUpgrade =     [  30,     30,   10,        3];
  public static var workshopMaxUpgrade =  [   0,      0,    0,        0];

//  public static var stuffInit = [
//    //                ammo, boards, food, survivors
//    /* barricade */  [   0,      0,    0,         0],
//    /* sniper */     [   0,      0,    0,         0],
//    /* depot */      [   0,      0,    0,         0],
//    /* hq */         [   0,      0,    0,         0],
//    /* workshop */   [   0,      0,    0,         0]];
//
//  public static var stuffMaxInit = [
//    //                ammo, boards, food, survivors
//    /* barricade */  [   0,     20,   20,         1],
//    /* sniper */     [  20,      0,   20,         1],
//    /* depot */      [  30,     30,   30,         3],
//    /* hq */         [   0,      0,    0,         0],
//    /* workshop */   [  20,     20,   20,         2]];
//
//  public static var stuffMaxUpgrade = [
//    //                ammo, boards, food, survivors
//    /* barricade */  [   0,     10,   10,         1],
//    /* sniper */     [  10,      0,   10,         1],
//    /* depot */      [  20,     20,   20,         2],
//    /* hq */         [   0,      0,    0,         1],
//    /* workshop */   [  10,     10,   10,         1]];

  //                                    barricade sniper depot   hq workshop
//  public static var speedInit =       [      25,   100,   50, 100,     100];
//  public static var speedUpgrade =    [       5,    10,   10,   0,       0];

//  public static var speed = [
//    // barricade, sniper, depot,  hq, workshop
//    [         10,     50,   100, 150, 3*truckLoad],
//    [         11,     60,   110, 150, 6*truckLoad],
//    [         12,     70,   120, 150, 6*truckLoad]];

  public static var barricadeSpeed = [50, 50, 50];
//  public static var sniperSpeed =    [60, 85, 120];
//  public static var sniperSpeed = [60, 108, 180];
  public static var sniperSpeed = [150, 150, 150];
  public static var depotSpeed =     [150, 150, 150];
#if TEST_LOAD
  public static var hqSpeed = [5000, 5000, 5000];
#else
  public static var hqSpeed =        [200, 200, 200];
#end
  public static var workshopSpeed =  [4*truckLoad, 4*truckLoad, 8*truckLoad];
  public static var workshopSpeedFactor = 50;

#if TEST_LOAD
  public static var returnTruckSpeedMin = 1;//200;
  public static var returnTruckSpeedRange = 10;//150;
#else
  public static var returnTruckSpeedMin = 300;
  public static var returnTruckSpeedRange = 225;
#end

#if TEST_LOAD
  public static var foodTruckSpeedMin = 200;
#else
  public static var foodTruckSpeedMin = 750;
#end
  public static var foodTruckSpeedRange = 75;

#if TEST_LOAD
  public static var depotTruckSpeedMin = [100, 150, 150];
#else
  public static var depotTruckSpeedMin = [200, 225, 450];
#end
  public static var depotTruckSpeedRange = [200, 75, 150];

#if TEST_LOAD
  public static var truckSpeedMin = 100;
#else
  public static var truckSpeedMin = 300;
#end
  public static var truckSpeedRange = 100;
  public static var zombieSpeedRange = 50;

  public static var supplyRange = 7;

  // In truckloads of boards
  // Delta of build/upgrade to level 0, 1, 2
  public static var barricadeCost = [0, 1, 1];
  public static var sniperCost =    [0, 1, 1];
  public static var depotCost =     [0, 3, 3];
  public static var hqCost =        [0, 0, 0];
  public static var workshopCost =  [0, 1, 0];

  public static var sniperBuildCost = 2;

  public static var barricadeLevelLimit = 0;
  public static var sniperLevelLimit = 2;
  public static var depotLevelLimit = 0;
  public static var hqLevelLimit = 0;
  public static var workshopLevelLimit = 0;

  // Sniper Tower only
//  public static var sniperAccuracy = [30, 42, 60];
  public static var sniperAccuracy = [30, 30, 30];
  public static var sniperRange = [4, 6, 9];

  public static var sniperIdleMin = 50;
  public static var sniperIdleRange = 500;

  public static var foodBonus = 24;
  public static var vulnerableBonus = 49;
#if NOFOOD
  public static var survivorBonus = 7;
#else
  public static var survivorBonus = 6;
#end
  public static var survivorFoodBonus = 3;

  // Barricade only
  public static var barricadeHits = [10, 15, 20];

  //                                    barricade sniper depot   hq workshop
/*
  public static var speedInit =         [      10,    50,  100, 150, 3*truckLoad];
  public static var speedUpgrade =      [       1,    10,   10,   0, 6*truckLoad];

  public static var accuracyInit =      [       0,    30,    0,   0,       0];
  public static var accuracyUpgrade =   [       0,     0,    0,   0,       0];

  public static var rangeInit =         [       0,     5,    0,   0,       0];
  public static var rangeUpgrade =      [       0,     1,    0,   0,       0];
  public static var accurateSpeedFactor = 1.0;
  public static var accurateAccuracyFactor = 1.0;
  public static var accurateRangeFactor = 1.0;
  public static var recklessSpeedFactor = 3.0;
  public static var recklessAccuracyFactor = 0.5;
  public static var recklessRangeFactor = 0.6;

  public static var hitsInit =          [      10,     1,    1,   1,       1];
  public static var hitsUpgrade =       [       5,     0,    0,   0,       0];
*/
  public static var normalRecklessDistance = 3;
//  public static var levelUpgrade =      [       1,     1,    1,   0,       1];
//  public static var levelLimit =        [       2,     2,    2,   0,       1];

  public static var accuracyMax = 100;

  public static var rotateStep = 5; // in degrees
  public static var sniperHeadRotate = 15;
  public static var sniperBodyRotate = 10;
  public static var frameDelay = 75;
  public static var startDelay = fps * frameDelay;
  public static var waitDelay = fps * frameDelay;

  public static var maxPathOperations = 200;

  public static var wanderingZombieDelay = fps*150;
public static var tutorialWanderingZombieDelay = fps*(150-20);
//  public static var wanderingZombieDelay = fps*30;
  public static var wanderingZombieBase = 10;
  public static var wanderingZombieIncrement = 2;
//  public static var wanderingZombieBase = 20;

  public static var spawnReplayColor = 0xcccccc;
  public static var depotMiniColor = 0xff0000ff;
  public static var barricadeMiniColor = 0xff6d4900;
  public static var workshopMiniColor = 0xff80ffff;

  public static var miniSupplyThickness = 0;
  public static var miniSupplyColor = 0xffffff;

  public static var unknownColor = 0x97694F; // 'Dark Tan'
  public static var zombieMiniColor = 0xffff8080;
  public static var selectedMiniColor = 0xffffffff;
  public static var towerMiniColor = 0xff00ff00;
  public static var truckMiniColor = 0xff008800;

//  public static var zombieBuildingMiniWeights = [4, 6, 20000000];
//  public static var zombieBuildingMiniColor = [0xd5d500, 0xd58a00, 0xd50000];
  public static var zombieBuildingMiniWeights = [1];
  public static var zombieBuildingMiniColor = [0x770000];

  public static var emptyBuildingMiniColor = 0x333333; // 6a6a6a
  public static var waterColor = 0x000066; // 0x0000d5
  public static var roadMiniColor = 0x000000;

  public static var shadowAllowColor = 0x00ff00;
  public static var shadowDenyColor = 0xff0000;
  public static var shadowBuildColor = 0x000000;
  public static var shadowOpacity = 0.3;
  public static var towerShadowOpacity = 0.7;

  public static var barLength = 25;
  public static var barLeft = Math.floor((cellPixels - barLength) / 2);
/*
  public static var ammoBarColor = 0x000000;
  public static var boardBarColor = 0x774400;//(109 << 16) + (73 << 8);
  public static var foodBarColor = 0x000077;//(255 << 16) + (30 << 8) + 30;
  public static var hitsBarColor = 0x007700;
  public static var fullBarColor = 0xff7777;
  public static var backgroundBarColor = 0x777777;
*/
  public static var ammoBarColor = 0xcccccc;
  public static var boardBarColor = 0x87421F;
  public static var foodBarColor = 0x0000cc;
  public static var hitsBarColor = 0x00cc00;
  public static var fullBarColor = 0x331111;
  public static var backgroundBarColor = 0x333333;

  public static var barThickness = 4;
  public static var noBar = -1;

  public static var noShootColor = 0xee0000;
  public static var supplyTargetColor = 0x0000ee;
  public static var supplyTargetThickness = 2;
  public static var supplyTargetLength = 32;
  public static var supplyArrowLength = 8;
  public static var supplyArrowAngle = Math.PI / 5;

  //                                         Zombies in Building
  public static var zombieBuildingWeights = [4, 6, 20000000];
  public static var zombieBuildingColor = [0xd5d500, 0xd58a00, 0xd50000];
//  public static var zombieBuildingColor = [0xffff00, 0xff7f00, 0xff0000];
  public static var zombieBuildingOpacity = [0.3, 0.3, 0.3];
  public static var salvageBuildingColor = 0xaaffaa;
  public static var salvageBuildingOpacity = 0.3;

  // Select parameters
  public static var selectThickness = 5;
  public static var selectColor = 0x00aa00;
  public static var supplyThickness = 0;
  public static var supplyColor = 0x0000ff;
  public static var rangeOpacityIncrement = 0.08;
  public static var rangeOpacity = 0.3;
  public static var rangeColor = 0x00aaaa;
  public static var shadowRangeOpacity = 0.3;
  public static var shadowRangeColor = 0xaaaaaa;
  public static var newRangeOpacity = 0.3;
  public static var newRangeColor = 0x00aaaa;

  public static var menuBackgroundColor = 0x202020;
  public static var redMenuColor = 0x400000;
  public static var greenMenuColor = 0x004000;
  public static var textButtonCount = 4;
  public static var buildButtonCount = 4;
  public static var abandonButtonCount = 1;
  public static var extraButtonCount = 2;
  public static var menuButtonCount = textButtonCount + buildButtonCount
    + abandonButtonCount + extraButtonCount;
  public static var abandonButton = textButtonCount + buildButtonCount;
  public static var toggleViewButton = abandonButton + 1;
  public static var jumpToDepotButton = toggleViewButton + 1;

  public static var statusTextColor = 0xeeeeee;
  public static var toolTipTitleColor = 0xffffff;
  public static var toolTipTextColor = 0xdddddd;
  public static var hqStatusTextColor = 0xcc7777;
  public static var hqBackgroundColor = 0x000000;

  public static var mainTitleTextColor = 0xeeeeee;
  public static var mainBodyTextColor = 0xaaaaaa;

  public static var zombieThreatTextColor = 0xff3333;
  public static var zombieNoThreatTextColor = 0x33ff33;

  public static var toolTipDelay = 5;

  public static var dynamiteWork = 100;

  // Keyboard
  public static var repeatWait = 1; // in frames

  public static var fastFrames = 5;

  public static var statusBarSize = 110;

  // Spawning/dying
  public static var spawnFrameCount = 50;
  public static var survivorDeathFrameCount = 50;

  // Reverse order
  public static var danceMoves = [0, 360, 220, 80, -80, 80, -80, 80];
  public static var dancePeriod = 1200;
}
