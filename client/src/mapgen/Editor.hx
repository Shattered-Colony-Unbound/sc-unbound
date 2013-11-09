package mapgen;

class Editor
{
  public function new(parent : flash.display.DisplayObjectContainer) : Void
  {
    boxes = new List<EditBox>();
    selected = null;
    selectedSquare = null;
    dragOrigin = null;
    dragCurrent = null;
    selectedClip = new flash.display.Shape();
    parent.addChild(selectedClip);
    dragBox = new flash.display.Shape();
    parent.addChild(dragBox);
    menu = new EditMenu(parent);
  }

  public function cleanup() : Void
  {
    menu.cleanup();
    dragBox.parent.removeChild(dragBox);
    selectedClip.parent.removeChild(selectedClip);
  }

  public function hover(pos : Point) : Void
  {
    menu.hover(pos);
  }

  public function beginDrag(begin : Point) : Void
  {
    var current = Game.map.getCell(begin.x, begin.y).edit;
    if (current != null)
    {
      var offset = current.getOffset();
      var limit = current.getLimit();
      // If you start dragging at a corner, set the origin to the
      // opposite corner.
      if ((begin.x == offset.x
           || begin.x == limit.x - 1)
          && (begin.y == offset.y
              || begin.y == limit.y - 1))
      {
        dragOrigin = offset.clone();
        if (begin.x == offset.x)
        {
          dragOrigin.x = limit.x - 1;
        }
        if (begin.y == offset.y)
        {
          dragOrigin.y = limit.y - 1;
        }
      }
    }
    else if (current == null)
    {
      dragOrigin = begin.clone();
      dragCurrent = null;
      clickSquare(null);
    }
    else
    {
      dragOrigin = null;
      dragCurrent = null;
    }
  }

  public function updateDrag(? current : Point) : Void
  {
    if (current != null)
    {
      dragCurrent = current.clone();
    }
    if (dragOrigin != null && dragCurrent != null
        && ! Lib.outsideMap(dragOrigin) && ! Lib.outsideMap(dragCurrent))
    {
      var originBox = Game.map.getCell(dragOrigin.x, dragOrigin.y).edit;
      if (selected != originBox)
      {
        selected = originBox;
      }
      selectedSquare = null;
      updateSelect();
      var offset = Lib.getOffset(dragOrigin, dragCurrent);
      var limit = Lib.getLimit(dragOrigin, dragCurrent);
      var first = Game.view.window.toRelative(offset.x, offset.y).toPixel();
      var second = new Point(limit.x - offset.x, limit.y - offset.y).toPixel();
      var color = ui.Color.allowEditBox;
      if (isOverlap(offset, limit) || tooSmall(offset, limit))
      {
        color = ui.Color.denyEditBox;
      }
      dragBox.graphics.clear();
      dragBox.graphics.lineStyle(dragBoxBorder, ui.Color.editBoxBorder);
      dragBox.graphics.beginFill(color);
      dragBox.graphics.drawRect(first.x, first.y, second.x, second.y);
      dragBox.graphics.endFill();
    }
  }

  public function endDrag(end : Point) : Void
  {
    if (dragOrigin != null && ! Lib.outsideMap(dragOrigin)
        && ! Lib.outsideMap(end))
    {
      var begin = dragOrigin;
      var offset = Lib.getOffset(begin, end);
      var limit = Lib.getLimit(begin, end);
      if (! isOverlap(offset, limit) && ! tooSmall(offset, limit))
      {
        if (selected == null)
        {
          var newBox = new EditBox(offset, limit);
          newBox.bind();
          newBox.show();
          boxes.add(newBox);
          clickSquare(end);
        }
        else
        {
          selected.resize(offset, limit);
          selectedSquare = null;
          updateSelect();
        }
      }
      dragOrigin = null;
      dragCurrent = null;
      dragBox.graphics.clear();
      Game.view.mini.update();
      Game.view.window.refresh();
    }
  }

  public function clickSquare(pos : Point) : Void
  {
    if (pos == null)
    {
      selected = null;
      selectedSquare = null;
    }
    else
    {
      var newSelect = Game.map.getCell(pos.x, pos.y).edit;
      if (selected != newSelect || selectedSquare != null)
      {
        selected = newSelect;
        selectedSquare = null;
      }
      else
      {
        selectedSquare = pos.clone();
      }
    }
    updateSelect();
  }

  public function updateSelect() : Void
  {
    selectedClip.graphics.clear();
    if (selected != null)
    {
      if (selectedSquare == null)
      {
        var offset = Game.view.window.toRelative(selected.getOffset().x,
                                                 selected.getOffset().y).toPixel();
        var limit = Game.view.window.toRelative(selected.getLimit().x,
                                                selected.getLimit().y).toPixel();
        selectedClip.graphics.lineStyle(selectedBorder, ui.Color.editSelected);
        selectedClip.graphics.drawRect(offset.x, offset.y,
                                       limit.x - offset.x, limit.y - offset.y);
      }
      else
      {
        var offset = Game.view.window.toRelative(selectedSquare.x,
                                                 selectedSquare.y).toPixel();
        var limit = new Point(offset.x + Option.cellPixels,
                              offset.y + Option.cellPixels);
        selectedClip.graphics.lineStyle(selectedBorder, ui.Color.editSelected);
        selectedClip.graphics.drawRect(offset.x, offset.y,
                                       limit.x - offset.x, limit.y - offset.y);
      }
    }
    if (selectedSquare == null)
    {
      Game.update.changeSelect(null);
    }
    menu.update(selected, selectedSquare);
  }

  public function changeType(newType : EditType) : Void
  {
    if (selected != null)
    {
      selected.changeType(newType);
      updateSelect();
      Game.view.mini.update();
      Game.view.window.refresh();
    }
  }

  function isOverlap(offset : Point, limit : Point) : Bool
  {
    var result = false;
    for (y in (offset.y)...(limit.y))
    {
      for (x in (offset.x)...(limit.x))
      {
        var current = Game.map.getCell(x, y).edit;
        var background = Game.map.getCell(x, y).getBackground();
        if (background == BackgroundType.EDGE ||
            !(current == null || current == selected))
        {
          result = true;
          break;
        }
      }
      if (result)
      {
        break;
      }
    }
    return result;
  }

  function tooSmall(offset : Point, limit : Point) : Bool
  {
    var result = false;
    if (selected != null)
    {
      var type = selected.getType();
      result = (limit.x - offset.x < type.minSize
                || limit.y - offset.y < type.minSize);
    }
    return result;
  }

  public function removeBoxFromList(box : EditBox) : Void
  {
    boxes.remove(box);
    Game.view.mini.update();
    Game.view.window.refresh();
  }

  public static var edgeCount = 5;
  static var waterCount = 3;

  public static function createEdges() : Void
  {
    var lot = new Section(new Point(0, 0), Game.map.size().clone());
    for (dir in Lib.directions)
    {
      var current = lot.slice(dir, edgeCount);
      Util.fillBlocked(current);
      Util.fillBackground(current, BackgroundType.EDGE);
      Util.fillAddTile(current, Tile.EDGE);
      Game.view.window.fillRegion(current.offset, current.limit);
      lot = lot.remainder(dir, edgeCount);
    }
  }

  public function createBorders() : Void
  {
    var lot = new Section(new Point(edgeCount, edgeCount),
                          new Point(Game.map.size().x - edgeCount,
                                    Game.map.size().y - edgeCount));
    Util.fillBlocked(lot);
    Util.fillBackground(lot, BackgroundType.STREET);
    for (dir in Lib.directions)
    {
      lot = createBorderEdge(lot, dir, waterCount - 1,
                             EditBox.DEEP_WATER);
    }
    for (dir in Lib.directions)
    {
      lot = createBorderEdge(lot, dir, 1, EditBox.SHALLOW_WATER);
    }
  }

  function createBorderEdge(lot : Section, dir : Direction, size : Int,
                            type : EditType) : Section
  {
    var result = lot.remainder(dir, size);
    var edge = lot.slice(dir, size);
    var newBox = new EditBox(edge.offset, edge.limit);
    newBox.bind();
    newBox.changeType(type);
    boxes.add(newBox);
    return result;
  }

  public function getSelectedSquare() : Point
  {
    return selectedSquare;
  }

  public function saveMap() : flash.utils.ByteArray
  {
    var output = new flash.utils.ByteArray();
    EditLoader.saveMap(output, boxes);
    return output;
  }

  public function loadMap(data : flash.utils.ByteArray) : Void
  {
    EditLoader.loadMap(data, boxes);
  }

  var boxes : List<EditBox>;
  var selected : EditBox;
  var selectedSquare : Point;
  var dragOrigin : Point;
  var dragCurrent : Point;
  var dragBox : flash.display.Shape;
  var selectedClip : flash.display.Shape;
  var menu : EditMenu;

  static var dragBoxBorder = 2;
  static var selectedBorder = 4;
}
