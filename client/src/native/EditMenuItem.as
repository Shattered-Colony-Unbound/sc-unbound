package native
{
  public class EditMenuItem
  {
    public function EditMenuItem(newLabel : String,
                                 newData : *) : void
    {
      label = newLabel;
      data = newData;
      icon = "";
    }

    public var label : String;
    public var data : *;
    public var icon : String;
  }
}
