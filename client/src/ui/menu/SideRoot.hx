package ui.menu;

class SideRoot
{
  public function new(newBase : flash.display.MovieClip,
                      ? optButtonList : Array<flash.display.MovieClip>)
    : Void
  {
    base = newBase;
    alpha = 0;
    if (base != null)
    {
      base.alpha = 0.0;
      base.addEventListener(flash.events.MouseEvent.ROLL_OVER, baseOver);
    }
    resourceClip = null;
    var newButtonList = [];
    if (optButtonList != null)
    {
      newButtonList = optButtonList;
    }
    buttonList = new ui.ButtonList(click, hover, newButtonList);
  }

  public function cleanup() : Void
  {
    if (base != null)
    {
      base.removeEventListener(flash.events.MouseEvent.ROLL_OVER, baseOver);
    }
    buttonList.cleanup();
  }

  public function resize(l : ui.LayoutGame) : Void
  {
  }

  function setResourceClip(clip : flash.display.MovieClip,
                           newResourceClip : flash.display.MovieClip)
  {
    resourceClip = newResourceClip;
    resourceClip.y = Game.view.layout.resourceShownOffset;
    clip.addEventListener(flash.events.MouseEvent.ROLL_OVER, rollOver);
    clip.addEventListener(flash.events.MouseEvent.ROLL_OUT, rollOut);
  }

  function removeResourceClip(clip : flash.display.MovieClip)
  {
    if (resourceClip != null)
    {
      clip.removeEventListener(flash.events.MouseEvent.ROLL_OVER, rollOver);
      clip.removeEventListener(flash.events.MouseEvent.ROLL_OUT, rollOut);
      resourceClip = null;
    }
  }

  function rollOver(event : flash.events.MouseEvent) : Void
  {
//    resourceClip.y = Game.view.layout.resourceShownOffset;
  }

  function rollOut(event : flash.events.MouseEvent) : Void
  {
//    resourceClip.y = Game.view.layout.resourceHiddenOffset;
  }

  function baseOver(event : flash.events.MouseEvent) : Void
  {
    Game.view.toolTip.hide();
  }

  function click(index : Int) : Void
  {
  }

  function hover(index : Int) : String
  {
    return null;
  }

  public function hoverTower(dest : Point) : Void
  {
    var text = null;
    var tower = Game.map.getCell(dest.x, dest.y).getTower();
    var type = tower.getType();
    if (type == Tower.DEPOT)
    {
      text = ui.Text.hoverDepotTip;
    }
    else if (type == Tower.WORKSHOP)
    {
      text = ui.Text.hoverWorkshopTip;
    }
    else if (type == Tower.SNIPER)
    {
      if (tower.countResource(Resource.SURVIVORS) == 0)
      {
        text = ui.Text.hoverSniperNoSurvivorsTip;
      }
      else if (tower.countResource(Resource.AMMO) == 0)
      {
        text = ui.Text.hoverSniperNoAmmoTip;
      }
      else if (tower.isHoldingFire())
      {
        text = ui.Text.hoverSniperHoldFireTip;
      }
      else
      {
        text = ui.Text.hoverSniperTip;
      }
    }
    else // type == Tower.BARRICADE
    {
      if (tower.countResource(Resource.BOARDS) == 0)
      {
        text = ui.Text.hoverBarricadeNoBoardsTip;
      }
      else
      {
        text = ui.Text.hoverBarricadeTip;
      }
    }
    Game.view.toolTip.show(text);
  }

  public function hoverBackground(dest : Point) : Void
  {
    var cell = Game.map.getCell(dest.x, dest.y);
    var text = null;
    if (cell.hasShadow())
    {
      text = ui.Text.hoverPlanTip;
    }
    else if (cell.mFeature != null)
    {
      text = cell.mFeature.getHoverTip();
    }
    else if (cell.hasZombies())
    {
      text = ui.Text.hoverZombieTip;
    }
    else if (cell.getBuilding() != null)
    {
      text = cell.getBuilding().getToolTip();
    }
    else if (cell.hasRubble())
    {
      text = ui.Text.hoverRubbleTip;
    }
    Game.view.toolTip.show(text);
  }

  public function hotkey(ch : String, code : Int) : Bool
  {
    return false;
  }

  public function tower(dest : Point) : Int
  {
    ui.Util.success();
    return changeSelect(dest);
  }

  public function background(dest : Point) : Int
  {
    if (Game.select.getSelected() != null)
    {
      ui.Util.success();
    }
    return changeSelect(dest);
  }

  function changeSelect(dest : Point) : Int
  {
    if (dest == null)
    {
      Game.update.changeSelect(null);
    }
    else
    {
      var cell = Game.map.getCell(dest.x, dest.y);
      if (cell.hasTower() || cell.hasShadow())
      {
        if (! Game.settings.isEditor()
            || Point.isEqual(Game.editor.getSelectedSquare(), dest))
        {
          Game.update.changeSelect(dest);
        }
        else
        {
          Game.update.changeSelect(null);
        }
      }
      else
      {
        Game.update.changeSelect(null);
      }
    }
    return SideBar.NONE;
  }

  function getTower() : Tower
  {
    return getSelectedTower();
  }

  static function getSelectedTower() : Tower
  {
    var selected = Game.select.getSelected();
    return Game.map.getCell(selected.x, selected.y).getTower();
  }

  function showReserveButtons(buttons : Array<flash.display.MovieClip>,
                              resources : Array<Resource>) : Void
  {
    var tower = getTower();
    for (i in 0...(buttons.length))
    {
      if (tower.countReserve(resources[i]) < Lib.truckLoad(resources[i]))
      {
        buttonList.setGhosted(buttons[i]);
      }
      else
      {
        buttonList.setNormal(buttons[i]);
      }
    }
  }

  function changeReserve(payload : Resource, isIncrease : Bool) : Void
  {
    var hasBeeped = false;
    var count = 1;
    if (Main.key.shift())
    {
      count = 5;
    }
    for (i in 0...count)
    {
      var load = new ResourceCount(payload, Lib.truckLoad(payload));
      var select = Game.select.getSelected();
      if (isIncrease)
      {
        var tower = getTower();
        if (tower.getType() != Tower.SNIPER || payload != Resource.SURVIVORS
            || tower.countReserve(Resource.SURVIVORS) < Sniper.maxSurvivors)
        {
          tower.addReserve(load);
          if (! hasBeeped)
          {
            ui.Util.success();
            hasBeeped = true;
          }
          if (payload == Resource.AMMO)
          {
            Game.script.trigger(logic.Script.CLICK_ADD_AMMO, select);
          }
          else if (payload == Resource.BOARDS)
          {
            Game.script.trigger(logic.Script.CLICK_ADD_BOARDS, select);
          }
          else if (payload == Resource.SURVIVORS)
          {
            Game.script.trigger(logic.Script.CLICK_ADD_SURVIVORS, select);
          }
        }
        else if (! hasBeeped)
        {
          ui.Util.failure();
          hasBeeped = true;
        }
      }
      else if (getTower().countReserve(payload) > 0)
      {
        getTower().removeReserve(load);
        if (! hasBeeped)
        {
          ui.Util.success();
          hasBeeped = true;
        }
        if (payload == Resource.AMMO)
        {
          Game.script.trigger(logic.Script.CLICK_REMOVE_AMMO, select);
        }
        else if (payload == Resource.BOARDS)
        {
          Game.script.trigger(logic.Script.CLICK_REMOVE_BOARDS, select);
        }
        else if (payload == Resource.SURVIVORS)
        {
          Game.script.trigger(logic.Script.CLICK_REMOVE_SURVIVORS, select);
        }
      }
      else if (! hasBeeped)
      {
        ui.Util.failure();
        hasBeeped = true;
      }
    }
  }

  public function show() : Void
  {
    if (base != null)
    {
      base.visible = true;
    }
  }

  public function stepShow() : Void
  {
    if (base != null)
    {
      if (alpha < maxAlpha)
      {
        ++alpha;
        if (alpha == maxAlpha)
        {
          base.alpha = 1.0;
        }
        else
        {
          base.alpha = alpha / maxAlpha;
        }
      }
    }
  }

  public function hide() : Void
  {
  }

  public function stepHide() : Void
  {
    if (base != null)
    {
      if (alpha > 0)
      {
        --alpha;
        if (alpha == 0)
        {
          base.alpha = 0.0;
          base.visible = false;
        }
        else
        {
          base.alpha = alpha / maxAlpha;
        }
      }
    }
  }

  var buttonList : ui.ButtonList;
  var resourceClip : flash.display.MovieClip;
  var base : flash.display.MovieClip;
  var alpha : Int;

  static var maxAlpha = 3;

  static var barNoDecreaseTip = [ui.Text.ammoNoDecreaseTip,
                                 ui.Text.boardsNoDecreaseTip,
                                 ui.Text.foodNoDecreaseTip,
                                 ui.Text.survivorsNoDecreaseTip];
}
