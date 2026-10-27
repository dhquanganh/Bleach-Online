package Processors.Game.Lobby.DailyActivity
{
   import Components.Slots.TUISlot;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DailyActivity.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.TInventories;
   import Logics.Streamization.VoidSoulWorld.TUnstreamizerVoidSoulWorld;
   import Logics.VoidSoulWorld.TVoidSoulWorldData;
   import Processors.Game.Common.Effects.Display.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Rendering.Overlayers.HelpTips.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Overlayers.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorDailyActivity extends TProcessorLobbyWindows
   {
      
      public static const SIZE_WindowDailyActivity_Width:uint = 624;
      
      public static const SIZE_WindowDailyActivity_Height:uint = 478;
      
      public static const MAX_COUNT:uint = 7;
      
      public static const ID_Database_Start:uint = 70200001;
      
      public static const BtnStatus_BeforeOpen:uint = CONST_ORGANIZATION.STATUS_ORGACTIVITY_NotOpen;
      
      public static const BtnStatus_Join:uint = CONST_ORGANIZATION.STATUS_ORGACTIVITY_SignUp;
      
      public static const BtnStatus_Open:uint = CONST_ORGANIZATION.STATUS_ORGACTIVITY_Battle;
      
      public static const BtnStatus_EndOpen:uint = CONST_ORGANIZATION.STATUS_ORGACTIVITY_End;
      
      public static const BtnStatus_Added:uint = CONST_ORGANIZATION.STATUS_ORGACTIVITY_Added;
      
      public static const BtnStatus_EndJoin:uint = CONST_ORGANIZATION.STATUS_ORGACTIVITY_EndJoin;
      
      public static const TYPE_ORGACTIVITY_MUYEGUARD:uint = CONST_ORGANIZATION.TYPE_ORGACTIVITY_MUYEGUARD;
      
      public static const TYPE_ORGACTIVITY_PETBATTLE:uint = CONST_ORGANIZATION.TYPE_ORGACTIVITY_PETBATTLE;
      
      public static const TYPE_ORGACTIVITY_MUYEBATTLE:uint = CONST_ORGANIZATION.TYPE_ORGACTIVITY_MUYEBATTLE;
      
      public static const TYPE_ORGACTIVITY_YUZHIBO:uint = CONST_ORGANIZATION.TYPE_ORGACTIVITY_YUZHIBO;
      
      public static const TYPE_ORGACTIVITY_RIXIANG:uint = CONST_ORGANIZATION.TYPE_ORGACTIVITY_RIXIANG;
      
      public static const TYPE_ORGACTIVITY_QIANSHOU:uint = CONST_ORGANIZATION.TYPE_ORGACTIVITY_QIANSHOU;
      
      public static const TYPE_ORGACTIVITY_TRAITORATTACK:uint = CONST_ORGANIZATION.TYPE_ORGACTIVITY_TRAITORATTACK;
      
      public static const TYPE_ORGACTIVITY_VoidSoulWorld:uint = CONST_ORGANIZATION.TYPE_ORGACTIVITY_VoidSoulWorld;
      
      public static const FilterColor:uint = 16776960;
      
      public static const FilterGlowWidth:int = 4;
      
      public static const FilterGlowStrength:int = 20;
      
      public static const MAX_COUNT_AUTOFIGHT:uint = 2;
      
      protected var FScene:MovieClip;
      
      protected var FBoundsDailyActivity:TBounds;
      
      protected var FSelectTabIndex:uint;
      
      protected var FCurBtnStatus:uint;
      
      protected var FBtn_AutoJoin:MovieClip;
      
      protected var FMC_HelpTip:SimpleButton;
      
      protected var FMC_AutoJoin:MovieClip;
      
      protected var FTF_AutoJoining:TextField;
      
      protected var FTF_VipConfig:TextField;
      
      protected var FDailyActivityBins:TBins;
      
      protected var FCharacter:TCharacter;
      
      protected var FActivityStatusVect:Vector.<uint>;
      
      protected var FIsPetBattleCanJoin:Boolean;
      
      protected var FGlowsFilter:Vector.<TEffectBaseGlowTwo>;
      
      protected var FHitHelp:THint;
      
      protected var FAutoJoinHelpHint:THint;
      
      protected var FHintHeroName:THint;
      
      protected var FAutoHangUpStatusVec:Vector.<uint>;
      
      protected var FAutoSignVec:Vector.<MovieClip>;
      
      protected var FUITab:TUITab;
      
      protected var FTabIndex:int;
      
      protected var FFormatDailyActivityNameVect:Vector.<String>;
      
      protected var FDAAutoInfos:Vector.<TDAAutoInfo>;
      
      protected var FAutoOpenVipLv:uint;
      
      protected var FMC_JoinConfig:Sprite;
      
      protected var FCurType:int;
      
      protected var FMyPetType:uint;
      
      protected var FUnstreamizerVoidSoulWorld:TUnstreamizerVoidSoulWorld;
      
      protected var FVoidSoulWorldData:TVoidSoulWorldData;
      
      protected var FVWHeroBtm:Vector.<Bitmap>;
      
      protected var FVWSlot:Vector.<TUISlot>;
      
      protected var FVoidSoulWorldOpen:Boolean;
      
      protected var FOnEnterFightPet:Function;
      
      protected var FOnEnterOrganizationWar:Function;
      
      protected var FOnJoinOrganizationWar:Function;
      
      protected var FOnEnterCityDefend:Function;
      
      protected var FOnEnterTraitorAttack:Function;
      
      protected var FOnEnterVoidSoulWorld:Function;
      
      protected var FOnShortcutEffect:Function;
      
      protected var FOnTraitorAttackEnd:Function;
      
      public function TProcessorDailyActivity(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FCurBtnStatus = BtnStatus_BeforeOpen;
         this.FCharacter = SLogicsCore.Character;
         this.FVoidSoulWorldData = SLogicsCore.VoidSoulWorldData;
         this.FUnstreamizerVoidSoulWorld = new TUnstreamizerVoidSoulWorld(this.FVoidSoulWorldData);
         this.FAutoHangUpStatusVec = new Vector.<uint>();
         this.FActivityStatusVect = Vector.<uint>([BtnStatus_BeforeOpen,BtnStatus_BeforeOpen,BtnStatus_BeforeOpen,BtnStatus_BeforeOpen,BtnStatus_BeforeOpen,BtnStatus_BeforeOpen,BtnStatus_BeforeOpen,BtnStatus_BeforeOpen,BtnStatus_BeforeOpen,BtnStatus_BeforeOpen]);
         this.FSelectTabIndex = 0;
         this.FTabIndex = 0;
         this.FDAAutoInfos = new Vector.<TDAAutoInfo>(MAX_COUNT_AUTOFIGHT);
         this.FCurType = -1;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_DailyActivity.RESOURCE_DailyActivity);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TEffectBaseGlowTwo = null;
         var _loc3_:uint = 0;
         var _loc4_:TSystemLanguage = null;
         var _loc5_:TVipConfig = null;
         var _loc6_:TBins = null;
         var _loc7_:TDailyActivity = null;
         var _loc8_:Bitmap = null;
         var _loc9_:MovieClip = null;
         var _loc10_:MovieClip = null;
         var _loc11_:TUISlot = null;
         var _loc12_:uint = 0;
         var _loc13_:Vector.<uint> = null;
         var _loc14_:TInventories = null;
         this.FVoidSoulWorldOpen = int(TUtilityLobby.GetObjectByIdentifier(CONST_CONFIGVALUE.VoidSoulWorld_FunctionOpen)) == 1;
         this.FBoundsDailyActivity = new TBounds();
         this.FBoundsDailyActivity.Width = SIZE_WindowDailyActivity_Width;
         this.FBoundsDailyActivity.Height = SIZE_WindowDailyActivity_Height;
         ComponentBoundsCenter(this,this.FBoundsDailyActivity);
         this.FBoundsDailyActivity = null;
         this.FUITab = new TUITab(this);
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_DailyActivity.RESOURCE_ClassName_MC_DailyActivity) as MovieClip;
         addChild(this.FScene);
         this.FDailyActivityBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_DailyActivity);
         this.FGlowsFilter = new Vector.<TEffectBaseGlowTwo>(MAX_COUNT);
         _loc1_ = 0;
         while(_loc1_ < MAX_COUNT)
         {
            _loc2_ = new TEffectBaseGlowTwo();
            _loc2_.SetParameters(this.FScene["mc_tab_" + _loc1_],FilterColor,FilterGlowWidth,FilterGlowStrength);
            this.FGlowsFilter[_loc1_] = _loc2_;
            MovieClip(this.FScene["mc_tab_" + _loc1_]).mouseChildren = false;
            TextField(this.FScene["mc_tab_" + _loc1_]["TF_ActivityName"]).mouseEnabled = false;
            this.FUITab.SetTabByIndex(this.FScene["mc_tab_" + _loc1_],_loc1_);
            if(_loc1_ < this.FDailyActivityBins.Count)
            {
               _loc7_ = this.FDailyActivityBins.GetDatebaseByIndex(_loc1_) as TDailyActivity;
               if(_loc7_ != null)
               {
                  this.FScene["mc_tab_" + _loc1_]["TF_ActivityName"].text = _loc7_.ActivityName.toString();
               }
               else
               {
                  this.FScene["mc_tab_" + _loc1_]["TF_ActivityName"].text = "";
               }
            }
            _loc1_++;
         }
         _loc9_ = this.FScene.MC_VoidSoulWorldDesc;
         this.FVWHeroBtm = new Vector.<Bitmap>(CONST_VOIDSOULWORLD.COUNT_SpecialHero);
         this.FVWSlot = new Vector.<TUISlot>(CONST_VOIDSOULWORLD.COUNT_RandomReward);
         _loc1_ = 0;
         while(_loc1_ < CONST_VOIDSOULWORLD.COUNT_SpecialHero)
         {
            _loc8_ = new Bitmap();
            _loc10_ = _loc9_["MC_Head_" + _loc1_].MC_Bmp_Icon;
            _loc10_.addChild(_loc8_);
            _loc10_.addEventListener(MouseEvent.MOUSE_MOVE,this.OnHeadMove);
            _loc10_.addEventListener(MouseEvent.MOUSE_OUT,this.OnHeadOut);
            _loc10_.Tag = _loc1_;
            this.FVWHeroBtm[_loc1_] = _loc8_;
            _loc1_++;
         }
         _loc13_ = TUtilityLobby.GetObjectByIdentifier(CONST_CONFIGVALUE.VoidSoulWorld_RandomReward) as Vector.<uint>;
         _loc14_ = new TInventories();
         _loc1_ = 0;
         while(_loc1_ < CONST_VOIDSOULWORLD.COUNT_RandomReward)
         {
            _loc11_ = new TUISlot(this);
            _loc11_.Resource = _loc9_["MC_Slot_" + _loc1_];
            _loc11_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc11_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc11_);
            _loc11_.OnQuerySubscript = null;
            _loc11_.Init();
            if(_loc1_ < _loc13_.length)
            {
               _loc12_ = _loc13_[_loc1_];
               SToolReward.GetInventoryByID(_loc12_,_loc14_);
               _loc11_.Context = _loc14_.GetInventoryByIndex(_loc1_);
            }
            else
            {
               _loc11_.Context = null;
            }
            this.FVWSlot[_loc1_] = _loc11_;
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.ProcessorTabOnSwitch;
         this.FUITab.Init();
         this.UpdataUI();
         this.FTF_AutoJoining = this.FScene["tf_autojoining"];
         this.FTF_AutoJoining.visible = false;
         this.FMC_JoinConfig = this.FScene["mc_joinConfig"];
         this.FMC_JoinConfig.visible = false;
         this.FScene["mc_joinConfig"]["tf_vipConfig"].visible = false;
         this.FBtn_AutoJoin = this.FMC_JoinConfig["mc_autoJoin"]["Btn_AutoJoin"];
         this.FMC_HelpTip = this.FMC_JoinConfig["mc_autoJoin"]["MC_HelpTip"];
         this.FMC_AutoJoin = this.FMC_JoinConfig["mc_autoJoin"];
         this.FTF_VipConfig = this.FMC_JoinConfig["tf_vipConfig"];
         this.FTF_VipConfig.visible = false;
         _loc6_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_VipConfig) as TBins;
         _loc3_ = uint(_loc6_.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            _loc5_ = _loc6_.GetDatebaseByIndex(_loc1_) as TVipConfig;
            if(Boolean(_loc5_.AutoJoinActivity))
            {
               this.FAutoOpenVipLv = _loc5_.Identifier;
               break;
            }
            _loc1_++;
         }
         this.FTF_VipConfig.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYACTIVITY_STRING_03),_loc5_.Identifier);
         this.FAutoSignVec = new Vector.<MovieClip>();
         _loc3_ = MAX_COUNT;
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            this.FAutoSignVec[_loc1_] = this.FScene["MC_AutoSign_" + _loc1_] as MovieClip;
            this.FAutoSignVec[_loc1_].mouseChildren = false;
            this.FAutoSignVec[_loc1_].mouseEnabled = false;
            this.FAutoSignVec[_loc1_].visible = false;
            _loc1_++;
         }
         this.FFormatDailyActivityNameVect = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_65);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TSystemLanguage = null;
         var _loc3_:TDailyActivity = null;
         this.FScene.btn_close.addEventListener(MouseEvent.CLICK,this.OnCloseWindow);
         this.FScene.btn_help.addEventListener(MouseEvent.MOUSE_MOVE,this.OnHintHelpMove);
         this.FScene.btn_help.addEventListener(MouseEvent.ROLL_OUT,this.OnHintHelpOut);
         this.FScene.btn_join.addEventListener(MouseEvent.CLICK,this.OnFunctionBtnClick);
         TGameUtil.setButtonMode(this.FScene.btn_join,true);
         TextField(this.FScene.btn_join.tf_btnInfo).mouseEnabled = false;
         _loc1_ = 0;
         while(_loc1_ < MAX_COUNT)
         {
            if(_loc1_ < this.FDailyActivityBins.Count)
            {
               this.FUITab.SetTabShowByIndex(_loc1_);
               _loc3_ = this.FDailyActivityBins.GetDatebaseByIndex(_loc1_) as TDailyActivity;
               if(_loc3_ != null)
               {
                  this.FUITab.SetTabCaptionByIndex(_loc3_.ActivityName,_loc1_);
               }
               else
               {
                  this.FUITab.SetTabCaptionByIndex("",_loc1_);
               }
            }
            else
            {
               this.FUITab.SetTabHideByIndex(_loc1_);
               this.FUITab.SetTabCaptionByIndex(this.FFormatDailyActivityNameVect[_loc1_ + 1],_loc1_);
            }
            _loc1_++;
         }
         this.FHitHelp = new THint();
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,CONST_SYSTEMLANGUAGE.HELPTIPS_DAILYACTIVITION) as TSystemLanguage;
         if(_loc2_ != null)
         {
            this.FHitHelp.Content = _loc2_.Desc;
         }
         else
         {
            this.FHitHelp.Content = "";
         }
         this.FAutoJoinHelpHint = new THint();
         this.FBtn_AutoJoin.addEventListener(MouseEvent.CLICK,this.SelectOnClick,false,0,true);
         this.FMC_HelpTip.addEventListener(MouseEvent.MOUSE_MOVE,this.HelpTipOnMove,false,0,true);
         this.FMC_HelpTip.addEventListener(MouseEvent.MOUSE_OUT,this.HelpTipOnOut,false,0,true);
         this.FHintHeroName = new THint();
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_DailyActivity_AutomaticStatusRet,this.PerformPacket_SC_StatusRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_DailyActivity_AutomaticOperateRet,this.PerformPacket_SC_OperateRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_DailyActivity_DailyRewardRet,this.PerformPacket_SC_DailyRewardRet);
         super.PacketRegisterRoutines();
      }
      
      protected function PerformPacket_SC_StatusRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TDAAutoInfo = null;
         var _loc6_:uint = 0;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         _loc2_ = param1.Data;
         if(this.FDAAutoInfos[0] != null)
         {
            _loc4_ = _loc2_.readShort();
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc6_ = uint(_loc2_.readByte());
               _loc5_ = this.GetInfoByType(_loc6_);
               if(_loc5_ == null)
               {
                  _loc5_ = new TDAAutoInfo();
                  _loc5_.Type = _loc6_;
                  _loc5_.IsSign = Boolean(_loc2_.readByte());
                  _loc5_.CanSign = Boolean(_loc2_.readByte());
                  _loc5_.Silver = _loc2_.readUnsignedInt();
                  _loc5_.Exp = _loc2_.readUnsignedInt();
                  this.FDAAutoInfos[_loc3_] = _loc5_;
               }
               else
               {
                  _loc5_.IsSign = Boolean(_loc2_.readByte());
                  _loc5_.CanSign = Boolean(_loc2_.readByte());
                  _loc5_.Silver = _loc2_.readUnsignedInt();
                  _loc5_.Exp = _loc2_.readUnsignedInt();
                  this.SetInfo(_loc5_);
               }
               _loc3_++;
            }
         }
         else
         {
            _loc4_ = _loc2_.readShort();
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = new TDAAutoInfo();
               _loc5_.Type = _loc2_.readByte();
               _loc5_.IsSign = Boolean(_loc2_.readByte());
               _loc5_.CanSign = Boolean(_loc2_.readByte());
               _loc5_.Silver = _loc2_.readUnsignedInt();
               _loc5_.Exp = _loc2_.readUnsignedInt();
               this.FDAAutoInfos[_loc3_] = _loc5_;
               _loc3_++;
            }
         }
         this.FMyPetType = TYPE_ORGACTIVITY_PETBATTLE + this.FCharacter.Country + 1;
         if(!this.Visible)
         {
            return;
         }
         this.TabSelectAutoFight();
      }
      
      protected function PerformPacket_SC_DailyRewardRet(param1:TPacket) : void
      {
         this.FUnstreamizerVoidSoulWorld.DailyRewardRet(param1.Data);
         this.UpdateDailyReward();
      }
      
      protected function PerformPacket_SC_OperateRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = uint(_loc2_.readByte());
         _loc7_ = Boolean(_loc2_.readByte());
         _loc6_ = int(this.FDAAutoInfos.length);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            if(this.FDAAutoInfos[_loc5_].Type == _loc4_)
            {
               this.FDAAutoInfos[_loc5_].IsSign = _loc7_;
               break;
            }
            _loc5_++;
         }
      }
      
      protected function PerformPacket_CS_StatusReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_DailyActivity_AutomaticStatusReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function PerformPacket_CS_OperateReq(param1:TDAAutoInfo) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_DailyActivity_AutomaticOperateReq);
         _loc2_ = _loc3_.Data;
         _loc2_.writeByte(param1.Type);
         _loc2_.writeByte(int(param1.IsSign));
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:TUISlot = null;
         super.LogicsPerform();
         if(this.Visible)
         {
            this.UpdateTabEffect();
            for each(_loc1_ in this.FVWSlot)
            {
               _loc1_.Update();
            }
         }
      }
      
      protected function UpdataUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TDailyActivity = null;
         if(this.FScene == null)
         {
            return;
         }
         if(this.FSelectTabIndex > this.FDailyActivityBins.Count)
         {
            this.FSelectTabIndex = 0;
         }
         _loc2_ = this.FDailyActivityBins.GetDatebaseByIdentifier(ID_Database_Start + this.FSelectTabIndex) as TDailyActivity;
         this.FScene.mc_baseInfo.tf_name.text = _loc2_.ActivityName;
         this.FScene.mc_baseInfo.tf_timeDesc.text = _loc2_.ActivityTimeVect[0];
         this.FScene.mc_baseInfo.tf_time.text = _loc2_.ActivityTimeVect[1];
         this.FScene.tf_desc.text = _loc2_.ActivityDescription;
         this.FScene.tf_awardDesc.text = _loc2_.ActivityRewards;
         this.FScene.mc_bg.gotoAndStop(this.FSelectTabIndex + 1);
         if(this.FSelectTabIndex < TYPE_ORGACTIVITY_PETBATTLE)
         {
            this.FScene.mc_bg.gotoAndStop(this.FSelectTabIndex + 1);
         }
         this.FIsPetBattleCanJoin = true;
         if(_loc2_.ActivityType == TYPE_ORGACTIVITY_PETBATTLE)
         {
            this.FCurBtnStatus = this.FActivityStatusVect[TYPE_ORGACTIVITY_YUZHIBO + this.FSelectTabIndex];
            if(this.FActivityStatusVect[TYPE_ORGACTIVITY_YUZHIBO + this.FCharacter.Country - 1] == BtnStatus_Open)
            {
               this.FIsPetBattleCanJoin = false;
            }
         }
         else
         {
            this.FCurBtnStatus = this.FActivityStatusVect[_loc2_.ActivityType];
            if(_loc2_.ActivityType == TYPE_ORGACTIVITY_MUYEGUARD)
            {
               this.FCurBtnStatus = BtnStatus_Open;
            }
         }
         this.FScene.btn_join.tf_btnInfo.text = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRINGS_ACTIVITYSTATE)[this.FCurBtnStatus];
         if(_loc2_.ActivityType == TYPE_ORGACTIVITY_MUYEGUARD)
         {
            this.FScene.btn_join.tf_btnInfo.text = "Tham gia";
         }
         TGameUtil.setButtonMode(this.FScene.btn_join,this.CheckStatusIsBtn());
         this.FScene.mc_tabPage.visible = false;
         this.UpdateVoidSoulWorldUI(_loc2_);
         this.FScene.mc_tab_6.visible = this.FVoidSoulWorldOpen;
      }
      
      protected function UpdateDailyReward() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Bitmap = null;
         var _loc3_:uint = 0;
         var _loc4_:TRoleModel = null;
         var _loc5_:uint = 0;
         var _loc6_:TUISlot = null;
         _loc1_ = 0;
         while(_loc1_ < CONST_VOIDSOULWORLD.COUNT_SpecialHero)
         {
            _loc2_ = this.FVWHeroBtm[_loc1_];
            _loc2_.bitmapData = null;
            _loc1_++;
         }
         _loc5_ = this.FVoidSoulWorldData.Form.SpecialHeroID.length;
         _loc1_ = 0;
         while(_loc1_ < _loc5_)
         {
            _loc3_ = this.FVoidSoulWorldData.Form.SpecialHeroID[_loc1_];
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc3_) as TRoleModel;
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc4_.RoleHead,this.RoleHeadLoadOK);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < CONST_VOIDSOULWORLD.COUNT_RandomReward)
         {
            _loc6_ = this.FVWSlot[_loc1_];
            if(_loc6_.Context != null)
            {
               if(_loc1_ == this.FVoidSoulWorldData.RewardIndex)
               {
                  _loc6_.SetDefaultFilters(false);
               }
               else
               {
                  _loc6_.SetDefaultFilters(true);
               }
            }
            _loc1_++;
         }
      }
      
      protected function UpdateVoidSoulWorldUI(param1:TDailyActivity) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = this.FScene.MC_VoidSoulWorldDesc;
         if(this.FSelectTabIndex == 6)
         {
            _loc2_.visible = true;
            _loc2_.TF_Desc.text = param1.ActivityDescription;
            _loc4_ = uint(TUtilityLobby.GetObjectByIdentifier(CONST_CONFIGVALUE.VoidSoulWorld_OpenLevel));
            if(SLogicsCore.Character.GetMainLevel() >= _loc4_)
            {
               TGameUtil.setButtonMode(this.FScene.btn_join,true);
            }
            else
            {
               TGameUtil.setButtonMode(this.FScene.btn_join,false);
            }
            this.FScene.btn_join.visible = true;
            this.FScene.btn_join.tf_btnInfo.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_26);
         }
         else
         {
            _loc2_.visible = false;
         }
      }
      
      protected function CheckTabEffect() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < MAX_COUNT)
         {
            if(_loc1_ == 0)
            {
               _loc2_ = _loc1_ + TYPE_ORGACTIVITY_YUZHIBO;
            }
            else if(_loc1_ == 3)
            {
               _loc2_ = TYPE_ORGACTIVITY_MUYEBATTLE;
            }
            else if(_loc1_ == 4)
            {
               _loc2_ = TYPE_ORGACTIVITY_MUYEGUARD;
            }
            else if(_loc1_ == 5)
            {
               _loc2_ = TYPE_ORGACTIVITY_TRAITORATTACK;
            }
            else if(_loc1_ == 6)
            {
               _loc2_ = TYPE_ORGACTIVITY_VoidSoulWorld;
            }
            if(this.FActivityStatusVect[_loc2_] == BtnStatus_Open || this.FActivityStatusVect[_loc2_] == BtnStatus_Join)
            {
               this.FGlowsFilter[_loc1_].IsRunOver = false;
            }
            else
            {
               this.FGlowsFilter[_loc1_].Stop();
            }
            _loc1_++;
         }
      }
      
      protected function UpdateTabEffect() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TEffectBaseGlowTwo = null;
         if(this.FGlowsFilter == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FGlowsFilter.length)
         {
            _loc2_ = this.FGlowsFilter[_loc1_];
            if(!_loc2_.IsRunOver)
            {
               _loc2_.Run();
            }
            _loc1_++;
         }
      }
      
      protected function CheckStatusIsBtn() : Boolean
      {
         if(!this.FIsPetBattleCanJoin && this.FCharacter.Country - 1 != this.FSelectTabIndex)
         {
            return false;
         }
         if(this.FCurBtnStatus == BtnStatus_Open || this.FCurBtnStatus == BtnStatus_Join)
         {
            return true;
         }
         return false;
      }
      
      protected function GetDailyActivity() : int
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FActivityStatusVect.length)
         {
            if(this.FActivityStatusVect[_loc1_] == BtnStatus_Open || this.FActivityStatusVect[_loc1_] == BtnStatus_Join)
            {
               if(_loc1_ == TYPE_ORGACTIVITY_TRAITORATTACK)
               {
                  return 5;
               }
               if(_loc1_ == TYPE_ORGACTIVITY_VoidSoulWorld)
               {
                  return 6;
               }
               if(_loc1_ >= TYPE_ORGACTIVITY_YUZHIBO)
               {
                  if(this.FActivityStatusVect[TYPE_ORGACTIVITY_YUZHIBO + this.FCharacter.Country - 1] == BtnStatus_Open)
                  {
                     return this.FCharacter.Country - 1;
                  }
                  return _loc1_ - TYPE_ORGACTIVITY_YUZHIBO;
               }
               if(_loc1_ == TYPE_ORGACTIVITY_MUYEGUARD)
               {
                  return 4;
               }
               if(_loc1_ == TYPE_ORGACTIVITY_MUYEBATTLE)
               {
                  return 3;
               }
            }
            _loc1_++;
         }
         return -1;
      }
      
      protected function UpdateAutoFight(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FDAAutoInfos.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1 == this.FDAAutoInfos[_loc2_].Type)
            {
               this.UpdateUIAutoFight(this.FDAAutoInfos[_loc2_]);
               break;
            }
            this.FMC_JoinConfig.visible = false;
            this.FTF_VipConfig.visible = false;
            _loc2_++;
         }
      }
      
      protected function UpdateUIAutoFight(param1:TDAAutoInfo) : void
      {
         this.FMC_JoinConfig.visible = true;
         if(this.FCharacter.VipLevel >= this.FAutoOpenVipLv)
         {
            this.FTF_VipConfig.visible = false;
            this.FMC_AutoJoin.visible = true;
            if(!param1.CanSign)
            {
               this.FMC_AutoJoin.filters = [TUtilityFilter.GaryColorFilters];
               if(param1.IsSign)
               {
                  this.FBtn_AutoJoin.gotoAndStop(2);
                  this.FTF_AutoJoining.visible = true;
                  this.FScene.btn_join.visible = false;
               }
               else
               {
                  this.FBtn_AutoJoin.gotoAndStop(1);
                  this.FTF_AutoJoining.visible = false;
                  this.FScene.btn_join.visible = true;
               }
            }
            else
            {
               this.FMC_AutoJoin.filters = [];
               this.FTF_AutoJoining.visible = false;
               if(param1.IsSign)
               {
                  this.FBtn_AutoJoin.gotoAndStop(2);
               }
               else
               {
                  this.FBtn_AutoJoin.gotoAndStop(1);
               }
               this.FScene.btn_join.visible = true;
            }
         }
         else
         {
            this.FTF_VipConfig.visible = true;
            this.FMC_AutoJoin.visible = false;
         }
      }
      
      protected function GetInfoByType(param1:uint) : TDAAutoInfo
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FDAAutoInfos.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FDAAutoInfos[_loc2_] == null)
            {
               return null;
            }
            if(this.FDAAutoInfos[_loc2_].Type == param1)
            {
               return this.FDAAutoInfos[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      protected function SetInfo(param1:TDAAutoInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.FDAAutoInfos.length <= 0)
         {
            return;
         }
         _loc3_ = int(this.FDAAutoInfos.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FDAAutoInfos[_loc2_].Type == param1.Type)
            {
               this.FDAAutoInfos[_loc2_] = param1;
               break;
            }
            _loc2_++;
         }
      }
      
      protected function OnCloseWindow(param1:MouseEvent) : void
      {
         ProcessorClose();
      }
      
      protected function OnFunctionBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:TDailyActivity = null;
         if(Boolean(param1.currentTarget) && !param1.currentTarget.buttonMode)
         {
            return;
         }
         _loc2_ = this.FDailyActivityBins.GetDatebaseByIdentifier(ID_Database_Start + this.FSelectTabIndex) as TDailyActivity;
         switch(_loc2_.ActivityType)
         {
            case TYPE_ORGACTIVITY_PETBATTLE:
               if(this.FOnEnterFightPet != null)
               {
                  this.FOnEnterFightPet(this,this.FSelectTabIndex + 1);
               }
               break;
            case TYPE_ORGACTIVITY_MUYEBATTLE:
               if(this.FActivityStatusVect[TYPE_ORGACTIVITY_MUYEBATTLE] == BtnStatus_Join)
               {
                  if(this.FOnJoinOrganizationWar != null)
                  {
                     this.FOnJoinOrganizationWar(this,CONST_ORGANIZATIONALWAR.CommandID_SignUp,0,null);
                  }
               }
               else if(this.FOnEnterOrganizationWar != null)
               {
                  this.FOnEnterOrganizationWar(this);
               }
               break;
            case TYPE_ORGACTIVITY_MUYEGUARD:
               if(this.FOnEnterCityDefend != null)
               {
                  this.FOnEnterCityDefend(this);
               }
               break;
            case TYPE_ORGACTIVITY_TRAITORATTACK:
               if(this.FOnEnterTraitorAttack != null)
               {
                  this.FOnEnterTraitorAttack(this);
               }
               break;
            case TYPE_ORGACTIVITY_VoidSoulWorld:
               if(this.FOnEnterVoidSoulWorld != null)
               {
                  this.FOnEnterVoidSoulWorld(this);
               }
         }
         ProcessorClose();
      }
      
      protected function ProcessorTabOnSwitch(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         _loc2_ = param1 as int;
         if(this.FTabIndex == _loc2_)
         {
            return;
         }
         this.FTabIndex = _loc2_;
         this.FSelectTabIndex = this.FTabIndex;
         this.TabSelectAutoFight();
         this.UpdataUI();
      }
      
      protected function OnHintHelpMove(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHitHelp);
      }
      
      protected function OnHintHelpOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHitHelp);
      }
      
      protected function HelpTipOnMove(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TDAAutoInfo = null;
         if(this.FCurType == -1)
         {
            return;
         }
         if(this.FCurType == TYPE_ORGACTIVITY_TRAITORATTACK)
         {
            _loc5_ = this.GetInfoByType(TYPE_ORGACTIVITY_TRAITORATTACK);
            if(_loc5_ == null)
            {
               return;
            }
            _loc3_ = _loc5_.Exp;
            _loc4_ = _loc5_.Silver;
            _loc2_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FIGHTPET_STRING_11),_loc4_,_loc3_);
         }
         else if(this.FCurType == this.FMyPetType)
         {
            _loc5_ = this.GetInfoByType(this.FMyPetType);
            if(_loc5_ == null)
            {
               return;
            }
            _loc3_ = _loc5_.Exp;
            _loc4_ = _loc5_.Silver;
            _loc2_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FIGHTPET_STRING_10),_loc4_,_loc3_);
         }
         this.FAutoJoinHelpHint.Caption = _loc2_;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FAutoJoinHelpHint);
      }
      
      protected function HelpTipOnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FAutoJoinHelpHint);
      }
      
      protected function TabSelectAutoFight() : void
      {
         var _loc1_:TDailyActivity = null;
         _loc1_ = this.FDailyActivityBins.GetDatebaseByIdentifier(ID_Database_Start + this.FSelectTabIndex) as TDailyActivity;
         if(_loc1_.ActivityType == TYPE_ORGACTIVITY_PETBATTLE)
         {
            if(this.FMyPetType == TYPE_ORGACTIVITY_PETBATTLE + this.FSelectTabIndex + 2)
            {
               this.FCurType = this.FMyPetType;
               this.UpdateAutoFight(this.FMyPetType);
               return;
            }
         }
         else
         {
            if(_loc1_.ActivityType == TYPE_ORGACTIVITY_TRAITORATTACK)
            {
               this.FCurType = TYPE_ORGACTIVITY_TRAITORATTACK;
               this.UpdateAutoFight(this.FCurType);
               return;
            }
            if(_loc1_.ActivityType == TYPE_ORGACTIVITY_VoidSoulWorld)
            {
               this.FCurType = TYPE_ORGACTIVITY_VoidSoulWorld;
            }
         }
         this.FMC_JoinConfig.visible = false;
         this.FTF_AutoJoining.visible = false;
      }
      
      protected function SelectOnClick(param1:MouseEvent) : void
      {
         var _loc2_:TDAAutoInfo = null;
         _loc2_ = this.GetInfoByType(this.FCurType);
         if(!_loc2_.CanSign)
         {
            return;
         }
         if(this.FBtn_AutoJoin.currentFrame == 2)
         {
            this.FBtn_AutoJoin.gotoAndStop(1);
            if(_loc2_ != null)
            {
               _loc2_.IsSign = false;
            }
         }
         else
         {
            this.FBtn_AutoJoin.gotoAndStop(2);
            if(_loc2_ != null)
            {
               _loc2_.IsSign = true;
            }
         }
         if(this.FCurType != -1)
         {
            this.PerformPacket_CS_OperateReq(_loc2_);
         }
      }
      
      protected function RoleHeadLoadOK(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TRoleModel = null;
         var _loc7_:uint = 0;
         var _loc8_:Bitmap = null;
         _loc5_ = this.FVoidSoulWorldData.Form.SpecialHeroID.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = this.FVoidSoulWorldData.Form.SpecialHeroID[_loc4_];
            _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc7_) as TRoleModel;
            if(param3 == _loc6_.RoleHead)
            {
               _loc8_ = this.FVWHeroBtm[_loc4_];
               _loc8_.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            }
            _loc4_++;
         }
      }
      
      protected function OnHeadMove(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TBaseHero = null;
         _loc2_ = uint(param1.currentTarget.Tag);
         _loc3_ = this.FVoidSoulWorldData.Form.SpecialHeroID[_loc2_];
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,_loc3_) as TBaseHero;
         this.FHintHeroName.Caption = _loc4_.Name;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHintHeroName);
      }
      
      protected function OnHeadOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHintHeroName);
      }
      
      public function set OnEnterFightPet(param1:Function) : void
      {
         this.FOnEnterFightPet = param1;
      }
      
      public function get OnEnterFightPet() : Function
      {
         return this.FOnEnterFightPet;
      }
      
      public function set OnEnterOrganizationWar(param1:Function) : void
      {
         this.FOnEnterOrganizationWar = param1;
      }
      
      public function get OnEnterOrganizationWar() : Function
      {
         return this.FOnEnterOrganizationWar;
      }
      
      public function set OnJoinOrganizationWar(param1:Function) : void
      {
         this.FOnJoinOrganizationWar = param1;
      }
      
      public function get OnJoinOrganizationWar() : Function
      {
         return this.FOnJoinOrganizationWar;
      }
      
      public function set OnEnterCityDefend(param1:Function) : void
      {
         this.FOnEnterCityDefend = param1;
      }
      
      public function get OnEnterCityDefend() : Function
      {
         return this.FOnEnterCityDefend;
      }
      
      public function set OnEnterTraitorAttack(param1:Function) : void
      {
         this.FOnEnterTraitorAttack = param1;
      }
      
      public function get OnEnterTraitorAttack() : Function
      {
         return this.FOnEnterTraitorAttack;
      }
      
      public function set OnShortcutEffect(param1:Function) : void
      {
         this.FOnShortcutEffect = param1;
      }
      
      public function get OnShortcutEffect() : Function
      {
         return this.FOnShortcutEffect;
      }
      
      public function set OnTraitorAttackEnd(param1:Function) : void
      {
         this.FOnTraitorAttackEnd = param1;
      }
      
      public function get OnTraitorAttackEnd() : Function
      {
         return this.FOnTraitorAttackEnd;
      }
      
      public function get OnEnterVoidSoulWorld() : Function
      {
         return this.FOnEnterVoidSoulWorld;
      }
      
      public function set OnEnterVoidSoulWorld(param1:Function) : void
      {
         this.FOnEnterVoidSoulWorld = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.FSelectTabIndex = Math.max(this.GetDailyActivity(),0);
         this.FTabIndex = this.FSelectTabIndex;
         this.FUITab.SwithTagManual(this.FSelectTabIndex);
         this.UpdataUI();
         this.CheckTabEffect();
         this.PerformPacket_CS_StatusReq();
         if(this.FVoidSoulWorldOpen)
         {
            this.FUnstreamizerVoidSoulWorld.DailyRewardReq();
         }
      }
      
      override public function Unmount() : void
      {
      }
      
      public function SetActivityStatus(param1:uint, param2:uint) : void
      {
         var _loc3_:TDAAutoInfo = null;
         this.FActivityStatusVect[param1] = param1 == TYPE_ORGACTIVITY_MUYEGUARD ? BtnStatus_Open : param2;
         if(param1 == TYPE_ORGACTIVITY_PETBATTLE)
         {
            this.FActivityStatusVect[TYPE_ORGACTIVITY_YUZHIBO] = param2;
            this.FActivityStatusVect[TYPE_ORGACTIVITY_RIXIANG] = param2;
            this.FActivityStatusVect[TYPE_ORGACTIVITY_QIANSHOU] = param2;
         }
         if(this.Visible)
         {
            this.UpdataUI();
            this.CheckTabEffect();
         }
         if(this.FOnShortcutEffect != null)
         {
            this.FOnShortcutEffect(CONST_SHORTCUTS.POSITION_SecondaryFunctionA,CONST_SHORTCUTS.TYPE_SecondaryFunctionA_DailyActivity,this.GetDailyActivity() >= 0);
         }
         if(param1 == TYPE_ORGACTIVITY_TRAITORATTACK && param2 == BtnStatus_EndOpen)
         {
            if(this.Visible)
            {
               _loc3_ = this.GetInfoByType(TYPE_ORGACTIVITY_TRAITORATTACK);
               _loc3_.CanSign = true;
               _loc3_.IsSign = false;
               this.TabSelectAutoFight();
            }
            this.FOnTraitorAttackEnd(this);
         }
         if(param2 == BtnStatus_EndOpen && param1 == TYPE_ORGACTIVITY_PETBATTLE)
         {
            if(this.Visible)
            {
               _loc3_ = this.GetInfoByType(this.FMyPetType);
               _loc3_.CanSign = true;
               _loc3_.IsSign = false;
               this.TabSelectAutoFight();
            }
         }
      }
   }
}

