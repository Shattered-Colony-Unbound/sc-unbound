class Save
{
  static public function maybe<T>(variable : T,
                                  fun : T -> Dynamic) : Dynamic
  {
    var result : Dynamic = variable;
    if (variable != null)
    {
      result = fun(variable);
    }
    return result;
  }

  static public function saveList<T>(theList : List<T>,
                                     fun : T -> Dynamic) : Dynamic
  {
    var result = new Array<Dynamic>();
    for (item in theList)
    {
      var next = fun(item);
      if (next != null)
      {
        result.push(next);
      }
    }
    return result;
  }

  static public function saveArray<T>(theArray : Array<T>,
                                      fun : T -> Dynamic) : Dynamic
  {
    var result = [];
    for (item in theArray)
    {
      var next = fun(item);
      if (next != null)
      {
        result.push(next);
      }
    }
    return result;
  }

  static public function saveGridInt(grid : Grid<Int>) : Dynamic
  {
    return grid.save(saveInt);
  }

  static public function saveInt(current : Int) : Dynamic
  {
    return current;
  }
}
