package ui;

class HoverList
{
  public function new(newClipList : Array<flash.display.DisplayObject>,
                      newTextList : Array<String>) : Void
  {
    clipList = newClipList;
    textList = newTextList;
    for (clip in clipList)
    {
      clip.addEventListener(flash.events.MouseEvent.MOUSE_OVER, rollOver);
      clip.addEventListener(flash.events.MouseEvent.MOUSE_OUT, rollOut);
    }
  }

  public function cleanup() : Void
  {
    for (clip in clipList)
    {
      clip.removeEventListener(flash.events.MouseEvent.MOUSE_OVER, rollOver);
      clip.removeEventListener(flash.events.MouseEvent.MOUSE_OUT, rollOut);
    }
  }

  function rollOver(event : flash.events.MouseEvent) : Void
  {
    var index : Null<Int> = getIndex(event);
    if (index != null)
    {
      Game.view.toolTip.show(textList[index]);
    }
  }

  function rollOut(event : flash.events.MouseEvent) : Void
  {
    Game.view.toolTip.hide();
  }

  function getIndex(event : flash.events.MouseEvent) : Null<Int>
  {
    var index : Null<Int> = null;
    for (i in 0...clipList.length)
    {
      if (clipList[i] == event.target)
      {
        index = i;
        break;
      }
    }
    return index;
  }

  var clipList : Array<flash.display.DisplayObject>;
  var textList : Array<String>;
}
