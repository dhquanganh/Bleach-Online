package Processors.Game.Lobby.GeneralStar
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Queries.Coordinate.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.GeneralStar.*;
   import Logics.Inventories.*;
   import Logics.Skills.*;
   import Logics.Streamization.Skills.*;
   import Processors.Game.Common.Effects.Texts.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.GeneralStar.PackageStarPoint.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.GeneralStar.*;
   import Rendering.Overlayers.HelpTips.*;
   import Rendering.Overlayers.Inventories.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Overlayers.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TProcessorGeneralStar extends TProcessorLobbyWindows
   {
      
      protected static const CAPACITY_ContextSkills:uint = 3;
      
      protected static const TAB_NUM:uint = 2;
      
      protected static const POINT_ID:uint = 17200000;
      
      protected static const OFFSIDE_ID:uint = 17500000;
      
      protected static const OFFSIDE_DIS:uint = 48;
      
      protected static const SIZE_WIDTH_GeneralStar:int = 663;
      
      protected static const SIZE_HEIGHT_GeneralStar:int = 466;
      
      protected static const SIZE_WindowSkillUpgrade_Width:uint = 453;
      
      protected static const SIZE_WindowSkillUpgrade_Height:uint = 287;
      
      public static const FORMAT_SkillName:String = CONST_COMMON.STRING_ThinSquare;
      
      protected var FOverlayerGeneralStar:TOverlayerGeneralStar;
      
      protected var FProcessorWindowEsoteric:TProcessorWindowEsoteric;
      
      protected var FProcessorWindowSkill:TProcessorWindowSkill;
      
      protected var FProcessorWindowSkillUpgrade:TProcessorWindowSkillUpgrade;
      
      protected var FCharacter:TCharacter;
      
      protected var FEsotericPoints:TEsotericPoints;
      
      protected var FEffectCoordinateParameters:TEffectCoordinateParameters;
      
      protected var FQueryCoordinate:TQueryCoordinate;
      
      protected var FWindows:Vector.<TProcessorLobbyWindow>;
      
      protected var FTabs:TUITab;
      
      protected var FGeneralStarMC:MovieClip;
      
      protected var FCloseButton:SimpleButton;
      
      protected var FBtn_Help:SimpleButton;
      
      protected var FHelpTips:THint;
      
      protected var FSkillConfigBin:TBins;
      
      protected var FSystemLanguage:TBins;
      
      protected var FUnstreamizerSkills:TUnstreamizerSkills;
      
      protected var FUnstreamizerSkill:TUnstreamizerSkill;
      
      protected var FTabIndex:int;
      
      protected var FSkillPicID:uint;
      
      protected var FMainHeroQualityOnChange:Function;
      
      protected var FOnAddPopTips:Function;
      
      protected var FOnEffectAcquireInventory:Function;
      
      protected var FOnQueryShortcutCoordinate:Function;
      
      protected var FOnUpdateChangeSkill:Function;
      
      protected var FOnUpdateHeroPower:Function;
      
      protected var FTriggerFreshGuide:Boolean;
      
      public function TProcessorGeneralStar(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FCharacter = SLogicsCore.Character;
         this.FEsotericPoints = this.FCharacter.EsotericPoints;
         this.FUnstreamizerSkills = new TUnstreamizerSkills();
         this.FUnstreamizerSkill = new TUnstreamizerSkill();
         this.FTabIndex = 0;
         this.FSkillPicID = 0;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_GENERAL_STAR.RESOURCESID_GENERAL_STAR);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TBounds = null;
         this.FTabs = new TUITab(this);
         this.FHelpTips = new THint();
         this.FWindows = new Vector.<TProcessorLobbyWindow>();
         _loc4_ = new TBounds();
         _loc4_.Width = SIZE_WIDTH_GeneralStar;
         _loc4_.Height = SIZE_HEIGHT_GeneralStar;
         ComponentBoundsCenter(this,_loc4_);
         this.FEffectCoordinateParameters = new TEffectCoordinateParameters();
         this.FQueryCoordinate = new TQueryCoordinate();
         this.FGeneralStarMC = TUtilityReflection.CreateDisplayObjectInstance(CONST_GENERAL_STAR.RESOURCESID_CLASSNAME_GENERAL_STAR) as MovieClip;
         addChild(this.FGeneralStarMC);
         _loc2_ = TAB_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FGeneralStarMC["Tab_" + _loc1_];
            _loc3_.buttonMode = true;
            _loc3_.mouseChildren = false;
            this.FTabs.SetTabByIndex(_loc3_,_loc1_);
            _loc1_++;
         }
         this.FTabs.OnSwitch = this.TabClick;
         this.FTabs.Init();
         this.FCloseButton = this.FGeneralStarMC[CONST_GENERAL_STAR.RESOURCESID_NAME_Close];
         this.FBtn_Help = this.FGeneralStarMC[CONST_GENERAL_STAR.RESOURCE_Link_Btn_Help];
         this.FProcessorWindowEsoteric = new TProcessorWindowEsoteric(this,this.FGeneralStarMC.MC_EsotericPoint);
         this.FProcessorWindowEsoteric.OnPointMove = this.UIComponentsHintOnOver;
         this.FProcessorWindowEsoteric.OnPointOut = this.UIComponentsHintOnOut;
         this.FProcessorWindowEsoteric.OnPointClick = this.OnPointClick;
         this.FProcessorWindowEsoteric.OnSetQuality = this.SetMainHeroQuality;
         this.FProcessorWindowEsoteric.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowEsoteric.Esoteric();
         this.FWindows.push(this.FProcessorWindowEsoteric);
         this.FProcessorWindowSkill = new TProcessorWindowSkill(this,this.FGeneralStarMC.MC_SkillShow);
         this.FProcessorWindowSkill.OnSkillUpgrade = this.OnSkillUpgrade;
         this.FProcessorWindowSkill.OnBoxClick = this.OnBoxClick;
         this.FProcessorWindowSkill.OnBoxOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowSkill.MySkillOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowSkill.OnBoxOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowSkill.MySkillOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowSkill.Skill();
         this.FWindows.push(this.FProcessorWindowSkill);
         this.FProcessorWindowSkillUpgrade = new TProcessorWindowSkillUpgrade(FParameters.MountPointWindow);
         this.FProcessorWindowSkillUpgrade.OnClose = this.ProcessorWindowOnClose;
         this.FProcessorWindowSkillUpgrade.OnUpgrade = this.SkillUpgrade_CS;
         this.FProcessorWindowSkillUpgrade.OnSlotMouseOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowSkillUpgrade.OnSlotMouseOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowSkillUpgrade.SkillUpgrade();
         _loc4_.Width = SIZE_WindowSkillUpgrade_Width;
         _loc4_.Height = SIZE_WindowSkillUpgrade_Height;
         ComponentBoundsCenter(this.FProcessorWindowSkillUpgrade,_loc4_);
         this.FOverlayerGeneralStar = new TOverlayerGeneralStar(this.Parent);
         this.FOverlayerGeneralStar.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerGeneralStar);
         this.FSkillConfigBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SkillConfig);
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_GeneralStarView,this.FGeneralStarMC);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_GeneralStarView,this);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FCloseButton.addEventListener(MouseEvent.CLICK,this.WindowCloseOnClick);
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver);
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut);
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_GeneralStar_PointRet,this.PacketPerform_SC_GeneralStar_PointRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_GeneralStar_SkillListRet,this.PacketPerform_SC_GeneralStar_SkillListRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_GeneralStar_SkillUpgradeRet,this.PacketPerform_SC_GeneralStar_SkillUpgradeRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_GeneralStar_ChangeSkillRet,this.PerformPacket_SC_TD_ChangeSkillRet);
      }
      
      private function PacketPerform_SC_GeneralStar_PointRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:TEsotericPoint = null;
         _loc2_ = param1.Data;
         _loc3_ = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FCharacter.StarMapIndex = _loc2_.readUnsignedInt();
         _loc4_ = this.FEsotericPoints.GetEsotericPointByIdentifier(this.FCharacter.StarMapIndex) as TEsotericPoint;
         this.FloatingWords();
         this.FProcessorWindowEsoteric.UpdatePoint();
      }
      
      private function PacketPerform_SC_GeneralStar_SkillListRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         _loc2_ = param1.Data;
         _loc3_ = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FUnstreamizerSkills.Unstreamize(_loc2_,this.FCharacter.Skills,null);
         this.SupplementarySkills();
         this.FCharacter.Skills.Sort();
      }
      
      private function SupplementarySkills() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TEsotericPoint = null;
         var _loc5_:TSkill = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         _loc2_ = this.FEsotericPoints.FPointsCount();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FEsotericPoints.GetEsotericPointByIndex(_loc1_);
            if(_loc4_.IsSkill)
            {
               _loc3_ = _loc4_.Value[0];
               _loc7_ = uint(this.FCharacter.Skills.Count);
               _loc6_ = 0;
               while(_loc6_ < _loc7_)
               {
                  _loc5_ = this.FCharacter.Skills.GetSkillByIndex(_loc6_);
                  if(_loc5_.SkillID == _loc3_)
                  {
                     break;
                  }
                  _loc6_++;
               }
               if(_loc6_ == _loc7_)
               {
                  this.FUnstreamizerSkill.UnstreamizeSupplementarySkill(this.FCharacter.Skills,_loc3_);
               }
            }
            _loc1_++;
         }
      }
      
      private function PacketPerform_SC_GeneralStar_SkillUpgradeRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:TSkill = null;
         var _loc6_:TSkillConfig = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Boolean = false;
         _loc2_ = param1.Data;
         _loc3_ = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = _loc2_.readUnsignedInt();
         _loc6_ = this.FSkillConfigBin.GetDatebaseByIdentifier(_loc4_) as TSkillConfig;
         _loc9_ = false;
         _loc8_ = uint(this.FCharacter.Skills.Count);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc5_ = this.FCharacter.Skills.GetSkillByIndex(_loc7_) as TSkill;
            if(_loc5_.NextID == _loc4_)
            {
               if(this.FCharacter.MainHero.Skill.NextID == _loc4_)
               {
                  _loc9_ = true;
               }
               this.FUnstreamizerSkill.UnstreamizeUpgradeSkill(null,_loc5_,_loc4_);
               break;
            }
            _loc7_++;
         }
         if(_loc9_)
         {
            this.FCharacter.MainHero.Skill = _loc5_;
         }
         this.FProcessorWindowSkillUpgrade.Context = _loc5_;
         this.FProcessorWindowSkillUpgrade.Update();
         this.FProcessorWindowSkill.Update();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GENERALSTAR_FORMAT_08));
      }
      
      protected function PerformPacket_SC_TD_ChangeSkillRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:ByteArray = null;
         var _loc6_:TSkills = null;
         var _loc7_:TSkill = null;
         var _loc8_:uint = 0;
         var _loc9_:TSystemLanguage = null;
         _loc5_ = param1.Data;
         _loc4_ = int(_loc5_.readUnsignedByte());
         if(_loc4_ != 0)
         {
            return;
         }
         _loc8_ = _loc5_.readUnsignedInt();
         this.FCharacter.MainHero.Skill = this.FCharacter.Skills.GetSkillByIdentifier(_loc8_);
         _loc3_ = this.FCharacter.Skills.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc7_ = this.FCharacter.Skills.GetSkillByIndex(_loc2_);
            if(_loc7_.Mounted)
            {
               _loc7_.Mounted = !_loc7_.Mounted;
               break;
            }
            _loc2_++;
         }
         _loc7_ = this.FCharacter.Skills.GetSkillByIdentifier(_loc8_);
         if(_loc7_.Mounted)
         {
            _loc7_.Mounted = false;
         }
         else
         {
            _loc7_.Mounted = true;
         }
         if(Visible)
         {
            if(this.FProcessorWindowSkill != null)
            {
               this.FProcessorWindowSkill.PlayEffect();
               this.FProcessorWindowSkill.Update();
            }
         }
         else if(this.FOnUpdateChangeSkill != null)
         {
            this.FOnUpdateChangeSkill(this);
         }
         if(this.FSystemLanguage == null)
         {
            this.FSystemLanguage = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SystemLanguage);
         }
         _loc9_ = this.FSystemLanguage.GetDatebaseByIdentifier(CONST_SYSTEMLANGUAGE.TACTICALDEPLOYMENT_STRING_03) as TSystemLanguage;
         EffectGenerateText(_loc9_.Desc);
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ChangeGeneralSkill);
      }
      
      protected function SetMainHeroQuality(param1:uint) : void
      {
         this.FCharacter.MainHero.Quality = param1;
         if(this.FMainHeroQualityOnChange != null)
         {
            this.FMainHeroQualityOnChange(this);
         }
      }
      
      protected function FloatingWords() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:TEsotericPoint = null;
         var _loc6_:TSkillConfig = null;
         var _loc7_:TStarPointDesc = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:uint = 0;
         _loc5_ = this.FEsotericPoints.GetEsotericPointByIdentifier(this.FCharacter.StarMapIndex) as TEsotericPoint;
         _loc3_ = _loc5_.IsSkill;
         _loc4_ = "";
         _loc11_ = "";
         _loc2_ = int(CAPACITY_ContextSkills);
         if(_loc3_ == 0)
         {
            _loc2_ = int(_loc5_.Type.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc8_ = TUtilityLobby.GetTargetNameByIndex(_loc5_.Target[_loc1_] - 1);
               _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_StarPointDesc,OFFSIDE_ID + _loc5_.Type[_loc1_]) as TStarPointDesc;
               _loc9_ = _loc7_.Desc;
               _loc10_ = _loc5_.Value[_loc1_].toString();
               if(_loc5_.Type[_loc1_] >= 100)
               {
                  _loc12_ = _loc5_.Value[_loc1_] * 100;
                  _loc10_ = _loc12_.toString() + "%";
               }
               _loc11_ += _loc8_ + _loc9_ + "+" + _loc10_ + "\n";
               _loc1_++;
            }
            EffectGenerateText(_loc11_);
            if(this.FOnUpdateHeroPower != null)
            {
               this.FOnUpdateHeroPower(this,this.FCharacter.MainHero.Identifier);
            }
         }
         else
         {
            _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,_loc5_.Value[0]) as TSkillConfig;
            _loc11_ = TUtilityString.Format(FORMAT_SkillName,_loc6_.Name);
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_19) + _loc11_);
            this.PlayEfffect();
         }
      }
      
      private function PlayEfffect() : void
      {
         var _loc1_:TSkillConfig = null;
         var _loc2_:TSkill = null;
         var _loc3_:TPoint = null;
         var _loc4_:TEsotericPoint = null;
         var _loc5_:uint = 0;
         _loc4_ = this.FEsotericPoints.GetEsotericPointByIdentifier(this.FCharacter.StarMapIndex) as TEsotericPoint;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,_loc4_.Value[0]) as TSkillConfig;
         _loc2_ = SLogicsCore.PoolSkill.Acquire(_loc1_.Identifier);
         _loc2_.IDTexture = _loc1_.Icon;
         _loc5_ = _loc4_.MapNum - Math.floor(_loc4_.MapNum / 10) * 10 - 2;
         _loc3_ = this.FProcessorWindowEsoteric.GetGroundByIndex(_loc5_).GetPointByIndex(_loc4_.PointIndex - 1);
         this.ProcessorEffectAcquireInventory(_loc3_,_loc2_);
      }
      
      protected function ProcessorEffectAcquireInventory(param1:TPoint, param2:TSkill) : void
      {
         var _loc3_:TCoordinate = null;
         if(this.FOnQueryShortcutCoordinate != null)
         {
            this.FOnQueryShortcutCoordinate(this,CONST_SHORTCUTS.POSITION_MainFunction,CONST_SHORTCUTS.TYPE_MainFunction_Star,this.FQueryCoordinate);
         }
         _loc3_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(param1.Substrate);
         _loc3_.X += (param1.Substrate.width - OFFSIDE_DIS) / 2;
         _loc3_.Y += (param1.Substrate.height - OFFSIDE_DIS) / 2;
         this.FEffectCoordinateParameters.CoordinateSource.Assign(_loc3_);
         this.FEffectCoordinateParameters.CoordinateDestination.Assign(this.FQueryCoordinate.Value);
         if(this.FOnEffectAcquireInventory != null)
         {
            this.FOnEffectAcquireInventory(this,param2,this.FEffectCoordinateParameters);
         }
      }
      
      override protected function PopTipsNotifyCheck() : void
      {
         if(FOnCheckPopTipsModes != null)
         {
            FOnCheckPopTipsModes(this,CONST_POPTIPS.POPTIP_Goto_GeneralStar);
         }
      }
      
      private function TabClick(param1:uint) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < TAB_NUM)
         {
            this.FWindows[_loc2_].Visible = false;
            _loc2_++;
         }
         if(param1 == 0)
         {
            this.FProcessorWindowEsoteric.Init();
            this.FProcessorWindowSkill.Reset();
         }
         else if(param1 == 1)
         {
            this.FProcessorWindowSkill.UpdateSkillEffect(this.FSkillPicID);
            this.FProcessorWindowSkill.Update();
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickGeneralTab);
         }
         this.FWindows[param1].Visible = true;
      }
      
      protected function ProcessorWindowOnClose(param1:Object) : void
      {
         BarrierDeactuateWindows(this.FProcessorWindowSkillUpgrade);
      }
      
      protected function UIComponentsHintOnOver(param1:Object) : void
      {
         var _loc2_:TPoint = null;
         _loc2_ = param1 as TPoint;
         this.FOverlayerGeneralStar.Context = _loc2_.Context;
         this.FOverlayerGeneralStar.Render(FUICore.MouseCoordinate);
         this.FOverlayerGeneralStar.Show();
      }
      
      protected function UIComponentsHintOnOut(param1:Object) : void
      {
         this.FOverlayerGeneralStar.Hide();
      }
      
      private function OnPointClick(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GeneralStar_PointReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function WindowCloseOnClick(param1:MouseEvent) : void
      {
         if(this.FTriggerFreshGuide)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GENERALSTAR_FORMAT_10));
            return;
         }
         ProcessorClose();
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_Star);
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHelpTips);
      }
      
      protected function ButtonHelpOnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHelpTips);
      }
      
      private function OnSkillUpgrade(param1:Object, param2:Object) : void
      {
         BarrierActuateWindows(this.FProcessorWindowSkillUpgrade);
         this.FProcessorWindowSkillUpgrade.Context = param2;
         this.FProcessorWindowSkillUpgrade.Update();
         this.FProcessorWindowSkillUpgrade.Visible = true;
      }
      
      private function OnBoxClick(param1:Object, param2:Object) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         var _loc5_:TSkill = null;
         _loc5_ = param2 as TSkill;
         if(_loc5_.IDTexture == this.FSkillPicID)
         {
            this.FSkillPicID = 0;
            this.FProcessorWindowSkill.UpdateSkillEffect(this.FSkillPicID);
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GeneralStar_ChangeSkillReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(_loc5_.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      private function SkillUpgrade_CS(param1:Object, param2:Object) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         var _loc5_:TSkill = null;
         _loc5_ = param2 as TSkill;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GeneralStar_SkillUpgradeReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(_loc5_.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      private function SetTabIndex(param1:ByteArray) : void
      {
         if(param1.length == 0)
         {
            return;
         }
         this.FTabIndex = param1.readInt();
         this.FSkillPicID = param1.readInt();
      }
      
      public function get MainHeroQualityOnChange() : Function
      {
         return this.FMainHeroQualityOnChange;
      }
      
      public function set MainHeroQualityOnChange(param1:Function) : void
      {
         this.FMainHeroQualityOnChange = param1;
      }
      
      public function get OnAddPopTips() : Function
      {
         return this.FOnAddPopTips;
      }
      
      public function set OnAddPopTips(param1:Function) : void
      {
         this.FOnAddPopTips = param1;
      }
      
      public function get OnEffectAcquireInventory() : Function
      {
         return this.FOnEffectAcquireInventory;
      }
      
      public function set OnEffectAcquireInventory(param1:Function) : void
      {
         this.FOnEffectAcquireInventory = param1;
      }
      
      public function get OnQueryShortcutCoordinate() : Function
      {
         return this.FOnQueryShortcutCoordinate;
      }
      
      public function set OnQueryShortcutCoordinate(param1:Function) : void
      {
         this.FOnQueryShortcutCoordinate = param1;
      }
      
      public function get ProcessorWindowEsoteric() : TProcessorWindowEsoteric
      {
         return this.FProcessorWindowEsoteric;
      }
      
      public function get OnUpdateChangeSkill() : Function
      {
         return this.FOnUpdateChangeSkill;
      }
      
      public function set OnUpdateChangeSkill(param1:Function) : void
      {
         this.FOnUpdateChangeSkill = param1;
      }
      
      public function get OnUpdateHeroPower() : Function
      {
         return this.FOnUpdateHeroPower;
      }
      
      public function set OnUpdateHeroPower(param1:Function) : void
      {
         this.FOnUpdateHeroPower = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(param1 != null)
         {
            this.SetTabIndex(param1);
         }
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.FTabs.SwithTagManual(this.FTabIndex);
         if(this.FCharacter.MainHero.CustomHero != null && this.FCharacter.MainHero.Skill.SkillID == this.FCharacter.MainHero.CustomHero.CurSkill)
         {
            this.FTabs.SetTabEnabledByIndex(1,false);
         }
         else
         {
            this.FTabs.SetTabEnabledByIndex(1,true);
         }
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenGeneralStar);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FTabs.Reset();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseGeneralStar);
         this.FTabIndex = 0;
         this.FSkillPicID = 0;
         this.FProcessorWindowSkill.Reset();
         this.FProcessorWindowEsoteric.Reset();
      }
      
      public function CheckPopTip() : void
      {
         var _loc1_:TEsotericPoint = null;
         var _loc2_:TEsotericPoint = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TStarMap = null;
         _loc1_ = this.FEsotericPoints.GetEsotericPointByIdentifier(this.FCharacter.StarMapIndex) as TEsotericPoint;
         if(this.FCharacter.StarMapIndex == 0)
         {
            _loc1_ = this.FEsotericPoints.GetEsotericPointByIndex(0) as TEsotericPoint;
         }
         _loc2_ = this.FEsotericPoints.GetEsotericPointByIdentifier(this.FCharacter.StarMapIndex + 1) as TEsotericPoint;
         if(_loc2_ == null)
         {
            _loc3_ = _loc1_.MapNum + 1 + POINT_ID;
            _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_StarMap,_loc3_) as TStarMap;
            if(_loc1_ == this.FEsotericPoints.GetEsotericPointByIndex(74))
            {
               return;
            }
            _loc4_ = uint(_loc5_.StartID);
            _loc1_ = this.FEsotericPoints.GetEsotericPointByIdentifier(_loc4_) as TEsotericPoint;
         }
         else
         {
            _loc1_ = this.FEsotericPoints.GetEsotericPointByIdentifier(this.FCharacter.StarMapIndex + 1) as TEsotericPoint;
         }
         if(this.FCharacter.GeneralsSoul >= _loc1_.NeedFetch)
         {
            if(this.FOnAddPopTips != null)
            {
               this.FOnAddPopTips(this,CONST_POPTIPS.POPTIP_UpanishadsVolumeLv);
            }
         }
      }
      
      public function ProcessorChangeSkillReq(param1:Object, param2:Object) : void
      {
         this.OnBoxClick(param1,param2);
      }
      
      public function SetupForcePromptFreshGuide(param1:Boolean) : void
      {
         this.FTriggerFreshGuide = param1;
      }
   }
}

