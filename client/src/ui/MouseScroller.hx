package ui;

class MouseScroller
{
  public function new(newParent : flash.display.InteractiveObject) : Void
  {
    enabled = true;
    north = false;
    south = false;
    east = false;
    west = false;
    parent = newParent;
    counter = 0;
    parent.stage.addEventListener(flash.events.MouseEvent.MOUSE_MOVE,
                                  mouseMove);
    parent.stage.addEventListener(flash.events.MouseEvent.ROLL_OVER,
                                  mouseMove);
    parent.stage.addEventListener(flash.events.Event.MOUSE_LEAVE,
                                  mouseLeave);
  }

  public function cleanup() : Void
  {
    parent.stage.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE,
                                     mouseMove);
    parent.stage.removeEventListener(flash.events.MouseEvent.ROLL_OVER,
                                     mouseMove);
    parent.stage.removeEventListener(flash.events.Event.MOUSE_LEAVE,
                                     mouseLeave);
    parent.removeEventListener(flash.events.Event.ENTER_FRAME, enterFrame);
  }
/*
  public function rollOut(event : flash.events.MouseEvent) : Void
  {
    updateMouse(Math.floor(parent.mouseX), Math.floor(parent.mouseY),
                Game.view.layout.scrollOutMargin);
  }
*/
  public function mouseMove(event : flash.events.MouseEvent) : Void
  {
    mouseClear();
    updateMouse(Math.floor(event.stageX), Math.floor(event.stageY),
                Game.view.layout.scrollMargin);
  }

  public function mouseClear() : Void
  {
    north = false;
    south = false;
    east = false;
    west = false;
    parent.removeEventListener(flash.events.Event.ENTER_FRAME, enterFrame);
  }

  function mouseLeave(event : flash.events.Event) : Void
  {
    parent.addEventListener(flash.events.Event.ENTER_FRAME, enterFrame);
    Game.view.toolTip.hide();
    updateMouse(Math.floor(parent.stage.mouseX),
                Math.floor(parent.stage.mouseY),
                Game.view.layout.scrollOutMargin);
  }

  static var outMargin = 75;

  function updateMouse(x : Int, y : Int, margin : Int) : Void
  {
    var size = Game.view.layout.screenSize;
    north = (y <= margin && withinGutter(size, x, y));
    south = (y > size.y - margin && withinGutter(size, x, y));
    east = (x > size.x - margin && withinGutter(size, x, y));
    west = (x <= margin && withinGutter(size, x, y));
    if (north || south || east || west)
    {
      parent.addEventListener(flash.events.Event.ENTER_FRAME, enterFrame);
    }
    else
    {
      parent.removeEventListener(flash.events.Event.ENTER_FRAME, enterFrame);
    }
  }

  function withinGutter(size : Point, x : Int, y : Int) : Bool
  {
    return x >= -outMargin && y >= -outMargin
      && x <= size.x + outMargin && y <= size.y + outMargin;
  }

  public function enterFrame(event : flash.events.Event) : Void
  {
    if (enabled && ! Game.pause.isSystemPaused())
    {
      updateExternal();
      counter += Main.config.getValue(Config.SCROLL) + 1;
      if (counter >= maxScroll)
      {
        if (north)
        {
          Game.view.window.scrollWindow(Direction.NORTH, 1);
        }
        if (south)
        {
          Game.view.window.scrollWindow(Direction.SOUTH, 1);
        }
        if (east)
        {
          Game.view.window.scrollWindow(Direction.EAST, 1);
        }
        if (west)
        {
          Game.view.window.scrollWindow(Direction.WEST, 1);
        }
        counter -= maxScroll;
      }
    }
  }

  public function enable() : Void
  {
    enabled = true;
  }

  public function disable() : Void
  {
    enabled = false;
  }

  function updateExternal() : Void
  {
/*
    if (mouseOut)
    {
      north = false;
      south = false;
      east = false;
      west = false;
    }
    else if (mousePos != null
        && flash.external.ExternalInterface.available)
    {
      updateMouse(mousePos.x, mousePos.y, Game.view.layout.scrollOutMargin);
    }
*/
  }

  static function getBasePos(id : String) : Point
  {
    var result = null;
/*
    try
    {
      if (flash.external.ExternalInterface.available)
      {
        var htmlJs =
          "function getPos() { " +
          " var curleft = curtop = 0; var obj = document.getElementById('" + id + "'); " +
          " if (obj.offsetParent) { do { curleft += obj.offsetLeft; curtop += obj.offsetTop; } " +
          " while (obj = obj.offsetParent); } " +
          " return [curleft, curtop]; }";
        var pos : Dynamic = flash.external.ExternalInterface.call(htmlJs);
        if (pos != null)
        {
          Lib.trace(result);
          result = new Point(pos[0], pos[1]);
        }
        else
        {
          Lib.trace("Error in Cordinates:getElPos, Couldn't get the object's pos");
        }
      }
      else
      {
        Lib.trace("Error in Cordinates:getElPos, ExternalInterface isn't available");
      }
    }
    catch(ex : flash.Error)
    {
      trace('Error in Cordinates:getElPos, ' + ex);
    }
*/
    return result;
  }

  public static function trackMouse() : Void
  {
/*
    try
    {
      if (flash.external.ExternalInterface.available)
      {
        var id = flash.external.ExternalInterface.objectID;
        basePos = getBasePos(id);
        flash.external.ExternalInterface.addCallback("mouseMoveCallback",
                                                     setMousePosition);
        flash.external.ExternalInterface.addCallback("mouseOutCallback",
                                                     setMouseOut);
        flash.external.ExternalInterface.addCallback("mouseOverCallback",
                                                     clearMouseOut);
        var htmlJs =
          "function getPos() {    " +
          " document.onmousemove = function(e) {  " +
          " if (!e) {  " +
          "   if (window.event) {  " +
          "     e = window.event;  " +
          "   } else {  " +
          "     return;  " +
          "   }  " +
          " }  " +
          " if (typeof (e.pageX) == 'number') {  " +
          "   var xcoord = e.pageX;  " +
          "   var ycoord = e.pageY;  " +
          " } else if (typeof (e.clientX) == 'number') {  " +
          "   var xcoord = e.clientX;  " +
          "   var ycoord = e.clientY;  " +
          "   var badOldBrowser = (window.navigator.userAgent.indexOf('Opera') + 1) || (window.ScriptEngine && ScriptEngine().indexOf('InScript') + 1) || (navigator.vendor == 'KDE');  " +
          "   if (!badOldBrowser) {  " +
          "     if (document.body && (document.body.scrollLeft || document.body.scrollTop)) {  " +
          "       xcoord += document.body.scrollLeft;  " +
          "       ycoord += document.body.scrollTop;  " +
          "     } else if (document.documentElement && (document.documentElement.scrollLeft || document.documentElement.scrollTop)) {  " +
          "       xcoord += document.documentElement.scrollLeft;  " +
          "       ycoord += document.documentElement.scrollTop;  " +
          "     }  " +
          "   }  " +
          " }   " +
          "  var obj = document.getElementById('" + id + "').mouseMoveCallback(xcoord, ycoord);  " +
          " }; " +

          " window.onmouseout = function(e) { " +
          " if (!e) { e = window.event; } " +
          " var isAChildOf = function(_parent, _child) " +
          " { " +
          "   if (_parent === _child) { return false; } " +
          "   while (_child && _child !== _parent) " +
          "   { _child = _child.parentNode; } " +
          "   return _child === _parent; " +
          " }; " +
          " var relTarget = e.relatedTarget || e.toElement; " +
          "  if (window === relTarget || isAChildOf(window, relTarget)) " +
          "  { return; } " +
//          " alert('mouseout detected!'); " +
          "  var obj = document.getElementById('" + id + "').mouseOutCallback(); " +
          " }; " +

          " window.onmouseover = function(e) { " +
          " if (!e) { e = window.event; } " +
          " var isAChildOf = function(_parent, _child) " +
          " { " +
          "   if (_parent === _child) { return false; } " +
          "   while (_child && _child !== _parent) " +
          "   { _child = _child.parentNode; } " +
          "   return _child === _parent; " +
          " }; " +
          " var relTarget = e.relatedTarget || e.fromElement; " +
          "  if (window === relTarget || isAChildOf(window, relTarget)) " +
          "  { return; } " +
//          " alert('mouseover detected!'); " +
          "  var obj = document.getElementById('" + id + "').mouseOverCallback(); " +
          " }; " +
          " return true }";

        var result = flash.external.ExternalInterface.call(htmlJs);

        if (result != null)
        {
          trace(result);
//          return result;
        }
        else
        {
          Lib.trace("Error in Cordinates:trackMouse, Couldn't get the object's id");
        }
      }
      else
      {
        Lib.trace("Error in Cordinates:trackMouse, ExternalInterface isn't available");
      }
    }
    catch(ex : flash.Error)
    {
      Lib.trace("Error in Cordinates:trackMouse, " + ex);
    }
*/
  }

  static function setMousePosition(x : Int, y : Int)
  {
    if (basePos != null)
    {
      mousePos = new Point(x - basePos.x, y - basePos.y);
    }
    else
    {
      mousePos = new Point(x, y);
    }
//    Game.view.mouseScroller.updateExternal();
  }

  static function setMouseOut()
  {
    mouseOut = true;
//    Game.view.mouseScroller.updateExternal();
  }

  static function clearMouseOut()
  {
    mouseOut = false;
//    Game.view.mouseScroller.updateExternal();
  }

  var enabled : Bool;
  var north : Bool;
  var south : Bool;
  var east : Bool;
  var west : Bool;
  var parent : flash.display.InteractiveObject;
  var counter : Int;

  static var basePos : Point = null;
  static var mousePos : Point = null;
  static var mouseOut : Bool = false;

  static var maxScroll = 7;
}
