package ui.menu;

class PediaHash
{
  public function new() : Void
  {
    hash = new haxe.ds.StringMap<String>();
    var i = 0;
    while (i < ui.Text.pedia.length - 1)
    {
      var key = ui.Text.pedia[i];
      key = StringTools.trim(key);
      var value = ui.Text.pedia[i+1];
      hash.set(key, value);
      i += 2;
    }
  }

  public function lookup(key : String) : String
  {
    var result = "ERROR: " + key + " not found";
    if (hash.exists(key))
    {
      result = hash.get(key);
    }
    return result;
  }

  var hash : haxe.ds.StringMap<String>;
}
