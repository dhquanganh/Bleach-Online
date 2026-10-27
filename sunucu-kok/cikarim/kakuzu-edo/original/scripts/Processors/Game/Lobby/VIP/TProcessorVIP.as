package Processors.Game.Lobby.VIP
{
   import Components.ScrollBar.*;
   import Components.Standard.*;
   import Externals.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Agent.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Signals.*;
   import Logics.Spaces.LogicsSpace;
   import Logics.Streamization.Vip.*;
   import Logics.Vip.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Lobby.VIP.Component.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   import ghostcat.operation.*;
   import ghostcat.util.easing.*;
   
   use namespace LogicsSpace;
   
   public class TProcessorVIP extends TProcessorLobbyWindows
   {
      
      public static const SIZE_WindowVIP_Width:uint = 796;
      
      public static const SIZE_WindowVIP_Height:uint = 542;
      
      public static const SIGNALDESTINATION_COUNTER_VIP_Req:uint = CONST_SIGNAL.SIGNALDESTINATION_COUNTER_VIP_Req;
      
      public static const SIGNALDESTINATION_COUNTER_VIP_Ret:uint = CONST_SIGNAL.SIGNALDESTINATION_COUNTER_VIP_Ret;
      
      public static const KEY_VIP_ReceiveState:uint = CONST_COUNTER.KEY_VIP_ReceiveState;
      
      protected static const STRING_Keys:Vector.<String> = STRING_VIP.STRING_Keys;
      
      protected static const TYPE_Item:Vector.<uint> = CONST_VIP.TYPE_Item;
      
      protected static const STATE_ForbidReceive:int = -1;
      
      protected static const STATE_UnReceive:int = 0;
      
      protected static const STATE_Received:int = 1;
      
      protected static const RENDERINGSTATE_Normal:int = 1;
      
      protected static const RENDERINGSTATE_Disabled:int = 4;
      
      protected static const RENDERINGSTATE_EFFECT:int = 5;
      
      protected var FHelpTips:THint;
      
      protected var FRepeatOper:RepeatOper;
      
      protected var FTweenOperIn:TweenOper;
      
      protected var FTweenOperOut:TweenOper;
      
      protected var FUnstreamizerVip:TUnstreamizerVip;
      
      protected var FMC_VIP:Sprite;
      
      protected var FTF_CurrentLevel:TextField;
      
      protected var FTF_PayMoney:TextField;
      
      protected var FTF_NextLevel:TextField;
      
      protected var FTF_EXP:TextField;
      
      protected var FTF_CurrentCoupons:TextField;
      
      protected var FTF_CurrentLevelRight:TextField;
      
      protected var FTF_NextLevelCoupons:TextField;
      
      protected var FSP_ExpBar:Sprite;
      
      protected var FBtn_ReceiveAwards:TUIButton;
      
      protected var FMC_Effect:MovieClip;
      
      protected var FMC_List:MovieClip;
      
      protected var FBT_Recharge:SimpleButton;
      
      protected var FBtn_Help:SimpleButton;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FUIDataBars:Vector.<TUIDataBar>;
      
      protected var FBoundsVIP:TBounds;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FVipConfigs:TBins;
      
      protected var FCharacter:TCharacter;
      
      protected var FVipData:TVip;
      
      protected var FColumnsCount:int;
      
      protected var FRowsCount:int;
      
      protected var FVipLevel:int;
      
      protected var FTF_CurrentExp:int;
      
      protected var FReceiveState:int;
      
      protected var FInitialization:Boolean;
      
      protected var FORMAT_Level:String;
      
      protected var FOnEffectBaseGlowVIP:Function;
      
      public function TProcessorVIP(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FHelpTips = new THint();
         this.ConstructTweens();
         this.FUnstreamizerVip = new TUnstreamizerVip();
         this.FBoundsVIP = new TBounds();
         this.FBoundsVIP.Width = SIZE_WindowVIP_Width;
         this.FBoundsVIP.Height = SIZE_WindowVIP_Height;
         ComponentBoundsCenter(this,this.FBoundsVIP);
         this.FBoundsVIP = null;
         this.FCharacter = SLogicsCore.Character;
         this.FVipData = SLogicsCore.Character.VipData;
         this.FVipLevel = -1;
         this.FTF_CurrentExp = -1;
         this.FReceiveState = STATE_ForbidReceive;
         this.FInitialization = false;
      }
      
      protected function ConstructTweens() : void
      {
         this.FRepeatOper = new RepeatOper();
         this.FTweenOperIn = new TweenOper();
         this.FTweenOperOut = new TweenOper();
         this.FTweenOperIn.duration = 10;
         this.FTweenOperOut.duration = 3000;
         this.FRepeatOper.loop = 1;
         this.FRepeatOper.children = [this.FTweenOperIn,this.FTweenOperOut];
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_VIP.RESOURCESID_VIP);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:Sprite = null;
         var _loc5_:TUIDataBar = null;
         var _loc6_:Vector.<String> = null;
         this.FMC_VIP = TUtilityReflection.CreateDisplayObjectInstance(CONST_VIP.RESOURCE_ClassName_VIP) as Sprite;
         addChild(this.FMC_VIP);
         this.FBtn_Help = this.FMC_VIP[CONST_COMMON.RESOURCE_Link_Btn_Help];
         this.FBtn_Close = this.FMC_VIP[CONST_COMMON.RESOURCE_Link_Btn_Close];
         _loc4_ = this.FMC_VIP[CONST_VIP.RESOURCE_Link_MC_EXP];
         this.FSP_ExpBar = _loc4_[CONST_VIP.RESOURCE_Link_MC_EXPBar];
         this.FSP_ExpBar.x = 0 - this.FSP_ExpBar.width;
         this.FTF_CurrentLevel = this.FMC_VIP[CONST_VIP.RESOURCE_Link_TF_CurrentLevel];
         this.FTF_CurrentLevelRight = this.FMC_VIP[CONST_VIP.RESOURCE_Link_TF_CurrentLevelRight];
         this.FTF_EXP = this.FMC_VIP[CONST_VIP.RESOURCE_Link_TF_EXP];
         this.FTF_NextLevel = this.FMC_VIP[CONST_VIP.RESOURCE_Link_TF_NextLevel];
         this.FTF_NextLevelCoupons = this.FMC_VIP[CONST_VIP.RESOURCE_Link_TF_NextLevelCoupons];
         this.FTF_PayMoney = this.FMC_VIP[CONST_VIP.RESOURCE_Link_TF_PayMoney];
         this.FTF_CurrentCoupons = this.FMC_VIP[CONST_VIP.RESOURCE_Link_TF_CurrentCoupons];
         this.FMC_Effect = this.FMC_VIP[CONST_VIP.RESOURCE_Link_MC_Effect];
         this.FMC_Effect.visible = false;
         this.FMC_Effect.stop();
         this.FBtn_ReceiveAwards = new TUIButton();
         this.FBtn_ReceiveAwards.Substrate = this.FMC_VIP[CONST_VIP.RESOURCE_Link_MC_ReceiveAwards];
         this.FBtn_ReceiveAwards.IsFilter = true;
         this.FBtn_ReceiveAwards.OnClick = this.BtnReceiveAwardsOnClick;
         this.FMC_List = this.FMC_VIP[CONST_VIP.RESOURCE_Link_mc_list];
         this.FScrollBar = new TScrollBar(this.FMC_List,294,false,0,23);
         this.FVipConfigs = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_VipConfig);
         _loc6_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.VIP_STRING_07);
         this.FColumnsCount = this.FVipConfigs.Count - 1;
         this.FRowsCount = _loc6_.length;
         this.FScrollBar.Clear();
         _loc2_ = uint(this.FRowsCount);
         this.FUIDataBars = new Vector.<TUIDataBar>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_VIP.RESOURCE_ClassName_MC_DataBar) as MovieClip;
            _loc5_ = new TUIDataBar(this);
            _loc5_.Resource = _loc3_;
            _loc5_.Tag = _loc1_;
            _loc5_.ColumnsCount = this.FColumnsCount;
            _loc5_.Init();
            this.FUIDataBars[_loc1_] = _loc5_;
            this.FScrollBar.AddItem(_loc5_);
            _loc1_++;
         }
         this.FBT_Recharge = this.FMC_VIP[CONST_VIP.RESOURCE_Link_BT_Recharge];
         this.SetDataBar();
         this.FORMAT_Level = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.VIP_STRING_01);
         this.FInitialization = true;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.BtnCloseOnClick);
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver,false,0,true);
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut,false,0,true);
         this.FBT_Recharge.addEventListener(MouseEvent.CLICK,this.RechargeOnClick);
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Vip_ReceiveRet,this.PerformPacket_SC_Vip_ReceiveRet);
      }
      
      protected function PerformPacket_SC_Vip_ReceiveRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = int(_loc3_.readUnsignedShort());
         _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.VIP_STRING_06);
         _loc5_ = TUtilityString.Format(_loc6_,_loc4_);
         EffectGenerateText(_loc5_);
         this.SetReceiveState(STATE_Received);
         this.FReceiveState = STATE_Received;
         if(this.FOnEffectBaseGlowVIP != null)
         {
            this.FOnEffectBaseGlowVIP(this,false);
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         this.LogicsPerform_Signals();
      }
      
      protected function LogicsPerform_Signals() : void
      {
         var _loc1_:TSignal = null;
         var _loc2_:uint = 0;
         _loc1_ = SLogicsCore.SignalRetrieve(SIGNALDESTINATION_COUNTER_VIP_Ret);
         if(_loc1_ == null)
         {
            return;
         }
         _loc2_ = uint(_loc1_.Value);
         this.FReceiveState = _loc2_;
         if(Visible)
         {
            this.UpdateVipActivating();
            this.UpdateTopPanel();
         }
         if(this.FReceiveState == STATE_UnReceive)
         {
            if(this.FOnEffectBaseGlowVIP != null)
            {
               this.FOnEffectBaseGlowVIP(this,true);
            }
         }
      }
      
      protected function SetDataBar() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         var _loc4_:TVipConfig = null;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc7_:TUIDataBar = null;
         var _loc8_:Vector.<String> = null;
         _loc8_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.VIP_STRING_07);
         _loc1_ = 0;
         while(_loc1_ < this.FRowsCount)
         {
            _loc7_ = this.FUIDataBars[_loc1_];
            _loc3_ = _loc8_[_loc1_];
            _loc7_.Caption = _loc3_;
            _loc5_ = STRING_Keys[_loc1_];
            _loc6_ = TYPE_Item[_loc1_];
            _loc2_ = 0;
            while(_loc2_ < this.FColumnsCount)
            {
               _loc4_ = this.FVipConfigs.GetDatebaseByIndex(_loc2_ + 1) as TVipConfig;
               _loc7_.SetItem(_loc6_,_loc2_,_loc4_[_loc5_]);
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      protected function SetReceiveState(param1:int) : void
      {
         if(!this.Visible)
         {
            return;
         }
         switch(param1)
         {
            case STATE_Received:
               this.FBtn_ReceiveAwards.Enabled = false;
               this.FMC_Effect.stop();
               this.FMC_Effect.visible = false;
               break;
            case STATE_UnReceive:
               this.FBtn_ReceiveAwards.Enabled = true;
               this.FMC_Effect.play();
               this.FMC_Effect.visible = true;
         }
      }
      
      protected function UpdateVipActivating() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIDataBar = null;
         _loc2_ = int(this.FVipData.VipLevel);
         if(_loc2_ <= 0)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FRowsCount)
         {
            _loc3_ = this.FUIDataBars[_loc1_];
            _loc3_.ActivationIndex = _loc2_ - 1;
            _loc3_.Update();
            _loc1_++;
         }
      }
      
      protected function UpdateTopPanel() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TVipConfig = null;
         var _loc5_:TVipConfig = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         _loc2_ = this.FVipData.VipLevel;
         _loc3_ = this.FVipData.VipExp;
         if(_loc2_ > this.FColumnsCount)
         {
            return;
         }
         _loc9_ = TUtilityString.Format(this.FORMAT_Level,_loc2_);
         this.FTF_CurrentLevel.text = _loc9_;
         this.FTF_CurrentLevelRight.text = _loc9_;
         _loc4_ = this.FVipConfigs.GetDatebaseByIdentifier(_loc2_ + 1) as TVipConfig;
         _loc8_ = 0;
         if(_loc2_ != 0)
         {
            _loc5_ = this.FVipConfigs.GetDatebaseByIdentifier(_loc2_) as TVipConfig;
            _loc8_ = uint(_loc5_.DailyChicket);
         }
         _loc10_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.VIP_STRING_03);
         this.FTF_CurrentCoupons.text = TUtilityString.Format(_loc10_,_loc8_);
         if(_loc2_ < this.FColumnsCount)
         {
            _loc6_ = uint(_loc4_.ChargeCount);
            _loc7_ = _loc6_ - _loc3_;
            this.FTF_NextLevel.text = TUtilityString.Format(this.FORMAT_Level,_loc2_ + 1);
            _loc11_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.VIP_STRING_04);
            this.FTF_PayMoney.text = TUtilityString.Format(_loc11_,_loc7_);
            _loc12_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.VIP_STRING_05);
            this.FTF_NextLevelCoupons.text = TUtilityString.Format(_loc12_,_loc2_ + 1,_loc4_.DailyChicket);
         }
         else
         {
            _loc6_ = uint(_loc5_.ChargeCount);
            _loc3_ = uint(_loc5_.ChargeCount);
            this.FTF_NextLevel.visible = false;
            this.FTF_NextLevelCoupons.visible = false;
            this.FTF_PayMoney.visible = false;
            this.FMC_VIP["tf_0"].visible = false;
            this.FMC_VIP["tf_1"].visible = false;
         }
         _loc1_ = this.FVipData.VipLevel;
         if(this.FVipLevel != _loc1_)
         {
            this.FSP_ExpBar.x = 0 - this.FSP_ExpBar.width;
         }
         if(this.FTF_CurrentExp != _loc3_)
         {
            this.UpdateProgressBarExp(_loc3_,_loc6_);
            this.FTF_CurrentExp = _loc3_;
         }
         this.SetReceiveState(this.FReceiveState);
      }
      
      protected function UpdateProgressBarExp(param1:uint, param2:uint) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         _loc7_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.VIP_STRING_02);
         this.FTF_EXP.text = TUtilityString.Format(_loc7_,param1,param2);
         _loc3_ = param1 / param2;
         if(_loc3_ > 1)
         {
            _loc3_ = 1;
         }
         _loc4_ = this.FSP_ExpBar.width * _loc3_;
         _loc5_ = this.FSP_ExpBar.x;
         _loc6_ = 0 - (this.FSP_ExpBar.width - _loc4_);
         this.FTweenOperIn.target = this.FSP_ExpBar;
         this.FTweenOperIn.params = {
            "x":_loc5_,
            "ease":Cubic.easeIn
         };
         this.FTweenOperOut.target = this.FSP_ExpBar;
         this.FTweenOperOut.params = {
            "x":_loc6_,
            "ease":Cubic.easeOut
         };
         this.FRepeatOper.execute();
      }
      
      protected function ProcessorInitVipLevelOpenFunction() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TVipConfig = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc18_:uint = 0;
         var _loc19_:uint = 0;
         var _loc20_:uint = 0;
         var _loc21_:uint = 0;
         var _loc22_:uint = 0;
         var _loc23_:uint = 0;
         var _loc24_:uint = 0;
         var _loc25_:uint = 0;
         var _loc26_:uint = 0;
         var _loc27_:uint = 0;
         var _loc28_:uint = 0;
         var _loc29_:uint = 0;
         var _loc30_:uint = 0;
         if(this.FVipConfigs == null)
         {
            this.FVipConfigs = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_VipConfig);
         }
         _loc2_ = this.FVipConfigs.Count - 1;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FVipConfigs.GetDatebaseByIdentifier(_loc1_) as TVipConfig;
            if(_loc4_ == 0 && _loc3_.FreeLook != 0)
            {
               _loc4_ = uint(_loc3_.Identifier);
            }
            if(_loc5_ == 0 && _loc3_.BlockTime != 0)
            {
               _loc5_ = uint(_loc3_.Identifier);
            }
            if(_loc6_ == 0 && _loc3_.StonePecent != 0)
            {
               _loc6_ = uint(_loc3_.Identifier);
            }
            if(_loc7_ == 0 && _loc3_.SkipBlock != 0)
            {
               _loc7_ = uint(_loc3_.Identifier);
            }
            if(_loc8_ == 0 && _loc3_.DailySingleReset != 0)
            {
               _loc8_ = uint(_loc3_.Identifier);
            }
            if(_loc9_ == 0 && _loc3_.DailyChaReset != 0)
            {
               _loc9_ = uint(_loc3_.Identifier);
            }
            if(_loc10_ == 0 && _loc3_.SkipChargeFight != 0)
            {
               _loc10_ = uint(_loc3_.Identifier);
            }
            if(_loc11_ == 0 && _loc3_.OneWine != 0)
            {
               _loc11_ = uint(_loc3_.Identifier);
            }
            if(_loc12_ == 0 && _loc3_.OneWinWine != 0)
            {
               _loc12_ = uint(_loc3_.Identifier);
            }
            if(_loc13_ == 0 && _loc3_.MoreChange != 0)
            {
               _loc13_ = uint(_loc3_.Identifier);
            }
            if(_loc14_ == 0 && _loc3_.ArenaSkip != 0)
            {
               _loc14_ = uint(_loc3_.Identifier);
            }
            if(_loc15_ == 0 && _loc3_.OneTimePet != 0)
            {
               _loc15_ = uint(_loc3_.Identifier);
            }
            if(_loc16_ == 0 && _loc3_.OneWater != 0)
            {
               _loc16_ = uint(_loc3_.Identifier);
            }
            if(_loc17_ == 0 && _loc3_.AutoBuyAct != 0)
            {
               _loc17_ = uint(_loc3_.Identifier);
            }
            if(_loc18_ == 0 && _loc3_.BossFightUp != 0)
            {
               _loc18_ = uint(_loc3_.Identifier);
            }
            if(_loc19_ == 0 && _loc3_.OneTimeWash != 0)
            {
               _loc19_ = uint(_loc3_.Identifier);
            }
            if(_loc20_ == 0 && _loc3_.MonsterOneTime != 0)
            {
               _loc20_ = uint(_loc3_.Identifier);
            }
            if(_loc21_ == 0 && _loc3_.StoneOneTime != 0)
            {
               _loc21_ = uint(_loc3_.Identifier);
            }
            if(_loc22_ == 0 && _loc3_.Digging != 0)
            {
               _loc22_ = uint(_loc3_.Identifier);
            }
            if(_loc23_ == 0 && _loc3_.SevenHeroOneKey != 0)
            {
               _loc23_ = uint(_loc3_.Identifier);
            }
            if(_loc24_ == 0 && _loc3_.SkipSevenHeroFight != 0)
            {
               _loc24_ = uint(_loc3_.Identifier);
            }
            if(_loc25_ == 0 && _loc3_.AutoJoinActivity != 0)
            {
               _loc25_ = uint(_loc3_.Identifier);
            }
            if(_loc26_ == 0 && _loc3_.TeamerExpand != 0)
            {
               _loc26_ = uint(_loc3_.Identifier);
            }
            if(_loc27_ == 0 && _loc3_.AKeyBableTower != 0)
            {
               _loc27_ = uint(_loc3_.Identifier);
            }
            if(_loc28_ == 0 && _loc3_.ResourcesBackvip != 0)
            {
               _loc28_ = uint(_loc3_.Identifier);
            }
            if(_loc29_ == 0 && _loc3_.ChangeHeroReset != 0)
            {
               _loc29_ = uint(_loc3_.Identifier);
            }
            if(_loc30_ == -1 && _loc3_.CanAutoFight != 0)
            {
               _loc30_ = uint(_loc3_.Identifier);
            }
            _loc1_++;
         }
         this.FVipData.CoercePropertieVipOpenLevel(_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc15_,_loc16_,_loc17_,_loc18_,_loc19_,_loc20_,_loc21_,_loc22_,_loc23_,_loc24_,_loc25_,_loc26_,_loc27_,_loc28_,_loc29_,_loc30_);
      }
      
      protected function ProcessorUpdateVipInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TVipConfig = null;
         var _loc5_:TVipConfig = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         _loc3_ = this.FVipData.VipLevel;
         if(this.FVipLevel == _loc3_)
         {
            return;
         }
         if(_loc3_ != 0)
         {
            this.Perform_CS_ReceiveStateReq();
         }
         if(_loc3_ <= 0)
         {
            this.FReceiveState = STATE_ForbidReceive;
         }
         if(this.FVipConfigs == null)
         {
            this.FVipConfigs = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_VipConfig);
         }
         _loc4_ = this.FVipConfigs.GetDatebaseByIdentifier(_loc3_) as TVipConfig;
         if(_loc4_ == null)
         {
            return;
         }
         this.FUnstreamizerVip.Unstreamize(null,this.FVipData,_loc4_);
         _loc2_ = this.FVipConfigs.Count - 1;
         if(_loc3_ < _loc2_)
         {
            _loc5_ = this.FVipConfigs.GetDatebaseByIdentifier(_loc3_ + 1) as TVipConfig;
            _loc6_ = this.FVipData.VipExp;
            _loc7_ = uint(_loc5_.ChargeCount);
            _loc8_ = _loc7_ - _loc6_;
         }
         _loc1_ = 1;
         while(_loc1_ <= _loc3_)
         {
            _loc4_ = this.FVipConfigs.GetDatebaseByIndex(_loc1_) as TVipConfig;
            _loc9_ += _loc4_.BagCount;
            _loc10_ += _loc4_.ActionLimit;
            _loc1_++;
         }
         this.FVipData.CoercePropertieVipLevelUpperLimit(this.FVipConfigs.Count - 1);
         this.FVipData.CoercePropertieVipNexpLevelExp(_loc8_);
         this.FVipData.CoercePropertieBagCount(_loc9_);
         this.FVipData.CoercePropertieActionLimit(_loc10_);
         this.FVipLevel = _loc3_;
      }
      
      protected function Perform_CS_ReceiveStateReq() : void
      {
         var _loc1_:Vector.<uint> = null;
         _loc1_ = new Vector.<uint>(1);
         _loc1_[0] = KEY_VIP_ReceiveState;
         SLogicsCore.SignalPost(SIGNALDESTINATION_COUNTER_VIP_Req,0,0,_loc1_);
      }
      
      protected function Perform_CS_ReceiveReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Vip_ReceiveReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function BtnCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorClose();
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_VIP);
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHelpTips);
      }
      
      protected function ButtonHelpOnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHelpTips);
      }
      
      protected function RechargeOnClick(param1:MouseEvent) : void
      {
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      protected function BtnReceiveAwardsOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FVipLevel <= 0)
         {
            return;
         }
         if(this.FReceiveState != STATE_UnReceive)
         {
            return;
         }
         this.Perform_CS_ReceiveReq();
      }
      
      public function get OnEffectBaseGlowVIP() : Function
      {
         return this.FOnEffectBaseGlowVIP;
      }
      
      public function set OnEffectBaseGlowVIP(param1:Function) : void
      {
         this.FOnEffectBaseGlowVIP = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.UpdateVipActivating();
         this.UpdateTopPanel();
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.Reset();
      }
      
      public function Reset() : void
      {
         this.FMC_Effect.stop();
         this.FMC_Effect.visible = false;
      }
      
      public function InitVipInfo() : void
      {
         this.ProcessorInitVipLevelOpenFunction();
         this.ProcessorUpdateVipInfo();
         if(this.FCharacter.VipLevel >= 1)
         {
            this.Perform_CS_ReceiveStateReq();
         }
      }
      
      public function UserUpdateCharVipInfo() : void
      {
         this.ProcessorUpdateVipInfo();
         if(this.Visible && this.FInitialization)
         {
            this.UpdateVipActivating();
            this.UpdateTopPanel();
         }
      }
   }
}

