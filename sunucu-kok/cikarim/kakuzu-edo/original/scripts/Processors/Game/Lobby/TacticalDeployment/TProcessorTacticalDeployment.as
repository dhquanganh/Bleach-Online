package Processors.Game.Lobby.TacticalDeployment
{
   import Foundation.Common.TBounds;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Characters.TCharacter;
   import Logics.Characters.THero;
   import Logics.Characters.THeros;
   import Logics.DatebaseVO.VO.TMilitary;
   import Logics.DatebaseVO.VO.TSystemLanguage;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_DEPLOYMENT;
   import Resources.Constants.CONST_FRESHGUIDE;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_POPTIPS;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.utils.ByteArray;
   
   public class TProcessorTacticalDeployment extends TProcessorLobbyWindows
   {
      
      protected static const SIZE_WIDTH_TacticalDeployment:int = 651;
      
      protected static const SIZE_HEIGHT_TacticalDeployment:int = 488;
      
      protected var FProcessorWindowTacticalDeployment:TProcessorWindowTacticalDeployment;
      
      protected var FBoundsTacticalDeployment:TBounds;
      
      protected var FSystemLanguage:TBins;
      
      protected var FMilitary:TBins;
      
      protected var FCharacter:TCharacter;
      
      protected var FOnChangePosition:Function;
      
      protected var FOnEnterMilitary:Function;
      
      protected var FUpdateHeroPower:Function;
      
      protected var FOnSetBackToDepoly:Function;
      
      public function TProcessorTacticalDeployment(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FCharacter = SLogicsCore.Character;
         this.FProcessorWindowTacticalDeployment = new TProcessorWindowTacticalDeployment(this);
         this.FProcessorWindowTacticalDeployment.OnClose = this.ProcessorWindowOnClose;
         this.FProcessorWindowTacticalDeployment.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowTacticalDeployment.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowTacticalDeployment.OnHelpTipsOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowTacticalDeployment.OnHelpTipsOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowTacticalDeployment.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowTacticalDeployment.OnEnterMilitary = this.ProcessorsOnEnterMilitary;
         this.FProcessorWindowTacticalDeployment.Visible = false;
         this.FBoundsTacticalDeployment = new TBounds();
         this.FBoundsTacticalDeployment.Width = SIZE_WIDTH_TacticalDeployment;
         this.FBoundsTacticalDeployment.Height = SIZE_HEIGHT_TacticalDeployment;
         ComponentBoundsCenter(this.FProcessorWindowTacticalDeployment,this.FBoundsTacticalDeployment);
         this.FBoundsTacticalDeployment = null;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_DEPLOYMENT.RESOURCESID_TacticalDeployment);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         if(this.FSystemLanguage == null)
         {
            this.FSystemLanguage = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SystemLanguage);
         }
         this.FMilitary = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Military);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         if(this.FUpdateHeroPower != null)
         {
            this.FUpdateHeroPower(this);
         }
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TacticalDeploymentChangePositonRet,this.PerformPacket_SC_TD_ChangePositionReq);
      }
      
      protected function PerformPacket_SC_TD_ChangePositionReq(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:ByteArray = null;
         var _loc6_:THero = null;
         var _loc7_:THero = null;
         var _loc8_:THeros = null;
         var _loc9_:uint = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:TSystemLanguage = null;
         var _loc13_:int = 0;
         var _loc14_:Boolean = false;
         _loc5_ = param1.Data;
         _loc2_ = _loc5_.readInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FProcessorWindowTacticalDeployment.SetupForcePromptFreshGuide(false);
         _loc9_ = _loc5_.readUnsignedInt();
         _loc11_ = int(_loc5_.readUnsignedByte());
         _loc8_ = this.FCharacter.Heros;
         _loc6_ = _loc8_.GetHeroByIdentifier(_loc9_);
         if(_loc6_ == null)
         {
            return;
         }
         _loc10_ = _loc6_.FightPosition;
         _loc4_ = _loc8_.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = _loc8_.GetHeroByIndex(_loc3_);
            if(_loc7_.FightPosition > 0 && _loc7_.FightPosition == _loc11_)
            {
               _loc7_.FightPosition = _loc10_;
               _loc7_.Mounted = false;
               _loc13_ = int(CONST_SYSTEMLANGUAGE.TACTICALDEPLOYMENT_STRING_04);
               _loc14_ = true;
               break;
            }
            _loc3_++;
         }
         if(!_loc14_)
         {
            if(_loc10_ == 0 || _loc11_ != 0)
            {
               _loc6_.Mounted = true;
               _loc13_ = int(CONST_SYSTEMLANGUAGE.TACTICALDEPLOYMENT_STRING_01);
            }
            else
            {
               _loc6_.Mounted = false;
               _loc13_ = int(CONST_SYSTEMLANGUAGE.TACTICALDEPLOYMENT_STRING_06);
            }
         }
         _loc6_.FightPosition = _loc11_;
         if(Visible)
         {
            this.FProcessorWindowTacticalDeployment.ResetDeployment();
         }
         if(this.FOnChangePosition != null)
         {
            this.FOnChangePosition(this,_loc7_.Identifier);
         }
         this.CheckHeroMounted();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(_loc13_));
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_HeroGotoDeployment);
      }
      
      override protected function PopTipsNotifyCheck() : void
      {
         if(FOnCheckPopTipsModes != null)
         {
            FOnCheckPopTipsModes(this,CONST_POPTIPS.POPTIP_Goto_TacticalDeployment);
         }
      }
      
      protected function CheckHeroMounted() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THero = null;
         _loc2_ = uint(this.FCharacter.Heros.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FCharacter.Heros.GetHeroByIndex(_loc1_);
            _loc3_.Mounted = Boolean(_loc3_.FightPosition != 0);
            _loc1_++;
         }
      }
      
      protected function ProcessorWindowOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      protected function ProcessorsOnEnterMilitary(param1:Object) : void
      {
         if(SLogicsCore.Character.RoleSencePosition == CONST_COMMON.SCENEPOSITION_BATTLESENCE_AUTO)
         {
            return;
         }
         if(this.FOnEnterMilitary != null)
         {
            this.FOnEnterMilitary(param1);
         }
      }
      
      public function get OnChangePosition() : Function
      {
         return this.FOnChangePosition;
      }
      
      public function set OnChangePosition(param1:Function) : void
      {
         this.FOnChangePosition = param1;
      }
      
      public function get OnEnterMilitary() : Function
      {
         return this.FOnEnterMilitary;
      }
      
      public function set OnEnterMilitary(param1:Function) : void
      {
         this.FOnEnterMilitary = param1;
      }
      
      public function get ProcessorWindowTacticalDeployment() : TProcessorWindowTacticalDeployment
      {
         return this.FProcessorWindowTacticalDeployment;
      }
      
      public function set UpdateHeroPower(param1:Function) : void
      {
         this.FUpdateHeroPower = param1;
      }
      
      public function set OnSetBackToDepoly(param1:Function) : void
      {
         this.FOnSetBackToDepoly = param1;
         this.FProcessorWindowTacticalDeployment.OnSetBackToDepoly = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TMilitary = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowTacticalDeployment.Load();
            return;
         }
         _loc2_ = this.FCharacter.MilitaryRank;
         _loc3_ = this.FMilitary.GetDatebaseByIdentifier(_loc2_) as TMilitary;
         _loc4_ = uint(_loc3_.FightHeroNum);
         _loc5_ = uint(_loc3_.MaxHeroNum);
         this.FProcessorWindowTacticalDeployment.MaxPointCount = _loc4_;
         this.FProcessorWindowTacticalDeployment.MaxHeroCount = _loc5_;
         this.FProcessorWindowTacticalDeployment.SetupDeploymentData();
         this.FProcessorWindowTacticalDeployment.Visible = true;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenDeployment);
      }
      
      override public function Unmount() : void
      {
         this.FProcessorWindowTacticalDeployment.Visible = false;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseDeployment);
         this.FProcessorWindowTacticalDeployment.Reset();
      }
      
      public function UserUpdateFightingPower() : void
      {
         if(this.FProcessorWindowTacticalDeployment.Visible)
         {
            this.FProcessorWindowTacticalDeployment.UserUpdateFightingPower();
         }
      }
      
      public function AutoSetDeployment(param1:uint, param2:uint, param3:Function) : void
      {
         this.FProcessorWindowTacticalDeployment.AutoSetDeployment(param1,param2,param3);
      }
      
      public function SetupForcePromptFreshGuide(param1:Boolean) : void
      {
         this.FProcessorWindowTacticalDeployment.SetupForcePromptFreshGuide(param1);
      }
   }
}

