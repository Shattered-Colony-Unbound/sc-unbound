package ui;

class Text
{
public static var toolTipStyleSheet =
"p { "
+ "font-size: 14; "
+ "color: #333333 "
+ "} "
+ ".title { "
+ "font-size: 16; "
+ "font-weight: bold; "
+ "color: #000000 "
+ "} "
+ ".hotkey { "
+ "color: #0000ff "
+ "} "
+ ".status { "
+ "color: #008888 "
+ "} "
+ ".survivor { "
+ "color: #008800 "
+ "} "
+ ".cost { "
+ "color: #ff0000 "
+ "} "
;
public static var tutorialStyleSheet =
"p { "
+ "font-size: 12; "
+ "color: #ffffff "
+ "} "
+ ".title { "
+ "font-size: 14; "
+ "font-weight: bold; "
+ "color: #ffff00 "
+ "} "
+ "a { "
+ "font-size: 12; "
+ "text-decoration: underline; "
+ "color: #ffaaaa "
+ "} "
;
public static var buttonStyleSheet =
".hotkey { "
+ "color: #dd0000 "
+ "} "
+ ".status { "
+ "color: #0000dd "
+ "} "
;
public static var pediaStyleSheet =
"p { "
+ "font-size: 18; "
+ "color: #dddddd; "
+ "} "
+ "a { "
+ "font-size: 18; "
+ "text-decoration: underline; "
+ "color: #aaaaff; "
+ "} "
+ ".title { "
+ "font-size: 24; "
+ "font-weight: bold; "
+ "text-align: center; "
+ "color: #ffffff; "
+ "} "
;
public static var mainNameDefaultInputText =
"Anytown "
;

public static var replaySpeedBarLabel =
"Speed "
;

public static var unpauseTip =
"<p>"
+ "<span class=\"title\">"
+ "Resume Game <span class=\"hotkey\">[Space]</span>"
+ "</span>\n"
+ "Click to resume the game. "
+ "</p>"
;

public static var pauseTip =
"<p>"
+ "<span class=\"title\">"
+ "Pause Game <span class=\"hotkey\">[Space]</span>"
+ "</span>\n"
+ "Click to pause the game. You can still select structures and issue orders while paused. "
+ "</p>"
;

public static var hideRangeTip =
"<p>"
+ "<span class=\"title\">"
+ "Hide Range <span class=\"hotkey\">V</span>iew"
+ "</span>\n"
+ "Hide the global range view. "
+ "</p>"
;

public static var showRangeTip =
"<p>"
+ "<span class=\"title\">"
+ "Show Range <span class=\"hotkey\">V</span>iew"
+ "</span>\n"
+ "Show global range view. The range of every sniper tower will be "
+ "shown with a white overlay. "
+ "</p>"
;

public static var jumpToDepotTip =
"<p>"
+ "<span class=\"title\">"
+ "<span class=\"hotkey\">J</span>ump to Depot"
+ "</span>\n"
+ "Select the nearest depot and center it in the window. "
+ "</p>"
;

public static var systemTip =
"<p>"
+ "<span class=\"title\">"
+ "System Menu<span class=\"hotkey\">[Esc]</span>"
+ "</span>\n"
+ "Save, set options, restart, or quit. "
+ "</p>"
;

public static var toggleTipTip =
"<p>"
+ "<span class=\"title\">"
+ "Toggle Tooltips <span class=\"hotkey\">[?]</span>"
+ "</span>\n"
+ "Click here to turn off tool tips like this one. "
+ "</p>"
;

public static var fleeTip =
"<p>"
+ "<span class=\"title\">"
+ "Flee <span class=\"hotkey\">[Del]</span>"
+ "</span>\n"
+ "Abandon this structure and flee for safety, leaving behind any "
+ "resources. They may be recovered later with a workshop. "
+ "</p>"
;

public static var noFleeTip =
"<p>"
+ "<span class=\"title\">"
+ "Cannot Flee "
+ "</span>\n"
+ "This is your last depot. There can be no further retreat from this structure. "
+ "</p>"
;

public static var addSupplyTip =
"<p>"
+ "<span class=\"title\">"
+ "<span class=\"hotkey\">A</span>dd Supply Line"
+ "</span>\n"
+ "Click here to create a supply line to another structure. The two structures "
+ "will send resources to each other as needed. "
+ "</p>"
;

public static var backgroundAddSupplyTip =
"<p>"
+ "<span class=\"title\">"
+ "How To Add "
+ "</span>\n"
+ "Move the mouse to the structure you want to add a supply line to and "
+ "click it, or press escape to cancel. "
+ "</p>"
;

public static var towerAddSupplyTip =
"<p>"
+ "<span class=\"title\">"
+ "Add Supply Line "
+ "</span>\n"
+ "If you click here, a new supply line will be created. You may press "
+ "escape to cancel. "
+ "</p>"
;

public static var towerAlreadyExistsAddSupplyTip =
"<p>"
+ "<span class=\"title\">"
+ "Supply Line Already Exists "
+ "</span>\n"
+ "You cannot add a supply line here because the source depot already "
+ "has a supply line to this structure. You may press escape to cancel. "
+ "</p>"
;

public static var towerSameTowerAddSupplyTip =
"<p>"
+ "<span class=\"title\">"
+ "Source Depot "
+ "</span>\n"
+ "A structure can't have a supply line to itself. You may press escape to cancel. "
+ "</p>"
;

public static var removeSupplyTip =
"<p>"
+ "<span class=\"title\">"
+ "<span class=\"hotkey\">R</span>emove Supply Line"
+ "</span>\n"
+ "Remove the supply line from this depot to another structure. After "
+ "removing the supply line, no new survivors will be sent to carry "
+ "resources between the two structures. "
+ "</p>"
;

public static var gatherResourcesTip =
"<p>"
+ "<span class=\"title\">"
+ "Gather Resources "
+ "</span>\n"
+ "For a short time, gather nearby unallocated resources to this depot. "
+ "Click multiple times to increase the range and effect. "
+ "</p>"
;

public static var backgroundRemoveSupplyTip =
"<p>"
+ "<span class=\"title\">"
+ "How To Remove "
+ "</span>\n"
+ "Move the mouse to the structure that you want to remove a supply line to "
+ "and click on it. The blue arrows show current supply lines from this "
+ "depot. You may press escape to cancel. "
+ "</p>"
;

public static var towerRemoveSupplyTip =
"<p>"
+ "<span class=\"title\">"
+ "Remove Supply Line "
+ "</span>\n"
+ "If you click here, the supply line to this structure from the source "
+ "depot will be removed. They will no longer send survivors with "
+ "supplies to one another. You may press escape to cancel. "
+ "</p>"
;

public static var towerNoRemoveSupplyTip =
"<p>"
+ "<span class=\"title\">"
+ "No Supply Line "
+ "</span>\n"
+ "You cannot remove a supply line to this structure because there is no "
+ "supply line from the source depot to here. You may press escape to "
+ "cancel. "
+ "</p>"
;

public static var spendFoodTip =
"<p>"
+ "<span class=\"title\">"
+ "Begin spending <span class=\"hotkey\">F</span>ood"
+ "</span>\n"
+ "This depot is currently sending out slower survivors to conserve "
+ "food. You can click here to begin spending food to double the speed "
+ "of survivors. "
+ "</p>"
;

public static var conserveFoodTip =
"<p>"
+ "<span class=\"title\">"
+ "Begin conserving <span class=\"hotkey\">F</span>ood"
+ "</span>\n"
+ "This depot is sending out fast survivors which use up food. Click "
+ "here to begin conserving food by sending out survivors who move at "
+ "half speed. "
+ "</p>"
;

public static var upgradeDepotTip =
"<p>"
+ "<span class=\"title\">"
+ "<span class=\"hotkey\">U</span>pgrade (30 Boards)"
+ "</span>\n"
+ "Increase the speed of this depot. The survivors at upgraded depots move 50% faster "
+ "than normal survivors. "
+ "</p>"
;

public static function upgradeSniperTip(a0 : String) : String
{
return "<p>"
+ "<span class=\"title\">"
+ "<span class=\"hotkey\">U</span>pgrade"
+ "</span>\n"
+ "<span class=\"cost\">"+a0+" Boards</span>\n"
+ "Upgrade this sniper tower to increase its range by 50%. "
+ "</p>"
;
}

public static var upgradeInProgressTip =
"<p>"
+ "<span class=\"title\">"
+ "Upgrade In Progress "
+ "</span>\n"
+ "The materials necessary to upgrade this structure are on the way. "
+ "</p> "
;

public static var upgradeMaxTip =
"<p>"
+ "<span class=\"title\">"
+ "Upgrading Complete "
+ "</span>\n"
+ "This structure has been completely upgraded. "
+ "</p>"
;

public static var upgradeNoResourceTip =
"<p>"
+ "<span class=\"title\">"
+ "Not Enough Boards to Upgrade "
+ "</span>\n"
+ "The suppliers to this structure do not have enough boards, or survivors "
+ "to transport those boards. "
+ "</p>"
;

public static var backgroundBuildBlockedTip =
"<p>"
+ "<span class=\"title\">"
+ "Location Blocked "
+ "</span>\n"
+ "This location is blocked by an obstruction. No structure may be built "
+ "here. You may press escape to cancel. "
+ "</p>"
;

public static var backgroundBuildShadowTip =
"<p>"
+ "<span class=\"title\">"
+ "Structure Already Planned "
+ "</span>\n"
+ "You cannot build here because a structure is already being constructed "
+ "here. You may press escape to cancel. "
+ "</p>"
;

public static var backgroundBuildZombieTip =
"<p>"
+ "<span class=\"title\">"
+ "Zombies Here "
+ "</span>\n"
+ "There are zombies here. Structures cannot be built where there are "
+ "zombies. You may press escape to cancel. "
+ "</p>"
;

public static var backgroundBuildBridgeTip =
"<p>"
+ "<span class=\"title\">"
+ "Cannot Build on Bridge "
+ "</span>\n"
+ "It is too dangerous to build on a bridge. You may press escape to cancel. "
+ "</p>"
;

public static function backgroundBuildSupplyTip(a0 : String) : String
{
return "<p>"
+ "<span class=\"title\">"
+ "Need Supply Line "
+ "</span>\n"
+ "You must build within "+a0+" squares of an existing depot so it can provide supplies. "
+ "</p>"
;
}

public static var towerBuildTip =
"<p>"
+ "<span class=\"title\">"
+ "Structure Already Here "
+ "</span>\n"
+ "You cannot build here because there is already a structure here. You may "
+ "press escape to cancel. "
+ "</p>"
;

public static var backgroundBuildRubbleTip =
"<p>"
+ "<span class=\"title\">"
+ "Rubble Here "
+ "</span>\n"
+ "You cannot build here because there is rubble blocking this "
+ "area. You can build a workshop here to clear the rubble and salvage "
+ "the resources in this square. You may press escape to cancel. "
+ "</p>"
;

public static var backgroundBuildFeatureTip =
"<p>"
+ "<span class=\"title\">"
+ "Special Feature Here "
+ "</span>\n"
+ "There is a special feature here which blocks you from building a "
+ "structure. You can build a workshop on this square to use this "
+ "feature. You may press escape to cancel. "
+ "</p>"
;

public static var backgroundBuildDynamiteTip =
"<p>"
+ "<span class=\"title\">"
+ "Dynamite Here "
+ "</span>\n"
+ "There is some dynamite here which blocks you from building a "
+ "structure. You can build a workshop on the dynamite to place the charges "
+ "and prevent more zombies from getting onto the island. You may press "
+ "escape to cancel. "
+ "</p>"
;

public static var backgroundEntranceTip =
"<p>"
+ "<span class=\"title\">"
+ "Building Entrance Here "
+ "</span>\n"
+ "There is a building entrance here which prevents you from "
+ "building. You can build a workshop on this square to harvest the "
+ "resources in the building. You may press escape to cancel. "
+ "</p>"
;

public static var backgroundEmptyEntranceTip =
"<p>"
+ "<span class=\"title\">"
+ "Building Entrance Here "
+ "</span>\n"
+ "The building entrance here blocks you from constructing a "
+ "structure. This building has already been stripped of all useful "
+ "resources. You may press escape to cancel. "
+ "</p>"
;

public static var buildBarricadeTip =
"<p>"
+ "<span class=\"title\">"
+ "Construct <span class=\"hotkey\">B</span>arricade"
+ "</span>\n"
+ "<span class=\"cost\">10 Boards</span>\n"
+ "Barricades block off streets and slow zombies down. Each board can withstand one zombie hit. Zombies are easier to kill while attacking a barricade. "
+ "</p>"
;

public static var barricadeNoSurvivorTip =
"<p>"
+ "<span class=\"title\">"
+ "Cannot Construct Barricade "
+ "</span>\n"
+ "You cannot construct a barricade from this depot. There are no "
+ "survivors here to carry the boards needed to create the barricade. "
+ "</p>"
;

public static var barricadeNoBoardTip =
"<p>"
+ "<span class=\"title\">"
+ "Cannot Construct Barricade "
+ "</span>\n"
+ "You cannot construct a barricade from this depot. There are not enough "
+ "boards here to create one. "
+ "</p>"
;

public static var buildingBarricadeTip =
"<p>"
+ "<span class=\"title\">"
+ "Place Barricade "
+ "</span>\n"
+ "Move the mouse to an open square and click to build a barricade "
+ "there. It will take some time for a survivor to bring the "
+ "construction materials to your planned building location. You may "
+ "press escape to cancel. "
+ "</p>"
;

public static var backgroundBarricadeTip =
"<p>"
+ "<span class=\"title\">"
+ "Click To Build Barricade "
+ "</span>\n"
+ "If you click here, a survivor will be dispatched to this location "
+ "with some boards to build a barricade. You may press escape to "
+ "cancel. "
+ "</p>"
;

public static var buildDepotTip =
"<p>"
+ "<span class=\"title\">"
+ "Construct <span class=\"hotkey\">D</span>epot"
+ "</span>\n"
+ "<span class=\"cost\">1 Survivor</span>\n"
+ "Depots store your resources and transfer them through your "
+ "supply network as needed. "
+ "</p>"
;

public static var depotNoSurvivorTip =
"<p>"
+ "<span class=\"title\">"
+ "Cannot Construct Depot "
+ "</span>\n"
+ "You cannot construct a depot from this structure. There are no survivors "
+ "here to build it. "
+ "</p>"
;

public static var depotNoBoardTip =
"<p>"
+ "<span class=\"title\">"
+ "Cannot Construct Depot "
+ "</span>\n"
+ "You cannot construct a depot from this structure. There are not enough "
+ "boards here to build the depot with. "
+ "</p>"
;

public static var buildingDepotTip =
"<p>"
+ "<span class=\"title\">"
+ "Place Depot "
+ "</span>\n"
+ "Move the mouse to on an open square and click to build a depot "
+ "there. It will take some time for a survivor to bring the "
+ "construction materials to your planned building location. You may "
+ "press escape to cancel. "
+ "</p>"
;

public static var backgroundDepotTip =
"<p>"
+ "<span class=\"title\">"
+ "Click To Build Depot "
+ "</span>\n"
+ "If you click here, a survivor will be dispatched to this location "
+ "with some boards to build a depot. You may press escape to cancel. "
+ "</p>"
;

public static var buildSniperTip =
"<p>"
+ "<span class=\"title\">"
+ "Construct <span class=\"hotkey\">S</span>niper"
+ "</span>\n"
+ "<span class=\"cost\">1 Survivor</span>\n"
+ "<span class=\"cost\">20 Boards</span>\n"
+ "Snipers are your only way to kill zombies. They are inaccurate, but "
+ "will kill a zombie in one hit. "
+ "</p>"
;

public static var sniperNoBoardTip =
"<p>"
+ "<span class=\"title\">"
+ "Cannot Construct Sniper "
+ "</span>\n"
+ "You cannot construct a sniper tower from this depot. There are not "
+ "enough boards available here to build it. "
+ "</p>"
;

public static var sniperNoSurvivorTip =
"<p>"
+ "<span class=\"title\">"
+ "Cannot Construct Sniper "
+ "</span>\n"
+ "You cannot construct a sniper tower from this depot. There are no "
+ "survivors here to build it. "
+ "</p>"
;

public static var buildingSniperTip =
"<p>"
+ "<span class=\"title\">"
+ "Place Sniper "
+ "</span>\n"
+ "Move the mouse to on an open square and click to build a sniper tower "
+ "there. It will take some time for a survivor to bring the "
+ "construction materials to your planned building location. You may "
+ "press escape to cancel. "
+ "</p>"
;

public static var backgroundSniperTip =
"<p>"
+ "<span class=\"title\">"
+ "Click To Build Sniper "
+ "</span>\n"
+ "If you click here, a survivor will be dispatched to this location "
+ "with some boards to build a sniper tower. You may press escape to cancel. "
+ "</p>"
;

public static var buildWorkshopTip =
"<p>"
+ "<span class=\"title\">"
+ "Construct <span class=\"hotkey\">W</span>orkshop"
+ "</span>\n"
+ "<span class=\"cost\">1 Survivor</span>\n"
+ "Workshops can be built at the entrances of buildings to collect the "
+ "resources inside. They can also reclaim resources after a structure has "
+ "been destroyed or abandoned. Finally, they can be used to activate "
+ "special features on the map such as dynamite. "
+ "</p>"
;

public static var workshopNoSurvivorTip =
"<p>"
+ "<span class=\"title\">"
+ "Cannot Construct Workshop "
+ "</span>\n"
+ "You cannot construct a workshop from this depot. There are no "
+ "survivors here to build it. "
+ "</p>"
;

public static var buildingWorkshopTip =
"<p>"
+ "<span class=\"title\">"
+ "Place Workshop "
+ "</span>\n"
+ "Move the mouse to on the entrance of a building, rubble on the "
+ "ground, or a special feature and click to build a workshop there. It "
+ "will take some time for a survivor to arrive at your planned "
+ "building location. You may press escape to cancel. "
+ "</p>"
;

public static var workshopBackgroundTip =
"<p>"
+ "<span class=\"title\">"
+ "Nothing Here "
+ "</span>\n"
+ "There is nothing for a workshop to do here. Workshops can only be "
+ "placed at the entrance to a building with resources inside, at some "
+ "rubble on the street, or at a special feature. You may press escape "
+ "to cancel. "
+ "</p>"
;

public static var workshopBuildingTip =
"<p>"
+ "<span class=\"title\">"
+ "Move to Entrance "
+ "</span>\n"
+ "Move the mouse to the entrance of this building and click if you "
+ "want to salvage the resources inside. You may press escape to cancel. "
+ "</p>"
;

public static var workshopEntranceTip =
"<p>"
+ "<span class=\"title\">"
+ "Click to Salvage "
+ "</span>\n"
+ "You can build a workshop here to salvage all usable "
+ "resources in this building. The workshop will automatically close "
+ "down and return the survivor when finished. You may press escape to "
+ "cancel. "
+ "</p>"
;

public static var workshopFeatureTip =
"<p>"
+ "<span class=\"title\">"
+ "Click to Activate "
+ "</span>\n"
+ "If you build a workshop it will begin activating the special feature "
+ "here. The effect depends on the feature. You may press escape to cancel. "
+ "</p>"
;

public static var workshopDynamiteTip =
"<p>"
+ "<span class=\"title\">"
+ "Click to Place Charges "
+ "</span>\n"
+ "If you build a workshop here, it will begin placing explosive "
+ "charges on this bridge. After this bridge is destroyed, no more "
+ "zombies can cross it to enter the island. You may press escape to "
+ "cancel. "
+ "</p>"
;

public static var workshopRubbleTip =
"<p>"
+ "<span class=\"title\">"
+ "Click to Reclaim "
+ "</span>\n"
+ "Build a workshop here to clear the rubble and reclaim all of "
+ "the resource in this square. You may press escape to cancel. "
+ "</p>"
;

public static var workshopBuildingZombiesTip =
"<p>"
+ "<span class=\"title\">"
+ "Zombies Inside "
+ "</span>\n"
+ "You cannot build a workshop at a building with zombies inside. Lure "
+ "out and destroy the zombies first. You may press escape to cancel. "
+ "</p>"
;

public static var workshopBuildingEmptyTip =
"<p>"
+ "<span class=\"title\">"
+ "No Resources Left "
+ "</span>\n"
+ "This building has already been stripped of all usable resources. You "
+ "may press escape to cancel. "
+ "</p>"
;

public static var wasteShotTip =
"<p>"
+ "<span class=\"title\">"
+ "Shoot Into <span class=\"hotkey\">A</span>ir"
+ "</span>\n"
+ "Zombies are attracted to sound. Firing a round into the air can "
+ "serve as a lure for nearby zombies. "
+ "</p>"
;

public static var noWasteShotTip =
"<p>"
+ "<span class=\"title\">"
+ "Out of Ammo "
+ "</span>\n"
+ "You cannot shoot into the air becaue this sniper is out of ammo. "
+ "</p>"
;

public static var enableFireTip =
"<p>"
+ "<span class=\"title\">"
+ "Allow Sniper to <span class=\"hotkey\">F</span>ire"
+ "</span>\n"
+ "This sniper is currently holding fire. Click this "
+ "button to allow the sniper to fire at targets within range. "
+ "</p>"
;

public static var disableFireTip =
"<p>"
+ "<span class=\"title\">"
+ "Forbid Sniper from <span class=\"hotkey\">F</span>iring"
+ "</span>\n"
+ "This sniper's current orders are to shoot any zombies within "
+ "range. Click this button to prevent the sniper from firing. "
+ "</p>"
;

public static var ammoNoDecreaseTip =
"<p>"
+ "<span class=\"title\">"
+ "Cannot Decrease Ammo Quota "
+ "</span>\n"
+ "The ammo quota is now zero. You cannot further decrease the quota. "
+ "</p>"
;

public static var boardsNoDecreaseTip =
"<p>"
+ "<span class=\"title\">"
+ "Cannot Decrease Board Quota "
+ "</span>\n"
+ "The board quota is now zero. You cannot further decrease the quota. "
+ "</p>"
;

public static var foodNoDecreaseTip =
"<p>"
+ "<span class=\"title\">"
+ "Cannot Decrease Food Quota "
+ "</span>\n"
+ "The food quota is now zero. You cannot further decrease the quota. "
+ "</p>"
;

public static var survivorsNoDecreaseTip =
"<p>"
+ "<span class=\"title\">"
+ "Cannot Decrease Survivor Quota "
+ "</span>\n"
+ "The survivor quota is now zero. You cannot further decrease the quota. "
+ "</p>"
;

public static var barricadeBoardsIncreaseTip =
"<p>"
+ "<span class=\"title\">"
+ "Increase Board Quota "
+ "</span>\n"
+ "More boards will hold off zombies for longer. Each zombie attack "
+ "destroys one board. When this barricade runs out of boards, it will "
+ "be destroyed. "
+ "</p>"
;

public static var barricadeBoardsDecreaseTip =
"<p>"
+ "<span class=\"title\">"
+ "Decrease Board Quota "
+ "</span>\n"
+ "Fewer boards will make this barricade weaker. Your survivors will "
+ "tear down part of the barricade to recover excess boards. Demolish "
+ "this barricade by setting the quota to 0. "
+ "</p>"
;

public static var depotAmmoIncreaseTip =
"<p>"
+ "<span class=\"title\">"
+ "Increase Ammo Quota "
+ "</span>\n"
+ "More ammo will be stored here to resupply nearby snipers. "
+ "</p>"
;

public static var depotAmmoDecreaseTip =
"<p>"
+ "<span class=\"title\">"
+ "Decrease Ammo Quota "
+ "</span>\n"
+ "Less ammo will be kept for resupplying nearby snipers. "
+ "</p>"
;

public static var depotBoardsIncreaseTip =
"<p>"
+ "<span class=\"title\">"
+ "Increase Board Quota "
+ "</span>\n"
+ "More boards will be kept on hand to build or upgrade towers. "
+ "</p>"
;

public static var depotBoardsDecreaseTip =
"<p>"
+ "<span class=\"title\">"
+ "Decrease Board Quota "
+ "</span>\n"
+ "Fewer boards will be kept here for building or upgrading. "
+ "</p>"
;

public static var depotFoodIncreaseTip =
"<p>"
+ "<span class=\"title\">"
+ "Increase Food Quota "
+ "</span>\n"
+ "Food can be used here to increase the speed of your survivors. It "
+ "can also be used by sniper towers. A depot will reserve all food in "
+ "its quota for local use and will not transfer it to other depots. "
+ "</p>"
;

public static var depotFoodDecreaseTip =
"<p>"
+ "<span class=\"title\">"
+ "Decrease Food Quota "
+ "</span>\n"
+ "If you click here, less food will be reserved for local use. If a "
+ "depot lacks food, survivors will move more slowly when transferring "
+ "resources. "
+ "</p>"
;

public static var depotSurvivorsIncreaseTip =
"<p>"
+ "<span class=\"title\">"
+ "Increase Survivor Quota "
+ "</span>\n"
+ "More survivors will be here ready to ferry supplies to nearby structures. "
+ "</p>"
;

public static var depotSurvivorsDecreaseTip =
"<p>"
+ "<span class=\"title\">"
+ "Decrease Survivor Quota "
+ "</span>\n"
+ "Fewer survivors will be on hand to transfer supplies to nearby "
+ "structures. "
+ "</p>"
;

public static var sniperAmmoIncreaseTip =
"<p>"
+ "<span class=\"title\">"
+ "Increase Ammo Quota "
+ "</span>\n"
+ "Storing more ammo allows this sniper to shoot more zombies between "
+ "resupplies. "
+ "</p>"
;

public static var sniperAmmoDecreaseTip =
"<p>"
+ "<span class=\"title\">"
+ "Decrease Ammo Quota "
+ "</span>\n"
+ "Storing less ammo makes this sniper more reliant on its supplier. "
+ "</p>"
;

public static var sniperFoodIncreaseTip =
"<p>"
+ "<span class=\"title\">"
+ "Increase Food Quota "
+ "</span>\n"
+ "Food increases the accuracy of your snipers. If food is available "
+ "when they fire at a zombie, they will consume some of the food and "
+ "are 50% more likely to hit. If you click here, more food will be "
+ "moved here. "
+ "</p>"
;

public static var sniperFoodDecreaseTip =
"<p>"
+ "<span class=\"title\">"
+ "Decrease Food Quota "
+ "</span>\n"
+ "If you click here, less food will be stored at this sniper "
+ "tower. While snipers can still fire without food, they are less "
+ "accurate. "
+ "</p>"
;

public static var sniperSurvivorsIncreaseTip =
"<p>"
+ "<span class=\"title\">"
+ "Increase Survivor Quota "
+ "</span>\n"
+ "More survivors will make this sniper tower more accurate. "
+ "</p>"
;

public static var sniperSurvivorsDecreaseTip =
"<p>"
+ "<span class=\"title\">"
+ "Decrease Survivor Quota "
+ "</span>\n"
+ "Fewer survivors will make this sniper less accurate. This tower "
+ "needs at least one survivor to shoot zombies. "
+ "</p>"
;

public static var workshopSurvivorsIncreaseTip =
"<p>"
+ "<span class=\"title\">"
+ "Increase Survivor Quota "
+ "</span>\n"
+ "More survivors will make this workshop faster. "
+ "</p>"
;

public static var workshopSurvivorsDecreaseTip =
"<p>"
+ "<span class=\"title\">"
+ "Decrease Survivor Quota "
+ "</span>\n"
+ "Fewer survivors will make this workshop slower. "
+ "</p>"
;

public static var hoverBarricadeTip =
"<p>"
+ "<span class=\"title\">"
+ "Barricade "
+ "</span>\n"
+ "Barricades use boards to slow down zombies. Click to select it. "
+ "</p>"
;

public static var hoverBarricadeNoBoardsTip =
"<p>"
+ "<span class=\"title\">"
+ "Barricade is Vulnerable "
+ "</span>\n"
+ "There are no boards left in this barricade. The next hit will "
+ "destroy it unless it is resupplied first. "
+ "</p>"
;

public static var hoverDepotTip =
"<p>"
+ "<span class=\"title\">"
+ "Depot "
+ "</span>\n"
+ "This is a depot. You can use it to build other structures or to store "
+ "and distribute supplies. Click to select it. "
+ "</p>"
;

public static var hoverSniperTip =
"<p>"
+ "<span class=\"title\">"
+ "Sniper Tower "
+ "</span>\n"
+ "Sniper towers like this one are used to kill zombies. Snipers aren't 100% accurate, but only one successful shot is required to kill each zombie. Click to "
+ "select it. "
+ "</p>"
;

public static var hoverSniperNoSurvivorsTip =
"<p>"
+ "<span class=\"title\">"
+ "Sniper Tower Cannot Fire "
+ "</span>\n"
+ "There are no survivors here to shoot. This sniper tower "
+ "is defenseless! "
+ "</p>"
;

public static var hoverSniperNoAmmoTip =
"<p>"
+ "<span class=\"title\">"
+ "Sniper Tower Cannot Fire "
+ "</span>\n"
+ "This sniper tower has run out of ammo. It cannot shoot until it is "
+ "resupplied. "
+ "</p>"
;

public static var hoverSniperHoldFireTip =
"<p>"
+ "<span class=\"title\">"
+ "Sniper Tower Will Not Fire "
+ "</span>\n"
+ "You have ordered this sniper tower to hold fire. It will not shoot until "
+ "you change its orders. "
+ "</p>"
;

public static var hoverWorkshopTip =
"<p>"
+ "<span class=\"title\">"
+ "Workshop "
+ "</span>\n"
+ "Workshops are your industrial base. They salvage resources from "
+ "buildings and rubble to allow the fight to continue. "
+ "</p>"
;

public static var hoverPlanTip =
"<p>"
+ "<span class=\"title\">"
+ "Planned Structure "
+ "</span>\n"
+ "A survivor is on the way here to build a structure. You can select the "
+ "plan to cancel it. "
+ "</p>"
;

public static var hoverRubbleTip =
"<p>"
+ "<span class=\"title\">"
+ "Rubble "
+ "</span>\n"
+ "Some rubble blocks the street. You can only build a workshop here "
+ "to clear away the rubble and recover the resources in the rubble. "
+ "</p>"
;

public static var hoverZombieTip =
"<p>"
+ "<span class=\"title\">"
+ "Zombie "
+ "</span>\n"
+ "This is a zombie. They stay where they are unless they hear a "
+ "noise. When they hear sounds, they will pursue them and attack "
+ "anything in the way. Survivors, buildings, and especially gunfire "
+ "attract zombies. "
+ "</p>"
;

public static var hoverFeatureTip =
"<p>"
+ "<span class=\"title\">"
+ "Special Feature "
+ "</span>\n"
+ "There is a special feature here. You can build a workshop here to "
+ "begin activate it. "
+ "</p>"
;

public static var hoverDynamiteTip =
"<p>"
+ "<span class=\"title\">"
+ "Dynamite "
+ "</span>\n"
+ "If you built a workshop on these explosives, your survivors "
+ "will wire them to the bridge and eventually detonate them. If all "
+ "bridges are destroyed, no more zombies can invade the "
+ "island. "
+ "</p>"
;

public static var buildingStandardText =
"Office "
;

public static var buildingApartmentText =
"Apartment Complex "
;

public static var buildingSupermarketText =
"Supermarket (Food) "
;

public static var buildingPoliceStationText =
"Police Station (Ammo) "
;

public static var buildingHardwareStoreText =
"Hardware Store (Boards) "
;

public static var buildingChurchText =
"Church (Survivors) "
;

public static var buildingHospitalText =
"Hospital (Zombies) "
;

public static var buildingMallText =
"Mall "
;

public static var buildingHouseText =
"House "
;

public static var buildingParkingLotText =
"Parking Lot "
;

public static var zombieThreatNone =
"None "
;

public static var zombieThreatLow =
"Low "
;

public static var zombieThreatModerate =
"Moderate "
;

public static var zombieThreatHigh =
"High "
;

public static var salvageProspectsNone =
"None "
;

public static var salvageProspectsLow =
"Low "
;

public static var salvageProspectsHigh =
"High "
;

public static var survivorsInside =
"<span class=\"survivor\">Survivors Inside</span>"
+ "</p>"
;

public static var survivorsNotInside =
"Deserted "
+ "</p>"
;

public static function buildingText(a0 : String, a1 : String, a2 : String, a3 : String) : String
{
return "<p>"
+ ""+a0+"\n"
+ "Zombie Threat: <span class=\"status\">"+a1+"</span>\n"
+ "Resource Level: <span class=\"status\">"+a2+"</span>\n"
+ ""+a3+" "
+ "</p>"
;
}

public static var planCancelTip =
"<p>"
+ "<span class=\"title\">"
+ "Cancel Construction <span class=\"hotkey\">[Del]</span>"
+ "</span>\n"
+ "Click here to cancel the planned structure. The survivor sent to build it "
+ "will return to the depot which sent it. "
+ "</p>"
;

public static var pauseText =
"Paused "
;

public static var moveWindowNorth =
"<p>Move window North.</p>"
;

public static var moveWindowSouth =
"<p>Move window South.</p>"
;

public static var moveWindowEast =
"<p>Move window East.</p>"
;

public static var moveWindowWest =
"<p>Move window West.</p>"
;

public static var clickDepot =
"<p>Click on your depot to select it.</p>"
;

public static var clickWorkshop =
"<p>Click on your workshop to select it.</p>"
;

public static var clickSniper =
"<p>Click on your sniper tower to select it.</p>"
;

public static var clickBarricade =
"<p>Click on your barricade to select it.</p>"
;

public static var clickRestartTutorial =
"<p>You have done something unexpected. Press escape to go to the system menu and select restart map to replay the tutorial from the beginning.</p>"
;

public static var clickNext =
"<p>Click Next to continue</p>"
;

public static function zombiesLeft(a0 : String) : String
{
return "Zombies Left: "+a0+" "
;
}

public static function bridgesLeft(a0 : String) : String
{
return "Bridges Left: "+a0+" "
;
}

public static var musicBarLabel =
"Music Volume "
;

public static var soundBarLabel =
"Sound Volume "
;

public static var scrollBarLabel =
"Scroll Speed "
;

public static var mainIntroText =
"No one knows how it happened. Soon, there'll be no one left to "
+ "care. But the simple truth is that overnight a globe full of civilized "
+ "people festered, and changed, and became something less than "
+ "civilized. Less than human. And if you weren't the smartest, or the "
+ "fastest, or the best-armed on your block, well... you're one of them "
+ "now.\n\n"
+ "Auriga Squad was the best, and you were its leader. Your final "
+ "orders before static filled the airwaves for good were "
+ "simple. Parachute onto the island. Secure the city. Blow the "
+ "bridges. And set up a secure command post surrounded by water, a safe "
+ "haven from the roving, hungry packs.\n\n"
+ "But it didn't work out that way. There were so many of them, "
+ "lurching through the streets, feeding in dark alleyways. Sure, it only "
+ "took one shot to drop them, but it only took one bite to drop you. And "
+ "those bites went through flak suits, through Kevlar, through "
+ "bone...\n\n"
+ "Now everyone is dead. Except you and the handful of civilians "
+ "you've rounded up, scared, defiant, looking for a leader. The "
+ "explosives sit useless where the airdrop left them, ready to drop the "
+ "bridges-- if only someone could reach them.\n\n"
+ "What the hell. Maybe there's still a chance. There'll be time to "
+ "mourn later, but for now, you'd better get these people moving. "
+ "Something tells you this quiet won't last.\n\n"
+ "The clock is ticking. "
;

public static var mainLoseText =
"The last board shatters and the monsters surge forward, the "
+ "bloodcurdling screams of your dying companions mingling with the "
+ "crunching of bone and snarls of inhuman throats, a wall of tattered "
+ "clothes and festering flesh and teeth stained lurid red advancing "
+ "toward you. And as that last board shatters your hope goes with it, "
+ "and you know you've failed. The island has fallen. Another sliver of "
+ "humanity corrupted and destroyed.\n\n"
+ "Screaming in rage, you draw your last weapon, an eight-inch hunting "
+ "knife, and charge straight into the advancing horde, stabbing and "
+ "slashing even as claws rip your flesh and teeth begin shattering your "
+ "bones. Let no man say Auriga Squad fell without a fight, if there be "
+ "men left to say anything at all... "
;

public static var mainWinText =
"The bridge falls into the water, sounds of rending metal and echoes "
+ "of the blast reverberating through the city, fading slowly to a "
+ "strange, deep silence.\n\n"
+ "At first your ragtag team watches numbly, too tired or gripped by "
+ "fear to respond, not yet people again, only survivors.\n\n"
+ "But then voices begin to murmur, to gasp, to cry out. A cheer "
+ "ripples through the crowd and finally explodes, elation shattering "
+ "through memories of horror and tears washing cheeks stained with blood "
+ "and grime. You've done it. The island is secure.\n\n"
+ "Your lips crack as you smile too. Sure, it's only one victory, and "
+ "there's a lot more work ahead. But it's something. You've made a haven "
+ "against darkness, a place to start to rebuild. Today you've triumphed "
+ "against horror. Against despair. Against the horde. "
;

public static var tutorialText =
"Tutorial "
;

public static var noviceText =
"Novice "
;

public static var veteranText =
"Veteran "
;

public static var expertText =
"Expert "
;

public static var quartermasterText =
"Quartermaster "
;

public static var ammoTip =
"<p>"
+ "<span class=\"title\">Ammo</span>\n"
+ "How much ammo is here right now. Your snipers use ammo to shoot "
+ "zombies. "
+ "</p>"
;

public static var boardsTip =
"<p>"
+ "<span class=\"title\">Boards</span>\n"
+ "How many boards are here right now. You need boards to build sniper "
+ "towers, barricades, and more depots. You can also upgrade your "
+ "sniper towers and repair barricades if you have enough boards. "
+ "</p>"
;

public static var survivorsTip =
"<p>"
+ "<span class=\"title\">Survivors</span>\n"
+ "How many survivors are here right now. Once liberated, survivors can "
+ "be put to work ferrying supplies, scavenging buildings, making "
+ "fortifications, manning sniper towers, and setting charges. "
+ "</p>"
;

public static var pediaTip =
"<p>"
+ "<span class=\"title\">Zombipedia</span>"
+ "Click here for more details on how the game works. "
+ "</p>"
;

public static var countDownTip =
"<p>"
+ "<span class=\"title\">Countdown Timer</span>\n"
+ "The timer counts down till the next zombie horde invasion. You can "
+ "also click here to pause the game. "
+ "</p>"
;

public static var quotaTip =
"<p>"
+ "<span class=\"title\">Quota</span>\n"
+ "If the amount of ammo, boards, or survivors drops below its quota, "
+ "your depot will send more as long as there is enough to go around. "
+ "</p>"
;

public static var ammoQuotaTip =
"<p>"
+ "<span class=\"title\">Ammo Quota</span>\n"
+ "How much ammo you want to keep on hand here. Snipers use ammo to "
+ "shoot zombies. "
+ "</p>"
;

public static var boardsQuotaTip =
"<p>"
+ "<span class=\"title\">Board Quota</span>\n"
+ "How many boards you want to keep on hand here. You can use boards "
+ "to build, upgrade, and repair structures. "
+ "</p>"
;

public static var survivorsQuotaTip =
"<p>"
+ "<span class=\"title\">Survivor Quota</span>\n"
+ "How many survivors should stay here. Survivors transport resources, "
+ "staff buildings, and increase accuracy at sniper towers. "
+ "</p>"
;

public static var accuracyBarTip =
"<p>"
+ "<span class=\"title\">Accuracy</span>\n"
+ "Shows the accuracy of shots fired by this sniper. Extra survivors "
+ "act as spotters to increase accuracy. It is much easier to hit "
+ "zombies as they are attacking a barricade. "
+ "</p>"
;

public static var setChargesBarTip =
"<p>"
+ "<span class=\"title\">Set Charges Progress</span>\n"
+ "Progress towards preparing the explosives to blow the bridge. Your "
+ "progress is cumulative even if you have to abandon the workshop. "
+ "</p>"
;

public static var leftToExtractTip =
"<p>"
+ "<span class=\"title\">Left to Extract</span>"
+ "How many resources are left in this area for your survivors to "
+ "recover. "
+ "</p>"
;

public static var ammoLeftTip =
"<p>"
+ "<span class=\"title\">Ammo Left</span>\n"
+ "How much ammo will be recovered before the tower is closed. "
+ "</p>"
;

public static var boardsLeftTip =
"<p>"
+ "<span class=\"title\">Survivors Left</span>\n"
+ "How many boards will be recovered before the tower is closed. "
+ "</p>"
;

public static var survivorsLeftTip =
"<p>"
+ "<span class=\"title\">Survivors Left</span>\n"
+ "How many survivors will be found before the tower is closed. "
+ "</p>"
;

public static var ammoLabel =
"Ammo "
;

public static var boardsLabel =
"Boards "
;

public static var foodLabel =
"Food "
;

public static var survivorsLabel =
"Survivors "
;

public static var northLabel =
"North "
;

public static var southLabel =
"South "
;

public static var eastLabel =
"East "
;

public static var westLabel =
"West "
;

public static var nameConstraint =
"A-Za-z0-9 ' "
;

public static var sizeConstraint =
"0-9 "
;

public static var waitGenerateMap =
"Generating Map... "
;

public static var waitLoadGame =
"Loading... "
;

public static var waitSaveGame =
"Saving... "
;

public static var waitEditMap =
"Starting Map Editor... "
;

public static var waitDownloadMap =
"Downloading Map... "
;

public static var waitUploadMap =
"Uploading Map... "
;

public static var waitRateMap =
"Submitting Rating... "
;

public static var waitBrowse =
"Fetching Map List... "
;

public static function timeLabel(a0 : String, a1 : String, a2 : String) : String
{
return "Time: "+a0+":"+a1+""+a2+" "
;
}

public static var noAmmoWarning =
"No Ammo "
;

public static var noBoardsWarning =
"No Boards "
;

public static var noSurvivorsWarning =
"No Survivors "
;

public static var noTowerWarning =
"No Structure There "
;

public static var towerWarning =
"Structure Already There "
;

public static var towerSameWarning =
"Structure Can't Supply Itself "
;

public static var supplyExistsWarning =
"Supply Line Already Exists "
;

public static var noSourceTowerWarning =
"No Selected Structure "
;

public static var supplyNotExistsWarning =
"No Supply Line "
;

public static var upgradeInProgressWarning =
"Upgrade in Progress "
;

public static var noUpgradeResourcesWarning =
"No Resources "
;

public static var placeZombieWarning =
"Blocked by Zombie "
;

public static var placeBlockedWarning =
"Blocked "
;

public static var placeBridgeWarning =
"Bridge Unstable "
;

public static var placeSupplyWarning =
"No Supply Line "
;

public static var placeBoringWarning =
"Nothing to\n"
+ "Scavenge "
;

public static var placeRubbleWarning =
"Blocked by Rubble "
;

public static var placeFeatureWarning =
"Blocked by Dynamite "
;

public static var placeBuildingWarning =
"Building Unsafe "
;

public static var editUnknown =
"Undefined "
;

public static var editStreetH =
"Street (H) "
;

public static var editStreetV =
"Street (V) "
;

public static var editParking =
"Parking Lot "
;

public static var editPark =
"Park "
;

public static var editPlaza =
"Plaza "
;

public static var editShallowWater =
"Shallow Water "
;

public static var editDeepWater =
"Deep Water "
;

public static var editBridge =
"Bridge "
;

public static var editStreet =
"Street "
;

public static var editCorner =
"Street Corner "
;

public static var editIntersection =
"Intersection "
;

public static var editFringe =
"Office (A) "
;

public static var editPlant =
"Office (B) "
;

public static var editHardware =
"Hardware Store "
;

public static var editHospital =
"Hospital "
;

public static var editApartment =
"Apartment Building "
;

public static var editChurch =
"Church "
;

public static var editHouse =
"House "
;

public static var editMall =
"Mall "
;

public static var editPolice =
"Police Station "
;

public static function zombiesEdit(a0 : String) : String
{
return "Zombies: "+a0+" "
;
}

public static function ammoEdit(a0 : String) : String
{
return "Ammo: "+a0+" "
;
}

public static function boardsEdit(a0 : String) : String
{
return "Boards: "+a0+" "
;
}

public static function survivorsEdit(a0 : String) : String
{
return "Survivors: "+a0+" "
;
}

public static function levelsEdit(a0 : String) : String
{
return "Level: "+a0+" "
;
}

public static var playPediaRootSecret =
"index "
;

public static var editPediaRootSecret =
"map_editor "
;

public static var rateBad =
"Bad "
;

public static var rateOk =
"Ok "
;

public static var rateGood =
"Good "
;

public static var rateEasy =
"Easy "
;

public static var rateMedium =
"Medium "
;

public static var rateHard =
"Hard "
;
public static var levels = [
"<map name=\"Basic Training\" difficulty=\"0\" sizeX=\"25\" sizeY=\"19\" startX=\"12\" startY=\"9\" >"
+ "<terrain>"
+ "aa1ea42d3c903d1fa27aa713a477f59c.eNoVikESgDAIxFwsC "
+ "y2tdPTHvly85JDEVBOmK8GwBs5poPqP8ArGQrk2nWgrFNAewtu "
+ "g9lSM3UVa2gle1JrZ8W6XY4wE8AF+HwLw "
+ "</terrain>"
+ "<briefing>"
+ "No one knows how it happened. Soon, there&apos;ll be no one left to "
+ "care. But the simple truth is that overnight a globe full of civilized "
+ "people festered, and changed, and became something less than "
+ "civilized. Less than human. And if you weren&apos;t the smartest, or the "
+ "fastest, or the best-armed on your block, well... you&apos;re one of them "
+ "now.\n\n"
+ "*Begin Transmission*\n\n"
+ "The hordes of undead are growing. We need to get you up to speed as fast as possible. Lets start with the basics.\n\n"
+ "*End Transmission* "
+ "</briefing>"
+ "<script>"
+ "<state name=\"start\" posX=\"16\" posY=\"8\">"
+ "<text>Your depot is the backbone of your supply network</text>"
+ "<next/>"
+ "<edge type=\"click-next\" next=\"1\"/>"
+ "<edge type=\"start-build-sniper\" next=\"4\"/>"
+ "<edge type=\"build-sniper\" next=\"5\"/>"
+ "</state>"
+ "<state name=\"1\">"
+ "<text>Depots store your resources and send them to other towers.</text>"
+ "<next/>"
+ "<edge type=\"click-next\" next=\"2\"/>"
+ "<edge type=\"start-build-sniper\" next=\"4\"/>"
+ "<edge type=\"build-sniper\" next=\"5\"/>"
+ "</state>"
+ "<state name=\"2\">"
+ "<text>Everything must be built within 7 tiles of a depot.</text>"
+ "<next/>"
+ "<edge type=\"click-next\" next=\"3\"/>"
+ "<edge type=\"start-build-sniper\" next=\"4\"/>"
+ "<edge type=\"build-sniper\" next=\"5\"/>"
+ "</state>"
+ "<state name=\"3\" button=\"build-sniper\">"
+ "<text>We need a sniper tower to protect us from zombies. Click the build sniper button on the left.</text>"
+ "<edge type=\"start-build-sniper\" next=\"4\"/>"
+ "<edge type=\"build-sniper\" next=\"5\"/>"
+ "</state>"
+ "<state name=\"4\" posX=\"12\" posY=\"8\">"
+ "<text>Now click to place a sniper tower at the indicated location. You can hold down shift to easily place multiple towers.</text>"
+ "<edge type=\"build-sniper\" next=\"5\"/>"
+ "<edge type=\"cancel-build\" next=\"3\"/>"
+ "</state>"
+ "<state name=\"5\" posX=\"12\" posY=\"10\">"
+ "<text>Build one more sniper tower here to support the other one. The sniper tower&apos;s range is shown in light blue.</text>"
+ "<edge type=\"build-sniper\" next=\"6\"/>"
+ "</state>"
+ "<state name=\"6\" button=\"build-barricade\">"
+ "<text>If a zombie gets too close to a sniper, it will be toast. We need barricades to hold off the hordes. Click to build a barricade.</text>"
+ "<edge type=\"start-build-barricade\" next=\"7\"/>"
+ "</state>"
+ "<state name=\"7\" posX=\"10\" posY=\"10\">"
+ "<text>Place the new barricade a bit in front of the snipers. Make sure at least one side is clear so the barricade can be properly supplied.</text>"
+ "<edge type=\"build-barricade\" next=\"8\"/>"
+ "<edge type=\"cancel-build\" next=\"6\"/>"
+ "</state>"
+ "<state name=\"8\" posX=\"10\" posY=\"9\">"
+ "<text>Place another barricade to seal off the road. Otherwise some zombies might bypass your defenses.</text>"
+ "<edge type=\"build-barricade\" next=\"9\"/>"
+ "</state>"
+ "<state name=\"9\">"
+ "<text>Zombies are coming! Get ready!</text>"
+ "<action type=\"countdown\" arg=\"10\"/>"
+ "<edge type=\"countdown-complete\" next=\"10\"/>"
+ "</state>"
+ "<state name=\"10\">"
+ "<text>Hold off this wave of zombies, and victory will be yours!</text>"
+ "<action type=\"horde\" arg=\"5 5 9\"/>"
+ "<action type=\"horde\" arg=\"5 5 10\"/>"
+ "<edge type=\"zombie-clear\" next=\"11\"/>"
+ "</state>"
+ "<state name=\"11\">"
+ "<action type=\"win\">"
+ "<arg>"
+ "*Begin Transmission*\n\n"
+ "Congratulations! This was your first meeting with our awful enemy, but you still have much to learn.\n\n"
+ "*End Transmission*</arg>"
+ "</action>"
+ "</state>"
+ "</script>"
+ "</map>"
,
"<map name=\"Boom\" difficulty=\"1\" sizeX=\"20\" sizeY=\"31\" startX=\"10\" startY=\"14\" >"
+ "<terrain>"
+ "1151f1ee463c72420c6686469eb083eb.eNoVzksSwjAMA9DId "
+ "izn21LacgPuCScnbN5CMxqJOVfhJHbmhZMOHxXhTlDKLv6uIVp "
+ "LqnUbzhPwdgksGoq1CbK/VJkXEbdZCusN7v0B8x5QDv45kFuZI "
+ "lqa6jAGsnNAjTvEeUDoz1XxDUafaybOlfFa9BtrcN34tIaUvqV "
+ "LSkkA/AApEQYw "
+ "</terrain>"
+ "<briefing>"
+ "*Begin Transmission*\n\n"
+ "You&apos;ve done well so far, soldier. But out in the field you will often have to scavenge what you can from the local area. You need to learn about workshops and resources.\n\n"
+ "*End Transmission* "
+ "</briefing>"
+ "<script>"
+ "<state name=\"start\">"
+ "<text>Most maps are bigger than your flash window. Scroll by dragging the map or using the arrow keys.</text>"
+ "<next/>"
+ "<edge type=\"bridge-clear\" next=\"win\"/>"
+ "<edge type=\"build-workshop\" next=\"17\" offsetX=\"9\" offsetY=\"21\" "
+ "limitX=\"10\" limitY=\"22\"/>"
+ "<edge type=\"build-depot\" next=\"16\" offsetX=\"5\" offsetY=\"14\" "
+ "limitX=\"15\" limitY=\"26\"/>"
+ "<edge type=\"build-workshop\" next=\"5\" offsetX=\"10\" offsetY = \"9\" "
+ "limitX=\"11\" limitY=\"10\"/>"
+ "<edge type=\"click-next\" next=\"1\"/>"
+ "</state>"
+ "<state name=\"1\" button=\"total-resources\">"
+ "<text>Your unallocated resources are shown at the top. Oh no! Resource levels are extremely low!</text>"
+ "<next/>"
+ "<edge type=\"bridge-clear\" next=\"win\"/>"
+ "<edge type=\"build-workshop\" next=\"17\" offsetX=\"9\" offsetY=\"21\" "
+ "limitX=\"10\" limitY=\"22\"/>"
+ "<edge type=\"build-depot\" next=\"16\" offsetX=\"5\" offsetY=\"14\" "
+ "limitX=\"15\" limitY=\"26\"/>"
+ "<edge type=\"build-workshop\" next=\"5\" offsetX=\"10\" offsetY = \"9\" "
+ "limitX=\"11\" limitY=\"10\"/>"
+ "<edge type=\"click-next\" next=\"2\"/>"
+ "</state>"
+ "<state name=\"2\" posX=\"10\" posY=\"9\">"
+ "<text>This house has a green arrow which means it is clear of zombies and there are resources inside.</text>"
+ "<action type=\"move-map\" arg=\"10 9\"/>"
+ "<next/>"
+ "<edge type=\"bridge-clear\" next=\"win\"/>"
+ "<edge type=\"build-workshop\" next=\"17\" offsetX=\"9\" offsetY=\"21\" "
+ "limitX=\"10\" limitY=\"22\"/>"
+ "<edge type=\"build-depot\" next=\"16\" offsetX=\"5\" offsetY=\"14\" "
+ "limitX=\"15\" limitY=\"26\"/>"
+ "<edge type=\"build-workshop\" next=\"5\" offsetX=\"10\" offsetY = \"9\" "
+ "limitX=\"11\" limitY=\"10\"/>"
+ "<edge type=\"click-next\" next=\"3\"/>"
+ "</state>"
+ "<state name=\"3\" button=\"build-workshop\">"
+ "<text>Click on the build workshop button so we can scavenge the valuable resources.</text>"
+ "<edge type=\"bridge-clear\" next=\"win\"/>"
+ "<edge type=\"build-workshop\" next=\"17\" offsetX=\"9\" offsetY=\"21\" "
+ "limitX=\"10\" limitY=\"22\"/>"
+ "<edge type=\"build-depot\" next=\"16\" offsetX=\"5\" offsetY=\"14\" "
+ "limitX=\"15\" limitY=\"26\"/>"
+ "<edge type=\"build-workshop\" next=\"5\" offsetX=\"10\" offsetY = \"9\" "
+ "limitX=\"11\" limitY=\"10\"/>"
+ "<edge type=\"start-build-workshop\" next=\"4\"/>"
+ "</state>"
+ "<state name=\"4\" posX=\"10\" posY=\"9\">"
+ "<text>Click on the entrance to the house to build a workshop there. This workshop will collect the resources in a building over time and return them to the depot.</text>"
+ "<edge type=\"bridge-clear\" next=\"win\"/>"
+ "<edge type=\"build-workshop\" next=\"17\" offsetX=\"9\" offsetY=\"21\" "
+ "limitX=\"10\" limitY=\"22\"/>"
+ "<edge type=\"build-depot\" next=\"16\" offsetX=\"5\" offsetY=\"14\" "
+ "limitX=\"15\" limitY=\"26\"/>"
+ "<edge type=\"build-workshop\" next=\"5\" offsetX=\"10\" offsetY = \"9\" "
+ "limitX=\"11\" limitY=\"10\"/>"
+ "<edge type=\"cancel-build\" next=\"3\"/>"
+ "</state>"
+ "<state name=\"5\" posX=\"10\" posY=\"9\">"
+ "<text>There are a lot of resources there and it will take a long time for one survivor to collect them all. Lets speed things up. Click on the new workshop.</text>"
+ "<edge type=\"bridge-clear\" next=\"win\"/>"
+ "<edge type=\"build-workshop\" next=\"17\" offsetX=\"9\" offsetY=\"21\" "
+ "limitX=\"10\" limitY=\"22\"/>"
+ "<edge type=\"build-depot\" next=\"16\" offsetX=\"5\" offsetY=\"14\" "
+ "limitX=\"15\" limitY=\"26\"/>"
+ "<edge type=\"select-workshop\" next=\"6\"/>"
+ "</state>"
+ "<state name=\"6\" button=\"workshop-increase\">"
+ "<text>Click the plus button to increase the worker quota. New workers will start working here when available and speed up the collection.</text>"
+ "<edge type=\"bridge-clear\" next=\"win\"/>"
+ "<edge type=\"build-workshop\" next=\"17\" offsetX=\"9\" offsetY=\"21\" "
+ "limitX=\"10\" limitY=\"22\"/>"
+ "<edge type=\"build-depot\" next=\"16\" offsetX=\"5\" offsetY=\"14\" "
+ "limitX=\"15\" limitY=\"26\"/>"
+ "<edge type=\"select-nothing\" next=\"5\"/>"
+ "<edge type=\"click-add-survivors\" next=\"7\" offsetX=\"10\" offsetY=\"9\" limitX=\"11\" limitY=\"10\"/>"
+ "</state>"
+ "<state name=\"7\">"
+ "<text>You can see how many resources are left to extract on the right. Increase the survivor quota to 10, then click next.</text>"
+ "<next/>"
+ "<edge type=\"bridge-clear\" next=\"win\"/>"
+ "<edge type=\"build-workshop\" next=\"17\" offsetX=\"9\" offsetY=\"21\" "
+ "limitX=\"10\" limitY=\"22\"/>"
+ "<edge type=\"build-depot\" next=\"16\" offsetX=\"5\" offsetY=\"14\" "
+ "limitX=\"15\" limitY=\"26\"/>"
+ "<edge type=\"click-next\" next=\"8\"/>"
+ "</state>"
+ "<state name=\"8\">"
+ "<text>There are three kinds of resources: Ammo, Boards, and Survivors.</text>"
+ "<next/>"
+ "<edge type=\"bridge-clear\" next=\"win\"/>"
+ "<edge type=\"build-workshop\" next=\"17\" offsetX=\"9\" offsetY=\"21\" "
+ "limitX=\"10\" limitY=\"22\"/>"
+ "<edge type=\"build-depot\" next=\"16\" offsetX=\"5\" offsetY=\"14\" "
+ "limitX=\"15\" limitY=\"26\"/>"
+ "<edge type=\"click-next\" next=\"9\"/>"
+ "</state>"
+ "<state name=\"9\">"
+ "<text>Ammo is used by snipers to shoot zombies.</text>"
+ "<next/>"
+ "<edge type=\"bridge-clear\" next=\"win\"/>"
+ "<edge type=\"build-workshop\" next=\"17\" offsetX=\"9\" offsetY=\"21\" "
+ "limitX=\"10\" limitY=\"22\"/>"
+ "<edge type=\"build-depot\" next=\"16\" offsetX=\"5\" offsetY=\"14\" "
+ "limitX=\"15\" limitY=\"26\"/>"
+ "<edge type=\"click-next\" next=\"10\"/>"
+ "</state>"
+ "<state name=\"10\">"
+ "<text>Boards are used to build sniper towers and barricades.</text>"
+ "<next/>"
+ "<edge type=\"bridge-clear\" next=\"win\"/>"
+ "<edge type=\"build-workshop\" next=\"17\" offsetX=\"9\" offsetY=\"21\" "
+ "limitX=\"10\" limitY=\"22\"/>"
+ "<edge type=\"build-depot\" next=\"16\" offsetX=\"5\" offsetY=\"14\" "
+ "limitX=\"15\" limitY=\"26\"/>"
+ "<edge type=\"click-next\" next=\"11\"/>"
+ "</state>"
+ "<state name=\"11\">"
+ "<text>Survivors carry resources around and staff buildings.</text>"
+ "<next/>"
+ "<edge type=\"bridge-clear\" next=\"win\"/>"
+ "<edge type=\"build-workshop\" next=\"17\" offsetX=\"9\" offsetY=\"21\" "
+ "limitX=\"10\" limitY=\"22\"/>"
+ "<edge type=\"build-depot\" next=\"16\" offsetX=\"5\" offsetY=\"14\" "
+ "limitX=\"15\" limitY=\"26\"/>"
+ "<edge type=\"click-next\" next=\"12\"/>"
+ "</state>"
+ "<state name=\"12\" button=\"total-resources\">"
+ "<text>When you increase quotas and spend resources, these numbers go down. If they are negative, that means you&apos;ve allocated more resources than you have.</text>"
+ "<next/>"
+ "<edge type=\"bridge-clear\" next=\"win\"/>"
+ "<edge type=\"build-workshop\" next=\"17\" offsetX=\"9\" offsetY=\"21\" "
+ "limitX=\"10\" limitY=\"22\"/>"
+ "<edge type=\"build-depot\" next=\"16\" offsetX=\"5\" offsetY=\"14\" "
+ "limitX=\"15\" limitY=\"26\"/>"
+ "<edge type=\"click-next\" next=\"13\"/>"
+ "</state>"
+ "<state name=\"13\">"
+ "<text>There are no zombies on this island, and we need to keep it that way by blowing up the bridge which gives them access.</text>"
+ "<next/>"
+ "<edge type=\"bridge-clear\" next=\"win\"/>"
+ "<edge type=\"build-workshop\" next=\"17\" offsetX=\"9\" offsetY=\"21\" "
+ "limitX=\"10\" limitY=\"22\"/>"
+ "<edge type=\"build-depot\" next=\"16\" offsetX=\"5\" offsetY=\"14\" "
+ "limitX=\"15\" limitY=\"26\"/>"
+ "<edge type=\"click-next\" next=\"14\"/>"
+ "</state>"
+ "<state name=\"14\" button=\"build-depot\">"
+ "<text>We need to expand our supply lines to cover the bridge. Click the build depot button.</text>"
+ "<edge type=\"bridge-clear\" next=\"win\"/>"
+ "<edge type=\"build-workshop\" next=\"17\" offsetX=\"9\" offsetY=\"21\" "
+ "limitX=\"10\" limitY=\"22\"/>"
+ "<edge type=\"build-depot\" next=\"16\" offsetX=\"5\" offsetY=\"14\" "
+ "limitX=\"15\" limitY=\"26\"/>"
+ "<edge type=\"start-build-depot\" next=\"15\"/>"
+ "</state>"
+ "<state name=\"15\" posX=\"9\" posY=\"19\">"
+ "<action type=\"move-map\" arg=\"9 19\"/>"
+ "<text>Click to place the depot as far south as you can.</text>"
+ "<edge type=\"bridge-clear\" next=\"win\"/>"
+ "<edge type=\"build-workshop\" next=\"17\" offsetX=\"9\" offsetY=\"21\" "
+ "limitX=\"10\" limitY=\"22\"/>"
+ "<edge type=\"cancel-build\" next=\"14\"/>"
+ "<edge type=\"build-depot\" next=\"16\" offsetX=\"5\" offsetY=\"14\" "
+ "limitX=\"15\" limitY=\"26\"/>"
+ "</state>"
+ "<state name=\"16\" posX=\"9\" posY=\"21\">"
+ "<text>Now build a workshop on the dynamite location to set charges and blow up the bridge.</text>"
+ "<edge type=\"bridge-clear\" next=\"win\"/>"
+ "<edge type=\"build-workshop\" next=\"17\" offsetX=\"9\" offsetY=\"21\" "
+ "limitX=\"10\" limitY=\"22\"/>"
+ "</state>"
+ "<state name=\"17\">"
+ "<text>Click on the workshop to see the progress it is making.</text>"
+ "<edge type=\"bridge-clear\" next=\"win\"/>"
+ "<edge type=\"select-workshop\" next=\"18\" offsetX=\"9\" offsetY=\"21\" "
+ "limitX=\"10\" limitY=\"22\"/>"
+ "</state>"
+ "<state name=\"18\">"
+ "<text>Many hands make light work. Increase the number of survivors here as much as you can to speed the work, then click next.</text>"
+ "<next/>"
+ "<edge type=\"bridge-clear\" next=\"win\"/>"
+ "<edge type=\"click-next\" next=\"19\"/>"
+ "</state>"
+ "<state name=\"19\">"
+ "<text>Clearing an island of zombies and blowing the bridges is how you win. Sit back and wait for victory.</text>"
+ "<edge type=\"bridge-clear\" next=\"win\"/>"
+ "</state>"
+ "<state name=\"win\">"
+ "<action type=\"win\">"
+ "<arg>"
+ "*Begin Transmission*\n\n"
+ "Well done on that demolition work, soldier. Destroying bridges will be crucial to preventing new zombies from entering an area. The last thing you need to learn is how to manage your snipers effectively in the field.\n\n"
+ "*End Transmission* "
+ "</arg>"
+ "</action>"
+ "</state>"
+ "</script>"
+ "</map>"
,
"<map name=\"Bang\" difficulty=\"0\" sizeX=\"25\" sizeY=\"30\" startX=\"12\" startY=\"9\" >"
+ "<terrain>"
+ "8d3979175577820f4d5fe645fca194c1.eNody9ESgyAMRFEX2 "
+ "MSAELTV/q72ywt9OXNndlb58ZBypYFZItogFEaWkmMUqwjCmiB "
+ "eEaWPUrZoerRgSjKpDyQTFBohbZbPskuRvIOpH/Prg32f6xmg/ "
+ "Zq0we4IyeZqB5KsDdT1hXRvhtsKnty5LE/5W/+26Xc7w7L4G8A "
+ "PlKcJBA "
+ "</terrain>"
+ "<briefing>"
+ "*Begin Transmission*\n\n"
+ "We don&apos;t have much time left. Outbreaks have been reported on every major continent. I&apos;ll show you how to use your snipers well, otherwise you will be slaughtered out there.\n\n"
+ "*End Transmission* "
+ "</briefing>"
+ "<script>"
+ "<state name=\"start\" posX=\"12\" posY=\"9\">"
+ "<text>There are zombies to the north, and we don&apos;t have any ammo!</text>"
+ "<next/>"
+ "<edge type=\"click-next\" next=\"1\"/>"
+ "</state>"
+ "<state name=\"1\">"
+ "<text>Luckily, they haven&apos;t heard us yet. They will stay where they are until they hear a noise.</text>"
+ "<next/>"
+ "<edge type=\"click-next\" next=\"2\"/>"
+ "</state>"
+ "<state name=\"2\" posX=\"11\" posY=\"16\">"
+ "<text>Before we do anything else, we need to restock on ammo. There is some rubble left on the street. Build a workshop to search for resources.</text>"
+ "<action type=\"move-map\" arg=\"11 16\" />"
+ "<edge type=\"build-workshop\" next=\"3\"/>"
+ "</state>"
+ "<state name=\"3\">"
+ "<text>In addition to finding resources, the rubble must be cleared away before you can build other towers there.</text>"
+ "<next/>"
+ "<edge type=\"click-next\" next=\"4\"/>"
+ "</state>"
+ "<state name=\"4\">"
+ "<text>Build workshops on the other rubble tiles and add survivors until you have a good stock of ammo. Then click next.</text>"
+ "<next/>"
+ "<edge type=\"click-next\" next=\"5\"/>"
+ "</state>"
+ "<state name=\"5\" posX=\"12\" posY=\"16\">"
+ "<text>Now build a sniper to take out these three zombies. Don&apos;t worry if the zombies aren&apos;t in range yet, we&apos;ll take care of that.</text>"
+ "<edge type=\"build-sniper\" next=\"6\"/>"
+ "</state>"
+ "<state name=\"6\">"
+ "<text>If we make some noise, we can pull the zombies within range. And shooting off a round should do that. Select your sniper.</text>"
+ "<edge type=\"select-sniper\" next=\"7\"/>"
+ "</state>"
+ "<state name=\"7\" button=\"sniper-shoot\">"
+ "<text>Now tell your sniper to shoot into the air. That will attract all nearby zombies.</text>"
+ "<edge type=\"select-nothing\" next=\"6\"/>"
+ "<edge type=\"click-shoot\" next=\"8\"/>"
+ "</state>"
+ "<state name=\"8\">"
+ "<text>Your sniper should make short work of these zombies. You can often draw zombies out of an area to clear it in a controlled manner.</text>"
+ "<next/>"
+ "<edge type=\"click-next\" next=\"9\"/>"
+ "</state>"
+ "<state name=\"9\" button=\"sniper-upgrade\">"
+ "<text>Your snipers are versatile and you can improve them in several ways. First, you can upgrade your sniper to increase its range.</text>"
+ "<next/>"
+ "<edge type=\"click-upgrade\" next=\"10\"/>"
+ "<edge type=\"click-next\" next=\"10\"/>"
+ "</state>"
+ "<state name=\"10\" button=\"sniper-increase-survivors\">"
+ "<text>Second, you can add extra survivors as spotters. Each additional survivor increases accuracy.</text>"
+ "<next/>"
+ "<edge type=\"click-add-survivors\" next=\"11\"/>"
+ "<edge type=\"click-next\" next=\"11\"/>"
+ "</state>"
+ "<state name=\"11\" button=\"sniper-increase-ammo\">"
+ "<text>Third, you can increase the amount of ammo. More ammo means that the sniper tower can shoot longer between resupplies</text>"
+ "<next/>"
+ "<edge type=\"click-add-ammo\" next=\"12\"/>"
+ "<edge type=\"click-next\" next=\"12\"/>"
+ "</state>"
+ "<state name=\"12\">"
+ "<text>Finally, be sure to use barricades to protect your vulnerable snipers. A sniper is much more accurate when attacking zombies delayed by a barricade.</text>"
+ "<next/>"
+ "<edge type=\"click-next\" next=\"13\"/>"
+ "</state>"
+ "<state name=\"13\">"
+ "<text>Set up a defensive perimeter here, upgrading your towers as necessary. Click next when you are ready for the final zombie attack.</text>"
+ "<next/>"
+ "<edge type=\"click-next\" next=\"14\"/>"
+ "</state>"
+ "<state name=\"14\">"
+ "<text>Make sure you have at least two sniper towers and plenty of ammo. Then click next.</text>"
+ "<next/>"
+ "<edge type=\"click-next\" next=\"15\"/>"
+ "</state>"
+ "<state name=\"15\">"
+ "<text>Defeat the zombie swarms!</text>"
+ "<action type=\"horde\" arg=\"4 12 5\"/>"
+ "<action type=\"horde\" arg=\"3 5 11\"/>"
+ "<action type=\"horde\" arg=\"4 19 11\"/>"
+ "<edge type=\"zombie-clear\" next=\"16\"/>"
+ "</state>"
+ "<state name=\"16\">"
+ "<action type=\"win\">"
+ "<arg>"
+ "*Begin Transmission*\n\n"
+ "For the next part of the course...\n\n"
+ "One minute...\n\n"
+ "I&apos;ve just recieved reports that a zombie horde has overrun the final training facility. This time will be for real. Get ready.\n\n"
+ "*End Transmission* "
+ "</arg>"
+ "</action>"
+ "</state>"
+ "</script>"
+ "</map>"
,
"<map name=\"Graduation\" difficulty=\"1\" sizeX=\"40\" sizeY=\"40\" startX=\"12\" startY=\"27\" >"
+ "<terrain>"
+ "84dc19f602cc8396e8735db89eb5a222.eNodkoGyoyAMRUlCC "
+ "IJoa9Gqrdr33mx3P7OzX77XdYY7hxC4MWCqO5t+tWxfxqvpyhb "
+ "MVgrtSym8Ik3BCsVXbIKk7LzTV9+oDFmc6msE3rOqhtcKfOaEj "
+ "60h4e6UCqEYA1FumfjA9B0Lc9M5Igrv2IMvjtiBr8xxcCwMviF "
+ "+c+Il/FqKyd4751R+5mrymJBtv/uidu26WmvUWki0K2Q6FpF3h "
+ "kPbETGD4dBeHMzBcMinA9k7w6Gtjp2TdzPBbUIOxXcGt3cnxJE "
+ "TfpziiHiGcIEB9VWZ68DMM0xlu4gI20RMcVbkTKyy3lXku59E+ "
+ "9mhZd8D8DY5uP2ZZvHzQgW+uVSGx4O5UP8Q9tNgTNNdKA8PD3q "
+ "iimUm75vFa7we3rsYRtyJjV8d0iuLbjdUNmzM/roR+3pK2bz4c "
+ "TPx6xrEHzcy/9yYwnMnDvtJ285k2+HZDlBoDk/BFlBcSX3aBbG "
+ "d6HwJZvHlyeJBlOoFPaXpopyOFhdISxsoz8BcITS2QumIaGSu8 "
+ "ZzHRLng6qlvlXJ3xvqolAwkybCn5HTujEgKweCmkLQ8cXpa7lj "
+ "gcSbJI1qcKxqWH6ghpxHroaJo7RgCSjb+P3PGmT4i/bO29NkxS "
+ "kefy0CfEWO40d/mwa5PCa4fNO0fd7UhUg "
+ "</terrain>"
+ "<briefing>"
+ "*Begin Transmission*\n\n"
+ "The training ground has been overrun. You must clear the island of zombies and blow the bridge to prevent others from coming.\n\n"
+ "*End Transmission* "
+ "</briefing>"
+ "<script>"
+ "<state name=\"start\">"
+ "<text>There are zombies in many of the buildings. Yellow, orange, and red triangles show increasing threat levels.</text>"
+ "<next/>"
+ "<action type=\"add-state\" arg=\"none\" />"
+ "<edge type=\"click-next\" next=\"1\" />"
+ "</state>"
+ "<state name=\"1\">"
+ "<text>If the zombies hear a noise, they will come out and attack. Be especially careful when dealing with buildings marked in red.</text>"
+ "<next/>"
+ "<edge type=\"click-next\" next=\"2\" />"
+ "</state>"
+ "<state name=\"2\" button=\"timer\">"
+ "<text>The timer counts down till the next zombie wave. You can also click it to pause the game. You can still issue orders while the game is paused.</text>"
+ "<next/>"
+ "<action type=\"add-state\" arg=\"countdown\" />"
+ "<edge type=\"click-next\" next=\"3\" />"
+ "</state>"
+ "<state name=\"3\">"
+ "<text>Clear the island of zombies and blow up the bridge. Good luck!</text>"
+ "<next/>"
+ "<edge type=\"click-next\" />"
+ "</state>"
+ "<state name=\"none\">"
+ "<edge type=\"bridge-clear\" next=\"bridge\"/>"
+ "<edge type=\"zombie-clear\" next=\"zombie\" />"
+ "</state>"
+ "<state name=\"bridge\">"
+ "<edge type=\"zombie-clear\" next=\"bridge-zombie\" />"
+ "</state>"
+ "<state name=\"zombie\">"
+ "<edge type=\"bridge-clear\" next=\"bridge-zombie\" />"
+ "<edge type=\"zombie-horde-begin\" next=\"none\" />"
+ "</state>"
+ "<state name=\"bridge-zombie\">"
+ "<action type=\"win\">"
+ "<arg>"
+ "*Begin Transmission*\n\n"
+ "The training island is now secured. Now it is time for you to move into the field.\n\n"
+ "*End Transmission* "
+ "</arg>"
+ "</action>"
+ "</state>"
+ "<state name=\"countdown\">"
+ "<action type=\"countdown\" arg=\"150\" />"
+ "<edge type=\"countdown-complete\" next=\"horde\" />"
+ "</state>"
+ "<state name=\"horde\">"
+ "<action type=\"horde\" />"
+ "<edge type=\"zombie-horde-end\" next=\"countdown\" />"
+ "</state>"
+ "</script>"
+ "</map>"
,
"<map name=\"Bridge\" difficulty=\"1\" sizeX=\"60\" sizeY=\"60\" startX=\"26\" startY=\"49\" >"
+ "<briefing>"
+ "*Begin Transmission*\n\n"
+ "Zombies have infiltrated the heart of the city. Your goal is to create a checkpoint on the south bridge.\n\n"
+ "Enter the area, clear out undead you find there, and make sure nobody enters or leaves the city. We need to quarantine the whole island.\n\n"
+ "*End Transmission* "
+ "</briefing>"
+ "<terrain>"
+ "40b96b8ff8119e279e1fb5ff8c004a08.eNpFkguXojoMgJukD "
+ "ygIXBEVGUB8jasr4mPm94HbH75hz7kOpwlfEpomKfreKaPXl5T "
+ "MYydD7bUThJk/JT0LJWLOSi5DQB1FFk2UWKPNxJA2ijyjEt8Yp "
+ "TCAyNcko1CjtKGETaQUxYb3cwYl5TZVRDO2AZs548JIAMRAkTy "
+ "WbFdjSHjrtZLUGAIQsgxT1GWUgu4UWnNXyq7PnpJnO4bxwFlpp "
+ "5D05qQ0nTR7yTS7qa+zC5FR+4mvvQ65zpYMRN2cMG+5l7Ilbqg "
+ "F3KRPrunJ+3A7Z1w8BTDnDylV+ZjApnxKqp6CW9g3HN98j+jBr "
+ "tOEpwfJpu0ktTckEk37YORvQajLA6RsvyUcdrzr8CX48ZpP5uO "
+ "Tu1ZGLWxk1vEi03UFni736OuyQjDzBRo9P7Ba7MdKKunJtNZal "
+ "jVqnVYa9HSvwEwP0pjphdhcSKPjnQQdV6B1/EFo4gUpzCOZ6GU "
+ "EiS5jilXp+aBOHkgVeQFIy0kwP3D6+gIgl3vwZVKR1usdU30AY "
+ "wOfaBIcfEn21BF56nIDlJcOwAZsEwY8AWk7MMeEW5t+aR6Opuj "
+ "J41DRgw/xvhG0+QI06guxXxnsC4NDYfj6+iPT8R8lvhwSnyffZ "
+ "z4Nmc8j7Gsfh5p92MeW+qmlYWpH/8JyHiv7wuq+Yt5w9JOjnxz "
+ "FPgxwYGHKAs7EBP1HQH3D/uaftQvQ2RBcEgpXsqyZG37vQ3RHf "
+ "v9maVmiiXApy3Ii+tVEupp5y3JgOU/AXSborhwrEnRFyjXNaFj "
+ "NxnqLOQ3FfKTVEofVkumVF/wHyHG9Vj9Y/ODHG4e85D7dtBJ9W "
+ "uOQ1jx+l9ViKGpC8SprEMCNILiqFu6/NQ6LtSbhZg24okGXbIS "
+ "bb9DNttzgVgzZTiOXucM+/+Ryjpyk//iFLj+BW57F8HFG5DZbM "
+ "ZTteHDdsnVl/5Wv5lVef467cvAKQ9yNdWQdFwzjejVvdL874ex "
+ "NuPCGLrvha357f7W6obA251t+NW+vm9451f0n1Rvd/s4X9RAuY "
+ "2ke8Mqf/1fyKt74p7yubn+yjlUzqvmN1erW3Fllo2pGs3iyyp9 "
+ "/AZagfKk "
+ "</terrain>"
+ "<script>"
+ "<state name=\"start\">"
+ "<action type=\"add-state\" arg=\"countdown\" />"
+ "<edge type=\"bridge-clear\" next=\"bridge\"/>"
+ "<edge type=\"zombie-clear\" next=\"zombie\" />"
+ "</state>"
+ "<state name=\"bridge\">"
+ "<edge type=\"zombie-clear\" next=\"bridge-zombie\" />"
+ "</state>"
+ "<state name=\"zombie\">"
+ "<edge type=\"bridge-clear\" next=\"bridge-zombie\" />"
+ "<edge type=\"zombie-horde-begin\" next=\"start\" />"
+ "</state>"
+ "<state name=\"bridge-zombie\">"
+ "<action type=\"win\">"
+ "<arg>"
+ "*Begin Transmission*\n\n"
+ "Excellent work, soldier. Other squads are reporting that their bridges are secure as well. We might just contain this.\n\n"
+ "*End Transmission*</arg>"
+ "</action>"
+ "</state>"
+ "<state name=\"countdown\">"
+ "<action type=\"countdown\" arg=\"150\" />"
+ "<edge type=\"countdown-complete\" next=\"horde\" />"
+ "</state>"
+ "<state name=\"horde\">"
+ "<action type=\"horde\" />"
+ "<edge type=\"zombie-horde-end\" next=\"countdown\" />"
+ "</state>"
+ "</script>"
+ "</map>"
,
"<map name=\"Survival\" difficulty=\"2\" sizeX=\"90\" sizeY=\"70\" startX=\"6\" startY=\"39\" >"
+ "<briefing>"
+ "*Begin Transmission*\n\n"
+ "Make your way inland, clearing the area of zombies and collecting survivors. We will contact you with...\n\n"
+ "*Gunshots*\n\n"
+ "*Moans*\n\n"
+ "My God! They are overrunning the command center! Fall back!\n\n"
+ "*End Transmission*\n\n"
+ "It looks like you are on your own. If you can establish a beach head here, you may be able to secure the entire island and destroy the bridges connecting it to the mainland. You could create a sanctuary here. "
+ "</briefing>"
+ "<terrain>"
+ "61d9972b068f4bcbfb4fbba385ae0dc3.eNpNlg1b2swShvc7g "
+ "ZCAAgomYAIhCEgQDGj9OMVaa8UWbfv+IJI3P/w867kajpd38mR "
+ "2dmcyO1k15M2VoYzrJVNGwoSSCWOGXEE9L02u3hZKGG8rxdSXl "
+ "WRUtixu1Vqcs5rDlVWzOKd1q8atPhTrO7zM+pIrGlnw68OPdlu "
+ "SU8uSnJkfAy2Tl2MMmCx2uVGOe5zbdN6rcOsekt0P4BRPqnicY "
+ "PZ60uTWBIpNYi7Kk4RjOEwMxHd5zappn3Bi8HIbIzZrx0iqrY3 "
+ "1iYJPDFWZC14uzfVwaYyIpSGCUzkU3Jrr9BOrhGA6/XuHN+gam "
+ "ZdfLZ3gq8Mt67UNn20bEV89rsqvPZ3BugcnE052uYaV1bDrW5Y "
+ "/qBrKVEHLE8LtcMZY0PS5bAaMUuo3YG10BKXMb2GNkz4nhPSaA "
+ "y6aEdfWrifFqQdJg8jjIuoKhnqPAk7leUBx6VIuRh6XYtqlQox "
+ "6ksvQpVL0PTwOPMrE4BR+gy4uXVdRdjJirHwyZIyXPZc5SrQGg "
+ "tF6C+/rtRiXA9fAsi7jvOULpqTbQwQPk2TdZyVZx+Ky4ZpU1Ee "
+ "SidaQidCLlQoWeDXOwzA21OCSIEvFejFT1EPNrV7COPUSrSaMn "
+ "9VjxVszwplhB3XsxNECr03k8Rwr1OGlejXs3EGilxSlxBCiMhR "
+ "lUbvq0GiGLb+YEcZJKVpAJ3NCtF5Cr2b0Q88w+2JFkIUZLaCTp "
+ "aCMmNESermEHXo94+IB6yBE9Aj9OBeE8kr0Dfr7XOdj9jbQmwv "
+ "tP3ibcf4+Myglpvgzw5xrxPs0x4YSO7rGup8QjwiT3cNu3S84o "
+ "/GiyqwJlLiNmRDryyqVLzMq5Do+pOJLYuOylFT8nDEhf8cY+BM "
+ "zKm4T7Nz0yqEiTlD6GAOBnHBlTIkSgkvUi0lzTA0px5z2Zccwy "
+ "h0iMFTpCENh/y2uhHQtFsqqlMbBx7uE5aqSdh210n3esFgkj7D "
+ "O8cdgZEKXj1ELaAu6ckS0Fs4RbDUYrFoD3iXHQJaOwEXykprUq "
+ "kIlDVUSSUcxcVPjh2J+WuI8coRpiolzyMSkgaTHDi2L6EiwsIG "
+ "MGofoDm6HriPl6YFucxV261IGx0iOqch3OOtVdWI2bzSkUMxro "
+ "lvdOk4Lq11HRm2HSdaGUbpNymXDQRXriBH5B5wF/3th4dc49a8 "
+ "jIW5GknMSXEKuzvRYMIvQQyO99/4Y1vHwo/1GgwaVVxFe7i5Ck "
+ "4/GdSpj/bjQlxEu4Xpgyocz9VGbJ1RfrHGRj2NGw/eulO+neiE "
+ "Vvvel+iesCiFV+H2g1Iv+xIgttiODiXmDW2LrMVu8ezg8122L+ "
+ "2tHiMcqR5MGT5DfDnRfBes6rA3UhPhPkN/qyBjdc2hR+RXtIb/ "
+ "WqeIvDk5l8VLXHXYsmHg6Vqz/3OH8WZ8VrP8A+dhFa0v25DHF1 "
+ "75kNn/Gt22LjT4knnG8yK8dtNraQx3XUOwep7K/kJa6MwihLFh "
+ "LUz0b+vTqbbAhr+WPMm6lYb5VtPS3Djfeq9hX5v+G/H2g+yfYH "
+ "hl8+9FicmvjWPnloGu3TYOy7xKbfi6VOjernAszjKAjQ1CUj/u "
+ "IroITqXjX0JP5SUkxe9CQUhwriSTssCINWVG6qqa0JFWyUsb6d "
+ "a0aJclkW6sTE+fdPb5Ncae/pDUOIfXlus7UwxXlxsNNwzDvrmS "
+ "ZmLkyyM40eGoaOJZzwyR5A7SAKpGsX0ISVP/uPpd4+rlEtZNFs "
+ "muL6MMBA9lGS65l+gop858WyWWFZH6lmBxWeBpWECEbF8bsdi8 "
+ "3lWKNHxW9hmGT3cLm6cJGxGxj70NAymxbGPK5Q9Klg3LkK4fkN "
+ "+DWIdmrUzj8cFj2Uz+Kj8dJleQxuAAJuAZ3VbJr12jarmEf85s "
+ "azT7X/uaW3xzAAdQPSTY4LMydOobAHdiAywbN4ybN5022WzRZu "
+ "mhSPbkJjybJ7pvFxA2c6keYAF5A9ZjkERiCMzAC5yAGt+ARfD8 "
+ "m6XFL1++8VRQ1brE0bukoFy2SLlq6BjctxGvRfI37E3gGG4wGb "
+ "XRletvWPndttlu3Wbpu69p+bxeZvbdZVjspNuVgLw/3cljIfH6 "
+ "CtwA34A5Il+QVl+aOS7KqW8yoFzI/csnut8vT365uJOXRvOShA "
+ "h7ZHXgiPfB0D45gmYA5uAVr8AC+gEewxaxfuI87NF91EB33dYf "
+ "sfnR45nSLqF636NBOIfNRl+TTLslm3f1bwHQH0/3etIZpfIo0T "
+ "mk+xX0Bbk9Zvj0l6dBHJfORj1GwAtfg1ie7WsDTGv67IdkoKAJ "
+ "OA0QAC5AEJL3SDvknPN2Bt4BklV4Rd9RDXDDpIS7ucY/tPvVY+ "
+ "qmH8zG73Ts+9Fj29f/m9dEyfbK76PP0oo9jInvsF22ygXEDI8l "
+ "Ow78fReaH+5KECBrSfIL7FMQhyVZhUccvhcxbA5K3wQlwB6jro "
+ "CjxYVR4nUQ0dyOS30csf4tIpoaMlEpl3WvWsPCqDLHekOVt3E+ "
+ "GJLPPqP6rhJ+8eoYh0AadM5L956xIxhrtkxnBA3igM8LLjYpkg "
+ "r3Xb4w6Y5q3xvAGHuiM8f7jfS1h+gbewC/wz5hm5UkxbE9Ydlg "
+ "87poTlgJEOSmMmbt3v4T7aj9yW8j08wR7sHvB/Bc9P32f4O9/X "
+ "jlH/5+T3eCcp4NzvUuz8yLYEsblh9Ge/i1PFkyLYGdTlt+A5yl "
+ "LWzF6JL+LSfoW6yo6M7KbzlgK8FGtZzhEwBb8AZULmi/m6FvwZ "
+ "06y0qIIerCg6cFCd+nPBT6FS3x1YAPKCSYm+L4TnIRJkUUM8xx "
+ "cgitwA74mdPec0PQ50Qv9gGULSkt8P0tdhtGSp6OlzvNxifKD0 "
+ "ork1ors7BVLAd7FWZG0u9I+pSsEBrUrmh/j7oIO8EEfDGCPcD8 "
+ "DEzAFCbi9Yv9Wemr4rxqWJ7hYI33Rj/aZvkz/C6qQhVY "
+ "</terrain>"
+ "<script>"
+ "<state name=\"start\">"
+ "<action type=\"add-state\" arg=\"countdown\" />"
+ "<edge type=\"bridge-clear\" next=\"bridge\"/>"
+ "<edge type=\"zombie-clear\" next=\"zombie\" />"
+ "</state>"
+ "<state name=\"bridge\">"
+ "<edge type=\"zombie-clear\" next=\"bridge-zombie\" />"
+ "</state>"
+ "<state name=\"zombie\">"
+ "<edge type=\"bridge-clear\" next=\"bridge-zombie\" />"
+ "<edge type=\"zombie-horde-begin\" next=\"start\" />"
+ "</state>"
+ "<state name=\"bridge-zombie\">"
+ "<action type=\"win\">"
+ "<arg>"
+ "The old world is gone, lost to this grim tide. But your sanctuary contains the hope of new life. Perhaps humankind will survive.\n\n"
+ "For more challenges, try playing a random map or creating your own levels! "
+ "</arg>"
+ "</action>"
+ "</state>"
+ "<state name=\"countdown\">"
+ "<action type=\"countdown\" arg=\"150\" />"
+ "<edge type=\"countdown-complete\" next=\"horde\" />"
+ "</state>"
+ "<state name=\"horde\">"
+ "<action type=\"horde\" />"
+ "<edge type=\"zombie-horde-end\" next=\"countdown\" />"
+ "</state>"
+ "</script>"
+ "</map>"
,
"<map name=\"Hide and Seek\" difficulty=\"2\" sizeX=\"90\" sizeY=\"64\" startX=\"35\" startY=\"35\" >"
+ "<terrain>"
+ "41d079c7f0eaa432f235005707feb90f.eNollIt22jgQhq2RR "
+ "r6BodxqSgm2IUDC2jGXBJJectgk9NAmTdLuI+nB97fgnM/zazQ "
+ "ajUcyLt+9Cc23a6G3N02pDxuf9O8F+/p9KCP9t0/K/W8oIvfvg "
+ "hru60Zp98eNp9zdbUOod8yq1z611GGthXrMyVfbTZ3U9YZY8XW "
+ "pBDebMuw2paRuW3phdyCliAdtGS6gaHEma+HiEr7iMpbBAUrTI "
+ "ZL18BDCeQx9zIQxAivfIqyWsNQiDttIGEkKu5Wvy9UyPII/YZX "
+ "hTzXuVrm7Ve7aJdLEl1iyyCUHi5WsUqyqFNW4i3FdFINYhoeqq "
+ "AMWkp9JL/BHUnqCR0qGfpWIL5XkIgoE7SJS4a5FJO5aTOE9FN1 "
+ "3yKVdB76iF9CkaLBbNhz8vMm6wbxpV1omd5FSd9affI+kuo8qK "
+ "fZIk+4xfrBT8hEbeMldh9XXjo196GCuV8n0IZby8ZMN22NPGex "
+ "6RDq5i1l+s+7kJlZyF9vgFeTGyqSAvLJSrTtM5wVrXQbVuJ5so "
+ "HdWp3es9Bcrkz2z3vt2p+/oaX0WR+369IN1pHN45l6laeKiHRP "
+ "GqyesKDiDqquYNSWxK1Vsg5KBy2p42iJxlcpcm2bKpGXSDJmbd "
+ "eto+vCIpou2Ri7aGvkkg6iGNxRc80lxFFLqM3NoC0sYN8091ci "
+ "Bj307beGpqK3FOOy53LQ9U9xTruS2j/OMOiixhXPyqNUjFuEgo "
+ "MAfoGTye9W9HTZpXBu5Xn1ql7ZH5MnazJf1hDPsNT3tNVNSZ1G "
+ "pub20jih3cXmCnISoFURBgEedO6WQqrMWpGqYUZyzTLlk9kpbf "
+ "FAqrlnpjjKl1GjmkZqkkvVkJEl/HnlSf86k0uNMKD2aKqHG1eP "
+ "zVKKvZ6qmPp+FGF7gMcMwiXNWfZswHUKmha1tnLsks/GVKydXl "
+ "YMvc8GcVY94GYj5Ed/7Lz7dz7cGy/fTJXzBffSyIy7ss3XwW8Q "
+ "ifWkp+ft0KY+QP61M3yH/WsnHbk2kbz2Wf2zvk1+Qz1bK40Arq "
+ "X71Fakjep0eR1r9HJ1yjbU6TiqZHWeQc9v84wLfxQ907Yd9E9r "
+ "nxMF+Vd2G9SqiYLmqzm1ZouFLNNwTRSFp8jVnvl+evr0t9O50R "
+ "Ok6V7y2HVBFzkL+KFnib2cpRJ0OuVDqsBJCPeTCVc85uWlRSr7 "
+ "a2PjlRolJmbm6tDXWJ7eJ1l/Pbd7J/oy9f63WdH9GXnA/rSq8n "
+ "WoKt5C0zfCBbJPqvyHxMZwTqeLsAx4ZaVXMca9v5zj6/ZSVitg "
+ "lg06bNjsm0o5pgjUoPMdc+cKsfMe4kWMCUAfccIzXEKYB224jt "
+ "uOYLbjuOuZnD7EfHdMBHCMuFuYI6/Yd8wz4E2KAHmAOvAM9FMY "
+ "dOiYEDdAakunAvgI+c4wP6uADGIIMnINLsAQ34CvojBzTBwUow "
+ "QZsR8Lcwn4ZkfkO+wo7SBwzT/C+KeLBJBVmBvsGLjKsB52xYwb "
+ "gHPQnwlxM0AvQPocfvIHzKeJBAfbgCfRnqBHMZ2QeYAdzx6RzY "
+ "a5gb8AXsAePczLZBeoHG3AHvoMn8Ap+/uOYF8A5+gQegC7Qx4L "
+ "MI+wL8K6E8a8wV2IMnpbo8VKYxzV6voYPrDY4F3ALvoH7jTBPs "
+ "PoafQU10AI9MAAjkIEpKK+F2cJ+AXvwAKIbx3y8EWZ8QyaHXoF "
+ "roLeoZytMCNsCfTAEKTgHF2CxJdPcOaYLRjthStjrnfgfv7rhH "
+ "g "
+ "</terrain>"
+ "</map>"
];
public static var tutorial = [
"<p>"
+ "<span class=\"title\">Tutorial</span>\n"
+ "There's not much time, so let's get you trained ASAP. <a "
+ "href=\"event:zombies\">Zombies</a> are everywhere. We need to <a "
+ "href=\"event:goal\">clear</a> the island and <a "
+ "href=\"event:resources\">resources</a> are limited. "
+ "</p>"
,
"<p>"
+ "<span class=\"title\">Scrolling</span>\n"
+ "Scout out the area. Scroll the map by moving the mouse outside the "
+ "play area or using the arrow keys. "
+ "</p>"
,
"2 "
,
"<p>"
+ "<span class=\"title\">Establish Perimeter</span>\n"
+ "You need a <a href=\"event:sniper\">sniper</a> to defend your <a "
+ "href=\"event:depot\">depot</a> from the <a "
+ "href=\"event:zombies\">zombies</a>. Click 'Build Sniper,' then click "
+ "the map to place your sniper tower. "
+ "</p>"
,
"<p>"
+ "<span class=\"title\">Establish Perimeter</span>\n"
+ "Good. An idle <a href=\"event:survivors\">survivor</a> has been sent "
+ "out with some <a href=\"event:boards\">boards</a> to build the tower. "
+ "</p>"
,
"<p>"
+ "<span class=\"title\">Establish Perimeter</span>\n"
+ "I'd breathe a lot easier with a second <a href=\"event:sniper\">sniper "
+ "tower</a>. Build another one near the first tower. "
+ "</p>"
,
"<p>"
+ "<span class=\"title\">Establish Perimeter</span>\n"
+ "Your <a href=\"event:sniper\">snipers</a> don't have <a "
+ "href=\"event:ammo\">ammo</a> yet. Wait until both towers are stocked "
+ "up. "
+ "</p>"
,
"7 "
,
"<p>"
+ "<span class=\"title\">Lure out Zombies</span>\n"
+ "Now that we've got some protection, let's give these crack shots "
+ "something to shoot at. Order one survivor to shoot into the air to "
+ "<a href=\"event:noise\">lure</a> out <a "
+ "href=\"event:zombies\">zombies</a> from any nearby <a "
+ "href=\"event:buildings\">buildings</a>. "
+ "</p>"
,
"<p>"
+ "<span class=\"title\">Lure out Zombies</span>\n"
+ "That's the stuff. Your <a href=\"event:sniper\">snipers</a> should "
+ "make mincemeat from these <a href=\"event:zombies\">living dead</a>. "
+ "</p>"
,
"10 "
,
"<p>"
+ "<span class=\"title\">Strengthen Perimeter</span>\n"
+ "If the <a href=\"event:zombies\">zombies</a> reach the base of a tower "
+ "you can kiss it goodbye. Some <a "
+ "href=\"event:barricade\">barricades</a> ought to slow the monsters "
+ "down. "
+ "</p>"
,
"<p>"
+ "<span class=\"title\">Strengthen Perimeter</span>\n"
+ "Build a second <a href=\"event:barricade\">barricade</a> next to the first. "
+ "</p>"
,
"<p>"
+ "<span class=\"title\">Strengthen Perimeter</span>\n"
+ "Build a third <a href=\"event:barricade\">barricade</a>. "
+ "</p>"
,
"<p>"
+ "<span class=\"title\">Strengthen Perimeter</span>\n"
+ "A fourth <a href=\"event:barricade\">barricade</a> can block off the "
+ "street completely. "
+ "</p>"
,
"15 "
,
"<p>"
+ "<span class=\"title\">Ride Out Attack</span>\n"
+ "Damn, we're running out of time. The <a "
+ "href=\"event:timer\">counter</a> in the upper left is all the time "
+ "you've got till the next <a href=\"event:zombie_hordes\">horde</a>"
+ "swarms over the bridges. Sit tight and hope those <a "
+ "href=\"event:sniper\">snipers</a> hold the line. "
+ "</p>"
,
"17 "
,
"<p>"
+ "<span class=\"title\">Expand Perimeter</span>\n"
+ "Close call, but we have to keep moving. Destroy a <a "
+ "href=\"event:barricade\">barricade</a> so <a "
+ "href=\"event:survivors\">survivors</a> can move through to the other "
+ "side. "
+ "</p>"
,
"<p>"
+ "<span class=\"title\">Expand Perimeter</span>\n"
+ "Wait while a <a href=\"survivor\">survivor</a> dismantles the <a "
+ "href=\"event:barricade\">barricade</a>. "
+ "</p>"
,
"<p>"
+ "<span class=\"title\">Expand Perimeter</span>\n"
+ "It's an awful long walk from here back to our first <a "
+ "href=\"event:depot\">depot</a>. Build another one as a forward supply "
+ "center. "
+ "</p>"
,
"21 "
,
"<p>"
+ "<span class=\"title\">Resupply</span>\n"
+ "We need to get this <a href=\"event:depot\">depot</a> stocked before "
+ "those things come back. Build <a href=\"event:workshop\">workshops</a>"
+ "at the entrances to nearby <a href=\"event:buildings\">buildings</a>"
+ "to search for <a href=\"event:ammo\">ammo</a>, <a "
+ "href=\"event:boards\">boards</a> to build structures, and <a "
+ "href=\"event:survivors\">survivors</a> to man stations and transport "
+ "<a href=\"event:resources\">resources</a>. "
+ "</p>"
,
"<p>"
+ "<span class=\"title\">Resupply</span>\n"
+ "That's a good start. Build another <a href=\"event:workshop\">workshop</a>. "
+ "</p>"
,
"<p>"
+ "<span class=\"title\">Resupply</span>\n"
+ "Build a third <a href=\"event:workshop\">workshop</a>. "
+ "</p>"
,
"<p>"
+ "<span class=\"title\">Clear Island of Zombies</span>\n"
+ "Good work. Now keep expanding. Build more <a "
+ "href=\"event:sniper\">sniper towers</a> to <a "
+ "href=\"event:noise\">lure</a> out <a href=\"event:zombies\">zombies</a>"
+ "and clear the streets. Build <a href=\"event:workshop\">workshops</a>"
+ "at buildings to send survivors in to bolster your resources. <a "
+ "href=\"event:goal\">Clear the island</a>. "
+ "</p>"
,
"<p>"
+ "<span class=\"title\">Destroy Bridge</span>\n"
+ "You've secured the island, but as long as that bridge is up, all "
+ "you've built could be overrun by a <a "
+ "href=\"event:zombie_hordes\">horde</a> at any moment. Build a <a "
+ "href=\"event:workshop\">workshop</a> on the <a "
+ "href=\"event:charges\">charge</a> to blow the bridge and make this a "
+ "permanent sanctuary. "
+ "</p>"
,
"<p>"
+ "<span class=\"title\">Destroy Bridge</span>\n"
+ "Wait for the <a href=\"event:survivors\">survivor</a> to build the <a "
+ "href=\"event:workshop\">workshop</a>. "
+ "</p>"
,
"28 "
,
"<p>"
+ "<span class=\"title\">Destroy Bridge</span>\n"
+ "You're about to be a hero, but don't get cocky. Increase the quota "
+ "at the <a href=\"event:workshop\">workshop</a> to send more people to "
+ "get those <a href=\"event:charges\">charges</a> set faster; you've got "
+ "plenty of <a href=\"event:survivors\">survivors</a> to spare now. "
+ "</p>"
,
"<p>"
+ "<span class=\"title\">Mission Accomplished</span>\n"
+ "Congrats, soldier: that's one bridge down. Keep it up and there may "
+ "just be hope for humanity yet. "
+ "</p>"
];
public static var cities = [
"Tokyo "
,
"Seoul "
,
"Mexico City "
,
"New York City "
,
"Mumbai "
,
"Jakarta "
,
"Sao Paulo "
,
"Delhi "
,
"Osaka "
,
"Kyoto "
,
"Kobe "
,
"Shanghai "
,
"Manila "
,
"Hong Kong "
,
"Los Angeles "
,
"Kolkata "
,
"Moscow "
,
"Cairo "
,
"Buenos Aires "
,
"Beijing "
,
"Karachi "
,
"Chicago "
,
"Dallas "
,
"Philadelphia "
,
"Houston "
,
"Miami "
,
"Washington DC "
,
"Atlanta "
,
"Boston "
,
"Detroit "
,
"San Francisco "
,
"Phoenix "
,
"Seattle "
,
"Minneapolis "
,
"San Diego "
,
"St Louis "
,
"Tampa "
,
"Baltimore "
,
"Denver "
,
"Pittsburgh "
,
"Portland "
,
"Cincinnati "
,
"Cleveland "
,
"Sacramento "
,
"Orlando "
,
"San Antonio "
,
"Kansas City "
,
"Las Vegas "
,
"San Jose "
,
"Istanbul "
,
"Paris "
,
"Madrid "
,
"Barcelona "
,
"Manchester "
,
"Liverpool "
,
"Milan "
,
"Berlin "
,
"Athens "
,
"Naples "
,
"Hamburg "
,
"Frankfurt "
,
"Kiev "
,
"Lisbon "
,
"Budapest "
,
"Copenhagen "
,
"Munich "
,
"Warsaw "
,
"Bucharest "
,
"Brussels "
,
"Vienna "
,
"Stockholm "
,
"Lyon "
,
"Lille "
,
"Belgrade "
,
"Minsk "
,
"Turin "
,
"Glasgow "
,
"Donetsk "
,
"Marseille "
,
"Kharkiv "
,
"Prague "
,
"Amsterdam "
,
"Antwerp "
,
"Odessa "
,
"Hannover "
,
"Zurich "
,
"Bordeaux "
,
"Dresden "
,
"Birmingham "
,
"Cologne "
,
"Katowice "
,
"Leeds "
,
"Lagos "
,
"Kinshasa "
,
"Khartoum "
,
"Johannesburg "
,
"Algiers "
,
"Abidjan "
,
"Ibadan "
,
"Cape Town "
,
"Alexandria "
,
"Nairobi "
,
"Casablanca "
,
"Mogadishu "
,
"Dakar "
,
"Tripoli "
,
"Rio de Janeiro "
,
"Bogata "
,
"Lima "
,
"Toronto "
,
"Santiago "
,
"Caracas "
,
"Guadalajara "
,
"Montreal "
,
"Recife "
,
"Havana "
,
"Sydney "
,
"Melbourne "
,
"Brisbane "
,
"Perth "
,
"Chennai "
,
"Bengaluru "
,
"Hyderabad "
,
"Ahmedabad "
,
"Pune "
,
"Kanpur "
,
"Surat "
,
"Jaipur "
,
"Guangzhou "
,
"Harbin "
,
"Shenzhen "
,
"Gonguan "
,
"Tianjin "
,
"Wuhan "
,
"Shenyang "
,
"Chengdu "
,
"Zhengzhou "
,
"Chongqing "
,
"Singapore "
];
public static var pedia = [
"index "
,
"<p><span class=\"title\">Index</span></p>\n"
+ "<a href=\"event:goal\">Goal</a>"
+ "\n\n"
+ "<a href=\"event:timer\">Timer</a>"
+ "\n\n"
+ "<a href=\"event:resources\">Resources</a>"
+ "<li><a href=\"event:ammo\">Ammo</a></li>"
+ "<li><a href=\"event:boards\">Boards</a></li>"
+ "<li><a href=\"event:survivors\">Survivors</a></li>"
+ "\n\n"
+ "Towers "
+ "<li><a href=\"event:sniper\">Sniper</a></li>"
+ "<li><a href=\"event:workshop\">Workshop</a></li>"
+ "<li><a href=\"event:depot\">Depot</a></li>"
+ "<li><a href=\"event:barricade\">Barricade</a></li>"
+ "\n\n"
+ "<a href=\"event:buildings\">Buildings</a>\n"
+ "<a href=\"event:building_types\">Building Types</a>"
+ "<li><a href=\"event:house\">House</a></li>"
+ "<li><a href=\"event:office\">Office</a></li>"
+ "<li><a href=\"event:apartment\">Apartment</a></li>"
+ "<li><a href=\"event:mall\">Mall</a></li>"
+ "<li><a href=\"event:police_station\">Police Station</a></li>"
+ "<li><a href=\"event:hardware_store\">Hardware Store</a></li>"
+ "<li><a href=\"event:church\">Church</a></li>"
+ "<li><a href=\"event:hospital\">Hospital</a></li>"
+ "\n\n"
+ "<a href=\"event:zombies\">Zombies</a>\n"
+ "<li><a href=\"event:zombie_hordes\">Zombie Hordes</a></li>"
+ "<li><a href=\"event:noise\">Noise</a></li>"
+ "<li><a href=\"event:scent\">Scent</a></li>"
+ "\n\n"
+ "<a href=\"event:map_features\">Map Features</a>"
+ "<li><a href=\"event:charges\">Charges</a></li>"
+ "<li><a href=\"event:rubble\">Rubble</a></li>"
+ "\n\n"
+ "<a href=\"event:map_editor\">Map Editor</a>"
,
"goal "
,
"<p><span class=\"title\">Goal</span></p>\n"
+ "<p>"
+ "Without safe havens, civilization will be destroyed. Your goal is to "
+ "secure the city by slowly expanding your perimeter, killing <a "
+ "href=\"event:zombies\">zombies</a> and looting <a "
+ "href=\"event:resources\">resources</a> as you go, until you reach and "
+ "destroy each bridge by setting off the <a "
+ "href=\"event:charges\">charges</a> that were airlifted in. Only once "
+ "the island is secure can you think about the future-- and whether "
+ "you'll live to see it. "
+ "</p>"
,
"timer "
,
"<p><span class=\"title\">Timer</span></p>\n"
+ "<p>"
+ "The timer is your friend and your worst enemy. It ticks down the "
+ "precious seconds until the next <a "
+ "href=\"event:zombie_horde\">horde</a> arrives, so keep a close eye on "
+ "it. If you can't take the heat, you can pause the game by "
+ "clicking on the timer. "
+ "</p>"
,
"resources "
,
"<p><span class=\"title\">Resources</span></p>\n"
+ "<p>"
+ "You'll need three things for this mission to succeed: <a "
+ "href=\"event:boards\">lumber</a>, <a href=\"event:ammo\">ammo</a>, and "
+ "fellow <a href=\"event:survivors\">survivors</a>. You'll find these by "
+ "looting the city's eerily quiet <a "
+ "href=\"event:buildings\">buildings</a>. But plan ahead: some types "
+ "contain more of certain resources. "
+ "</p>"
,
"ammo "
,
"<p><span class=\"title\">Ammo</span></p>\n"
+ "<p>"
+ "<img src=\"pedia_ammo\">"
+ "The folks who once lived here had time to stockpile ammunition, but "
+ "in the end it didn't save them. Maybe it will save you. Ammo is one "
+ "of three <a href=\"event:resources\">resources</a> your team is "
+ "searching for in <a href=\"event:buildings\">buildings</a>. Once your "
+ "people get it to a supply <a href=\"event:depot\">depot</a>, it can be "
+ "distributed to your <a href=\"event:sniper\">snipers</a>. You can bet "
+ "your ass they'll need it. "
+ "</p>"
,
"boards "
,
"<p><span class=\"title\">Boards</span></p>\n"
+ "<p>"
+ "<img src=\"pedia_boards\">"
+ "You've ordered your team to strip all spare lumber from any <a "
+ "href=\"event:buildings\">buildings</a> they reconnoiter. Once they "
+ "haul it back to the nearest <a href=\"event:depot\">depot</a>, it will "
+ "fuel your survival: you can order survivors to build <a "
+ "href=\"event:sniper\">sniper towers</a> or <a "
+ "href=\"event:barricade\">barricades</a>. You can even "
+ "upgrade your sniper towers... if there's time. "
+ "</p>"
,
"survivors "
,
"<p><span class=\"title\">Survivors</span></p>\n"
+ "<p>"
+ "<img src=\"pedia_survivors\">"
+ "Anyone left alive is holed up deep inside one of these <a "
+ "href=\"event:buildings\">buildings</a>, scared and hungry. But their "
+ "fear has kept them alive, and they'll be eager to join you, once "
+ "your scouts find them. You can put them to work ferrying <a "
+ "href=\"event:resources\">supplies</a>, scavenging buildings, making <a "
+ "href=\"event:barricade\">fortifications</a>, manning <a "
+ "href=\"event:sniper\">sniper towers</a>, and even setting <a "
+ "href=\"event:charges\">charges</a>. If you survive long enough to "
+ "reach them. "
+ "</p>"
,
"sniper "
,
"<p><span class=\"title\">Sniper</span></p>\n"
+ "<p>"
+ "<img src=\"pedia_sniper\">"
+ "Anyone who's handy with a rifle gets sent to man these towers, "
+ "thrown together from <a href=\"event:boards\">boards</a> and "
+ "sweat. Send more <a href=\"event:survivors\">survivors</a> to a tower "
+ "and they'll act as spotters, increasing the accuracy of your shots; "
+ "and make damn sure your snipers have enough <a "
+ "href=\"event:ammo\">ammo</a>. If you have the time "
+ "and boards, you can upgrade a sniper tower, building it up higher "
+ "to improve your range. "
+ "</p>\n"
+ "<p>"
+ "Your snipers are good shots, and sharp: they'll obey tactical orders "
+ "without question, like firing in the air to attract the <a "
+ "href=\"event:zombies\">zombies</a>, or holding fire to avoid a "
+ "swarm. But the towers themselves are rickety scrap heaps; one good "
+ "swipe from those monsters and they'll collapse. So don't let "
+ "them get within swiping distance. "
+ "</p>"
,
"workshop "
,
"<p><span class=\"title\">Workshop</span></p>\n"
+ "<p>"
+ "<img src=\"pedia_workshop\">"
+ "If something needs doing, assign a <a "
+ "href=\"event:survivors\">civvie</a> to the job by building a workshop "
+ "there: at the entrance to a <a href=\"event:buildings\">building</a> "
+ "to loot it, on a piece of <a href=\"event:rubble\">rubble</a> to clear "
+ "it, or on the bridge <a href=\"event:charges\">charges</a> to prime "
+ "them to blow. Up the quota of survivors at a workshop to get the job done faster. Collected <a "
+ "href=\"event:resources\">resources</a> get taken "
+ "back to the nearest <a href=\"event:depot\">depot</a>, ready to be ferried wherever they're needed. "
+ "</p>\n"
+ "<p>"
+ "When the job's done, the workshop automatically closes and the "
+ "assigned survivors return to base. "
+ "</p>"
,
"depot "
,
"<p><span class=\"title\">Depot</span></p>\n"
+ "<p>"
+ "<img src=\"pedia_depot\">"
+ "Your command posts and sanctuaries against the <a "
+ "href=\"event:zombies\">horde</a>. All the <a "
+ "href=\"event:resources\">resources</a> and <a "
+ "href=\"event:survivors\">survivors</a> you gather will be staged at "
+ "the nearest depot, and you can only build new structures close by "
+ "a depot which can keep them supplied. "
+ "</p>\n"
+ "<p>"
+ "As you start to control more area, you should keep a tight eye on "
+ "your supply lines. Each <a href=\"event:sniper\">sniper tower</a> or "
+ "<a href=\"event:workshop\">workshop</a> is connected to a depot; add "
+ "and remove supply lines to make sure your survivors are being routed "
+ "as efficiently as possible. "
+ "</p>"
,
"barricade "
,
"<p><span class=\"title\">Barricade</span></p>\n"
+ "<p>"
+ "<img src=\"pedia_barricade\">"
+ "Unmanned heaps of <a href=\"event:boards\">boards</a> and other junk that should "
+ "hold back the <a href=\"event:zombies\">horde</a>, though not for "
+ "long. Each costs 10 boards to build and will stand up to about that "
+ "many blows from a zombie before it collapses. You can assign <a "
+ "href=\"event:survivors\">survivors</a> to repair them if you act fast, "
+ "and increase the board quota to add durability, but you can only put "
+ "off the inevitable: those things will break through, sooner or "
+ "later. "
+ "</p>\n"
+ "<p>"
+ "But here's the good news: zombies held up by a barricade are easy "
+ "pickings for your <a href=\"event:sniper\">snipers</a>, and the things "
+ "are usually too stupid to go around them. Put up a barricade between "
+ "your sniper towers and the advancing horde and pick them off like "
+ "ducks in a shooting gallery. "
+ "</p>"
,
"buildings "
,
"<p><span class=\"title\">Buildings</span></p>\n"
+ "<p>"
+ "Whoever once owned them is dead now. Inside are exactly three things "
+ "you care about: <a href=\"event:boards\">lumber</a>, <a "
+ "href=\"event:ammo\">ammo</a>, and <a "
+ "href=\"event:survivors\">survivors</a>. The quicker you can get them "
+ "out, the better your chances. But be careful: <a "
+ "href=\"event:zombies\">zombies</a> are lurking inside too, and any "
+ "loud <a href=\"event:noise\">noise</a> nearby will draw them out into "
+ "the street. To feed. "
+ "</p>\n"
+ "<p>"
+ "Through initial recon runs you know a little about what's inside "
+ "each building. A green triangle means a cakewalk: plenty of loot and "
+ "no sign of trouble. But yellow, orange, and red triangles point to "
+ "increasing levels of bad news inside: zombies, hiding and waiting in "
+ "the quiet shadows. "
+ "</p>\n"
+ "<p>"
+ "See also: <a href=\"event:building_types\">Building Types</a>"
+ "</p>"
,
"building_types "
,
"<p><span class=\"title\">Building Types</span></p>\n"
+ "<p>"
+ "Based on a few scouting runs and detailed intel on the <a "
+ "href=\"event:zombies\">zombies</a>, you have a sense of what to expect "
+ "inside each type of <a href=\"event:buildings\">building</a>. "
+ "</p>\n"
+ "<li><a href=\"event:house\">House</a></li>"
+ "<li><a href=\"event:office\">Office</a></li>"
+ "<li><a href=\"event:apartment\">Apartment</a></li>"
+ "<li><a href=\"event:mall\">Mall</a></li>"
+ "<li><a href=\"event:police_station\">Police Station</a></li>"
+ "<li><a href=\"event:hardware_store\">Hardware Store</a></li>"
+ "<li><a href=\"event:church\">Church</a></li>"
+ "<li><a href=\"event:hospital\">Hospital</a></li>"
,
"house "
,
"<p><span class=\"title\">House</span></p>\n"
+ "<p>"
+ "<img src=\"pedia_house\">"
+ "You can't expect to find too many <a "
+ "href=\"event:resources\">resources</a> in these yuppie McMansions, but "
+ "on the plus side, 2.4 kids can't turn into too many <a "
+ "href=\"event:zombies\">zombies</a>. "
+ "</p>"
,
"office "
,
"<p><span class=\"title\">Office</span></p>\n"
+ "<p>"
+ "<img src=\"pedia_office\">"
+ "A good source for basic <a href=\"event:resources\">resources</a> in "
+ "reasonable quantities, and only a moderate amount of <a "
+ "href=\"event:zombies\">zombies</a>. Bet these schmucks wish they "
+ "hadn't put in for overtime now. "
+ "</p>"
,
"apartment "
,
"<p><span class=\"title\">Apartment</span></p>\n"
+ "<p>"
+ "<img src=\"pedia_apartment\">"
+ "<a href=\"event:resources\">Resource</a>-heavy, but swarming with <a "
+ "href=\"event:zombies\">former occupants</a>. Watch out. "
+ "</p>"
,
"mall "
,
"<p><span class=\"title\">Mall</span></p>\n"
+ "<p>"
+ "<img src=\"pedia_mall\">"
+ "The mother lode for <a href=\"event:resources\">resources</a>, but "
+ "swarming with <a href=\"event:zombies\">monsters</a>: ain't no free "
+ "lunch in this food court. "
+ "</p>"
,
"police_station "
,
"<p><span class=\"title\">Police Station</span></p>\n"
+ "<p>"
+ "<img src=\"pedia_police_station\">"
+ "<a href=\"event:ammo\">Ammunition</a> by the truckful, but since cops "
+ "were usually the first ones infected, they've had plenty of time to "
+ "feed and grow strong. Be on your guard. "
+ "</p>"
,
"hardware_store "
,
"<p><span class=\"title\">Hardware Store</span></p>\n"
+ "<p>"
+ "<img src=\"pedia_hardware_store\">"
+ "Your best source for <a href=\"event:boards\">lumber</a>, but these "
+ "seem to attract the <a href=\"event:zombies\">zombies</a>, too. Maybe "
+ "it's the smell of sawdust. "
+ "</p>"
,
"church "
,
"<p><span class=\"title\">Church</span></p>\n"
+ "<p>"
+ "<img src=\"pedia_church\">"
+ "You can bet your ass a congregation's worth of <a "
+ "href=\"event:survivors\">survivors</a> is holed up inside. But the "
+ "overgrown graveyard and shadowy halls inside offer far too many "
+ "perfect hiding places for <a href=\"event:zombies\">unholy things</a>. "
+ "</p>"
,
"hospital "
,
"<p><span class=\"title\">Hospital</span></p>\n"
+ "<p>"
+ "<img src=\"pedia_hospital\">"
+ "The sick and weak were the first to be taken, God rest their "
+ "souls. There's precious little hope of finding survivors here. What "
+ "roams the halls now is beyond your skill to heal. "
+ "</p>"
,
"zombies "
,
"<p><span class=\"title\">Zombies</span></p>\n"
+ "<p>"
+ "<img src=\"pedia_zombies\">"
+ "Keep two things in mind and you have a chance to stay alive. First, "
+ "their sense of hearing is far more acute than their vision. They're "
+ "attracted by <a href=\"event:noise\">noise</a>-- gunfire or "
+ "construction-- and will mindlessly move towards it. They can <a "
+ "href=\"event:scent\">smell</a> you too, so keep your distance and "
+ "stay quiet. "
+ "</p>\n"
+ "<p>"
+ "Second, it only takes one good shot to the head to drop them. On the "
+ "flip side, one bite from those rotten teeth and it's curtains for "
+ "you. If you get within hand-to-hand distance, you're as good as "
+ "dead. Scratch that. You're worse than dead, because soon you'll be "
+ "one of them. "
+ "</p>\n"
+ "<p>"
+ "See also: <a href=\"event:zombie_hordes\">Zombie Hordes</a>"
+ "</p>"
,
"zombie_hordes "
,
"<p><span class=\"title\">Zombie Hordes</span></p>\n"
+ "<p>"
+ "These <a href=\"event:zombies\">things</a> seem to like to move in "
+ "packs, or waves. Every so often a new horde will sweep into town "
+ "across a bridge, or swarm out of unexplored buildings angry and "
+ "drooling. The hordes only get bigger each time it happens. Better "
+ "get to those bridge <a href=\"event:charges\">charges</a> fast. "
+ "</p>"
,
"noise "
,
"<p><span class=\"title\">Noise</span></p>\n"
+ "The <a href=\"event:zombies\">zombies</a> flock to noise like moths to "
+ "flame. Loud noises like gunshots bring them from far away, but "
+ "construction noise wakes up the ones at a medium distance. Remember "
+ "that it's not just the ones in the street you have to worry about; "
+ "most of the <a href=\"event:buildings\">buildings</a> are swarming "
+ "with them too. "
+ "</p>"
,
"scent "
,
"<p><span class=\"title\">Scent</span></p>\n"
+ "<p>"
+ "Almost anything you'll do makes <a href=\"event:noise\">noise</a>, "
+ "which attracts the <a href=\"event:zombies\">zombies</a>. But those "
+ "bastards can smell you, too. Walk past some and they'll follow your "
+ "scent trail all the way back to base. Noise seems more important to "
+ "them, though; distract them with a loud noise and they'll forget "
+ "about the delicious scent of flesh-- for a while. "
+ "</p>"
,
"map_features "
,
"<p><span class=\"title\">Map Features</span></p>\n"
+ "<p>"
+ "Keep an eye on the topography around your <a "
+ "href=\"event:depot\">depots</a>. <a "
+ "href=\"event:survivors\">Survivors</a> can't move through <a "
+ "href=\"event:barricade\">barricades</a> or other structures, so make "
+ "sure they have clear paths to work, and run. Mind the urban warfare tradeoff: wide streets make your "
+ "structures harder to defend, and narrow streets make them harder to "
+ "supply. And keep an eye on where the bridges are, since both the <a "
+ "href=\"event:zombie_hordes\">hordes</a> and the <a "
+ "href=\"event:charges\">charges</a> are in that direction. "
+ "</p>\n"
+ "<p>"
+ "<a href=\"event:rubble\">Destroyed structures</a> block construction, "
+ "and must be cleared by building a <a "
+ "href=\"event:workshop\">workshop</a> on them. Also watch for parks, "
+ "whose vegetation provides cover and is hard for <a "
+ "href=\"event:sniper\">snipers</a> to shoot through. "
+ "</p>"
,
"charges "
,
"<p><span class=\"title\">Charges</span></p>\n"
+ "<p>"
+ "<img src=\"pedia_charges\">"
+ "Your only prayer of surviving this mission is to get to the charges at each bridge, build <a href=\"event:workshop\">workshops</a> on them, and buy your team enough time to get them ready to blow. "
+ "</p>"
,
"rubble "
,
"<p><span class=\"title\">Rubble</span></p>\n"
+ "<p>"
+ "<img src=\"pedia_rubble\">"
+ "Jetsam left over from the initial attack, or the sorry ruins of your own construction. Either way, it'll have to go if you want to clear a path for <a href=\"event:survivors\">survivors</a> or build new structures. Build a <a href=\"event:workshop\">workshop</a> on a tile of rubble to clear it and recover most of its <a href=\"event:resources\">resources</a>. "
+ "</p>"
,
"map_editor "
,
"<p><span class=\"title\">Map Editor</span></p>\n"
+ "<p>"
+ "When editing a map, you can click the question mark icon in the "
+ "lower-left to access this help again. "
+ "</p>\n"
+ "<p><span class=\"title\">Boxes</span></p>\n"
+ "<p>"
+ "Boxes represent areas or buildings. The outlines of boxes are shown "
+ "by thin white lines surrounding them. A box might be a single office "
+ "or a street or an area of water. "
+ "</p>\n"
+ "<p>"
+ "When you create a new map, boxes representing the ocean around an "
+ "island are created for you automatically. You can adjust them or "
+ "move them aside to create bridges. I recommend that you always make "
+ "sure to leave at least the starting amount of water around the edges "
+ "so that the status displays on the edges of the screens do not "
+ "interfere with the player's visibility. "
+ "</p>\n"
+ "<p><span class=\"title\">Creating a Box</span></p>\n"
+ "<p>"
+ "To create a new box, move the mouse to an empty (white) area of the "
+ "map. Click and drag. A green rectangle will follow your cursor "
+ "showing where the new box will be placed. If the rectangle turns "
+ "red, that means the prospective box overlaps an existing box and "
+ "will not be created. When you have a size that you want, release the "
+ "mouse and a new box will be created. "
+ "</p>\n"
+ "<p><span class=\"title\">Resizing a Box</span></p>\n"
+ "<p>"
+ "Existing boxes can be resized by dragging their corners. Move the "
+ "mouse so it is inside the box you want to resize near one of the "
+ "corners. Click and drag. You can resize the box to any dimension you "
+ "want. If it overlaps with another box or is too small for the "
+ "current box type, it will turn red. "
+ "</p>\n"
+ "<p><span class=\"title\">Selecting</span></p>\n"
+ "<p>"
+ "Select boxes and squares to edit them. A box or square which is "
+ "selected has a black outline. Click on an unselected box to select "
+ "it. Click within a selected box to select a particular square. "
+ "</p>\n"
+ "<p><span class=\"title\">Editing Boxes</span></p>\n"
+ "<p>"
+ "You can edit boxes using the combo-box and buttons on the "
+ "left. Click on the box you want to edit. Then click on the combo-box "
+ "widget in the upper-left and select what kind of area you want the "
+ "box to be. Keep in mind that some box types have a minimum size and "
+ "a box must be that size before you can change to those types. "
+ "</p>\n"
+ "<p>"
+ "All boxes can be deleted using the delete button in the "
+ "lower-left. Buildings can have zombies and resources added to "
+ "them. Some kinds of boxes, like bridges, have a direction which you "
+ "can modify using the rotate and reflect buttons. "
+ "</p>\n"
+ "<p><span class=\"title\">Editing Squares</span></p>\n"
+ "<p>"
+ "In addition to editing boxes as a whole, individual squares may be "
+ "edited as well. Some buildings allow you to set an entrance anywhere "
+ "on the perimiter. On those boxes, select the square where you want "
+ "the entrance and click 'Set Entrance' on the left. "
+ "</p>\n"
+ "<p>"
+ "You can also place zombies, rubble, or towers on any square where "
+ "they are normally allowed. You can add obstacles which permanently "
+ "block a square. You can edit the resources available at any tower or "
+ "rubble location. You can also select towers to change their quotas "
+ "or to create and destroy trade links. "
+ "</p>\n"
+ "<p>"
+ "Finally, you can select a square and remove the obstacle, rubble, or "
+ "tower there with the delete button. To remove zombies just click '-' "
+ "next to the zombie count. "
+ "</p>\n"
+ "<p><span class=\"title\">Saving, Loading, and Testing</span></p>\n"
+ "<p>"
+ "Open the system menu by clicking the system button in the lower-left "
+ "corner. From the system menu, you can save, load, and test the "
+ "current map. "
+ "</p>\n"
+ "<p>"
+ "When you click \"Save Map\", the map is encoded into a plain text "
+ "format and displayed in the white text box. You can copy and paste "
+ "that into a file for later use. "
+ "</p>\n"
+ "<p>"
+ "To load a map, copy a the text for a map into the text box. Make "
+ "sure that the only text in the text box is the map you wish to "
+ "load. Then click \"Load Map\" to load that map for editing. "
+ "</p>\n"
+ "<p>"
+ "You can also test a map by clicking \"Test Map\". When you do, you "
+ "will begin playing the current map. If you win or lose, you will be "
+ "returned to the map editor. You can also end the test by opening the "
+ "system menu and clicking \"Edit Map\". "
+ "</p>"
];
public static var easter = [
"Some city names cause special maps which change the rules a bit. "
,
"Map names must contain a certain name to be special. For instance, if 'New York' was a special map, then 'New York City' would also be the same kind of special map. "
,
"The author's home town map is a perfect grid, just like in the real world. "
,
"In the city from \"28 Days Later\", the zombies run. "
,
"There is a mall city inspired by \"Dawn of the Dead\". "
,
"A medical reference from \"Night of the Living Dead\" creates an extra challenge. "
,
"Umbrella Corporation's home town is cut off from the mainland but has lots of special buildings. "
,
"If you visit the city from \"Land of the Dead\", survive as long as you can because the zombies can cross the water... "
,
"In the city where Thriller was shot, the zombies can dance. "
];
  public static var playPediaRoot = StringTools.trim(playPediaRootSecret);
  public static var editPediaRoot = StringTools.trim(editPediaRootSecret);
}
