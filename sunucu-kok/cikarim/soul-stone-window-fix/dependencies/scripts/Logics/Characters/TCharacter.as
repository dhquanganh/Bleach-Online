package Logics.Characters
{
   import Debugging.*;
   import Foundation.Common.*;
   import Foundation.Common.Integer.*;
   import Foundation.Common.Spaces.*;
   import Foundation.Common.Stubs.*;
   import Logics.Achievenment.TAchievementInfor;
   import Logics.Achievenment.TAchievementInfors;
   import Logics.Achievenment.TTitles;
   import Logics.Buffs.TBuffs;
   import Logics.Dailytask.TDailytask;
   import Logics.GeneralStar.TEsotericPoints;
   import Logics.Inventories.*;
   import Logics.KnifeOfKillSoul.TKnifeOfkillSoulDatas;
   import Logics.KnifeSoul.TKnifeSoulData;
   import Logics.Quests.*;
   import Logics.Skills.*;
   import Logics.Spaces.*;
   import Logics.Vip.TVip;
   import Logics.YellowDiamon.TYellowDiamon;
   import Resources.Constants.*;
   import adobe.utils.*;
   
   use namespace LogicsSpace;
   
   public class TCharacter extends TEntity64
   {
      
      protected static const INDEX_MainHero:uint = 0;
      
      public static const CAPACITY_Backpack:uint = CONST_CHARACTER.CAPACITY_Backpack;
      
      public static const CAPACITY_BackpackTemporary:uint = CONST_CHARACTER.CAPACITY_BackpackTemporary;
      
      protected static const CAPACITY_Credits:int = CONST_CHARACTER.CAPACITY_Credits;
      
      protected static const CREDITINDEX_Gold:int = CONST_CHARACTER.CREDITINDEX_Gold;
      
      protected static const CREDITINDEX_SilverCoin:int = CONST_CHARACTER.CREDITINDEX_SilverCoin;
      
      protected static const CREDITINDEX_GiftCertificate:int = CONST_CHARACTER.CREDITINDEX_GiftCertificate;
      
      protected static const CREDITINDEX_MilitaryOrders:int = CONST_CHARACTER.CREDITINDEX_MilitaryOrders;
      
      protected static const CREDITINDEX_Integral:int = CONST_CHARACTER.CREDITINDEX_Integral;
      
      public static const CAPACITY_HeroSouls:int = CONST_CHARACTER.CAPACITY_HeroSouls;
      
      public static const HEROSOULINDEX_BlueSoul:int = CONST_CHARACTER.HEROSOULINDEX_BlueSoul;
      
      public static const HEROSOULINDEX_PurpleSoul:int = CONST_CHARACTER.HEROSOULINDEX_PurpleSoul;
      
      public static const HEROSOULINDEX_GoldSoul:int = CONST_CHARACTER.HEROSOULINDEX_GoldSoul;
      
      public static const HEROSOULINDEX_OrangeSoul:int = CONST_CHARACTER.HEROSOULINDEX_OrangeSoul;
      
      protected static const CAPACITY_KingSouls:uint = CONST_COMMON.CAPACITY_KingSouls;
      
      public static const KINGSOULINDEX_Common:int = CONST_COMMON.KINGSOULINDEX_Common;
      
      public static const KINGSOULINDEX_Thunder:int = CONST_COMMON.KINGSOULINDEX_Thunder;
      
      public static const KINGSOULINDEX_Dust:int = CONST_COMMON.KINGSOULINDEX_Dust;
      
      public static const KINGSOULINDEX_Water:int = CONST_COMMON.KINGSOULINDEX_Water;
      
      public static const KINGSOULINDEX_Wind:int = CONST_COMMON.KINGSOULINDEX_Wind;
      
      public static const KINGSOULINDEX_Fire:int = CONST_COMMON.KINGSOULINDEX_Fire;
      
      public static const KINGSOULINDEX_Forth:int = CONST_COMMON.KINGSOULINDEX_Forth;
      
      public static const KINGSOULINDEX_First:int = CONST_COMMON.KINGSOULINDEX_First;
      
      public static const TIME_COOLDOWN_StrengthenCD:int = CONST_COMMON.TIME_COOLDOWN_Strengthen;
      
      public static const TIME_COOLDOWN_AreanCD:int = CONST_COMMON.TIME_COOLDOWN_Arean;
      
      protected static const CAPACITY_INVENTORIES:uint = CONST_CHARACTER.CAPACITY_INVENTORIES;
      
      protected static const INVENTORIESINDEX_Appliances:uint = CONST_CHARACTER.INVENTORIESINDEX_Appliances;
      
      protected static const INVENTORIESINDEX_Equipments:uint = CONST_CHARACTER.INVENTORIESINDEX_Equipments;
      
      protected static const INVENTORIESINDEX_Ornament:uint = CONST_CHARACTER.INVENTORIESINDEX_Ornament;
      
      protected static const INVENTORIESINDEX_Materials:uint = CONST_CHARACTER.INVENTORIESINDEX_Materials;
      
      protected static const INVENTORIESINDEX_Gems:uint = CONST_CHARACTER.INVENTORIESINDEX_Gems;
      
      protected static const INVENTORIESINDEX_Treasures:uint = CONST_CHARACTER.INVENTORIESINDEX_Treasures;
      
      protected static const INVENTORIESINDEX_WakeEquip:uint = CONST_CHARACTER.INVENTORIESINDEX_WakeEquip;
      
      public static const INVENTORIESINDEX_Temporary:uint = CONST_CHARACTER.INVENTORIESINDEX_Temporary;
      
      protected var FStubReferences:TStubReferences;
      
      protected var FAgentOperatorId:uint;
      
      protected var FAgentUserId:String;
      
      protected var FServerId:uint;
      
      protected var FNickName:String;
      
      protected var FCountry:uint;
      
      protected var FPrestige:uint;
      
      protected var FMilitaryRank:uint;
      
      protected var FTownID:uint;
      
      protected var FStarMapIndex:uint;
      
      protected var FGeneralsSoul:uint;
      
      protected var FKnifeSoul:TKnifeSoulData;
      
      protected var FKnifeOfKillSoul:TKnifeOfkillSoulDatas;
      
      protected var FKnifeOfKillSoulShow:TKnifeOfkillSoulDatas;
      
      protected var FDailyTask:TDailytask;
      
      protected var FVipData:TVip;
      
      protected var FCredits:Vector.<Object>;
      
      protected var FHeroSouls:Vector.<uint>;
      
      protected var FKingSouls:Vector.<uint>;
      
      protected var FEsotericPoints:TEsotericPoints;
      
      protected var FMaxStarLevel:uint;
      
      protected var FMainQuestComplete:TQuests;
      
      protected var FSubQuestComplete:TQuests;
      
      protected var FMainQuestsAlreadyAccept:TQuests;
      
      protected var FSubQuestsAlreadyAccept:TQuests;
      
      protected var FMainQuestsCanAccept:TQuests;
      
      protected var FSubQuestsCanAccept:TQuests;
      
      protected var FMainQuestBase:TQuests;
      
      protected var FSubQuestBase:TQuests;
      
      protected var FFreshGuideProgress:String;
      
      protected var FBuffsGlobalOptional:TBuffs;
      
      protected var FHeros:THeros;
      
      protected var FSkills:TSkills;
      
      protected var FBackpackCapacity:uint;
      
      protected var FBackpackExpandCount:uint;
      
      protected var FBackpackTemporaryCapacity:uint;
      
      protected var FInventories:TInventories;
      
      protected var FAppliances:TInventories;
      
      protected var FEquipments:TInventories;
      
      protected var FOrnaments:TInventories;
      
      protected var FMaterials:TInventories;
      
      protected var FGems:TInventories;
      
      protected var FTreasures:TInventories;
      
      protected var FWakeEquip:TInventories;
      
      protected var FTemporaryInventories:TInventories;
      
      protected var FInventorySamples:TInventorySamples;
      
      protected var FCrashJade:TInventories;
      
      protected var FCrashJadeTemporary:TInventories;
      
      protected var FBackpack:Vector.<TInventories>;
      
      protected var FRoleSencePosition:int;
      
      protected var FIsAntiAddiction:Boolean;
      
      protected var FChatForbidden:Boolean;
      
      protected var FChatForbiddanceExpiration:uint;
      
      protected var FMilitaryBuyCount:uint;
      
      protected var FIfArriveLimitTime:Boolean;
      
      protected var FAchievementData:TAchievementInfors;
      
      protected var FCurrentFollowAchievement:TAchievementInfor;
      
      protected var FCurrentEquipTitles:TTitles;
      
      protected var FAchievementTitles:Vector.<TTitles>;
      
      protected var FGirlClothesID:uint;
      
      protected var FHeroAddSlotNum:int;
      
      protected var FInventoryWakes:TInventories;
      
      protected var FYellowDimondInfor:TYellowDiamon;
      
      public function TCharacter(param1:uint, param2:uint)
      {
         super(param1,param2);
         this.FStubReferences = new TStubReferences(this);
         this.FVipData = new TVip();
         this.FCredits = new Vector.<Object>(CAPACITY_Credits);
         this.FCredits[CREDITINDEX_Gold] = 0;
         this.FCredits[CREDITINDEX_SilverCoin] = new UInt64();
         this.FCredits[CREDITINDEX_GiftCertificate] = 0;
         this.FCredits[CREDITINDEX_MilitaryOrders] = 0;
         this.FCredits[CREDITINDEX_Integral] = 0;
         this.FHeroSouls = new Vector.<uint>(CAPACITY_HeroSouls);
         this.FKingSouls = new Vector.<uint>(CAPACITY_KingSouls);
         this.FEsotericPoints = new TEsotericPoints();
         this.FHeros = new THeros();
         this.FBackpackCapacity = CAPACITY_Backpack;
         this.FBackpackTemporaryCapacity = CAPACITY_BackpackTemporary;
         this.FInventories = new TInventories();
         this.FAppliances = new TInventories();
         this.FEquipments = new TInventories();
         this.FOrnaments = new TInventories();
         this.FMaterials = new TInventories();
         this.FGems = new TInventories();
         this.FTreasures = new TInventories();
         this.FWakeEquip = new TInventories();
         this.FTemporaryInventories = new TInventories();
         this.FInventorySamples = new TInventorySamples();
         this.FCrashJade = new TInventories();
         this.FCrashJadeTemporary = new TInventories();
         this.FBackpack = new Vector.<TInventories>(CAPACITY_INVENTORIES);
         this.FBackpack[INVENTORIESINDEX_Appliances] = this.FAppliances;
         this.FBackpack[INVENTORIESINDEX_Equipments] = this.FEquipments;
         this.FBackpack[INVENTORIESINDEX_Ornament] = this.FOrnaments;
         this.FBackpack[INVENTORIESINDEX_Materials] = this.FMaterials;
         this.FBackpack[INVENTORIESINDEX_Gems] = this.FGems;
         this.FBackpack[INVENTORIESINDEX_Treasures] = this.FTreasures;
         this.FBackpack[INVENTORIESINDEX_WakeEquip] = this.FWakeEquip;
         this.FBackpack[INVENTORIESINDEX_Temporary] = this.FTemporaryInventories;
         this.FMainQuestComplete = new TQuests();
         this.FSubQuestComplete = new TQuests();
         this.FMainQuestsAlreadyAccept = new TQuests();
         this.FSubQuestsAlreadyAccept = new TQuests();
         this.FMainQuestsCanAccept = new TQuests();
         this.FSubQuestsCanAccept = new TQuests();
         this.FMainQuestBase = new TQuests();
         this.FSubQuestBase = new TQuests();
         this.FKnifeSoul = new TKnifeSoulData();
         this.FKnifeOfKillSoul = new TKnifeOfkillSoulDatas();
         this.FKnifeOfKillSoulShow = new TKnifeOfkillSoulDatas();
         this.FDailyTask = new TDailytask();
         this.FSkills = new TSkills();
         this.FAchievementData = new TAchievementInfors();
         this.FCurrentEquipTitles = new TTitles();
         this.FAchievementTitles = new Vector.<TTitles>();
         this.FInventoryWakes = new TInventories();
         this.FYellowDimondInfor = new TYellowDiamon();
      }
      
      LogicsSpace function Coerce(param1:uint, param2:uint) : void
      {
         FIdentifier0 = param1;
         FIdentifier1 = param2;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get NickName() : String
      {
         return this.FNickName ? this.FNickName : "";
      }
      
      public function set NickName(param1:String) : void
      {
         this.FNickName = param1;
      }
      
      public function get Country() : uint
      {
         return this.FCountry;
      }
      
      public function set Country(param1:uint) : void
      {
         this.FCountry = param1;
      }
      
      public function get TownID() : uint
      {
         return this.FTownID;
      }
      
      public function set TownID(param1:uint) : void
      {
         this.FTownID = param1;
      }
      
      public function get StarMapIndex() : uint
      {
         return this.FStarMapIndex;
      }
      
      public function set StarMapIndex(param1:uint) : void
      {
         this.FStarMapIndex = param1;
      }
      
      public function get DailyTask() : TDailytask
      {
         return this.FDailyTask;
      }
      
      public function set DailyTask(param1:TDailytask) : void
      {
         this.FDailyTask = param1;
      }
      
      public function get VipData() : TVip
      {
         return this.FVipData;
      }
      
      public function get InventoryWakes() : TInventories
      {
         return this.FInventoryWakes;
      }
      
      public function GetFightingPower() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THero = null;
         var _loc4_:int = 0;
         if(this.FHeros == null)
         {
            return 0;
         }
         _loc2_ = this.FHeros.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FHeros.GetHeroByIndex(_loc1_);
            if(_loc3_.FightPosition > 0)
            {
               _loc4_ += _loc3_.BaseAttributeFightingPower;
            }
            _loc1_++;
         }
         return _loc4_;
      }
      
      public function get IsAntiAddiction() : Boolean
      {
         return this.FIsAntiAddiction;
      }
      
      public function set IsAntiAddiction(param1:Boolean) : void
      {
         this.FIsAntiAddiction = param1;
      }
      
      public function get ChatForbidden() : Boolean
      {
         return this.FChatForbidden;
      }
      
      public function set ChatForbidden(param1:Boolean) : void
      {
         this.FChatForbidden = param1;
      }
      
      public function GetCreditByIndex(param1:int) : Object
      {
         return this.FCredits[param1];
      }
      
      public function SetCreditByIndex(param1:int, param2:Object) : void
      {
         this.FCredits[param1] = param2;
      }
      
      public function get CreditGold() : uint
      {
         return this.FCredits[CREDITINDEX_Gold] as uint;
      }
      
      public function set CreditGold(param1:uint) : void
      {
         this.FCredits[CREDITINDEX_Gold] = param1;
      }
      
      public function get CreditSilverCoin() : UInt64
      {
         return this.FCredits[CREDITINDEX_SilverCoin] as UInt64;
      }
      
      public function CheckCreditSilverCoinEnough(param1:uint, param2:uint = 0) : Boolean
      {
         var _loc3_:Boolean = false;
         _loc3_ = false;
         if(this.CreditSilverCoin.High > param2)
         {
            _loc3_ = true;
         }
         else if(this.CreditSilverCoin.High == param2)
         {
            if(this.CreditSilverCoin.Low >= param1)
            {
               _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      public function get CreditGiftCertificate() : uint
      {
         return this.FCredits[CREDITINDEX_GiftCertificate] as uint;
      }
      
      public function set CreditGiftCertificate(param1:uint) : void
      {
         this.FCredits[CREDITINDEX_GiftCertificate] = param1;
      }
      
      public function get CreditMilitaryOrders() : uint
      {
         return this.FCredits[CREDITINDEX_MilitaryOrders] as uint;
      }
      
      public function set CreditMilitaryOrders(param1:uint) : void
      {
         this.FCredits[CREDITINDEX_MilitaryOrders] = param1;
      }
      
      public function get CreditIntegral() : uint
      {
         return this.FCredits[CREDITINDEX_Integral] as uint;
      }
      
      public function set CreditIntegral(param1:uint) : void
      {
         this.FCredits[CREDITINDEX_Integral] = param1;
      }
      
      public function GetHeroSoulByIndex(param1:int) : uint
      {
         return this.FHeroSouls[param1];
      }
      
      public function SetHeroSoulByIndex(param1:int, param2:uint) : void
      {
         this.FHeroSouls[param1] = param2;
      }
      
      public function get HeroSoulBlueSoul() : uint
      {
         return this.FHeroSouls[HEROSOULINDEX_BlueSoul] as uint;
      }
      
      public function set HeroSoulBlueSoul(param1:uint) : void
      {
         this.FHeroSouls[HEROSOULINDEX_BlueSoul] = param1;
      }
      
      public function get HeroSoulPurpleSoul() : uint
      {
         return this.FHeroSouls[HEROSOULINDEX_PurpleSoul] as uint;
      }
      
      public function set HeroSoulPurpleSoul(param1:uint) : void
      {
         this.FHeroSouls[HEROSOULINDEX_PurpleSoul] = param1;
      }
      
      public function get HeroSoulGoldSoul() : uint
      {
         return this.FHeroSouls[HEROSOULINDEX_GoldSoul] as uint;
      }
      
      public function set HeroSoulGoldSoul(param1:uint) : void
      {
         this.FHeroSouls[HEROSOULINDEX_GoldSoul] = param1;
      }
      
      public function get HeroSoulOrangeSoul() : uint
      {
         return this.FHeroSouls[HEROSOULINDEX_OrangeSoul] as uint;
      }
      
      public function set HeroSoulOrangeSoul(param1:uint) : void
      {
         this.FHeroSouls[HEROSOULINDEX_OrangeSoul] = param1;
      }
      
      public function get BuffsGlobalOptional() : TBuffs
      {
         return this.FBuffsGlobalOptional;
      }
      
      public function get Heros() : THeros
      {
         return this.FHeros;
      }
      
      public function get MainHero() : THero
      {
         return this.FHeros.GetHeroByIndex(INDEX_MainHero);
      }
      
      public function get BackpackCapacity() : uint
      {
         return this.FBackpackCapacity;
      }
      
      public function set BackpackCapacity(param1:uint) : void
      {
         this.FBackpackCapacity = param1;
      }
      
      public function get BackpackExpandCount() : uint
      {
         return this.FBackpackExpandCount;
      }
      
      public function set BackpackExpandCount(param1:uint) : void
      {
         this.FBackpackExpandCount = param1;
      }
      
      public function get BackpackTemporaryCapacity() : uint
      {
         return this.FBackpackTemporaryCapacity;
      }
      
      public function set BackpackTemporaryCapacity(param1:uint) : void
      {
         this.FBackpackTemporaryCapacity = param1;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function GetBackpackByIndex(param1:int) : TInventories
      {
         return this.FBackpack[param1];
      }
      
      public function get Appliances() : TInventories
      {
         return this.FBackpack[INVENTORIESINDEX_Appliances];
      }
      
      public function get Equipments() : TInventories
      {
         return this.FBackpack[INVENTORIESINDEX_Equipments];
      }
      
      public function get Ornaments() : TInventories
      {
         return this.FBackpack[INVENTORIESINDEX_Ornament];
      }
      
      public function get Gems() : TInventories
      {
         return this.FBackpack[INVENTORIESINDEX_Gems];
      }
      
      public function get Treasures() : TInventories
      {
         return this.FBackpack[INVENTORIESINDEX_Treasures];
      }
      
      public function get Materials() : TInventories
      {
         return this.FBackpack[INVENTORIESINDEX_Materials];
      }
      
      public function get WakeEquip() : TInventories
      {
         return this.FBackpack[INVENTORIESINDEX_WakeEquip];
      }
      
      public function get TemporaryInventories() : TInventories
      {
         return this.FBackpack[INVENTORIESINDEX_Temporary];
      }
      
      public function get AgentOperatorId() : uint
      {
         return this.FAgentOperatorId;
      }
      
      public function set AgentOperatorId(param1:uint) : void
      {
         this.FAgentOperatorId = param1;
      }
      
      public function get AgentUserId() : String
      {
         return this.FAgentUserId;
      }
      
      public function set AgentUserId(param1:String) : void
      {
         this.FAgentUserId = param1;
      }
      
      public function get ServerId() : uint
      {
         return this.FServerId;
      }
      
      public function set ServerId(param1:uint) : void
      {
         this.FServerId = param1;
      }
      
      public function GetKingSoulByIndex(param1:int) : uint
      {
         return this.FKingSouls[param1];
      }
      
      public function SetKingSoulByIndex(param1:int, param2:uint) : void
      {
         this.FKingSouls[param1] = param2;
      }
      
      public function get KingSoulCommon() : uint
      {
         return this.FKingSouls[KINGSOULINDEX_Common];
      }
      
      public function set KingSoulCommon(param1:uint) : void
      {
         this.FKingSouls[KINGSOULINDEX_Common] = param1;
      }
      
      public function get KingSoulThunder() : uint
      {
         return this.FKingSouls[KINGSOULINDEX_Thunder];
      }
      
      public function set KingSoulThunder(param1:uint) : void
      {
         this.FKingSouls[KINGSOULINDEX_Thunder] = param1;
      }
      
      public function get KingSoulDust() : uint
      {
         return this.FKingSouls[KINGSOULINDEX_Dust];
      }
      
      public function set KingSoulDust(param1:uint) : void
      {
         this.FKingSouls[KINGSOULINDEX_Dust] = param1;
      }
      
      public function get KingSoulWater() : uint
      {
         return this.FKingSouls[KINGSOULINDEX_Water];
      }
      
      public function set KingSoulWater(param1:uint) : void
      {
         this.FKingSouls[KINGSOULINDEX_Water] = param1;
      }
      
      public function get KingSoulWind() : uint
      {
         return this.FKingSouls[KINGSOULINDEX_Wind];
      }
      
      public function set KingSoulWind(param1:uint) : void
      {
         this.FKingSouls[KINGSOULINDEX_Wind] = param1;
      }
      
      public function get KingSoulFire() : uint
      {
         return this.FKingSouls[KINGSOULINDEX_Fire];
      }
      
      public function set KingSoulFire(param1:uint) : void
      {
         this.FKingSouls[KINGSOULINDEX_Fire] = param1;
      }
      
      public function get KingSoulForth() : uint
      {
         return this.FKingSouls[KINGSOULINDEX_Forth];
      }
      
      public function set KingSoulForth(param1:uint) : void
      {
         this.FKingSouls[KINGSOULINDEX_Forth] = param1;
      }
      
      public function get KingSoulFirst() : uint
      {
         return this.FKingSouls[KINGSOULINDEX_First];
      }
      
      public function set KingSoulFirst(param1:uint) : void
      {
         this.FKingSouls[KINGSOULINDEX_First] = param1;
      }
      
      public function get Prestige() : uint
      {
         return this.FPrestige;
      }
      
      public function set Prestige(param1:uint) : void
      {
         this.FPrestige = param1;
      }
      
      public function get MilitaryRank() : uint
      {
         return this.FMilitaryRank;
      }
      
      public function set MilitaryRank(param1:uint) : void
      {
         this.FMilitaryRank = param1;
      }
      
      public function get GeneralsSoul() : uint
      {
         return this.FGeneralsSoul;
      }
      
      public function set GeneralsSoul(param1:uint) : void
      {
         this.FGeneralsSoul = param1;
      }
      
      public function get VipLevel() : uint
      {
         return this.FVipData.VipLevel;
      }
      
      public function get ChatForbiddanceExpiration() : uint
      {
         return this.FChatForbiddanceExpiration;
      }
      
      public function set ChatForbiddanceExpiration(param1:uint) : void
      {
         this.FChatForbiddanceExpiration = param1;
      }
      
      public function get MaxStarLevel() : uint
      {
         return this.FMaxStarLevel;
      }
      
      public function set MaxStarLevel(param1:uint) : void
      {
         this.FMaxStarLevel = param1;
      }
      
      public function GetMainHero() : THero
      {
         return this.FHeros.GetHeroByIndex(0);
      }
      
      public function GetMainExperience() : UInt64
      {
         return this.FHeros.GetHeroByIndex(0).Experience;
      }
      
      public function GetMainLevel() : uint
      {
         return this.FHeros.GetHeroByIndex(0).Level;
      }
      
      public function GetMainRebirthLevel() : uint
      {
         return this.FHeros.GetHeroByIndex(0).RebirthLevel;
      }
      
      public function get Profession() : uint
      {
         return this.FHeros.GetHeroByIndex(0).Profession;
      }
      
      public function get MainQuestComplete() : TQuests
      {
         return this.FMainQuestComplete;
      }
      
      public function get SubQuestComplete() : TQuests
      {
         return this.FSubQuestComplete;
      }
      
      public function get MainQuestsAlreadyAccept() : TQuests
      {
         return this.FMainQuestsAlreadyAccept;
      }
      
      public function get SubQuestsAlreadyAccept() : TQuests
      {
         return this.FSubQuestsAlreadyAccept;
      }
      
      public function get MainQuestsCanAccept() : TQuests
      {
         return this.FMainQuestsCanAccept;
      }
      
      public function get SubQuestsCanAccept() : TQuests
      {
         return this.FSubQuestsCanAccept;
      }
      
      public function get RoleSencePosition() : int
      {
         return this.FRoleSencePosition;
      }
      
      public function set RoleSencePosition(param1:int) : void
      {
         this.FRoleSencePosition = param1;
      }
      
      public function get FreshGuideProgress() : String
      {
         return this.FFreshGuideProgress;
      }
      
      public function set FreshGuideProgress(param1:String) : void
      {
         this.FFreshGuideProgress = param1;
      }
      
      public function get MilitaryBuyCount() : uint
      {
         return this.FMilitaryBuyCount;
      }
      
      public function set MilitaryBuyCount(param1:uint) : void
      {
         this.FMilitaryBuyCount = param1;
      }
      
      public function get InventorySamples() : TInventorySamples
      {
         return this.FInventorySamples;
      }
      
      public function set InventorySamples(param1:TInventorySamples) : void
      {
         this.FInventorySamples = param1;
      }
      
      public function get EsotericPoints() : TEsotericPoints
      {
         return this.FEsotericPoints;
      }
      
      public function set EsotericPoints(param1:TEsotericPoints) : void
      {
         this.FEsotericPoints = param1;
      }
      
      public function get MainQuestBase() : TQuests
      {
         return this.FMainQuestBase;
      }
      
      public function get SubQuestBase() : TQuests
      {
         return this.FSubQuestBase;
      }
      
      public function get Skills() : TSkills
      {
         return this.FSkills;
      }
      
      public function set Skills(param1:TSkills) : void
      {
         this.FSkills = param1;
      }
      
      public function get KnifeSoul() : TKnifeSoulData
      {
         return this.FKnifeSoul;
      }
      
      public function set KnifeSoul(param1:TKnifeSoulData) : void
      {
         this.FKnifeSoul = param1;
      }
      
      public function get KnifeOfKillSoul() : TKnifeOfkillSoulDatas
      {
         return this.FKnifeOfKillSoul;
      }
      
      public function get YellowDimondInfor() : TYellowDiamon
      {
         return this.FYellowDimondInfor;
      }
      
      public function set YellowDimondInfor(param1:TYellowDiamon) : void
      {
         this.FYellowDimondInfor = param1;
      }
      
      public function get AchievementData() : TAchievementInfors
      {
         return this.FAchievementData;
      }
      
      public function get IfArriveLimitTime() : Boolean
      {
         return this.FIfArriveLimitTime;
      }
      
      public function set IfArriveLimitTime(param1:Boolean) : void
      {
         this.FIfArriveLimitTime = param1;
      }
      
      public function get CurrentFollowAchievement() : TAchievementInfor
      {
         return this.FCurrentFollowAchievement;
      }
      
      public function set CurrentFollowAchievement(param1:TAchievementInfor) : void
      {
         this.FCurrentFollowAchievement = param1;
      }
      
      public function get CurrentEquipTitles() : TTitles
      {
         return this.FCurrentEquipTitles;
      }
      
      public function set CurrentEquipTitles(param1:TTitles) : void
      {
         this.FCurrentEquipTitles = param1;
      }
      
      public function get GirlClothesID() : uint
      {
         return this.FGirlClothesID;
      }
      
      public function set GirlClothesID(param1:uint) : void
      {
         this.FGirlClothesID = param1;
      }
      
      public function get KnifeOfKillSoulShow() : TKnifeOfkillSoulDatas
      {
         return this.FKnifeOfKillSoulShow;
      }
      
      public function get HeroAddSlotNum() : int
      {
         return this.FHeroAddSlotNum;
      }
      
      public function set HeroAddSlotNum(param1:int) : void
      {
         this.FHeroAddSlotNum = param1;
      }
      
      public function get CrashJade() : TInventories
      {
         return this.FCrashJade;
      }
      
      public function get CrashJadeTemporary() : TInventories
      {
         return this.FCrashJadeTemporary;
      }
      
      public function get AchievementTitles() : Vector.<TTitles>
      {
         return this.FAchievementTitles;
      }
      
      public function get Backpack() : Vector.<TInventories>
      {
         return this.FBackpack;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         this.FAgentOperatorId = 0;
         this.FAgentUserId = "";
         this.FServerId = 0;
         this.FNickName = "";
         this.FCountry = 0;
         this.FTownID = 0;
         this.FStarMapIndex = 0;
         this.FGeneralsSoul = 0;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Credits)
         {
            this.FCredits[_loc1_] = 0;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_HeroSouls)
         {
            this.FHeroSouls[_loc1_] = 0;
            _loc1_++;
         }
         this.FPrestige = 0;
         this.FMilitaryRank = 0;
         this.FVipData.Reset();
         this.FMainQuestsAlreadyAccept.Clear();
         this.FSubQuestsAlreadyAccept.Clear();
         this.FMainQuestsCanAccept.Clear();
         this.FSubQuestsCanAccept.Clear();
         this.FBuffsGlobalOptional.Clear();
         this.FBackpackCapacity = CAPACITY_Backpack;
         this.FBackpackExpandCount = 0;
         this.FBackpackTemporaryCapacity = CAPACITY_BackpackTemporary;
         this.FInventories.Clear();
         this.FAppliances.Clear();
         this.FEquipments.Clear();
         this.FOrnaments.Clear();
         this.FGems.Clear();
         this.FTreasures.Clear();
         this.FMaterials.Clear();
         this.FWakeEquip.Clear();
         this.FTemporaryInventories.Clear();
         this.FInventorySamples.Clear();
         this.FChatForbidden = false;
         this.FChatForbiddanceExpiration = 0;
         this.FMilitaryBuyCount = 0;
      }
   }
}

