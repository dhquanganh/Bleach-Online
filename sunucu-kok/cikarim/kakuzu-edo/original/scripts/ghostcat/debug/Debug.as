package ghostcat.debug
{
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.net.sendToURL;
   import flash.system.Security;
   import flash.text.TextField;
   import flash.utils.getQualifiedClassName;
   import ghostcat.util.Util;
   
   public final class Debug
   {
      
      public static var channels:Array;
      
      public static var debugTextField:TextField;
      
      public static var logUrl:String;
      
      public static var DEBUG:Boolean = false;
      
      public static var LOCAL:Boolean = false;
      
      public static var log:String = "";
      
      public static var enabledLog:Boolean = false;
      
      public static var enabledBrowserConsole:Boolean = false;
      
      public static var showTime:Boolean = false;
      
      public static var errorHandler:Function = defaultErrorHandler;
      
      public function Debug()
      {
         super();
      }
      
      public static function trace(param1:*, ... rest) : void
      {
         var _loc3_:String = getHeader(param1) + (rest as Array).join(",");
         if(enabledLog)
         {
            log += _loc3_ + "\n";
         }
         if(debugTextField)
         {
            debugTextField.appendText(_loc3_ + "\n");
         }
         if(enabledBrowserConsole && ExternalInterface.available)
         {
            ExternalInterface.call("console.log",_loc3_);
         }
         if(DEBUG && (channels == null || param1 == null || channels.indexOf(param1) != -1))
         {
            traceExt(_loc3_);
         }
      }
      
      public static function traceAll(... rest) : void
      {
         trace(null,rest);
      }
      
      public static function traceObject(param1:*, param2:Object, ... rest) : void
      {
         trace(param1,"[" + getObjectValues.apply(null,[param2].concat(rest)) + "]");
      }
      
      public static function getObjectValues(param1:Object, ... rest) : String
      {
         var _loc4_:* = undefined;
         var _loc3_:String = getQualifiedClassName(param1);
         if(Boolean(rest) && rest.length > 0)
         {
            for each(_loc4_ in rest)
            {
               _loc3_ += " " + _loc4_ + "=" + param1[_loc4_];
            }
         }
         else
         {
            for(_loc4_ in param1)
            {
               _loc3_ += " " + _loc4_ + "=" + param1[_loc4_];
            }
         }
         return _loc3_;
      }
      
      private static function getHeader(param1:*) : String
      {
         var _loc3_:Date = null;
         var _loc2_:String = "";
         if(showTime)
         {
            _loc3_ = new Date();
            _loc2_ = "[" + _loc3_.hours + ":" + _loc3_.minutes + ":" + _loc3_.seconds + ":" + _loc3_.milliseconds + "]";
         }
         if(param1)
         {
            _loc2_ += "[" + param1 + "]";
         }
         return _loc2_;
      }
      
      public static function error(param1:String = null) : void
      {
         var _loc2_:URLVariables = null;
         var _loc3_:URLRequest = null;
         if(DEBUG && enabledBrowserConsole && ExternalInterface.available)
         {
            ExternalInterface.call("console.error",param1);
         }
         errorHandler(param1);
         if(logUrl)
         {
            _loc2_ = new URLVariables();
            _loc2_.log = log;
            _loc3_ = new URLRequest(logUrl);
            _loc3_.data = _loc2_;
            sendToURL(_loc3_);
            log = "";
         }
      }
      
      private static function defaultErrorHandler(param1:String) : void
      {
         if(param1)
         {
            throw new Error(param1);
         }
      }
      
      public static function restriction(param1:*, param2:Array) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         if(param1 == null)
         {
            return;
         }
         if(!Util.isIn(param1,param2))
         {
            _loc3_ = [];
            _loc4_ = 0;
            while(_loc4_ < param2.length)
            {
               _loc3_.push(getQualifiedClassName(param2[_loc4_]));
               _loc4_++;
            }
            error("类型必须限定为[" + _loc3_.join(",") + "]中的一个");
         }
      }
      
      public static function get isNetWork() : Boolean
      {
         return Security.sandboxType == Security.REMOTE;
      }
      
      public static function get isBrower() : Boolean
      {
         return ExternalInterface.available;
      }
   }
}

function traceExt(... rest):void
{
   trace(rest);
}
