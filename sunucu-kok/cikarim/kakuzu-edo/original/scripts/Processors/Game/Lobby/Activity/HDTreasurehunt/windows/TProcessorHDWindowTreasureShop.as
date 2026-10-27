package Processors.Game.Lobby.Activity.HDTreasurehunt.windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.THDTreasureHuntShop;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDTreasureHunt.TTreasureShop;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Activity.HDActivity.Common.THDScoreExchangeShop;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowTreasureShop extends TProcessorHDSingleWindowBase
   {
      
      protected var FTF_DarkItemCount:uint;
      
      protected var FTF_LightItemCount:uint;
      
      protected var FBtn_LightBag:TUIButton;
      
      protected var FBtn_LightShop:TUIButton;
      
      protected var FBtn_LightGetOne:TUIButton;
      
      protected var FBtn_LightGetTen:TUIButton;
      
      protected var FBtn_LightClose:TUIButton;
      
      protected var FLightTips:MovieClip;
      
      protected var FLightSlots:Vector.<TUISlot>;
      
      protected var FLightExchangeShop:THDScoreExchangeShop;
      
      protected var FBtn_DarkBag:TUIButton;
      
      protected var FBtn_DarkShop:TUIButton;
      
      protected var FBtn_DarkGetOne:TUIButton;
      
      protected var FBtn_DarkGetTen:TUIButton;
      
      protected var FBtn_DarkClose:TUIButton;
      
      protected var FDarkTips:MovieClip;
      
      protected var FDarkSlots:Vector.<TUISlot>;
      
      protected var FDarkExchangeShop:THDScoreExchangeShop;
      
      protected var FJackPoint:TShowAwardUI;
      
      protected var FBtn_Report:TUIButton;
      
      protected var FBtn_JackPointGet:TUIButton;
      
      protected var FData:TTreasureShop;
      
      protected var FIsinit:Boolean;
      
      public function TProcessorHDWindowTreasureShop(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDTreasureHuntShop = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDTreasureHuntShop;
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
         var _loc4_:uint = 0;
         this.FData = param1 as TTreasureShop;
         this.FData.ActivityID = FActivityAtoms.Identifier;
         if(!this.FIsinit)
         {
            this.SetupLightShop();
            this.SetupDarkShop();
            this.FIsinit = true;
         }
         this.FLightExchangeShop.Update(this.FData.LightItemCount,this.FData.LightShopStatus);
         this.FDarkExchangeShop.Update(this.FData.DarkItemCount,this.FData.DarkShopStatus);
         FScene["TF_LightItemCount"].text = this.FData.LightItemCount;
         FScene["TF_DarkItemCount"].text = this.FData.DarkItemCount;
         this.UpdateJackPoint();
      }
      
      protected function UpdateJackPoint() : void
      {
         var _loc1_:Sprite = null;
         this.FJackPoint.SetData(this.FData.Config.BigAward.showType,this.FData.Config.BigAward.awardId,this.FData.Config.BigAward.showId);
         this.FBtn_Report.Visible = this.FData.Config.BigAward.fightReportAddr != "";
         FScene["SP_ShowUI"]["TF_Cost"].text = "" + this.FData.Config.BigAward.cost;
         if(this.FData.BigAwardStatus == -1)
         {
            FScene["SP_ShowUI"]["SP_AlreadyBuy"].visible = true;
            this.FBtn_JackPointGet.Visible = false;
         }
         else
         {
            if(this.FData.LightItemCount >= this.FData.Config.BigAward.cost || this.FData.DarkItemCount >= this.FData.Config.BigAward.cost)
            {
               this.FBtn_JackPointGet.Enabled = true;
            }
            else
            {
               this.FBtn_JackPointGet.Enabled = false;
            }
            FScene["SP_ShowUI"]["SP_AlreadyBuy"].visible = false;
         }
      }
      
      protected function SetupLightShop() : void
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
         _loc5_ = 6;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc2_.push(this.FData.Config.Shop[_loc6_ + 6].cost);
            _loc3_.push(this.FData.Config.Shop[_loc6_ + 6].num == 0);
            SToolReward.GetAwardsByAwardID(this.FData.Config.Shop[_loc6_ + 6].awardId,_loc4_);
            _loc6_++;
         }
         this.FLightExchangeShop.SetupBasicInfo(_loc4_,_loc2_,_loc3_);
      }
      
      protected function SetupDarkShop() : void
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
         _loc5_ = 6;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc2_.push(this.FData.Config.Shop[_loc6_].cost);
            _loc3_.push(this.FData.Config.Shop[_loc6_].num == 0);
            SToolReward.GetAwardsByAwardID(this.FData.Config.Shop[_loc6_].awardId,_loc4_);
            _loc6_++;
         }
         this.FDarkExchangeShop.SetupBasicInfo(_loc4_,_loc2_,_loc3_);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.LogicsPerform();
         if(Visible && this.FData != null)
         {
            _loc2_ = 6;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FLightSlots[_loc1_].Update();
               _loc1_++;
            }
            _loc2_ = 6;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FDarkSlots[_loc1_].Update();
               _loc1_++;
            }
         }
      }
      
      protected function ProcessorOpenLightWin(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc4_ = 6;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FLightSlots[_loc3_].Context = this.FData.LightShowItems.GetInventoryByIndex(_loc3_);
            _loc3_++;
         }
         this.FLightTips.visible = true;
      }
      
      protected function ProcessorCloseLightWin(param1:Object, param2:MouseEvent) : void
      {
         this.FLightTips.visible = false;
      }
      
      protected function ProcessorGetLightOne(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FData.Config.Cost,this.ProcessorGoldGetLightOne);
      }
      
      protected function ProcessorGetLightTen(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FData.Config.Cost * 10,this.ProcessorGoldGetLightTen);
      }
      
      protected function ProcessorGoldGetLightOne(param1:Object) : void
      {
         var _loc2_:Vector.<int> = null;
         _loc2_ = new Vector.<int>(1);
         _loc2_[0] = 1;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.LightIndex,0,_loc2_);
         FScene["MC_Light"]["Effect_One"].gotoAndPlay(1);
         FScene["MC_Light"]["Effect_back"].gotoAndPlay(1);
      }
      
      protected function ProcessorGoldGetLightTen(param1:Object) : void
      {
         var _loc2_:Vector.<int> = null;
         _loc2_ = new Vector.<int>(1);
         _loc2_[0] = 10;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.LightIndex,0,_loc2_);
         FScene["MC_Light"]["Effect_Ten"].gotoAndPlay(1);
         FScene["MC_Light"]["Effect_One"].gotoAndPlay(1);
         FScene["MC_Light"]["Effect_back"].gotoAndPlay(1);
      }
      
      protected function ProcessorOpenLightShop(param1:Object, param2:MouseEvent) : void
      {
         this.FLightExchangeShop.Visible = true;
         this.FLightExchangeShop.Update(this.FData.LightItemCount,this.FData.LightShopStatus);
      }
      
      protected function ProcessorOpenDarkWin(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc4_ = 6;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FDarkSlots[_loc3_].Context = this.FData.DarkShowItems.GetInventoryByIndex(_loc3_);
            _loc3_++;
         }
         this.FDarkTips.visible = true;
      }
      
      protected function ProcessorCloseDarkWin(param1:Object, param2:MouseEvent) : void
      {
         this.FDarkTips.visible = false;
      }
      
      protected function ProcessorGetDarkOne(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FData.Config.Cost,this.ProcessorGoldGetDarkOne);
      }
      
      protected function ProcessorGetDarkTen(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FData.Config.Cost * 10,this.ProcessorGoldGetDarkTen);
      }
      
      protected function ProcessorGoldGetDarkOne(param1:Object) : void
      {
         var _loc2_:Vector.<int> = null;
         _loc2_ = new Vector.<int>(1);
         _loc2_[0] = 1;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.DarkIndex,0,_loc2_);
         FScene["MC_Dark"]["Effect_One"].gotoAndPlay(1);
         FScene["MC_Dark"]["Effect_back"].gotoAndPlay(1);
      }
      
      protected function ProcessorGoldGetDarkTen(param1:Object) : void
      {
         var _loc2_:Vector.<int> = null;
         _loc2_ = new Vector.<int>(1);
         _loc2_[0] = 10;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.DarkIndex,0,_loc2_);
         FScene["MC_Dark"]["Effect_Ten"].gotoAndPlay(1);
         FScene["MC_Dark"]["Effect_One"].gotoAndPlay(1);
         FScene["MC_Dark"]["Effect_back"].gotoAndPlay(1);
      }
      
      protected function ProcessorOpenDarkShop(param1:Object, param2:MouseEvent) : void
      {
         this.FDarkExchangeShop.Visible = true;
         this.FDarkExchangeShop.Update(this.FData.DarkItemCount,this.FData.DarkShopStatus);
      }
      
      protected function LightExchangeCall(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         _loc3_ = this.FData.Config.Shop[param1 + 6];
         _loc2_ = uint(_loc3_.score);
         if(this.FData.DarkItemCount >= _loc2_)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.index);
         }
      }
      
      protected function DarkExchangeCall(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         _loc3_ = this.FData.Config.Shop[param1];
         _loc2_ = uint(_loc3_.score);
         if(this.FData.DarkItemCount >= _loc2_)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.index);
         }
      }
      
      protected function ProcessorGoldBuyJackPoint(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.BigAward.index);
      }
      
      protected function ProcessorReport(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FData.Config.BigAward.fightReportAddr);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         super.InitWindow(param1);
         this.FBtn_LightBag = new TUIButton();
         this.FBtn_LightBag.Substrate = FScene["MC_Light"]["Btn_Bag"];
         this.FBtn_LightBag.OnClick = this.ProcessorOpenLightWin;
         this.FBtn_LightShop = new TUIButton();
         this.FBtn_LightShop.Substrate = FScene["MC_Light"]["Btn_Shop"];
         this.FBtn_LightShop.OnClick = this.ProcessorOpenLightShop;
         this.FBtn_LightGetOne = new TUIButton();
         this.FBtn_LightGetOne.Substrate = FScene["MC_Light"]["Btn_Get"];
         this.FBtn_LightGetOne.OnClick = this.ProcessorGetLightOne;
         this.FBtn_LightGetTen = new TUIButton();
         this.FBtn_LightGetTen.Substrate = FScene["MC_Light"]["Btn_GetTen"];
         this.FBtn_LightGetTen.OnClick = this.ProcessorGetLightTen;
         this.FLightTips = FScene["MC_Light"]["MC_Tips"];
         this.FLightTips.visible = false;
         this.FBtn_LightClose = new TUIButton();
         this.FBtn_LightClose.Substrate = FScene["MC_Light"]["MC_Tips"]["Btn_Close"];
         this.FBtn_LightClose.OnClick = this.ProcessorCloseLightWin;
         this.FLightSlots = new Vector.<TUISlot>(6);
         _loc2_ = 6;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FLightSlots[_loc3_] = new TUISlot(this);
            this.FLightSlots[_loc3_].Resource = this.FLightTips["MC_Slot_" + _loc3_];
            this.FLightSlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FLightSlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FLightSlots[_loc3_]);
            this.FLightSlots[_loc3_].Init();
            _loc3_++;
         }
         _loc4_ = TUtilityReflection.CreateDisplayObjectInstance("MC_LightShop") as MovieClip;
         this.FLightExchangeShop = new THDScoreExchangeShop(this);
         this.FLightExchangeShop.ExchangeCall = this.LightExchangeCall;
         this.FLightExchangeShop.UIDispatch(_loc4_);
         this.FBtn_DarkBag = new TUIButton();
         this.FBtn_DarkBag.Substrate = FScene["MC_Dark"]["Btn_Bag"];
         this.FBtn_DarkBag.OnClick = this.ProcessorOpenDarkWin;
         this.FBtn_DarkShop = new TUIButton();
         this.FBtn_DarkShop.Substrate = FScene["MC_Dark"]["Btn_Shop"];
         this.FBtn_DarkShop.OnClick = this.ProcessorOpenDarkShop;
         this.FBtn_DarkGetOne = new TUIButton();
         this.FBtn_DarkGetOne.Substrate = FScene["MC_Dark"]["Btn_Get"];
         this.FBtn_DarkGetOne.OnClick = this.ProcessorGetDarkOne;
         this.FBtn_DarkGetTen = new TUIButton();
         this.FBtn_DarkGetTen.Substrate = FScene["MC_Dark"]["Btn_GetTen"];
         this.FBtn_DarkGetTen.OnClick = this.ProcessorGetDarkTen;
         this.FDarkTips = FScene["MC_Dark"]["MC_Tips"];
         this.FDarkTips.visible = false;
         this.FBtn_DarkClose = new TUIButton();
         this.FBtn_DarkClose.Substrate = FScene["MC_Dark"]["MC_Tips"]["Btn_Close"];
         this.FBtn_DarkClose.OnClick = this.ProcessorCloseDarkWin;
         this.FDarkSlots = new Vector.<TUISlot>(6);
         _loc2_ = 6;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FDarkSlots[_loc3_] = new TUISlot(this);
            this.FDarkSlots[_loc3_].Resource = this.FDarkTips["MC_Slot_" + _loc3_];
            this.FDarkSlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FDarkSlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FDarkSlots[_loc3_]);
            this.FDarkSlots[_loc3_].Init();
            _loc3_++;
         }
         _loc4_ = TUtilityReflection.CreateDisplayObjectInstance("MC_DarkShop") as MovieClip;
         this.FDarkExchangeShop = new THDScoreExchangeShop(this);
         this.FDarkExchangeShop.ExchangeCall = this.DarkExchangeCall;
         this.FDarkExchangeShop.UIDispatch(_loc4_);
         this.FJackPoint = new TShowAwardUI(this);
         this.FJackPoint.UIDispatch(FScene["SP_ShowUI"]);
         this.FBtn_JackPointGet = new TUIButton();
         this.FBtn_JackPointGet.Substrate = FScene["SP_ShowUI"]["Btn_Buy"];
         this.FBtn_JackPointGet.OnClick = this.ProcessorGoldBuyJackPoint;
         this.FBtn_Report = new TUIButton();
         this.FBtn_Report.Substrate = FScene["SP_ShowUI"]["Btn_Report"];
         this.FBtn_Report.OnClick = this.ProcessorReport;
      }
   }
}

