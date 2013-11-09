package flash {
        import flash.text.TextFormat;
        import flash.display.MovieClip;
        import flash.Lib;
        import flash.display.Stage;
        import flash.text.TextField;
        import flash.text.TextFieldAutoSize;
        import flash.utils.getQualifiedClassName;
        public dynamic class Boot extends flash.display.MovieClip {
                public function Boot(mc : flash.display.MovieClip = null) : void { if( !flash.Boot.skip_constructor ) {
                        super();
                        {
                                var aproto : * = Array.prototype;
                                aproto.copy = function() : * {
                                        return this.slice();
                                }
                                aproto.insert = function(i : *,x : *) : void {
                                        this.splice(i,0,x);
                                }
                                aproto.remove = function(obj : *) : Boolean {
                                        var idx : int = this.indexOf(obj);
                                        if(idx == -1) return false;
                                        this.splice(idx,1);
                                        return true;
                                }
                                aproto.iterator = function() : * {
                                        var cur : int = 0;
                                        var arr : Array = this;
                                        return { hasNext : function() : Boolean {
                                                return cur < arr.length;
                                        }, next : function() : * {
                                                return arr[cur++];
                                        }}
                                }
                                aproto.setPropertyIsEnumerable("copy",false);
                                aproto.setPropertyIsEnumerable("insert",false);
                                aproto.setPropertyIsEnumerable("remove",false);
                                aproto.setPropertyIsEnumerable("iterator",false);
                                var cca : * = String.prototype.charCodeAt;
                                String.prototype.charCodeAt = function(i : *) : * {
                                        var x : * = cca.call(this,i);
                                        if(isNaN(x)) return null;
                                        return x;
                                }
                        }
                        flash.Boot.lines = new Array();
                        var c : flash.display.MovieClip = (mc == null?this:mc);
                        flash.Lib.current = c;
                        try {
                                if(c.stage != null && c.stage.align == "") c.stage.align = "TOP_LEFT";
                                else null;
                        }
                        catch( e : * ){
                                null;
                        }
                        if(flash.Boot.init != null) init();
                }}

                private static function init() : void {{
                        Math["NaN"] = Number.NaN;
                        Math["NEGATIVE_INFINITY"] = Number.NEGATIVE_INFINITY;
                        Math["POSITIVE_INFINITY"] = Number.POSITIVE_INFINITY;
                        Math["isFinite"] = function(i : Number) : Boolean {
                                return isFinite(i);
                        }
                        Math["isNaN"] = function(i : Number) : Boolean {
                                return isNaN(i);
                        }
                }{
                        Date["now"] = function() : Date {
                                return new Date();
                        }
                        Date["fromTime"] = function(t : Number) : Date {
                                var d : Date = new Date();
                                d.setTime(t);
                                return d;
                        }
                        Date["fromString"] = function(s : String) : Date {
                                switch(s.length) {
                                case 8:{
                                        var k : Array = s.split(":");
                                        var d : Date = new Date();
                                        d.setTime(0);
                                        d.setUTCHours(k[0]);
                                        d.setUTCMinutes(k[1]);
                                        d.setUTCSeconds(k[2]);
                                        return d;
                                }break;
                                case 10:{
                                        var k2 : Array = s.split("-");
                                        return new Date(k2[0],k2[1] - 1,k2[2],0,0,0);
                                }break;
                                case 19:{
                                        var k3 : Array = s.split(" ");
                                        var y : Array = k3[0].split("-");
                                        var t : Array = k3[1].split(":");
                                        return new Date(y[0],y[1] - 1,y[2],t[0],t[1],t[2]);
                                }break;
                                default:{
                                        throw "Invalid date format : " + s;
                                }break;
                                }
                        }
                        Date.prototype["toString"] = function() : String {
                                var date : Date = this;
                                var m : int = date.getMonth() + 1;
                                var d : int = date.getDate();
                                var h : int = date.getHours();
                                var mi : int = date.getMinutes();
                                var s : int = date.getSeconds();
                                return date.getFullYear() + "-" + ((m < 10?"0" + m:"" + m)) + "-" + ((d < 10?"0" + d:"" + d)) + " " + ((h < 10?"0" + h:"" + h)) + ":" + ((mi < 10?"0" + mi:"" + mi)) + ":" + ((s < 10?"0" + s:"" + s));
                        }
                }}
                static protected var tf : flash.text.TextField;
                static protected var lines : Array;
                static protected var lastError : Error;
                static public var skip_constructor : Boolean = false;
                static public function enum_to_string(e : *) : String {
                        if(e.params == null) return e.tag;
                        return e.tag + "(" + e.params.join(",") + ")";
                }

                static public function __instanceof(v : *,t : *) : Boolean {
                        try {
                                if(t == Object) return true;
                                return v is t;
                        }
                        catch( e : * ){
                                null;
                        }
                        return false;
                }

                static public function __clear_trace() : void {
                        if(flash.Boot.tf == null) return;
                        flash.Lib.current.removeChild(tf);
                        flash.Boot.tf = null;
                        flash.Boot.lines = new Array();
                }

                static public function __set_trace_color(rgb : uint) : void {
                        getTrace().textColor = rgb;
                }

                static public function getTrace() : flash.text.TextField {
                        var mc : flash.display.MovieClip = flash.Lib.current;
                        if(flash.Boot.tf == null) {
                                flash.Boot.tf = new flash.text.TextField();
                                var format : flash.text.TextFormat = tf.getTextFormat();
                                format.font = "_sans";
                                tf.defaultTextFormat = format;
                                tf.selectable = false;
                                tf.width = (mc.stage == null?800:mc.stage.stageWidth);
                                tf.autoSize = flash.text.TextFieldAutoSize.LEFT;
                                tf.mouseEnabled = false;
                        }
                        mc.addChild(tf);
                        return tf;
                }

                static public function __trace(v : *,pos : *) : void {
                        var tf : flash.text.TextField = getTrace();
                        var pstr : String = (pos == null?"(null)":pos.fileName + ":" + pos.lineNumber);
                        flash.Boot.lines = lines.concat((pstr + ": " + __string_rec(v,"")).split("\n"));
                        tf.text = lines.join("\n");
                        var stage : flash.display.Stage = flash.Lib.current.stage;
                        if(stage == null) return;
                        while(lines.length > 1 && tf.height > stage.stageHeight) {
                                lines.shift();
                                tf.text = lines.join("\n");
                        }
                }

                static public function __string_rec(v : *,str : String) : String {
                        var cname : String = flash.utils.getQualifiedClassName(v);
                        switch(cname) {
                        case "Object":{
                                var k : Array = function() : Array {
                                        var $r : Array;
                                        $r = new Array();
                                        for(var $k : String in v) $r.push($k);
                                        return $r;
                                }();
                                var s : String = "{";
                                var first : Boolean = true;
                                {
                                        var _g1 : int = 0, _g : int = k.length;
                                        while(_g1 < _g) {
                                                var i : int = _g1++;
                                                var key : String = k[i];
                                                if(first) first = false;
                                                else s += ",";
                                                s += " " + key + " : " + __string_rec(v[key],str);
                                        }
                                }
                                if(!first) s += " ";
                                s += "}";
                                return s;
                        }break;
                        case "Array":{
                                var s2 : String = "[";
                                var i2 : *;
                                var first2 : Boolean = true;
                                var a : Array = v;
                                {
                                        var _g12 : int = 0, _g2 : int = a.length;
                                        while(_g12 < _g2) {
                                                var i1 : int = _g12++;
                                                if(first2) first2 = false;
                                                else s2 += ",";
                                                s2 += __string_rec(a[i1],str);
                                        }
                                }
                                return s2 + "]";
                        }break;
                        default:{
                                switch(typeof v) {
                                case "function":{
                                        return "<function>";
                                }break;
                                }
                        }break;
                        }
                        return new String(v);
                }

                static protected function __unprotect__(s : String) : String {
                        return s;
                }

        }
}
