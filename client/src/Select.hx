// Select manages the overlays to indicate a selected tower, that
// tower's supply network, and the range of its weapons.
class Select
{
  public function new(parent : flash.display.DisplayObjectContainer) : Void
  {
    selectedCell = null;

    range = new Range(parent, Option.rangeColor, Option.rangeOpacity);

    select = ui.Workaround.attach(ui.Label.select);
    parent.addChild(select);
    select.visible = false;
    select.stop();
    select.mouseEnabled = false;
    select.mouseChildren = false;
  }

  public function cleanup() : Void
  {
    select.parent.removeChild(select);
    select = null;
    range.cleanup();
    range = null;
  }

  public function resize(l : ui.LayoutGame) : Void
  {
    range.resize(l);
    update();
  }

  public function update() : Void
  {
    if (selectedCell != null)
    {
      var pixel : Point = Game.view.window.toRelative(selectedCell.x,
                                                      selectedCell.y);
      pixel.x = Lib.cellToPixel(pixel.x) + Game.view.layout.mapOffset.x;
      pixel.y = Lib.cellToPixel(pixel.y) + Game.view.layout.mapOffset.y;
      var tower = Game.map.getCell(selectedCell.x, selectedCell.y).getTower();

      updateSelect(pixel);
      if (tower != null)
      {
        updateRange(selectedCell.x, selectedCell.y, tower.getRange());
      }
    }
    else
    {
      clear();
    }
  }

  private function updateSelect(pixel : Point) : Void
  {
    if (pixel.x >= 0 && pixel.x < Game.view.layout.mapSize.x
        && pixel.y >= 0 && pixel.y < Game.view.layout.mapSize.y)
    {
      select.x = pixel.x + Math.floor(Option.cellPixels/2);
      select.y = pixel.y + Math.floor(Option.cellPixels/2);
      select.visible = true;
      select.play();
    }
    else
    {
      select.visible = false;
      select.stop();
    }
  }

  private function updateRange(sourceX : Int, sourceY : Int,
                               towerRange : Int) : Void
  {
    range.clear();
    if (towerRange > 0)
    {
      Game.map.getCell(sourceX, sourceY).getTower().showVisibility(range);
    }
    range.draw();
  }

  public function setRange(x : Int, y : Int) : Void
  {
    range.set(x, y);
  }

  public function rangeBlocked(x : Int, y : Int) : Bool
  {
    var cell = Game.map.getCell(x, y);
    return cell.isBlocked()
      || (cell.hasTower() && cell.getTower().getType() == Tower.WORKSHOP);
  }

  public function clear() : Void
  {
    range.clear();
    select.visible = false;
    select.stop();
  }

  public function isSelected() : Bool
  {
    return selectedCell != null;
  }

  public function changeSelect(newSelect : Point) : Void
  {
    if (newSelect != null)
    {
      selectedCell = newSelect.clone();
      var type = Game.map.getCell(selectedCell.x,
                                  selectedCell.y).getTower().getType();
      if (type == Tower.SNIPER)
      {
        Game.script.trigger(logic.Script.SELECT_SNIPER, selectedCell);
      }
      else if (type == Tower.BARRICADE)
      {
        Game.script.trigger(logic.Script.SELECT_BARRICADE, selectedCell);
      }
      else if (type == Tower.DEPOT)
      {
        Game.script.trigger(logic.Script.SELECT_DEPOT, selectedCell);
      }
      else if (type == Tower.WORKSHOP)
      {
        Game.script.trigger(logic.Script.SELECT_WORKSHOP, selectedCell);
      }
    }
    else
    {
      selectedCell = null;
      Game.script.trigger(logic.Script.SELECT_NOTHING);
    }
    update();
  }

  public function getSelected() : Point
  {
    return selectedCell;
  }

  var selectedCell : Point;

  // From lowest to highest
  var range : Range;
  var select : flash.display.MovieClip;
}
