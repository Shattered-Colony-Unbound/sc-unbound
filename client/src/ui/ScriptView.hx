package ui;

class ScriptView
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      l : LayoutGame) : Void
  {
    state = null;
    clickNext = null;
    clickSkip = null;

    clip = new TutorialClip();
    parent.addChild(clip);
    clip.mouseEnabled = false;
    clip.back.mouseEnabled = false;
    clip.back.mouseChildren = false;

    buttons = new ButtonList(click, null, [clip.next]);
    clip.next.mouseEnabled = true;
    clip.next.mouseChildren = false;

    clip.text.wordWrap = true;
    clip.text.autoSize = flash.text.TextFieldAutoSize.LEFT;
    clip.text.addEventListener(flash.events.TextEvent.LINK, link);

//    var sheet = new flash.text.StyleSheet();
//    sheet.parseCSS(Text.tutorialStyleSheet);
//    clip.text.styleSheet = sheet;

    clip.arrow.mouseEnabled = false;
    clip.arrow.mouseChildren = false;
    clip.arrow.visible = false;

    resize(l);
  }


  public function cleanup() : Void
  {
    buttons.cleanup();
    clip.text.removeEventListener(flash.events.TextEvent.LINK, link);
    clip.parent.removeChild(clip);
    clip = null;
  }

  public function resize(l : ui.LayoutGame) : Void
  {
    clip.back.x = l.tutorialBoxOffset.x;
    clip.back.y = l.tutorialBoxOffset.y;

    clip.text.x = l.tutorialTextOffset.x;
    clip.text.y = l.tutorialTextOffset.y;
    clip.text.width = l.tutorialSize.x;

    redraw();
  }

  public function setButtons(newNext : Void -> Void,
                             newSkip : Void -> Void) : Void
  {
    clickNext = newNext;
    clickSkip = newSkip;
  }

  function click(choice : Int) : Void
  {
    if (choice == 0)
    {
      clickNext();
    }
    else
    {
      clickSkip();
    }
  }

  function link(event : flash.events.TextEvent) : Void
  {
    ui.Util.success();
    Game.view.centerMenu.lookup(event.text);
  }

  public function update(newStateList : Array<logic.ScriptState>) : Void
  {
    var newState = null;
    for (current in newStateList)
    {
      if (current.shouldShowText() || current.shouldShowArrow())
      {
        newState = current;
        break;
      }
    }
    if (state != newState)
    {
      state = newState;
      redraw();
    }
  }

  public function redraw() : Void
  {
    if (state == null)
    {
      clip.visible = false;
      hideArrow();
    }
    else
    {
      clip.visible = true;
      if (state.shouldShowText())
      {
        setText();
      }
      else
      {
        hideText();
      }
      if (state.shouldShowArrow())
      {
        updateGuide(state.getPos(), state.isMapPos());
      }
      else
      {
        hideArrow();
      }
    }
  }

  function setText() : Void
  {
    clip.text.visible = true;
    clip.back.visible = true;
    clip.text.text = state.getText();
    var textWidth = Math.floor(clip.text.width);
    var textHeight = Math.floor(clip.text.height);
    if (state.shouldShowNext())
    {
      clip.next.visible = true;
      clip.next.x = clip.text.x + 15;
      clip.next.y = clip.text.y + textHeight + 10;
      textHeight += 5 + Math.floor(clip.next.height);
    }
    else
    {
      clip.next.visible = false;
    }
    var boxSize = new Point(textWidth + 10, textHeight + 15);
    clip.back.graphics.clear();
    clip.back.graphics.lineStyle(/*borderThickness, Color.tutorialBorder, 1.0,
                                   false, flash.display.LineScaleMode.NONE*/);
    clip.back.graphics.beginFill(Color.tutorialBackground,
                                 Color.tutorialAlpha);
    clip.back.graphics.drawRoundRect(0, 0,
                                     boxSize.x, boxSize.y,
                                     10, 10);
    clip.back.graphics.endFill();
  }

  function hideText() : Void
  {
    clip.text.visible = false;
    clip.next.visible = false;
    clip.back.visible = false;
  }

  function updateGuide(pos : Point, isMap : Bool) : Void
  {
    if (isMap)
    {
      var screenSize = Game.view.layout.screenSize;
      var middle = new Point(Math.floor(screenSize.x / 2),
                             Math.floor(screenSize.y / 2));
      var dirToPos = [new Point(middle.x, 0),
                      new Point(middle.x, screenSize.y),
                      new Point(screenSize.x, middle.y),
                      new Point(0, middle.y)];

      var winDir = Game.view.window.getDir(pos);
      if (winDir == null)
      {
        pos = Game.view.window.toRelative(pos.x, pos.y).toPixel();
        pos.x += Option.halfCell;
        pos.y += Option.halfCell;
      }
      else
      {
        var index = Lib.directionToIndex(winDir);
        pos = dirToPos[index];
      }
    }
    showArrow(pos);
  }

  function hideArrow() : Void
  {
    clip.arrow.visible = false;
  }

  function showArrow(pos : Point) : Void
  {
    clip.arrow.visible = true;
    clip.arrow.x = pos.x;
    clip.arrow.y = pos.y;
    var deltaX = pos.x - (clip.text.x + clip.text.width/2);
    var deltaY = pos.y - (clip.text.y + clip.text.height/2);
    var angle = Lib.slopeToAngle(deltaX, deltaY);
    clip.arrow.rotation = 180 + angle;
    clip.arrow.tail.width = Math.sqrt(deltaX*deltaX + deltaY*deltaY);
  }

  var state : logic.ScriptState;
  var clickNext : Void -> Void;
  var clickSkip : Void -> Void;

  var clip : TutorialClip;
  var buttons : ButtonList;

  static var borderThickness = 2;
}
