package Processors.Game.Lobby.Activity.HDActivity.Common
{
   import Components.Pages.TUIPage;
   import Components.Standard.TUIButton;
   import Foundation.Common.TCoordinate;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityCartisian;
   import Logics.HDActivityMode.TGiftBoxTipData;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class THDGiftScoreExchangeShop extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FPage:TUIPage;
      
      protected var FVecInventories:Vector.<TInventories>;
      
      protected var FItemCount:uint;
      
      protected var FPageIndex:uint;
      
      protected var FExchangeBtns:Vector.<TUIButton>;
      
      protected var FPrices:Vector.<uint>;
      
      protected var FInfiniteBuy:Vector.<Boolean>;
      
      protected var FTotalScore:uint;
      
      protected var FStates:Vector.<int>;
      
      protected var FCloseBtn:TUIButton;
      
      protected var FGifts:Vector.<TUIButton>;
      
      protected var FGiftBoxTipData:TGiftBoxTipData;
      
      protected var FExchangeCall:Function;
      
      public function THDGiftScoreExchangeShop(param1:TUIComponent)
      {
         super(param1);
         Visible = false;
         this.FGiftBoxTipData = new TGiftBoxTipData();
      }
      
      protected function LocalToGlobalIndex(param1:uint) : uint
      {
         return this.FPageIndex * this.FItemCount + param1;
      }
      
      protected function UpdatePage() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         var _loc4_:TUIButton = null;
         var _loc5_:int = 0;
         this.FMainUI.TF_Score.text = this.FTotalScore.toString();
         _loc1_ = 0;
         while(_loc1_ < this.FItemCount)
         {
            _loc2_ = this.FMainUI["MC_Item_" + _loc1_];
            _loc3_ = this.LocalToGlobalIndex(_loc1_);
            if(_loc3_ < this.FVecInventories.length)
            {
               _loc2_.visible = true;
               _loc4_ = this.FExchangeBtns[_loc1_];
               _loc5_ = this.FStates[_loc3_];
               _loc4_.Enabled = _loc5_ != CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
               _loc2_.TF_Score.text = this.FPrices[_loc3_].toString();
               _loc2_.MC_Limit.visible = !this.FInfiniteBuy[_loc3_];
            }
            else
            {
               _loc2_.visible = false;
            }
            _loc1_++;
         }
      }
      
      protected function OnExchangeBtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FExchangeCall != null)
         {
            this.FExchangeCall(this.LocalToGlobalIndex((param1 as TUIButton).Tag));
         }
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdatePage();
      }
      
      protected function OnCloseBtnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function OnGiftMove(param1:Object, param2:MouseEvent) : void
      {
         this.FGiftBoxTipData.TipReset();
         this.FGiftBoxTipData.NormalInventories = this.FVecInventories[param1.Tag];
         this.FGiftBoxTipData.AwardType = TOverlayerGiftBox.TYPE_ALL;
         this.FGiftBoxTipData.NeedColour = true;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FGiftBoxTipData);
      }
      
      protected function OnGiftOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FGiftBoxTipData);
      }
      
      public function set ExchangeCall(param1:Function) : void
      {
         this.FExchangeCall = param1;
      }
      
      public function UIDispatch(param1:MovieClip, param2:uint = 6) : void
      {
         var _loc3_:Bitmap = null;
         var _loc4_:uint = 0;
         var _loc5_:TUIButton = null;
         var _loc6_:MovieClip = null;
         var _loc7_:TCoordinate = null;
         this.FItemCount = param2;
         this.FMainUI = param1;
         _loc3_ = new Bitmap(SUtilityResource.BtmDataFullScreen);
         addChild(_loc3_);
         addChild(this.FMainUI);
         this.FMainUI.x = (_loc3_.width - this.FMainUI.width) / 2;
         this.FMainUI.y = (_loc3_.height - this.FMainUI.height) / 2;
         this.FExchangeBtns = new Vector.<TUIButton>();
         this.FGifts = new Vector.<TUIButton>();
         _loc4_ = 0;
         while(_loc4_ < this.FItemCount)
         {
            _loc6_ = this.FMainUI["MC_Item_" + _loc4_];
            _loc5_ = new TUIButton();
            _loc5_.Substrate = _loc6_.Btn_Exchange;
            _loc5_.OnClick = this.OnExchangeBtnClick;
            _loc5_.Tag = _loc4_;
            this.FExchangeBtns[_loc4_] = _loc5_;
            _loc5_ = new TUIButton();
            _loc5_.Substrate = _loc6_.Btn_Gift;
            _loc5_.OnMove = this.OnGiftMove;
            _loc5_.OnOut = this.OnGiftOut;
            _loc5_.Tag = _loc4_;
            this.FGifts[_loc4_] = _loc5_;
            _loc4_++;
         }
         this.FPage = new TUIPage(this);
         this.FPage.ButtonNext.Substrate = param1.MC_ChangeSlotPage.MC_PageRight;
         this.FPage.ButtonPrevious.Substrate = param1.MC_ChangeSlotPage.MC_PageLeft;
         this.FPage.LabelPage = param1.MC_ChangeSlotPage.TF_Page;
         this.FPage.PageSize = this.FItemCount;
         this.FPage.OnChangePage = this.PageOnSwitch;
         this.FPage.Init();
         this.FPage.Update();
         this.FCloseBtn = new TUIButton();
         this.FCloseBtn.Substrate = this.FMainUI.btn_close;
         this.FCloseBtn.OnClick = this.OnCloseBtnClick;
         _loc7_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(Parent);
         X -= _loc7_.X;
         Y -= _loc7_.Y;
      }
      
      public function SetupBasicInfo(param1:Vector.<TInventories>, param2:Vector.<uint>, param3:Vector.<Boolean>) : void
      {
         this.FVecInventories = param1;
         this.FPage.SetupPage(this.FVecInventories.length,0);
         this.FPageIndex = 0;
         this.FInfiniteBuy = param3;
         this.FPrices = param2;
      }
      
      public function Update(param1:uint, param2:Vector.<int>) : void
      {
         if(!Visible || this.FMainUI == null)
         {
            return;
         }
         this.FTotalScore = param1;
         this.FStates = param2;
         this.UpdatePage();
      }
   }
}

