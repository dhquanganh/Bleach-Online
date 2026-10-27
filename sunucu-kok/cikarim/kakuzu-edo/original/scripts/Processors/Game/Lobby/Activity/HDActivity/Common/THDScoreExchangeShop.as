package Processors.Game.Lobby.Activity.HDActivity.Common
{
   import Components.Pages.TUIPage;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Common.TCoordinate;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityCartisian;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class THDScoreExchangeShop extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FPage:TUIPage;
      
      protected var FInventories:TInventories;
      
      protected var FItemCount:uint;
      
      protected var FPageIndex:uint;
      
      protected var FExchangeBtns:Vector.<TUIButton>;
      
      protected var FPrices:Vector.<uint>;
      
      protected var FInfiniteBuy:Vector.<Boolean>;
      
      protected var FTotalScore:uint;
      
      protected var FStates:Vector.<int>;
      
      protected var FCloseBtn:TUIButton;
      
      protected var FExchangeCall:Function;
      
      public function THDScoreExchangeShop(param1:TUIComponent)
      {
         super(param1);
         Visible = false;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:TUISlot = null;
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         if(this.FSlots != null)
         {
            for each(_loc1_ in this.FSlots)
            {
               _loc1_.Update();
            }
         }
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
         var _loc4_:TUISlot = null;
         var _loc5_:TUIButton = null;
         var _loc6_:int = 0;
         this.FMainUI.TF_Score.text = this.FTotalScore.toString();
         _loc1_ = 0;
         while(_loc1_ < this.FItemCount)
         {
            _loc2_ = this.FMainUI["MC_Item_" + _loc1_];
            _loc3_ = this.LocalToGlobalIndex(_loc1_);
            if(_loc3_ < this.FInventories.Count)
            {
               _loc2_.visible = true;
               _loc4_ = this.FSlots[_loc1_];
               _loc5_ = this.FExchangeBtns[_loc1_];
               _loc6_ = this.FStates[_loc3_];
               _loc4_.Context = this.FInventories.GetInventoryByIndex(_loc3_);
               _loc5_.Enabled = this.FPrices[_loc3_] <= this.FTotalScore && _loc6_ != CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
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
      
      public function set ExchangeCall(param1:Function) : void
      {
         this.FExchangeCall = param1;
      }
      
      public function UIDispatch(param1:MovieClip, param2:uint = 6) : void
      {
         var _loc3_:Bitmap = null;
         var _loc4_:uint = 0;
         var _loc5_:TUISlot = null;
         var _loc6_:TUIButton = null;
         var _loc7_:MovieClip = null;
         var _loc8_:TCoordinate = null;
         this.FItemCount = param2;
         this.FMainUI = param1;
         _loc3_ = new Bitmap(SUtilityResource.BtmDataFullScreen);
         addChild(_loc3_);
         addChild(this.FMainUI);
         this.FMainUI.x = (_loc3_.width - this.FMainUI.width) / 2;
         this.FMainUI.y = (_loc3_.height - this.FMainUI.height) / 2;
         this.FSlots = new Vector.<TUISlot>();
         this.FExchangeBtns = new Vector.<TUIButton>();
         _loc4_ = 0;
         while(_loc4_ < this.FItemCount)
         {
            _loc7_ = this.FMainUI["MC_Item_" + _loc4_];
            _loc5_ = new TUISlot(this);
            _loc5_.Resource = _loc7_.MC_Slot;
            _loc5_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc5_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc5_);
            _loc5_.Init();
            this.FSlots[_loc4_] = _loc5_;
            _loc6_ = new TUIButton();
            _loc6_.Substrate = _loc7_.Btn_Exchange;
            _loc6_.OnClick = this.OnExchangeBtnClick;
            _loc6_.Tag = _loc4_;
            this.FExchangeBtns[_loc4_] = _loc6_;
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
         _loc8_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(Parent);
         X -= _loc8_.X;
         Y -= _loc8_.Y;
      }
      
      public function SetupBasicInfo(param1:TInventories, param2:Vector.<uint>, param3:Vector.<Boolean>) : void
      {
         this.FInventories = param1;
         this.FPage.SetupPage(this.FInventories.Count,0);
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

