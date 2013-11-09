class Keyboard
{
  public function new(newStage : flash.display.Stage) : Void
  {
    stage = newStage;
    repeat = Option.repeatWait;
    shiftPressed = false;
    hotkeyHandlers = new List<String -> Int -> Bool>();
    stage.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, onKeyDown);
    stage.addEventListener(flash.events.KeyboardEvent.KEY_UP, onKeyUp);
    stage.addEventListener(flash.events.Event.ENTER_FRAME, step);
  }

  public function cleanup() : Void
  {
    stage.removeEventListener(flash.events.KeyboardEvent.KEY_DOWN, onKeyDown);
    stage.removeEventListener(flash.events.KeyboardEvent.KEY_UP, onKeyUp);
    stage.removeEventListener(flash.events.Event.ENTER_FRAME, step);
  }

  function onKeyDown(event : flash.events.KeyboardEvent) : Void
  {
    if (repeat == Option.repeatWait)
    {
      repeat = 0;
      var ch = String.fromCharCode(event.charCode);
      var code = event.keyCode;

      if (code == ui.Workaround.SHIFT)
      {
        shiftPressed = true;
      }

      for (handler in hotkeyHandlers)
      {
        if (handler(ch, code))
        {
          break;
        }
      }
    }
  }

  function onKeyUp(event : flash.events.KeyboardEvent) : Void
  {
    repeat = Option.repeatWait;
    if (event.keyCode == ui.Workaround.SHIFT)
    {
      shiftPressed = false;
    }
  }

  function step(event : flash.events.Event) : Void
  {
    if (repeat < Option.repeatWait)
    {
      ++repeat;
    }
  }

  public function addHandler(newHandler : String -> Int -> Bool) : Void
  {
    hotkeyHandlers.add(newHandler);
  }

  public function clearHandlers() : Void
  {
    hotkeyHandlers = new List<String -> Int -> Bool>();
  }

  public function shift() : Bool
  {
    return shiftPressed;
  }

  var stage : flash.display.Stage;
  var repeat : Int;
  var shiftPressed : Bool;
  var hotkeyHandlers : List<String -> Int -> Bool>;

  public static var escapeCode = flash.ui.Keyboard.ESCAPE;
  public static var deleteCode = flash.ui.Keyboard.DELETE;
  public static var backSpaceCode = flash.ui.Keyboard.BACKSPACE;
  public static var enterCode = flash.ui.Keyboard.ENTER;
}
