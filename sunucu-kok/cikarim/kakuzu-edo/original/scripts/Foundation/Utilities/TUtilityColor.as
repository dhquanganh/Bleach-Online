package Foundation.Utilities
{
   public class TUtilityColor
   {
      
      public function TUtilityColor()
      {
         super();
         throw new Error("TUtilityColor Class Is Static Container Only");
      }
      
      public static function GetHex(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0) : Number
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         _loc5_ = param1 > 1 ? 1 : param1;
         _loc6_ = param2 > 1 ? 1 : param2;
         _loc7_ = param3 > 1 ? 1 : param3;
         _loc8_ = param4 > 1 ? 1 : param4;
         return Math.round(_loc8_ * 255) << 24 ^ Math.round(_loc5_ * 255) << 16 ^ Math.round(_loc6_ * 255) << 8 ^ Math.round(_loc7_ * 255);
      }
      
      public static function GetRGB(param1:Number) : Object
      {
         var _loc2_:Object = null;
         _loc2_ = new Object();
         _loc2_.a = ((0xFF0000 & param1) >> 24) / 255;
         _loc2_.r = ((0xFF0000 & param1) >> 16) / 255;
         _loc2_.g = ((0xFF00 & param1) >> 8) / 255;
         _loc2_.b = (0xFF & param1) / 255;
         return _loc2_;
      }
      
      public static function HSB2RGB(param1:Number, param2:Number, param3:Number) : Object
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         param1 %= 360;
         if(param3 == 0)
         {
            return {
               "r":0,
               "g":0,
               "b":0
            };
         }
         param2 /= 100;
         param3 /= 100;
         param1 /= 60;
         _loc7_ = Math.floor(param1);
         _loc8_ = param1 - _loc7_;
         _loc9_ = param3 * (1 - param2);
         _loc10_ = param3 * (1 - param2 * _loc8_);
         _loc11_ = param3 * (1 - param2 * (1 - _loc8_));
         switch(_loc7_)
         {
            case 0:
               _loc4_ = param3;
               _loc5_ = _loc11_;
               _loc6_ = _loc9_;
               break;
            case 1:
               _loc4_ = _loc10_;
               _loc5_ = param3;
               _loc6_ = _loc9_;
               break;
            case 2:
               _loc4_ = _loc9_;
               _loc5_ = param3;
               _loc6_ = _loc11_;
               break;
            case 3:
               _loc4_ = _loc9_;
               _loc5_ = _loc10_;
               _loc6_ = param3;
               break;
            case 4:
               _loc4_ = _loc11_;
               _loc5_ = _loc9_;
               _loc6_ = param3;
               break;
            case 5:
               _loc4_ = param3;
               _loc5_ = _loc9_;
               _loc6_ = _loc10_;
         }
         return {
            "r":_loc4_,
            "g":_loc5_,
            "b":_loc6_
         };
      }
      
      public static function RGB2HSB(param1:Number, param2:Number, param3:Number) : Object
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         _loc4_ = Math.min(Math.min(param1,param2),param3);
         _loc5_ = Math.max(Math.max(param1,param2),param3);
         if(_loc4_ == _loc5_)
         {
            return {
               "h":undefined,
               "s":0,
               "v":_loc5_ * 100
            };
         }
         _loc6_ = param1 == _loc4_ ? param2 - param3 : (param2 == _loc4_ ? param3 - param1 : param1 - param2);
         _loc7_ = param1 == _loc4_ ? 3 : (param2 == _loc4_ ? 5 : 1);
         _loc8_ = Math.floor((_loc7_ - _loc6_ / (_loc5_ - _loc4_)) * 60) % 360;
         _loc9_ = Math.floor((_loc5_ - _loc4_) / _loc5_ * 100);
         _loc5_ = Math.floor(_loc5_ * 100);
         return {
            "h":_loc8_,
            "s":_loc9_,
            "b":_loc5_
         };
      }
      
      public static function TransformWebColor(param1:String) : uint
      {
         if(param1 == "" || param1 == null)
         {
            return 0;
         }
         return uint(parseInt(param1.slice(1),16));
      }
      
      public static function TransUintToWeb(param1:uint) : String
      {
         return "#" + param1.toString(16);
      }
      
      public static function GetAlphaFromARGB(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc2_ = param1;
         _loc3_ = uint(_loc2_ >> 24 & 0xFF);
         _loc4_ = uint(_loc2_ >> 16 & 0xFF);
         _loc5_ = uint(_loc2_ >> 8 & 0xFF);
         _loc6_ = uint(_loc2_ & 0xFF);
         return _loc3_;
      }
   }
}

