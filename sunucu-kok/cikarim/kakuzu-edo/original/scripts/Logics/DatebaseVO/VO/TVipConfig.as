package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TVipConfig extends TDatebaseVO
   {
      
      protected var FChargeCount:int;
      
      protected var FDailyChicket:int;
      
      protected var FFreeLook:int;
      
      protected var FBlockTime:int;
      
      protected var FStonePecent:int;
      
      protected var FSkipBlock:int;
      
      protected var FBagCount:int;
      
      protected var FActionLimit:int;
      
      protected var FBuyActionLimit:int;
      
      protected var FDailySingleReset:int;
      
      protected var FDailyChaReset:int;
      
      protected var FSkipChargeFight:int;
      
      protected var FOneWine:int;
      
      protected var FOneWinWine:int;
      
      protected var FMoreChange:int;
      
      protected var FDailyChangeNum:int;
      
      protected var FArenaSkip:int;
      
      protected var FOneTimePet:int;
      
      protected var FOneWater:int;
      
      protected var FAutoBuyAct:int;
      
      protected var FBossFightUp:int;
      
      protected var FOneTimeWash:int;
      
      protected var FMonsterOneTime:int;
      
      protected var FStoneOneTime:int;
      
      protected var FDigging:int;
      
      protected var FNoClearTime:int;
      
      protected var FDayBuyCount:int;
      
      protected var FSevenHeroCount:int;
      
      protected var FSevenHeroOneKey:int;
      
      protected var FSkipSevenHeroFight:int;
      
      protected var FAutoJoinActivity:int;
      
      protected var FTeamerExpand:int;
      
      protected var FAKeyBableTower:int;
      
      protected var FResourcesBackvip:int;
      
      protected var FChangeHeroEnterBuy:int;
      
      protected var FChangeHeroReset:int;
      
      protected var FVainTravelBuy:int;
      
      protected var FVainTravelFree:int;
      
      protected var FVainTravelReliveTime:int;
      
      protected var FPetInteractionCount:int;
      
      protected var FPetTrainClearCD:int;
      
      protected var FCanAutoFight:int;
      
      protected var FRelatedDailyAward:int;
      
      protected var FLotteryRecruitNum:int;
      
      public function TVipConfig()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FChargeCount = param1.readUnsignedInt();
         this.FDailyChicket = param1.readUnsignedInt();
         this.FFreeLook = param1.readUnsignedInt();
         this.FBlockTime = param1.readUnsignedInt();
         this.FStonePecent = param1.readUnsignedInt();
         this.FSkipBlock = param1.readUnsignedInt();
         this.FBagCount = param1.readUnsignedInt();
         this.FActionLimit = param1.readUnsignedInt();
         this.FBuyActionLimit = param1.readUnsignedInt();
         this.FDailySingleReset = param1.readUnsignedInt();
         this.FDailyChaReset = param1.readUnsignedInt();
         this.FSkipChargeFight = param1.readUnsignedInt();
         this.FOneWine = param1.readUnsignedInt();
         this.FOneWinWine = param1.readUnsignedInt();
         this.FMoreChange = param1.readUnsignedInt();
         this.FDailyChangeNum = param1.readUnsignedInt();
         this.FArenaSkip = param1.readUnsignedInt();
         this.FOneTimePet = param1.readUnsignedInt();
         this.FOneWater = param1.readUnsignedInt();
         this.FAutoBuyAct = param1.readUnsignedInt();
         this.FBossFightUp = param1.readUnsignedInt();
         this.FOneTimeWash = param1.readUnsignedInt();
         this.FMonsterOneTime = param1.readUnsignedInt();
         this.FStoneOneTime = param1.readUnsignedInt();
         this.FDigging = param1.readUnsignedInt();
         this.FNoClearTime = param1.readUnsignedInt();
         this.FDayBuyCount = param1.readUnsignedInt();
         this.FSevenHeroCount = param1.readUnsignedInt();
         this.FSevenHeroOneKey = param1.readUnsignedInt();
         this.FSkipSevenHeroFight = param1.readUnsignedInt();
         this.FAutoJoinActivity = param1.readUnsignedInt();
         this.FTeamerExpand = param1.readUnsignedInt();
         this.FAKeyBableTower = param1.readUnsignedInt();
         this.FResourcesBackvip = param1.readUnsignedInt();
         this.FChangeHeroEnterBuy = param1.readUnsignedInt();
         this.FChangeHeroReset = param1.readUnsignedInt();
         this.FVainTravelBuy = param1.readInt();
         this.FVainTravelFree = param1.readInt();
         this.FVainTravelReliveTime = param1.readInt();
         this.FPetInteractionCount = param1.readUnsignedInt();
         this.FPetTrainClearCD = param1.readUnsignedInt();
         this.FCanAutoFight = param1.readInt();
         this.FRelatedDailyAward = param1.readUnsignedInt();
         this.FLotteryRecruitNum = param1.readUnsignedInt();
      }
      
      public function get ChargeCount() : int
      {
         return this.FChargeCount;
      }
      
      public function get DailyChicket() : int
      {
         return this.FDailyChicket;
      }
      
      public function get FreeLook() : int
      {
         return this.FFreeLook;
      }
      
      public function get BlockTime() : int
      {
         return this.FBlockTime;
      }
      
      public function get StonePecent() : int
      {
         return this.FStonePecent;
      }
      
      public function get SkipBlock() : int
      {
         return this.FSkipBlock;
      }
      
      public function get BagCount() : int
      {
         return this.FBagCount;
      }
      
      public function get ActionLimit() : int
      {
         return this.FActionLimit;
      }
      
      public function get BuyActionLimit() : int
      {
         return this.FBuyActionLimit;
      }
      
      public function get DailySingleReset() : int
      {
         return this.FDailySingleReset;
      }
      
      public function get DailyChaReset() : int
      {
         return this.FDailyChaReset;
      }
      
      public function get SkipChargeFight() : int
      {
         return this.FSkipChargeFight;
      }
      
      public function get OneWine() : int
      {
         return this.FOneWine;
      }
      
      public function get OneWinWine() : int
      {
         return this.FOneWinWine;
      }
      
      public function get MoreChange() : int
      {
         return this.FMoreChange;
      }
      
      public function get DailyChangeNum() : int
      {
         return this.FDailyChangeNum;
      }
      
      public function get ArenaSkip() : int
      {
         return this.FArenaSkip;
      }
      
      public function get OneTimePet() : int
      {
         return this.FOneTimePet;
      }
      
      public function get OneWater() : int
      {
         return this.FOneWater;
      }
      
      public function get AutoBuyAct() : int
      {
         return this.FAutoBuyAct;
      }
      
      public function get BossFightUp() : int
      {
         return this.FBossFightUp;
      }
      
      public function get OneTimeWash() : int
      {
         return this.FOneTimeWash;
      }
      
      public function get MonsterOneTime() : int
      {
         return this.FMonsterOneTime;
      }
      
      public function get StoneOneTime() : int
      {
         return this.FStoneOneTime;
      }
      
      public function get Digging() : int
      {
         return this.FDigging;
      }
      
      public function get NoClearTime() : int
      {
         return this.FNoClearTime;
      }
      
      public function get DayBuyCount() : int
      {
         return this.FDayBuyCount;
      }
      
      public function get AutoJoinActivity() : int
      {
         return this.FAutoJoinActivity;
      }
      
      public function get SevenHeroCount() : int
      {
         return this.FSevenHeroCount;
      }
      
      public function get SevenHeroOneKey() : int
      {
         return this.FSevenHeroOneKey;
      }
      
      public function get SkipSevenHeroFight() : int
      {
         return this.FSkipSevenHeroFight;
      }
      
      public function get TeamerExpand() : int
      {
         return this.FTeamerExpand;
      }
      
      public function get AKeyBableTower() : int
      {
         return this.FAKeyBableTower;
      }
      
      public function get ResourcesBackvip() : int
      {
         return this.FResourcesBackvip;
      }
      
      public function get ChangeHeroEnterBuy() : int
      {
         return this.FChangeHeroEnterBuy;
      }
      
      public function get ChangeHeroReset() : int
      {
         return this.FChangeHeroReset;
      }
      
      public function get PetInteractionCount() : int
      {
         return this.FPetInteractionCount;
      }
      
      public function get PetTrainClearCD() : int
      {
         return this.FPetTrainClearCD;
      }
      
      public function get VainTravelBuy() : int
      {
         return this.FVainTravelBuy;
      }
      
      public function get VainTravelFree() : int
      {
         return this.FVainTravelFree;
      }
      
      public function get VainTravelReliveTime() : int
      {
         return this.FVainTravelReliveTime;
      }
      
      public function get CanAutoFight() : int
      {
         return this.FCanAutoFight;
      }
      
      public function get RelatedDailyAward() : int
      {
         return this.FRelatedDailyAward;
      }
      
      public function get LotteryRecruitNum() : int
      {
         return this.FLotteryRecruitNum;
      }
   }
}

