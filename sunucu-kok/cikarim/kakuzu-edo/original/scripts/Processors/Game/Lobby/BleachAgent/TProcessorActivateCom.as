package Processors.Game.Lobby.BleachAgent
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.BleachAgent.TBleachAgentData;
   import Logics.SLogicsCore;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TProcessorActivateCom extends TUIComponent
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FData:TBleachAgentData;
      
      protected var FLookWelfareBtn:TUIButton;
      
      protected var FActivateBtn:TUIButton;
      
      protected var FLookWelfare:Function;
      
      protected var FActivate:Function;
      
      public function TProcessorActivateCom(param1:TUIComponent)
      {
         super(param1);
         this.FData = SLogicsCore.BleachAgentData;
      }
      
      protected function OnWelfareBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FLookWelfare();
      }
      
      protected function OnActivateBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FActivate();
      }
      
      public function set LookWelfare(param1:Function) : void
      {
         this.FLookWelfare = param1;
      }
      
      public function set Activate(param1:Function) : void
      {
         this.FActivate = param1;
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         this.FMainUI = param1;
         addChild(this.FMainUI);
         this.FLookWelfareBtn = new TUIButton();
         this.FLookWelfareBtn.Substrate = this.FMainUI.Btn_LookWelfare;
         this.FLookWelfareBtn.OnClick = this.OnWelfareBtnClick;
         this.FActivateBtn = new TUIButton();
         this.FActivateBtn.Substrate = this.FMainUI.Btn_Activate;
         this.FActivateBtn.OnClick = this.OnActivateBtnClick;
         this.FMainUI.MC_BtnEffect.gotoAndPlay(1);
      }
      
      public function UIFinalize() : void
      {
         this.FMainUI.TF_Day.text = this.FData.ConfigValueVO.EnjoyDay.toString();
         this.FMainUI.TF_OriginalPrice.text = this.FData.ConfigValueVO.Original.toString();
         this.FMainUI.TF_Discount.text = this.FData.ConfigValueVO.Discount.toString();
      }
   }
}

