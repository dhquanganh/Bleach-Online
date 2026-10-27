package Processors.Game.Lobby.Activity.HDActivityChristmas.components
{
   import Components.Standard.TUIButton;
   import Logics.Inventories.TInventories;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TRewardItem
   {
      
      protected static const Status_CanGet:int = 1;
      
      protected static const Status_NotGet:int = 0;
      
      protected static const Status_Get:int = -1;
      
      protected var FMainUI:Sprite;
      
      protected var FTFCount:TextField;
      
      protected var FIconGet:Sprite;
      
      protected var FBtnGet:TUIButton;
      
      protected var FBtnGift:TUIButton;
      
      protected var FGiftMoveFun:Function;
      
      protected var FGiftOutFun:Function;
      
      protected var FData:TInventories;
      
      protected var FCount:int;
      
      protected var FStatus:int;
      
      protected var FOnClick:Function;
      
      protected var FItemIndex:int;
      
      public function TRewardItem(param1:Sprite)
      {
         super();
         this.FMainUI = param1;
         this.InitView();
      }
      
      public function InitView() : void
      {
         this.FTFCount = this.FMainUI["TF_Count"];
         this.FIconGet = this.FMainUI["MC_Get"];
         this.FIconGet.mouseChildren = false;
         this.FIconGet.mouseEnabled = false;
         this.FBtnGet = new TUIButton();
         this.FBtnGet.Substrate = this.FMainUI["Btn_ExchargeOne"];
         this.FBtnGet.OnClick = this.BtnOnClick;
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
      
      public function get Count() : int
      {
         return this.FCount;
      }
      
      public function set Count(param1:int) : void
      {
         this.FCount = param1;
         this.FTFCount.text = this.FCount + "";
      }
      
      public function get Status() : int
      {
         return this.FStatus;
      }
      
      public function set Status(param1:int) : void
      {
         this.FStatus = param1;
         switch(this.FStatus)
         {
            case Status_CanGet:
               this.IconVisible = false;
               this.FBtnGet.Enabled = true;
               break;
            case Status_NotGet:
               this.IconVisible = false;
               this.FBtnGet.Enabled = false;
               break;
            case Status_Get:
               this.IconVisible = true;
               this.FBtnGet.Enabled = false;
         }
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

