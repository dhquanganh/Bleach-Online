package Processors.Game.Lobby.Organization.Part.SecondPart
{
   import Components.Pages.TUIPage;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.Organization.NewFeatures.TNewOrgData;
   import Logics.Organization.VO.TOrgShopCommodityItemVO;
   import Logics.Streamization.Organization.TUnstreamizerOrganizationNew;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.CONST_COMMON;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class TCompOrgShop extends TUIComponent
   {
      
      protected const EachPageCount:uint = 6;
      
      protected const ShopType_Normal:uint = 3;
      
      protected const ShopType_Special:uint = 4;
      
      protected const SpecialBg_Frame:uint = 1;
      
      protected const NormalBg_Frame:uint = 2;
      
      protected var FMainUI:MovieClip;
      
      protected var FBtn_Exchange:TUIButton;
      
      protected var FBtn_Update:TUIButton;
      
      protected var FTF_RemainMoney:TextField;
      
      protected var FTabs:TUITab;
      
      protected var FPage:TUIPage;
      
      protected var FCommoditys:Vector.<MovieClip>;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FCurrentShopVOs:Vector.<TOrgShopCommodityItemVO>;
      
      protected var FBuyBtns:Vector.<TUIButton>;
      
      protected var FCurrentRefleshTime:Vector.<uint>;
      
      protected var FPageIndex:uint;
      
      protected var FNextFlushTimeIndex:int;
      
      protected var FSpecialInit:Boolean;
      
      protected var FData:TNewOrgData;
      
      protected var FUnstreamizerOrganizationNew:TUnstreamizerOrganizationNew;
      
      protected var FOnOpenShopExchang:Function;
      
      protected var FCurrentShopType:uint;
      
      public function TCompOrgShop(param1:TUIComponent)
      {
         super(param1);
         this.FCommoditys = new Vector.<MovieClip>(this.EachPageCount);
         this.FSlots = new Vector.<TUISlot>(this.EachPageCount);
         this.FBuyBtns = new Vector.<TUIButton>(this.EachPageCount);
         this.FCurrentShopType = this.ShopType_Normal;
         this.FPageIndex = 0;
         this.FSpecialInit = false;
      }
      
      protected function GetGlobalIconIndexByLocal(param1:uint) : uint
      {
         return this.FPageIndex * this.EachPageCount + param1;
      }
      
      protected function UpdateNextFlushTime() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = (STimingCore.ServerTick - STimingCore.ServerTimeZone) % CONST_COMMON.SecondPerDay;
         _loc3_ = int(this.FCurrentRefleshTime.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FCurrentRefleshTime[_loc2_] * CONST_COMMON.SecondPerHour;
            if(_loc1_ < _loc4_)
            {
               break;
            }
            _loc2_++;
         }
         _loc2_ = _loc2_ == _loc3_ ? 0 : int(_loc2_);
         if(this.FNextFlushTimeIndex != _loc2_)
         {
            this.FMainUI.TF_TimeCounter.text = TUtilityTiming.fomatTime(this.FCurrentRefleshTime[_loc2_] * CONST_COMMON.SecondPerHour);
            this.FNextFlushTimeIndex = _loc2_;
         }
      }
      
      protected function OnBuyBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TOrgShopCommodityItemVO = null;
         var _loc7_:String = null;
         _loc3_ = param1 as TUIButton;
         _loc4_ = uint(_loc3_.Tag);
         _loc5_ = this.GetGlobalIconIndexByLocal(_loc4_);
         _loc6_ = this.FCurrentShopVOs[_loc5_];
         if(_loc6_.Market.Price.amount > this.FData.GroupMoney)
         {
            _loc7_ = this.FData.NewOrgSystemLanguage.GetStr27();
            SToolReward.ShowMessage(_loc7_);
            return;
         }
         this.FUnstreamizerOrganizationNew.MallBuyReq(this.FCurrentShopType,_loc6_.Market.Identifier);
      }
      
      protected function OpenExchange(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnOpenShopExchang != null)
         {
            this.FOnOpenShopExchang();
         }
      }
      
      protected function OnClickUpdateBtn(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:TUIWindowConfirmation = null;
         if(this.FData.MallRefreshCounts >= this.FData.OrgConfigValue.TotalResetCount_Mall)
         {
            _loc3_ = this.FData.NewOrgSystemLanguage.GetStr26();
            SToolReward.ShowMessage(_loc3_);
            return;
         }
         _loc4_ = SUtilityOverLayer.UIWindowConfirmation;
         _loc4_.Text = this.FData.NewOrgSystemLanguage.GetStr28();
         _loc4_.OnOK = this.OnUpdateOkCall;
         _loc4_.Visible = true;
      }
      
      protected function OnUpdateOkCall(param1:Object) : void
      {
         var _loc2_:String = null;
         if(this.FData.OrgConfigValue.Mall_Reset_Price[this.FData.MallRefreshCounts] > this.FData.GroupMoney)
         {
            _loc2_ = this.FData.NewOrgSystemLanguage.GetStr27();
            SToolReward.ShowMessage(_loc2_);
            return;
         }
         this.FUnstreamizerOrganizationNew.MallRefreshReq(this.FCurrentShopType);
      }
      
      protected function OnSwitchShop(param1:int) : void
      {
         this.FCurrentShopType = param1 == 0 ? this.ShopType_Normal : this.ShopType_Special;
         if(this.FCurrentShopType == this.ShopType_Special && !this.FSpecialInit)
         {
            this.FUnstreamizerOrganizationNew.MallInitReq(this.FCurrentShopType);
            this.FSpecialInit = true;
            return;
         }
         this.Update();
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdateCurrentPage();
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         this.Update();
      }
      
      public function set Data(param1:TNewOrgData) : void
      {
         this.FData = param1;
      }
      
      public function set OnOpenShopExchang(param1:Function) : void
      {
         this.FOnOpenShopExchang = param1;
      }
      
      public function get CurrentShopType() : uint
      {
         return this.FCurrentShopType;
      }
      
      public function set UnstreamizerOrganizationNew(param1:TUnstreamizerOrganizationNew) : void
      {
         this.FUnstreamizerOrganizationNew = param1;
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:Point = null;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:uint = 0;
         var _loc6_:TUISlot = null;
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         var _loc9_:TUIButton = null;
         this.FMainUI = param1;
         addChildAt(this.FMainUI,0);
         this.FBtn_Exchange = new TUIButton();
         this.FBtn_Exchange.Substrate = this.FMainUI["Btn_Exchange"];
         this.FBtn_Exchange.OnClick = this.OpenExchange;
         this.FBtn_Exchange.Enabled = false;
         this.FBtn_Update = new TUIButton();
         this.FBtn_Update.Substrate = this.FMainUI["Btn_Update"];
         this.FBtn_Update.OnClick = this.OnClickUpdateBtn;
         this.FTF_RemainMoney = this.FMainUI["TF_RemainMoney"];
         _loc3_ = this.FMainUI["Btn_Shop"];
         _loc4_ = this.FMainUI["Btn_Special"];
         this.FTabs = new TUITab(this);
         this.FTabs.SetTabByIndex(_loc3_,0);
         this.FTabs.SetTabByIndex(_loc4_,1);
         this.FTabs.OnSwitch = this.OnSwitchShop;
         this.FTabs.Init();
         _loc8_ = this.FMainUI["MC_ChangeListPage"];
         this.FPage = new TUIPage(this);
         this.FPage.LabelPage = _loc8_["TF_Page"];
         this.FPage.ButtonNext.Substrate = _loc8_["MC_PageRight"];
         this.FPage.ButtonPrevious.Substrate = _loc8_["MC_PageLeft"];
         this.FPage.PageSize = this.EachPageCount;
         this.FPage.OnChangePage = this.PageOnSwitch;
         this.FPage.Init();
         this.FPage.Update();
         _loc5_ = 0;
         while(_loc5_ < this.EachPageCount)
         {
            _loc7_ = this.FMainUI["MC_Item_" + _loc5_];
            _loc9_ = new TUIButton();
            _loc9_.Substrate = _loc7_["BuyBtn"];
            _loc9_.Tag = _loc5_;
            _loc9_.OnClick = this.OnBuyBtnClick;
            _loc6_ = new TUISlot(this);
            _loc6_.Resource = _loc7_["Slot"];
            _loc6_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc6_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc6_);
            _loc6_.Init();
            this.FCommoditys[_loc5_] = _loc7_;
            this.FSlots[_loc5_] = _loc6_;
            this.FBuyBtns[_loc5_] = _loc9_;
            _loc5_++;
         }
         this.FMainUI.TF_Lable.text = this.FData.NewOrgSystemLanguage.GetStr25();
      }
      
      public function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(Visible)
         {
            _loc2_ = this.FSlots.length;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FSlots[_loc1_].Update();
               _loc1_++;
            }
            this.UpdateNextFlushTime();
         }
      }
      
      public function Update() : void
      {
         if(Visible && this.FData != null)
         {
            this.FNextFlushTimeIndex = -1;
            if(this.FCurrentShopType == this.ShopType_Normal)
            {
               this.FCurrentShopVOs = this.FData.ShopVOs;
               this.FCurrentRefleshTime = this.FData.OrgConfigValue.ORG_Mall_RefleshTime;
               this.FMainUI.Btn_Update.visible = true;
            }
            else
            {
               this.FCurrentShopVOs = this.FData.SpecialVOs;
               this.FCurrentRefleshTime = this.FData.OrgConfigValue.ORG_Mall_DailyRefleshTime;
               this.FMainUI.Btn_Update.visible = false;
            }
            this.FPage.SetupPage(this.FCurrentShopVOs.length,0);
            this.FPageIndex = 0;
            this.UpdateCurrentPage();
         }
      }
      
      public function UpdateCurrentPage() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         var _loc4_:TOrgShopCommodityItemVO = null;
         var _loc5_:uint = 0;
         var _loc6_:TInventories = null;
         var _loc7_:TInventory = null;
         var _loc8_:TUISlot = null;
         var _loc9_:TUIButton = null;
         var _loc10_:MovieClip = null;
         if(Visible && this.FData != null)
         {
            _loc3_ = this.FCurrentShopVOs.length;
            _loc1_ = 0;
            while(_loc1_ < this.EachPageCount)
            {
               _loc2_ = this.FCommoditys[_loc1_];
               _loc9_ = this.FBuyBtns[_loc1_];
               _loc8_ = this.FSlots[_loc1_];
               _loc10_ = _loc2_["MC_Bg"];
               _loc5_ = this.GetGlobalIconIndexByLocal(_loc1_);
               if(_loc5_ < _loc3_)
               {
                  _loc2_.visible = true;
                  _loc4_ = this.FCurrentShopVOs[_loc5_];
                  _loc2_.MC_Buyed.visible = _loc4_.BuyCount >= _loc4_.Market.Number;
                  _loc9_.Enabled = !_loc2_.MC_Buyed.visible;
                  _loc2_.TF_Name.text = _loc4_.Name;
                  _loc2_.TF_Money.text = _loc4_.Market.Price.amount.toString();
                  _loc6_ = new TInventories();
                  SToolReward.GetInventoryByID(_loc4_.Market.ItemID,_loc6_);
                  _loc7_ = _loc6_.GetInventoryByIndex(0);
                  _loc7_.Quantity = _loc4_.Market.Number;
                  _loc8_.Context = _loc7_;
               }
               else
               {
                  _loc2_.visible = false;
               }
               if(this.FCurrentShopType == this.ShopType_Normal)
               {
                  _loc10_.gotoAndStop(this.NormalBg_Frame);
               }
               else
               {
                  _loc10_.gotoAndStop(this.SpecialBg_Frame);
               }
               _loc1_++;
            }
            this.FTF_RemainMoney.text = this.FData.GroupMoney.toString();
         }
      }
   }
}

