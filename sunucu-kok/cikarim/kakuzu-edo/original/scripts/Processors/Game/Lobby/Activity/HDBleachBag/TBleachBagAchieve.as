package Processors.Game.Lobby.Activity.HDBleachBag
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.HDBleachBag.THDBleachBagData;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_CHRISTMAS;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TBleachBagAchieve extends TUIComponent
   {
      
      public static const AchieveNum:int = 4;
      
      private var FMainUI:Sprite;
      
      private var FTFDescVec:Vector.<TextField>;
      
      private var FGiftsVec:Vector.<TUIButton>;
      
      private var FGiftFlagsVec:Vector.<Sprite>;
      
      private var FData:THDBleachBagData;
      
      private var FCloseBtn:TUIButton;
      
      private var FBackgroundView:Sprite;
      
      protected var FOnSendMessageFun:Function;
      
      protected var FOnGiftBoxOut:Function;
      
      protected var FOnGiftBoxMove:Function;
      
      public function TBleachBagAchieve(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FMainUI = param2;
         this.addChild(this.FMainUI);
         this.InitWindow();
      }
      
      protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TUIButton = null;
         _loc2_ = AchieveNum;
         this.FTFDescVec = new Vector.<TextField>();
         this.FGiftFlagsVec = new Vector.<Sprite>();
         this.FGiftsVec = new Vector.<TUIButton>();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMainUI["MC_Gift_" + _loc1_];
            _loc4_ = new TUIButton();
            _loc4_.Substrate = _loc3_["Btn_Gift"];
            _loc4_.OnMove = this.GiftBoxOnMove;
            _loc4_.OnOut = this.BoxOnOut;
            _loc4_.OnClick = this.GiftOnClick;
            this.FGiftsVec[_loc1_] = _loc4_;
            this.FTFDescVec[_loc1_] = _loc3_["TF_Desc"];
            this.FGiftFlagsVec[_loc1_] = _loc3_["MC_Get"];
            _loc1_++;
         }
         this.FCloseBtn = new TUIButton();
         this.FCloseBtn.Substrate = this.FMainUI["BtnClose"];
         this.FCloseBtn.OnClick = this.OnCloseHide;
         this.FBackgroundView = new Sprite();
         this.FBackgroundView.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.FBackgroundView.x = -FParent.X;
         this.FBackgroundView.y = -FParent.Y;
         this.addChildAt(this.FBackgroundView,0);
         this.Visible = false;
      }
      
      public function RefreshView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = AchieveNum;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTFDescVec[_loc1_].text = this.FData.GetTaskGiftsData()[_loc1_].Desc;
            this.FGiftFlagsVec[_loc1_].visible = this.FData.GetTaskGiftsData()[_loc1_].GetAwardState == CONST_CHRISTMAS.Finish;
            this.FGiftsVec[_loc1_].Enabled = this.SetGiftState(this.FData.GetTaskGiftsData()[_loc1_].GetAwardState);
            _loc1_++;
         }
      }
      
      private function SetGiftState(param1:int) : Boolean
      {
         var _loc2_:Boolean = false;
         if(param1 == CONST_CHRISTMAS.ScanGetState)
         {
            _loc2_ = true;
         }
         else
         {
            _loc2_ = false;
         }
         return _loc2_;
      }
      
      protected function GiftOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FGiftsVec.indexOf(param1 as TUIButton);
         if(this.FOnSendMessageFun != null)
         {
            this.FOnSendMessageFun(this.FData.GetTaskGiftsData()[_loc3_].Index);
         }
      }
      
      protected function GiftBoxOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FGiftsVec.indexOf(param1 as TUIButton);
         if(this.FOnGiftBoxMove != null)
         {
            this.FOnGiftBoxMove(this,this.FData.GetTaskGiftsData()[_loc3_].Inventories,TOverlayerGiftBox.TYPE_ALL);
         }
      }
      
      protected function BoxOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnGiftBoxOut != null)
         {
            this.FOnGiftBoxOut(this);
         }
      }
      
      protected function OnCloseHide(param1:Object, param2:MouseEvent) : void
      {
         this.Visible = false;
      }
      
      public function set OnSendMessageFun(param1:Function) : void
      {
         this.FOnSendMessageFun = param1;
      }
      
      public function set OnGiftBoxOut(param1:Function) : void
      {
         this.FOnGiftBoxOut = param1;
      }
      
      public function set OnGiftBoxMove(param1:Function) : void
      {
         this.FOnGiftBoxMove = param1;
      }
      
      public function set Data(param1:THDBleachBagData) : void
      {
         this.FData = param1;
      }
      
      public function Show(param1:THDBleachBagData) : void
      {
         this.FData = param1;
         this.Visible = true;
         this.RefreshView();
      }
   }
}

