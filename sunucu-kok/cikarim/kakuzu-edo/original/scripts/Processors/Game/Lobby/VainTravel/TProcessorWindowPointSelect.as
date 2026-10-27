package Processors.Game.Lobby.VainTravel
{
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.BleachAgent.TBleachAgentData;
   import Logics.SLogicsCore;
   import Logics.VainTravel.TVainTravelData;
   import Logics.VainTravel.TVainTravelPlayerInfor;
   import Processors.Game.Common.Effects.Display.TEffectBaseGlow;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Resources.Constants.CONST_VAINTRAVEL;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorWindowPointSelect extends TProcessorLobbyWindow
   {
      
      protected static const GrowEffectColor:int = 16723968;
      
      protected var FMainUI:Sprite;
      
      protected var FBtnClose:TUIButton;
      
      protected var FLastResetTime:TextField;
      
      protected var FBtnReset:TUIButton;
      
      protected var FCanReliveTime:TextField;
      
      protected var FBtnRelive:TUIButton;
      
      protected var FBtnExchange:TUIButton;
      
      protected var FBtnFightReport:TUIButton;
      
      protected var FBtnRuleDesc:TUIButton;
      
      protected var FPointTombs:Vector.<TUIButton>;
      
      protected var FPointBoxs:Vector.<TUIButton>;
      
      protected var FPointIcons:Vector.<TUIButton>;
      
      protected var FDesHit:THint;
      
      protected var FVainHeroInforTip:TVainHeroInforTip;
      
      protected var FShowHeroInfoTip:Boolean;
      
      protected var FEffectBaseGlow:TEffectBaseGlow;
      
      protected var FBAData:TBleachAgentData;
      
      protected var FVainTravelData:TVainTravelData;
      
      protected var FOnOpenReadyWindow:Function;
      
      protected var FOnOpenShop:Function;
      
      protected var FOnOpenFightReport:Function;
      
      public function TProcessorWindowPointSelect(param1:TUIComponent)
      {
         super(param1);
         this.FBAData = SLogicsCore.BleachAgentData;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         if(this.FShowHeroInfoTip)
         {
            this.FVainHeroInforTip.CheckTipPoint();
         }
         this.UpdateGrowEffect();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIButton = null;
         var _loc4_:Sprite = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("VainTravelUI") as Sprite;
         addChild(this.FMainUI);
         this.FPointTombs = new Vector.<TUIButton>();
         this.FPointBoxs = new Vector.<TUIButton>();
         this.FPointIcons = new Vector.<TUIButton>();
         _loc2_ = CONST_VAINTRAVEL.VAINPOINTNUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FMainUI["Point" + _loc1_];
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc4_["BtnTomb"];
            _loc3_.OnClick = this.BtnTombOnClick;
            _loc3_.OnMove = this.BtnTombOnMove;
            _loc3_.OnOut = this.BtnTombOnOut;
            this.FPointTombs.push(_loc3_);
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc4_["BtnBox"];
            _loc3_.OnClick = this.BtnBoxOnClick;
            _loc3_.OnMove = this.BtnBoxOnMove;
            _loc3_.OnOut = this.BtnBoxOnOut;
            this.FPointBoxs.push(_loc3_);
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc4_["BtnIcon"];
            _loc3_.OnClick = this.BtnIconOnClick;
            _loc3_.OnMove = this.BtnIconOnMove;
            _loc3_.OnOut = this.BtnIconOnOut;
            this.FPointIcons.push(_loc3_);
            _loc1_++;
         }
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["BtnClose"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FBtnExchange = new TUIButton();
         this.FBtnExchange.Substrate = this.FMainUI["BtnExchange"];
         this.FBtnExchange.OnClick = this.BtnExchangeOnClick;
         this.FBtnFightReport = new TUIButton();
         this.FBtnFightReport.Substrate = this.FMainUI["BtnFightReport"];
         this.FBtnFightReport.OnClick = this.BtnFightReportOnClick;
         this.FLastResetTime = this.FMainUI["LastResetTime"];
         this.FBtnReset = new TUIButton();
         this.FBtnReset.Substrate = this.FMainUI["BtnReset"];
         this.FBtnReset.OnClick = this.BtnResetOnClick;
         this.FBtnRuleDesc = new TUIButton();
         this.FBtnRuleDesc.Substrate = this.FMainUI["RuleDesc"];
         this.FBtnRuleDesc.OnClick = this.BtnRuleOnClick;
         this.FCanReliveTime = this.FMainUI["ReliveTime"];
         this.FBtnRelive = new TUIButton();
         this.FBtnRelive.Substrate = this.FMainUI["Btn_Relive"];
         this.FBtnRelive.OnClick = this.BtnReliveOnClick;
         this.FDesHit = new THint();
         this.FVainHeroInforTip = new TVainHeroInforTip(this.Parent);
         this.FVainHeroInforTip.Visible = false;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FEffectBaseGlow = new TEffectBaseGlow();
         super.ResourcesPerform_UILocations();
      }
      
      protected function RenderPoint() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TVainTravelPlayerInfor = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc6_ = -1;
         this.FEffectBaseGlow.Stop();
         _loc2_ = int(this.FVainTravelData.VainTravelPlayerInfor.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FVainTravelData.VainTravelPlayerInfor[_loc1_];
            if(_loc3_.CurrentState != CONST_VAINTRAVEL.PlayerState_Dead)
            {
               _loc6_ = _loc6_ == -1 ? _loc1_ : _loc6_;
            }
            switch(_loc3_.CurrentState)
            {
               case CONST_VAINTRAVEL.PlayerState_Alive:
                  this.FPointTombs[_loc1_].Visible = false;
                  this.FPointBoxs[_loc1_].Visible = false;
                  this.FPointIcons[_loc1_].Visible = true;
                  break;
               case CONST_VAINTRAVEL.PlayerState_Box:
                  this.FPointTombs[_loc1_].Visible = false;
                  this.FPointBoxs[_loc1_].Visible = true;
                  this.FPointIcons[_loc1_].Visible = false;
                  break;
               case CONST_VAINTRAVEL.PlayerState_Dead:
                  this.FPointTombs[_loc1_].Visible = true;
                  this.FPointBoxs[_loc1_].Visible = false;
                  this.FPointIcons[_loc1_].Visible = false;
            }
            _loc1_++;
         }
         if(_loc6_ != -1)
         {
            _loc3_ = this.FVainTravelData.VainTravelPlayerInfor[_loc6_];
            switch(_loc3_.CurrentState)
            {
               case CONST_VAINTRAVEL.PlayerState_Alive:
                  this.FEffectBaseGlow.SetParameters(this.FPointIcons[_loc6_].Substrate,GrowEffectColor,1);
                  break;
               case CONST_VAINTRAVEL.PlayerState_Box:
                  this.FEffectBaseGlow.SetParameters(this.FPointBoxs[_loc6_].Substrate,GrowEffectColor,1);
            }
         }
         _loc7_ = this.FBAData.GetWelfareCountByType(this.FBAData.WelfareType_BraveCirleRefreshCount);
         this.FLastResetTime.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_12),this.FVainTravelData.LastResetTime + _loc7_);
         this.FBtnReset.Enabled = this.FVainTravelData.LastResetTime + _loc7_ > 0;
         this.FCanReliveTime.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_16),this.FVainTravelData.CanReliveTime);
      }
      
      protected function RequestReset(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_VainTravel_DailyResetReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function RequestRelive(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_VainTravel_ReliveReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function UpdateGrowEffect() : void
      {
         if(this.FEffectBaseGlow.Source != null)
         {
            this.FEffectBaseGlow.Run();
         }
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function BtnRuleOnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIWindowBigInformation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_01);
         SUtilityOverLayer.UIWindowBigInformation.Visible = true;
      }
      
      protected function BtnResetOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FVainTravelData.IfFree || this.FVainTravelData.CurrentResetCost == 0)
         {
            SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_22);
         }
         else
         {
            SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_14),this.FVainTravelData.CurrentResetCost);
         }
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.RequestReset;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      protected function BtnReliveOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FVainTravelData.LastReliveBuyTime <= 0)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_15));
         }
         else
         {
            SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_17),this.FVainTravelData.BuyReliveCost);
            SUtilityOverLayer.UIWindowConfirmation.OnOK = this.RequestRelive;
            SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         }
      }
      
      protected function BtnExchangeOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnOpenShop != null)
         {
            this.FOnOpenShop(this);
         }
      }
      
      protected function BtnFightReportOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnOpenFightReport != null)
         {
            this.FOnOpenFightReport(this);
         }
      }
      
      protected function BtnTombOnClick(param1:Object, param2:MouseEvent) : void
      {
      }
      
      protected function BtnTombOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FPointTombs.indexOf(param1 as TUIButton);
         this.FVainHeroInforTip.SetContext(this.FVainTravelData.PlayerInforByIndex(_loc3_));
         this.FShowHeroInfoTip = true;
         this.FVainHeroInforTip.Visible = true;
      }
      
      protected function BtnTombOnOut(param1:Object, param2:MouseEvent) : void
      {
         this.FShowHeroInfoTip = false;
         this.FVainHeroInforTip.Visible = false;
      }
      
      protected function BtnBoxOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TPacket = null;
         _loc3_ = this.FPointBoxs.indexOf(param1 as TUIButton);
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_VainTravel_TakeRewardReq);
         _loc4_.Data.writeByte(this.FVainTravelData.VainTravelPlayerInfor[_loc3_].Index);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function BtnBoxOnMove(param1:Object, param2:MouseEvent) : void
      {
      }
      
      protected function BtnBoxOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FDesHit);
      }
      
      protected function BtnIconOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TVainTravelPlayerInfor = null;
         _loc3_ = this.FPointIcons.indexOf(param1 as TUIButton);
         if(_loc3_ > 0)
         {
            _loc4_ = this.FVainTravelData.PlayerInforByIndex(_loc3_ - 1);
            if(_loc4_.CurrentState != CONST_VAINTRAVEL.PlayerState_Dead)
            {
               SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_13));
               return;
            }
         }
         this.FOnOpenReadyWindow(this.FVainTravelData.PlayerInforByIndex(_loc3_));
      }
      
      protected function BtnIconOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FPointIcons.indexOf(param1 as TUIButton);
         this.FVainHeroInforTip.SetContext(this.FVainTravelData.PlayerInforByIndex(_loc3_));
         this.FShowHeroInfoTip = true;
         this.FVainHeroInforTip.Visible = true;
      }
      
      protected function BtnIconOnOut(param1:Object, param2:MouseEvent) : void
      {
         this.FShowHeroInfoTip = false;
         this.FVainHeroInforTip.Visible = false;
      }
      
      public function set OnOpenReadyWindow(param1:Function) : void
      {
         this.FOnOpenReadyWindow = param1;
      }
      
      public function set OnOpenShop(param1:Function) : void
      {
         this.FOnOpenShop = param1;
      }
      
      public function set OnOpenFightReport(param1:Function) : void
      {
         this.FOnOpenFightReport = param1;
      }
      
      public function Show(param1:TVainTravelData) : void
      {
         Visible = true;
         this.FVainTravelData = param1;
         this.RenderPoint();
      }
   }
}

