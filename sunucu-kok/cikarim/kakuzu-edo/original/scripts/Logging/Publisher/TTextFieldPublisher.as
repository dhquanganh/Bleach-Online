package Logging.Publisher
{
   import Logging.TLogger;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class TTextFieldPublisher implements IPublisher
   {
      
      private static const STR_MAX_CHARS:uint = 5000000;
      
      private static const LINE_MIN_LEN:uint = 15;
      
      private static const LINE_MAX_LEN:uint = 50;
      
      protected var FField:TextField;
      
      protected var FFieldTest:TextField;
      
      protected var FTextFormat:TextFormat;
      
      protected var FLinelen:uint;
      
      protected var FContextCached:String;
      
      protected var FOutputType:uint;
      
      protected var FAutoScrollV:Boolean;
      
      public function TTextFieldPublisher(param1:TextField)
      {
         super();
         this.FField = param1;
         this.FFieldTest = GetLoggerField(param1.width,param1.height);
         this.FTextFormat = new TextFormat();
         this.FAutoScrollV = true;
         this.FContextCached = "";
         this.FLinelen = LINE_MIN_LEN;
      }
      
      public static function GetLoggerField(param1:int = 200, param2:int = 200) : TextField
      {
         var _loc3_:TextField = null;
         var _loc4_:TextFormat = null;
         _loc4_ = new TextFormat();
         _loc4_.font = "Arial";
         _loc4_.size = 12;
         _loc4_.color = 4291348680;
         _loc4_.leading = 0;
         _loc4_.letterSpacing = 0;
         _loc3_ = new TextField();
         _loc3_.defaultTextFormat = _loc4_;
         _loc3_.width = param1;
         _loc3_.height = param2;
         _loc3_.wordWrap = true;
         _loc3_.multiline = true;
         _loc3_.mouseEnabled = false;
         _loc3_.selectable = false;
         _loc3_.cacheAsBitmap = true;
         _loc3_.alpha = 0.6;
         return _loc3_;
      }
      
      protected function GetPrefix(param1:int) : String
      {
         switch(param1)
         {
            case TLogger.LEVEL_DEBUG:
               return "_";
            case TLogger.LEVEL_LoadStart:
               return "◇";
            case TLogger.LEVEL_LoadFailed:
               return "◎";
            case TLogger.LEVEL_LoadFailureRetry:
               return "※";
            case TLogger.LEVEL_LoadTimeOutRetry:
               return "※";
            case TLogger.LEVEL_LoadBlockRetry:
               return "※";
            case TLogger.LEVEL_LoadAbort:
               return "◎";
            case TLogger.LEVEL_LoadEnd:
               return "◆";
            case TLogger.LEVEL_UnLoad:
               return "●";
            case TLogger.LEVEL_Login:
               return "→";
            case TLogger.LEVEL_PacketTransmit:
               return "↑";
            case TLogger.LEVEL_PacketReceive:
               return "↓";
            case TLogger.LEVEL_INFORMATION:
               return "-";
            case TLogger.LEVEL_WARNING:
               return "!";
            case TLogger.LEVEL_ERROR:
               return "#";
            case TLogger.LEVEL_FATAL:
               return "µ";
            default:
               return "";
         }
      }
      
      protected function GetColorByLevel(param1:int) : int
      {
         switch(param1)
         {
            case TLogger.LEVEL_DEBUG:
               return 4282949887;
            case TLogger.LEVEL_LoadStart:
               return 4286643968;
            case TLogger.LEVEL_LoadFailed:
               return 4294901760;
            case TLogger.LEVEL_LoadFailureRetry:
               return 4292541539;
            case TLogger.LEVEL_LoadTimeOutRetry:
               return 4286644223;
            case TLogger.LEVEL_LoadBlockRetry:
               return 4289200128;
            case TLogger.LEVEL_LoadAbort:
               return 4292541539;
            case TLogger.LEVEL_LoadEnd:
               return 4294934528;
            case TLogger.LEVEL_UnLoad:
               return 4278223103;
            case TLogger.LEVEL_Login:
               return 4286643968;
            case TLogger.LEVEL_PacketTransmit:
               return 4294923263;
            case TLogger.LEVEL_PacketReceive:
               return 4278255615;
            case TLogger.LEVEL_INFORMATION:
               return 4291995974;
            case TLogger.LEVEL_WARNING:
               return 4294940980;
            case TLogger.LEVEL_ERROR:
               return 4294906643;
            case TLogger.LEVEL_FATAL:
               return 4292412163;
            default:
               return 4278190080;
         }
      }
      
      public function get ContextCached() : String
      {
         return this.FContextCached;
      }
      
      public function get OutputType() : uint
      {
         return this.FOutputType;
      }
      
      public function set OutputType(param1:uint) : void
      {
         this.FOutputType = param1;
      }
      
      public function get AutoScrollV() : Boolean
      {
         return this.FAutoScrollV;
      }
      
      public function set AutoScrollV(param1:Boolean) : void
      {
         this.FAutoScrollV = param1;
      }
      
      public function Publish(param1:uint, param2:int, param3:*, ... rest) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         this.FTextFormat.color = this.GetColorByLevel(param2);
         _loc5_ = this.GetPrefix(param2) + ": " + String(param3) + "\n";
         this.FContextCached += _loc5_;
         if(this.FContextCached.length > STR_MAX_CHARS)
         {
            this.FContextCached = "";
         }
         this.FField.appendText(_loc5_);
         this.FFieldTest.text = _loc5_;
         _loc7_ = this.FField.numLines - this.FFieldTest.numLines;
         _loc8_ = this.FField.getLineOffset(_loc7_);
         _loc9_ = _loc8_ + this.FField.getLineLength(_loc7_);
         this.FField.setTextFormat(this.FTextFormat,_loc8_,_loc9_);
         if(this.FField.numLines > this.FLinelen)
         {
            _loc9_ = this.FField.getLineOffset(1);
            this.FField.replaceText(0,_loc9_,"");
         }
         if(this.FAutoScrollV)
         {
            this.FField.scrollV = this.FField.maxScrollV;
         }
      }
      
      public function Clear() : void
      {
         this.FField.text = "";
      }
      
      public function Destroy() : void
      {
         this.Clear();
      }
   }
}

