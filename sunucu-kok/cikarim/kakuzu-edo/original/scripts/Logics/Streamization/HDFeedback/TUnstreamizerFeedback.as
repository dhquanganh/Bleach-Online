package Logics.Streamization.HDFeedback
{
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDFeedbackConfig;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDFeedback.TFeedbackData;
   import Logics.HDFeedback.VO.TFeedbackPageVO;
   import Logics.HDFeedback.VO.TFeedbackShowAwardVO;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TUnstreamizerFeedback extends TUnstreamizer
   {
      
      public function TUnstreamizerFeedback()
      {
         super();
      }
      
      protected function ProcessorConfig(param1:TFeedbackData, param2:THDFeedbackConfig) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TFeedbackShowAwardVO = null;
         var _loc6_:Object = null;
         if(param1.PageVO1.ShowAwardList.length > 0)
         {
            return;
         }
         _loc4_ = int(param2.SignInGift.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = param2.SignInGift[_loc3_];
            _loc5_ = new TFeedbackShowAwardVO();
            _loc5_.CS_Bit = _loc3_;
            _loc5_.CS_Index = param2.SignInReceiveIndex;
            _loc5_.Inventories = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc6_.awardID,_loc5_.Inventories);
            param1.PageVO1.ShowAwardList.push(_loc5_);
            _loc3_++;
         }
         _loc4_ = int(param2.RechargeGift.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = param2.RechargeGift[_loc3_];
            _loc5_ = new TFeedbackShowAwardVO();
            _loc5_.CS_Bit = _loc3_;
            _loc5_.CS_Index = param2.RechargeReceiveIndex;
            _loc5_.AwardID = _loc6_.showID;
            _loc5_.AwardType = _loc6_.showType;
            _loc5_.FightReportAddr = _loc6_.fightReportAddr;
            _loc5_.ShowAwardID = _loc6_.showID;
            _loc5_.Title1 = TUtilityString.Format(param2.Language.rechargeTitle,_loc6_.condition);
            param1.PageVO2.ShowAwardList.push(_loc5_);
            _loc3_++;
         }
         _loc4_ = int(param2.ConsumeGift.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = param2.ConsumeGift[_loc3_];
            _loc5_ = new TFeedbackShowAwardVO();
            _loc5_.CS_Bit = _loc3_;
            _loc5_.CS_Index = param2.ConsumeReceiveIndex;
            _loc5_.AwardID = _loc6_.showID;
            _loc5_.AwardType = _loc6_.showType;
            _loc5_.FightReportAddr = _loc6_.fightReportAddr;
            _loc5_.ShowAwardID = _loc6_.showID;
            _loc5_.Title1 = TUtilityString.Format(param2.Language.consumeTitle,_loc6_.condition);
            param1.PageVO3.ShowAwardList.push(_loc5_);
            _loc3_++;
         }
         _loc6_ = param2.FinalGift;
         _loc5_ = new TFeedbackShowAwardVO();
         _loc5_.CS_Bit = 0;
         _loc5_.CS_Index = param2.FinalReceiveIndex;
         _loc5_.AwardID = _loc6_.showID;
         _loc5_.AwardType = _loc6_.showType;
         _loc5_.FightReportAddr = _loc6_.fightReportAddr;
         _loc5_.ShowAwardID = _loc6_.showID;
         _loc5_.Title1 = String(_loc6_.rechargeCondition);
         _loc5_.Title2 = String(_loc6_.consumeCondition);
         param1.PageVO4.ShowAwardList.push(_loc5_);
         param1.PageVO1.LinkID = param2.Link.signInLink;
         param1.PageVO2.LinkID = param2.Link.rechargeLink;
         param1.PageVO3.LinkID = param2.Link.consumeLink;
         param1.PageVO2.ProgressDesc = param2.Language.rechargeDesc;
         param1.PageVO3.ProgressDesc = param2.Language.consumeDesc;
      }
      
      protected function Core(param1:uint, param2:int, param3:TFeedbackData, param4:THDFeedbackConfig) : void
      {
         var _loc5_:int = 0;
         var _loc6_:TFeedbackPageVO = null;
         var _loc7_:TFeedbackShowAwardVO = null;
         var _loc8_:int = 0;
         switch(param1)
         {
            case param4.SignInIndex:
               param3.PageVO1.Progress = param2.toString();
               break;
            case param4.RechargeIndex:
               param3.PageVO2.Progress = param2.toString();
               break;
            case param4.ConsumeIndex:
               param3.PageVO3.Progress = param2.toString();
               break;
            case param4.SignInReceiveIndex:
               _loc8_ = int(param3.PageVO1.ShowAwardList.length);
               _loc5_ = 0;
               while(_loc5_ < _loc8_)
               {
                  _loc7_ = param3.PageVO1.ShowAwardList[_loc5_];
                  if((1 << _loc5_ & param2) != 0)
                  {
                     _loc7_.GiftState = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
                  }
                  else if(param3.PageVO1.Progress >= param4.SignInGift[_loc5_].condition)
                  {
                     _loc7_.GiftState = CONST_ACTIVITY_MODE.Activity_CanReceive;
                  }
                  else
                  {
                     _loc7_.GiftState = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
                  }
                  _loc5_++;
               }
               break;
            case param4.RechargeReceiveIndex:
               _loc8_ = int(param3.PageVO2.ShowAwardList.length);
               _loc5_ = 0;
               while(_loc5_ < _loc8_)
               {
                  _loc7_ = param3.PageVO2.ShowAwardList[_loc5_];
                  if((1 << _loc5_ & param2) != 0)
                  {
                     _loc7_.GiftState = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
                  }
                  else if(param3.PageVO2.Progress >= param4.RechargeGift[_loc5_].condition)
                  {
                     _loc7_.GiftState = CONST_ACTIVITY_MODE.Activity_CanReceive;
                  }
                  else
                  {
                     _loc7_.GiftState = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
                  }
                  _loc5_++;
               }
               break;
            case param4.ConsumeReceiveIndex:
               _loc8_ = int(param3.PageVO3.ShowAwardList.length);
               _loc5_ = 0;
               while(_loc5_ < _loc8_)
               {
                  _loc7_ = param3.PageVO3.ShowAwardList[_loc5_];
                  if((1 << _loc5_ & param2) != 0)
                  {
                     _loc7_.GiftState = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
                  }
                  else if(param3.PageVO3.Progress >= param4.ConsumeGift[_loc5_].condition)
                  {
                     _loc7_.GiftState = CONST_ACTIVITY_MODE.Activity_CanReceive;
                  }
                  else
                  {
                     _loc7_.GiftState = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
                  }
                  _loc5_++;
               }
               break;
            case param4.FinalReceiveIndex:
               _loc8_ = int(param3.PageVO4.ShowAwardList.length);
               _loc5_ = 0;
               while(_loc5_ < _loc8_)
               {
                  _loc7_ = param3.PageVO4.ShowAwardList[_loc5_];
                  if((1 << _loc5_ & param2) != 0)
                  {
                     _loc7_.GiftState = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
                  }
                  else if(param3.PageVO2.Progress >= param4.FinalGift.rechargeCondition && param3.PageVO3.Progress >= param4.FinalGift.consumeCondition)
                  {
                     _loc7_.GiftState = CONST_ACTIVITY_MODE.Activity_CanReceive;
                  }
                  else
                  {
                     _loc7_.GiftState = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
                  }
                  _loc5_++;
               }
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:TFeedbackData = null;
         var _loc8_:THDFeedbackConfig = null;
         _loc7_ = param2 as TFeedbackData;
         _loc8_ = param3 as THDFeedbackConfig;
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
         var _loc4_:TFeedbackData = null;
         var _loc5_:THDFeedbackConfig = null;
         _loc4_ = param2 as TFeedbackData;
         _loc5_ = param3 as THDFeedbackConfig;
         this.Core(param1.Index,param1.Status,_loc4_,_loc5_);
      }
   }
}

