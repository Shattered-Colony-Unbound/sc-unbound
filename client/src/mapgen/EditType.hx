package mapgen;

class EditType
{
  public function new(newNumber : Int, newMinSize : Int,
                      newItemText : String) : Void
  {
    number = newNumber;
    minSize = newMinSize;
    item = new native.EditMenuItem(newItemText, this);
  }

  public var number : Int;
  public var minSize : Int;
  public var item : native.EditMenuItem;
}
