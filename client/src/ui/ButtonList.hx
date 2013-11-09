package ui;

class ButtonList
{
  public static var NORMAL = 1;
  public static var OVER = 2;
  public static var GHOSTED = 3;
  public static var IN_PROGRESS = 4;
  public static var GREEN = 5;
  public static var GREEN_OVER = 6;

  public function new(newClickAction : Int -> Void,
                      newHoverAction : Int -> String,
                      newButtonList : Array<flash.display.MovieClip>)
  {
    clickAction = newClickAction;
    hoverAction = newHoverAction;
    buttonList = newButtonList;
    for (button in buttonList)
    {
      button.mouseChildren = false;
//      button.addEventListener(flash.events.MouseEvent.CLICK, buttonClick);
      button.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, buttonDown);
      button.addEventListener(flash.events.MouseEvent.MOUSE_UP, buttonUp);
      button.addEventListener(flash.events.MouseEvent.MOUSE_OVER, buttonOver);
      button.addEventListener(flash.events.MouseEvent.MOUSE_OUT, buttonOut);
      button.gotoAndStop(NORMAL);
    }
    lastHovered = null;
    lastClicked = null;
    frame = mouseWait;
  }

  public function cleanup() : Void
  {
    for (button in buttonList)
    {
//      button.removeEventListener(flash.events.MouseEvent.CLICK, buttonClick);
      button.removeEventListener(flash.events.MouseEvent.MOUSE_DOWN,
                                 buttonDown);
      button.removeEventListener(flash.events.MouseEvent.MOUSE_UP,
                                 buttonUp);
      button.removeEventListener(flash.events.MouseEvent.MOUSE_OVER,
                                 buttonOver);
      button.removeEventListener(flash.events.MouseEvent.MOUSE_OUT, buttonOut);
    }
    Main.getRoot().removeEventListener(flash.events.Event.ENTER_FRAME,
                                       enterFrame);
  }

  public function get(index : Int) : flash.display.MovieClip
  {
    return buttonList[index];
  }

  public function setNormal(clip : flash.display.MovieClip) : Void
  {
    var index = getButtonIndex(clip);
    if (lastHovered != null && index == lastHovered)
    {
      changeState(clip, OVER);
    }
    else
    {
      changeState(clip, NORMAL);
    }
  }

  public function setGhosted(clip : flash.display.MovieClip) : Void
  {
    changeState(clip, GHOSTED);
  }

  public function setProgress(clip : flash.display.MovieClip) : Void
  {
    changeState(clip, IN_PROGRESS);
  }

  public function setGreen(clip : flash.display.MovieClip) : Void
  {
    var index = getButtonIndex(clip);
    if (lastHovered != null && index == lastHovered)
    {
      changeState(clip, GREEN_OVER);
    }
    else
    {
      changeState(clip, GREEN);
    }
  }

  function changeState(clip : flash.display.MovieClip, state : Int) : Void
  {
    clip.gotoAndStop(state);
  }

  function buttonClick(/*event : flash.events.MouseEvent*/) : Void
  {
    var index = getButtonIndex(/*event.target*/lastClicked);
    var text = null;
    if (index != null)
    {
      clickAction(index);
    }
  }

  function buttonDown(event : flash.events.MouseEvent) : Void
  {
    lastClicked = cast(event.target, flash.display.DisplayObject);
    Main.getRoot().addEventListener(flash.events.Event.ENTER_FRAME,
                                    enterFrame);
    frame = mouseWait;
    buttonClick();
  }

  function buttonUp(event : flash.events.MouseEvent) : Void
  {
    Main.getRoot().removeEventListener(flash.events.Event.ENTER_FRAME,
                                       enterFrame);
  }

  function buttonOver(event : flash.events.MouseEvent) : Void
  {
    var index = getButtonIndex(event.target);
    if (hoverAction != null)
    {
      var text = null;
      if (index != null)
      {
        text = hoverAction(index);
      }
      if (text == null)
      {
        Game.view.toolTip.hide();
      }
      else
      {
        Game.view.toolTip.show(text);
      }
    }
    if (index != null)
    {
      if (buttonList[index].currentFrame == NORMAL)
      {
        buttonList[index].gotoAndStop(OVER);
      }
      else if (buttonList[index].currentFrame == GREEN)
      {
        buttonList[index].gotoAndStop(GREEN_OVER);
      }
    }
    lastHovered = index;
  }

  function buttonOut(event : flash.events.MouseEvent) : Void
  {
    var index = getButtonIndex(event.target);
    if (index != null)
    {
      if (buttonList[index].currentFrame == OVER)
      {
        buttonList[index].gotoAndStop(NORMAL);
      }
      else if (buttonList[index].currentFrame == GREEN_OVER)
      {
        buttonList[index].gotoAndStop(GREEN);
      }
    }
    if (hoverAction != null)
    {
      Game.view.toolTip.hide();
    }
    lastHovered = null;
    Main.getRoot().removeEventListener(flash.events.Event.ENTER_FRAME,
                                       enterFrame);
  }

  function enterFrame(event : flash.events.Event) : Void
  {
    --frame;
    if (frame <= 0 && lastClicked.visible && lastClicked.parent.visible &&
        lastClicked.parent.parent.visible)
    {
      buttonClick();
      frame = mouseWait;
    }
  }

  function getButtonIndex(target : Dynamic) : Null<Int>
  {
    var index : Null<Int> = null;
    for (i in 0...buttonList.length)
    {
      if (buttonList[i] == target)
      {
        index = i;
        break;
      }
    }
    return index;
  }

  var clickAction : Int -> Void;
  var hoverAction : Int -> String;
  var buttonList : Array<flash.display.MovieClip>;
  var lastHovered : Null<Int>;
  var lastClicked : flash.display.DisplayObject;
  var frame : Int;

  static var mouseWait = 6;
}
