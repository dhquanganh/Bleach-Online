package Logics.Streamization.HDActivityMode
{
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.*;
   import Foundation.Timing.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityMode.*;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.*;
   
   public class TUnstreamizerActivityAtoms extends TUnstreamizer
   {
      
      protected static const TYPE_TIME_DAY:uint = 1;
      
      protected static const TYPE_TIME_WEEK:uint = 2;
      
      protected static const TYPE_TIME_DATE:uint = 3;
      
      protected static const TYPE_TIME_MINUTE:uint = 4;
      
      protected static const TYPE_TIME_CYCLE:uint = 5;
      
      protected static const TYPE_StartTime:uint = 0;
      
      protected static const TYPE_EndTime:uint = 1;
      
      protected var FAllDayTime:uint;
      
      protected var FSeverStartTime:uint;
      
      protected var FSeverTime:uint;
      
      public function TUnstreamizerActivityAtoms()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_ActivityAtoms(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_ActivityAtoms(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityAtoms = null;
         var _loc5_:THDActivity = null;
         var _loc6_:THDIcon = null;
         var _loc7_:TBins = null;
         var _loc8_:uint = 0;
         _loc7_ = param3 as TBins;
         _loc4_ = param2 as TActivityAtoms;
         _loc8_ = _loc4_.Identifier;
         _loc5_ = _loc7_.GetDatebaseByIdentifier(_loc8_) as THDActivity;
         _loc4_.ActivityNumber = _loc5_.ActId;
         _loc4_.ActivityID = _loc4_.ActivityNumber - _loc4_.ActivityNumber % 1000;
         _loc4_.ActivityName = _loc5_.ActName;
         _loc4_.ActivityType = _loc5_.ActType;
         _loc4_.TimeType = _loc5_.TimeType;
         _loc4_.StartTimeVect = _loc5_.StartTimeVect;
         _loc4_.EndTimeVect = _loc5_.EndTimeVect;
         _loc4_.StartTime = this.GetTime(TYPE_StartTime,_loc4_.TimeType,_loc5_.StartTimeVect,_loc5_.EndTimeVect);
         if(_loc4_.TimeType == TYPE_TIME_CYCLE)
         {
            _loc4_.EndTime = this.GetTime(TYPE_EndTime,_loc4_.TimeType,_loc5_.StartTimeVect,_loc5_.EndTimeVect);
         }
         else
         {
            _loc4_.EndTime = this.GetTime(TYPE_EndTime,_loc4_.TimeType,_loc5_.EndTimeVect);
         }
         _loc4_.IconID = _loc5_.ActIcon;
         _loc4_.IconLocation = _loc5_.Position;
         _loc4_.IconSort = _loc5_.ActPosition;
         _loc4_.PlayerLevel = _loc5_.PlayerLv;
         _loc4_.VipLevel = _loc5_.VipLv;
         _loc4_.TimeShowType = _loc5_.StartTimeShow;
         _loc4_.IsOpen = true;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HDIcon,_loc4_.IconID) as THDIcon;
         _loc4_.IconType = _loc6_.MainType;
         _loc4_.MainType = _loc6_.MainType;
         _loc4_.SecondType = _loc6_.IconID;
      }
      
      protected function GetTime(param1:uint, param2:uint, param3:Vector.<uint>, param4:Vector.<uint> = null) : uint
      {
         var _loc5_:uint = 0;
         this.FAllDayTime = CONST_ACTIVITY.ALLDAY_TIME;
         this.FSeverStartTime = STimingCore.ServerStartTime;
         this.FSeverTime = STimingCore.ServerTime;
         switch(param2)
         {
            case TYPE_TIME_DAY:
               _loc5_ = this.GetTimeByTypeDay(param1,param3);
               break;
            case TYPE_TIME_WEEK:
               _loc5_ = this.GetTimeByTypeWeek(param1,param3);
               break;
            case TYPE_TIME_DATE:
               _loc5_ = this.GetTimeByTypeDate(param3);
               break;
            case TYPE_TIME_MINUTE:
               break;
            case TYPE_TIME_CYCLE:
               _loc5_ = this.GetTimeByTypeCycle(param1,param3,param4);
         }
         return _loc5_;
      }
      
      protected function GetTimeByTypeDay(param1:uint, param2:Vector.<uint>) : uint
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Date = null;
         if(param1 == TYPE_StartTime)
         {
            _loc3_ = (param2[0] - 1) * this.FAllDayTime;
            _loc4_ = this.FSeverStartTime + _loc3_;
         }
         else if(param1 == TYPE_EndTime)
         {
            _loc5_ = new Date(this.FSeverStartTime * 1000);
            _loc5_.setDate(_loc5_.date + param2[0]);
            _loc4_ = _loc5_.time / 1000;
         }
         return _loc4_;
      }
      
      protected function GetTimeByTypeWeek(param1:uint, param2:Vector.<uint>) : uint
      {
         var _loc3_:Date = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         this.FSeverTime = STimingCore.ServerTime;
         _loc3_ = new Date(this.FSeverTime * 1000);
         _loc5_ = _loc3_.day;
         if(_loc5_ == 0)
         {
            _loc5_ = 7;
         }
         if(param1 == TYPE_StartTime)
         {
            _loc4_ = this.FSeverTime - this.FAllDayTime * (_loc5_ - param2[0]) - _loc3_.hours * 3600 - _loc3_.minutes * 60 - _loc3_.seconds;
            if(_loc4_ < this.FSeverTime)
            {
               _loc4_ = this.FSeverTime;
            }
         }
         else if(param1 == TYPE_EndTime)
         {
            _loc4_ = this.FSeverTime + this.FAllDayTime * (param2[0] - _loc5_) + 3600 * (23 - _loc3_.hours) + 60 * (59 - _loc3_.minutes) + (59 - _loc3_.seconds);
         }
         return _loc4_;
      }
      
      protected function GetTimeByTypeDate(param1:Vector.<uint>) : uint
      {
         var _loc2_:Date = null;
         var _loc3_:uint = 0;
         var _loc4_:Date = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         this.FSeverTime = STimingCore.ServerTime;
         _loc2_ = new Date(this.FSeverTime * 1000);
         _loc5_ = param1[0] == 0 ? int(_loc2_.getFullYear()) : int(param1[0]);
         _loc6_ = param1[1] == 0 ? int(_loc2_.getMonth()) : int(param1[1] - 1);
         _loc7_ = param1[2] == 0 ? int(_loc2_.getDate()) : int(param1[2]);
         _loc8_ = int(param1[3]);
         _loc9_ = int(param1[4]);
         _loc10_ = int(param1[5]);
         _loc4_ = new Date(_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_);
         return uint(_loc4_.getTime() / 1000);
      }
      
      protected function GetTimeByTypeCycle(param1:uint, param2:Vector.<uint>, param3:Vector.<uint> = null) : uint
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:Date = null;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:int = 0;
         _loc4_ = int(param2[0]);
         _loc5_ = param2[1] - 1;
         _loc6_ = int(param2[2]);
         _loc7_ = int(param2[3]);
         _loc8_ = int(param2[4]);
         _loc9_ = int(param2[5]);
         _loc13_ = new Date(_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_);
         _loc11_ = _loc13_.getTime() / 1000;
         _loc10_ = uint(STimingCore.ServerTime);
         _loc14_ = param3[0] + param3[1];
         _loc17_ = _loc10_ - _loc11_;
         if(_loc17_ < 0)
         {
            _loc17_ = 0;
         }
         else
         {
            _loc17_ += _loc17_ % 10;
         }
         _loc15_ = _loc17_ % (_loc14_ * 86400);
         _loc16_ = Math.floor((_loc17_ - _loc15_) / (_loc14_ * 86400));
         if(param1 == TYPE_StartTime)
         {
            _loc12_ = _loc11_ + _loc16_ * _loc14_ * 86400;
         }
         else
         {
            _loc12_ = _loc11_ + _loc16_ * _loc14_ * 86400 + param3[0] * 86400;
         }
         return _loc12_;
      }
   }
}

