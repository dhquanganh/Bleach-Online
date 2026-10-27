package Foundation.Utilities
{
   import flash.utils.*;
   
   public class TUtilityString
   {
      
      protected static var FFormatParameters:*;
      
      protected static var FFormatExpression:RegExp = /\%(\d+)/g;
      
      protected static var FCRLFExpression:RegExp = /\r\n/g;
      
      public function TUtilityString()
      {
         super();
         throw new Error("UtilityString Class Is Static Container Only");
      }
      
      protected static function FormatRoutine() : String
      {
         var _loc2_:int = 0;
         _loc2_ = parseInt(arguments[1]);
         return FFormatParameters[_loc2_];
      }
      
      public static function Empty(param1:String) : Boolean
      {
         return param1 == null || param1 == "";
      }
      
      public static function Format(param1:String, ... rest) : String
      {
         var _loc3_:String = null;
         FFormatParameters = rest;
         _loc3_ = param1.replace(FFormatExpression,FormatRoutine);
         FFormatParameters = null;
         return _loc3_;
      }
      
      public static function Fetch(param1:ByteArray) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         _loc2_ = "";
         _loc6_ = false;
         _loc3_ = int(param1.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = int(param1.readUnsignedShort());
            if(_loc5_ == 10 || _loc5_ == 13)
            {
               _loc6_ = true;
            }
            _loc2_ += String.fromCharCode(_loc5_);
            _loc4_++;
         }
         if(_loc6_)
         {
            _loc2_ = _loc2_.replace(FCRLFExpression,"\n");
         }
         return _loc2_;
      }
      
      public static function FetchUTF(param1:ByteArray) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         _loc2_ = "";
         _loc3_ = int(param1.readUnsignedShort());
         return param1.readUTFBytes(_loc3_);
      }
      
      public static function FetchFixed(param1:ByteArray, param2:int) : String
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         _loc3_ = "";
         _loc7_ = false;
         _loc4_ = int(param1.readUnsignedShort());
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = int(param1.readUnsignedShort());
            if(_loc6_ == 10 || _loc6_ == 13)
            {
               _loc7_ = true;
            }
            _loc3_ += String.fromCharCode(_loc6_);
            _loc5_++;
         }
         if(_loc4_ < param2)
         {
            _loc4_ = param2 - _loc4_;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               param1.readUnsignedShort();
               _loc5_++;
            }
         }
         if(_loc7_)
         {
            _loc3_ = _loc3_.replace(FCRLFExpression,"\n");
         }
         return _loc3_;
      }
      
      public static function Flush(param1:ByteArray, param2:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = param2.length;
         param1.writeUnsignedInt(_loc3_);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            param1.writeShort(param2.charCodeAt(_loc4_));
            _loc4_++;
         }
      }
      
      public static function FlushUTF(param1:ByteArray, param2:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:ByteArray = null;
         _loc4_ = new ByteArray();
         _loc4_.writeUTFBytes(param2);
         _loc3_ = int(_loc4_.length);
         param1.writeShort(_loc3_);
         param1.writeUTFBytes(param2);
         _loc4_.clear();
         _loc4_ = null;
      }
      
      public static function FlushFixed(param1:ByteArray, param2:String, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param2.length >= param3)
         {
            _loc4_ = param3;
            _loc5_ = 0;
         }
         else
         {
            _loc4_ = param2.length;
            _loc5_ = param3 - _loc4_;
         }
         param1.writeShort(_loc4_);
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            param1.writeShort(param2.charCodeAt(_loc6_));
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            param1.writeShort(0);
            _loc6_++;
         }
      }
      
      public static function StringsAreEquals(param1:String, param2:String, param3:Boolean = false) : Boolean
      {
         if(param3)
         {
            return param1 == param2;
         }
         return param1.toUpperCase() == param2.toUpperCase();
      }
      
      public static function Trim(param1:String) : String
      {
         return LTrim(RTrim(param1));
      }
      
      public static function LTrim(param1:String) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = param1.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1.charCodeAt(_loc2_) > 32)
            {
               return param1.substring(_loc2_);
            }
            _loc2_++;
         }
         return "";
      }
      
      public static function RTrim(param1:String) : String
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         _loc3_ = param1.length;
         _loc2_ = _loc3_;
         while(_loc2_ > 0)
         {
            if(param1.charCodeAt(_loc2_ - 1) > 32)
            {
               return param1.substring(0,_loc2_);
            }
            _loc2_--;
         }
         return "";
      }
      
      public static function Remove(param1:String, param2:String) : String
      {
         return Replace(param1,param2,"");
      }
      
      public static function Replace(param1:String, param2:String, param3:String) : String
      {
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         _loc6_ = new String();
         _loc7_ = false;
         _loc8_ = param1.length;
         _loc9_ = param2.length;
         _loc4_ = 0;
         for(; _loc4_ < _loc8_; _loc4_++)
         {
            if(param1.charAt(_loc4_) == param2.charAt(0))
            {
               _loc7_ = true;
               _loc5_ = 0;
               while(_loc5_ < _loc9_)
               {
                  if(param1.charAt(_loc4_ + _loc5_) != param2.charAt(_loc5_))
                  {
                     _loc7_ = false;
                     break;
                  }
                  _loc5_++;
               }
               if(_loc7_)
               {
                  _loc6_ += param3;
                  _loc4_ += _loc9_ - 1;
                  continue;
               }
            }
            _loc6_ += param1.charAt(_loc4_);
         }
         return _loc6_;
      }
      
      public static function CompareArray(param1:String, param2:String) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = "";
         var _loc6_:String = "";
         var _loc7_:int = 0;
         if(param1.length >= param2.length)
         {
            _loc5_ = param1;
            _loc6_ = param2;
         }
         else
         {
            _loc5_ = param2;
            _loc6_ = param1;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc5_.length)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc6_.length)
            {
               if(_loc6_.charAt(_loc4_) != _loc5_.charAt(_loc3_))
               {
                  _loc7_++;
               }
               _loc4_++;
            }
            if(_loc7_ == _loc6_.length)
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      public static function WrapFormat(param1:String) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         _loc4_ = "";
         _loc5_ = param1.split("%n");
         _loc3_ = int(_loc5_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc4_ + _loc5_[_loc2_] + "\n";
            _loc2_++;
         }
         return _loc4_;
      }
   }
}

