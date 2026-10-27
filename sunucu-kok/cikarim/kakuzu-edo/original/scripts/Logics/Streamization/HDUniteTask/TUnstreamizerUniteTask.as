package Logics.Streamization.HDUniteTask
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.TAward;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDUniteTaskConfig;
   import Logics.DatebaseVO.VO.TKnife;
   import Logics.DatebaseVO.VO.TKnifeExpand;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDUniteTask.TUniteTaskData;
   import Logics.HDUniteTask.VO.TUltimateRewardVO;
   import Logics.HDUniteTask.VO.TUniteTaskTaskVO;
   import Logics.Inventories.TInventories;
   import Logics.TypeCodeAmount.TTypeCodeAmount;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_DATEBASEVO;
   
   public class TUnstreamizerUniteTask extends TUnstreamizer
   {
      
      public function TUnstreamizerUniteTask()
      {
         super();
      }
      
      protected function GetLanguageConfigObj(param1:uint, param2:THDUniteTaskConfig) : Object
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc4_ = param2.Language.taskDesc;
         _loc6_ = _loc4_.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = _loc4_[_loc5_];
            if(_loc3_.type == param1)
            {
               return _loc3_;
            }
            _loc5_++;
         }
         return null;
      }
      
      protected function GetLinkConfigObj(param1:uint, param2:THDUniteTaskConfig) : Object
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc4_ = param2.Link;
         _loc6_ = _loc4_.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = _loc4_[_loc5_];
            if(_loc3_.type == param1)
            {
               return _loc3_;
            }
            _loc5_++;
         }
         return null;
      }
      
      protected function GetTaskConfigObj(param1:uint, param2:THDUniteTaskConfig) : Object
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc4_ = param2.Tasks;
         _loc6_ = _loc4_.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = _loc4_[_loc5_];
            if(_loc3_.index == param1)
            {
               return _loc3_;
            }
            _loc5_++;
         }
         return null;
      }
      
      protected function Core(param1:int, param2:int, param3:TUniteTaskData, param4:THDUniteTaskConfig) : void
      {
         if(this.ProcessorUltimateAward(param1,param2,param3,param4) || this.ProcessorLottery(param1,param2,param3,param4) || this.ProcessorTask(param1,param2,param3,param4))
         {
            return;
         }
         this.ProcessorEmploy(param1,param2,param3,param4);
      }
      
      protected function ProcessorConfig(param1:TUniteTaskData, param2:THDUniteTaskConfig) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TUniteTaskTaskVO = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:TBaseHero = null;
         var _loc11_:TKnifeExpand = null;
         var _loc12_:TKnife = null;
         var _loc13_:TAward = null;
         param1.Config = param2;
         _loc3_ = 0;
         while(_loc3_ < TUniteTaskData.TaskCount)
         {
            _loc4_ = new TUniteTaskTaskVO();
            param1.TaskVOs[_loc3_] = _loc4_;
            _loc5_ = param2.Tasks[_loc3_];
            _loc8_ = uint(_loc5_.condition[param1.Day].type);
            _loc6_ = this.GetLanguageConfigObj(_loc8_,param2);
            _loc7_ = this.GetLinkConfigObj(_loc8_,param2);
            _loc4_.DescName = _loc6_.name;
            _loc4_.DescProgKey = _loc6_.prog;
            _loc4_.DescAddReward = TUtilityString.Format(param2.Language.addReward,_loc5_.getExtractTimes);
            _loc4_.Link = _loc7_.link;
            _loc4_.Inventories = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc5_.award[param1.Day],_loc4_.Inventories);
            _loc3_++;
         }
         param1.LotteryInventories = new TInventories();
         SToolReward.GetAwardsByAwardID(param2.Extract.award[param1.Day],param1.LotteryInventories,true);
         _loc9_ = uint(param2.FinalAward.showID[param1.Day]);
         param1.UltimateRewardVO.Type = param2.FinalAward.showType[param1.Day];
         if(param1.UltimateRewardVO.Type == TUltimateRewardVO.RewardType_Hero)
         {
            _loc10_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,_loc9_) as TBaseHero;
            param1.UltimateRewardVO.MoudleID = _loc9_;
            param1.UltimateRewardVO.Name = _loc10_.Name;
            param1.UltimateRewardVO.Quality = _loc10_.Quality;
         }
         else if(param1.UltimateRewardVO.Type == TUltimateRewardVO.RewardType_Knife)
         {
            _loc11_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,_loc9_) as TKnifeExpand;
            _loc12_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Knife,_loc11_.RelationID) as TKnife;
            param1.UltimateRewardVO.MoudleID = _loc11_.RelationID;
            param1.UltimateRewardVO.Name = _loc12_.Name;
            param1.UltimateRewardVO.Quality = _loc11_.Quality;
            param1.UltimateRewardVO.KnifeID = _loc9_;
         }
         else
         {
            param1.UltimateRewardVO.Inventories = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc9_,param1.UltimateRewardVO.Inventories);
         }
      }
      
      protected function ProcessorUltimateAward(param1:int, param2:int, param3:TUniteTaskData, param4:THDUniteTaskConfig) : Boolean
      {
         if(param1 == param4.FinalAward.index)
         {
            param3.UltimateRewardVO.IsReceive = param2 == CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
            param3.UltimateRewardVO.ReceiveEnabled = !param3.UltimateRewardVO.IsReceive && param2 == TUniteTaskData.TaskCount;
            return true;
         }
         return false;
      }
      
      protected function ProcessorLottery(param1:int, param2:int, param3:TUniteTaskData, param4:THDUniteTaskConfig) : Boolean
      {
         if(param1 == param4.ExtractIndex)
         {
            param3.RemainLotteryCount = param2;
            return true;
         }
         return false;
      }
      
      protected function ProcessorTask(param1:int, param2:int, param3:TUniteTaskData, param4:THDUniteTaskConfig) : Boolean
      {
         var _loc5_:Object = null;
         var _loc6_:TUniteTaskTaskVO = null;
         var _loc7_:uint = 0;
         _loc5_ = this.GetTaskConfigObj(param1,param4);
         if(_loc5_ != null)
         {
            _loc7_ = uint(_loc5_.condition[param3.Day].value);
            _loc6_ = param3.TaskVOs[param4.Tasks.indexOf(_loc5_)];
            _loc6_.IsReceive = param2 == CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
            _loc6_.IsFinish = _loc6_.IsReceive || param2 == _loc7_;
            _loc6_.AwardBtnEnabled = !_loc6_.IsReceive && _loc6_.IsFinish;
            _loc6_.DescProgValue = (_loc6_.IsReceive ? _loc7_ : param2) + "/" + _loc7_;
            return true;
         }
         return false;
      }
      
      protected function ProcessorEmploy(param1:int, param2:int, param3:TUniteTaskData, param4:THDUniteTaskConfig) : Boolean
      {
         if(param1 == param4.Employ[0].index)
         {
            param3.LowEmploymentEnabled = param2 == 0;
            return true;
         }
         if(param1 == param4.Employ[1].index)
         {
            param3.SeniorEmploymentEnabled = param2 == 0;
            return true;
         }
         return false;
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:TUniteTaskData = null;
         var _loc8_:THDUniteTaskConfig = null;
         _loc7_ = param2 as TUniteTaskData;
         _loc8_ = param3 as THDUniteTaskConfig;
         _loc7_.Day = param1.ParameterVec[0];
         _loc7_.LotteryTarget = null;
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
         var _loc4_:TUniteTaskData = null;
         var _loc5_:THDUniteTaskConfig = null;
         _loc4_ = param2 as TUniteTaskData;
         _loc5_ = param3 as THDUniteTaskConfig;
         _loc4_.LotteryTarget = null;
         this.Core(param1.Index,param1.Status,_loc4_,_loc5_);
         if(param1.Index == _loc5_.Extract.index)
         {
            _loc4_.LotteryTarget = new TTypeCodeAmount();
            _loc4_.LotteryTarget.Type = param1.Condition[0];
            _loc4_.LotteryTarget.Code = param1.Condition[1];
            _loc4_.LotteryTarget.Amount = param1.Condition[2];
         }
      }
   }
}

