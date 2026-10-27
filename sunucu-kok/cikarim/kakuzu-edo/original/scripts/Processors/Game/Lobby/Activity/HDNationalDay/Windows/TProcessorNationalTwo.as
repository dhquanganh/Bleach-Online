package Processors.Game.Lobby.Activity.HDNationalDay.Windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.THDNationalDayTwo;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNationalDay.TNationalDayTwo;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Activity.HDActivity.Common.THDScoreExchangeShop;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorNationalTwo extends TProcessorHDSingleWindowBase
   {
      
      protected var FBtn_Discount:TUIButton;
      
      protected var FBtn_Refresh:TUIButton;
      
      protected var FBtn_Shop:TUIButton;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FBtn_Buys:Vector.<TUIButton>;
      
      protected var FExchangeShop:THDScoreExchangeShop;
      
      protected var FIsinit:Boolean;
      
      protected var FBuyIndex:int;
      
      protected var FJackPoint:TShowAwardUI;
      
      protected var FBtn_Report:TUIButton;
      
      protected var FConfig:THDNationalDayTwo;
      
      protected var FData:TNationalDayTwo;
      
      public function TProcessorNationalTwo(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDNationalDayTwo = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDNationalDayTwo;
         this.FConfig = _loc3_;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FData = param1 as TNationalDayTwo;
         FScene["TF_Free"].text = this.FData.Free + "";
         FScene["TF_Score"].text = this.FData.Score + "";
         if(!this.FIsinit)
         {
            this.SetupShop();
            if(this.FData.IsDiscount == -1)
            {
               FScene["MC_Effect"].gotoAndStop(34);
            }
            else
            {
               FScene["MC_Effect"].gotoAndStop(1);
            }
            this.FIsinit = true;
         }
         _loc3_ = 6;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FSlots[_loc2_].Context = this.FData.GetCurItemsInfo()[_loc2_].inv;
            FScene["SP_Slot_" + _loc2_]["MC_OldPrice_1"]["TF_Price"].text = this.FData.GetCurItemsInfo()[_loc2_].price + "";
            FScene["SP_Slot_" + _loc2_]["MC_NewPrice_1"]["TF_Price"].text = uint(this.FData.GetCurItemsInfo()[_loc2_].price * this.FData.Config.Discount / 10) + "";
            this.FBtn_Buys[_loc2_].Enabled = this.FData.CurItemsLast[this.FData.CurItemsIndex[_loc2_] - 1] > 0 ? true : false;
            _loc2_++;
         }
         this.FExchangeShop.Update(this.FData.Score,this.FData.ShopStatus);
         this.UpdateJackPoint();
         FScene["TF_Discount"].text = this.FData.IsDiscount == -1 ? this.FData.Config.Discount + "" : "?";
         this.FBtn_Discount.Visible = this.FData.IsDiscount == -1 ? false : true;
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
      
      protected function UpdateJackPoint() : void
      {
         var _loc1_:Sprite = null;
         this.FJackPoint.SetData(this.FData.Config.Bag.showType,this.FData.Config.Bag.awardId,this.FData.Config.Bag.showID);
         this.FBtn_Report.Visible = this.FData.Config.Bag.fightReportAddr != "";
      }
      
      protected function ProcessorRefresh(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FConfig.RefreshCost,this.ProcessorGoldRefresh);
      }
      
      protected function ProcessorBuyOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FBuyIndex = param1.Tag;
         if(this.FData.Free > 0)
         {
            this.ProcessorGoldBuyOnClick(null);
         }
         else
         {
            GoldBuy(this.FData.Config.Items[this.FData.CurItemsIndex[param1.Tag] - 1].gold * this.FData.Config.Discount / 10,this.ProcessorGoldBuyOnClick);
         }
      }
      
      protected function ProcessorGoldRefresh(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.RefreshIndex);
      }
      
      protected function ProcessorGoldBuyOnClick(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Items[this.FData.CurItemsIndex[this.FBuyIndex] - 1].index);
      }
      
      protected function ProcessorOpenDiscount(param1:Object, param2:MouseEvent) : void
      {
         FScene["MC_Effect"].play();
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.DiscountIndex);
      }
      
      protected function ProcessorReport(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FData.Config.Bag.fightReportAddr);
      }
      
      protected function ProcessorOpenShop(param1:Object, param2:MouseEvent) : void
      {
         this.FExchangeShop.Visible = true;
         this.FExchangeShop.Update(this.FData.Score,this.FData.ShopStatus);
      }
      
      protected function SetupShop() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Vector.<uint> = null;
         var _loc3_:Vector.<Boolean> = null;
         var _loc4_:TInventories = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc2_ = new Vector.<uint>();
         _loc3_ = new Vector.<Boolean>();
         _loc4_ = new TInventories();
         _loc5_ = this.FData.Config.Mall.length;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc2_.push(this.FData.Config.Mall[_loc6_].score);
            _loc3_.push(this.FData.Config.Mall[_loc6_].limit == 0);
            SToolReward.GetAwardsByAwardID(this.FData.Config.Mall[_loc6_].award,_loc4_);
            _loc6_++;
         }
         this.FExchangeShop.SetupBasicInfo(_loc4_,_loc2_,_loc3_);
      }
      
      protected function ExchangeCall(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         _loc3_ = this.FData.Config.Mall[param1];
         _loc2_ = uint(_loc3_.score);
         if(this.FData.Score >= _loc2_)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.index);
         }
         else
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_63));
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         super.InitWindow(param1);
         this.FBtn_Discount = new TUIButton();
         this.FBtn_Discount.Substrate = FScene["Btn_Discount"];
         this.FBtn_Discount.OnClick = this.ProcessorOpenDiscount;
         this.FBtn_Refresh = new TUIButton();
         this.FBtn_Refresh.Substrate = FScene["Btn_Reflesh"];
         this.FBtn_Refresh.OnClick = this.ProcessorRefresh;
         this.FBtn_Shop = new TUIButton();
         this.FBtn_Shop.Substrate = FScene["Btn_Shop"];
         this.FBtn_Shop.OnClick = this.ProcessorOpenShop;
         _loc2_ = 6;
         this.FBtn_Buys = new Vector.<TUIButton>(_loc2_);
         this.FSlots = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBtn_Buys[_loc3_] = new TUIButton();
            this.FBtn_Buys[_loc3_].Substrate = FScene["SP_Slot_" + _loc3_]["Btn_Buy"];
            this.FBtn_Buys[_loc3_].OnClick = this.ProcessorBuyOnClick;
            this.FBtn_Buys[_loc3_].Tag = _loc3_;
            this.FSlots[_loc3_] = new TUISlot(this);
            this.FSlots[_loc3_].Resource = FScene["SP_Slot_" + _loc3_]["MC_Slot"]["Slot"];
            this.FSlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots[_loc3_]);
            this.FSlots[_loc3_].Init();
            _loc3_++;
         }
         _loc4_ = TUtilityReflection.CreateDisplayObjectInstance("MC_NationalShop") as MovieClip;
         this.FExchangeShop = new THDScoreExchangeShop(this);
         this.FExchangeShop.ExchangeCall = this.ExchangeCall;
         this.FExchangeShop.UIDispatch(_loc4_);
         this.FExchangeShop.Visible = false;
         this.FJackPoint = new TShowAwardUI(this);
         this.FJackPoint.UIDispatch(FScene["MC_MountPoint"]["SP_ShowUI"]);
         this.FBtn_Report = new TUIButton();
         this.FBtn_Report.Substrate = FScene["MC_MountPoint"]["SP_ShowUI"]["Btn_Report"];
         this.FBtn_Report.OnClick = this.ProcessorReport;
      }
   }
}

