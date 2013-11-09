class Point
{
  public function new(newX : Int, newY : Int) : Void
  {
    x = newX;
    y = newY;
  }

  public function clone() : Point
  {
    return new Point(x, y);
  }

  public static function debug(pos : Point) : String
  {
    if (pos == null)
    {
      return "<NULL>";
    }
    else
    {
      return pos.toString();
    }
  }

  public function toString() : String
  {
    return "(" + Std.string(x) + ", " + Std.string(y) + ")";
  }

  public function toPixel() : Point
  {
    return new Point(Lib.cellToPixel(x), Lib.cellToPixel(y));
  }

  public function plusEquals(right : Point) : Void
  {
    x += right.x;
    y += right.y;
  }

  public function plus(right : Point) : Point
  {
    return new Point(x + right.x, y + right.y);
  }

  public function minus(right : Point) : Point
  {
    return new Point(x - right.x, y - right.y);
  }

  public static function isEqual(left : Point, right : Point) : Bool
  {
    return (left == null && right == null)
      || (left != null && right != null
          && left.x == right.x && left.y == right.y);
  }

  public static function isAdjacent(left : Point, right : Point) : Bool
  {
    var result = false;
    if (left == null && right == null)
    {
      result = true;
    }
    else if (left != null && right != null)
    {
      var x = Math.floor(Math.abs(left.x - right.x));
      var y = Math.floor(Math.abs(left.y - right.y));
      result = ((x <= 1 && y == 0) || (y <= 1 && x == 0));
    }
    return result;
  }

  public static function isHorizontallyAdjacent(left : Point,
                                                right : Point) : Bool
  {
    var result = false;
    if (left == null && right == null)
    {
      result = true;
    }
    else if (left != null && right != null)
    {
      var x = Math.floor(Math.abs(left.x - right.x));
      var y = Math.floor(Math.abs(left.y - right.y));
      result = (y == 0 && x <= 1);
    }
    return result;
  }

  public static function isVerticallyAdjacent(left : Point,
                                              right : Point) : Bool
  {
    var result = false;
    if (left == null && right == null)
    {
      result = true;
    }
    else if (left != null && right != null)
    {
      var x = Math.floor(Math.abs(left.x - right.x));
      var y = Math.floor(Math.abs(left.y - right.y));
      result = (x == 0 && y <= 1);
    }
    return result;
  }

  public static function saveS(pos : Point) : Dynamic
  {
    return pos.save();
  }

  public function save() : Dynamic
  {
    return { x : x,
             y : y };
  }

  public static function load(input : Dynamic) : Point
  {
    if (input != null)
    {
      return new Point(input.x, input.y);
    }
    else
    {
      return null;
    }
  }

  public var x : Int;
  public var y : Int;
}
