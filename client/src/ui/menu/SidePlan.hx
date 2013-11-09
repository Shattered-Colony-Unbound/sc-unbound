package ui.menu;

class SidePlan extends SideRoot
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      l : ui.LayoutGame) : Void
  {
    clip = new PlanMenuClip();
    parent.addChild(clip);
    clip.visible = false;
    resize(l);
    super(clip, [clip.abandon]);
  }

  override public function cleanup() : Void
  {
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
    if (code == Keyboard.deleteCode || code == Keyboard.backSpaceCode)
    {
      cancelClick();
    }
    else if (code == Keyboard.escapeCode)
    {
      Game.update.changeSelect(null);
      ui.Util.success();
    }
    else
    {
      used = false;
    }
    return used;
  }

  override function click(index : Int) : Void
  {
    cancelClick();
  }

  override function hover(index : Int) : String
  {
    return cancelHover();
  }

  function cancelClick() : Void
  {
    var select = Game.select.getSelected();
    Game.map.getCell(select.x, select.y).clearShadow();
    Game.update.changeSelect(null);
    ui.Util.success();
  }

  function cancelHover() : String
  {
    return ui.Text.planCancelTip;
  }

  var clip : PlanMenuClip;
}
