package Logics.Streamization.HDNewYearSheep
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.TPetLevelUp;
   import Logics.DatebaseVO.VO.TPetYearConfig;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYearSheep.PetYearVO.TPetYearChipGiftBoxVO;
   import Logics.HDNewYearSheep.PetYearVO.TPetYearTaskVO;
   import Logics.HDNewYearSheep.TPetYearData;
   import Logics.Inventories.TInventories;
   import Logics.Pet.TPetBase;
   import Logics.Pet.TVicePet;
   import Logics.SLogicsCore;
   import Logics.Streamization.Pet.TUnstreamizerPet;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_DATEBASEVO;
   
   public class TUnstreamizerPetYear extends TUnstreamizer
   {
      
      public function TUnstreamizerPetYear()
      {
         super();
      }
      
      protected function ProcessorConfig(param1:TPetYearData, param2:TPetYearConfig) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TPetYearChipGiftBoxVO = null;
         var _loc5_:TPetYearTaskVO = null;
         var _loc6_:TPetLevelUp = null;
         var _loc7_:TVicePet = null;
         var _loc8_:TUnstreamizerPet = null;
         param1.Config = param2;
         param1.LoginGiftBoxInventories = new TInventories();
         SToolReward.GetAwardsByAwardID(param2.FreeAward.award[param1.Day],param1.LoginGiftBoxInventories);
         _loc3_ = 0;
         while(_loc3_ < TPetYearData.BoxCount)
         {
            _loc4_ = new TPetYearChipGiftBoxVO();
            param1.ChipGiftBoxVOs[_loc3_] = _loc4_;
            _loc4_.Inventories = new TInventories();
            SToolReward.GetAwardsByAwardID(param2.ChipBox[_loc3_].award,_loc4_.Inventories);
            _loc4_.Cost = param2.ChipBox[_loc3_].cost;
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < TPetYearData.TaskCount)
         {
            _loc5_ = new TPetYearTaskVO();
            param1.TaskVOs[_loc3_] = _loc5_;
            _loc5_.Inventories = new TInventories();
            SToolReward.GetAwardsByAwardID(param2.Task[_loc3_].award,_loc5_.Inventories);
            _loc3_++;
         }
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_PetLevelUp,param2.VicePet.petListID) as TPetLevelUp;
         param1.VicePetVO.ResourceID = _loc6_.PetResourceID;
         param1.VicePetVO.Name = _loc6_.Name;
         _loc8_ = new TUnstreamizerPet();
         _loc3_ = 0;
         while(_loc3_ < TPetYearData.RankCount)
         {
            _loc7_ = new TVicePet(0,0);
            _loc7_.TemplateID = param2.VicePet.rank[_loc3_].templateID;
            _loc7_.Level = param2.VicePet.rank[_loc3_].level;
            _loc8_.UnstreamizeVicePet(null,_loc7_,null);
            param1.PetRankDatas[_loc3_] = _loc7_;
            _loc3_++;
         }
      }
      
      protected function Core(param1:int, param2:int, param3:Vector.<int>, param4:TPetYearData, param5:TPetYearConfig) : void
      {
         var _loc6_:TPetYearTaskVO = null;
         if(param1 == param5.FreeAward.index)
         {
            param4.LoginGiftBoxState = param2;
         }
         else if(param1 == param5.VicePet.index)
         {
            param4.VicePetVO.State = param2;
         }
         else if(param1 == param5.ChipBox[0].index || param1 == param5.ChipBox[1].index)
         {
            param4.ChipCount += param3[0];
         }
         else
         {
            _loc6_ = param4.TaskVOs[this.GetTaskIndexByKey(param1,param5)];
            _loc6_.Progress = param2;
         }
      }
      
      protected function GetTaskIndexByKey(param1:int, param2:TPetYearConfig) : int
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         _loc3_ = 0;
         while(_loc3_ < TPetYearData.TaskCount)
         {
            _loc4_ = param2.Task[_loc3_];
            if(_loc4_.index == param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      protected function ProcessorVicePet(param1:int, param2:int, param3:TPetYearData, param4:TPetYearConfig) : void
      {
         var _loc5_:TPetBase = null;
         if(param3.VicePetVO.State == CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
         {
            _loc5_ = SLogicsCore.PetData.OwnVicePets.GetPetByIdentifier(param1,param2);
            param3.VicePetVO.IsExist = _loc5_ != null;
            if(param3.VicePetVO.IsExist)
            {
               param3.VicePetVO.CurRank = _loc5_.GetRank();
               param3.VicePetVO.Level = TUtilityString.Format(param4.Language.levelFlag,_loc5_.Level);
               param3.VicePetVO.NextRankInfo = param3.VicePetVO.CurRank == param4.VicePet.rank.length - 1 ? param4.Language.rankInfoB : TUtilityString.Format(param4.Language.rankInfoA,param3.VicePetVO.CurRank + 1,(_loc5_ as TVicePet).ConditionAdvancePropQuantity);
            }
            else
            {
               param3.VicePetVO.Level = "";
               param3.VicePetVO.NextRankInfo = "";
            }
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:TPetYearData = null;
         var _loc8_:TPetYearConfig = null;
         _loc7_ = param2 as TPetYearData;
         _loc8_ = param3 as TPetYearConfig;
         _loc7_.Day = param1.ParameterVec[0];
         _loc7_.ChipCount = param1.ParameterVec[1];
         this.ProcessorConfig(_loc7_,_loc8_);
         _loc5_ = param1.AllBox.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.AllBox[_loc4_];
            this.Core(_loc6_.BoxIndex,_loc6_.State,_loc6_.Conditions,_loc7_,_loc8_);
            _loc4_++;
         }
         this.ProcessorVicePet(param1.ParameterVec[2],param1.ParameterVec[3],_loc7_,_loc8_);
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:TPetYearData = null;
         var _loc5_:TPetYearConfig = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         _loc4_ = param2 as TPetYearData;
         _loc5_ = param3 as TPetYearConfig;
         this.Core(param1.Index,param1.Status,param1.Condition,_loc4_,_loc5_);
         if(param1.Condition.length == 2)
         {
            this.ProcessorVicePet(param1.Condition[0],param1.Condition[1],_loc4_,_loc5_);
         }
      }
   }
}

