package Logics.Vip
{
   import Foundation.DataProtected.TDataProtected;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TVip
   {
      
      protected static const PROPERTY_VIPLEVEL:String = "VIPLEVEL";
      
      protected var FDataProtected:TDataProtected;
      
      protected var FVipExp:uint;
      
      protected var FRequirementNextExp:uint;
      
      protected var FVipLevelUpperLimit:uint;
      
      protected var FChargeCount:int;
      
      protected var FDailyChicket:int;
      
      protected var FFreeLook:Boolean;
      
      protected var FBlockTime:Boolean;
      
      protected var FStonePecent:Boolean;
      
      protected var FSkipBlock:Boolean;
      
      protected var FBagCount:int;
      
      protected var FActionLimit:int;
      
      protected var FBuyActionLimit:int;
      
      protected var FDailySingleReset:int;
      
      protected var FDailyChaReset:int;
      
      protected var FSkipChargeFight:Boolean;
      
      protected var FOneWine:Boolean;
      
      protected var FOneWinWine:Boolean;
      
      protected var FMoreChange:Boolean;
      
      protected var FDailyChangeNum:int;
      
      protected var FArenaSkip:Boolean;
      
      protected var FOneTimePet:Boolean;
      
      protected var FOneWater:Boolean;
      
      protected var FAutoBuyAct:Boolean;
      
      protected var FBossFightUp:Boolean;
      
      protected var FOneTimeWash:Boolean;
      
      protected var FMonsterOneTime:Boolean;
      
      protected var FStoneOneTime:Boolean;
      
      protected var FDigging:Boolean;
      
      protected var FNoClearTime:Boolean;
      
      protected var FDayBuyCount:int;
      
      protected var FSevenHeroCount:int;
      
      protected var FSevenHeroOneKey:Boolean;
      
      protected var FSkipSevenHeroFight:Boolean;
      
      protected var FAutoJoinActivity:Boolean;
      
      protected var FTeamerExpand:Boolean;
      
      protected var FAKeyBableTower:Boolean;
      
      protected var FDailyWelfare:Boolean;
      
      protected var FChangeHeroEnterBuy:int;
      
      protected var FChangeHeroReset:int;
      
      protected var FPetInteractionCount:int;
      
      protected var FPetTrainClearCD:int;
      
      protected var FVainTravelBuy:int;
      
      protected var FVainTravelFree:int;
      
      protected var FVainTravelCanReliveTime:int;
      
      protected var FCanAutoFight:Boolean;
      
      protected var FVipOpenLevel_FreeLook:uint;
      
      protected var FVipOpenLevel_BlockTime:uint;
      
      protected var FVipOpenLevel_StonePecent:uint;
      
      protected var FVipOpenLevel_SkipBlock:uint;
      
      protected var FVipOpenLevel_DailySingleReset:uint;
      
      protected var FVipOpenLevel_DailyChaReset:uint;
      
      protected var FVipOpenLevel_SkipChargeFight:uint;
      
      protected var FVipOpenLevel_OneWine:uint;
      
      protected var FVipOpenLevel_OneWinWine:uint;
      
      protected var FVipOpenLevel_MoreChange:uint;
      
      protected var FVipOpenLevel_ArenaSkip:uint;
      
      protected var FVipOpenLevel_OneTimePet:uint;
      
      protected var FVipOpenLevel_OneWater:uint;
      
      protected var FVipOpenLevel_AutoBuyAct:uint;
      
      protected var FVipOpenLevel_BossFightUp:uint;
      
      protected var FVipOpenLevel_OneTimeWash:uint;
      
      protected var FVipOpenLevel_MonsterOneTime:uint;
      
      protected var FVipOpenLevel_StoneOneTime:uint;
      
      protected var FVipOpenLevel_Digging:uint;
      
      protected var FVipOpenLevel_SevenHeroOneKey:uint;
      
      protected var FVipOpenLevel_SkipSevenHeroFight:uint;
      
      protected var FVipOpenLevel_AutoJoinActivity:uint;
      
      protected var FVipOpenLevel_TeamerExpand:uint;
      
      protected var FVipOpenLevel_AKeyBableTower:uint;
      
      protected var FVipOpenLevel_DailyWelfare:uint;
      
      protected var FVipOpenLevel_HeroChangeReset:uint;
      
      protected var FVipOpenLevel_CanAutoFight:uint;
      
      public function TVip()
      {
         super();
         this.FDataProtected = new TDataProtected();
      }
      
      LogicsSpace function CoerceProperties(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int, param10:int, param11:int, param12:int, param13:int, param14:int, param15:int, param16:int, param17:int, param18:int, param19:int, param20:int, param21:int, param22:int, param23:int, param24:int, param25:int, param26:int, param27:int, param28:int, param29:int, param30:int, param31:int, param32:int, param33:int, param34:int, param35:int, param36:int, param37:int, param38:int, param39:int, param40:int, param41:int, param42:int) : void
      {
         this.FChargeCount = param1;
         this.FDailyChicket = param2;
         this.FFreeLook = Boolean(param3);
         this.FBlockTime = Boolean(param4);
         this.FStonePecent = Boolean(param5);
         this.FSkipBlock = Boolean(param6);
         this.FBagCount = param7;
         this.FActionLimit = param8;
         this.FBuyActionLimit = param9;
         this.FDailySingleReset = param10;
         this.FDailyChaReset = param11;
         this.FSkipChargeFight = Boolean(param12);
         this.FOneWine = Boolean(param13);
         this.FOneWinWine = Boolean(param14);
         this.FMoreChange = Boolean(param15);
         this.FDailyChangeNum = param16;
         this.FArenaSkip = Boolean(param17);
         this.FOneTimePet = Boolean(param18);
         this.FOneWater = Boolean(param19);
         this.FAutoBuyAct = Boolean(param20);
         this.FBossFightUp = Boolean(param21);
         this.FOneTimeWash = Boolean(param22);
         this.FMonsterOneTime = Boolean(param23);
         this.FStoneOneTime = Boolean(param24);
         this.FDigging = Boolean(param25);
         this.FNoClearTime = Boolean(param26);
         this.FDayBuyCount = param27;
         this.FSevenHeroCount = param28;
         this.FSevenHeroOneKey = Boolean(param29);
         this.FSkipSevenHeroFight = Boolean(param30);
         this.FAutoJoinActivity = Boolean(param31);
         this.FTeamerExpand = Boolean(param32);
         this.FAKeyBableTower = Boolean(param33);
         this.FDailyWelfare = Boolean(param34);
         this.FChangeHeroEnterBuy = param35;
         this.FChangeHeroReset = param36;
         this.FPetInteractionCount = param37;
         this.FPetTrainClearCD = param38;
         this.FVainTravelBuy = param39;
         this.FVainTravelFree = param40;
         this.FVainTravelCanReliveTime = param41;
         this.FCanAutoFight = Boolean(param42);
      }
      
      LogicsSpace function CoercePropertieVipLevel(param1:int) : void
      {
         this.FDataProtected.SetProperty(PROPERTY_VIPLEVEL,param1);
      }
      
      LogicsSpace function CoercePropertieVipExp(param1:int) : void
      {
         this.FVipExp = param1;
      }
      
      LogicsSpace function CoercePropertieVipNexpLevelExp(param1:int) : void
      {
         this.FRequirementNextExp = param1;
      }
      
      LogicsSpace function CoercePropertieVipLevelUpperLimit(param1:int) : void
      {
         this.FVipLevelUpperLimit = param1;
      }
      
      LogicsSpace function CoercePropertieBagCount(param1:int) : void
      {
         this.FBagCount = param1;
      }
      
      LogicsSpace function CoercePropertieActionLimit(param1:int) : void
      {
         this.FActionLimit = param1;
      }
      
      LogicsSpace function CoercePropertieVipOpenLevel(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint, param7:uint, param8:uint, param9:uint, param10:uint, param11:uint, param12:uint, param13:uint, param14:uint, param15:uint, param16:uint, param17:uint, param18:uint, param19:uint, param20:uint, param21:uint, param22:uint, param23:uint, param24:uint, param25:uint, param26:uint, param27:uint) : void
      {
         this.FVipOpenLevel_FreeLook = param1;
         this.FVipOpenLevel_BlockTime = param2;
         this.FVipOpenLevel_StonePecent = param3;
         this.FVipOpenLevel_SkipBlock = param4;
         this.FVipOpenLevel_DailySingleReset = param5;
         this.FVipOpenLevel_DailyChaReset = param6;
         this.FVipOpenLevel_SkipChargeFight = param7;
         this.FVipOpenLevel_OneWine = param8;
         this.FVipOpenLevel_OneWinWine = param9;
         this.FVipOpenLevel_MoreChange = param10;
         this.FVipOpenLevel_ArenaSkip = param11;
         this.FVipOpenLevel_OneTimePet = param12;
         this.FVipOpenLevel_OneWater = param13;
         this.FVipOpenLevel_AutoBuyAct = param14;
         this.FVipOpenLevel_BossFightUp = param15;
         this.FVipOpenLevel_OneTimeWash = param16;
         this.FVipOpenLevel_MonsterOneTime = param17;
         this.FVipOpenLevel_StoneOneTime = param18;
         this.FVipOpenLevel_Digging = param19;
         this.FVipOpenLevel_SevenHeroOneKey = param20;
         this.FVipOpenLevel_SkipSevenHeroFight = param21;
         this.FVipOpenLevel_AutoJoinActivity = param22;
         this.FVipOpenLevel_TeamerExpand = param23;
         this.FVipOpenLevel_AKeyBableTower = param24;
         this.FVipOpenLevel_DailyWelfare = param25;
         this.FVipOpenLevel_HeroChangeReset = param26;
         this.FVipOpenLevel_CanAutoFight = param27;
      }
      
      public function get VipLevel() : uint
      {
         return uint(this.FDataProtected.GetProperty(PROPERTY_VIPLEVEL));
      }
      
      public function get VipExp() : uint
      {
         return this.FVipExp;
      }
      
      public function get RequirementNextExp() : uint
      {
         return this.FRequirementNextExp;
      }
      
      public function get VipLevelUpperLimit() : uint
      {
         return this.FVipLevelUpperLimit;
      }
      
      public function get ChargeCount() : int
      {
         return this.FChargeCount;
      }
      
      public function get DailyChicket() : int
      {
         return this.FDailyChicket;
      }
      
      public function get FreeLook() : Boolean
      {
         return this.FFreeLook;
      }
      
      public function get BlockTime() : Boolean
      {
         return this.FBlockTime;
      }
      
      public function get StonePecent() : Boolean
      {
         return this.FStonePecent;
      }
      
      public function get SkipBlock() : Boolean
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
      
      public function get SkipChargeFight() : Boolean
      {
         return this.FSkipChargeFight;
      }
      
      public function get OneWine() : Boolean
      {
         return this.FOneWine;
      }
      
      public function get OneWinWine() : Boolean
      {
         return this.FOneWinWine;
      }
      
      public function get MoreChange() : Boolean
      {
         return this.FMoreChange;
      }
      
      public function get DailyChangeNum() : int
      {
         return this.FDailyChangeNum;
      }
      
      public function get ArenaSkip() : Boolean
      {
         return this.FArenaSkip;
      }
      
      public function get OneTimePet() : Boolean
      {
         return this.FOneTimePet;
      }
      
      public function get OneWater() : Boolean
      {
         return this.FOneWater;
      }
      
      public function get AutoBuyAct() : Boolean
      {
         return this.FAutoBuyAct;
      }
      
      public function get BossFightUp() : Boolean
      {
         return this.FBossFightUp;
      }
      
      public function get OneTimeWash() : Boolean
      {
         return this.FOneTimeWash;
      }
      
      public function get MonsterOneTime() : Boolean
      {
         return this.FMonsterOneTime;
      }
      
      public function get StoneOneTime() : Boolean
      {
         return this.FStoneOneTime;
      }
      
      public function get Digging() : Boolean
      {
         return this.FDigging;
      }
      
      public function get NoClearTime() : Boolean
      {
         return this.FNoClearTime;
      }
      
      public function get DayBuyCount() : int
      {
         return this.FDayBuyCount;
      }
      
      public function get SevenHeroCount() : int
      {
         return this.FSevenHeroCount;
      }
      
      public function get SevenHeroOneKey() : Boolean
      {
         return this.FSevenHeroOneKey;
      }
      
      public function get SkipSevenHeroFight() : Boolean
      {
         return this.FSkipSevenHeroFight;
      }
      
      public function get AutoJoinActivity() : Boolean
      {
         return this.FAutoJoinActivity;
      }
      
      public function get TeamerExpand() : Boolean
      {
         return this.FTeamerExpand;
      }
      
      public function get AKeyBableTower() : Boolean
      {
         return this.FAKeyBableTower;
      }
      
      public function get DailyWelfare() : Boolean
      {
         return this.FDailyWelfare;
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
      
      public function get VipOpenLevel_FreeLook() : int
      {
         return this.FVipOpenLevel_FreeLook;
      }
      
      public function get VipOpenLevel_BlockTime() : int
      {
         return this.FVipOpenLevel_BlockTime;
      }
      
      public function get VipOpenLevel_StonePecent() : int
      {
         return this.FVipOpenLevel_StonePecent;
      }
      
      public function get VipOpenLevel_SkipBlock() : int
      {
         return this.FVipOpenLevel_SkipBlock;
      }
      
      public function get VipOpenLevel_DailySingleReset() : int
      {
         return this.FVipOpenLevel_DailySingleReset;
      }
      
      public function get VipOpenLevel_DailyChaReset() : int
      {
         return this.FVipOpenLevel_DailyChaReset;
      }
      
      public function get VipOpenLevel_SkipChargeFight() : int
      {
         return this.FVipOpenLevel_SkipChargeFight;
      }
      
      public function get VipOpenLevel_OneWine() : int
      {
         return this.FVipOpenLevel_OneWine;
      }
      
      public function get VipOpenLevel_OneWinWine() : int
      {
         return this.FVipOpenLevel_OneWinWine;
      }
      
      public function get VipOpenLevel_MoreChange() : int
      {
         return this.FVipOpenLevel_MoreChange;
      }
      
      public function get VipOpenLevel_ArenaSkip() : int
      {
         return this.FVipOpenLevel_ArenaSkip;
      }
      
      public function get VipOpenLevel_OneTimePet() : int
      {
         return this.FVipOpenLevel_OneTimePet;
      }
      
      public function get VipOpenLevel_OneWater() : int
      {
         return this.FVipOpenLevel_OneWater;
      }
      
      public function get VipOpenLevel_AutoBuyAct() : int
      {
         return this.FVipOpenLevel_AutoBuyAct;
      }
      
      public function get VipOpenLevel_BossFightUp() : int
      {
         return this.FVipOpenLevel_BossFightUp;
      }
      
      public function get VipOpenLevel_OneTimeWash() : int
      {
         return this.FVipOpenLevel_OneTimeWash;
      }
      
      public function get VipOpenLevel_MonsterOneTime() : int
      {
         return this.FVipOpenLevel_MonsterOneTime;
      }
      
      public function get VipOpenLevel_StoneOneTime() : int
      {
         return this.FVipOpenLevel_StoneOneTime;
      }
      
      public function get VipOpenLevel_Digging() : int
      {
         return this.FVipOpenLevel_Digging;
      }
      
      public function get VipOpenLevel_SevenHeroOneKey() : int
      {
         return this.FVipOpenLevel_SevenHeroOneKey;
      }
      
      public function get VipOpenLevel_SkipSevenHeroFight() : int
      {
         return this.FVipOpenLevel_SkipSevenHeroFight;
      }
      
      public function get VipOpenLevel_AutoJoinActivity() : uint
      {
         return this.FVipOpenLevel_AutoJoinActivity;
      }
      
      public function get VipOpenLevel_TeamerExpand() : uint
      {
         return this.FVipOpenLevel_TeamerExpand;
      }
      
      public function get VipOpenLevel_AKeyBableTower() : uint
      {
         return this.FVipOpenLevel_AKeyBableTower;
      }
      
      public function get VipOpenLevel_DailyWelfare() : uint
      {
         return this.FVipOpenLevel_DailyWelfare;
      }
      
      public function get VipOpenLevel_HeroChangeReset() : uint
      {
         return this.FVipOpenLevel_HeroChangeReset;
      }
      
      public function get VainTravelBuy() : int
      {
         return this.FVainTravelBuy;
      }
      
      public function get VainTravelFree() : int
      {
         return this.FVainTravelFree;
      }
      
      public function get VainTravelCanReliveTime() : int
      {
         return this.FVainTravelCanReliveTime;
      }
      
      public function get VipOpenLevel_CanAutoFight() : uint
      {
         return this.FVipOpenLevel_CanAutoFight;
      }
      
      public function get CanAutoFight() : Boolean
      {
         return this.FCanAutoFight;
      }
      
      public function Reset() : void
      {
         this.FChargeCount = 0;
         this.FDailyChicket = 0;
         this.FFreeLook = false;
         this.FBlockTime = false;
         this.FStonePecent = false;
         this.FSkipBlock = false;
         this.FBagCount = 0;
         this.FActionLimit = 0;
         this.FBuyActionLimit = 0;
         this.FDailySingleReset = 0;
         this.FDailyChaReset = 0;
         this.FSkipChargeFight = false;
         this.FOneWine = false;
         this.FOneWinWine = false;
         this.FMoreChange = false;
         this.FDailyChangeNum = 0;
         this.FArenaSkip = false;
         this.FOneTimePet = false;
         this.FOneWater = false;
         this.FAutoBuyAct = false;
         this.FBossFightUp = false;
         this.FOneTimeWash = false;
         this.FMonsterOneTime = false;
         this.FStoneOneTime = false;
         this.FDigging = false;
         this.FNoClearTime = false;
         this.FDayBuyCount = 0;
         this.FSevenHeroCount = 0;
         this.FSevenHeroOneKey = false;
         this.FSkipSevenHeroFight = false;
         this.FAutoJoinActivity = false;
         this.FTeamerExpand = false;
         this.FAKeyBableTower = false;
         this.FDailyWelfare = false;
         this.FChangeHeroEnterBuy = 0;
      }
   }
}

