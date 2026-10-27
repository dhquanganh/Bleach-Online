package Processors.Game.Lobby.Account
{
   import Externals.SExternalCore;
   import Foundation.Common.Integer.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import LocalStorages.*;
   import Logics.*;
   import Logics.Affairs.*;
   import Logics.Agent.*;
   import Logics.Characters.*;
   import Logics.ChatOptions.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.GeneralStar.*;
   import Logics.Rebirth.TRebirthData;
   import Logics.Skills.*;
   import Logics.Spaces.LogicsSpace;
   import Logics.Streamization.BleachAgent.TUnstreamizerBleachAgent;
   import Logics.Streamization.Characters.*;
   import Logics.Streamization.GeneralStar.*;
   import Logics.Streamization.Inventories.TUnstreamizerInventoryHeroWake;
   import Logics.Streamization.Pet.TUnstreamizerPets;
   import Logics.Streamization.Skills.*;
   import Logics.TimeCoolDown.*;
   import Processors.Game.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   
   use namespace LogicsSpace;
   
   public class TProcessorAccount extends TProcessorGame
   {
      
      protected static const AFFAIRID_TimingWaitLoaded:uint = 1;
      
      protected static const AFFAIRID_TimingWaitFrontRequest:uint = 2;
      
      protected static const AFFAIRID_TimingWaitRearRequest:uint = 3;
      
      protected static const AFFAIRID_TimingCharBaseInfosUpdate:uint = 4;
      
      protected static const TIME_RequestData:int = 200;
      
      protected static const TIME_RequestPeriod:int = 500;
      
      protected static const BASESINFOINDEX_Character:Vector.<uint> = CONST_CHARACTER.BASESINFOINDEX_Character;
      
      protected static const BASEINFOINDEX_SilverCoin:uint = CONST_CHARACTER.BASEINFOINDEX_SilverCoin;
      
      protected static const BASEINFOINDEX_GiftCertificate:uint = CONST_CHARACTER.BASEINFOINDEX_GiftCertificate;
      
      protected static const BASEINFOINDEX_MilitaryOrders:uint = CONST_CHARACTER.BASEINFOINDEX_MilitaryOrders;
      
      protected static const BASEINFOINDEX_Gold:uint = CONST_CHARACTER.BASEINFOINDEX_Gold;
      
      protected static const BASEINFOINDEX_Soul:uint = CONST_CHARACTER.BASEINFOINDEX_Soul;
      
      protected static const BASEINFOINDEX_Prestige:uint = CONST_CHARACTER.BASEINFOINDEX_Prestige;
      
      protected static const BASEINFOINDEX_StrengthenCD:uint = CONST_CHARACTER.BASEINFOINDEX_StrengthenCD;
      
      protected static const BASEINFOINDEX_BlueSoul:uint = CONST_CHARACTER.BASEINFOINDEX_BlueSoul;
      
      protected static const BASEINFOINDEX_PurpleSoul:uint = CONST_CHARACTER.BASEINFOINDEX_PurpleSoul;
      
      protected static const BASEINFOINDEX_GoldSoul:uint = CONST_CHARACTER.BASEINFOINDEX_GoldSoul;
      
      protected static const BASEINFOINDEX_OrangeSoul:uint = CONST_CHARACTER.BASEINFOINDEX_OrangeSoul;
      
      protected static const BASEINFOINDEX_Experience:uint = CONST_CHARACTER.BASEINFOINDEX_Experience;
      
      protected static const BASEINFOINDEX_ExperienceTarget:uint = CONST_CHARACTER.BASEINFOINDEX_ExperienceTarget;
      
      protected static const BASEINFOINDEX_Integral:uint = CONST_CHARACTER.BASEINFOINDEX_Integral;
      
      protected static const BASEINFOINDEX_VipLevel:uint = CONST_CHARACTER.BASEINFOINDEX_VipLevel;
      
      protected static const BASEINFOINDEX_CharacterLevel:uint = CONST_CHARACTER.BASEINFOINDEX_CharacterLevel;
      
      protected static const BASEINFOINDEX_CharacterState:uint = CONST_CHARACTER.BASEINFOINDEX_CharacterState;
      
      protected static const BASEINFOINDEX_VipExp:uint = CONST_CHARACTER.BASEINFOINDEX_VipExp;
      
      protected static const BASEINFOINDEX_FamilyID:uint = CONST_CHARACTER.BASEINFOINDEX_FamilyID;
      
      protected static const SCENEPOSITION_MAINCITY:int = CONST_COMMON.SCENEPOSITION_MAINCITY;
      
      protected static const KEYS_COUNTER_PRIORITY_COPYCLASSROOM:Vector.<uint> = CONST_COUNTER.KEYS_COUNTER_PRIORITY_COPYCLASSROOM;
      
      protected static const KEY_COUNTER_MilitaryOrdersLimit:uint = CONST_COUNTER.KEY_COUNTER_MilitaryOrdersLimit;
      
      protected var FUnstreamizerCharacter:TUnstreamizerCharacter;
      
      protected var FUnstreamizerSkill:TUnstreamizerSkill;
      
      protected var FUnStreamizerGeneralStar:TUnstreamizerGeneralStar;
      
      protected var FUnstreamizerPets:TUnstreamizerPets;
      
      protected var FUnstreamizerInventoryHeroWake:TUnstreamizerInventoryHeroWake;
      
      protected var FUnstreamizerBleachAgent:TUnstreamizerBleachAgent;
      
      protected var FCharacterBaseInfos:Vector.<Function>;
      
      protected var FCharacterUpdateBaseInfo:Vector.<Function>;
      
      protected var FCharacter:TCharacter;
      
      protected var FEsotericPoints:TEsotericPoints;
      
      protected var FHerosID:Vector.<uint>;
      
      protected var FRequestFrontRoutines:Vector.<Function>;
      
      protected var FRequestRearRoutines:Vector.<Function>;
      
      protected var FTickRequest:int;
      
      protected var FRebirthData:TRebirthData;
      
      protected var FOnLoadFollowUp:Function;
      
      protected var FOnStartFreshGuide:Function;
      
      protected var FOnUserUpdateBaseInfo:Function;
      
      protected var FOnUpdateHeroPower:Function;
      
      protected var FOnUserUpdateStrengthenCD:Function;
      
      protected var FOnUserLevelUpEffect:Function;
      
      protected var FOnUserLevelUp:Function;
      
      protected var FOnUpdateHerosBaseAttributeRet:Function;
      
      protected var FOnUpdateVipInfo:Function;
      
      protected var FOnInitQuests:Function;
      
      protected var FOnInitMilitaryInfor:Function;
      
      protected var FOnUpdataSeverTime:Function;
      
      protected var FOnInitAllNpc:Function;
      
      protected var FOnInitMall:Function;
      
      protected var FOnCheckAntiAddiction:Function;
      
      protected var FOnUpdateAllHeroEquipmentMountedSuitCount:Function;
      
      protected var FOnEnabledCheckSpeedUp:Function;
      
      protected var FOnInitVip:Function;
      
      protected var FOnInitAddHeroSlotTime:Function;
      
      protected var FOnEnterFamily:Function;
      
      protected var FOnCloseSocketLoading:Function;
      
      protected var FOnDailyQusetInfoReq:Function;
      
      protected var FOnActivityInfoReq:Function;
      
      protected var FOnHeroQualityChange:Function;
      
      protected var FOnMilitaryInfoReq:Function;
      
      protected var FOnLoadAchievementInfor:Function;
      
      protected var FOnLoadBleachTrainInfor:Function;
      
      protected var FOnLoadDailyWelfareInfor:Function;
      
      protected var FOnInitHeroChangeInfor:Function;
      
      public function TProcessorAccount(param1:TUIComponent)
      {
         super(param1);
         this.FUnstreamizerCharacter = new TUnstreamizerCharacter();
         this.FUnstreamizerSkill = new TUnstreamizerSkill();
         this.FUnStreamizerGeneralStar = new TUnstreamizerGeneralStar();
         this.FUnstreamizerPets = new TUnstreamizerPets();
         this.FUnstreamizerInventoryHeroWake = new TUnstreamizerInventoryHeroWake();
         this.FUnstreamizerBleachAgent = new TUnstreamizerBleachAgent(SLogicsCore.BleachAgentData);
         this.ConstructCharBaseInfos();
         this.ConstructRequestRoutines();
         this.FCharacterUpdateBaseInfo = new Vector.<Function>();
         this.FHerosID = new Vector.<uint>();
         this.FCharacter = SLogicsCore.Character;
         this.FEsotericPoints = this.FCharacter.EsotericPoints;
         this.FRebirthData = SLogicsCore.RebirthData;
      }
      
      protected function ConstructCharBaseInfos() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(BASESINFOINDEX_Character.length);
         this.FCharacterBaseInfos = new Vector.<Function>(_loc2_);
         this.FCharacterBaseInfos[BASEINFOINDEX_SilverCoin] = this.ProcessorCharBaseInfoSilverCoin;
         this.FCharacterBaseInfos[BASEINFOINDEX_GiftCertificate] = this.ProcessorCharBaseInfoGiftCertificate;
         this.FCharacterBaseInfos[BASEINFOINDEX_MilitaryOrders] = this.ProcessorCharBaseInfoMilitaryOrders;
         this.FCharacterBaseInfos[BASEINFOINDEX_Gold] = this.ProcessorCharBaseInfoGold;
         this.FCharacterBaseInfos[BASEINFOINDEX_Soul] = this.ProcessorCharBaseInfoSoul;
         this.FCharacterBaseInfos[BASEINFOINDEX_Prestige] = this.ProcessorCharBaseInfoPrestige;
         this.FCharacterBaseInfos[BASEINFOINDEX_StrengthenCD] = this.ProcessorCharBaseInfoStrengthenCD;
         this.FCharacterBaseInfos[BASEINFOINDEX_BlueSoul] = this.ProcessorCharBaseInfoBlueSoul;
         this.FCharacterBaseInfos[BASEINFOINDEX_PurpleSoul] = this.ProcessorCharBaseInfoPurpleSoul;
         this.FCharacterBaseInfos[BASEINFOINDEX_GoldSoul] = this.ProcessorCharBaseInfoGoldSoul;
         this.FCharacterBaseInfos[BASEINFOINDEX_OrangeSoul] = this.ProcessorCharBaseInfoOrangeSoul;
         this.FCharacterBaseInfos[BASEINFOINDEX_Experience] = this.ProcessorCharBaseInfoExperience;
         this.FCharacterBaseInfos[BASEINFOINDEX_ExperienceTarget] = this.ProcessorCharBaseInfoExperienceTarget;
         this.FCharacterBaseInfos[BASEINFOINDEX_Integral] = this.ProcessorCharBaseInfoIntegral;
         this.FCharacterBaseInfos[BASEINFOINDEX_VipLevel] = this.ProcessorCharBaseInfoVipLevel;
         this.FCharacterBaseInfos[BASEINFOINDEX_CharacterLevel] = this.ProcessorCharBaseInfoCharacterLevel;
         this.FCharacterBaseInfos[BASEINFOINDEX_CharacterState] = this.ProcessorCharBaseInfoCharacterState;
         this.FCharacterBaseInfos[BASEINFOINDEX_VipExp] = this.ProcessorCharBaseInfoVipExp;
         this.FCharacterBaseInfos[BASEINFOINDEX_FamilyID] = this.ProcessorCharBaseInfoFamily;
      }
      
      protected function ConstructRequestRoutines() : void
      {
         this.FRequestFrontRoutines = new Vector.<Function>();
         this.FRequestFrontRoutines.push(this.ProcessorLoadFollowUp,this.LoadLocalStoragelCore,this.ProcessorUpdataSeverTime,this.CharacterVipInfoReq,this.InitAddHeroSlotTime,this.CharacterLoadMilitaryOrdersLimit,this.CharacterLoadMilitaryReq,this.ProcessorOnActiveInfoReq,this.ProcessorOnInitAllNpc,this.CharacterLoadGeneralStar,this.ProcessorOnRequestMilitaryInfor,this.ProcessorOnLoadAchievementData,this.ProcessorAchievementTitleReq,this.ProcessorPetInfoReq);
         this.FRequestRearRoutines = new Vector.<Function>();
         this.FRequestRearRoutines.push(this.ProcessorConstructHeroChangeInfor,this.PacketPerform_CS_GongFuFightSeasonReq,this.ProcessorOnEnterTown,this.CharacterInitQuests,this.CharacterLoadQuestReq,this.ProcessorCloseSocketLoading,this.InitTrainInfor,this.ProcessorOnUserUpdateBaseInfo,this.CharacterLoadDailytask,this.ProcessorOnUserUpdateStrengthenCD,this.CharacterGetOrganizationInfo,this.CharacterLoadKnifeSoul,this.ProcessorOnInitMallInfo,this.CharacterLoadSign,this.CharacterLoadFriend,this.ProcessorOnStartFreshGuide,this.CharacterLoadBackpack,this.ProcessorOnUpdateAllHeroEquipmentMountedSuitCount,this.ProcessorMailDataReq,this.ProcessorSkillsDataReq,this.CharacterLimitCopyHeroReq,this.ProcessorNijiaStarUpdateReq,this.ProcessorSlaveDataReq,this.ProcessorOnCheckAntiAddiction,this.ProcessorOnEnabledCheckSpeedUp,this.ProcessorOpenAnnouncementForcibly,this.InitDailyWelfareInfor,this.ProcessorLikeUsDataReq,this.FBInviteCheck,this.ProcessorCustomHeroInfoReq,this.ProcessorKingChallengeNpcReq);
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Account_CharInfoNtf,this.PacketPerform_SC_CharInfoNtf);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Account_CharUpgradeNtf,this.PacketPerform_SC_CharUpgradeNtf);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Account_CharBaseAttributeRet,this.PacketPerform_SC_CharBaseAttributeRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Account_CharBaseInfoUpdate,this.PacketPerform_SC_CharBaseInfoUpdate);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Account_MainHeroSkillInfoNtf,this.PacketPerform_SC_MainHeroSkillInfoNtf);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Account_CharForbiddenNtf,this.PacketPerform_SC_CharForbiddenNtf);
      }
      
      protected function PacketPerform_SC_CharInfoNtf(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:THero = null;
         _loc2_ = param1.Data;
         this.FUnstreamizerCharacter.UnstreamizeBasicProperties(_loc2_,this.FCharacter,null);
         this.FUnstreamizerCharacter.UnstreamizeHeros(_loc2_,this.FCharacter.Heros,null);
         _loc3_ = this.FCharacter.GetMainHero();
         this.FUnStreamizerGeneralStar.Unstreamize(null,this.FEsotericPoints,null);
         if(_loc3_ != null)
         {
            _loc3_.Name = this.FCharacter.NickName;
         }
         this.FUnstreamizerCharacter.UnstreamizeFreshGuide(_loc2_,null,null);
         this.FUnstreamizerCharacter.UnstreamizeKnifeSoul(_loc2_,this.FCharacter.KnifeSoul,null);
         this.FUnstreamizerInventoryHeroWake.InitRet(_loc2_,SLogicsCore.HeroWakeData);
         this.FUnstreamizerBleachAgent.CharInfoNtf(_loc2_);
         this.FTickRequest = STimingCore.TickCount;
         FAffairGenerator.Generate(AFFAIRID_TimingWaitLoaded);
      }
      
      protected function PacketPerform_SC_CharUpgradeNtf(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ByteArray = null;
         var _loc5_:uint = 0;
         var _loc6_:THero = null;
         var _loc7_:THeros = null;
         var _loc8_:TBaseHero = null;
         var _loc9_:int = 0;
         _loc4_ = param1.Data;
         _loc7_ = this.FCharacter.Heros;
         _loc3_ = int(_loc4_.readUnsignedShort());
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = _loc4_.readUnsignedInt();
            _loc6_ = _loc7_.GetHeroByIdentifier(_loc5_);
            _loc6_.RebirthLevel = _loc4_.readUnsignedInt();
            _loc6_.Experience.High = _loc4_.readUnsignedInt();
            _loc6_.Experience.Low = _loc4_.readUnsignedInt();
            this.ProcessorOnUserUpdateBaseInfo();
            this.ProcessorUpdateHeroPower(_loc5_);
            if(_loc6_.IsMain)
            {
               if(this.FCharacter.RoleSencePosition == SCENEPOSITION_MAINCITY)
               {
                  if(this.FOnUserLevelUpEffect != null)
                  {
                     this.FOnUserLevelUpEffect(this);
                  }
               }
               if(this.FOnUserLevelUp != null)
               {
                  this.FOnUserLevelUp(this);
               }
               SExternalCore.PushPlayerInfo(_loc6_.Name,_loc6_.Level);
               _loc9_ = SLogicsCore.Character.GetMainLevel() - 1;
               if(_loc9_ % 5 == 0)
               {
                  SExternalCore.GetRolePost();
               }
            }
            _loc2_++;
         }
         this.ProcessorOnActiveInfoReq();
      }
      
      protected function PacketPerform_SC_CharBaseAttributeRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ByteArray = null;
         var _loc5_:THero = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         _loc4_ = param1.Data;
         _loc6_ = _loc4_.readUnsignedInt();
         _loc5_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc6_);
         this.FUnstreamizerCharacter.UnstreamizeBaseAttributes(_loc4_,_loc5_,null);
         this.FUnstreamizerCharacter.UnstreamizePvPAttributes(_loc4_,_loc5_,null);
         this.FUnstreamizerCharacter.UnstreamizeGrowUpAttributes(_loc4_,_loc5_,null);
         this.ProcessorOnUpdateHerosBaseAttributeRet();
      }
      
      protected function PacketPerform_SC_CharBaseInfoUpdate(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:ByteArray = null;
         var _loc7_:Function = null;
         var _loc8_:Function = null;
         _loc6_ = param1.Data;
         _loc3_ = int(_loc6_.readUnsignedShort());
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = int(_loc6_.readUnsignedByte());
            _loc7_ = this.FCharacterBaseInfos[_loc4_];
            if(_loc7_ != null)
            {
               _loc7_(_loc6_);
            }
            switch(_loc4_)
            {
               case BASEINFOINDEX_SilverCoin:
               case BASEINFOINDEX_GiftCertificate:
               case BASEINFOINDEX_MilitaryOrders:
               case BASEINFOINDEX_Gold:
               case BASEINFOINDEX_Soul:
               case BASEINFOINDEX_Prestige:
               case BASEINFOINDEX_BlueSoul:
               case BASEINFOINDEX_PurpleSoul:
               case BASEINFOINDEX_GoldSoul:
               case BASEINFOINDEX_OrangeSoul:
               case BASEINFOINDEX_Experience:
               case BASEINFOINDEX_ExperienceTarget:
                  _loc8_ = this.ProcessorOnUserUpdateBaseInfo;
                  break;
               case BASEINFOINDEX_VipLevel:
               case BASEINFOINDEX_VipExp:
                  _loc8_ = this.ProcessorOnUpdateVipInfo;
                  break;
               case BASEINFOINDEX_FamilyID:
                  _loc8_ = this.ProcessorOnReflushFamily;
            }
            _loc5_ = this.FCharacterUpdateBaseInfo.indexOf(_loc8_);
            if(_loc5_ < 0)
            {
               this.FCharacterUpdateBaseInfo.push(_loc8_);
            }
            _loc2_++;
         }
         FAffairGenerator.Generate(AFFAIRID_TimingCharBaseInfosUpdate);
      }
      
      protected function PacketPerform_SC_MainHeroSkillInfoNtf(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ByteArray = null;
         var _loc5_:THero = null;
         var _loc6_:TSkill = null;
         var _loc7_:TSkills = null;
         var _loc8_:uint = 0;
         _loc4_ = param1.Data;
         _loc7_ = this.FCharacter.Skills;
         _loc3_ = int(_loc4_.readUnsignedShort());
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc8_ = _loc4_.readUnsignedInt();
            _loc6_ = _loc7_.GetSkillByIdentifier(_loc8_);
            if(!_loc6_.IsUnlock)
            {
               this.FUnstreamizerSkill.UnstreamizeGenerateSkill(null,_loc6_,null);
               _loc6_.IsUnlock = true;
            }
            _loc2_++;
         }
         _loc3_ = this.FCharacter.Skills.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = this.FCharacter.Skills.GetSkillByIndex(_loc2_);
            _loc6_.Mounted = false;
            if(_loc6_.Identifier == this.FCharacter.MainHero.Skill.Identifier)
            {
               _loc6_.Mounted = true;
            }
            _loc2_++;
         }
      }
      
      protected function PacketPerform_SC_CharForbiddenNtf(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:Boolean = false;
         var _loc4_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readBoolean();
         _loc4_ = _loc2_.readUnsignedInt();
         this.FCharacter.ChatForbidden = _loc3_;
         this.FCharacter.ChatForbiddanceExpiration = _loc4_;
      }
      
      protected function LoadLocalStoragelCore() : void
      {
         var _loc1_:Object = null;
         SLocalStoragelCore.StoragelPath = TLocalStoragelCore.LOCAL_STORAGEL_NAME + "." + SParametersCore.AgentID.toString() + "." + SParametersCore.ServerID.toString() + "." + SParametersCore.OperatorUserID;
         _loc1_ = SLocalStoragelCore.Fetch(SLocalStoragelCore.StoragelPath);
         SLogicsCore.AntiAddiction.LogicsSpace::Coerce(_loc1_);
      }
      
      protected function CharacterLoadBackpack() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Backpack_LoadBag);
         _loc2_ = _loc1_.Data;
         _loc2_.writeByte(CONST_BACKPACK.TYPE_LOADBACKPACK_NORMAL);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ProcessorMailDataReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Mail_InitDataReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function CharacterLoadGeneralStar() : void
      {
         var _loc1_:TStarPoint = null;
         var _loc2_:int = 0;
         var _loc3_:TStarMap = null;
         var _loc4_:TStarPoint = null;
         if(this.FCharacter.StarMapIndex != 0)
         {
            _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_StarPoint,this.FCharacter.StarMapIndex) as TStarPoint;
            _loc2_ = _loc1_.MapId;
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_StarMap,_loc2_ + 17200000) as TStarMap;
            this.FCharacter.MainHero.Quality = _loc3_.Quality;
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_StarPoint,this.FCharacter.StarMapIndex + 1) as TStarPoint;
            if(_loc4_ == null)
            {
               this.FCharacter.MainHero.Quality = _loc3_.Quality + 1;
            }
         }
         if(this.FOnHeroQualityChange != null)
         {
            this.FOnHeroQualityChange(this);
         }
      }
      
      protected function CharacterLoadFriend() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Friend_LoadFriend);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function CharacterInitQuests() : void
      {
         if(this.FOnInitQuests != null)
         {
            this.FOnInitQuests(this);
         }
      }
      
      protected function InitTrainInfor() : void
      {
         if(this.FOnLoadBleachTrainInfor != null)
         {
            this.FOnLoadBleachTrainInfor(this);
         }
      }
      
      protected function InitDailyWelfareInfor() : void
      {
         if(this.FOnLoadDailyWelfareInfor != null)
         {
            this.FOnLoadDailyWelfareInfor(this);
         }
      }
      
      protected function CharacterLoadQuestReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Task_QuestInforReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function CharacterGetOrganizationInfo() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_GetGulidInfoReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function CharacterLoadKnifeSoul() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KnifeInfoRequest);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KnifeOfKillSoulRequest);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ProcessorUpdataSeverTime() : void
      {
         if(this.FOnUpdataSeverTime != null)
         {
            this.FOnUpdataSeverTime(this);
         }
      }
      
      protected function CharacterLimitCopyHeroReq() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<uint> = null;
         _loc2_ = int(KEYS_COUNTER_PRIORITY_COPYCLASSROOM.length);
         _loc3_ = new Vector.<uint>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[_loc1_] = KEYS_COUNTER_PRIORITY_COPYCLASSROOM[_loc1_];
            SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_COUNTER_CopyClassRoom_Req,0,0,_loc3_);
            _loc1_++;
         }
      }
      
      protected function CharacterLoadDailytask() : void
      {
         if(this.FOnDailyQusetInfoReq != null)
         {
            this.FOnDailyQusetInfoReq(this);
         }
      }
      
      protected function ProcessorOnActiveInfoReq() : void
      {
         if(this.FOnActivityInfoReq != null)
         {
            this.FOnActivityInfoReq(this);
         }
      }
      
      protected function CharacterLoadMilitaryOrdersLimit() : void
      {
         var _loc1_:Vector.<uint> = null;
         _loc1_ = new Vector.<uint>(1);
         _loc1_[0] = KEY_COUNTER_MilitaryOrdersLimit;
         SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_COUNTER_MilitaryOrdersLimit_Req,0,0,_loc1_);
      }
      
      override protected function AffairRegisterRoutines() : void
      {
         super.AffairRegisterRoutines();
         FAffairRoutines.Register(AFFAIRID_TimingWaitLoaded,this.AffairPerform_TimingWaitLoaded);
         FAffairRoutines.Register(AFFAIRID_TimingWaitFrontRequest,this.AffairPerform_TimingWaitFrontRequest);
         FAffairRoutines.Register(AFFAIRID_TimingWaitRearRequest,this.AffairPerform_TimingWaitRearRequest);
         FAffairRoutines.Register(AFFAIRID_TimingCharBaseInfosUpdate,this.AffairPerform_TimingCharBaseInfosUpdate);
      }
      
      protected function AffairPerform_TimingWaitLoaded(param1:TAffair) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.PerformAffair_TimingWaitLoaded();
         if(_loc2_)
         {
            param1.PostProcess = TAffair.POSTPROCESS_Pend;
         }
         else
         {
            param1.PostProcess = TAffair.POSTPROCESS_Remove;
         }
      }
      
      protected function PerformAffair_TimingWaitLoaded() : Boolean
      {
         if(SResourcesCore.PrimaryCount == 0)
         {
            FAffairGenerator.Generate(AFFAIRID_TimingWaitFrontRequest);
            this.FTickRequest = STimingCore.TickCount;
            return false;
         }
         return true;
      }
      
      protected function AffairPerform_TimingWaitFrontRequest(param1:TAffair) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.PerformAffair_TimingWaitRequest(this.FRequestFrontRoutines,TIME_RequestData,TIME_RequestPeriod / 2);
         if(_loc2_)
         {
            param1.PostProcess = TAffair.POSTPROCESS_Pend;
         }
         else
         {
            this.FRequestFrontRoutines.length = 0;
            FAffairGenerator.Generate(AFFAIRID_TimingWaitRearRequest);
            this.FTickRequest = STimingCore.TickCount;
            param1.PostProcess = TAffair.POSTPROCESS_Remove;
         }
      }
      
      protected function AffairPerform_TimingWaitRearRequest(param1:TAffair) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.PerformAffair_TimingWaitRequest(this.FRequestRearRoutines,TIME_RequestData,TIME_RequestPeriod);
         if(_loc2_)
         {
            param1.PostProcess = TAffair.POSTPROCESS_Pend;
         }
         else
         {
            this.FRequestRearRoutines.length = 0;
            param1.PostProcess = TAffair.POSTPROCESS_Remove;
         }
      }
      
      protected function PerformAffair_TimingWaitRequest(param1:Vector.<Function>, param2:int, param3:int) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:Function = null;
         _loc4_ = int(STimingCore.TickCount);
         _loc4_ = _loc4_ - this.FTickRequest;
         if(_loc4_ > param2)
         {
            if(_loc4_ % param3 >= param3 / 2)
            {
               _loc5_ = param1.shift();
               if(_loc5_ != null)
               {
                  _loc5_();
               }
            }
            if(param1.length == 0)
            {
               param1 = null;
               return false;
            }
         }
         return true;
      }
      
      protected function AffairPerform_TimingCharBaseInfosUpdate(param1:TAffair) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.PerformAffair_TimingWaitCharBaseInfosUpdate();
         if(_loc2_)
         {
            param1.PostProcess = TAffair.POSTPROCESS_Pend;
         }
         else
         {
            param1.PostProcess = TAffair.POSTPROCESS_Remove;
         }
      }
      
      protected function PerformAffair_TimingWaitCharBaseInfosUpdate() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:Function = null;
         _loc1_ = int(this.FCharacterUpdateBaseInfo.length);
         if(_loc1_ > 0)
         {
            _loc2_ = this.FCharacterUpdateBaseInfo.shift();
            if(_loc2_ != null)
            {
               _loc2_();
            }
            return false;
         }
         return true;
      }
      
      protected function ProcessorCharBaseInfoSilverCoin(param1:ByteArray) : void
      {
         this.FCharacter.CreditSilverCoin.High = param1.readUnsignedInt();
         this.FCharacter.CreditSilverCoin.Low = param1.readUnsignedInt();
         param1.readUnsignedInt();
      }
      
      protected function ProcessorCharBaseInfoGiftCertificate(param1:ByteArray) : void
      {
         this.FCharacter.CreditGiftCertificate = param1.readUnsignedInt();
         param1.readUnsignedInt();
         param1.readUnsignedInt();
      }
      
      protected function ProcessorCharBaseInfoMilitaryOrders(param1:ByteArray) : void
      {
         this.FCharacter.CreditMilitaryOrders = param1.readUnsignedInt();
         param1.readUnsignedInt();
         param1.readUnsignedInt();
      }
      
      protected function ProcessorCharBaseInfoGold(param1:ByteArray) : void
      {
         this.FCharacter.CreditGold = param1.readUnsignedInt();
         param1.readUnsignedInt();
         param1.readUnsignedInt();
      }
      
      protected function ProcessorCharBaseInfoSoul(param1:ByteArray) : void
      {
         this.FCharacter.GeneralsSoul = param1.readUnsignedInt();
         param1.readUnsignedInt();
         param1.readUnsignedInt();
      }
      
      protected function ProcessorCharBaseInfoPrestige(param1:ByteArray) : void
      {
         this.FCharacter.Prestige = param1.readUnsignedInt();
         param1.readUnsignedInt();
         param1.readUnsignedInt();
      }
      
      protected function ProcessorCharBaseInfoStrengthenCD(param1:ByteArray) : void
      {
         var _loc2_:TTimeCoolDown = null;
         var _loc3_:int = 0;
         _loc2_ = SLogicsCore.TimeCoolDowns.GetTimeByIdentifier(CONST_COMMON.TIME_COOLDOWN_Strengthen);
         _loc3_ = param1.readUnsignedInt() - STimingCore.ServerTick;
         _loc2_.TimingTime = _loc3_ < 0 ? 0 : uint(_loc3_);
         SLogicsCore.Character.IfArriveLimitTime = param1.readUnsignedInt() == 1;
         param1.readUnsignedInt();
      }
      
      protected function ProcessorCharBaseInfoBlueSoul(param1:ByteArray) : void
      {
         this.FCharacter.HeroSoulBlueSoul = param1.readUnsignedInt();
         param1.readUnsignedInt();
         param1.readUnsignedInt();
      }
      
      protected function ProcessorCharBaseInfoPurpleSoul(param1:ByteArray) : void
      {
         this.FCharacter.HeroSoulPurpleSoul = param1.readUnsignedInt();
         param1.readUnsignedInt();
         param1.readUnsignedInt();
      }
      
      protected function ProcessorCharBaseInfoGoldSoul(param1:ByteArray) : void
      {
         this.FCharacter.HeroSoulGoldSoul = param1.readUnsignedInt();
         param1.readUnsignedInt();
         param1.readUnsignedInt();
      }
      
      protected function ProcessorCharBaseInfoOrangeSoul(param1:ByteArray) : void
      {
         this.FCharacter.HeroSoulOrangeSoul = param1.readUnsignedInt();
         param1.readUnsignedInt();
         param1.readUnsignedInt();
      }
      
      protected function ProcessorCharBaseInfoExperience(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TPacket = null;
         var _loc5_:THero = null;
         var _loc6_:THeros = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         _loc7_ = int(param1.readUnsignedInt());
         param1.readUnsignedInt();
         param1.readUnsignedInt();
         _loc6_ = this.FCharacter.Heros;
         _loc3_ = _loc6_.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = _loc6_.GetHeroByIndex(_loc2_);
            if(_loc5_.Mounted)
            {
               _loc8_ = int(_loc5_.Experience.High);
               _loc9_ = int(_loc5_.Experience.Low);
               _loc10_ = this.VerificationHeroLevel(_loc5_,_loc7_);
               if(_loc10_)
               {
                  this.FHerosID.push(_loc5_.Identifier);
                  _loc5_.Experience.High = _loc8_;
                  _loc5_.Experience.Low = _loc9_;
               }
            }
            _loc2_++;
         }
         _loc3_ = int(this.FHerosID.length);
         if(_loc3_ > 0)
         {
            _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Account_CharUpgradeReq);
            param1 = _loc4_.Data;
            param1.writeShort(_loc3_);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               param1.writeUnsignedInt(this.FHerosID[_loc2_]);
               _loc2_++;
            }
            SNetworkCore.Transceiver.PacketTransmit(_loc4_);
            this.FHerosID.length = 0;
         }
      }
      
      protected function VerificationHeroLevel(param1:THero, param2:int) : Boolean
      {
         var _loc3_:THeroExp = null;
         var _loc4_:UInt64 = null;
         var _loc5_:UInt64 = null;
         var _loc6_:Boolean = false;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HeroExp,param1.RebirthLevel) as THeroExp;
         _loc4_ = param1.Experience;
         _loc5_ = this.FRebirthData.CalNeedExpByUInt64(_loc3_.NeedExp,param1.RebirthNum);
         _loc4_.Add(param2);
         return _loc4_.EqualMax(_loc5_);
      }
      
      protected function ProcessorCharBaseInfoExperienceTarget(param1:ByteArray) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:THero = null;
         var _loc4_:uint = 0;
         var _loc5_:THeroExp = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:UInt64 = null;
         var _loc9_:Boolean = false;
         _loc6_ = int(param1.readUnsignedInt());
         _loc7_ = int(param1.readUnsignedInt());
         _loc4_ = param1.readUnsignedInt();
         _loc3_ = this.FCharacter.Heros.GetHeroByIdentifier(_loc4_);
         _loc3_.Experience.High = _loc6_;
         _loc3_.Experience.Low = _loc7_;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HeroExp,_loc3_.RebirthLevel) as THeroExp;
         _loc8_ = _loc3_.Experience;
         _loc9_ = _loc3_.Experience.EqualMax(_loc8_);
         if(_loc9_)
         {
            _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Account_CharUpgradeReq);
            param1 = _loc2_.Data;
            param1.writeShort(1);
            param1.writeUnsignedInt(_loc4_);
            SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         }
      }
      
      protected function ProcessorCharBaseInfoIntegral(param1:ByteArray) : void
      {
         this.FCharacter.CreditIntegral = param1.readUnsignedInt();
         param1.readUnsignedInt();
         param1.readUnsignedInt();
      }
      
      protected function ProcessorCharBaseInfoVipLevel(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1.readUnsignedInt());
         param1.readUnsignedInt();
         param1.readUnsignedInt();
         this.FCharacter.VipData.CoercePropertieVipLevel(_loc2_);
         this.ProcessorOnActiveInfoReq();
      }
      
      protected function ProcessorCharBaseInfoCharacterLevel(param1:ByteArray) : void
      {
         param1.readUnsignedInt();
         param1.readUnsignedInt();
         param1.readUnsignedInt();
      }
      
      protected function ProcessorCharBaseInfoCharacterState(param1:ByteArray) : void
      {
         param1.readUnsignedInt();
         param1.readUnsignedInt();
         param1.readUnsignedInt();
      }
      
      protected function ProcessorCharBaseInfoVipExp(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1.readUnsignedInt());
         param1.readUnsignedInt();
         param1.readUnsignedInt();
         this.FCharacter.VipData.CoercePropertieVipExp(_loc2_);
      }
      
      protected function ProcessorCharBaseInfoFamily(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1.readUnsignedInt());
         this.FCharacter.Country = _loc2_;
      }
      
      protected function ProcessorOnUpdateHerosBaseAttributeRet() : void
      {
         if(this.FOnUpdateHerosBaseAttributeRet != null)
         {
            this.FOnUpdateHerosBaseAttributeRet(this);
         }
      }
      
      protected function ProcessorOnUserUpdateBaseInfo() : void
      {
         if(this.FOnUserUpdateBaseInfo != null)
         {
            this.FOnUserUpdateBaseInfo(this);
         }
      }
      
      protected function ProcessorUpdateHeroPower(param1:uint) : void
      {
         if(this.FOnUpdateHeroPower != null)
         {
            this.FOnUpdateHeroPower(this,param1);
         }
      }
      
      protected function ProcessorOnUserUpdateStrengthenCD() : void
      {
         if(this.FOnUserUpdateStrengthenCD != null)
         {
            this.FOnUserUpdateStrengthenCD(this);
         }
      }
      
      protected function ProcessorOnReflushFamily() : void
      {
         if(this.FOnEnterFamily != null)
         {
            this.FOnEnterFamily(this);
         }
      }
      
      protected function ProcessorOnCheckAntiAddiction() : void
      {
         if(this.FOnCheckAntiAddiction != null)
         {
            this.FOnCheckAntiAddiction(this);
         }
      }
      
      protected function ProcessorOnInitAllNpc() : void
      {
         if(this.FOnInitAllNpc != null)
         {
            this.FOnInitAllNpc(this);
         }
      }
      
      protected function CharacterLoadMilitaryReq() : void
      {
         if(this.FOnInitMilitaryInfor != null)
         {
            this.FOnInitMilitaryInfor(this);
         }
      }
      
      protected function ProcessorOnStartFreshGuide() : void
      {
         if(this.FOnStartFreshGuide != null)
         {
            this.FOnStartFreshGuide(this);
         }
      }
      
      protected function ProcessorOnUpdateAllHeroEquipmentMountedSuitCount() : void
      {
         if(this.FOnUpdateAllHeroEquipmentMountedSuitCount != null)
         {
            this.FOnUpdateAllHeroEquipmentMountedSuitCount(this);
         }
      }
      
      protected function ProcessorOnEnabledCheckSpeedUp() : void
      {
         if(this.FOnEnabledCheckSpeedUp != null)
         {
            this.FOnEnabledCheckSpeedUp(this);
         }
      }
      
      protected function ProcessorOnRequestMilitaryInfor() : void
      {
         if(this.FOnMilitaryInfoReq != null)
         {
            this.FOnMilitaryInfoReq(this);
         }
      }
      
      protected function ProcessorOnLoadAchievementData() : void
      {
         if(this.FOnLoadAchievementInfor != null)
         {
            this.FOnLoadAchievementInfor(this);
         }
      }
      
      protected function ProcessorAchievementTitleReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_AchievenmentTitleInforReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ProcessorNijiaStarUpdateReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_NijiaStar_NijiaStarUpdateReq);
         _loc2_ = _loc1_.Data;
         _loc2_.writeUnsignedInt(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ProcessorSlaveDataReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Mentorship_LoadBaseDataReq);
         _loc2_ = _loc1_.Data;
         _loc2_.writeUnsignedInt(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function PacketPerform_CS_GongFuFightSeasonReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GongFuFight_TryIn);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GongFuFight_SeasonInforReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GongFuFight_BaseInforReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function CharacterLoadSign() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Sign_Load);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ProcessorSkillsDataReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GeneralStar_SkillListReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ProcessorOnInitMallInfo() : void
      {
         if(this.FOnInitMall != null)
         {
            this.FOnInitMall(this);
         }
      }
      
      protected function CharacterVipInfoReq() : void
      {
         if(this.FOnInitVip != null)
         {
            this.FOnInitVip(this);
         }
      }
      
      protected function InitAddHeroSlotTime() : void
      {
         if(this.FOnInitAddHeroSlotTime != null)
         {
            this.FOnInitAddHeroSlotTime(this);
         }
      }
      
      protected function ProcessorOnUpdateVipInfo() : void
      {
         if(this.FOnUpdateVipInfo != null)
         {
            this.FOnUpdateVipInfo(this);
         }
      }
      
      protected function ProcessorLoadFollowUp() : void
      {
         if(this.FOnLoadFollowUp != null)
         {
            this.FOnLoadFollowUp(this);
         }
      }
      
      protected function ProcessorOnEnterTown(param1:uint = 0) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_LOBBY_Enter_Town);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(this.FCharacter.TownID);
         _loc3_.writeUnsignedInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function ProcessorOpenAnnouncementForcibly() : void
      {
         if(this.FCharacter.GetMainLevel() >= 2)
         {
            SExternalCore.OpenAnnouncementForcibly();
         }
      }
      
      protected function ProcessorConstructHeroChangeInfor() : void
      {
         if(this.FOnInitHeroChangeInfor != null)
         {
            this.FOnInitHeroChangeInfor(this);
         }
      }
      
      protected function ProcessorCloseSocketLoading() : void
      {
         if(this.FOnCloseSocketLoading != null)
         {
            this.FOnCloseSocketLoading(this);
         }
      }
      
      protected function ProcessorLikeUsDataReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_LikeUs_DataReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ProcessorCustomHeroInfoReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CustomHero_InitInfoReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ProcessorKingChallengeNpcReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KingChallenge_NpcReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function FBInviteCheck() : void
      {
         if(false)
         {
            if(SLogicsCore.Character.GetMainLevel() >= 30)
            {
               SExternalCore.FBLevel30Notify();
            }
         }
      }
      
      protected function ProcessorPetInfoReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Pet_InitInfoReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function get OnLoadFollowUp() : Function
      {
         return this.FOnLoadFollowUp;
      }
      
      public function set OnLoadFollowUp(param1:Function) : void
      {
         this.FOnLoadFollowUp = param1;
      }
      
      public function get OnUserUpdateBaseInfo() : Function
      {
         return this.FOnUserUpdateBaseInfo;
      }
      
      public function set OnUserUpdateBaseInfo(param1:Function) : void
      {
         this.FOnUserUpdateBaseInfo = param1;
      }
      
      public function get OnUpdateHeroPower() : Function
      {
         return this.FOnUpdateHeroPower;
      }
      
      public function set OnUpdateHeroPower(param1:Function) : void
      {
         this.FOnUpdateHeroPower = param1;
      }
      
      public function get OnUserUpdateStrengthenCD() : Function
      {
         return this.FOnUserUpdateStrengthenCD;
      }
      
      public function set OnUserUpdateStrengthenCD(param1:Function) : void
      {
         this.FOnUserUpdateStrengthenCD = param1;
      }
      
      public function get OnUserLevelUp() : Function
      {
         return this.FOnUserLevelUp;
      }
      
      public function set OnUserLevelUp(param1:Function) : void
      {
         this.FOnUserLevelUp = param1;
      }
      
      public function get OnUserLevelUpEffect() : Function
      {
         return this.FOnUserLevelUpEffect;
      }
      
      public function set OnUserLevelUpEffect(param1:Function) : void
      {
         this.FOnUserLevelUpEffect = param1;
      }
      
      public function get OnCharacterBaseAttributeRet() : Function
      {
         return this.FOnUpdateHerosBaseAttributeRet;
      }
      
      public function set OnCharacterBaseAttributeRet(param1:Function) : void
      {
         this.FOnUpdateHerosBaseAttributeRet = param1;
      }
      
      public function get OnUpdataSeverTime() : Function
      {
         return this.FOnUpdataSeverTime;
      }
      
      public function set OnUpdataSeverTime(param1:Function) : void
      {
         this.FOnUpdataSeverTime = param1;
      }
      
      public function get OnCheckAntiAddiction() : Function
      {
         return this.FOnCheckAntiAddiction;
      }
      
      public function set OnCheckAntiAddiction(param1:Function) : void
      {
         this.FOnCheckAntiAddiction = param1;
      }
      
      public function set OnStartFreshGuide(param1:Function) : void
      {
         this.FOnStartFreshGuide = param1;
      }
      
      public function set OnInitMilitaryInfor(param1:Function) : void
      {
         this.FOnInitMilitaryInfor = param1;
      }
      
      public function get OnInitAllNpc() : Function
      {
         return this.FOnInitAllNpc;
      }
      
      public function set OnInitAllNpc(param1:Function) : void
      {
         this.FOnInitAllNpc = param1;
      }
      
      public function get OnUpdateAllHeroEquipmentMountedSuitCount() : Function
      {
         return this.FOnUpdateAllHeroEquipmentMountedSuitCount;
      }
      
      public function set OnUpdateAllHeroEquipmentMountedSuitCount(param1:Function) : void
      {
         this.FOnUpdateAllHeroEquipmentMountedSuitCount = param1;
      }
      
      public function get OnEnabledCheckSpeedUp() : Function
      {
         return this.FOnEnabledCheckSpeedUp;
      }
      
      public function set OnEnabledCheckSpeedUp(param1:Function) : void
      {
         this.FOnEnabledCheckSpeedUp = param1;
      }
      
      public function get OnCloseSocketLoading() : Function
      {
         return this.FOnCloseSocketLoading;
      }
      
      public function set OnCloseSocketLoading(param1:Function) : void
      {
         this.FOnCloseSocketLoading = param1;
      }
      
      public function get OnInitMall() : Function
      {
         return this.FOnInitMall;
      }
      
      public function set OnInitMall(param1:Function) : void
      {
         this.FOnInitMall = param1;
      }
      
      public function get OnInitVip() : Function
      {
         return this.FOnInitVip;
      }
      
      public function set OnInitVip(param1:Function) : void
      {
         this.FOnInitVip = param1;
      }
      
      public function get OnUpdateVipInfo() : Function
      {
         return this.FOnUpdateVipInfo;
      }
      
      public function set OnUpdateVipInfo(param1:Function) : void
      {
         this.FOnUpdateVipInfo = param1;
      }
      
      public function get OnEnterFamily() : Function
      {
         return this.FOnEnterFamily;
      }
      
      public function set OnEnterFamily(param1:Function) : void
      {
         this.FOnEnterFamily = param1;
      }
      
      public function get OnDailyQusetInfoReq() : Function
      {
         return this.FOnDailyQusetInfoReq;
      }
      
      public function set OnDailyQusetInfoReq(param1:Function) : void
      {
         this.FOnDailyQusetInfoReq = param1;
      }
      
      public function get OnActivityInfoReq() : Function
      {
         return this.FOnActivityInfoReq;
      }
      
      public function set OnActivityInfoReq(param1:Function) : void
      {
         this.FOnActivityInfoReq = param1;
      }
      
      public function get OnInitQuests() : Function
      {
         return this.FOnInitQuests;
      }
      
      public function set OnInitQuests(param1:Function) : void
      {
         this.FOnInitQuests = param1;
      }
      
      public function get OnHeroQualityChange() : Function
      {
         return this.FOnHeroQualityChange;
      }
      
      public function set OnHeroQualityChange(param1:Function) : void
      {
         this.FOnHeroQualityChange = param1;
      }
      
      public function get OnMilitaryInfoReq() : Function
      {
         return this.FOnMilitaryInfoReq;
      }
      
      public function set OnMilitaryInfoReq(param1:Function) : void
      {
         this.FOnMilitaryInfoReq = param1;
      }
      
      public function get OnLoadAchievementInfor() : Function
      {
         return this.FOnLoadAchievementInfor;
      }
      
      public function set OnLoadAchievementInfor(param1:Function) : void
      {
         this.FOnLoadAchievementInfor = param1;
      }
      
      public function set OnLoadBleachTrainInfor(param1:Function) : void
      {
         this.FOnLoadBleachTrainInfor = param1;
      }
      
      public function get OnInitAddHeroSlotTime() : Function
      {
         return this.FOnInitAddHeroSlotTime;
      }
      
      public function set OnInitAddHeroSlotTime(param1:Function) : void
      {
         this.FOnInitAddHeroSlotTime = param1;
      }
      
      public function set OnLoadDailyWelfareInfor(param1:Function) : void
      {
         this.FOnLoadDailyWelfareInfor = param1;
      }
      
      public function set OnInitHeroChangeInfor(param1:Function) : void
      {
         this.FOnInitHeroChangeInfor = param1;
      }
      
      public function UserEnterTownRequest(param1:uint) : void
      {
         this.ProcessorOnEnterTown(param1);
      }
   }
}

