package logic;

class ScriptAction implements action.Interface
{
  public static var WIN = 0;
  public static var LOSE = 1;
  public static var COUNTDOWN = 2;
  public static var HORDE = 3;
  public static var MOVE_MAP = 4;
  public static var ADD_STATE = 5;

  public function new(newAction : Int, newArg : String) : Void
  {
    action = newAction;
    arg = newArg;
  }

  public function run() : Void
  {
    if (action == WIN)
    {
      var text = arg;
      if (text == null)
      {
        text = ui.Text.mainWinText;
      }
      Game.settings.setWinText(text);
      Game.endGame(GameOver.WIN);
    }
    else if (action == LOSE)
    {
      var text = arg;
      if (text == null)
      {
        text = ui.Text.mainLoseText;
      }
      Game.settings.setLoseText(text);
      Game.endGame(GameOver.LOSE);
    }
    else if (action == COUNTDOWN)
    {
      var num = Std.parseInt(arg);
      Game.spawner.startCountDown(num);
    }
    else if (action == HORDE)
    {
      var count = null;
      var pos = null;
      if (arg != null)
      {
        var nums = arg.split(" ");
        if (nums.length >= 1)
        {
          count = Std.parseInt(nums[0]);
        }
        if (nums.length >= 3)
        {
          var x = Std.parseInt(nums[1]);
          var y = Std.parseInt(nums[2]);
          if (x != null && y != null)
          {
            pos = new Point(x, y);
          }
        }
      }
      Game.spawner.startHorde(count, pos);
    }
    else if (action == MOVE_MAP)
    {
      var nums = arg.split(" ");
      if (nums.length >= 2)
      {
        var x = Std.parseInt(nums[0]);
        var y = Std.parseInt(nums[1]);
        if (x != null && y != null)
        {
          Game.view.window.moveWindowCenter(x, y);
        }
      }
    }
    else if (action == ADD_STATE)
    {
      Game.script.addCurrentState(arg);
    }
  }

  var action : Int;
  var arg : String;
}
