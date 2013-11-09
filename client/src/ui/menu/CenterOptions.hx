package ui.menu;

class CenterOptions extends MenuRoot
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      screenSize : Point, newIsCenter : Bool) : Void
  {
    super();
    isCenter = newIsCenter;
    clip = new OptionsMenuClip();
    parent.addChild(clip);
    clip.visible = false;
    clip.mouseEnabled = false;
    buttons = new ui.ButtonList(click, null, [clip.soundUp, clip.soundDown,
                                              clip.musicUp, clip.musicDown,
                                              clip.scrollUp, clip.scrollDown,
                                              clip.back]);
    clip.music.barText.text = ui.Text.musicBarLabel;
    clip.sound.barText.text = ui.Text.soundBarLabel;
    clip.scroll.barText.text = ui.Text.scrollBarLabel;

    if (isCenter)
    {
      clip.background.visible = false;
    }

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
    ui.Util.scaleToFit(clip.background, size);
  }

  override public function hotkey(ch : String, code : Int) : Bool
  {
    var used = true;
    if (code == Keyboard.escapeCode)
    {
      click(6);
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
    showSound();
    showMusic();
    showScroll();
  }

  function showBar(option : Int, bar : StatusClip,
                   up : flash.display.MovieClip,
                   down : flash.display.MovieClip) : Void
  {
    var proportion = Main.config.getProportion(option);
    bar.bar.width = proportion * Option.statusBarSize;
    if (Main.config.canIncrease(option))
    {
      buttons.setNormal(up);
    }
    else
    {
      buttons.setGhosted(up);
    }
    if (Main.config.canDecrease(option))
    {
      buttons.setNormal(down);
    }
    else
    {
      buttons.setGhosted(down);
    }
  }

  function showSound() : Void
  {
    showBar(Config.SOUND, clip.sound, clip.soundUp, clip.soundDown);
    Main.sound.setVolume(Main.config.getProportion(Config.SOUND));
  }

  function showMusic() : Void
  {
    showBar(Config.MUSIC, clip.music, clip.musicUp, clip.musicDown);
    Main.music.setVolume(Main.config.getProportion(Config.MUSIC));
  }

  function showScroll() : Void
  {
    showBar(Config.SCROLL, clip.scroll, clip.scrollUp, clip.scrollDown);
  }

  override public function hide() : Void
  {
    clip.visible = false;
  }

  function click(choice : Int) : Void
  {
    if (choice == 0 && Main.config.canIncrease(Config.SOUND))
    {
      Main.config.increase(Config.SOUND);
      showSound();
      ui.Util.success();
    }
    else if (choice == 1 && Main.config.canDecrease(Config.SOUND))
    {
      Main.config.decrease(Config.SOUND);
      showSound();
      ui.Util.success();
    }
    else if (choice == 2 && Main.config.canIncrease(Config.MUSIC))
    {
      Main.config.increase(Config.MUSIC);
      showMusic();
      ui.Util.success();
    }
    else if (choice == 3 && Main.config.canDecrease(Config.MUSIC))
    {
      Main.config.decrease(Config.MUSIC);
      showMusic();
      ui.Util.success();
    }
    else if (choice == 4 && Main.config.canIncrease(Config.SCROLL))
    {
      Main.config.increase(Config.SCROLL);
      showScroll();
      ui.Util.success();
    }
    else if (choice == 5 && Main.config.canDecrease(Config.SCROLL))
    {
      Main.config.decrease(Config.SCROLL);
      showScroll();
      ui.Util.success();
    }
    else if (choice == 6)
    {
      ui.Util.success();
      if (isCenter)
      {
        Game.view.centerMenu.changeState(CenterMenu.SYSTEM);
      }
      else
      {
        Main.menu.changeState(MainMenu.START);
      }
    }
    else
    {
      ui.Util.failure();
    }
  }

  var clip : OptionsMenuClip;
  var buttons : ui.ButtonList;
  var isCenter : Bool;
}
