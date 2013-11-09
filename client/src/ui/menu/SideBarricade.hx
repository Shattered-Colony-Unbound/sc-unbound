package ui.menu;

class SideBarricade extends SideRoot
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      l : ui.LayoutGame) : Void
  {
    clip = new BarricadeMenuClip();
    parent.addChild(clip);
    clip.visible = false;
    resize(l);
    super(clip, [clip.boardsUp, clip.boardsDown]);
    hoverBase = new ui.HoverList([cast(clip.boardsStock,
                                       flash.display.DisplayObject),
                                  clip.boardsIcon,
                                  clip.boardsStockBackground,
                                  clip.boardsQuota,
                                  clip.boardsQuotaBackground,
                                  clip.quota],
                                 [ui.Text.boardsTip,
                                  ui.Text.boardsTip,
                                  ui.Text.boardsTip,
                                  ui.Text.boardsQuotaTip,
                                  ui.Text.boardsQuotaTip,
                                  ui.Text.quotaTip]);
  }

  static var BOARDS_UP = 0;
  static var BOARDS_DOWN = 1;

  override public function cleanup() : Void
  {
    hoverBase.cleanup();
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
    var result = true;
    if (ch == '-' || ch == '_')
    {
      click(BOARDS_DOWN);
    }
    else if (ch == '=' || ch == "+")
    {
      click(BOARDS_UP);
    }
    else
    {
      result = false;
    }
    return result;
  }

  override public function show() : Void
  {
    super.show();
    var select = Game.select.getSelected();
    var tower = Game.map.getCell(select.x, select.y).getTower();
    clip.boardsStock.text = Std.string(tower.countResource(Resource.BOARDS));
    clip.boardsQuota.text = Std.string(tower.countReserve(Resource.BOARDS));
  }

  override function click(index : Int) : Void
  {
    if (index == BOARDS_UP)
    {
      barClick(Resource.BOARDS, true);
    }
    else if (index == BOARDS_DOWN)
    {
      barClick(Resource.BOARDS, false);
    }
  }

  function barClick(payload : Resource, isIncrease : Bool) : Void
  {
    changeReserve(Resource.BOARDS, isIncrease);
  }

  override function hover(index : Int) : String
  {
    if (index == BOARDS_UP)
    {
      return boardHover(Resource.BOARDS, true);
    }
    else if (index == BOARDS_DOWN)
    {
      return boardHover(Resource.BOARDS, false);
    }
    else
    {
      return null;
    }
  }

  function boardHover(payload : Resource, isIncrease : Bool) : String
  {
    var result = null;
    if (isIncrease)
    {
      return ui.Text.barricadeBoardsIncreaseTip;
    }
    else
    {
      return ui.Text.barricadeBoardsDecreaseTip;
    }
    return result;
  }

  var clip : BarricadeMenuClip;
  var hoverBase : ui.HoverList;
}
