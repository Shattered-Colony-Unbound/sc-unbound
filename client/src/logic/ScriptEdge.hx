package logic;

class ScriptEdge
{
  public function new(newType : Int, newArea : mapgen.Section,
                      newNext : String) : Void
  {
    type = newType;
    area = newArea;
    next = newNext;
  }

  public function trigger(candidate : Int, pos : Point) : String
  {
    var result = null;
    if (candidate == type)
    {
      if (area == null
          || (area != null && pos != null && area.contains(pos)))
      {
        result = next;
      }
    }
    return result;
  }

  public function getNext() : String
  {
    return next;
  }

  var type : Int;
  var area : mapgen.Section;
  var next : String;
}
