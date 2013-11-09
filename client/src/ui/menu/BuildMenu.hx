// Build menu at the bottom of the screen which allows new towers to be built.
package ui.menu;

class BuildMenu
{
  static var NO_ACTION = -1;
  static var BARRICADE = 0;
  static var DEPOT = 1;
  static var SNIPER = 2;
  static var WORKSHOP = 3;

  public function new(parent : flash.display.DisplayObjectContainer,
                      l : ui.LayoutGame)
  {
    clip = new BuildMenuClip();
    parent.addChild(clip);
    clip.visible = true;
    clip.mouseEnabled = false;
    buttonList = new ui.ButtonList(click, hover,
                                   [clip.barricade, clip.depot, clip.sniper,
                                    clip.workshop]);
    clip.addEventListener(flash.events.MouseEvent.ROLL_OVER, rollOver);
    resize(l);
    action = NO_ACTION;
  }

  public function cleanup() : Void
  {
    clip.removeEventListener(flash.events.MouseEvent.ROLL_OVER, rollOver);
    buttonList.cleanup();
    clip.parent.removeChild(clip);
    clip = null;
  }

  public function resize(l : ui.LayoutGame) : Void
  {
    clip.x = l.buildMenuOffset.x;
    clip.y = l.buildMenuOffset.y;
  }

  public function hotkey(ch : String, code : Int) : Bool
  {
    var used = true;
    if (ch == "s" || ch == "S")
    {
      click(SNIPER);
    }
    else if (ch == "b" || ch == "B")
    {
      click(BARRICADE);
    }
    else if (ch == "d" || ch == "D")
    {
      click(DEPOT);
    }
    else if (ch == "w" || ch == "W")
    {
      click(WORKSHOP);
    }
    else if (action != NO_ACTION && code == Keyboard.escapeCode)
    {
      ui.Util.success();
      resetAction();
    }
    else
    {
      used = false;
    }
    return used;
  }

  function rollOver(event : flash.events.MouseEvent) : Void
  {
    Game.view.toolTip.hide();
  }


  public function hoverTower(dest : Point) : Void
  {
    var text = null;
    if (action == NO_ACTION)
    {
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
    }
    else
    {
      text = ui.Text.towerBuildTip;
    }
    Game.view.toolTip.show(text);
  }

  public function hoverBackground(dest : Point) : Void
  {
    var text = null;
    var cell = Game.map.getCell(dest.x, dest.y);
    if (action == NO_ACTION)
    {
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
    }
    else
    {
      // Deal with universal build problems
      if (cell.hasShadow())
      {
        text = ui.Text.backgroundBuildShadowTip;
      }
      else if (cell.hasZombies())
      {
        text = ui.Text.backgroundBuildZombieTip;
      }
      else if (cell.getBackground() == BackgroundType.BRIDGE)
      {
        text = ui.Text.backgroundBuildBridgeTip;
      }
      else if (! Tower.isSupplied(dest.x, dest.y))
      {
        text = ui.Text.backgroundBuildSupplyTip(Std.string(Option.supplyRange));
      }
      else if (getBuildType(action) == Tower.WORKSHOP)
      {
        if (cell.getBuilding() != null && cell.getBuilding().hasZombies())
        {
          text = ui.Text.workshopBuildingZombiesTip;
        }
        else if (cell.getBuilding() != null
                 && ! cell.getBuilding().hasResources())
        {
          text = ui.Text.workshopBuildingEmptyTip;
        }
        else if (cell.getBackground() == BackgroundType.BUILDING)
        {
          text = ui.Text.workshopBuildingTip;
        }
        else if (cell.isBlocked())
        {
          text = ui.Text.backgroundBuildBlockedTip;
        }
        else if (cell.getBackground() == BackgroundType.ENTRANCE)
        {
          text = ui.Text.workshopEntranceTip;
        }
        else if (cell.mFeature != null)
        {
          text = cell.mFeature.getWorkshopTip();
        }
        else if (cell.hasRubble())
        {
          text = ui.Text.workshopRubbleTip;
        }
        else
        {
          text = ui.Text.workshopBackgroundTip;
        }
      }
      else
      {
        var type = getBuildType(action);
        if (cell.isBlocked())
        {
          text = ui.Text.backgroundBuildBlockedTip;
        }
        else if (cell.mFeature != null)
        {
          text = cell.mFeature.getBuildTip();
        }
        else if (cell.getBackground() == BackgroundType.ENTRANCE
                 && cell.getBuilding().hasResources())
        {
          text = ui.Text.backgroundEntranceTip;
        }
        else if (cell.getBackground() == BackgroundType.ENTRANCE)
        {
          text = ui.Text.backgroundEmptyEntranceTip;
        }
        else if (cell.hasRubble())
        {
          text = ui.Text.backgroundBuildRubbleTip;
        }
        else if (type == Tower.BARRICADE)
        {
          text = ui.Text.backgroundBarricadeTip;
        }
        else if (type == Tower.SNIPER)
        {
          text = ui.Text.backgroundSniperTip;
        }
        else // type == Tower.DEPOT
        {
          text = ui.Text.backgroundDepotTip;
        }
      }
    }
    Game.view.toolTip.show(text);
  }

  public function clickTower(dest : Point) : Void
  {
    var select = Game.select.getSelected();
    if (action == NO_ACTION)
    {
      changeSelect(dest);
      ui.Util.success();
    }
    else
    {
      ui.Util.failure();
      if (! Main.key.shift())
      {
        resetAction();
      }
      Game.view.warning.show(ui.Text.towerWarning);
    }
  }

  public function clickBackground(dest : Point) : Void
  {
    if (action == NO_ACTION)
    {
      changeSelect(dest);
      ui.Util.success();
    }
    else
    {
      var type = getBuildType(action);
      if (Tower.canPlace(type, dest.x, dest.y))
      {
        Game.map.getCell(dest.x, dest.y).createTower(type);
        var tower = Game.map.getCell(dest.x, dest.y).getTower();
        var neighbors = Game.map.findTowers(dest.x, dest.y,
                                            Option.supplyRange);
        for (current in neighbors)
        {
          var currentTower = Game.map.getCell(current.x, current.y).getTower();
          var currentType = currentTower.getType();
          if (type == Tower.DEPOT || currentType == Tower.DEPOT)
          {
            tower.addTradeLink(current);
          }
        }
//        Main.sound.play(SoundPlayer.TOWER_BUILD);
        ui.Util.success();
        if (! Main.key.shift())
        {
          resetAction();
        }
        else
        {
          Game.floater.updatePublic();
        }
      }
      else
      {
        var cell = Game.map.getCell(dest.x, dest.y);
        if (! Main.key.shift())
        {
          resetAction();
        }
        ui.Util.failure();
        var text = null;
        if (cell.hasTower() || cell.hasShadow())
        {
          text = ui.Text.towerWarning;
        }
        else if (cell.hasZombies())
        {
          text = ui.Text.placeZombieWarning;
        }
        else if (cell.isBlocked())
        {
          text = ui.Text.placeBlockedWarning;
        }
        else if (cell.getBackground() == BackgroundType.BRIDGE)
        {
          text = ui.Text.placeBridgeWarning;
        }
        else if (! Tower.isSupplied(dest.x, dest.y))
        {
          text = ui.Text.placeSupplyWarning;
        }
        else if (type == Tower.WORKSHOP)
        {
          if (cell.getBuilding() != null && cell.getBuilding().hasZombies())
          {
            text = ui.Text.placeZombieWarning;
          }
          else if (! cell.hasRubble() && cell.mFeature == null)
          {
            text = ui.Text.placeBoringWarning;
          }
        }
        else
        {
          if (cell.hasRubble())
          {
            text = ui.Text.placeRubbleWarning;
          }
          else if (cell.mFeature != null)
          {
            text = ui.Text.placeFeatureWarning;
          }
          else if (cell.getBackground() == BackgroundType.ENTRANCE
                   || cell.getBackground() == BackgroundType.BUILDING)
          {
            text = ui.Text.placeBuildingWarning;
          }
        }
        Game.view.warning.show(text);
      }
    }
  }

  function changeSelect(dest : Point) : Void
  {
    Game.view.changeSelect(dest);
  }

  function resetAction() : Void
  {
    action = NO_ACTION;
    Game.floater.stop();
    Game.script.trigger(logic.Script.CANCEL_BUILD);
  }

  function getBuildType(index : Int) : Int
  {
    var result = Tower.SNIPER;
    if (index == BARRICADE)
    {
      result = Tower.BARRICADE;
    }
    else if (index == DEPOT)
    {
      result = Tower.DEPOT;
    }
    else if (index == WORKSHOP)
    {
      result = Tower.WORKSHOP;
    }
    return result;
  }

  function click(index : Int) : Void
  {
    if (action == NO_ACTION)
    {
      action = index;
      ui.Util.success();
      var type = getBuildType(action);
      if (type == Tower.SNIPER)
      {
        Game.script.trigger(logic.Script.START_BUILD_SNIPER);
      }
      else if (type == Tower.BARRICADE)
      {
        Game.script.trigger(logic.Script.START_BUILD_BARRICADE);
      }
      else if (type == Tower.DEPOT)
      {
        Game.script.trigger(logic.Script.START_BUILD_DEPOT);
      }
      else if (type == Tower.WORKSHOP)
      {
        Game.script.trigger(logic.Script.START_BUILD_WORKSHOP);
      }
      Game.floater.start(type);
    }
    else
    {
      resetAction();
    }
  }

  function hover(index : Int) : String
  {
    var result = ui.Text.buildWorkshopTip;
    if (index == SNIPER)
    {
      result = ui.Text.buildSniperTip;
    }
    else if (index == BARRICADE)
    {
      result = ui.Text.buildBarricadeTip;
    }
    else if (index == DEPOT)
    {
      result = ui.Text.buildDepotTip;
    }
    return result;
  }

  var action : Int;
  var clip : BuildMenuClip;
  var buttonList : ui.ButtonList;
}
