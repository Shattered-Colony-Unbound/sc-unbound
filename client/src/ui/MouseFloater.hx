package ui;

class MouseFloater
{
  public function new(newParent : flash.display.DisplayObjectContainer) : Void
  {
    parent = newParent;
    range = new Range(parent, Option.newRangeColor, Option.newRangeOpacity);
    supplies = new flash.display.Shape();
    parent.addChild(supplies);
    supplies.visible = false;
    shadow = new CenteredImage(parent, ui.Label.floater);
    shadow.setCenter(new Point(0, 0));
    shadow.hide();
    isActive = false;
    oldPos = null;
    buildType = 0;
  }

  public function cleanup() : Void
  {
    parent.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, mouseMove);
    parent = null;
    shadow.cleanup();
    shadow = null;
    supplies.parent.removeChild(supplies);
    supplies = null;
    range.cleanup();
    range = null;
    isActive = false;
  }

  public function resize(l : ui.LayoutGame) : Void
  {
    range.resize(l);
    if (oldPos != null)
    {
      var newPos = oldPos;
      oldPos = null;
      update(newPos.x, newPos.y, false);
    }
  }

  public function mouseMove(event : flash.events.MouseEvent) : Void
  {
    update(event.stageX, event.stageY, false);
  }

  public function update(x : Float, y : Float, forceUpdate : Bool) : Void
  {
    var l = Game.view.layout;
    var mouse : Point = new Point(Math.floor(x), Math.floor(y));
    if (mouse.x >= l.mapOffset.x
        && mouse.x < l.mapSize.x + l.mapOffset.x
        && mouse.y >= l.mapOffset.y
        && mouse.y < l.mapSize.y + l.mapOffset.y
        && isActive)
    {
      shadow.show();
      var cellPos =
        Game.view.window.toAbsolute(Lib.pixelToCell(mouse.x - l.mapOffset.x),
                                    Lib.pixelToCell(mouse.y - l.mapOffset.y));
      if (oldPos == null || ! Point.isEqual(cellPos, oldPos) || forceUpdate)
      {
        oldPos = cellPos;
        updateShadow(cellPos);
        updateOverlay(cellPos);
        updateRange(cellPos);
      }
    }
    else
    {
      shadow.hide();
      range.clear();
      supplies.visible = false;
      oldPos = null;
    }
  }

  private function updateShadow(cellPos : Point) : Void
  {
    var relative = Game.view.window.toRelative(cellPos.x, cellPos.y);
    shadow.goto(Lib.cellToPixel(relative.x),
                Lib.cellToPixel(relative.y));
  }

  private function updateOverlay(cellPos : Point) : Void
  {
    if (isValid(cellPos))
    {
      shadow.setTransform(Color.allowTransform);
      updateSupplies(cellPos);
    }
    else
    {
      shadow.setTransform(Color.denyTransform);
      supplies.visible = false;
    }
  }

  private function updateSupplies(cellPos : Point) : Void
  {
    var relative = Game.view.window.toRelative(cellPos.x, cellPos.y);
    supplies.x = Lib.cellToPixel(relative.x) + Option.halfCell;
    supplies.y = Lib.cellToPixel(relative.y) + Option.halfCell;
    supplies.graphics.clear();
    var posList = Game.map.findTowers(cellPos.x, cellPos.y,
                                      Option.supplyRange);
    for (pos in posList)
    {
      var tower = Game.map.getCell(pos.x, pos.y).getTower();
      if (buildType == Tower.DEPOT || tower.getType() == Tower.DEPOT)
      {
        var color = Color.supplyOtherLine;
        if (buildType == Tower.DEPOT && tower.getType() == Tower.DEPOT)
        {
          color = Color.supplyDepotLine;
        }
        supplies.graphics.lineStyle(Color.supplyLineThickness, color,
                                    Color.supplyLineAlpha, true,
                                    flash.display.LineScaleMode.NORMAL,
                                    flash.display.CapsStyle.ROUND);
        var x = Lib.cellToPixel(pos.x - cellPos.x);
        var y = Lib.cellToPixel(pos.y - cellPos.y);
        supplies.graphics.moveTo(0, 0);
        supplies.graphics.lineTo(x, y);
      }
    }
    supplies.visible = true;
  }

  function isValid(cellPos : Point) : Bool
  {
    var result = true;
    if (buildType == ADD_SUPPLY)
    {
      result = (Check.checkAddSupply(cellPos) == Check.ADD_OK);
    }
    else if (buildType == REMOVE_SUPPLY)
    {
      result = (Check.checkRemoveSupply(cellPos) == Check.REMOVE_OK);
    }
    else
    {
      result = Tower.canPlace(buildType, cellPos.x, cellPos.y);
    }
    return result;
  }

  private function updateRange(cellPos : Point) : Void
  {
    range.clear();
    if (buildType == Tower.SNIPER
        && Tower.canPlace(buildType, cellPos.x, cellPos.y))
    {
      var towerRange = Option.sniperRange[0];
      PermissiveFov.permissiveFov(cellPos.x, cellPos.y, towerRange,
                                  Sniper.isBlocked, addNewSquare);
      range.draw();
    }
  }

  private function addNewSquare(xPos : Int, yPos : Int) : Void
  {
    if (! Sniper.isBlocked(xPos, yPos))
    {
      range.set(xPos, yPos);
    }
  }

  public function start(newType : Int) : Void
  {
    if (! isActive || newType != buildType)
    {
      buildType = newType;
      shadow.gotoFrame(buildType + 2);
      shadow.show();
      parent.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, mouseMove);
      isActive = true;
      oldPos = null;
      update(Main.getRoot().mouseX, Main.getRoot().mouseY, false);
    }
  }

  public function stop() : Void
  {
    if (isActive)
    {
      parent.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, mouseMove);
      shadow.hide();
      isActive = false;
      range.clear();
      supplies.visible = false;
    }
  }

  public function updatePublic() : Void
  {
    update(Main.getRoot().mouseX, Main.getRoot().mouseY, true);
  }

  var parent : flash.display.DisplayObjectContainer;
  var shadow : CenteredImage;
  var range : Range;
  var supplies : flash.display.Shape;
  var isActive : Bool;
  var oldPos : Point;
  var buildType : Int;

  public static var ADD_SUPPLY = 4;
  public static var REMOVE_SUPPLY = 5;
}
