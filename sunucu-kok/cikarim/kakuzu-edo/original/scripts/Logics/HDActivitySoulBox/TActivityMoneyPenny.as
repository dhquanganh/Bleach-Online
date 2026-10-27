package Logics.HDActivitySoulBox
{
   import Logics.HDActivityOS.TActivityOSBase;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TActivityMoneyPenny extends TActivityOSBase
   {
      
      protected var FMPBoxStatus:Vector.<TActivityMoneyPennyBox>;
      
      protected var FCurDay:uint;
      
      protected var FTotalReturn:uint;
      
      protected var FTotalExcharged:uint;
      
      protected var FMPConditions:Vector.<TActivityMoneyPennyCondition>;
      
      protected var FAddPercent:uint;
      
      public function TActivityMoneyPenny()
      {
         super();
      }
      
      public function get MPBoxStatus() : Vector.<TActivityMoneyPennyBox>
      {
         return this.FMPBoxStatus;
      }
      
      public function set MPBoxStatus(param1:Vector.<TActivityMoneyPennyBox>) : void
      {
         this.FMPBoxStatus = param1;
      }
      
      public function get CurDay() : uint
      {
         return this.FCurDay;
      }
      
      public function set CurDay(param1:uint) : void
      {
         this.FCurDay = param1;
      }
      
      public function get TotalReturn() : uint
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         _loc3_ = true;
         _loc2_ = this.FMPBoxStatus.length - 1;
         this.FTotalReturn = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FMPBoxStatus[_loc1_].Excharged >= this.FMPConditions[0].Condition)
            {
               if(_loc3_)
               {
                  _loc3_ = true;
               }
            }
            else
            {
               _loc3_ = false;
            }
            this.FTotalReturn += this.FMPBoxStatus[_loc1_].Return;
            _loc1_++;
         }
         if(_loc3_)
         {
            this.FTotalReturn += Math.floor(this.FTotalReturn * this.FAddPercent / 100);
         }
         return this.FTotalReturn;
      }
      
      public function get TotalExcharged() : uint
      {
         return this.FTotalExcharged;
      }
      
      public function get MPConditions() : Vector.<TActivityMoneyPennyCondition>
      {
         return this.FMPConditions;
      }
      
      public function set MPConditions(param1:Vector.<TActivityMoneyPennyCondition>) : void
      {
         this.FMPConditions = param1;
      }
      
      public function get AddPercent() : uint
      {
         return this.FAddPercent;
      }
      
      public function set AddPercent(param1:uint) : void
      {
         this.FAddPercent = param1;
      }
      
      public function GetMPByUniqueIndex(param1:uint) : TActivityMoneyPennyBox
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FMPBoxStatus.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FMPBoxStatus[_loc2_].Index == param1)
            {
               return this.FMPBoxStatus[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function GetBoxByIndex(param1:int) : TActivityMoneyPennyBox
      {
         return this.FMPBoxStatus[param1];
      }
      
      public function GetReceiveBox() : TActivityMoneyPennyBox
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FMPBoxStatus.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FMPBoxStatus[_loc1_].GetType == CONST_ACTIVITY_MODE.GETTYPE_Activity_AwardRecive)
            {
               return this.FMPBoxStatus[_loc1_];
            }
            _loc1_++;
         }
         return null;
      }
   }
}

