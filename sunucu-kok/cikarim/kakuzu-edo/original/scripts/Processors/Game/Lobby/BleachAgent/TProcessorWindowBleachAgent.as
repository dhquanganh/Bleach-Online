package Processors.Game.Lobby.BleachAgent
{
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.BleachAgent.TBleachAgentData;
   import Logics.SLogicsCore;
   import Logics.Streamization.BleachAgent.TUnstreamizerBleachAgent;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TProcessorWindowBleachAgent extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FCloseBtn:TUIButton;
      
      protected var FRenewBtn:TUIButton;
      
      protected var FActivateCom:TProcessorActivateCom;
      
      protected var FDailyRewardCom:TProcessorDailyRewardCom;
      
      protected var FFirstRewardCom:TProcessorFirstRewardCom;
      
      protected var FWelfareWin:TProcessorWindowWelfare;
      
      protected var FData:TBleachAgentData;
      
      protected var FUnstreamizer:TUnstreamizerBleachAgent;
      
      protected var FHint:THint;
      
      public function TProcessorWindowBleachAgent(param1:TUIComponent)
      {
         super(param1);
         this.FData = SLogicsCore.BleachAgentData;
         this.FUnstreamizer = new TUnstreamizerBleachAgent(this.FData);
         this.FHint = new THint();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_BleachAgent") as MovieClip;
         addChild(this.FMainUI);
         this.FActivateCom = new TProcessorActivateCom(this);
         this.FActivateCom.UIDispatch(this.FMainUI.MC_Activate);
         this.FActivateCom.LookWelfare = this.LookWelfare;
         this.FActivateCom.Activate = this.Activate;
         this.FDailyRewardCom = new TProcessorDailyRewardCom(this);
         this.FDailyRewardCom.UIDispatch(this.FMainUI.MC_DailyReward);
         this.FDailyRewardCom.LookWelfare = this.LookWelfare;
         this.FFirstRewardCom = new TProcessorFirstRewardCom(this);
         this.FFirstRewardCom.UIDispatch(this.FMainUI.MC_FirstReward);
         this.FWelfareWin = new TProcessorWindowWelfare(this);
         this.FWelfareWin.X = -this.x;
         this.FWelfareWin.Y = -this.y;
         this.FWelfareWin.Visible = false;
         this.FWelfareWin.Load();
         this.FCloseBtn = new TUIButton();
         this.FCloseBtn.Substrate = this.FMainUI.Btn_Close;
         this.FCloseBtn.OnClick = this.OnCloseBtnClick;
         this.FRenewBtn = new TUIButton();
         this.FRenewBtn.Substrate = this.FMainUI.Btn_Renew;
         this.FRenewBtn.OnClick = this.OnRenewBtnClick;
         this.FRenewBtn.OnMove = this.OnRenewBtnMove;
         this.FRenewBtn.OnOut = this.OnRenewBtnOut;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UIFinalize() : void
      {
         this.FUnstreamizer.UnstreamizerConfig();
         this.FActivateCom.UIFinalize();
         this.FDailyRewardCom.UIFinalize();
         this.FFirstRewardCom.UIFinalize();
         this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BleachAgent_07),this.FData.ConfigValueVO.Renewal);
         super.ResourcesPerform_UIFinalize();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         if(Visible && this.FMainUI != null)
         {
            _loc1_ = this.FData.Remain;
            this.FMainUI.TF_Time.text = TUtilityTiming.FormatSingleDHMBySeconds(_loc1_);
            this.FDailyRewardCom.UILoop();
            this.FFirstRewardCom.UILoop();
         }
      }
      
      protected function LookWelfare() : void
      {
         this.FWelfareWin.Visible = true;
      }
      
      protected function Activate() : void
      {
         TUtilityLobby.GoldBuy(this.FData.ConfigValueVO.Discount,this.Recharge);
      }
      
      protected function OnCloseBtnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function OnRenewBtnClick(param1:Object, param2:MouseEvent) : void
      {
         TUtilityLobby.GoldBuy(this.FData.ConfigValueVO.Renewal,this.Renewal);
      }
      
      protected function OnRenewBtnMove(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OnRenewBtnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function Renewal(param1:Object) : void
      {
         this.FUnstreamizer.BuyReq(this.FUnstreamizer.BuyType_Renewal);
      }
      
      protected function Recharge(param1:Object) : void
      {
         this.FUnstreamizer.BuyReq(this.FUnstreamizer.BuyType_Recharge);
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(param1)
         {
            this.UIUpdate();
         }
      }
      
      public function UIUpdate() : void
      {
         if(this.FMainUI != null)
         {
            if(this.FData.CurIsBuyState)
            {
               this.FRenewBtn.Visible = false;
               this.FDailyRewardCom.Visible = false;
               this.FActivateCom.Visible = true;
            }
            else
            {
               this.FRenewBtn.Visible = true;
               this.FDailyRewardCom.Visible = true;
               this.FActivateCom.Visible = false;
            }
            this.FDailyRewardCom.UIUpdate();
            this.FFirstRewardCom.UIUpdate();
         }
      }
   }
}

