package Logics.Streamization.HDDayBack
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.ActivityVO.THDShowAwardVO;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDDayBackConfig;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDDayBack.TDayBackData;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TUnstreamizerDayBack extends TUnstreamizer
   {
      
      public function TUnstreamizerDayBack()
      {
         super();
      }
      
      protected function ProcessorConfig(param1:TDayBackData, param2:THDDayBackConfig) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THDShowAwardVO = null;
         var _loc6_:Array = null;
         var _loc7_:Object = null;
         param1.LoginGiftVO.Inventories = new TInventories();
         SToolReward.GetAwardsByAwardID(param2.LoginGift.award[param1.Day],param1.LoginGiftVO.Inventories);
         param1.LoginGiftVO.CS_Index = param2.LoginGift.index;
         _loc6_ = param2.RechargeGift[param1.Day] as Array;
         _loc4_ = int(_loc6_.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = _loc6_[_loc3_];
            _loc5_ = new THDShowAwardVO();
            _loc5_.Condition[0] = _loc7_.condition;
            _loc5_.CS_Index = param2.RechargeReceiveIndex;
            _loc5_.CS_Bit = _loc3_;
            _loc5_.AwardType = _loc7_.showType;
            _loc5_.AwardID = _loc5_.ShowAwardID = _loc7_.showID;
            _loc5_.FightReportAddr = _loc7_.fightReportAddr;
            param1.RechGifts[_loc3_] = _loc5_;
            _loc3_++;
         }
         _loc7_ = param2.FinalGift.award[param1.Day];
         param1.FinalGift.Condition[0] = _loc7_.rechargeCondition;
         param1.FinalGift.CS_Index = param2.FinalGift.index;
         param1.FinalGift.AwardType = _loc7_.showType;
         param1.FinalGift.AwardID = param1.FinalGift.ShowAwardID = _loc7_.showID;
         param1.FinalGift.FightReportAddr = _loc7_.fightReportAddr;
         param1.Link = param2.Link;
      }
      
      protected function Core(param1:uint, param2:int, param3:TDayBackData, param4:THDDayBackConfig) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:THDShowAwardVO = null;
         switch(param1)
         {
            case param4.LoginGift.index:
               param3.LoginGiftVO.State = param2;
               break;
            case param4.RechargeIndex:
               param3.Prog = param2;
               if(param3.CurrentRechGiftsState != -1)
               {
                  this.Core(param4.RechargeReceiveIndex,param3.CurrentRechGiftsState,param3,param4);
               }
               break;
            case param4.FinalGift.index:
               param3.FinalGift.State = param2;
               break;
            case param4.RechargeReceiveIndex:
               _loc6_ = int(param3.RechGifts.length);
               _loc5_ = 0;
               while(_loc5_ < _loc6_)
               {
                  _loc7_ = param3.RechGifts[_loc5_];
                  if((1 << _loc5_ & param2) != 0)
                  {
                     _loc7_.State = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
                  }
                  else if(param3.Prog >= _loc7_.Condition[0])
                  {
                     _loc7_.State = CONST_ACTIVITY_MODE.Activity_CanReceive;
                  }
                  else
                  {
                     _loc7_.State = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
                  }
                  _loc5_++;
               }
               param3.CurrentRechGiftsState = param2;
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:TDayBackData = null;
         var _loc8_:THDDayBackConfig = null;
         _loc7_ = param2 as TDayBackData;
         _loc8_ = param3 as THDDayBackConfig;
         _loc7_.Day = param1.ParameterVec[0];
         this.ProcessorConfig(_loc7_,_loc8_);
         _loc5_ = param1.AllBox.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.AllBox[_loc4_];
            this.Core(_loc6_.BoxIndex,_loc6_.State,_loc7_,_loc8_);
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:TDayBackData = null;
         var _loc5_:THDDayBackConfig = null;
         _loc4_ = param2 as TDayBackData;
         _loc5_ = param3 as THDDayBackConfig;
         this.Core(param1.Index,param1.Status,_loc4_,_loc5_);
      }
   }
}

