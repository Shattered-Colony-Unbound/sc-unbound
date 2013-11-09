package ui.menu;

class SideSniper extends SideRoot
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      l : ui.LayoutGame) : Void
  {
    clip = new SniperMenuClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.accuracy.mouseChildren = false;
    resize(l);
    super(clip,
          [clip.abandon, clip.shootIntoAir, clip.holdFire, clip.fireAtWill,
           clip.upgrade, clip.resource.ammoDown, clip.resource.survivorsDown,
           clip.resource.ammoUp, clip.resource.survivorsUp]);
    setResourceClip(clip, clip.resource);
    stocks = [clip.resource.ammoStock, clip.resource.survivorsStock];
    quotas = [clip.resource.ammoQuota, clip.resource.survivorsQuota];
    resources = [Resource.AMMO, Resource.SURVIVORS];
    hoverBase = new ui.HoverList([cast(clip.accuracy,
                                       flash.display.DisplayObject),
                                  clip.resource.ammoStock,
                                  clip.resource.ammoIcon,
                                  clip.resource.ammoStockBackground,
                                  clip.resource.survivorsStock,
                                  clip.resource.survivorsIcon,
                                  clip.resource.survivorsStockBackground,
                                  clip.resource.quota,
                                  clip.resource.ammoQuota,
                                  clip.resource.ammoQuotaBackground,
                                  clip.resource.survivorsQuota,
                                  clip.resource.survivorsQuotaBackground],
                                 [ui.Text.accuracyBarTip,
                                  ui.Text.ammoTip,
                                  ui.Text.ammoTip,
                                  ui.Text.ammoTip,
                                  ui.Text.survivorsTip,
                                  ui.Text.survivorsTip,
                                  ui.Text.survivorsTip,
                                  ui.Text.quotaTip,
                                  ui.Text.ammoQuotaTip,
                                  ui.Text.ammoQuotaTip,
                                  ui.Text.survivorsQuotaTip,
                                  ui.Text.survivorsQuotaTip]);
    if (Game.settings.isEditor())
    {
      clip.abandon.visible = false;
      clip.shootIntoAir.visible = false;
      clip.holdFire.visible = false;
      clip.fireAtWill.visible = false;
      clip.upgrade.visible = false;
    }
  }

  override public function cleanup() : Void
  {
    hoverBase.cleanup();
    super.removeResourceClip(clip);
    super.cleanup();
    clip.parent.removeChild(clip);
  }

  override public function resize(l : ui.LayoutGame) : Void
  {
    clip.x = l.sideMenuOffset.x;
    clip.y = l.sideMenuOffset.y;
  }

  override public function hotkey(ch : String, code : Int) : Bool
  {
    var used = true;
    if (ch == "a" || ch == "A")
    {
      wasteShotClick();
    }
    else if (ch == "f" || ch == "F")
    {
      toggleFireClick();
    }
    else if (ch == "u" || ch == "U")
    {
      upgradeClick();
    }
    else if (ch == '-' || ch == '_')
    {
      click(SURVIVORS_DOWN);
    }
    else if (ch == '=' || ch == "+")
    {
      click(SURVIVORS_UP);
    }
    else
    {
      used = ui.Util.towerMenuHotkey(ch, code);
    }
    return used;
  }

  static var accuracySize = 92;

  override public function show() : Void
  {
    super.show();
    var select = Game.select.getSelected();
    var tower = Game.map.getCell(select.x, select.y).getTower();
    for (i in 0...resources.length)
    {
      stocks[i].text = Std.string(tower.countResource(resources[i]));
      quotas[i].text = Std.string(tower.countReserve(resources[i]));
    }
    clip.accuracy.bar.width = tower.getAccuracy() / 100 * accuracySize;
    if (tower.canWasteShot())
    {
      buttonList.setNormal(clip.shootIntoAir);
    }
    else
    {
      buttonList.setGhosted(clip.shootIntoAir);
    }

    if (! Game.settings.isEditor())
    {
      if (tower.isHoldingFire())
      {
        clip.holdFire.visible = true;
        clip.fireAtWill.visible = false;
      }
      else
      {
        clip.holdFire.visible = false;
        clip.fireAtWill.visible = true;
      }


      if (tower.isUpgrading())
      {
        buttonList.setProgress(clip.upgrade);
        clip.upgrade.visible = true;
      }
      else if (! tower.canUpgrade())
      {
        clip.upgrade.visible = false;
      }
      else if (tower.getUpgradeSupplier() == null)
      {
        buttonList.setGhosted(clip.upgrade);
        clip.upgrade.visible = true;
      }
      else
      {
        buttonList.setNormal(clip.upgrade);
        clip.upgrade.visible = true;
      }
    }

    showReserveButtons([clip.resource.ammoDown, clip.resource.survivorsDown],
                       [Resource.AMMO, Resource.SURVIVORS]);
    if (tower.countReserve(Resource.SURVIVORS) >= Sniper.maxSurvivors)
    {
      buttonList.setGhosted(clip.resource.survivorsUp);
    }
    else
    {
      buttonList.setNormal(clip.resource.survivorsUp);
    }
  }

  override function click(index : Int) : Void
  {
    if (index == ABANDON)
    {
      ui.Util.fleeClick();
      ui.Util.success();
    }
    else if (index == SHOOT_INTO_AIR)
    {
      wasteShotClick();
    }
    else if (index == HOLD_FIRE || index == FIRE_AT_WILL)
    {
      toggleFireClick();
    }
    else if (index == UPGRADE)
    {
      upgradeClick();
    }
    else
    {
      var isIncreasing = getIncreasing(index);
      var resource = getResource(index);
//      var tower = getTower();
//      if (! isIncreasing || resource != Resource.SURVIVORS
//          || tower.countReserve(Resource.SURVIVORS) < Sniper.maxSurvivors)
//      {
        barClick(resource, isIncreasing);
//      }
//      else
//      {
//        ui.Util.failure();
//      }
    }
  }

  override function hover(index : Int) : String
  {
    var result = null;
    if (index == ABANDON)
    {
      result = ui.Util.fleeHover();
    }
    else if (index == SHOOT_INTO_AIR)
    {
      result = wasteShotHover();
    }
    else if (index == HOLD_FIRE || index == FIRE_AT_WILL)
    {
      result = toggleFireHover();
    }
    else if (index == UPGRADE)
    {
      result = upgradeHover();
    }
    else
    {
      var isIncreasing = getIncreasing(index);
      var resource = getResource(index);
      result = barHover(resource, isIncreasing);
    }
    return result;
  }

  function getIncreasing(index : Int) : Bool
  {
    var result = true;
    if (index == AMMO_DOWN || index == SURVIVORS_DOWN)
    {
      result = false;
    }
    return result;
  }

  function getResource(index : Int) : Resource
  {
    var result = Resource.SURVIVORS;
    if (index == AMMO_DOWN || index == AMMO_UP)
    {
      result = Resource.AMMO;
    }
    return result;
  }

  function wasteShotClick() : Void
  {
    var select = Game.select.getSelected();
    var tower = Game.map.getCell(select.x, select.y).getTower();
    if (tower.canWasteShot())
    {
      ui.Util.success();
      tower.wasteShot();
      Game.script.trigger(logic.Script.CLICK_SHOOT, select);
    }
    else
    {
      ui.Util.failure();
      if (tower.countResource(Resource.SURVIVORS) == 0)
      {
        Game.view.warning.show(ui.Text.noSurvivorsWarning);
      }
      else if (tower.countResource(Resource.AMMO) == 0)
      {
        Game.view.warning.show(ui.Text.noAmmoWarning);
      }
      else
      {
        Game.view.warning.show(ui.Text.noBoardsWarning);
      }
    }
    show();
  }

  function wasteShotHover() : String
  {
    var select = Game.select.getSelected();
    var tower = Game.map.getCell(select.x, select.y).getTower();
    if (tower.canWasteShot())
    {
      return ui.Text.wasteShotTip;
    }
    else
    {
      return ui.Text.noWasteShotTip;
    }
  }

  function toggleFireClick() : Void
  {
    var select = Game.select.getSelected();
    var tower = Game.map.getCell(select.x, select.y).getTower();
    tower.toggleHoldFire();
    Game.script.trigger(logic.Script.CLICK_HOLD_FIRE, select);
    ui.Util.success();
    show();
  }

  function toggleFireHover() : String
  {
    var select = Game.select.getSelected();
    var tower = Game.map.getCell(select.x, select.y).getTower();
    if (tower.isHoldingFire())
    {
      return ui.Text.enableFireTip;
    }
    else
    {
      return ui.Text.disableFireTip;
    }
  }

  function upgradeClick() : Void
  {
    var select = Game.select.getSelected();
    var tower = Game.map.getCell(select.x, select.y).getTower();
    var success = tower.startUpgradeTruck();
    if (success)
    {
      Game.script.trigger(logic.Script.CLICK_UPGRADE, select);
      ui.Util.success();
    }
    else
    {
      ui.Util.failure();
      if (tower.isUpgrading())
      {
        Game.view.warning.show(ui.Text.upgradeInProgressWarning);
      }
      else
      {
        Game.view.warning.show(ui.Text.noUpgradeResourcesWarning);
      }
    }
    show();
  }

  function upgradeHover() : String
  {
    var result = null;
    var select = Game.select.getSelected();
    var tower = Game.map.getCell(select.x, select.y).getTower();
    if (tower.isUpgrading())
    {
      result = ui.Text.upgradeInProgressTip;
    }
    else if (! tower.canUpgrade())
    {
      result = ui.Text.upgradeMaxTip;
    }
    else if (tower.getUpgradeSupplier() != null)
    {
      var text = tower.getUpgradeLeftText();
      result = ui.Text.upgradeSniperTip(text);
    }
    else
    {
      result = ui.Text.upgradeNoResourceTip;
    }
    return result;
  }

  function barClick(payload : Resource, isIncrease : Bool) : Void
  {
    changeReserve(payload, isIncrease);
  }

  function barHover(payload : Resource, isIncrease : Bool) : String
  {
    var result = null;
    var index = Lib.resourceToIndex(payload);
    if (isIncrease)
    {
      result = barIncreaseTip[index];
    }
    else if (getTower().countReserve(payload) > 0)
    {
      result = barDecreaseTip[index];
    }
    else
    {
      result = SideRoot.barNoDecreaseTip[index];
    }
    return result;
  }

  var clip : SniperMenuClip;

  var stocks : Array<flash.text.TextField>;
  var quotas : Array<flash.text.TextField>;
  var resources : Array<Resource>;
  var hoverBase : ui.HoverList;

  static var ABANDON = 0;
  static var SHOOT_INTO_AIR = 1;
  static var HOLD_FIRE = 2;
  static var FIRE_AT_WILL = 3;
  static var UPGRADE = 4;
  static var AMMO_DOWN = 5;
  static var SURVIVORS_DOWN = 6;
  static var AMMO_UP = 7;
  static var SURVIVORS_UP = 8;

  static var barIncreaseTip = [ui.Text.sniperAmmoIncreaseTip,
                               null,
                               null,
                               ui.Text.sniperSurvivorsIncreaseTip];
  static var barDecreaseTip = [ui.Text.sniperAmmoDecreaseTip,
                               null,
                               null,
                               ui.Text.sniperSurvivorsDecreaseTip];
}
