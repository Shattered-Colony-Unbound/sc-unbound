class Config
{
  public static var SOUND = 0;
  public static var MUSIC = 1;
  public static var SCROLL = 2;

  static var maxValues = [6, 6, 6];
  static var startValues = [3, 3, 3];

  public function new() : Void
  {
    options = startValues.slice(0);
    load();
  }

  public function cleanup() : Void
  {
  }

  function load() : Void
  {
    try
    {
      var input = Main.configDisk;
      if (input.data.options != null)
      {
        for (i in 0...(input.data.options.length))
        {
          if (i < options.length)
          {
            options[i] = input.data.options[i];
          }
        }
      }
    }
    catch (e : flash.errors.Error)
    {
    }
    catch (e : Dynamic)
    {
    }
  }

  public function save() : Void
  {
    try
    {
      var out = Main.configDisk;
      out.data.options = options.copy();
      out.flush(100);
    }
    catch (e : flash.errors.Error)
    {
    }
    catch (e : Dynamic)
    {
    }
  }

  public function canIncrease(choice : Int) : Bool
  {
    return options[choice] < maxValues[choice];
  }

  public function increase(choice : Int) : Void
  {
    if (canIncrease(choice))
    {
      options[choice]++;
      save();
    }
  }

  public function canDecrease(choice : Int) : Bool
  {
    return options[choice] > 0;
  }

  public function decrease(choice : Int) : Void
  {
    if (canDecrease(choice))
    {
      options[choice]--;
      save();
    }
  }

  public function getProportion(choice : Int) : Float
  {
    return options[choice] / maxValues[choice];
  }

  public function setProportion(choice : Int, proportion : Float) : Void
  {
    setValue(choice, Math.round(proportion * maxValues[choice]));
  }

  public function getValue(choice : Int) : Int
  {
    return options[choice];
  }

  public function setValue(choice : Int, newValue : Int) : Void
  {
    var value = newValue;
    if (value < 0)
    {
      value = 0;
    }
    if (value > maxValues[choice])
    {
      value = maxValues[choice];
    }
    options[choice] = value;
    save();
  }

  var options : Array<Int>;
}
