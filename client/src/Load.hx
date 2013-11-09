class Load
{
  static public function maybe<T>(input : Dynamic, fun : Dynamic -> T) : T
  {
    var result : T = null;
    if (input != null)
    {
      result = fun(input);
    }
    return result;
  }

  static public function loadList<T>(input : Dynamic,
                                     fun : Dynamic -> T) : List<T>
  {
    var result = new List<T>();
    for (i in 0...(input.length))
    {
      result.add(fun(input[i]));
    }
    return result;
  }

  static public function loadGridInt(input : Dynamic) : Grid<Int>
  {
    return Grid.load(input, loadInt);
  }

  static public function loadInt(input : Dynamic) : Int
  {
    return input;
  }

  static public function loadOtherList<T, S>(input : Dynamic,
                                             fun : Dynamic -> S -> T,
                                             other : S) : List<T>
  {
    var result = new List<T>();
    var current : Array<Dynamic> = input.h;
    while (current != null)
    {
      result.add(fun(current[0], other));
      current = current[1];
    }
    return result;
  }

  static public function loadArray<T>(input : Dynamic,
                                      fun : Dynamic -> T) : Array<T>
  {
    var result = new Array<T>();
    for (i in 0...(input.length))
    {
      result.push(fun(input[i]));
    }
    return result;
  }

  static public function loadArrayInt(input : Dynamic) : Array<Int>
  {
    var result : Array<Int> = [];
    for (i in 0...(input.length))
    {
      result.push(input[i]);
    }
    return result;
  }
}
