package ui;

class TotalResource
{
  public function new(parent : flash.display.DisplayObjectContainer,
                      layout : LayoutGame) : Void
  {
    clip = new TotalResourceClip();
    parent.addChild(clip);
    resize(layout);
    if (Game.settings.isEditor())
    {
      clip.visible = false;
    }
  }

  public function cleanup() : Void
  {
    clip.parent.removeChild(clip);
  }

  public function resize(layout : LayoutGame) : Void
  {
    clip.x = layout.totalResourceOffset.x;
    clip.y = layout.totalResourceOffset.y;
  }

  public function update(values : Array<Int>) : Void
  {
    updateText(Resource.AMMO, clip.ammoStock, values);
    updateText(Resource.BOARDS, clip.boardsStock, values);
    updateText(Resource.SURVIVORS, clip.survivorsStock, values);
  }

  function updateText(payload : Resource, text : flash.text.TextField,
                      values : Array<Int>) : Void
  {
    var index = Lib.resourceToIndex(payload);
    text.text = Std.string(values[index]);
  }

  var clip : TotalResourceClip;
}
