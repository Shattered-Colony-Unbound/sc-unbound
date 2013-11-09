package ui.menu;

class CenterSystem extends MenuRoot
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      screenSize : Point) : Void
  {
    super();
    clip = new SystemMenuClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;
    for (text in [clip.saveMapLabel, clip.uploadMapLabel, clip.testMapLabel,
                  clip.editMapLabel, clip.briefingLabel])
    {
      text.mouseEnabled = false;
    }
    if (Game.settings.isEditor())
    {
      for (spr in [clip.pedia, clip.options, clip.saveGame, clip.loadGame,
                   clip.retryGame, clip.editMapLabel, clip.editMap,
                   clip.briefing, clip.briefingLabel])
      {
        spr.visible = false;
      }
    }
    else if (Game.settings.isTesting())
    {
      for (spr in [clip.saveMap, clip.saveMapLabel, clip.uploadMap,
                   clip.uploadMapLabel, clip.testMap, clip.testMapLabel,
                   clip.loadGame, clip.mainMenu])
      {
        spr.visible = false;
      }
    }
    else
    {
      for (spr in [clip.saveMap, clip.saveMapLabel, clip.uploadMap,
                   clip.uploadMapLabel, clip.testMap, clip.testMapLabel,
                   clip.editMap, clip.editMapLabel])
      {
        spr.visible = false;
      }
    }

    buttons = new ui.ButtonList(click, null, [clip.resume, clip.pedia,
                                              clip.options, clip.saveGame,
                                              clip.loadGame, clip.retryGame,
                                              clip.mainMenu, clip.saveMap,
                                              clip.uploadMap, clip.testMap,
                                              clip.editMap, clip.briefing]);
    resize(screenSize);
  }

  override public function cleanup() : Void
  {
    buttons.cleanup();
    clip.parent.removeChild(clip);
    clip = null;
  }

  override public function resize(size : Point) : Void
  {
    ui.Util.alignRight(clip.city, size);
    ui.Util.alignRight(clip.difficulty, size);
    ui.Util.alignRight(clip.zombies, size);
    ui.Util.alignRight(clip.bridges, size);
  }

  override public function hotkey(ch : String, code : Int) : Bool
  {
    var used = true;
    if (code == Keyboard.escapeCode)
    {
      click(0);
    }
    else
    {
      used = false;
    }
    return used;
  }

  override public function show() : Void
  {
    clip.visible = true;
    clip.city.text = Game.settings.getCityName();
    clip.difficulty.text = Game.settings.getDifficultyName();
    var zombieCount = Std.string(Game.progress.getZombieCount());
    clip.zombies.text = ui.Text.zombiesLeft(zombieCount);
    var bridgeCount = Std.string(Game.progress.getBridgeCount());
    clip.bridges.text = ui.Text.bridgesLeft(bridgeCount);
    if (Main.canLoad())
    {
      buttons.setNormal(clip.loadGame);
    }
    else
    {
      buttons.setGhosted(clip.loadGame);
    }
    buttons.setNormal(clip.saveGame);
  }

  override public function hide() : Void
  {
    clip.visible = false;
  }

  override public function showTutorial() : Void
  {
    show();
  }

  function click(choice : Int) : Void
  {
    if (choice == 0)
    {
      ui.Util.success();
      Game.view.centerMenu.changeState(CenterMenu.NONE);
    }
    else if (choice == 1)
    {
      ui.Util.success();
      Game.view.centerMenu.changeState(CenterMenu.PEDIA);
    }
    else if (choice == 2)
    {
      ui.Util.success();
      Game.view.centerMenu.changeState(CenterMenu.OPTIONS);
    }
    else if (choice == 3)
    {
      ui.Util.success();
      hide();
      Game.attemptSave();
    }
    else if (choice == 4)
    {
      if (Main.canLoad())
      {
        ui.Util.success();
        Game.endGame(GameOver.RESTART_LOAD);
      }
      else
      {
        ui.Util.failure();
      }
    }
    else if (choice == 5)
    {
      ui.Util.success();
      Game.endGame(GameOver.RESTART);
    }
    else if (choice == 6)
    {
      ui.Util.success();
      Game.endGame(GameOver.END);
    }
    else if (choice == 7 && Game.settings.isEditor())
    {
      ui.Util.success();
      Game.settings.setMap(Game.editor.saveMap());
      Game.settings.setStart(Game.view.window.getCenter());
      Game.view.centerMenu.changeState(CenterMenu.SAVE_MAP);
    }
    else if (choice == 8 && Game.settings.isEditor())
    {
      ui.Util.success();
      Game.settings.setMap(Game.editor.saveMap());
      Game.settings.setStart(Game.view.window.getCenter());
      Game.view.centerMenu.changeState(CenterMenu.UPLOAD_MAP_WAIT);
    }
    else if (choice == 9 && Game.settings.isEditor())
    {
      ui.Util.success();
      Game.settings.setMap(Game.editor.saveMap());
      Game.settings.setStart(Game.view.window.getCenter());
      Game.loadMap = Game.settings.saveMap();
      Game.endGame(GameOver.TRY_MAP);
    }
    else if (choice == 10 && Game.settings.isTesting())
    {
      ui.Util.success();
      Game.endGame(GameOver.EDIT_MAP);
    }
    else if (choice == 11)
    {
      ui.Util.success();
      Game.view.centerMenu.changeState(CenterMenu.BRIEFING);
    }
    else
    {
      ui.Util.failure();
    }
  }

  var clip : SystemMenuClip;
  var buttons : ui.ButtonList;
}
