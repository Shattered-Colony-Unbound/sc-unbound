package ui;

class CustomCellRenderer extends fl.controls.listClasses.CellRenderer
{
  public function new() : Void
  {
    super();
    var format = new flash.text.TextFormat();
    format.size = FontSize.comboList;
    setStyle("textFormat", format);
  }
}
