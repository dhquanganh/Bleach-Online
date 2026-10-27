package Logics.HDNewYearSheep
{
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TPetYearConfig;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYearSheep.PetYearVO.TPetYearChipGiftBoxVO;
   import Logics.HDNewYearSheep.PetYearVO.TPetYearTaskVO;
   import Logics.HDNewYearSheep.PetYearVO.TPetYearVicePetVO;
   import Logics.Inventories.TInventories;
   import Logics.Pet.TVicePet;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TPetYearData extends TActivityOSBase
   {
      
      public static const TaskCount:int = 3;
      
      public static const BoxCount:int = 2;
      
      public static const RankCount:int = 6;
      
      protected var FLoginGiftBoxState:int;
      
      protected var FLoginGiftBoxInventories:TInventories;
      
      protected var FChipCount:int;
      
      protected var FTaskVOs:Vector.<TPetYearTaskVO>;
      
      protected var FConfig:TPetYearConfig;
      
      protected var FDay:int;
      
      protected var FChipGiftBoxVOs:Vector.<TPetYearChipGiftBoxVO>;
      
      protected var FPetRankDatas:Vector.<TVicePet>;
      
      protected var FVicePetVO:TPetYearVicePetVO;
      
      public function TPetYearData()
      {
         super();
         this.FLoginGiftBoxState = CONST_ACTIVITY_MODE.Activity_CanReceive;
         this.FTaskVOs = new Vector.<TPetYearTaskVO>(TaskCount);
         this.FChipGiftBoxVOs = new Vector.<TPetYearChipGiftBoxVO>(BoxCount);
         this.FPetRankDatas = new Vector.<TVicePet>(RankCount);
         this.FVicePetVO = new TPetYearVicePetVO();
      }
      
      public function get LoginGiftBoxState() : int
      {
         return this.FLoginGiftBoxState;
      }
      
      public function set LoginGiftBoxState(param1:int) : void
      {
         this.FLoginGiftBoxState = param1;
      }
      
      public function get LoginGiftBoxInventories() : TInventories
      {
         return this.FLoginGiftBoxInventories;
      }
      
      public function set LoginGiftBoxInventories(param1:TInventories) : void
      {
         this.FLoginGiftBoxInventories = param1;
      }
      
      public function get ChipCount() : int
      {
         return this.FChipCount;
      }
      
      public function set ChipCount(param1:int) : void
      {
         this.FChipCount = param1;
      }
      
      public function get TaskVOs() : Vector.<TPetYearTaskVO>
      {
         return this.FTaskVOs;
      }
      
      public function set TaskVOs(param1:Vector.<TPetYearTaskVO>) : void
      {
         this.FTaskVOs = param1;
      }
      
      public function get Config() : TPetYearConfig
      {
         return this.FConfig;
      }
      
      public function set Config(param1:TPetYearConfig) : void
      {
         this.FConfig = param1;
      }
      
      public function get Day() : int
      {
         return this.FDay;
      }
      
      public function set Day(param1:int) : void
      {
         this.FDay = param1;
      }
      
      public function get ChipGiftBoxVOs() : Vector.<TPetYearChipGiftBoxVO>
      {
         return this.FChipGiftBoxVOs;
      }
      
      public function set ChipGiftBoxVOs(param1:Vector.<TPetYearChipGiftBoxVO>) : void
      {
         this.FChipGiftBoxVOs = param1;
      }
      
      public function get PetRankDatas() : Vector.<TVicePet>
      {
         return this.FPetRankDatas;
      }
      
      public function set PetRankDatas(param1:Vector.<TVicePet>) : void
      {
         this.FPetRankDatas = param1;
      }
      
      public function get VicePetVO() : TPetYearVicePetVO
      {
         return this.FVicePetVO;
      }
      
      public function set VicePetVO(param1:TPetYearVicePetVO) : void
      {
         this.FVicePetVO = param1;
      }
      
      public function GetRankInfo(param1:int) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TVicePet = null;
         if(this.VicePetVO.NextRankInfo == "")
         {
            return "";
         }
         if(this.VicePetVO.CurRank == this.Config.VicePet.rank.length - 1)
         {
            return this.FConfig.Language.rankInfoB;
         }
         _loc2_ = 0;
         if(param1 > this.VicePetVO.CurRank)
         {
            _loc3_ = this.VicePetVO.CurRank;
            while(_loc3_ < param1)
            {
               _loc4_ = this.FPetRankDatas[_loc3_];
               _loc2_ += _loc4_.ConditionAdvancePropQuantity;
               _loc3_++;
            }
         }
         return TUtilityString.Format(this.FConfig.Language.rankInfoA,param1,_loc2_);
      }
   }
}

