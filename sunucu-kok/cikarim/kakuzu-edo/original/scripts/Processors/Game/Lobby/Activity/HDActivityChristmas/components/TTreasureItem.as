package Processors.Game.Lobby.Activity.HDActivityChristmas.components
{
   import Components.Standard.TUIButton;
   import Logics.Inventories.TInventories;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TTreasureItem
   {
      
      protected static const Status_Get:int = -1;
      
      protected var FMainUI:Sprite;
      
      protected var FTFPrice:TextField;
      
      protected var FIconGet:Sprite;
      
      protected var FBtnBuy:TUIButton;
      
      protected var FBtnGift:TUIButton;
      
      protected var FGiftMoveFun:Function;
      
      protected var FGiftOutFun:Function;
      
      protected var FData:TInventories;
      
      protected var FPrice:int;
      
      protected var FStatus:int;
      
      protected var FOnClick:Function;
      
      protected var FItemIndex:int;
      
      public function TTreasureItem(param1:Sprite)
      {
         super();
         this.FMainUI = param1;
         this.InitView();
      }
      
      public function InitView() : void
      {
         this.FTFPrice = this.FMainUI["TF_Money"];
         this.FIconGet = this.FMainUI["MC_Get"];
         this.FIconGet.mouseEnabled = false;
         this.FIconGet.mouseChildren = false;
         this.FBtnBuy = new TUIButton();
         this.FBtnBuy.Substrate = this.FMainUI["Btn_Buy"];
         this.FBtnBuy.OnClick = this.BtnOnClick;
         this.FBtnGift = new TUIButton();
         this.FBtnGift.Substrate = this.FMainUI["Btn_Gift"];
         this.FBtnGift.OnMove = this.GiftBagOnMove;
         this.FBtnGift.OnOut = this.GiftBagOnOut;
      }
      
      protected function BtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnClick != null)
         {
            this.FOnClick(this.FItemIndex,param2);
         }
      }
      
      protected function GiftBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         if(this.FGiftMoveFun != null)
         {
            this.FGiftMoveFun(this.FData,param2);
         }
      }
      
      protected function GiftBagOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FGiftOutFun != null)
         {
            this.FGiftOutFun(param1,param2);
         }
      }
      
      public function get GiftMoveFun() : Function
      {
         return this.FGiftMoveFun;
      }
      
      public function set GiftMoveFun(param1:Function) : void
      {
         this.FGiftMoveFun = param1;
      }
      
      public function get GiftOutFun() : Function
      {
         return this.FGiftOutFun;
      }
      
      public function set GiftOutFun(param1:Function) : void
      {
         this.FGiftOutFun = param1;
      }
      
      public function get Data() : TInventories
      {
         return this.FData;
      }
      
      public function set Data(param1:TInventories) : void
      {
         this.FData = param1;
      }
      
      public function get IconVisible() : Boolean
      {
         return this.FIconGet.visible;
      }
      
      public function set IconVisible(param1:Boolean) : void
      {
         this.FIconGet.visible = param1;
      }
      
      public function get Price() : int
      {
         return this.FPrice;
      }
      
      public function set Price(param1:int) : void
      {
         this.FPrice = param1;
         this.FTFPrice.text = this.FPrice + "";
      }
      
      public function get Status() : int
      {
         return this.FStatus;
      }
      
      public function set Status(param1:int) : void
      {
         var _loc2_:Boolean = false;
         this.FStatus = param1;
         _loc2_ = this.FStatus == Status_Get;
         this.IconVisible = _loc2_;
         this.FBtnBuy.Enabled = !_loc2_;
      }
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function get ItemIndex() : int
      {
         return this.FItemIndex;
      }
      
      public function set ItemIndex(param1:int) : void
      {
         this.FItemIndex = param1;
      }
   }
}

