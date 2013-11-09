package native;

extern class NativeBase
{
  public static function nativeTrace(arg : Dynamic) : Void;
  public static function removeWhitespace(str : String) : String;
  public static function navigateToURL(request : flash.net.URLRequest) : Void;
}
