package Foundation.Crypto
{
   import Foundation.Crypto.Utils.*;
   
   public class TBase64
   {
      
      private static const code:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
      
      public function TBase64()
      {
         super();
         throw new Error("TBase64 Class Is Static Container Only");
      }
      
      public static function Encode(param1:String, param2:Boolean = false) : String
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc13_:* = 0;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:String = null;
         var _loc11_:Array = [];
         var _loc12_:String = "";
         _loc16_ = TBase64.code;
         _loc14_ = param2 ? TUTF8.Encode(param1) : param1;
         _loc13_ = int(_loc14_.length % 3);
         if(_loc13_ > 0)
         {
            while(_loc13_++ < 3)
            {
               _loc12_ += "=";
               _loc14_ += "0";
            }
         }
         _loc13_ = 0;
         while(_loc13_ < _loc14_.length)
         {
            _loc3_ = _loc14_.charCodeAt(_loc13_);
            _loc4_ = _loc14_.charCodeAt(_loc13_ + 1);
            _loc5_ = _loc14_.charCodeAt(_loc13_ + 2);
            _loc6_ = _loc3_ << 16 | _loc4_ << 8 | _loc5_;
            _loc7_ = _loc6_ >> 18 & 0x3F;
            _loc8_ = _loc6_ >> 12 & 0x3F;
            _loc9_ = _loc6_ >> 6 & 0x3F;
            _loc10_ = _loc6_ & 0x3F;
            _loc11_[_loc13_ / 3] = _loc16_.charAt(_loc7_) + _loc16_.charAt(_loc8_) + _loc16_.charAt(_loc9_) + _loc16_.charAt(_loc10_);
            _loc13_ += 3;
         }
         _loc15_ = _loc11_.join("");
         return _loc15_.slice(0,_loc15_.length - _loc12_.length) + _loc12_;
      }
      
      public static function Decode(param1:String, param2:Boolean = false) : String
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc12_:Array = [];
         _loc15_ = TBase64.code;
         _loc14_ = param2 ? TUTF8.Decode(param1) : param1;
         _loc11_ = 0;
         while(_loc11_ < _loc14_.length)
         {
            _loc6_ = _loc15_.indexOf(_loc14_.charAt(_loc11_));
            _loc7_ = _loc15_.indexOf(_loc14_.charAt(_loc11_ + 1));
            _loc8_ = _loc15_.indexOf(_loc14_.charAt(_loc11_ + 2));
            _loc9_ = _loc15_.indexOf(_loc14_.charAt(_loc11_ + 3));
            _loc10_ = _loc6_ << 18 | _loc7_ << 12 | _loc8_ << 6 | _loc9_;
            _loc3_ = _loc10_ >>> 16 & 0xFF;
            _loc4_ = _loc10_ >>> 8 & 0xFF;
            _loc5_ = _loc10_ & 0xFF;
            _loc12_[_loc11_ / 4] = String.fromCharCode(_loc3_,_loc4_,_loc5_) + "";
            if(_loc9_ == 64)
            {
               _loc12_[_loc11_ / 4] = String.fromCharCode(_loc3_,_loc4_);
            }
            if(_loc8_ == 64)
            {
               _loc12_[_loc11_ / 4] = String.fromCharCode(_loc3_);
            }
            _loc11_ += 4;
         }
         _loc13_ = _loc12_.join("");
         return param2 ? TUTF8.Decode(_loc13_) : _loc13_;
      }
   }
}

