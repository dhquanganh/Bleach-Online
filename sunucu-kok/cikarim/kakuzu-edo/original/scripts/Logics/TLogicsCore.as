package Logics
{
   import Foundation.Container.*;
   import Logics.AntiAddiction.*;
   import Logics.Arena.*;
   import Logics.BleachAgent.TBleachAgentData;
   import Logics.Buffs.*;
   import Logics.Campaign.*;
   import Logics.Characters.*;
   import Logics.Characters.MainRoleWake.THeroWakeData;
   import Logics.CityDefend.*;
   import Logics.ExpDuplicate.TExpDuplicateData;
   import Logics.GongFuFight.TGongFuFightData;
   import Logics.HDActivityMode.TActivityModes;
   import Logics.HellButterfly.*;
   import Logics.HeroChange.THeroChangeData;
   import Logics.Home.*;
   import Logics.HyperStrings.*;
   import Logics.InteractionLog.*;
   import Logics.Inventories.*;
   import Logics.Items.*;
   import Logics.Log.TPoolLog;
   import Logics.Mail.*;
   import Logics.MainScene.*;
   import Logics.Map.TPoolMap;
   import Logics.Mentorship.*;
   import Logics.MiniBattle.TPoolMiniBattle;
   import Logics.MiniBattle.TPoolScript;
   import Logics.NightmareTrial.TNightmareTrialData;
   import Logics.Organization.*;
   import Logics.Organization.NewFeatures.TNewOrgData;
   import Logics.Pet.TPetData;
   import Logics.Pet.TPoolPet;
   import Logics.ProfessionRefine.TProfessionRefineList;
   import Logics.Purchases.TPoolPurchase;
   import Logics.Quests.*;
   import Logics.Rebirth.TRebirthData;
   import Logics.Signals.*;
   import Logics.Skills.*;
   import Logics.SkyTower.TSkyTower;
   import Logics.Smithy.*;
   import Logics.Spaces.*;
   import Logics.Streamization.Arena.*;
   import Logics.Streamization.Buffs.*;
   import Logics.Streamization.Campaign.*;
   import Logics.Streamization.Characters.*;
   import Logics.Streamization.CityDefend.*;
   import Logics.Streamization.HyperStrings.Common.*;
   import Logics.Streamization.InteractionLog.*;
   import Logics.Streamization.Inventories.*;
   import Logics.Streamization.Items.*;
   import Logics.Streamization.Mail.*;
   import Logics.Streamization.Pet.TUnstreamizerPetUnknown;
   import Logics.Streamization.Post.*;
   import Logics.Streamization.Quest.*;
   import Logics.Streamization.Skills.*;
   import Logics.Streamization.Tavern.*;
   import Logics.Streamization.TraitorAttack.TUnstreamizerTraitorAttack;
   import Logics.Streamization.TreasureMap.*;
   import Logics.Tavern.*;
   import Logics.TeamBattle.TTeamBattle;
   import Logics.TimeCoolDown.*;
   import Logics.TraitorAttack.TPoolTraitorAttack;
   import Logics.TreasureMap.*;
   import Logics.Unlocks.*;
   import Logics.VoidSoulWorld.TVoidSoulWorldData;
   import Processors.Game.Lobby.Common.Map.AutoSearhWay.TQuestAutoSearchWay;
   import Processors.Game.Lobby.FreshGuide.*;
   import Processors.Game.Lobby.MainSceneTwo.*;
   import Rendering.HyperStrings.*;
   import Resources.Constants.*;
   
   use namespace LogicsSpace;
   
   public class TLogicsCore
   {
      
      protected var FPoolSignal:TPoolSignal;
      
      protected var FCharacter:TCharacter;
      
      protected var FRoleDigests:TRoleDigests;
      
      protected var FFriends:TFriendDigests;
      
      protected var FMails:TMails;
      
      protected var FHellButterfly:THellButterfly;
      
      protected var FNodal:TNodal;
      
      protected var FUnlocks:TUnlocks;
      
      protected var FAntiAddiction:TAntiAddiction;
      
      protected var FCounterLimit:THashMap;
      
      protected var FOrganization:TBaseOrganization;
      
      protected var FMentorship:TMentorship;
      
      protected var FHome:THome;
      
      protected var FHomeFriend:THome;
      
      protected var FActivityModes:TActivityModes;
      
      protected var FTeamBattle:TTeamBattle;
      
      protected var FSkyTower:TSkyTower;
      
      protected var FQuestAutoSearchWay:TQuestAutoSearchWay;
      
      protected var FProcessorFreshGuide:TProcessorFreshGuide;
      
      protected var FScreenMapX:Number;
      
      protected var FScreenMapY:Number;
      
      protected var FAutoSearching:Boolean;
      
      protected var FAutoSearchQuest:TQuest;
      
      protected var FGongFuFightData:TGongFuFightData;
      
      protected var FHeroChangeData:THeroChangeData;
      
      protected var FNewOrgData:TNewOrgData;
      
      protected var FPetData:TPetData;
      
      protected var FNightmareTrialData:TNightmareTrialData;
      
      protected var FHeroWakeData:THeroWakeData;
      
      protected var FBleachAgentData:TBleachAgentData;
      
      protected var FExpDuplicateData:TExpDuplicateData;
      
      protected var FRebirthData:TRebirthData;
      
      protected var FVoidSoulWorldData:TVoidSoulWorldData;
      
      protected var FPoolCharacter:TPoolCharacter;
      
      protected var FPoolInventory:TPoolInventory;
      
      protected var FPoolQuest:TPoolQuest;
      
      protected var FPoolSkill:TPoolSkill;
      
      protected var FPoolArena:TPoolArena;
      
      protected var FPoolMail:TPoolMail;
      
      protected var FPoolTavern:TPoolTavern;
      
      protected var FPoolCampaign:TPoolCampaign;
      
      protected var FPoolItem:TPoolItem;
      
      protected var FPoolTreasureMap:TPoolTreasureMap;
      
      protected var FPoolCityDefend:TPoolCityDefend;
      
      protected var FPoolInteractionLog:TPoolInteractionLog;
      
      protected var FPoolHyperString:TPoolHyperString;
      
      protected var FPoolTraitorAttack:TPoolTraitorAttack;
      
      protected var FPoolLog:TPoolLog;
      
      protected var FPoolUIRoleCanMove:TPoolUIRoleCanMove;
      
      protected var FPoolUISingleEquipment:TPoolUISingleEquipment;
      
      protected var FPoolMap:TPoolMap;
      
      protected var FPoolMiniBattle:TPoolMiniBattle;
      
      protected var FPoolScript:TPoolScript;
      
      protected var FPoolPurchase:TPoolPurchase;
      
      protected var FPoolPet:TPoolPet;
      
      protected var FPlayPlotState:int;
      
      protected var FStatisticalStep:uint;
      
      protected var FTimeCoolDowns:TTimeCoolDowns;
      
      protected var FIsShowAllUser:Boolean;
      
      protected var FSignals:Vector.<TSignal>;
      
      protected var FMainServerID:uint;
      
      protected var FProfessionRefineList:TProfessionRefineList;
      
      public function TLogicsCore()
      {
         super();
         this.ConstructPools();
         this.StreamizationSetup();
         this.FCharacter = new TCharacter(0,0);
         this.FRoleDigests = new TRoleDigests();
         this.FFriends = new TFriendDigests();
         this.FMails = new TMails();
         this.FHellButterfly = new THellButterfly();
         this.FNodal = new TNodal();
         this.FUnlocks = new TUnlocks();
         this.FAntiAddiction = new TAntiAddiction();
         this.FCounterLimit = new THashMap();
         this.FOrganization = new TBaseOrganization();
         this.FMentorship = new TMentorship();
         this.FHome = new THome(0,0);
         this.FHomeFriend = new THome(0,0);
         this.FActivityModes = new TActivityModes();
         this.FTeamBattle = new TTeamBattle();
         this.FSkyTower = new TSkyTower();
         this.FQuestAutoSearchWay = new TQuestAutoSearchWay();
         this.FSignals = new Vector.<TSignal>();
         this.FTimeCoolDowns = new TTimeCoolDowns();
         this.FGongFuFightData = new TGongFuFightData();
         this.FHeroChangeData = new THeroChangeData();
         this.FNewOrgData = new TNewOrgData();
         this.FPetData = new TPetData();
         this.FNightmareTrialData = new TNightmareTrialData();
         this.FHeroWakeData = new THeroWakeData();
         this.FBleachAgentData = new TBleachAgentData();
         this.FExpDuplicateData = new TExpDuplicateData();
         this.FRebirthData = new TRebirthData();
         this.FVoidSoulWorldData = new TVoidSoulWorldData();
         this.FStatisticalStep = 1;
         this.FIsShowAllUser = true;
      }
      
      protected function ConstructPools() : void
      {
         this.FPoolSignal = new TPoolSignal();
         this.FPoolCharacter = new TPoolCharacter();
         this.FPoolInventory = new TPoolInventory();
         this.FPoolQuest = new TPoolQuest();
         this.FPoolSkill = new TPoolSkill();
         this.FPoolArena = new TPoolArena();
         this.FPoolMail = new TPoolMail();
         this.FPoolTavern = new TPoolTavern();
         this.FPoolCampaign = new TPoolCampaign();
         this.FPoolItem = new TPoolItem();
         this.FPoolTreasureMap = new TPoolTreasureMap();
         this.FPoolCityDefend = new TPoolCityDefend();
         this.FPoolInteractionLog = new TPoolInteractionLog();
         this.FPoolHyperString = new TPoolHyperString();
         this.FPoolTraitorAttack = new TPoolTraitorAttack();
         this.FPoolLog = new TPoolLog();
         this.FPoolUIRoleCanMove = new TPoolUIRoleCanMove();
         this.FPoolUISingleEquipment = new TPoolUISingleEquipment();
         this.FPoolMap = new TPoolMap();
         this.FPoolMiniBattle = new TPoolMiniBattle();
         this.FPoolScript = new TPoolScript();
         this.FPoolPurchase = new TPoolPurchase();
         this.FPoolPet = new TPoolPet();
      }
      
      protected function StreamizationSetup() : void
      {
         this.StreamizationSetup_Streamizers();
         this.StreamizationSetup_Unstreamizers();
      }
      
      protected function StreamizationSetup_Streamizers() : void
      {
         TStreamizerHyperStringUnknown.PoolsSetup(this.FPoolHyperString);
      }
      
      protected function StreamizationSetup_Unstreamizers() : void
      {
         TUnstreamizerHyperStringUnknown.PoolsSetup(this.FPoolHyperString);
         TUnstreamizerPost.PoolsSetup(this.FPoolHyperString);
         TUnstreamizerInteractionLogs.PoolsSetup(this.FPoolInteractionLog);
         TUnstreamizerCharacterUnknown.PoolsSetup(this.FPoolCharacter);
         TUnstreamizerSkillUnknown.PoolsSetup(this.FPoolSkill);
         TUnstreamizerInventoryUnknown.PoolsSetup(this.FPoolInventory);
         TUnstreamizerQuestUnknown.PoolsSetup(this.FPoolQuest);
         TUnstreamizerMailUnknown.PoolsSetup(this.FPoolMail);
         TUnstreamizerArena.PoolsSetup(this.FPoolArena);
         TUnstreamizerTavern.PoolsSetup(this.FPoolTavern);
         TUnstreamizerCampaignUnknown.PoolsSetup(this.FPoolCampaign);
         TUnstreamizerCampaignUnknown.PoolsSetupItem(this.FPoolItem);
         TUnstreamizerItemUnknown.PoolsSetup(this.FPoolItem);
         TUnstreamizerTreasureMap.PoolsSetup(this.FPoolTreasureMap);
         TUnstreamizerCityDefend.PoolsSetup(this.FPoolCityDefend);
         TUnstreamizerTraitorAttack.PoolsSetup(this.FPoolTraitorAttack);
         TUnstreamizerPetUnknown.PoolsSetup(this.FPoolPet);
      }
      
      protected function TimingUpdate() : void
      {
         this.TimingUpdateModuleTiming(this.FTimeCoolDowns);
         this.TimingUpdateCollection(this.FCharacter.TemporaryInventories);
      }
      
      protected function TimingUpdateModuleTiming(param1:TTimeCoolDowns) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TTimeCoolDown = null;
         _loc3_ = param1.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.GetTimeByIndex(_loc2_);
            if(_loc4_ != null)
            {
               _loc4_.TimingUpdate();
            }
            _loc2_++;
         }
      }
      
      protected function TimingUpdateCollection(param1:TInventories) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         _loc2_ = param1.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.GetInventoryByIndex(_loc3_);
            if(_loc4_ != null)
            {
               _loc4_.TimingUpdate();
            }
            _loc3_++;
         }
      }
      
      public function get SignalCount() : int
      {
         return this.FSignals.length;
      }
      
      public function get Character() : TCharacter
      {
         return this.FCharacter;
      }
      
      public function get RoleDigests() : TRoleDigests
      {
         return this.FRoleDigests;
      }
      
      public function get Friends() : TFriendDigests
      {
         return this.FFriends;
      }
      
      public function get Nodal() : TNodal
      {
         return this.FNodal;
      }
      
      public function get Mails() : TMails
      {
         return this.FMails;
      }
      
      public function get HellButterfly() : THellButterfly
      {
         return this.FHellButterfly;
      }
      
      public function get PoolCharacter() : TPoolCharacter
      {
         return this.FPoolCharacter;
      }
      
      public function get PoolMail() : TPoolMail
      {
         return this.FPoolMail;
      }
      
      public function get PoolInventory() : TPoolInventory
      {
         return this.FPoolInventory;
      }
      
      public function get PoolQuest() : TPoolQuest
      {
         return this.FPoolQuest;
      }
      
      public function get PoolSkill() : TPoolSkill
      {
         return this.FPoolSkill;
      }
      
      public function get PoolArena() : TPoolArena
      {
         return this.FPoolArena;
      }
      
      public function get PoolTavern() : TPoolTavern
      {
         return this.FPoolTavern;
      }
      
      public function get PoolCampaign() : TPoolCampaign
      {
         return this.FPoolCampaign;
      }
      
      public function get PoolItem() : TPoolItem
      {
         return this.FPoolItem;
      }
      
      public function get PoolTreasureMap() : TPoolTreasureMap
      {
         return this.FPoolTreasureMap;
      }
      
      public function get PoolCityDefend() : TPoolCityDefend
      {
         return this.FPoolCityDefend;
      }
      
      public function get PoolInteractionLog() : TPoolInteractionLog
      {
         return this.FPoolInteractionLog;
      }
      
      public function get PoolHyperString() : TPoolHyperString
      {
         return this.FPoolHyperString;
      }
      
      public function get PoolTraitorAttack() : TPoolTraitorAttack
      {
         return this.FPoolTraitorAttack;
      }
      
      public function get ScreenMapX() : Number
      {
         return this.FScreenMapX;
      }
      
      public function set ScreenMapX(param1:Number) : void
      {
         this.FScreenMapX = param1;
      }
      
      public function get ScreenMapY() : Number
      {
         return this.FScreenMapY;
      }
      
      public function set ScreenMapY(param1:Number) : void
      {
         this.FScreenMapY = param1;
      }
      
      public function get PoolUIRoleCanMove() : TPoolUIRoleCanMove
      {
         return this.FPoolUIRoleCanMove;
      }
      
      public function set ProcessorFreshGuide(param1:TProcessorFreshGuide) : void
      {
         this.FProcessorFreshGuide = param1;
      }
      
      public function get AutoSearching() : Boolean
      {
         return this.FAutoSearching;
      }
      
      public function set AutoSearching(param1:Boolean) : void
      {
         this.FAutoSearching = param1;
      }
      
      public function get AutoSearchQuest() : TQuest
      {
         return this.FAutoSearchQuest;
      }
      
      public function set AutoSearchQuest(param1:TQuest) : void
      {
         this.FAutoSearchQuest = param1;
      }
      
      public function get AntiAddiction() : TAntiAddiction
      {
         return this.FAntiAddiction;
      }
      
      public function get PlayPlotState() : int
      {
         return this.FPlayPlotState;
      }
      
      public function set PlayPlotState(param1:int) : void
      {
         this.FPlayPlotState = param1;
      }
      
      public function get Unlocks() : TUnlocks
      {
         return this.FUnlocks;
      }
      
      public function get PoolUISingleEquipment() : TPoolUISingleEquipment
      {
         return this.FPoolUISingleEquipment;
      }
      
      public function get CounterLimit() : THashMap
      {
         return this.FCounterLimit;
      }
      
      public function get Organization() : TBaseOrganization
      {
         return this.FOrganization;
      }
      
      public function set Organization(param1:TBaseOrganization) : void
      {
         this.FOrganization = param1;
      }
      
      public function get Mentorship() : TMentorship
      {
         return this.FMentorship;
      }
      
      public function get Home() : THome
      {
         return this.FHome;
      }
      
      public function get HomeFriend() : THome
      {
         return this.FHomeFriend;
      }
      
      public function get ActivityModes() : TActivityModes
      {
         return this.FActivityModes;
      }
      
      public function get TeamBattle() : TTeamBattle
      {
         return this.FTeamBattle;
      }
      
      public function get SkyTower() : TSkyTower
      {
         return this.FSkyTower;
      }
      
      public function get TimeCoolDowns() : TTimeCoolDowns
      {
         return this.FTimeCoolDowns;
      }
      
      public function get PoolMap() : TPoolMap
      {
         return this.FPoolMap;
      }
      
      public function get IsShowAllUser() : Boolean
      {
         return this.FIsShowAllUser;
      }
      
      public function set IsShowAllUser(param1:Boolean) : void
      {
         this.FIsShowAllUser = param1;
      }
      
      public function get QuestAutoSearchWay() : TQuestAutoSearchWay
      {
         return this.FQuestAutoSearchWay;
      }
      
      public function get PoolMiniBattle() : TPoolMiniBattle
      {
         return this.FPoolMiniBattle;
      }
      
      public function get PoolScript() : TPoolScript
      {
         return this.FPoolScript;
      }
      
      public function get GongFuFightData() : TGongFuFightData
      {
         return this.FGongFuFightData;
      }
      
      public function get PoolPurchase() : TPoolPurchase
      {
         return this.FPoolPurchase;
      }
      
      public function get PoolPet() : TPoolPet
      {
         return this.FPoolPet;
      }
      
      public function get PoolLog() : TPoolLog
      {
         return this.FPoolLog;
      }
      
      public function get HeroChangeData() : THeroChangeData
      {
         return this.FHeroChangeData;
      }
      
      public function get PetData() : TPetData
      {
         return this.FPetData;
      }
      
      public function get NewOrgData() : TNewOrgData
      {
         return this.FNewOrgData;
      }
      
      public function get NightmareTrialData() : TNightmareTrialData
      {
         return this.FNightmareTrialData;
      }
      
      public function get HeroWakeData() : THeroWakeData
      {
         return this.FHeroWakeData;
      }
      
      public function get BleachAgentData() : TBleachAgentData
      {
         return this.FBleachAgentData;
      }
      
      public function get ExpDuplicateData() : TExpDuplicateData
      {
         return this.FExpDuplicateData;
      }
      
      public function get RebirthData() : TRebirthData
      {
         return this.FRebirthData;
      }
      
      public function get VoidSoulWorldData() : TVoidSoulWorldData
      {
         return this.FVoidSoulWorldData;
      }
      
      public function get MainServerID() : uint
      {
         return this.FMainServerID;
      }
      
      public function set MainServerID(param1:uint) : void
      {
         this.FMainServerID = param1;
      }
      
      public function get ProfessionRefineList() : TProfessionRefineList
      {
         if(this.FProfessionRefineList == null)
         {
            this.FProfessionRefineList = new TProfessionRefineList();
         }
         return this.FProfessionRefineList;
      }
      
      public function Update() : void
      {
         this.FPoolSignal.Update();
         this.FPoolCharacter.Update();
         this.FPoolInventory.Update();
         this.FPoolQuest.Update();
         this.FPoolSkill.Update();
         this.FPoolArena.Update();
         this.FPoolTavern.Update();
         this.FPoolMail.Update();
         this.FPoolCampaign.Update();
         this.FPoolItem.Update();
         this.FPoolTreasureMap.Update();
         this.FPoolCityDefend.Update();
         this.FPoolInteractionLog.Update();
         this.FPoolHyperString.Update();
         this.FPoolTraitorAttack.Update();
         this.FPoolUIRoleCanMove.Update();
         this.FPoolUISingleEquipment.Update();
         this.FPoolPurchase.Update();
         this.FPoolPet.Update();
         this.FPoolLog.Update();
         this.TimingUpdate();
      }
      
      public function SinalPostFreshGuide(param1:Object) : void
      {
         this.FProcessorFreshGuide.EventNotify(param1);
      }
      
      public function SignalPost(param1:uint, param2:uint, param3:int = 0, param4:Object = null) : void
      {
         var _loc5_:TSignal = null;
         _loc5_ = this.FPoolSignal.Acquire(param1,param2,param3,param4);
         _loc5_.StubReferences.Reference(this);
         this.FSignals.push(_loc5_);
      }
      
      public function SignalRetrieve(param1:uint) : TSignal
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TSignal = null;
         _loc2_ = int(this.FSignals.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FSignals[_loc3_];
            if(_loc4_.Destination == param1)
            {
               this.FSignals.splice(_loc3_,1);
               _loc4_.StubReferences.Dereference(this);
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
   }
}

