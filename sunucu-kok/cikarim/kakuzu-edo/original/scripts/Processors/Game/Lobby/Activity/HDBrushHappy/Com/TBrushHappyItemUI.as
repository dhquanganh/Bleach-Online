package Processors.Game.Lobby.Activity.HDBrushHappy.Com
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.HDBrushHappy.TBrushHappyArticle;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TBrushHappyItemUI extends TUIComponent
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FSlot:TUISlot;
      
      protected var FBuyBtn:TUIButton;
      
      protected var FRefreshBtn:TUIButton;
      
      protected var FID:uint;
      
      protected var FData:TBrushHappyArticle;
      
      protected var FBuyCall:Function;
      
      protected var FRefreshCall:Function;
      
      public function TBrushHappyItemUI(param1:TUIComponent, param2:uint)
      {
         super(param1);
         this.FID = param2;
      }
      
      protected function BuyBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FBuyCall(this.FID);
      }
      
      protected function RefreshBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FRefreshCall(this.FID);
      }
      
      public function set Data(param1:TBrushHappyArticle) : void
      {
         this.FData = param1;
      }
      
      public function set BuyCall(param1:Function) : void
      {
         this.FBuyCall = param1;
      }
      
      public function set RefreshCall(param1:Function) : void
      {
         this.FRefreshCall = param1;
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         this.FMainUI = param1;
         this.FSlot = new TUISlot(this);
         this.FSlot.Resource = this.FMainUI.MC_Slot;
         this.FSlot.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FSlot.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         TJadeCommon.InitSlot(this.FSlot);
         this.FSlot.Init();
         this.FBuyBtn = new TUIButton();
         this.FBuyBtn.Substrate = this.FMainUI.Btn_Buy;
         this.FBuyBtn.OnClick = this.BuyBtnOnClick;
         this.FRefreshBtn = new TUIButton();
         this.FRefreshBtn.Substrate = this.FMainUI.Btn_Refresh;
         this.FRefreshBtn.OnClick = this.RefreshBtnClick;
      }
      
      public function LogicsPerform() : void
      {
         if(this.FSlot != null)
         {
            this.FSlot.Update();
         }
      }
      
      public function Update() : void
      {
         this.FMainUI.TF_InitPrice.text = this.FData.InitPrice.toString();
         this.FMainUI.TF_CurPrice.text = this.FData.CurPrice.toString();
         this.FMainUI.TF_CurDis.text = this.FData.CurDiscount + "%";
         this.FMainUI.TF_MinDis.text = this.FData.MinDiscount + "%";
         this.FSlot.Context = this.FData.Article;
         if(this.FData.Buyed)
         {
            this.FBuyBtn.Enabled = this.FRefreshBtn.Enabled = false;
            this.FMainUI.MC_AlreadyGet.visible = true;
         }
         else
         {
            this.FBuyBtn.Enabled = true;
            this.FMainUI.MC_AlreadyGet.visible = false;
            this.FRefreshBtn.Enabled = this.FData.CurDiscount > this.FData.MinDiscount;
         }
      }
   }
}

