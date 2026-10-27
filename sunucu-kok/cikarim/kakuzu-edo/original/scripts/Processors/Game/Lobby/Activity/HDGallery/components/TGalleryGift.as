package Processors.Game.Lobby.Activity.HDGallery.components
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.TAward;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TGalleryGift extends TUIComponent
   {
      
      protected var FMainUI:Sprite;
      
      protected var FGift:TUIButton;
      
      protected var FIcon:Sprite;
      
      protected var FBtnExchange:TUIButton;
      
      protected var FTFScore:TextField;
      
      protected var FGiftIndex:int;
      
      protected var FInventories:TInventories;
      
      protected var FOnOver:Function;
      
      protected var FOnOut:Function;
      
      protected var FOnExchange:Function;
      
      public function TGalleryGift(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function BtnOnExchange(param1:Object, param2:MouseEvent) : void
      {
         this.OnExchange(this,param2);
      }
      
      protected function OnGiftOver(param1:Object, param2:MouseEvent) : void
      {
         this.OnOver(this.FInventories);
      }
      
      protected function OnGiftOut(param1:Object, param2:MouseEvent) : void
      {
         this.OnOut();
      }
      
      public function Init(param1:Sprite) : void
      {
         var _loc2_:Sprite = null;
         this.FMainUI = param1;
         _loc2_ = this.FMainUI["MC_Exchange"];
         this.FIcon = this.FMainUI["MC_Get"];
         this.FIcon.mouseChildren = false;
         this.FIcon.mouseEnabled = false;
         this.FIcon.visible = false;
         this.FTFScore = _loc2_["TF_Count"];
         this.FBtnExchange = new TUIButton();
         this.FBtnExchange.Substrate = this.FMainUI["Btn_ExchargeOne"];
         this.FBtnExchange.OnClick = this.BtnOnExchange;
         this.FGift = new TUIButton();
         this.FGift.Substrate = this.FMainUI["Btn_Gift"];
         this.FGift.OnMove = this.OnGiftOver;
         this.FGift.OnOut = this.OnGiftOut;
      }
      
      public function SetData(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TAward = null;
         var _loc5_:TInventories = null;
         _loc5_ = new TInventories();
         SToolReward.GetAwardsByAwardID(param1,_loc5_);
         this.FInventories = _loc5_;
         this.FTFScore.text = param2 + "";
      }
      
      public function get GiftIndex() : int
      {
         return this.FGiftIndex;
      }
      
      public function set GiftIndex(param1:int) : void
      {
         this.FGiftIndex = param1;
      }
      
      public function get OnOver() : Function
      {
         return this.FOnOver;
      }
      
      public function set OnOver(param1:Function) : void
      {
         this.FOnOver = param1;
      }
      
      public function get OnOut() : Function
      {
         return this.FOnOut;
      }
      
      public function set OnOut(param1:Function) : void
      {
         this.FOnOut = param1;
      }
      
      public function get OnExchange() : Function
      {
         return this.FOnExchange;
      }
      
      public function set OnExchange(param1:Function) : void
      {
         this.FOnExchange = param1;
      }
   }
}

