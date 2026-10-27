package Processors.Game.Lobby.Activity.HDActivityGiftBag.windows
{
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityGB.*;
   import Logics.HDActivityMode.*;
   import Logics.TimeCoolDown.*;
   import Processors.Game.Lobby.Activity.HDActivityGiftBag.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorWindowGBOrder extends TProcessorWindowGiftBase
   {
      
      protected static const Activity_OrderGiftBag:uint = CONST_ACTIVITY_MODE.Activity_OrderGiftBag;
      
      protected static const CONFIGS_ID_Vect:Vector.<uint> = CONST_ACTIVITY.CONFIGS_ID_Vect;
      
      protected static const CONFIGS_ResourceID_Vect:Vector.<uint> = CONST_ACTIVITY.CONFIGS_ResourceID_Vect;
      
      protected static const CardinalNumber_ActivityID:uint = 10000;
      
      protected var FOrderCoolingDown:TTimeCoolDown;
      
      protected var FIfCoolDown:Boolean;
      
      protected var FActivityGBOrder:TActivityGBOrder;
      
      protected var FHD_OrderReward:THD_OrderReward;
      
      public function TProcessorWindowGBOrder(param1:TUIComponent)
      {
         super(param1);
         this.FOrderCoolingDown = new TTimeCoolDown(CONST_COMMON.TIME_COOLDOWN_Activity_OrderGiftBag);
         SLogicsCore.TimeCoolDowns.Add(this.FOrderCoolingDown);
         this.FActivityGBOrder = new TActivityGBOrder();
         FActivityID = Activity_OrderGiftBag;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FOrderCoolingDown.TimingTime <= 0 && this.FIfCoolDown)
         {
            this.FIfCoolDown = false;
            this.CheckNotification();
         }
      }
      
      override protected function UpdateDataBase(param1:ByteArray) : void
      {
         super.UpdateDataBase(param1);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         FUnstreamizerActivityGB.UnstreamizeOrderGiftBag(this.FActivityGBOrder,FActivityInitRetData);
         this.InitConfig();
         this.CheckNotification();
      }
      
      override protected function UpdataStatus(param1:uint, param2:int, param3:Vector.<int>) : void
      {
         super.UpdataStatus(param1,param2,param3);
         this.FActivityGBOrder.Time = param2;
         this.CheckNotification();
      }
      
      protected function CheckNotification() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         _loc2_ = int(this.FHD_OrderReward.Condition.length);
         _loc2_ >>= 1;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FHD_OrderReward.Condition[(_loc1_ << 1) + 0] * CONST_COMMON.SecondPerHour;
            _loc4_ = this.FHD_OrderReward.Condition[(_loc1_ << 1) + 1] * CONST_COMMON.SecondPerHour;
            _loc5_ = this.CheckIfTimeHit(_loc3_,_loc4_);
            if(_loc5_)
            {
               break;
            }
            _loc1_++;
         }
         if(_loc5_ && !this.CheckIfRecived(_loc3_,_loc4_))
         {
            this.EffectNotification(true);
         }
         else
         {
            _loc3_ = int(this.GetNextCanReciveTime());
            this.FOrderCoolingDown.TimingTime = _loc3_;
            this.FIfCoolDown = true;
            this.EffectNotification(false);
         }
      }
      
      protected function CheckIfRecived(param1:uint, param2:uint) : Boolean
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Date = null;
         _loc4_ = this.FActivityGBOrder.Time - STimingCore.ServerTimeZone;
         _loc3_ = STimingCore.ServerTick - STimingCore.ServerTimeZone;
         _loc3_ -= _loc3_ % CONST_COMMON.SecondPerDay;
         param1 += _loc3_;
         param2 += _loc3_;
         return _loc4_ >= param1 && _loc4_ <= param2;
      }
      
      protected function InitConfig() : void
      {
         var _loc1_:TActivityAtoms = null;
         _loc1_ = FActivityModes.GetActivityAtomsByActivityID(FActivityID);
         super.GetConfig(_loc1_);
         this.FHD_OrderReward = FHDActivityConfig as THD_OrderReward;
      }
      
      protected function EffectNotification(param1:Boolean) : void
      {
         var _loc2_:TActivityAtoms = null;
         _loc2_ = FActivityModes.GetActivityAtomsByActivityID(FActivityID);
         if(param1)
         {
            _loc2_.Status = Activity_CanReceive;
            if(FCheckSecondEffectNotification != null)
            {
               FCheckSecondEffectNotification(_loc2_.Identifier,true);
            }
         }
         else
         {
            _loc2_.Status = Activity_CanNotReceive;
            if(FCheckSecondEffectNotification != null)
            {
               FCheckSecondEffectNotification(_loc2_.Identifier,false);
            }
         }
      }
      
      protected function GetNextCanReciveTime() : uint
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc2_ = int(this.FHD_OrderReward.Condition.length);
         _loc4_ = (STimingCore.ServerTick - STimingCore.ServerTimeZone) % CONST_COMMON.SecondPerDay;
         _loc2_ >>= 1;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FHD_OrderReward.Condition[_loc1_ << 1] * CONST_COMMON.SecondPerHour;
            if(_loc4_ < _loc3_)
            {
               return _loc3_ - _loc4_;
            }
            _loc1_++;
         }
         _loc5_ = CONST_COMMON.SecondPerDay - _loc4_ % CONST_COMMON.SecondPerDay;
         return uint(_loc5_ + this.FHD_OrderReward.Condition[0] * CONST_COMMON.SecondPerHour);
      }
      
      protected function CheckIfTimeHit(param1:uint, param2:uint) : Boolean
      {
         var _loc3_:uint = 0;
         _loc3_ = (STimingCore.ServerTick - STimingCore.ServerTimeZone) % CONST_COMMON.SecondPerDay;
         return _loc3_ >= param1 && _loc3_ <= param2;
      }
      
      override public function ActivityInitRet(param1:ByteArray, param2:TActivityAtoms) : void
      {
         super.ActivityInitRet(param1,param2);
         FActivityAtoms = param2;
         this.UpdateDataBase(param1);
      }
      
      override public function ChangeActivityStatus(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         super.ChangeActivityStatus(param1,param2);
         this.UpdataStatus(param2.Index,param2.Status,param2.Condition);
      }
   }
}

