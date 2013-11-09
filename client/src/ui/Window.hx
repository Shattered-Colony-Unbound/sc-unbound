// Window.hx
package ui;

// The code for managing and displaying the current window on the map.

class Window
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      l : LayoutGame) : Void
  {
    offset = new Point(0, 0);

    background = new flash.display.Sprite();
    background.mouseChildren = false;
    parent.addChild(background);
    background.visible = true;
    background.x = l.mapOffset.x;
    background.y = l.mapOffset.y;
    background.cacheAsBitmap = true;
    background.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, press);
    background.addEventListener(flash.events.MouseEvent.MOUSE_UP, release);
    background.addEventListener(flash.events.MouseEvent.MOUSE_MOVE,
                                hoverMove);
    var size = Game.settings.getSize().toPixel();
    var tileData = new flash.display.BitmapData(size.x, size.y,
                                                false, 0xffffff);
    tiles = new flash.display.Bitmap(tileData);
    background.addChild(tiles);

    tileStatus = new flash.display.Shape();
    background.addChild(tileStatus);
    tileStatus.visible = true;
    tileStatus.x = l.mapOffset.x;
    tileStatus.y = l.mapOffset.y;

    var clip = Workaround.attach(ui.Label.background);
    source = new flash.display.BitmapData(Lib.cellToPixel(Tile.X_COUNT),
                                              Lib.cellToPixel(Tile.Y_COUNT),
                                              true, 0);
    source.draw(clip);
    isDragging = false;
    startDrag = null;
    mouse = null;
    showingRanges = false;
  }

  public function cleanup() : Void
  {
    source.dispose();
    source = null;
    tileStatus.parent.removeChild(tileStatus);
    tileStatus = null;
    tiles.parent.removeChild(tiles);
    tiles.bitmapData.dispose();
    background.removeEventListener(flash.events.MouseEvent.MOUSE_DOWN, press);
    background.removeEventListener(flash.events.MouseEvent.MOUSE_UP, release);
    background.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE,
                                   hoverMove);
    background.stage.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE,
                                         dragMove);
    background.parent.removeChild(background);
    background = null;
  }

  public function resize(l : LayoutGame) : Void
  {
    background.x = l.mapOffset.x;
    background.y = l.mapOffset.y;
    tileStatus.x = l.mapOffset.x;
    tileStatus.y = l.mapOffset.y;
    moveWindow(offset.x, offset.y);
  }

  public function getOffset() : Point
  {
    return offset;
  }

  // Return the direction that a position is relative to the window or
  // null if it is inside the window.
  public function getDir(pos : Point) : Direction
  {
    var windowSize = Game.view.layout.windowSize;
    if (pos.x < offset.x)
    {
      return Direction.WEST;
    }
    else if (pos.y < offset.y)
    {
      return Direction.NORTH;
    }
    else if (pos.x >= offset.x + windowSize.x)
    {
      return Direction.EAST;
    }
    else if (pos.y >= offset.y + windowSize.y)
    {
      return Direction.SOUTH;
    }
    else
    {
      return null;
    }
  }

  public function getClip() : flash.display.DisplayObjectContainer
  {
    return background;
  }

  private function updateRect(rect : flash.geom.Rectangle,
                              tile : Int) : Void
  {
    rect.x = Lib.cellToPixel(tile % Tile.X_COUNT);
    rect.y = Lib.cellToPixel(Math.floor(tile / Tile.X_COUNT));
  }

  public function fillBitmap() : Void
  {
    fillRegion(new Point(0, 0),
               Game.map.size());
  }

  public function fillRegion(offset : Point, limit : Point) : Void
  {
    fillBitmapRegion(tiles, new Point(0, 0), offset, limit, true);
  }

  public function fillBitmapRegion(dest : flash.display.Bitmap,
                                   destOffset : Point,
                                   offset : Point,
                                   limit : Point,
                                   allTiles : Bool) : Void
  {
    var sourceRect = new flash.geom.Rectangle(0.0, 0.0, Option.cellPixels,
                                              Option.cellPixels);
    sourceRect.width = Option.cellPixels;
    sourceRect.height = Option.cellPixels;

    for (y in (offset.y)...(limit.y))
    {
      for (x in (offset.x)...(limit.x))
      {
        var cell = Game.map.getCell(x, y);
        for (tile in cell.getTiles())
        {
          if (allTiles || tile == cell.getTiles().last())
          {
            updateRect(sourceRect, tile);
            Workaround.copyPixels(dest,  source, sourceRect,
                                  Lib.cellToPixel(x - destOffset.x),
                                  Lib.cellToPixel(y - destOffset.y));
          }
        }
      }
    }
  }

  public function fillSolid(offset : Point, limit : Point, color : Int) : Void
  {
    Workaround.fillRect(tiles, offset.x+1, offset.y+1,
                        limit.x-1, limit.y-1, color);
  }

  public function fillEdit(offset : Point, limit : Point) : Void
  {
    fillRegion(offset, limit);
    var offsetPixel = offset.toPixel();
    var limitPixel = limit.toPixel();
    Workaround.fillRect(tiles, offsetPixel.x, offsetPixel.y,
                        limitPixel.x, offsetPixel.y+1, Color.editEmpty);
    Workaround.fillRect(tiles, offsetPixel.x, offsetPixel.y,
                        offsetPixel.x+1, limitPixel.y, Color.editEmpty);
    Workaround.fillRect(tiles, offsetPixel.x, limitPixel.y-1,
                        limitPixel.x, limitPixel.y, Color.editEmpty);
    Workaround.fillRect(tiles, limitPixel.x-1, offsetPixel.y,
                        limitPixel.x, limitPixel.y, Color.editEmpty);
  }

  public function press(event : flash.events.MouseEvent) : Void
  {
    isDragging = false;
    mouse = new Point(Math.floor(event.localX),
                      Math.floor(event.localY));
    startDrag = toAbsolute(Lib.pixelToCell(mouse.x),
                           Lib.pixelToCell(mouse.y));
    background.stage.addEventListener(flash.events.MouseEvent.MOUSE_MOVE,
                                      dragMove);
//    Game.view.mouseScroller.disable();
    if (Game.editor != null)
    {
      Game.editor.beginDrag(startDrag);
    }
  }

  public function release(event : flash.events.MouseEvent) : Void
  {
    var pixel = new Point(Math.floor(event.localX),
                          Math.floor(event.localY));
    var relative = new Point(Lib.pixelToCell(pixel.x),
                             Lib.pixelToCell(pixel.y));
    var absolute = toAbsolute(relative.x, relative.y);
    if (! isDragging && startDrag != null)
    {
      startDrag = null;
      if (Game.editor != null)
      {
        Game.editor.clickSquare(absolute);
      }
      if (Game.map.getCell(absolute.x, absolute.y).hasTower()
          || Game.map.getCell(absolute.x, absolute.y).hasShadow())
      {
        Game.view.buildMenu.clickTower(absolute);
      }
      else
      {
        Game.view.buildMenu.clickBackground(absolute);
      }
    }
    else if (isDragging && startDrag != null)
    {
      isDragging = false;
      startDrag = null;
      if (Game.editor != null)
      {
        Game.editor.endDrag(absolute);
      }
    }
    background.stage.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE,
                                         dragMove);
//    Game.view.mouseScroller.enable();
  }

  public function hoverMove(event : flash.events.MouseEvent) : Void
  {
    var xPixel = Math.floor(event.stageX);
    var yPixel = Math.floor(event.stageY);
    var pos = toAbsolute(Lib.pixelToCell(xPixel),
                         Lib.pixelToCell(yPixel));
    if (xPixel < Game.view.layout.mapOffset.x + Game.view.layout.mapSize.x
        && yPixel < Game.view.layout.mapOffset.y + Game.view.layout.mapSize.y)
    {
      if (Game.editor != null)
      {
        Game.editor.hover(pos);
      }
      if (Game.map.getCell(pos.x, pos.y).getTower() != null)
      {
        Game.view.buildMenu.hoverTower(pos);
      }
      else
      {
        Game.view.buildMenu.hoverBackground(pos);
      }
    }
  }

  public function dragMove(event : flash.events.MouseEvent) : Void
  {
    if (! event.buttonDown)
    {
      release(event);
    }
    else //if (Game.view.tutorial.canMove())
    {
      mouse.x = Math.floor(event.stageX);
      mouse.y = Math.floor(event.stageY);
      var newDrag = toAbsolute(Lib.pixelToCell(mouse.x),
                               Lib.pixelToCell(mouse.y));
      if (isDragging || ! Point.isEqual(startDrag, newDrag))
      {
        isDragging = true;
        if (! Game.settings.isEditor())
        {
          moveWindow(offset.x - newDrag.x + startDrag.x,
                     offset.y - newDrag.y + startDrag.y);
        }
        if (Game.editor != null)
        {
          Game.editor.updateDrag(newDrag);
        }
        startDrag = toAbsolute(Lib.pixelToCell(mouse.x),
                               Lib.pixelToCell(mouse.y));
      }
    }
  }

  // coord is an absolute position in cells.
  // returns the relative position of coord in cells.
  public function toRelative(absoluteX : Int, absoluteY : Int) : Point
  {
    return new Point(absoluteX - offset.x, absoluteY - offset.y);
  }

  // coord is a relative position in cells.
  // returns the absolute position of coord in cells.
  public function toAbsolute(relativeX : Int, relativeY : Int) : Point
  {
    return new Point(relativeX + offset.x, relativeY + offset.y);
  }

  private function updateCellStatus(xCell : Int, yCell : Int,
                                    color : Int, opacity : Float) : Void
  {
    var top = Lib.cellToPixel(yCell);
    var left = Lib.cellToPixel(xCell);

    var absPos = toAbsolute(xCell, yCell);
    var building = Game.map.getCell(absPos.x, absPos.y).getBuilding();
    if (building != null)
    {
      var i = Lib.directionToIndex(building.getEntranceDir());
      var lengthX = Option.cellPixels - 16;
      var lengthY = Option.cellPixels - 16;
      var x = 0;
      var y = 0;
      tileStatus.graphics.lineStyle(2, 0x000000);
      tileStatus.graphics.beginFill(color);
      tileStatus.graphics.moveTo(start.x + left, start.y + top);
      x = second[i].x * lengthX + start.x + left;
      y = second[i].y * lengthY + start.y + top;
      tileStatus.graphics.lineTo(x, y);
      x = third[i].x * lengthX + start.x + left;
      y = third[i].y * lengthY + start.y + top;
      tileStatus.graphics.lineTo(x, y);
      tileStatus.graphics.lineTo(start.x + left, start.y + top);
      tileStatus.graphics.endFill();
    }
  }

  public function updateCell(x : Int, y : Int)
  {
    refresh();
  }

  public function refresh() : Void
  {
    var l = Game.view.layout;
    tileStatus.graphics.clear();
    for (y in 0...l.windowSize.y)
    {
      for (x in 0...l.windowSize.x)
      {
        var absolute = toAbsolute(x, y);
        var cell = Game.map.getCell(absolute.x, absolute.y);
        if (cell.getBackground() == BackgroundType.ENTRANCE)
        {
          if (cell.getBuilding().getZombieCount() > 0)
          {
            var index = Lib.weightedIndex(cell.getBuilding().getZombieCount(),
                                          Option.zombieBuildingWeights);
            updateCellStatus(x, y,
                             Option.zombieBuildingColor[index],
                             Option.zombieBuildingOpacity[index]);
          }
          else if (cell.getBuilding().getSalvage().getTotalCount() > 0)
          {
            updateCellStatus(x, y,
                             Option.salvageBuildingColor,
                             Option.salvageBuildingOpacity);
          }
        }
      }
    }
  }

  public function scrollWindow(dir : Direction, distance : Int) : Void
  {
    switch (dir)
    {
    case NORTH:
      moveWindow(offset.x, offset.y - distance);
    case SOUTH:
      moveWindow(offset.x, offset.y + distance);
    case EAST:
      moveWindow(offset.x + distance, offset.y);
    case WEST:
      moveWindow(offset.x - distance, offset.y);
    }
  }

  public function moveWindowCenter(x : Int, y : Int) : Void
  {
    moveWindow(x - Game.view.layout.windowCenter.x,
               y - Game.view.layout.windowCenter.y);
  }

  // x and y are in cells
  public function moveWindow(x : Int, y : Int) : Void
  {
    var l = Game.view.layout;
    var maxOffset = new Point(Game.map.sizeX() - l.windowSize.x,
                              Game.map.sizeY() - l.windowSize.y);
    var dest = new Point(x, y);
    if (dest.x < 0)
    {
      dest.x = 0;
    }
    if (dest.x > maxOffset.x)
    {
      dest.x = maxOffset.x;
    }
    if (dest.y < 0)
    {
      dest.y = 0;
    }
    if (dest.y > maxOffset.y)
    {
      dest.y = maxOffset.y;
    }
    offset = dest;

    tiles.scrollRect = new flash.geom.Rectangle(Lib.cellToPixel(offset.x),
                                                Lib.cellToPixel(offset.y),
                                                l.mapSize.x,
                                                l.mapSize.y);
    Game.view.mini.moveWindow(dest.x, dest.y);
    Game.view.updateImageList();
    Game.script.trigger(logic.Script.MOVE_WINDOW, offset);
    for (explosion in Game.view.explosions)
    {
      explosion.moveWindow();
    }
    Game.select.update();
    if (Game.editor != null)
    {
      Game.editor.updateDrag();
      Game.editor.updateSelect();
    }
    refresh();
    updateRanges();
  }

  public function getCenter() : Point
  {
    var l = Game.view.layout;
    return new Point(offset.x + Math.floor(l.windowSize.x / 2),
                     offset.y + Math.floor(l.windowSize.y / 2));
  }

  public function toggleRanges() : Void
  {
    if (showingRanges)
    {
      Game.sprites.clearAllVisibility();
    }
    else
    {
      Game.sprites.showAllVisibility();
    }
    showingRanges = !showingRanges;
    Game.view.quickMenu.updateView(showingRanges);
  }

  public function updateRanges() : Void
  {
    if (showingRanges)
    {
      Game.sprites.showAllVisibility();
    }
  }

  public function isShowingRanges() : Bool
  {
    return showingRanges;
  }

  var offset : Point; // in cells
  var background : flash.display.DisplayObjectContainer;
  var tiles : flash.display.Bitmap;
  var tileStatus : flash.display.Shape;
  var source : flash.display.BitmapData;
  var isDragging : Bool;
  var startDrag : Point;
  var mouse : Point;

  var showingRanges : Bool;

  static var start = new Point(Math.floor(Option.cellPixels/2),
                               Math.floor(Option.cellPixels/2));
  static var second = [new Point(-1, 1),
                       new Point(-1, -1),
                       new Point(-1, -1),
                       new Point(1, -1)];
  static var third = [new Point(1, 1),
                      new Point(1, -1),
                      new Point(-1, 1),
                      new Point(1, 1)];
}
