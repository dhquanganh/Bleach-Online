package Foundation.Utilities
{
   import flash.utils.*;
   
   public class TUtilityDate
   {
      
      public function TUtilityDate()
      {
         super();
         throw new Error("UtilityDate Class Is Static Container Only");
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
      
      public static function FormatDateBleachTime(param1:Date) : String
      {
         var _loc2_:String = null;
         return (param1.hours < 10 ? "0" + param1.hours : param1.hours) + ":" + (param1.minutes < 10 ? "0" + param1.minutes : param1.minutes) + ":" + (param1.seconds < 10 ? "0" + param1.seconds : param1.seconds);
      }
      
      public static function FormatDateString(param1:Date) : String
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         _loc2_ = param1.fullYear % 100;
         _loc3_ = _loc2_ / 10;
         _loc4_ = _loc2_ % 10;
         _loc5_ = _loc3_.toString() + _loc4_.toString();
         return _loc5_ + "-" + (param1.month + 1) + "-" + param1.date + " " + (param1.hours < 10 ? "0" + param1.hours : param1.hours) + ":" + (param1.minutes < 10 ? "0" + param1.minutes : param1.minutes) + ":" + (param1.seconds < 10 ? "0" + param1.seconds : param1.seconds);
      }
      
      public static function FormatDateChinese(param1:Date) : String
      {
         var _loc2_:String = param1.fullYearUTC.toString();
         return _loc2_ + "/" + (param1.month + 1) + "/" + param1.date;
      }
      
      public static function FormatDateChineseNew(param1:Date) : String
      {
         var _loc2_:String = param1.fullYear.toString();
         return _loc2_ + "/" + (param1.month + 1) + "/" + param1.date + " " + (param1.hours > 9 ? param1.hours.toString() : "0" + param1.hours) + ":" + (param1.minutes > 9 ? param1.minutes.toString() : "0" + param1.minutes);
      }
      
      public static function FormatDateAmerican(param1:Date) : String
      {
         var _loc2_:String = param1.fullYearUTC.toString();
         return param1.month + 1 + "/" + param1.date + "/" + _loc2_;
      }
      
      public static function FormatDateAmericanNew(param1:Date) : String
      {
         var _loc2_:String = param1.fullYear.toString();
         return param1.month + 1 + "/" + param1.date + "/" + _loc2_ + " " + (param1.hours > 9 ? param1.hours.toString() : "0" + param1.hours) + ":" + (param1.minutes > 9 ? param1.minutes.toString() : "0" + param1.minutes);
      }
      
      public static function FormatDateChineseNewByTime(param1:Number) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:Date = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         _loc4_ = new Date(param1);
         _loc5_ = FormatDecimal(_loc4_.month + 1);
         _loc6_ = FormatDecimal(_loc4_.date);
         _loc7_ = FormatDecimal(_loc4_.hours);
         _loc8_ = FormatDecimal(_loc4_.minutes);
         return _loc5_ + "-" + _loc6_ + " " + _loc7_ + ":" + _loc8_;
      }
      
      public static function FormatMMDDChineseNew(param1:Date) : String
      {
         return param1.month + 1 + "/" + param1.date;
      }
      
      public static function GetMonthDaysByDate(param1:Date) : int
      {
         var _loc2_:int = 0;
         switch(param1.month)
         {
            case 0:
               _loc2_ = 31;
               break;
            case 1:
               _loc2_ = param1.fullYear % 4 == 0 ? (param1.fullYear % 100 == 0 && param1.fullYear % 400 != 0 ? 28 : 29) : 28;
               break;
            case 2:
               _loc2_ = 31;
               break;
            case 3:
               _loc2_ = 30;
               break;
            case 4:
               _loc2_ = 31;
               break;
            case 5:
               _loc2_ = 30;
               break;
            case 6:
               _loc2_ = 31;
               break;
            case 7:
               _loc2_ = 31;
               break;
            case 8:
               _loc2_ = 30;
               break;
            case 9:
               _loc2_ = 31;
               break;
            case 10:
               _loc2_ = 30;
               break;
            case 11:
               _loc2_ = 31;
         }
         return _loc2_;
      }
      
      public static function CompareTwoDate(param1:Date, param2:Date) : Boolean
      {
         if(param1 == null || param2 == null)
         {
            throw new Error("Date is Null!");
         }
         var _loc3_:Number = param1.getTime();
         var _loc4_:Number = param2.getTime();
         if(_loc3_ > _loc4_)
         {
            return true;
         }
         return false;
      }
      
      public static function ValidateDates(param1:Date, param2:Date) : Boolean
      {
         if(param1 == null && param2 == null)
         {
            return true;
         }
         if(param1 != null && param2 == null || param2 != null && param1 == null)
         {
            return true;
         }
         if(CompareTwoDate(param1,param2))
         {
            return false;
         }
         return true;
      }
      
      public static function ParseDateString(param1:String) : Date
      {
         if(param1 == null)
         {
            return new Date();
         }
         return new Date();
      }
      
      public static function ValidateTwoYear(param1:Date, param2:Date = null, param3:int = 18) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if(param2 == null)
         {
            param2 = new Date();
         }
         var _loc4_:int = param2.getFullYear() - param1.getFullYear();
         if(_loc4_ >= param3)
         {
            return true;
         }
         return false;
      }
      
      public static function ToDateMaxFormat(param1:Date) : Date
      {
         if(param1 == null)
         {
            return param1;
         }
         return new Date(param1.getFullYear(),param1.getMonth(),param1.getDate(),23,59,59);
      }
      
      public static function ToDateMinFormat(param1:Date) : Date
      {
         if(param1 == null)
         {
            return param1;
         }
         return new Date(param1.getFullYear(),param1.getMonth(),param1.getDate(),0,0,0);
      }
      
      public static function TransDateToGMTNegativeFour(param1:Date) : Date
      {
         if(param1 == null)
         {
            return null;
         }
         return new Date(param1.setMilliseconds((param1.getTimezoneOffset() - 240) * 60000));
      }
      
      public static function TransDateToNegativeFourHoursLater(param1:Date) : Date
      {
         if(param1 == null)
         {
            return null;
         }
         return new Date(param1.setMilliseconds((240 - param1.getTimezoneOffset()) * 60000));
      }
      
      public static function ValidateBetweenTwoDate(param1:Date, param2:Date, param3:int) : Boolean
      {
         var _loc4_:Number = NaN;
         if(param1 == null || param2 == null)
         {
            return false;
         }
         _loc4_ = param1.getTime() - param2.getTime();
         if(_loc4_ >= param3 * 1000)
         {
            return true;
         }
         return false;
      }
      
      public static function GetCountDownTime(param1:int, param2:int) : Number
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Date = null;
         var _loc6_:Date = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         _loc5_ = new Date();
         _loc5_.time = param1 * 1000;
         _loc9_ = param2 / 3600;
         _loc7_ = new Vector.<int>();
         _loc3_ = 0;
         while(_loc3_ <= 23)
         {
            if(_loc3_ % _loc9_ == 0)
            {
               _loc7_.push(_loc3_);
            }
            _loc3_++;
         }
         _loc4_ = int(_loc7_.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(_loc5_.hours >= _loc7_[_loc3_])
            {
               _loc8_ = _loc7_[_loc3_];
            }
            _loc3_++;
         }
         _loc6_ = new Date();
         _loc6_.fullYear = _loc5_.fullYear;
         _loc6_.month = _loc5_.month;
         _loc6_.date = _loc5_.date;
         _loc6_.hours = _loc8_;
         _loc6_.seconds = 0;
         _loc6_.minutes = 0;
         return _loc6_.time / 1000 + param2 - param1;
      }
      
      public static function GetCountDownTime2(param1:int, param2:int) : Number
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Vector.<int> = null;
         var _loc8_:Date = null;
         var _loc9_:Date = null;
         _loc4_ = 24 * 60 * 60 / param2;
         _loc8_ = new Date();
         _loc8_.time = param1 * 1000;
         _loc9_ = new Date();
         _loc9_.fullYear = _loc8_.fullYear;
         _loc9_.month = _loc8_.month;
         _loc9_.date = _loc8_.date;
         _loc9_.hours = 0;
         _loc9_.seconds = 0;
         _loc9_.minutes = 0;
         _loc5_ = _loc9_.time / 1000;
         _loc7_ = new Vector.<int>();
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ += _loc3_ * param2;
            _loc7_[_loc3_] = _loc5_;
            _loc5_ -= _loc3_ * param2;
            _loc3_++;
         }
         _loc4_ = int(_loc7_.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1 >= _loc7_[_loc3_])
            {
               _loc6_ = _loc7_[_loc3_];
            }
            _loc3_++;
         }
         return _loc6_ + param2 - param1;
      }
   }
}

