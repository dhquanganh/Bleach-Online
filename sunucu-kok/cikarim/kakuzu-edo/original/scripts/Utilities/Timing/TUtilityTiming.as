package Utilities.Timing
{
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   
   public class TUtilityTiming
   {
      
      public static const CONST_DAY:uint = 24 * 60 * 60;
      
      public function TUtilityTiming()
      {
         super();
         throw new Error("TUtilityTiming Class Is Static Container Only");
      }
      
      protected static function FormatDecimal(param1:uint, param2:int = 2) : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc3_ = param1.toString().toUpperCase();
         _loc5_ = param2 - _loc3_.length;
         if(_loc5_ > 0)
         {
            _loc4_ = "";
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc4_ += "0";
               _loc6_++;
            }
            _loc3_ = _loc4_ + _loc3_;
         }
         return _loc3_;
      }
      
      public static function FormatDHMBySeconds(param1:int) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param1 <= 59)
         {
            return param1.toString() + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MainScene_STRING_5);
         }
         _loc3_ = (param1 + 59) / 60;
         _loc6_ = _loc3_ % 60;
         _loc3_ /= 60;
         _loc5_ = _loc3_ % 24;
         _loc4_ = _loc3_ / 24;
         if(_loc4_ != 0)
         {
            _loc2_ = _loc4_.toString() + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MainScene_STRING_6);
         }
         else
         {
            _loc2_ = "";
         }
         if(_loc4_ != 0 || _loc5_ != 0)
         {
            _loc2_ += _loc5_.toString() + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MainScene_STRING_3);
         }
         return _loc2_ + (_loc6_.toString() + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MainScene_STRING_4));
      }
      
      public static function FormatDHMSBySeconds(param1:int) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc3_ = param1 / 60;
         _loc6_ = _loc3_ % 60;
         _loc3_ /= 60;
         _loc5_ = _loc3_ % 24;
         _loc4_ = _loc3_ / 24;
         if(_loc6_ != 0)
         {
            if(_loc5_ != 0)
            {
               _loc7_ = _loc6_ + _loc5_ * 60;
               if(_loc4_ != 0)
               {
                  _loc7_ += _loc4_ * CONST_DAY;
               }
            }
            else
            {
               _loc7_ = _loc6_;
            }
         }
         else
         {
            _loc7_ = _loc5_ * 60;
         }
         _loc3_ = param1 - _loc7_ * 60;
         if(_loc4_ != 0)
         {
            return _loc4_.toString() + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MainScene_STRING_6);
         }
         _loc2_ = "";
         _loc2_ += FormatDecimal(_loc5_) + ":";
         _loc2_ += FormatDecimal(_loc6_) + ":";
         return _loc2_ + FormatDecimal(_loc3_);
      }
      
      public static function FormatSingleDHMBySeconds(param1:int) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param1 <= 59)
         {
            return param1.toString() + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MainScene_STRING_5);
         }
         _loc3_ = (param1 + 59) / 60;
         _loc6_ = _loc3_ % 60;
         _loc3_ /= 60;
         _loc5_ = _loc3_ % 24;
         _loc4_ = _loc3_ / 24;
         if(_loc4_ != 0)
         {
            return _loc4_.toString() + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MainScene_STRING_6);
         }
         _loc2_ = "";
         if(_loc4_ != 0 || _loc5_ != 0)
         {
            return _loc5_.toString() + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MainScene_STRING_3);
         }
         return _loc6_.toString() + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MainScene_STRING_4);
      }
      
      public static function FormatMSBySeconds(param1:int) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc2_ = "";
         _loc3_ = param1 / 60;
         _loc6_ = _loc3_ % 60;
         _loc3_ /= 60;
         _loc5_ = _loc3_ % 24;
         _loc4_ = _loc3_ / 24;
         if(_loc6_ != 0)
         {
            if(_loc5_ != 0)
            {
               _loc7_ = _loc6_ + _loc5_ * 60;
               if(_loc4_ != 0)
               {
                  _loc7_ += _loc4_ * CONST_DAY;
               }
            }
            else
            {
               _loc7_ = _loc6_;
            }
         }
         else
         {
            _loc7_ = _loc5_ * 60;
         }
         _loc3_ = param1 - _loc7_ * 60;
         _loc2_ += FormatDecimal(_loc6_) + ":";
         return _loc2_ + FormatDecimal(_loc3_);
      }
      
      public static function FormatTimeWithoutHours(param1:int) : String
      {
         if(param1 <= 0)
         {
            return "00:00:00";
         }
         var _loc2_:String = "";
         var _loc3_:int = param1 / 3600;
         var _loc4_:int = (param1 - _loc3_ * 3600) / 60;
         var _loc5_:int = param1 - _loc3_ * 3600 - _loc4_ * 60;
         if(_loc3_ >= 24)
         {
            return Math.floor(_loc3_ / 24) + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MainScene_STRING_6);
         }
         if(_loc4_ >= 10)
         {
            _loc2_ += _loc4_;
         }
         else if(_loc4_ == 0)
         {
            _loc2_ += "00";
         }
         else
         {
            _loc2_ += "0" + _loc4_;
         }
         _loc2_ += ":";
         if(_loc5_ >= 10)
         {
            _loc2_ += _loc5_;
         }
         else if(_loc5_ == 0)
         {
            _loc2_ += "00";
         }
         else
         {
            _loc2_ += "0" + _loc5_;
         }
         return _loc2_;
      }
      
      public static function FormatTimeWithoutSecond(param1:int) : String
      {
         if(param1 <= 0)
         {
            return "00:00";
         }
         var _loc2_:String = "";
         var _loc3_:int = param1 / 3600;
         var _loc4_:int = (param1 - _loc3_ * 3600) / 60;
         if(_loc3_ >= 10)
         {
            _loc2_ += _loc3_;
         }
         else if(_loc3_ == 0)
         {
            _loc2_ += "00";
         }
         else
         {
            _loc2_ += "0" + _loc3_;
         }
         _loc2_ += ":";
         if(_loc4_ >= 10)
         {
            _loc2_ += _loc4_;
         }
         else if(_loc4_ == 0)
         {
            _loc2_ += "00";
         }
         else
         {
            _loc2_ += "0" + _loc4_;
         }
         return _loc2_;
      }
      
      public static function fomatTime(param1:int) : String
      {
         if(param1 <= 0)
         {
            return "00:00:00";
         }
         var _loc2_:String = "";
         var _loc3_:int = param1 / 3600;
         var _loc4_:int = (param1 - _loc3_ * 3600) / 60;
         var _loc5_:int = param1 - _loc3_ * 3600 - _loc4_ * 60;
         if(_loc3_ >= 24)
         {
            return Math.floor(_loc3_ / 24) + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MainScene_STRING_6);
         }
         if(_loc3_ >= 10)
         {
            _loc2_ += _loc3_;
         }
         else if(_loc3_ == 0)
         {
            _loc2_ += "00";
         }
         else
         {
            _loc2_ += "0" + _loc3_;
         }
         _loc2_ += ":";
         if(_loc4_ >= 10)
         {
            _loc2_ += _loc4_;
         }
         else if(_loc4_ == 0)
         {
            _loc2_ += "00";
         }
         else
         {
            _loc2_ += "0" + _loc4_;
         }
         _loc2_ += ":";
         if(_loc5_ >= 10)
         {
            _loc2_ += _loc5_;
         }
         else if(_loc5_ == 0)
         {
            _loc2_ += "00";
         }
         else
         {
            _loc2_ += "0" + _loc5_;
         }
         return _loc2_;
      }
      
      public static function fomatTimeTwo(param1:int) : String
      {
         if(param1 <= 0)
         {
            return "00:00:00";
         }
         var _loc2_:String = "";
         var _loc3_:int = param1 / 3600;
         var _loc4_:int = (param1 - _loc3_ * 3600) / 60;
         var _loc5_:int = param1 - _loc3_ * 3600 - _loc4_ * 60;
         if(_loc3_ >= 10)
         {
            _loc2_ += _loc3_;
         }
         else if(_loc3_ == 0)
         {
            _loc2_ += "00";
         }
         else
         {
            _loc2_ += "0" + _loc3_;
         }
         _loc2_ += ":";
         if(_loc4_ >= 10)
         {
            _loc2_ += _loc4_;
         }
         else if(_loc4_ == 0)
         {
            _loc2_ += "00";
         }
         else
         {
            _loc2_ += "0" + _loc4_;
         }
         _loc2_ += ":";
         if(_loc5_ >= 10)
         {
            _loc2_ += _loc5_;
         }
         else if(_loc5_ == 0)
         {
            _loc2_ += "00";
         }
         else
         {
            _loc2_ += "0" + _loc5_;
         }
         return _loc2_;
      }
   }
}

