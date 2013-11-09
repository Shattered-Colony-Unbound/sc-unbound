class Grid<T>
{
  public function new(sizeX : Int, sizeY : Int)
  {
    mBuffer = [];
    mSizeX = sizeX;
    mSizeY = sizeY;
    for (i in 0...sizeX)
    {
      for (j in 0...sizeY)
      {
        mBuffer.push(null);
      }
    }
  }

  public function get(x : Int, y : Int) : T
  {
    if (x < 0 || x >= mSizeX || y < 0 || y >= mSizeY)
    {
      throw new flash.errors.Error("Grid out of bounds: (" + Std.string(x)
                                   + ", " + Std.string(y) + ")");
    }
    return mBuffer[x + y*mSizeX];
  }

  public function set(x : Int, y : Int, val : T) : Void
  {
    if (x < 0 || x >= mSizeX || y < 0 || y >= mSizeY)
    {
      throw new flash.errors.Error("Grid out of bounds: (" + Std.string(x)
                                   + ", " + Std.string(y) + ")");
    }
    mBuffer[x + y*mSizeX] = val;
  }

  public function sizeX() : Int
  {
    return mSizeX;
  }

  public function sizeY() : Int
  {
    return mSizeY;
  }

  public function save(fun : T -> Dynamic) : Dynamic
  {
    return { mBuffer : saveBuffer(fun),
             mSizeX : mSizeX,
             mSizeY : mSizeY };
  }

  public function saveBuffer(fun : T -> Dynamic) : Array<Dynamic>
  {
    var result = new Array<Dynamic>();
    for (item in mBuffer)
    {
      result.push(fun(item));
    }
    return result;
  }

  public static function load<T>(input : Dynamic, fun : Dynamic -> T) : Grid<T>
  {
    var sizeX = input.mSizeX;
    var sizeY = input.mSizeY;
    var result = new Grid<T>(sizeX, sizeY);
    for (y in 0...sizeY)
    {
      for (x in 0...sizeX)
      {
        result.set(x, y, fun(input.mBuffer[x + y*sizeX]));
      }
    }
    return result;
  }

  var mBuffer : Array<T>;
  var mSizeX : Int;
  var mSizeY : Int;
}
