package Processors.Game.Lobby.TreasureMap
{
   import Components.Pages.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Purchases.TPurchaseParameters;
   import Logics.Purchases.TPurchaseRequest;
   import Logics.SLogicsCore;
   import Logics.TreasureMap.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.TreasureMap.Components.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowTreasureExchange extends TProcessorLobbyWindow
   {
      
      protected static const MAX_ITEMCOUNT:uint = 12;
      
      protected static const MAX_MAPITEMCOUNT:uint = 5;
      
      protected var FPurchaseParameters:TPurchaseParameters;
      
      protected var FMC:MovieClip;
      
      protected var FTF_BlueStar:TextField;
      
      protected var FTF_RedStar:TextField;
      
      protected var FTF_Page:TextField;
      
      protected var FBtn_LeftPage:MovieClip;
      
      protected var FBtn_RightPage:MovieClip;
      
      protected var FBtn_Help:SimpleButton;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FUIPage:TUIPage;
      
      protected var FPageIndex:int;
      
      protected var FExchangeItemVect:Vector.<TUITreasureExchangeItem>;
      
      protected var FMapItemVect:Vector.<MovieClip>;
      
      protected var FMapNameVect:Vector.<TextField>;
      
      protected var FMallVect:Vector.<TMall>;
      
      protected var FTreasureMapData:TTreasureMapData;
      
      protected var FData_BlueStar:int;
      
      protected var FData_RedStar:int;
      
      protected var FMallBin:TBins;
      
      protected var FDiggingBins:TBins;
      
      protected var FOnItemSlotOver:Function;
      
      protected var FOnItemSlotOut:Function;
      
      protected var FOnExchange:Function;
      
      public function TProcessorWindowTreasureExchange(param1:TUIComponent)
      {
         super(param1);
         this.FExchangeItemVect = new Vector.<TUITreasureExchangeItem>();
         this.FMapItemVect = new Vector.<MovieClip>(MAX_MAPITEMCOUNT);
         this.FMapNameVect = new Vector.<TextField>(MAX_MAPITEMCOUNT);
         this.FMallVect = new Vector.<TMall>();
         this.ConstructPurchase();
      }
      
      protected function ConstructPurchase() : void
      {
         this.FPurchaseParameters = new TPurchaseParameters();
         this.FPurchaseParameters.RoutineSuccess = this.PurchaseRoutineSuccess;
         this.FPurchaseParameters.RoutineFailure = this.PurchaseRoutineFailure;
         this.FPurchaseParameters.RoutineCancel = this.PurchaseRoutineCancel;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_TREASUREMAP.RESOURCE_TREASUREMAP);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIWait() : void
      {
         if(SResourcesCore.LoadingPrimary)
         {
            return;
         }
         super.ResourcesPerform_UIWait();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FMallBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Mall);
         this.FDiggingBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Digging);
         this.InitExchangeUI();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FExchangeItemVect.length > 0)
         {
            _loc2_ = int(this.FExchangeItemVect.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FExchangeItemVect[_loc1_].UpDateSlot();
               _loc1_++;
            }
         }
      }
      
      protected function InitExchangeUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUITreasureExchangeItem = null;
         var _loc4_:TMall = null;
         var _loc5_:TDigging = null;
         this.FMC = TUtilityReflection.CreateDisplayObjectInstance(CONST_TREASUREMAP.RESOURCE_ClassName_MC_TreasureExChange) as MovieClip;
         addChild(this.FMC);
         this.FTF_BlueStar = this.FMC[CONST_TREASUREMAP.RESOURCE_Link_TF_BlueStar];
         this.FTF_RedStar = this.FMC[CONST_TREASUREMAP.RESOURCE_Link_TF_RedStar];
         this.FBtn_Close = this.FMC[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Help = this.FMC[CONST_COMMON.RESOURCE_Link_Btn_Help];
         this.FBtn_LeftPage = this.FMC[CONST_TREASUREMAP.RESOURCE_Link_Btn_LeftPage];
         this.FBtn_RightPage = this.FMC[CONST_TREASUREMAP.RESOURCE_Link_Btn_RightPage];
         this.FTF_Page = this.FMC[CONST_TREASUREMAP.RESOURCE_Link_TF_Page];
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = this.FBtn_LeftPage;
         this.FUIPage.ButtonNext.Substrate = this.FBtn_RightPage;
         this.FUIPage.LabelPage = this.FTF_Page;
         this.FUIPage.PageSize = MAX_ITEMCOUNT;
         this.FUIPage.OnChangePage = this.ProcessorOnChangePage;
         this.FUIPage.Init();
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.BtnCloseOnClick);
         _loc2_ = int(MAX_ITEMCOUNT);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUITreasureExchangeItem(this);
            _loc3_.Perform_UIDispatch(this.FMC[CONST_TREASUREMAP.RESOURCE_Link_MC_Item + _loc1_]);
            _loc3_.OnSlotOver = this.SlotOnOver;
            _loc3_.OnSlotOut = this.SlotOnOut;
            _loc3_.OnExchange = this.ProcessorOnExchange;
            this.FExchangeItemVect.push(_loc3_);
            _loc1_++;
         }
         _loc2_ = int(MAX_MAPITEMCOUNT);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FDiggingBins.GetDatebaseByIndex(_loc1_) as TDigging;
            this.FMC[CONST_TREASUREMAP.RESOURCE_Link_TF_MapName + _loc1_].text = _loc5_.Name.toString();
            this.FMC[CONST_TREASUREMAP.RESOURCE_Link_MC_Map + _loc1_].gotoAndStop(_loc1_ + 1);
            _loc1_++;
         }
         if(this.FMallBin == null)
         {
            return;
         }
         _loc2_ = this.FMallBin.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FMallBin.GetDatebaseByIndex(_loc1_) as TMall;
            if(_loc4_.Model == 3)
            {
               this.FMallVect.push(_loc4_);
            }
            _loc1_++;
         }
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TMall = null;
         _loc2_ = int(this.FExchangeItemVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ >= this.FMallVect.length)
            {
               this.FExchangeItemVect[_loc1_].Visible = false;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FPageIndex * MAX_ITEMCOUNT + _loc1_ < this.FMallVect.length)
            {
               _loc3_ = this.FMallVect[this.FPageIndex * MAX_ITEMCOUNT + _loc1_];
               this.FExchangeItemVect[_loc1_].UpData(_loc3_);
               this.FExchangeItemVect[_loc1_].Visible = true;
            }
            _loc1_++;
         }
         this.UpdateUIPage();
      }
      
      protected function UpdateStarUI() : void
      {
         this.FTF_BlueStar.text = this.FTreasureMapData.BlueStar.toString();
         this.FTF_RedStar.text = this.FTreasureMapData.RedStar.toString();
      }
      
      protected function UpdateUIPage() : void
      {
         this.FUIPage.TotalQuantity = this.FMallVect.length;
         this.FUIPage.PageIndex = this.FPageIndex;
         this.FUIPage.Update();
      }
      
      protected function PurchaseRoutineSuccess() : void
      {
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_45));
      }
      
      protected function PurchaseRoutineFailure() : void
      {
      }
      
      protected function PurchaseRoutineCancel() : void
      {
      }
      
      protected function ProcessorOnExchange(param1:Object, param2:int, param3:int, param4:int, param5:int) : void
      {
         var _loc6_:TPurchaseRequest = null;
         if(param2 <= 0 || param3 <= 0)
         {
            return;
         }
         if(param4 == 8)
         {
            if(this.FTreasureMapData.BlueStar < param5)
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_12));
               return;
            }
         }
         else if(param4 == 9)
         {
            if(this.FTreasureMapData.RedStar < param5)
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_12));
               return;
            }
         }
         _loc6_ = SLogicsCore.PoolPurchase.AcquirePurchaseRequest();
         _loc6_.IDTemplate = param2;
         _loc6_.Quantity = param3;
         if(this.FOnExchange != null)
         {
            this.FOnExchange(this,_loc6_,this.FPurchaseParameters);
         }
      }
      
      protected function ProcessorOnChangePage(param1:Object, param2:int) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(param2 == this.FPageIndex)
         {
            return;
         }
         this.FPageIndex = param2;
         _loc4_ = MAX_ITEMCOUNT;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.FPageIndex * MAX_ITEMCOUNT + _loc3_ >= this.FMallVect.length)
            {
               this.FExchangeItemVect[_loc3_].Visible = false;
            }
            else
            {
               this.FExchangeItemVect[_loc3_].UpData(this.FMallVect[this.FPageIndex * MAX_ITEMCOUNT + _loc3_]);
               this.FExchangeItemVect[_loc3_].Visible = true;
            }
            _loc3_++;
         }
         this.UpdateUIPage();
      }
      
      protected function SlotOnOver(param1:Object, param2:Object) : void
      {
         if(this.FOnItemSlotOver != null)
         {
            this.FOnItemSlotOver(param1,param2);
         }
      }
      
      protected function SlotOnOut(param1:Object, param2:Object) : void
      {
         if(this.FOnItemSlotOut != null)
         {
            this.FOnItemSlotOut(param1,param2);
         }
      }
      
      protected function BtnCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      override public function get Visible() : Boolean
      {
         return super.Visible;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         this.FPageIndex = 0;
         super.Visible = param1;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
      }
      
      public function get OnItemSlotOver() : Function
      {
         return this.FOnItemSlotOver;
      }
      
      public function set OnItemSlotOver(param1:Function) : void
      {
         this.FOnItemSlotOver = param1;
      }
      
      public function get OnItemSlotOut() : Function
      {
         return this.FOnItemSlotOut;
      }
      
      public function set OnItemSlotOut(param1:Function) : void
      {
         this.FOnItemSlotOut = param1;
      }
      
      public function get OnExchange() : Function
      {
         return this.FOnExchange;
      }
      
      public function set OnExchange(param1:Function) : void
      {
         this.FOnExchange = param1;
      }
      
      public function SetTreasureMapData(param1:TTreasureMapData) : void
      {
         this.FTreasureMapData = param1;
         this.UpDateUI();
      }
      
      public function UpDateUI() : void
      {
         this.UpdateUI();
         this.UpdateStarUI();
      }
      
      public function Reset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = this.FExchangeItemVect.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FExchangeItemVect[_loc1_].Reset();
            _loc1_++;
         }
         this.FPageIndex = 0;
      }
   }
}

