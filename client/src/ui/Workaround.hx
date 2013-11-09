package ui;

class Workaround
{
  public static function attach(name : String) : flash.display.MovieClip
  {
    return flash.Lib.attach(name);
  }

  public static function copyPixels(tiles : flash.display.Bitmap,
                                    source : flash.display.BitmapData,
                                    sourceRect : flash.geom.Rectangle,
                                    x : Int, y : Int) : Void
  {
    tiles.bitmapData.copyPixels(source, sourceRect,
                                new flash.geom.Point(x, y));
  }

  public static function drawOverPixels(tiles : flash.display.Bitmap,
                                        source : flash.display.DisplayObject,
                                        x : Int, y : Int,
                                        color : Array<Int>)
  {
    var matrix = new flash.geom.Matrix();
    matrix.translate(x*2, y*2);
    matrix.scale(0.5, 0.5);
    var colorTransform = null;
    if (color != null)
    {
      colorTransform =
        new flash.geom.ColorTransform(0, 0, 0, 1,
                                      color[0], color[1], color[2], 0);
    }
    tiles.bitmapData.draw(source, matrix, colorTransform);
  }

  public static function copyOverPixels(tiles : flash.display.Bitmap,
                                        source : flash.display.BitmapData,
                                        sourceRect : flash.geom.Rectangle,
                                        x : Int, y : Int) : Void
  {
    tiles.bitmapData.copyPixels(source, sourceRect,
                                new flash.geom.Point(x, y), null, null, true);
  }

  public static function fillRect(dest : flash.display.Bitmap,
                                  offsetX : Int, offsetY : Int,
                                  limitX : Int, limitY : Int,
                                  color : Int) : Void
  {
    var rect = new flash.geom.Rectangle(offsetX, offsetY,
                                        limitX - offsetX, limitY - offsetY);
    dest.bitmapData.fillRect(rect, color);
  }

  public static var SHIFT = flash.ui.Keyboard.SHIFT;
}
