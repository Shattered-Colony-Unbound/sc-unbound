// Separated into foreground and background bitmaps so that supply
// lines are drawn above background elements (roads, buildings,
// zombies), but below foreground elements (towers, trucks).

package ui;

class MiniMap
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      l : LayoutGame) : Void
  {
    monitor = new MonitorClip();
    parent.addChild(monitor);
    monitor.visible = true;
    monitor.scaleX = l.monitorScaleX;
    monitor.scaleY = l.monitorScaleY;
    clip = new flash.display.Sprite();
    parent.addChild(clip);
    clip.visible = true;
    clip.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, bitmapPress);
    clip.addEventListener(flash.events.MouseEvent.MOUSE_UP, bitmapRelease);
    glare = new MonitorOverlayClip();
    parent.addChild(glare);
    glare.visible = true;
    glare.scaleX = l.monitorScaleX;
    glare.scaleY = l.monitorScaleY;
    glare.mouseEnabled = false;

    var backgroundData = new flash.display.BitmapData(l.miniSize.x,
                                                      l.miniSize.y,
                                                      false,
                                                      Option.roadMiniColor);
    background = new flash.display.Bitmap(backgroundData);
    clip.addChild(background);
    background.visible = true;

    supply = new flash.display.Shape();
    clip.addChild(supply);
    supply.visible = true;

    window = new flash.display.Shape();
    clip.addChild(window);
    window.visible = true;

    var foregroundData = new flash.display.BitmapData(l.miniSize.x,
                                                      l.miniSize.y,
                                                      true, 0x00ffffff);
    foreground = new flash.display.Bitmap(foregroundData);
    clip.addChild(foreground);
    foreground.visible = true;

    monitor.addEventListener(flash.events.MouseEvent.ROLL_OVER, rollOver);

    resize(l);
  }

  public function cleanup() : Void
  {
    monitor.removeEventListener(flash.events.MouseEvent.ROLL_OVER, rollOver);

    foreground.parent.removeChild(foreground);
    foreground.bitmapData.dispose();
    foreground = null;

    window.parent.removeChild(window);
    window = null;

    supply.parent.removeChild(supply);
    supply = null;

    background.parent.removeChild(background);
    background.bitmapData.dispose();
    background = null;

    glare.parent.removeChild(glare);
    glare = null;

    clip.removeEventListener(flash.events.MouseEvent.MOUSE_DOWN, bitmapPress);
    clip.removeEventListener(flash.events.MouseEvent.MOUSE_UP, bitmapRelease);
    clip.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE,
                             bitmapMouseMove);
    clip.parent.removeChild(clip);
    clip = null;
    monitor.parent.removeChild(monitor);
    monitor = null;
  }

  public function resize(l : LayoutGame) : Void
  {
    clip.x = l.miniOffset.x;
    clip.y = l.miniOffset.y;
    monitor.x = l.monitorOffset.x;
    monitor.y = l.monitorOffset.y;
    glare.x = l.monitorOffset.x;
    glare.y = l.monitorOffset.y;
    drawWindow(l);
    // Currently assumes that miniCellSize doesn't change.
  }

  function rollOver(event : flash.events.MouseEvent) : Void
  {
    Game.view.toolTip.hide();
  }

  function drawWindow(l : LayoutGame) : Void
  {
    var windowSize = new Point(l.windowSize.x * l.miniCellSize,
                               l.windowSize.y * l.miniCellSize);
    window.graphics.clear();
    window.graphics.lineStyle(1, Color.miniCursor);
    window.graphics.moveTo(0, 0);
    window.graphics.lineTo(windowSize.x, 0);
    window.graphics.lineTo(windowSize.x, windowSize.y);
    window.graphics.lineTo(0, windowSize.y);
    window.graphics.lineTo(0, 0);
  }

  public function bitmapPress(event : flash.events.MouseEvent) : Void
  {
    clip.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, bitmapMouseMove);
    bitmapUpdate(Math.floor(event.localX), Math.floor(event.localY));
//    Game.view.mouseScroller.disable();
  }

  public function bitmapRelease(event : flash.events.MouseEvent) : Void
  {
    clip.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE,
                             bitmapMouseMove);
//    Game.view.mouseScroller.enable();
  }

  public function bitmapMouseMove(event : flash.events.MouseEvent) : Void
  {
    if (event.buttonDown)
    {
      bitmapUpdate(Math.floor(event.localX), Math.floor(event.localY));
    }
    else
    {
      bitmapRelease(event);
    }
  }

  function bitmapUpdate(mouseX : Int, mouseY : Int) : Void
  {
    var l = Game.view.layout;
    var factor = l.miniCellSize;
    var x = Math.floor(mouseX / factor) - l.windowCenter.x;
    var y = Math.floor(mouseY / factor) - l.windowCenter.y;
//    if (Game.view.tutorial.canMove())
    {
      Game.view.window.moveWindow(x, y);
    }
  }

  // x and y are in cells
  private function setCell(x : Int, y : Int, color : Int,
                           bitmap : flash.display.BitmapData)
  {
    var factor = Game.view.layout.miniCellSize;
    var rect = new flash.geom.Rectangle(x*factor, y*factor, factor, factor);
    bitmap.fillRect(rect, color);
    if (bitmap == background.bitmapData)
    {
      foreground.bitmapData.fillRect(rect, 0x00ffffff);
    }
  }

  public function updateCell(x : Int, y : Int)
  {
    var cell : MapCell = Game.map.getCell(x, y);
    var color = Option.roadMiniColor;
    var bitmap = background.bitmapData;
    if (cell.hasZombies())
    {
      color = Option.zombieMiniColor;
      bitmap = foreground.bitmapData;
    }
    else if (Point.isEqual(new Point(x, y), Game.select.getSelected()))
    {
      color = Option.selectedMiniColor;
      bitmap = foreground.bitmapData;
    }
    else if (cell.hasTower())
    {
/*
      var type = cell.getTower().getType();
      if (type == Tower.DEPOT)
      {
        color = Option.depotMiniColor;
      }
      else if (type == Tower.SNIPER)
      {
        color = Option.towerMiniColor;
      }
      else if (type == Tower.BARRICADE)
      {
        color = Option.barricadeMiniColor;
      }
      else //if (type == Tower.WORKSHOP)
      {
        color = Option.workshopMiniColor;
      }
*/
      color = Option.towerMiniColor;
      bitmap = foreground.bitmapData;
    }
    else if (cell.hasTrucks())
    {
      color = Option.truckMiniColor;
      bitmap = foreground.bitmapData;
    }
    else if (cell.buildingHasZombies())
    {
      var zombieCount = cell.getBuilding().getZombieCount();
      color = Lib.zombieColor(zombieCount);
    }
    else
    {
      switch (cell.getBackground())
      {
      case BUILDING:
        color = Option.emptyBuildingMiniColor;
      case ENTRANCE:
        color = Option.emptyBuildingMiniColor;
      case PARK:
        color = Option.roadMiniColor;
      case STREET:
        color = Option.roadMiniColor;
      case ALLEY:
        color = Option.roadMiniColor;
      case BRIDGE:
        color = Option.roadMiniColor;
      case WATER:
        color = Option.waterColor;
      case EDGE:
        color = Option.waterColor;
      }
    }
    setCell(x, y, color, bitmap);
  }

  public function update() : Void
  {
    for (y in 0...Game.map.sizeY())
    {
      for (x in 0...Game.map.sizeX())
      {
        updateCell(x, y);
      }
    }
  }

  // x and y are in cells
  public function moveWindow(x : Int, y : Int) : Void
  {
    var l = Game.view.layout;
    window.x = x * l.miniCellSize;
    window.y = y * l.miniCellSize;
  }

  public function updateSupply()
  {
    var dest = Game.select.getSelected();
    if (dest == null || Game.map.getCell(dest.x, dest.y).getTower() == null)
    {
      clearSupply();
    }
    else
    {
      showSupply(dest.x, dest.y);
    }
  }

  function showSupply(x : Int, y : Int) : Void
  {
    var l = Game.view.layout;
    var delta = l.miniCellSize / 2;
    supply.graphics.clear();
    supply.graphics.lineStyle(Option.miniSupplyThickness,
                              Option.miniSupplyColor);
    var tower = Game.map.getCell(x, y).getTower();
    for (customer in tower.getTradeLinks())
    {
      supply.graphics.moveTo(x * l.miniCellSize + delta,
                             y * l.miniCellSize + delta);
      supply.graphics.lineTo(customer.dest.x * l.miniCellSize + delta,
                             customer.dest.y * l.miniCellSize + delta);
    }
  }

  function clearSupply() : Void
  {
    supply.graphics.clear();
  }

  var monitor : MonitorClip;
  var clip : flash.display.DisplayObjectContainer;
  var glare : flash.display.MovieClip;
  var background : flash.display.Bitmap;
  var supply : flash.display.Shape;
  var foreground : flash.display.Bitmap;
  var window : flash.display.Shape;
}
