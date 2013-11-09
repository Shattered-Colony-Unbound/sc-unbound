package ui;

class Color
{
  public static var supplyDepotLine = 0x6666ff;
  public static var supplyOtherLine = 0xdddddd;
  public static var supplyInterruptedLine = 0xff6666;
  public static var supplyLineAlpha = 1.0;
  public static var supplyLineThickness = 10;

  public static var textBoxAlpha = 1.0;

  public static var toolTip = 0xffffaa;

  public static var fpsCounterBackground = 0xffffff;

  public static var announceForeground = 0xdddddd;
  public static var announceBackground = 0x400000;
  public static var countDownText = 0xdddddd;
  public static var countDownForeground = 0x400000;
  public static var countDownBackground = 0x404040;
  public static var countDownBorder = 0x000000;

  public static var menuTitle = 0xffffff;
  public static var menuBackground = 0x004000;
  public static var gameMenuAlpha = 1.0;
  public static var mainMenuAlpha = 0.4;
  public static var mainMenuBackdrop = 0x404040;
  public static var mainMenuBackdropAlpha = 1.0;
  public static var progressBarForeground = 0x007700;
  public static var progressBarBackground = 0x300000;
  public static var progressBarBorder = 0xffffff;
  public static var progressBarText = 0xffffff;

  public static var nameNoteText = 0xffffff;

  public static var centerGhost = 0x000000;
  public static var centerGhostAlpha = 0.85;

  public static var resourceBarText = 0x000000;
  public static var resourceBarBorder = 0xff303030;
  public static var resourceBarQuota = 0xff007700;
  public static var resourceBarOverflow = 0xff007777;

  public static var tutorialBackground = 0x000000;
  public static var tutorialAlpha = 0.8;
  public static var tutorialBorder = 0xffffff;

  public static var mouseLureOn = 0xff0000;
  public static var mouseLureOff = 0xffff00;

  // Button Colors
  public static var buttonBorder = 0x000000;
  public static var buttonBackground = 0x009999;
  public static var buttonRollOverBackground = 0x00ffff;
  public static var ghostedBackground = 0x999999;
  public static var inProgressBackground = 0x009900;
  public static var shouldClickBackground = 0x009900;
  public static var shouldClickRollOverBackground = 0x00ff00;
  public static var shouldAvoidBackground = 0x990000;
  public static var shouldAvoidRollOverBackground = 0xff0000;
  public static var toggledOnBackground = 0x999900;
  public static var toggledOnRollOverBackground = 0xffff00;

  // Shadow colors
  public static var shadowAllow = 0x00ff00;
  public static var shadowDeny = 0xff0000;
  public static var shadowBuild = 0x000000;
  public static var shadowAlpha = 0.3;
  public static var shadowPlanAlpha = 0.7;

//  public static var backgroundTransform =
//    new flash.geom.ColorTransform(0.9, 0.9, 0.9, 1.0,
//                                  0, 0, 0, 0);
  public static var normalTransform =
    new flash.geom.ColorTransform(1.0, 1.0, 1.0, 1.0,
                                  0, 0, 0, 0);
  public static var allowTransform =
    new flash.geom.ColorTransform(0.5, 1.5, 0.5, 2.0,
                                  0, 0, 0, 0);
  public static var denyTransform =
    new flash.geom.ColorTransform(1.5, 0.5, 0.5, 2.0,
                                  0, 0, 0, 0);
  public static var plannedTransform =
    new flash.geom.ColorTransform(0.6, 0.6, 0.6, 0.8,
                                  0, 0, 0, 0);

  public static var noShoot = 0xee0000;

  // Replay colors
  public static var depotReplay = 0x0000cc;
  public static var barricadeReplay = 0x6d4900;
  public static var workshopReplay = 0x80ffff;
  public static var sniperReplay = 0xcc0000;

  // Minimap colors
  public static var miniCursor = 0xaaaaaa;

  public static var allowEditBox = 0x008000;
  public static var denyEditBox = 0x800000;
  public static var editBoxBorder = 0x000000;

  public static var editSelected = 0x000000;
  public static var editEmpty = 0xffffff;
}
