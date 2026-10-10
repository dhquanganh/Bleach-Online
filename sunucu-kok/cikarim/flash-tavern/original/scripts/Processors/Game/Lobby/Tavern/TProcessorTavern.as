package Processors.Game.Lobby.Tavern
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Registries.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.ChatOptions.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Characters.*;
   import Logics.Streamization.Tavern.*;
   import Logics.Tavern.*;
   import Processors.Game.Common.Effects.Texts.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Tavern.TavernEffect.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.Hints.*;
   import Rendering.Overlayers.Inventories.*;
   import Rendering.Overlayers.Tavern.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Overlayers.*;
   import flash.display.*;
   import flash.utils.*;
   
   public class TProcessorTavern extends TProcessorLobbyPlate
   {
      
      protected static const SIZE_WIDTH_Recruit:uint = 624;
      
      protected static const SIZE_HEIGHT_Recruit:uint = 200;
      
      protected static const SIZE_WIDTH_ChangeCard:uint = 301;
      
      protected static const SIZE_HEIGHT_ChangeCard:uint = 176;
      
      protected static const EffectSingle_DelayTicks:int = 1000;
      
      protected static const EffectMulti_DelayTicks:int = 500;
      
      protected static const FLOATING:uint = 1;
      
      protected static const MoraMode_Normal:uint = 0;
      
      protected static const MoraMode_Advance:uint = 1;
      
      protected static const MoraMode_Ten:uint = 2;
      
      protected static const MoraMode_TenWin:uint = 3;
      
      protected var FScene:MovieClip;
      
      protected var FProcessorWindowTavern:TProcessorWindowTavern;
      
      protected var FProcessorWindowTavernHeroList:TProcessorWindowTavernHeroList;
      
      protected var FProcessorWindowTavernMora:TProcessorWindowTavernMora;
      
      protected var FOverlayerKey:TOverlayerKey;
      
      protected var FIsInit:Boolean;
      
      protected var FProcessorWindowRecruit:TProcessorWindowRecruit;
      
      protected var FProcessorWindowChangeCard:TProcessorWindowChangeCard;
      
      protected var FBoundsRecruit:TBounds;
      
      protected var FBoundsChangeCard:TBounds;
      
      protected var FMountPointWindow:TUIComponent;
      
      protected var FEffRoutines:TRegistryRoutine;
      
      protected var FEffState:int;
      
      protected var FEffDelayReferenceTick:int;
      
      protected var FEffectCount:uint;
      
      protected var FTavernEffectStructVect:Vector.<TTavernEffectStruct>;
      
      protected var FTempTotleSouls:int;
      
      protected var FTempQuality:int;
      
      protected var FIsTip:Boolean;
      
      protected var FMoras:TMoras;
      
      protected var UnstreamizerTavern:TUnstreamizerTavern;
      
      protected var FTavernWarriorBins:TBins;
      
      protected var FEffectCoordinateParameters:TEffectCoordinateParameters;
      
      protected var FHeros:THeros;
      
      protected var FUnstreamizerCharacter:TUnstreamizerCharacter;
      
      protected var FIsIconUpdate:Boolean;
      
      protected var FIfForceGuide:Boolean;
      
      protected var FIDTemplates:Vector.<uint>;
      
      protected var FOnReturnTown:Function;
      
      protected var FOnEffectSoul:Function;
      
      protected var FOnUpdateHerosBaseAttributeReq:Function;
      
      public function TProcessorTavern(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FIsInit = false;
         this.FMountPointWindow = param2.MountPointWindow;
         this.FTavernEffectStructVect = new Vector.<TTavernEffectStruct>();
         this.FMoras = new TMoras();
         this.UnstreamizerTavern = new TUnstreamizerTavern();
         this.FEffectCoordinateParameters = new TEffectCoordinateParameters();
         this.FHeros = SLogicsCore.Character.Heros;
         this.FUnstreamizerCharacter = new TUnstreamizerCharacter();
         this.FIDTemplates = new Vector.<uint>();
         this.FTempQuality = -1;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FProcessorWindowTavern != null && Visible == true)
         {
            this.FProcessorWindowTavern.UpdataEffect();
         }
         if(this.FProcessorWindowTavernHeroList != null && this.FProcessorWindowTavernHeroList.Visible == true)
         {
            this.FProcessorWindowTavernHeroList.UpdataTavernHeroHeadBitmap();
         }
         if(this.FProcessorWindowChangeCard != null && this.FProcessorWindowChangeCard.Visible == true)
         {
            this.FProcessorWindowChangeCard.UpdataBitmap();
         }
         if(this.FTavernEffectStructVect.length > 0)
         {
            this.LogicsPerform_Effect();
         }
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_TAVERN.RESOURCESID_TAVERN);
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_TavernView,this);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_TavernView,FParent.parent);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.InitArena();
         this.FProcessorWindowChangeCard = new TProcessorWindowChangeCard(this.FMountPointWindow);
         this.FProcessorWindowChangeCard.Visible = false;
         this.FProcessorWindowChangeCard.BarrierDeactuate = this.OnBarrierDeactuate;
         this.FProcessorWindowChangeCard.SlotsOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowChangeCard.SlotsOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FBoundsRecruit = new TBounds();
         this.FBoundsRecruit.Width = SIZE_WIDTH_Recruit;
         this.FBoundsRecruit.Height = SIZE_HEIGHT_Recruit;
         ComponentBoundsCenter(this.FProcessorWindowRecruit,this.FBoundsRecruit);
         this.FBoundsRecruit = null;
         this.FBoundsChangeCard = new TBounds();
         this.FBoundsChangeCard.Width = SIZE_WIDTH_ChangeCard;
         this.FBoundsChangeCard.Height = SIZE_HEIGHT_ChangeCard;
         ComponentBoundsCenter(this.FProcessorWindowChangeCard,this.FBoundsChangeCard);
         this.FBoundsChangeCard = null;
         this.FOverlayerKey = new TOverlayerKey(this);
         this.FOverlayerKey.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerKey);
         this.FTavernWarriorBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Tavern_Warrior);
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function InitArena() : void
      {
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_TAVERN.RESOURCESID_CLASSNAME_Tavern) as MovieClip;
         addChild(this.FScene);
         this.FProcessorWindowTavern = new TProcessorWindowTavern(this,this.FScene.mc_publicBox);
         this.FProcessorWindowTavern.OnHelpTipsOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowTavern.OnHelpTipsOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowTavern.OnEnterCity = this.OnCloseTavern;
         this.FProcessorWindowTavernHeroList = new TProcessorWindowTavernHeroList(this,this.FScene.mc_generalBox);
         this.FProcessorWindowTavernHeroList.Visible = false;
         this.FProcessorWindowTavernHeroList.OnOverlay = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowTavernHeroList.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowTavernHeroList.SetRecruitData = this.SetRecruitData;
         this.FProcessorWindowTavernHeroList.SetChangeCardData = this.SetChangeCardData;
         this.FProcessorWindowTavernHeroList.EnterMora = this.OnEnterMora;
         this.FProcessorWindowTavernHeroList.HintOnMove = this.UIComponentsOnOver;
         this.FProcessorWindowTavernHeroList.HintOnOut = this.UIComponentsOnOut;
         this.FProcessorWindowTavernHeroList.EffectGenerateText = EffectGenerateText;
         this.FProcessorWindowTavernHeroList.EnableWindowTavern = this.EnableWindowTavern;
         this.FProcessorWindowTavernHeroList.EnableMora = this.EnableMora;
         this.FProcessorWindowTavernHeroList.TutorialNextStep = TutorialNextStep;
         this.FProcessorWindowTavernHeroList.SetButtonAndLevel = this.SetButtonAndLevel;
         this.FProcessorWindowTavernMora = new TProcessorWindowTavernMora(this,this.FScene.mc_moraBox);
         this.FProcessorWindowTavernMora.Visible = true;
         this.FProcessorWindowTavernMora.TurnBackHeroList = this.TurnBackHeroList;
         this.FProcessorWindowTavernMora.OnPlayScene = this.OnPlayScene;
         this.FProcessorWindowTavernMora.SetWineBT = this.SetWineBT;
         this.FProcessorWindowRecruit = new TProcessorWindowRecruit(this,this.FScene.mc_tavernTip);
         this.FProcessorWindowRecruit.RecruitVisible = true;
         this.FProcessorWindowRecruit.BarrierDeactuate = this.OnBarrierDeactuate;
         this.FProcessorWindowRecruit.OnEffectText = FOnEffectText;
         this.FProcessorWindowRecruit.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowRecruit.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FEffRoutines = new TRegistryRoutine();
         this.EffRegisterRoutines();
      }
      
      protected function EffRegisterRoutines() : void
      {
         this.FEffRoutines.Register(FLOATING,this.LoginPerform_FloatingWord);
      }
      
      protected function LoginPerform_FloatingWord() : void
      {
         var _loc1_:TCoordinate = null;
         var _loc2_:TTavernEffectStruct = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         _loc4_ = STimingCore.TickCount - this.FEffDelayReferenceTick;
         if(_loc4_ < EffectMulti_DelayTicks)
         {
            return;
         }
         this.FEffDelayReferenceTick = STimingCore.TickCount;
         _loc2_ = this.FTavernEffectStructVect.shift();
         if(this.FTavernEffectStructVect.length == 0)
         {
            if(this.FIsTip)
            {
               this.SetMoraLog();
               this.EnableWindowTavern(true);
            }
            setTimeout(this.SetListSelected,1000);
         }
         if(_loc2_.IsWin == false)
         {
            if(_loc2_.HeroId != 0)
            {
               this.FProcessorWindowTavernHeroList.ShowOneKeyHeroById(_loc2_.HeroId);
            }
            EffectGenerateText(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_06),_loc2_.ReturnMoney));
         }
         else
         {
            _loc3_ = this.FProcessorWindowTavern.GetHeroSoulByIndex(_loc2_.AwardSoulType - 3);
            this.FProcessorWindowTavern.SetHeroSoulByIndex(_loc2_.AwardSoulType - 3,_loc2_.AwardSoulValue + _loc3_);
            EffectGenerateText(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_07),_loc2_.AwardSoulValue,TUtilityLobby.GetColorNameByIndex(_loc2_.AwardSoulType)));
            if(this.FOnEffectSoul != null)
            {
               if(_loc2_.HeroId != 0)
               {
                  this.FProcessorWindowTavernHeroList.ShowOneKeyHeroById(_loc2_.HeroId);
                  _loc1_ = this.FProcessorWindowTavernHeroList.GetCoordinateByHeroId(_loc2_.HeroId);
                  this.FEffectCoordinateParameters.CoordinateDestination.Assign(_loc1_);
                  this.FOnEffectSoul(this,_loc2_.AwardSoulType - 3,_loc2_.AwardSoulValue,this.FEffectCoordinateParameters);
               }
               else
               {
                  _loc1_ = this.FProcessorWindowTavernMora.GetCoordinateByResult();
                  this.FEffectCoordinateParameters.CoordinateDestination.Assign(_loc1_);
                  this.FOnEffectSoul(this,_loc2_.AwardSoulType - 3,_loc2_.AwardSoulValue,this.FEffectCoordinateParameters);
               }
            }
         }
         TPoolTavernEffectStruct.SaveTavernEffectStruct(_loc2_);
      }
      
      private function SetListSelected() : void
      {
         this.FProcessorWindowTavernHeroList.SetHightLight();
      }
      
      protected function SetMoraLog() : void
      {
         this.FProcessorWindowTavern.MoraLog(this.FTempTotleSouls,this.FTempQuality);
         this.FTempTotleSouls = 0;
         this.FTempQuality = -1;
      }
      
      protected function EnterTavern() : void
      {
         if(this.FScene == null)
         {
            return;
         }
         this.FProcessorWindowTavern.UpdataPublicUI();
         this.FProcessorWindowTavernHeroList.CheckTavernHeroList();
         this.FProcessorWindowTavernHeroList.SelectFirstMan();
         if(this.FMoras.Count <= 0)
         {
            this.FProcessorWindowTavernHeroList.Visible = true;
            this.FProcessorWindowTavernMora.Visible = true;
            this.FProcessorWindowTavernMora.SetMouseEnable(false);
            this.FProcessorWindowRecruit.RecruitVisible = true;
         }
         else
         {
            this.FProcessorWindowRecruit.RecruitVisible = false;
            this.FProcessorWindowTavernHeroList.Visible = false;
            this.FProcessorWindowTavernMora.Visible = true;
            this.FProcessorWindowTavernMora.SetMouseEnable(true);
            this.FProcessorWindowTavernMora.SetMoraData(this.FMoras);
         }
         SLogicsCore.Character.RoleSencePosition = CONST_COMMON.SCENEPOSITION_TAVERN;
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TavernMoraRet,this.PacketPerform_SC_TavernMora);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TavernNormalMoraRet,this.PacketPerform_SC_TavernNormalMora);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TavernRecruitRet,this.PacketPerform_SC_TavernRecruit);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TavernChangeCardRet,this.PacketPerform_SC_ChangeCard);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TavernAddQuality_Ret,this.PacketPerform_SC_TavernAddQuality_Ret);
      }
      
      protected function PacketPerform_SC_Enter_Tavern(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.UnstreamizerTavern.Unstreamize(param1,this.FMoras,null);
         if(this.FMoras.Count > 0)
         {
            this.FProcessorWindowTavernHeroList.Visible = false;
            this.FProcessorWindowTavernMora.Visible = true;
            this.FProcessorWindowTavernMora.SetMouseEnable(true);
            this.FProcessorWindowTavernMora.SetMoraData(this.FMoras);
            this.FIsTip = false;
         }
         this.FIsInit = true;
      }
      
      protected function PacketPerform_SC_TavernMora(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:TMora = null;
         _loc3_ = param1.Data;
         _loc4_ = _loc3_.readUnsignedInt();
         if(_loc4_ != 0)
         {
            this.EnableWindowTavern(true);
            EffectGenerateTextByErrorCode(_loc4_);
            return;
         }
         this.UnstreamizerTavern.Unstreamize(_loc3_,this.FMoras,null);
         if(this.FMoras.MoraType == MoraMode_Normal || this.FMoras.MoraType == MoraMode_Advance)
         {
            this.FProcessorWindowTavernHeroList.ShowChooseMoraHero(this.FMoras);
            this.FIsTip = false;
         }
         else if(this.FMoras.MoraType == MoraMode_Ten || this.FMoras.MoraType == MoraMode_TenWin)
         {
            this.FProcessorWindowTavernHeroList.ResetList();
            _loc2_ = 0;
            while(_loc2_ < this.FMoras.Count)
            {
               _loc5_ = this.FMoras.GetMoraByIndex(_loc2_);
               this.MakeEffectStruct(_loc5_);
               if(_loc5_.IsMoraWin)
               {
                  this.FTempTotleSouls += this.FTavernEffectStructVect[this.FTavernEffectStructVect.length - 1].AwardSoulValue;
               }
               _loc2_++;
            }
            this.FTempQuality = this.FTavernEffectStructVect[this.FTavernEffectStructVect.length - 1].AwardSoulType;
            this.FEffState = FLOATING;
            this.FEffectCount = this.FMoras.Count;
            this.FEffDelayReferenceTick = STimingCore.TickCount;
            this.FMoras.Clear();
            this.FIsTip = true;
         }
      }
      
      protected function PacketPerform_SC_TavernNormalMora(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Boolean = false;
         var _loc6_:TMora = null;
         var _loc7_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = _loc2_.readUnsignedInt();
         _loc5_ = Boolean(_loc2_.readUnsignedByte());
         _loc7_ = _loc2_.readUnsignedInt();
         this.FProcessorWindowTavernMora.SetMoraResult(_loc4_,_loc5_);
         _loc6_ = this.FMoras.GetMoraByHeroId(_loc4_);
         _loc6_.IsMoraWin = _loc5_;
         _loc6_.ReturnMoney = _loc7_;
         if(!_loc6_.IsMoraWin)
         {
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_MoreLose);
         }
         this.MakeEffectStruct(_loc6_,false);
         this.FEffState = FLOATING;
         this.FEffectCount = 1;
         this.FEffDelayReferenceTick = STimingCore.TickCount;
      }
      
      protected function PacketPerform_SC_TavernRecruit(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TTavernWarrior = null;
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:THero = null;
         _loc3_ = param1.Data;
         _loc4_ = _loc3_.readUnsignedInt();
         if(_loc4_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc4_);
            return;
         }
         _loc5_ = _loc3_.readUnsignedInt();
         _loc8_ = int(_loc3_.readUnsignedInt());
         _loc9_ = _loc3_.readUnsignedInt();
         _loc10_ = _loc3_.readUnsignedInt();
         _loc11_ = this.FHeros.GetHeroByIdentifier(_loc5_);
         if(_loc11_ != null)
         {
            _loc11_.HeroCostGold = _loc10_;
            _loc11_.HeroOverTime = _loc9_;
            return;
         }
         this.FIDTemplates.length = 0;
         this.FIDTemplates.push(_loc5_);
         this.FUnstreamizerCharacter.UnstreamizeGenerateHerosByIdentifiers(null,this.FHeros,this.FIDTemplates);
         _loc11_ = this.FHeros.GetHeroByIdentifier(_loc5_);
         _loc11_.HeroCostGold = _loc10_;
         _loc11_.HeroOverTime = _loc9_;
         _loc11_.RebirthLevel = _loc8_;
         if(this.FOnUpdateHerosBaseAttributeReq != null)
         {
            this.FOnUpdateHerosBaseAttributeReq(this,_loc5_);
         }
         if(this.FTavernWarriorBins == null)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < this.FTavernWarriorBins.Count)
         {
            _loc6_ = this.FTavernWarriorBins.GetDatebaseByIndex(_loc2_) as TTavernWarrior;
            if(_loc6_.AwardId == _loc5_)
            {
               break;
            }
            _loc2_++;
         }
         if(_loc6_ != null)
         {
            this.FProcessorWindowTavernHeroList.SetHightLight();
            this.FProcessorWindowRecruit.SetRecruitData(_loc6_,false);
            _loc7_ = this.FProcessorWindowTavern.GetHeroSoulByIndex(_loc6_.Awardsouls.Type - 3);
            this.FProcessorWindowTavern.SetHeroSoulByIndex(_loc6_.Awardsouls.Type - 3,_loc7_ - _loc6_.RecruitSoul);
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_20));
         }
      }
      
      protected function PacketPerform_SC_TavernAddQuality_Ret(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:TTavernWarrior = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc5_ = _loc2_.readUnsignedInt();
         _loc6_ = _loc2_.readUnsignedInt();
         SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc5_).AddQuality = _loc6_;
         _loc7_ = 0;
         while(_loc7_ < this.FTavernWarriorBins.Count)
         {
            _loc4_ = this.FTavernWarriorBins.GetDatebaseByIndex(_loc7_) as TTavernWarrior;
            if(_loc4_.AwardId == _loc5_)
            {
               break;
            }
            _loc7_++;
         }
         if(this.FOnUpdateHerosBaseAttributeReq != null)
         {
            this.FOnUpdateHerosBaseAttributeReq(this,_loc5_);
         }
         if(_loc4_ != null)
         {
            this.FProcessorWindowRecruit.SetRecruitData(_loc4_,false);
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(70130027));
            this.FProcessorWindowTavern.UpdataPublicUI();
         }
      }
      
      protected function PacketPerform_SC_ChangeCard(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:TExchangeExpCard = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc6_ = this.FProcessorWindowChangeCard.GetBuyCount();
         _loc4_ = this.FProcessorWindowChangeCard.GetExchangeExpCard();
         _loc5_ = this.FProcessorWindowTavern.GetHeroSoulByIndex(_loc4_.Quality - 3);
         this.FProcessorWindowTavern.SetHeroSoulByIndex(_loc4_.Quality - 3,_loc5_ - _loc4_.Value * _loc6_);
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_09));
      }
      
      protected function MakeEffectStruct(param1:TMora, param2:Boolean = true) : void
      {
         var _loc3_:TTavernWarrior = null;
         var _loc4_:TTavernEffectStruct = null;
         _loc4_ = TPoolTavernEffectStruct.GetTavernEffectStruct();
         _loc3_ = this.FTavernWarriorBins.GetDatebaseByIdentifier(param1.TavernHeroId) as TTavernWarrior;
         if(param2)
         {
            _loc4_.HeroId = param1.TavernHeroId;
         }
         _loc4_.AwardSoulType = _loc3_.Awardsouls.Type;
         _loc4_.AwardSoulValue = _loc3_.Awardsouls.Value;
         _loc4_.IsWin = param1.IsMoraWin;
         _loc4_.ReturnMoney = param1.ReturnMoney;
         this.FTavernEffectStructVect.push(_loc4_);
      }
      
      protected function EnableWindowTavern(param1:Boolean) : void
      {
         this.FProcessorWindowTavernHeroList.EnableBtn(param1);
         this.FProcessorWindowTavern.EnableBtn(param1);
      }
      
      protected function EnableMora(param1:Boolean) : void
      {
         this.FProcessorWindowTavernMora.SetMouseEnable(param1);
      }
      
      protected function SetButtonAndLevel(param1:Object) : void
      {
         this.FProcessorWindowTavernMora.CurGrade = this.FProcessorWindowTavernHeroList.CurGrade;
         this.FProcessorWindowTavernMora.SetButtonAndLevel();
      }
      
      protected function UIComponentsOnOver(param1:Object, param2:TPayConfig) : void
      {
         this.FOverlayerKey.Context = param2;
         this.FOverlayerKey.Render(FUICore.MouseCoordinate);
         this.FOverlayerKey.Show();
      }
      
      protected function UIComponentsOnOut(param1:Object) : void
      {
         this.FOverlayerKey.Hide();
      }
      
      protected function OnPlayScene() : void
      {
         this.FScene.gotoAndPlay(1);
      }
      
      protected function SetWineBT(param1:Boolean) : void
      {
         this.FProcessorWindowTavernHeroList.IsLookOnly = this.FProcessorWindowTavernMora.IsLookOnly;
         this.FProcessorWindowTavernHeroList.SetWineBT(param1);
      }
      
      protected function OnCloseTavern(param1:Object) : void
      {
         if(this.FIfForceGuide)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GENERALSTAR_FORMAT_10));
            return;
         }
         if(this.FOnReturnTown != null)
         {
            this.FOnReturnTown(param1);
         }
      }
      
      protected function SetRecruitData(param1:TTavernWarrior, param2:Boolean) : void
      {
         this.FProcessorWindowRecruit.SetRecruitData(param1,param2);
      }
      
      protected function SetChangeCardData(param1:TExchangeExpCard, param2:Boolean) : void
      {
         BarrierActuate(this.FProcessorWindowChangeCard);
         this.FProcessorWindowChangeCard.SetChangeCardData(param1,param2);
      }
      
      protected function OnBarrierDeactuate(param1:Object) : void
      {
         BarrierDeactuate(param1);
         this.FProcessorWindowTavernHeroList.ResetList();
         this.FProcessorWindowTavernHeroList.SetHightLight();
         this.FProcessorWindowTavernMora.Visible = true;
         this.FProcessorWindowTavernMora.SetMouseEnable(false);
      }
      
      protected function OnEnterMora(param1:TMoras) : void
      {
         this.FProcessorWindowTavernMora.SetMoraData(param1);
         this.FProcessorWindowTavernMora.Visible = true;
         this.FProcessorWindowTavernMora.SetMouseEnable(true);
         this.FProcessorWindowTavernHeroList.Visible = false;
         this.FProcessorWindowRecruit.RecruitVisible = false;
         this.EnableWindowTavern(true);
      }
      
      protected function TurnBackHeroList() : void
      {
         this.FProcessorWindowTavernHeroList.IsLookOnly = this.FProcessorWindowTavernMora.IsLookOnly;
         this.FProcessorWindowTavernHeroList.EnableBtn(true);
         this.FProcessorWindowTavernHeroList.ResetList();
         this.FProcessorWindowTavernHeroList.SetHightLight();
         this.FProcessorWindowTavernHeroList.Visible = true;
         this.FProcessorWindowRecruit.RecruitVisible = true;
         this.FScene.gotoAndStop(1);
         this.FMoras.Clear();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_MoreLose);
      }
      
      protected function LogicsPerform_Effect() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Function = null;
         var _loc3_:int = 0;
         if(this.FEffectCount == 1)
         {
            _loc3_ = STimingCore.TickCount - this.FEffDelayReferenceTick;
            if(_loc3_ < EffectSingle_DelayTicks)
            {
               return;
            }
         }
         do
         {
            _loc1_ = this.FEffState;
            _loc2_ = this.FEffRoutines.GetRoutineByIndentifier(this.FEffState);
            if(_loc2_ != null)
            {
               _loc2_();
            }
            else
            {
               this.FEffectCount = 0;
            }
         }
         while(_loc1_ != this.FEffState);
      }
      
      public function set OnReturnTown(param1:Function) : void
      {
         this.FOnReturnTown = param1;
      }
      
      public function get OnReturnTown() : Function
      {
         return this.FOnReturnTown;
      }
      
      public function set OnEffectSoul(param1:Function) : void
      {
         this.FOnEffectSoul = param1;
      }
      
      public function get OnEffectSoul() : Function
      {
         return this.FOnEffectSoul;
      }
      
      public function set OnUpdateHerosBaseAttributeReq(param1:Function) : void
      {
         this.FOnUpdateHerosBaseAttributeReq = param1;
      }
      
      public function get OnUpdateHerosBaseAttributeReq() : Function
      {
         return this.FOnUpdateHerosBaseAttributeReq;
      }
      
      override public function ChatOptionsSetup(param1:TChatOptions) : void
      {
         param1.ChatStatus = CONST_CHAT.MODE_Hidden;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         var _loc2_:TPacket = null;
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         if(param1 != null)
         {
            this.PacketPerform_SC_Enter_Tavern(param1);
         }
         if(this.FIsInit == false)
         {
            _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Enter_Tavern);
            SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         }
         else
         {
            this.EnterTavern();
         }
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenTavern);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         if(this.FIsInit)
         {
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseTavern);
            this.FProcessorWindowTavernHeroList.Reset();
            this.FProcessorWindowRecruit.Reset();
            this.FProcessorWindowTavernMora.Reset();
            this.FProcessorWindowChangeCard.Reset();
         }
      }
      
      public function SetForcePromot(param1:Object, param2:Boolean) : void
      {
         this.FIfForceGuide = param2;
      }
   }
}

