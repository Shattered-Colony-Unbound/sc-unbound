package ui.menu;

class SideDepot extends SideRoot
{
  static var resources = [Resource.AMMO, Resource.BOARDS, Resource.SURVIVORS];

  public function new(parent : flash.display.DisplayObjectContainer,
                      l : ui.LayoutGame) : Void
  {
    clip = new DepotMenuClip();
    parent.addChild(clip);
    clip.visible = false;
    resize(l);
    quotaText = [clip.resource.ammoQuota, clip.resource.boardsQuota,
                 clip.resource.survivorsQuota];
    stockText = [clip.resource.ammoStock, clip.resource.boardsStock,
                 clip.resource.survivorsStock];
    super(clip, [clip.abandon, clip.gather, clip.resource.ammoDown,
                 clip.resource.boardsDown, clip.resource.survivorsDown,
                 clip.resource.ammoUp, clip.resource.boardsUp,
                 clip.resource.survivorsUp]);
    setResourceClip(clip, clip.resource);
    hoverBase = new ui.HoverList([cast(clip.resource.ammoStock,
                                       flash.display.DisplayObject),
                                  clip.resource.ammoIcon,
                                  clip.resource.ammoStockBackground,
                                  clip.resource.boardsStock,
                                  clip.resource.boardsIcon,
                                  clip.resource.boardsStockBackground,
                                  clip.resource.survivorsStock,
                                  clip.resource.survivorsIcon,
                                  clip.resource.survivorsStockBackground,
                                  clip.resource.quota,
                                  clip.resource.ammoQuota,
                                  clip.resource.ammoQuotaBackground,
                                  clip.resource.boardsQuota,
                                  clip.resource.boardsQuotaBackground,
                                  clip.resource.survivorsQuota,
                                  clip.resource.survivorsQuotaBackground],
                                 [ui.Text.ammoTip,
                                  ui.Text.ammoTip,
                                  ui.Text.ammoTip,
                                  ui.Text.boardsTip,
                                  ui.Text.boardsTip,
                                  ui.Text.boardsTip,
                                  ui.Text.survivorsTip,
                                  ui.Text.survivorsTip,
                                  ui.Text.survivorsTip,
                                  ui.Text.quotaTip,
                                  ui.Text.ammoQuotaTip,
                                  ui.Text.ammoQuotaTip,
                                  ui.Text.boardsQuotaTip,
                                  ui.Text.boardsQuotaTip,
                                  ui.Text.survivorsQuotaTip,
                                  ui.Text.survivorsQuotaTip]);
    if (Game.settings.isEditor())
    {
      clip.abandon.visible = false;
    }
  }

  override public function cleanup() : Void
  {
    hoverBase.cleanup();
    super.removeResourceClip(clip);
    super.cleanup();
    clip.parent.removeChild(clip);
    clip = null;
  }

  override public function resize(l : ui.LayoutGame) : Void
  {
    clip.x = l.sideMenuOffset.x;
    clip.y = l.sideMenuOffset.y;
  }

  override public function hotkey(ch : String, code : Int) : Bool
  {
    var used = true;
    if (code == Keyboard.escapeCode)
    {
      ui.Util.success();
      show();
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

  override public function show() : Void
  {
    super.show();
    showResources(quotaText, stockText);
    showButtons();
  }

  override public function hide() : Void
  {
    super.hide();
  }

  static function showResources(quotaText : Array<flash.text.TextField>,
                                stockText : Array<flash.text.TextField>) : Void
  {
    for (i in 0...(quotaText.length))
    {
      var payload = resources[i];
      var tower = SideRoot.getSelectedTower();
      var loadSize = /*Lib.truckLoad(payload)*/1;
      var quota = Math.floor(tower.countReserve(payload) / loadSize);
      quotaText[i].text = Std.string(quota);
      var stock = Math.floor(tower.countResource(payload) / loadSize);
      stockText[i].text = Std.string(stock);
    }
  }

  function showButtons() : Void
  {
    showReserveButtons([clip.resource.ammoDown,
                        clip.resource.boardsDown,
                        clip.resource.survivorsDown],
                       [Resource.AMMO,
                        Resource.BOARDS,
                        Resource.SURVIVORS]);
    if (Game.progress.getDepotCount() <= 1)
    {
      buttonList.setGhosted(clip.abandon);
    }
    else
    {
      buttonList.setNormal(clip.abandon);
    }
  }

  override function click(index : Int) : Void
  {
    if (index == ABANDON)
    {
      if (Game.progress.getDepotCount() <= 1)
      {
        ui.Util.failure();
      }
      else
      {
        ui.Util.fleeClick();
        ui.Util.success();
      }
    }
    else if (index == GATHER)
    {
      var tower = getTower();
      for (payload in Lib.resource)
      {
        tower.addSand(new ResourceCount(payload, 100));
      }
      ui.Util.success();
    }
    else
    {
      var isIncreasing = getIncreasing(index);
      var resource = getResource(index);
      barClick(resource, isIncreasing);
    }
    if (index != ABANDON)
    {
      show();
    }
  }

  function getIncreasing(index : Int) : Bool
  {
    var result = true;
    if (index == AMMO_DOWN || index == BOARDS_DOWN
        || index == SURVIVORS_DOWN)
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
    else if (index == BOARDS_DOWN || index == BOARDS_UP)
    {
      result = Resource.BOARDS;
    }
    return result;
  }

  override function hover(index : Int) : String
  {
    var result = null;
    if (index == ABANDON)
    {
      if (Game.progress.getDepotCount() <= 1)
      {
        result = ui.Text.noFleeTip;
      }
      else
      {
        result = ui.Text.fleeTip;
      }
    }
    else if (index == GATHER)
    {
      result = ui.Text.gatherResourcesTip;
    }
    else
    {
      var isIncreasing = getIncreasing(index);
      var resource = getResource(index);
      result = barHover(resource, isIncreasing);
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

  var clip : DepotMenuClip;
  var quotaText : Array<flash.text.TextField>;
  var stockText : Array<flash.text.TextField>;
  var hoverBase : ui.HoverList;

  static var ABANDON = 0;
  static var GATHER = 1;
  static var AMMO_DOWN = 2;
  static var BOARDS_DOWN = 3;
  static var SURVIVORS_DOWN = 4;
  static var AMMO_UP = 5;
  static var BOARDS_UP = 6;
  static var SURVIVORS_UP = 7;

  static var barIncreaseTip = [ui.Text.depotAmmoIncreaseTip,
                               ui.Text.depotBoardsIncreaseTip,
                               null,
                               ui.Text.depotSurvivorsIncreaseTip];
  static var barDecreaseTip = [ui.Text.depotAmmoDecreaseTip,
                               ui.Text.depotBoardsDecreaseTip,
                               null,
                               ui.Text.depotSurvivorsDecreaseTip];
}
