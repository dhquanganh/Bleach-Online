package Processors.Game.Lobby.CrashJade
{
   import Components.Pages.TUIPage;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.CrashJade.TCrashJadeData;
   import Logics.CrashJade.TCrashJadeShopItemVO;
   import Logics.Purchases.TPurchaseParameters;
   import Logics.Purchases.TPurchaseRequest;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TProcessoeCrashJadeShop extends TProcessorLobbyWindow
   {
      
      protected const PageMax:uint = 12;
      
      protected var FPurchaseParameters:TPurchaseParameters;
      
      protected var FMainUI:MovieClip;
      
      protected var FMask:Bitmap;
      
      protected var FData:TCrashJadeData;
      
      protected var FItems:Vector.<TCrashJadeShopItem>;
      
      protected var FExchangeBtns:Vector.<TUIButton>;
      
      protected var FPage:TUIPage;
      
      protected var FCurPage:uint;
      
      protected var FCloseBtn:TUIButton;
      
      protected var FBuyItem:TCrashJadeShopItemVO;
      
      protected var FOnExchange:Function;
      
      protected var FParentUIUpdate:Function;
      
      public function TProcessoeCrashJadeShop(param1:TUIComponent)
      {
         super(param1);
         this.FItems = new Vector.<TCrashJadeShopItem>();
         this.FExchangeBtns = new Vector.<TUIButton>();
         this.ConstructPurchase();
      }
      
      protected function ConstructPurchase() : void
      {
         this.FPurchaseParameters = new TPurchaseParameters();
         this.FPurchaseParameters.RoutineSuccess = this.PurchaseRoutineSuccess;
         this.FPurchaseParameters.RoutineFailure = this.PurchaseRoutineFailure;
         this.FPurchaseParameters.RoutineCancel = this.PurchaseRoutineCancel;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TCrashJadeShopItem = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_CrashJadeShop") as MovieClip;
         this.FMask = new Bitmap(SUtilityResource.BtmDataFullScreen);
         addChild(this.FMask);
         addChild(this.FMainUI);
         this.FMainUI.x = (this.FMask.width - this.FMainUI.width) / 2;
         this.FMainUI.y = (this.FMask.height - this.FMainUI.height) / 2;
         _loc1_ = 0;
         while(_loc1_ < this.PageMax)
         {
            _loc2_ = new TCrashJadeShopItem(this);
            _loc2_.UIDispose(this.FMainUI["MC_Item_" + _loc1_]);
            _loc2_.OnExchange = this.ProcessorOnExchange;
            this.FItems.push(_loc2_);
            _loc1_++;
         }
         this.FPage = new TUIPage(this);
         this.FPage.ButtonNext.Substrate = this.FMainUI.MC_Page.MC_PageRight;
         this.FPage.ButtonPrevious.Substrate = this.FMainUI.MC_Page.MC_PageLeft;
         this.FPage.LabelPage = this.FMainUI.MC_Page.TF_Page;
         this.FPage.PageSize = this.PageMax;
         this.FPage.TotalQuantity = this.FData.ShopItems.length;
         this.FPage.OnChangePage = this.PageOnSwitch;
         this.FPage.Init();
         this.FPage.Update();
         this.FCloseBtn = new TUIButton();
         this.FCloseBtn.Substrate = this.FMainUI.Btn_Close;
         this.FCloseBtn.OnClick = this.OnCloseBtnClick;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:TCrashJadeShopItem = null;
         if(Visible)
         {
            for each(_loc1_ in this.FItems)
            {
               _loc1_.LogicsPerform();
            }
         }
         super.LogicsPerform();
      }
      
      protected function LocalToGlobalIndex(param1:uint) : uint
      {
         return this.FCurPage * this.PageMax + param1;
      }
      
      protected function UpdatePage() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TCrashJadeShopItem = null;
         var _loc3_:TCrashJadeShopItemVO = null;
         var _loc4_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this.PageMax)
         {
            _loc2_ = this.FItems[_loc1_];
            _loc4_ = this.LocalToGlobalIndex(_loc1_);
            if(_loc4_ < this.FData.ShopItems.length)
            {
               _loc2_.Show();
               _loc3_ = this.FData.ShopItems[_loc4_];
               _loc2_.Data = _loc3_;
            }
            else
            {
               _loc2_.Hide();
            }
            _loc1_++;
         }
      }
      
      protected function PurchaseRoutineSuccess() : void
      {
         SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_43));
         this.FData.ShopCoinCount -= this.FBuyItem.Mall.Items.Amount;
         ++this.FBuyItem.BuyCont;
         this.UpdateUI();
         this.FParentUIUpdate();
      }
      
      protected function PurchaseRoutineFailure() : void
      {
      }
      
      protected function PurchaseRoutineCancel() : void
      {
      }
      
      protected function ProcessorOnExchange(param1:TCrashJadeShopItemVO, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:TPurchaseRequest = null;
         if(param2 <= 0 || param3 <= 0)
         {
            return;
         }
         if(this.FData.ShopCoinCount < param4)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_42));
            return;
         }
         _loc5_ = SLogicsCore.PoolPurchase.AcquirePurchaseRequest();
         _loc5_.IDTemplate = param2;
         _loc5_.Quantity = param3;
         if(this.FOnExchange != null)
         {
            this.FOnExchange(this,_loc5_,this.FPurchaseParameters);
         }
         this.FBuyItem = param1;
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         this.FCurPage = param2;
         this.UpdatePage();
      }
      
      protected function OnCloseBtnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         this.UpdateUI();
      }
      
      public function set Data(param1:TCrashJadeData) : void
      {
         this.FData = param1;
      }
      
      public function set OnExchange(param1:Function) : void
      {
         this.FOnExchange = param1;
      }
      
      public function set ParentUIUpdate(param1:Function) : void
      {
         this.FParentUIUpdate = param1;
      }
      
      public function UpdateUI() : void
      {
         var _loc1_:TCrashJadeShopItem = null;
         if(!Visible || this.FMainUI == null)
         {
            return;
         }
         this.FMainUI.Txt_Value.text = this.FData.ShopCoinCount.toString();
         this.UpdatePage();
      }
   }
}

