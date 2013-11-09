package native
{
  import flash.net.navigateToURL;
  import flash.net.URLRequest;

  public class NativeBase
  {
    public static function nativeTrace(arg : *) : void
    {
      trace(arg);
    }

    public static function removeWhitespace(str : String) : String
    {
      var r = new RegExp("\\s", "g");
      return str.replace(r, "");
    }

    public static function navigateToURL(request : URLRequest) : void
    {
      flash.net.navigateToURL(request);
    }
  }
}
