// Central repository for all events which change the state of the
// viewer's screen.
class Update
{
  public function new() : Void
  {
    statusCount = 0;
    changeButtons = false;
    cellUpdates = new List<Point>();
    newTowerList = new List<Point>();
    destroyedTowerList = new List<Point>();
    resourceChangeList = new List<Point>();
    supplierList = new List<Point>();
    customerList = new List<Point>();
    selectIsChanging = false;
    newSelect = null;
    hasProgress = false;
    rangeList = new List<Point>();
  }

  public function clear() : Void
  {
    statusCount = 0;
    changeButtons = false;
    cellUpdates.clear();
    newTowerList.clear();
    destroyedTowerList.clear();
    resourceChangeList.clear();
    supplierList.clear();
    customerList.clear();
    selectIsChanging = false;
    newSelect = null;
    hasProgress = false;
    rangeList.clear();
  }

  public function commit() : Void
  {
    commitNewTowerList();
    commitDestroyedTowerList();
    commitRange();
    commitChangeSelect();
    commitCellUpdates();
    commitResourceChangeList();
    commitSupplierList();
    commitCustomerList();
    commitProgress();
    commitStatus();
    commitButtons();

    clear();
  }

  function commitNewTowerList() : Void
  {
    var selected = Game.select.getSelected();
    for (dest in newTowerList)
    {
      cellState(dest);
      if ((selectIsChanging && Point.isEqual(dest, newSelect))
          || (!selectIsChanging && Point.isEqual(dest, selected)))
      {
//        Game.menu.transitionToTower();
        changeSelect(dest);
      }
    }
    if (! newTowerList.isEmpty())
    {
      Game.view.window.updateRanges();
    }
  }

  function commitDestroyedTowerList() : Void
  {
    var selected = Game.select.getSelected();
    for (dest in destroyedTowerList)
    {
      cellState(dest);
      if ((selectIsChanging && Point.isEqual(dest, newSelect))
          || (!selectIsChanging && Point.isEqual(dest, selected)))
      {
//        Game.menu.transitionToStart();
        changeSelect(null);
      }
    }
    if (! destroyedTowerList.isEmpty())
    {
      Game.view.window.updateRanges();
    }
  }

  function commitChangeSelect() : Void
  {
    if (selectIsChanging)
    {
      var oldPos = Game.select.getSelected();

      changeStatus();
      buttons();

      Game.select.changeSelect(newSelect);
      Game.view.mini.updateSupply();
      if (oldPos != null)
      {
        cellState(oldPos);
        var oldTower = Game.map.getCell(oldPos.x, oldPos.y).getTower();
        if (oldTower != null)
        {
          oldTower.removeTradeTargets();
        }
      }
      if (newSelect != null)
      {
        cellState(newSelect);
        var newTower = Game.map.getCell(newSelect.x, newSelect.y).getTower();
        if (newTower != null)
        {
          newTower.addTradeTargets();
        }
//        Game.menu.transitionToSelect();
      }
      Game.view.sideMenu.changeSelect();
    }
  }

  function commitCellUpdates() : Void
  {
    for (dest in cellUpdates)
    {
      Game.view.mini.updateCell(dest.x, dest.y);
    }
  }

  function commitResourceChangeList() : Void
  {
    if (! resourceChangeList.isEmpty())
    {
      // Be more fine-grained later.
      changeStatus();
      buttons();
    }
  }

  function commitSupplierList() : Void
  {
    // Do nothing for now. Be more fine-grained later.
  }

  function commitCustomerList() : Void
  {
    clearTargets(supplierList);
    clearTargets(customerList);
    var select = Game.select.getSelected();
    if (select != null
        && (! supplierList.isEmpty() || ! customerList.isEmpty()))
    {
      var tower = Game.map.getCell(select.x, select.y).getTower();
      if (tower != null)
      {
        tower.removeTradeTargets();
        tower.addTradeTargets();
        Game.view.mini.updateSupply();
      }
    }
  }

  function clearTargets(targetList : List<Point>) : Void
  {
    for (target in targetList)
    {
      var tower = Game.map.getCell(target.x, target.y).getTower();
      if (tower != null)
      {
        tower.removeTarget();
      }
    }
  }

  function commitProgress() : Void
  {
    if (hasProgress)
    {
      // TODO: Be more fine-grained.
      changeStatus();
      Game.view.totals.update(Game.progress.getAllResourceCounts());
    }
  }

  function commitStatus() : Void
  {
    if (statusCount > 0)
    {
//      Game.menu.showStatus();
      Game.view.sideMenu.show();
    }
  }

  function commitButtons() : Void
  {
    if (changeButtons)
    {
//      Game.menu.show();
      Game.view.sideMenu.show();
    }
  }

  function commitRange() : Void
  {
    if (rangeList.length > 0 && ! selectIsChanging)
    {
      var found = false;
      for (pos in rangeList)
      {
        if (Point.isEqual(pos, Game.select.getSelected()))
        {
          found = true;
          break;
        }
      }
      if (found)
      {
        Game.select.update();
      }
    }
  }

  public function progress() : Void
  {
    hasProgress = true;
  }

  public function changeStatus() : Void
  {
    ++statusCount;
  }

  public function undoStatus() : Void
  {
    --statusCount;
  }

  public function buttons() : Void
  {
    changeButtons = true;
  }

  public function cellState(pos : Point) : Void
  {
    if (pos != null)
    {
      cellUpdates.add(pos);
    }
  }

  public function newTower(pos : Point) : Void
  {
    if (pos != null)
    {
      newTowerList.add(pos);
    }
  }

  public function destroyTower(pos : Point) : Void
  {
    if (pos != null)
    {
      destroyedTowerList.add(pos);
    }
  }

  public function resourceChange(pos : Point) : Void
  {
    if (pos != null)
    {
      resourceChangeList.add(pos);
    }
  }

  public function supplyLine(supplier : Point, customer : Point) : Void
  {
    if (supplier != null)
    {
      supplierList.add(supplier);
    }
    if (customer != null)
    {
      customerList.add(customer);
    }
  }
/*
  public function updateWindowPosition(pos : Point) : Void
  {
    // See Window.moveWindow for other places to update
//    Game.menu.getMiniMap().moveWindow(dest.x, dest.y);

  }
*/

  public function changeSelect(newPos : Point) : Void
  {
    selectIsChanging = true;
    newSelect = newPos;
  }

  public function changeRange(newPos : Point) : Void
  {
    rangeList.add(newPos);
  }

  // The number of status updates
  var statusCount : Int;
  var changeButtons : Bool;
  var cellUpdates : List<Point>;
  var newTowerList : List<Point>;
  var destroyedTowerList : List<Point>;
  var resourceChangeList : List<Point>;
  var supplierList : List<Point>;
  var customerList : List<Point>;
  var selectIsChanging : Bool;
  var newSelect : Point;
  var hasProgress : Bool;
  var rangeList : List<Point>;
}
