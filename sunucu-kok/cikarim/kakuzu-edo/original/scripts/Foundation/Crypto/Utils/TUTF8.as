package Foundation.Crypto.Utils
{
   public class TUTF8
   {
      
      public function TUTF8()
      {
         super();
         throw new Error("TUTF8 Class Is Static Container Only");
      }
      
      public static function Encode(param1:String) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc4_ = "";
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1.charCodeAt(_loc2_);
            if(_loc3_ < 128)
            {
               _loc4_ += String.fromCharCode(_loc3_);
            }
            else if(_loc3_ > 127 && _loc3_ < 2048)
            {
               _loc4_ += String.fromCharCode(_loc3_ >> 6 | 0xC0);
               _loc4_ = _loc4_ + String.fromCharCode(_loc3_ & 0x3F | 0x80);
            }
            else
            {
               _loc4_ += String.fromCharCode(_loc3_ >> 12 | 0xE0);
               _loc4_ = _loc4_ + String.fromCharCode(_loc3_ >> 6 & 0x3F | 0x80);
               _loc4_ = _loc4_ + String.fromCharCode(_loc3_ & 0x3F | 0x80);
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      public static function Decode(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc2_ = "";
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1.charCodeAt(_loc3_);
            if(_loc4_ < 128)
            {
               _loc2_ += String.fromCharCode(_loc4_);
               _loc3_++;
            }
            else if(_loc4_ > 191 && _loc4_ < 224)
            {
               _loc5_ = param1.charCodeAt(_loc3_ + 1);
               _loc2_ += String.fromCharCode((_loc4_ & 0x1F) << 6 | _loc5_ & 0x3F);
               _loc3_ += 2;
            }
            else
            {
               _loc5_ = param1.charCodeAt(_loc3_ + 1);
               _loc6_ = param1.charCodeAt(_loc3_ + 2);
               _loc2_ += String.fromCharCode((_loc4_ & 0x0F) << 12 | (_loc5_ & 0x3F) << 6 | _loc6_ & 0x3F);
               _loc3_ += 3;
            }
         }
         return _loc2_;
      }
   }
}

