package ui;

class Animation
{
  public static var carryAmmo : Animation = null;
  public static var carryBoards : Animation = null;
  public static var carryFood : Animation = null;
  public static var carrySurvivors : Animation = null;
  public static var fireRifle : Animation = null;
  public static var fireShotgun : Animation = null;
  public static var attackTower : Animation = null;
  public static var attackSurvivor : Animation = null;
  public static var zombieDeath : Animation = null;
  public static var zombieShamble : Animation = null;
  public static var headShot : Animation = null;
  public static var rubble : Animation = null;
  public static var feature : Animation = null;

  public static var animations : Array<Animation> = null;

  static var survivorAdvanceTable : Array<Int> = null;
  static var fireAdvanceTable : Array<Int> = null;

  // Move count distance units over count time units before advancing the frame.
  static function move(count : Int) : Int
  {
    return count;
  }

  // Wait count time units without moving before advancing the frame.
  static function wait(count : Int) : Int
  {
    return -count;
  }

  static function survivorAdvance() : Array<Int>
  {
    if (survivorAdvanceTable == null)
    {
      survivorAdvanceTable = [];
      for (i in 0...8)
      {
        survivorAdvanceTable.push(move(8));
      }
    }
    return survivorAdvanceTable;
  }

  static function fireAdvance() : Array<Int>
  {
    if (fireAdvanceTable == null)
    {
      fireAdvanceTable = [];
      for (i in 0...20/*44*/)
      {
        fireAdvanceTable.push(wait(1));
      }
    }
    return fireAdvanceTable;
  }

  static function attackTowerAdvance() : Array<Int>
  {
    var result = [];
    for (i in 0...60)
    {
      result.push(move(1));
    }
    return result;
  }

  static function attackSurvivorAdvance() : Array<Int>
  {
    var result = [];
    for (i in 0...72)
    {
      result.push(move(1));
    }
    return result;
  }

  public static var zombieDeathWait = 7;

  static function zombieDeathAdvance() : Array<Int>
  {
    var result = [];
    result.push(wait(zombieDeathWait));
    for (i in 0...27)
    {
      result.push(wait(1));
    }
    return result;
  }

  static function zombieShambleAdvance() : Array<Int>
  {
    var result = [];
    result.push(move(2));
    for (i in 0...5)
    {
      result.push(move(1));
      result.push(wait(1));
    }
    result.push(move(1));
    for (i in 0...6)
    {
      result.push(move(2));
      result.push(move(2));
    }
    return result;
  }

  static function headShotAdvance() : Array<Int>
  {
    var result = [];
    result.push(wait(zombieDeathWait));
    for (i in 0...5)
    {
      result.push(wait(1));
    }
    return result;
  }

  static var validSurvivors = [1, 2, 4, 5, 7, 8, 10, 11, 13, 14,
                               15, 16, 17, 18, 19, 20];

  static function linkageTable(prefix : String, suffix : String,
                               indexes : Array<Int>) : Array<String>
  {
    var table : Array<String> = [];
    for (i in indexes)
    {
      table.push(prefix + Std.string(i) + suffix);
    }
    return table;
  }

  public static var headLinkage = linkageTable("gunCycle_toplayer_", "",
                                               validSurvivors);
  public static var bodyLinkage = linkageTable("gunCycle_midlayer_", "",
                                               validSurvivors);
  public static var sniperScale = 1.0;

  static function survivorLinkage(payload : Int) : Array<String>
  {
    var table : Array<String> = [];
    var base = "Survivor_";
    for (i in validSurvivors)
    {
      table.push(base + Std.string(payload) + "_" + Std.string(i));
    }
    return table;
  }

  static function fireLinkage(gun : Int) : Array<String>
  {
    var table : Array<String> = [];
    var base = "gunCycle_";
    for (i in validSurvivors)
    {
      table.push(base + Std.string(i) + "_gun" + Std.string(gun));
    }
    return table;
  }

  static function zombieLinkage(action : String) : Array<String>
  {
    var table : Array<String> = [];
    var base = "zombieCycle_";
    for (i in 0...12)
    {
      table.push(base + action + "_" + Std.string(i+1));
    }
    return table;
  }

  static var mobileScale = 0.9;

  public static function init() : Void
  {
    carryAmmo = new Animation(32, survivorAdvance(), survivorLinkage(0),
                              SpriteDisplay.SURVIVOR_LAYER, 0);
    carryAmmo.scale = mobileScale;
    carryBoards = new Animation(32, survivorAdvance(), survivorLinkage(1),
                                SpriteDisplay.SURVIVOR_LAYER, 1);
    carryBoards.scale = mobileScale;
    carryFood = new Animation(32, survivorAdvance(), survivorLinkage(2),
                              SpriteDisplay.SURVIVOR_LAYER, 2);
    carryFood.scale = mobileScale;
    carrySurvivors = new Animation(32, survivorAdvance(), survivorLinkage(3),
                                   SpriteDisplay.SURVIVOR_LAYER, 3);
    carrySurvivors.scale = mobileScale;
    fireRifle = new Animation(20, fireAdvance(), fireLinkage(2),
                              SpriteDisplay.SNIPER_LAYER, 4);
    fireRifle.scale = sniperScale;
    fireRifle.doWait = true;
    fireShotgun = new Animation(20, fireAdvance(), fireLinkage(1),
                                SpriteDisplay.SNIPER_LAYER, 5);
    fireShotgun.scale = sniperScale;
    fireShotgun.doWait = true;
    attackTower = new Animation(60, attackTowerAdvance(),
                                zombieLinkage("attack"),
                                SpriteDisplay.CREATURE_LAYER, 6);
    attackTower.doReverse = true;
    attackTower.doFace = true;
    attackTower.doRotate = false;
    attackTower.scale = mobileScale;
    attackTower.doOffset = true;
    attackSurvivor = new Animation(72, attackSurvivorAdvance(),
                                   zombieLinkage("attack"),
                                   SpriteDisplay.CREATURE_LAYER, 7);
    attackSurvivor.scale = mobileScale;
    attackSurvivor.doFace = true;
    attackSurvivor.doRotate = false;
    attackSurvivor.scale = mobileScale;
    attackSurvivor.doOffset = true;
    zombieDeath = new Animation(34, zombieDeathAdvance(),
                                zombieLinkage("death"),
                                SpriteDisplay.CREATURE_LAYER, 8);
    zombieDeath.doWait = true;
    zombieDeath.scale = mobileScale;
    zombieDeath.doOffset = true;
    zombieShamble = new Animation(32, zombieShambleAdvance(),
                                  zombieLinkage("shamble"),
                                  SpriteDisplay.CREATURE_LAYER, 9);
    zombieShamble.scale = mobileScale;
    headShot = new Animation(12, headShotAdvance(), ["zombie_headshot"],
                             SpriteDisplay.SURVIVOR_LAYER, 10);
    headShot.doWait = true;
    headShot.doOffset = true;
    rubble = new Animation(1, [wait(1)], ["RubbleClip"],
                           SpriteDisplay.FLOOR_LAYER, 11);
    feature = new Animation(1, [wait(1)], ["FeatureClip"],
                            SpriteDisplay.FLOOR_LAYER, 12);

    animations = [carryAmmo, carryBoards, carryFood, carrySurvivors,
                  fireRifle, fireShotgun, attackTower, attackSurvivor,
                  zombieDeath, zombieShamble, headShot, rubble, feature];
  }

  public static function carry(payload : Resource) : Animation
  {
    var result = null;
    switch(payload)
    {
    case AMMO:
      result = carryAmmo;
    case BOARDS:
      result = carryBoards;
    case FOOD:
      result = carryFood;
    case SURVIVORS:
      result = carrySurvivors;
    }
    return result;
  }

  function new(newMoveCount : Int, newAdvance : Array<Int>,
               newLinkage : Array<String>, newLayer : Int,
               newNumber : Int) : Void
  {
    moveCount = newMoveCount;
    advance = newAdvance;
    linkage = newLinkage;
    layer = newLayer;
    doReverse = false;
    doFace = false;
    doRotate = true;
    doWait = false;
    scale = 1.0;
    number = newNumber;
    doOffset = false;
  }

  public function getMoveCount() : Int
  {
    return moveCount;
  }

  public function getMove(frame : Int) : Int
  {
    var result = 0;
    if (advance[frame] > 0)
    {
      result = advance[frame];
    }
    return result;
  }

  public function getWait(frame : Int) : Int
  {
    var result = 0;
    if (advance[frame] < 0)
    {
      result = -advance[frame];
    }
    return result;
  }

  public function getFrameCount() : Int
  {
    return advance.length;
  }

  public function getLinkage(type : Int) : String
  {
    return linkage[type];
  }

  public function getTypeCount() : Int
  {
    return linkage.length;
  }

  public function getLayer() : Int
  {
    return layer;
  }

  public function shouldReverse() : Bool
  {
    return doReverse;
  }

  public function shouldFace() : Bool
  {
    return doFace;
  }

  public function shouldRotate() : Bool
  {
    return doRotate;
  }

  public function shouldWait() : Bool
  {
    return doWait;
  }

  public function getScale() : Float
  {
    return scale;
  }

  public function getNumber() : Int
  {
    return number;
  }

  public function shouldOffset() : Bool
  {
    return doOffset;
  }

  var moveCount : Int;
  var advance : Array<Int>;
  var linkage : Array<String>;
  var layer : Int;
  // Should the sprite run halfway and then reverse rather than going
  // all the way through? Default: false
  var doReverse : Bool;
  // Should the sprite turn to face the destination before
  // moving/animating? Default: false
  var doFace : Bool;
  // Should the sprite turn to face the next movement step while
  // moving/animating? Default: true
  var doRotate : Bool;
  // Should the sprite wait for moveCount time units rather than move
  // moveCount spaces? Default: false
  var doWait : Bool;
  var scale : Float;
  var number : Int;
  var doOffset : Bool;
}
