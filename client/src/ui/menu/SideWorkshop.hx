package ui.menu;

class SideWorkshop extends SideRoot
{
  static var resources = [Resource.AMMO, Resource.BOARDS, Resource.SURVIVORS];

  public function new(parent : flash.display.DisplayObjectContainer,
                      l : ui.LayoutGame) : Void
  {
    clip = new WorkshopMenuClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.setCharges.mouseChildren = false;
    resize(l);
    super(clip, [clip.abandon, clip.survivorsDown, clip.survivorsUp]);

    stocks = [clip.ammoStock, clip.boardsStock,
              clip.survivorsStock];
    lefts = [clip.ammoLeft, clip.boardsLeft,
             clip.survivorsLeft];

    hoverBase = new ui.HoverList([cast(clip.setCharges,
                                       flash.display.DisplayObject),
                                  clip.ammoStock,
                                  clip.ammoIcon,
                                  clip.ammoStockBackground,
                                  clip.boardsStock,
                                  clip.boardsIcon,
                                  clip.boardsStockBackground,
                                  clip.survivorsStock,
                                  clip.survivorsIcon,
                                  clip.survivorsStockBackground,
                                  clip.quota,
                                  clip.survivorsQuota,
                                  clip.survivorsQuotaBackground,
                                  clip.leftToExtract,
                                  clip.ammoLeft,
                                  clip.ammoLeftBackground,
                                  clip.boardsLeft,
                                  clip.boardsLeftBackground,
                                  clip.survivorsLeft,
                                  clip.survivorsLeftBackground],
                                 [ui.Text.setChargesBarTip,
                                  ui.Text.ammoTip,
                                  ui.Text.ammoTip,
                                  ui.Text.ammoTip,
                                  ui.Text.boardsTip,
                                  ui.Text.boardsTip,
                                  ui.Text.boardsTip,
                                  ui.Text.survivorsTip,
                                  ui.Text.survivorsTip,
                                  ui.Text.survivorsTip,
                                  ui.Text.quotaTip,
                                  ui.Text.survivorsQuotaTip,
                                  ui.Text.survivorsQuotaTip,
                                  ui.Text.leftToExtractTip,
                                  ui.Text.ammoLeftTip,
                                  ui.Text.ammoLeftTip,
                                  ui.Text.boardsLeftTip,
                                  ui.Text.boardsLeftTip,
                                  ui.Text.survivorsLeftTip,
                                  ui.Text.survivorsLeftTip]);
    if (Game.settings.isEditor())
    {
      clip.abandon.visible = false;
    }
  }

  override public function cleanup() : Void
  {
    hoverBase.cleanup();
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
    if (ch == '-' || ch == '_')
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

  static var setChargesSize = 128;

  override public function show() : Void
  {
    super.show();
    var select = Game.select.getSelected();
    var cell = Game.map.getCell(select.x, select.y);
    var tower = cell.getTower();
    clip.survivorsQuota.text
      = Std.string(tower.countReserve(Resource.SURVIVORS));
    for (i in 0...stocks.length)
    {
      var payload = resources[i];
      stocks[i].text = Std.string(tower.countResource(payload));
      lefts[i].text = Std.string(cell.getRubbleCount(payload));
    }
    if (cell.mFeature != null)
    {
      var workLeft = cell.mFeature.workLeft();
      var maxWork = cell.mFeature.maxWork();
      var proportion = (maxWork - workLeft) / maxWork;
      clip.setCharges.visible = true;
      clip.setCharges.bar.width = proportion * setChargesSize;
    }
    else
    {
      clip.setCharges.visible = false;
    }
    showReserveButtons([clip.survivorsDown], [Resource.SURVIVORS]);
  }

  override public function hide() : Void
  {
  }

  override function click(index : Int) : Void
  {
    if (index == ABANDON)
    {
      ui.Util.fleeClick();
      ui.Util.success();
    }
    else if (index == SURVIVORS_DOWN)
    {
      barClick(Resource.SURVIVORS, false);
    }
    else
    {
      barClick(Resource.SURVIVORS, true);
    }
  }

  override function hover(index : Int) : String
  {
    var result = null;
    if (index == ABANDON)
    {
      result = ui.Util.fleeHover();
    }
    else if (index == SURVIVORS_DOWN)
    {
      result = barHover(Resource.SURVIVORS, false);
    }
    else
    {
      result = barHover(Resource.SURVIVORS, true);
    }
    return result;
  }

  function barClick(payload : Resource, isIncrease : Bool) : Void
  {
    if (payload == Resource.SURVIVORS)
    {
      changeReserve(payload, isIncrease);
    }
  }

  function barHover(payload : Resource, isIncrease : Bool) : String
  {
    var result = null;
    if (payload == Resource.SURVIVORS)
    {
      if (isIncrease)
      {
        result = ui.Text.workshopSurvivorsIncreaseTip;
      }
      else if (getTower().countReserve(payload) > 0)
      {
        result = ui.Text.workshopSurvivorsDecreaseTip;
      }
      else
      {
        result = ui.Text.survivorsNoDecreaseTip;
      }
    }
    return result;
  }

  var clip : WorkshopMenuClip;

  var stocks : Array<flash.text.TextField>;
  var lefts : Array<flash.text.TextField>;

  var hoverBase : ui.HoverList;

  static var ABANDON = 0;
  static var SURVIVORS_DOWN = 1;
  static var SURVIVORS_UP = 2;
}
