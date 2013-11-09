package fl.controls;

extern class ComboBox extends UIComponent
{
  var selectedIndex : Int;
  var selectedItem : Dynamic;
  var focusEnabled : Bool;
  var textField : UIComponent;
  var dropdown : UIComponent;
  function addItem(item : Dynamic) : Void;
  function removeAll() : Void;
}
