package Ǹ
{
   import flash.utils.*;
   
   public class Ǿ
   {
      
      protected static var Ȯ:*;
      
      protected static var ȭ:RegExp = /\%(\d+)/g;
      
      protected static var ȯ:RegExp = /\r\n/g;
      
      public function Ǿ()
      {
         super();
         throw new Error("UtilityString Class Is Static Container Only");
      }
      
      protected static function Ȱ() : String
      {
         var _loc2_:int = 0;
         _loc2_ = parseInt(arguments[1]);
         return Ȯ[_loc2_];
      }
      
      public static function ȱ(param1:String) : Boolean
      {
         return param1 == null || param1 == "";
      }
      
      public static function Ȳ(param1:String, ... rest) : String
      {
         var _loc3_:String = null;
         Ȯ = rest;
         _loc3_ = param1.replace(ȭ,Ȱ);
         Ȯ = null;
         return _loc3_;
      }
      
      public static function ȳ(param1:ByteArray) : String
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
            _loc2_ = _loc2_.replace(ȯ,"\n");
         }
         return _loc2_;
      }
      
      public static function ȴ(param1:ByteArray) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         _loc2_ = "";
         _loc3_ = int(param1.readUnsignedShort());
         return param1.readUTFBytes(_loc3_);
      }
      
      public static function ȵ(param1:ByteArray, param2:int) : String
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
            _loc3_ = _loc3_.replace(ȯ,"\n");
         }
         return _loc3_;
      }
      
      public static function ȶ(param1:ByteArray, param2:String) : void
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
      
      public static function ȷ(param1:ByteArray, param2:String) : void
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
      
      public static function ȸ(param1:ByteArray, param2:String, param3:int) : void
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
      
      public static function ȹ(param1:String, param2:String, param3:Boolean = false) : Boolean
      {
         if(param3)
         {
            return param1 == param2;
         }
         return param1.toUpperCase() == param2.toUpperCase();
      }
      
      public static function Ⱥ(param1:String) : String
      {
         return Ȼ(ȼ(param1));
      }
      
      public static function Ȼ(param1:String) : String
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
      
      public static function ȼ(param1:String) : String
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
      
      public static function Ƚ(param1:String, param2:String) : String
      {
         return Ⱦ(param1,param2,"");
      }
      
      public static function Ⱦ(param1:String, param2:String, param3:String) : String
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
      
      public static function ȿ(param1:String, param2:String) : Boolean
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
      
      public static function ɀ(param1:String) : String
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

