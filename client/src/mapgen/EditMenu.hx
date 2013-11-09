package mapgen;

class EditMenu
{
  public function new(parent : flash.display.DisplayObjectContainer) : Void
  {
    selected = null;
    selectedSquare = null;
    posClip = new EditPosClip();
    parent.addChild(posClip);
    clip = new EditMenuClip();
    parent.addChild(clip);
    clip.visible = false;
    for (text in [clip.zombies, clip.ammo, clip.boards, clip.survivors,
                  clip.setEntranceLabel, clip.deleteBoxLabel,
                  clip.addRubbleLabel, clip.addObstacleLabel,
                  clip.rotateLabel, clip.reflectLabel, clip.brokenLabel,
                  clip.changeTypeLabel])
    {
      text.mouseEnabled = false;
    }
    clip.type.focusEnabled = false;
    clip.type.addEventListener(flash.events.Event.CHANGE, changeType);
    var format = new flash.text.TextFormat();
//    format.font = new BitstreamVeraSans().fontName;
    format.size = ui.FontSize.comboListTitle;
//    clip.type.textField.setStyle("embedFonts", true);
    clip.type.textField.setStyle("textFormat", format);
    clip.type.dropdown.setStyle("cellRenderer", ui.CustomCellRenderer);
//    clip.type.textField.y = 0;
    initSprites();
    buttons = new ui.ButtonList(click, null,
                                [clip.zombiesDown, clip.zombiesUp,
                                 clip.ammoDown, clip.ammoUp,
                                 clip.boardsDown, clip.boardsUp,
                                 clip.survivorsDown, clip.survivorsUp,
                                 clip.setEntrance, clip.deleteBox,
                                 clip.addRubble, clip.addObstacle,
                                 clip.rotate, clip.reflect,
                                 clip.levelsDown, clip.levelsUp,
                                 clip.broken, clip.changeType]);
  }

  public function cleanup() : Void
  {
    buttons.cleanup();
    clip.type.removeEventListener(flash.events.Event.CHANGE, changeType);
    clip.parent.removeChild(clip);
    posClip.parent.removeChild(posClip);
  }

  public function hover(pos : Point) : Void
  {
    posClip.pos.text = pos.toString();
  }

  function click(choice : Int) : Void
  {
    if (selected == null)
    {
      return;
    }
    if (choice == 0)
    {
      addZombies(-1);
    }
    else if (choice == 1)
    {
      addZombies(1);
    }
    else if (choice == 2)
    {
      removeResources(Resource.AMMO);
    }
    else if (choice == 3)
    {
      addResources(Resource.AMMO);
    }
    else if (choice == 4)
    {
      removeResources(Resource.BOARDS);
    }
    else if (choice == 5)
    {
      addResources(Resource.BOARDS);
    }
    else if (choice == 6)
    {
      removeResources(Resource.SURVIVORS);
    }
    else if (choice == 7)
    {
      addResources(Resource.SURVIVORS);
    }
    else if (choice == 8)
    {
      selected.setEntrance(selectedSquare);
    }
    else if (choice == 9)
    {
      removeSelected();
    }
    else if (choice == 10)
    {
      if (selectedSquare != null)
      {
        EditChange.createRubble(selectedSquare);
      }
    }
    else if (choice == 11)
    {
      if (selectedSquare != null)
      {
        EditChange.addObstacle(selectedSquare);
        selected.show();
      }
    }
    else if (choice == 12)
    {
      rotate();
    }
    else if (choice == 13)
    {
      reflect();
    }
    else if (choice == 14)
    {
      if (selectedSquare != null)
      {
        EditChange.removeLevel(selectedSquare);
      }
    }
    else if (choice == 15)
    {
      if (selectedSquare != null)
      {
        EditChange.addLevel(selectedSquare);
      }
    }
    else if (choice == 16)
    {
      selected.toggleBroken();
    }
    else if (choice == 17)
    {
      if (selectedSquare != null)
      {
        EditChange.changeObstacle(selectedSquare);
        selected.show();
      }
    }
    Game.view.mini.update();
    Game.view.window.refresh();
    Game.editor.updateSelect();
  }

  function addZombies(count : Int) : Void
  {
    if (selectedSquare == null)
    {
      selected.addZombies(count);
    }
    else
    {
      EditChange.addZombie(selectedSquare, count);
    }
  }

  function addResources(payload : Resource) : Void
  {
    if (selectedSquare == null)
    {
      selected.addResources(payload, 1);
    }
    else
    {
      EditChange.addResource(selectedSquare, payload, 1);
    }
  }

  function removeResources(payload : Resource) : Void
  {
    if (selectedSquare == null)
    {
      selected.removeResources(payload, 1);
    }
    else
    {
      EditChange.addResource(selectedSquare, payload, -1);
    }
  }

  function removeSelected() : Void
  {
    if (selectedSquare == null)
    {
      selected.remove();
    }
    else
    {
      EditChange.remove(selectedSquare);
      selected.show();
    }
  }

  function rotate() : Void
  {
    if (selected != null)
    {
      selected.rotate();
    }
  }

  function reflect() : Void
  {
    if (selected != null)
    {
      selected.reflect();
    }
  }

  public function update(newSelected : EditBox,
                         newSelectedSquare : Point) : Void
  {
    selected = newSelected;
    selectedSquare = newSelectedSquare;
    if (selected == null)
    {
      clip.visible = false;
    }
    else
    {
      clip.visible = true;
      for (spr in sprites)
      {
        spr.visible = false;
      }
      updateType();
      updateBuilding();
      updateDirections();
      if (selectedSquare == null)
      {
        clip.deleteBox.visible = true;
        clip.deleteBoxLabel.visible = true;
        if (selected.getType() == EditBox.BRIDGE)
        {
          clip.broken.visible = true;
          clip.brokenLabel.visible = true;
        }
      }
      updateSquare();
    }
    Game.settings.setMap(Game.editor.saveMap());
    Main.setEditSave(Game.settings.saveMap());
  }

  function updateType() : Void
  {
    var size = Math.floor(Math.min(selected.getLimit().x-selected.getOffset().x,
                                selected.getLimit().y-selected.getOffset().y));
    clip.type.removeAll();
    var index = 0;
    for (type in EditBox.typeList)
    {
      if (size >= type.minSize)
      {
        clip.type.addItem(type.item);
        if (type == selected.getType())
        {
          clip.type.selectedIndex = index;
        }
        ++index;
      }
    }
  }

  function updateBuilding() : Void
  {
    if (EditBox.isBuilding(selected.getType()))
    {
      if (selectedSquare == null)
      {
        for (spr in [clip.zombiesDown, clip.zombiesUp, clip.zombies,
                     clip.ammoDown, clip.ammoUp, clip.ammo,
                     clip.boardsDown, clip.boardsUp, clip.boards,
                     clip.survivorsDown, clip.survivorsUp, clip.survivors])
        {
          spr.visible = true;
        }
        var zombies = selected.getZombies();
        var ammo = selected.getResources(Resource.AMMO);
        var boards = selected.getResources(Resource.BOARDS);
        var survivors = selected.getResources(Resource.SURVIVORS);
        clip.zombies.text = ui.Text.zombiesEdit(Std.string(zombies));
        clip.ammo.text = ui.Text.ammoEdit(Std.string(ammo));
        clip.boards.text = ui.Text.boardsEdit(Std.string(boards));
        clip.survivors.text = ui.Text.survivorsEdit(Std.string(survivors));
      }
      else if (selected.canSetEntrance())
      {
        for (spr in [clip.setEntrance, clip.setEntranceLabel])
        {
          spr.visible = true;
        }
      }
    }
  }

  function updateSquare() : Void
  {
    if (selectedSquare != null)
    {
      var x = selectedSquare.x;
      var y = selectedSquare.y;
      var cell = Game.map.getCell(x, y);
      if (EditChange.canAddZombie(selectedSquare))
      {
        clip.zombiesUp.visible = true;
        clip.zombiesDown.visible = true;
        clip.zombies.visible = true;
        var zombies = cell.zombieCount();
        clip.zombies.text = ui.Text.zombiesEdit(Std.string(zombies));
      }
      if (EditChange.canAddResource(selectedSquare))
      {
        for (spr in [clip.ammoUp, clip.ammoDown, clip.ammo,
                     clip.boardsUp, clip.boardsDown, clip.boards,
                     clip.survivorsUp, clip.survivorsDown, clip.survivors])
        {
          spr.visible = true;
        }
        var ammo = cell.getRubbleCount(Resource.AMMO);
        var boards = cell.getRubbleCount(Resource.BOARDS);
        var survivors = cell.getRubbleCount(Resource.SURVIVORS);
        if (cell.hasTower())
        {
          ammo = cell.getTower().countResource(Resource.AMMO);
          boards = cell.getTower().countResource(Resource.BOARDS);
          survivors = cell.getTower().countResource(Resource.SURVIVORS);
        }
        clip.ammo.text = ui.Text.ammoEdit(Std.string(ammo));
        clip.boards.text = ui.Text.boardsEdit(Std.string(boards));
        clip.survivors.text = ui.Text.survivorsEdit(Std.string(survivors));
      }
      if (EditChange.canAddLevel(selectedSquare)
          || EditChange.canRemoveLevel(selectedSquare))
      {
        clip.levels.visible = true;
        var levels = cell.getTower().getLevel();
        clip.levels.text = ui.Text.levelsEdit(Std.string(levels));
      }
      if (EditChange.canRemoveLevel(selectedSquare))
      {
        clip.levelsDown.visible = true;
      }
      if (EditChange.canAddLevel(selectedSquare))
      {
        clip.levelsUp.visible = true;
      }
      if (EditChange.canCreateRubble(selectedSquare))
      {
        clip.addRubble.visible = true;
        clip.addRubbleLabel.visible = true;
      }
      if (EditChange.canAddObstacle(selectedSquare))
      {
        clip.addObstacle.visible = true;
        clip.addObstacleLabel.visible = true;
      }
      if (EditChange.canChangeObstacle(selectedSquare))
      {
        clip.changeType.visible = true;
        clip.changeTypeLabel.visible = true;
      }
      if (EditChange.canRemove(selectedSquare))
      {
        clip.deleteBox.visible = true;
        clip.deleteBoxLabel.visible = true;
      }
    }
  }

  function updateDirections() : Void
  {
    if (selected != null && selectedSquare == null)
    {
      if (EditBox.hasDirection(selected.getType()))
      {
        for (current in [clip.rotate, clip.rotateLabel,
                         clip.reflect, clip.reflectLabel])
        {
          current.visible = true;
        }
      }
    }
  }

  function changeType(event : flash.events.Event) : Void
  {
    Game.editor.changeType(clip.type.selectedItem.data);
    Game.view.window.refresh();
    Game.view.mini.update();
  }

  var clip : EditMenuClip;
  var posClip : EditPosClip;
  var buttons : ui.ButtonList;

  var selected : EditBox;
  var selectedSquare : Point;

  var sprites : Array<flash.display.DisplayObject>;

  function initSprites() : Void
  {
    sprites = [cast(clip.zombiesDown, flash.display.DisplayObject),
               clip.zombiesUp, clip.zombies, clip.ammoDown, clip.ammoUp,
               clip.ammo, clip.boardsDown, clip.boardsUp, clip.boards,
               clip.survivorsDown, clip.survivorsUp, clip.survivors,
               clip.setEntrance, clip.setEntranceLabel, clip.deleteBox,
               clip.deleteBoxLabel, clip.addRubble, clip.addRubbleLabel,
               clip.addObstacle, clip.addObstacleLabel,
               clip.rotate, clip.rotateLabel,
               clip.reflect, clip.reflectLabel, clip.levelsDown, clip.levelsUp,
               clip.levels, clip.broken, clip.brokenLabel, clip.changeType,
               clip.changeTypeLabel];
  }
}
