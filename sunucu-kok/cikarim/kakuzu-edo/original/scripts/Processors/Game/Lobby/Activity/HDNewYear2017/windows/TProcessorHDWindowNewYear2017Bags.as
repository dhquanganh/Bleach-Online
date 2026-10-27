package Processors.Game.Lobby.Activity.HDNewYear2017.windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.THDNewYear2017Bags;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYear2017.TNewYear2017Bags;
   import Processors.Game.Lobby.Activity.HDActivity.Common.THDScoreExchangeShop;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowNewYear2017Bags extends TProcessorHDSingleWindowBase
   {
      
      protected var FBtn_Perview_0:TUIButton;
      
      protected var FBtn_Perview_1:TUIButton;
      
      protected var FBtn_ClosePerview:TUIButton;
      
      protected var FBtn_Bag_0:TUIButton;
      
      protected var FBtn_Bag_1:TUIButton;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FJackPoint:TShowAwardUI;
      
      protected var FBtn_Report:TUIButton;
      
      protected var FBtn_Shop:TUIButton;
      
      protected var FScoreExchangeShop:THDScoreExchangeShop;
      
      protected var FIsinit:Boolean;
      
      protected var FConfig:THDNewYear2017Bags;
      
      protected var FData:TNewYear2017Bags;
      
      public function TProcessorHDWindowNewYear2017Bags(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDNewYear2017Bags = null;
         super.UpdateUIConfig();
         this.FConfig = FHDActivityConfig as THDNewYear2017Bags;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
         FScene["TF_Cost_0"].text = this.FConfig.OrangeCond + "";
         FScene["TF_Cost_1"].text = this.FConfig.RedCond + "";
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.FData = param1 as TNewYear2017Bags;
         FScene["TF_Last_0"].text = this.FData.Bag_0Last + "";
         this.FBtn_Bag_0.Enabled = this.FData.Bag_0Last > 0 ? true : false;
         FScene["TF_Last_1"].text = this.FData.Bag_1Last + "";
         this.FBtn_Bag_1.Enabled = this.FData.Bag_1Last > 0 ? true : false;
         this.FScoreExchangeShop.Update(this.FData.Score,this.FData.MailStatus);
         if(!this.FIsinit)
         {
            this.SetupScoreShop();
            this.FIsinit = true;
         }
         this.UpdateJackPoint();
      }
      
      protected function SetupScoreShop() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Vector.<uint> = null;
         var _loc3_:Vector.<Boolean> = null;
         _loc2_ = new Vector.<uint>();
         _loc3_ = new Vector.<Boolean>();
         for each(_loc1_ in this.FData.Config.Mall)
         {
            _loc2_.push(_loc1_.cost);
            _loc3_.push(_loc1_.numLimit == 0);
         }
         this.FScoreExchangeShop.SetupBasicInfo(this.FData.MailInvs,_loc2_,_loc3_);
      }
      
      protected function UpdateJackPoint() : void
      {
         this.FJackPoint.SetData(this.FData.Config.Bag.showType,this.FData.Config.Bag.awardId,this.FData.Config.Bag.showID);
         this.FBtn_Report.Visible = this.FData.Config.Bag.fightReportAddr != "";
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         _loc2_ = 6;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      protected function ProcessorPerview0(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc3_ = 6;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            this.FSlots[_loc4_].Context = this.FData.Bag_Award_0[0].GetInventoryByIndex(_loc4_);
            _loc4_++;
         }
         FScene["MC_Perview"].visible = true;
      }
      
      protected function ProcessorPerview1(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc3_ = 6;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            this.FSlots[_loc4_].Context = this.FData.Bag_Award_1[0].GetInventoryByIndex(_loc4_);
            _loc4_++;
         }
         FScene["MC_Perview"].visible = true;
      }
      
      protected function ProcessorClosePerview(param1:Object, param2:MouseEvent) : void
      {
         FScene["MC_Perview"].visible = false;
      }
      
      protected function ProcessorGetBag0(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.OrangeIndex);
         if(FScene["MC_Effect_0"] == null)
         {
            return;
         }
         FScene["MC_Effect_0"].gotoAndPlay(1);
      }
      
      protected function ProcessorGetBag1(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.RedIndex);
         if(FScene["MC_Effect_1"] == null)
         {
            return;
         }
         FScene["MC_Effect_1"].gotoAndPlay(1);
      }
      
      protected function ShowShopOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.FScoreExchangeShop.Visible = true;
         this.FScoreExchangeShop.Update(this.FData.Score,this.FData.MailStatus);
      }
      
      protected function ProcessorReport(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FData.Config.Bag.fightReportAddr);
      }
      
      protected function ExchangeCall(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         _loc3_ = this.FData.Config.Mall[param1];
         _loc2_ = uint(_loc3_.cost);
         if(this.FData.Score >= _loc2_)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.index);
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         this.FScoreExchangeShop = new THDScoreExchangeShop(this);
         this.FScoreExchangeShop.ExchangeCall = this.ExchangeCall;
         this.FScoreExchangeShop.UIDispatch(TUtilityReflection.CreateDisplayObjectInstance("MC_Christmas2015Shop") as MovieClip);
         this.FJackPoint = new TShowAwardUI(this);
         this.FJackPoint.UIDispatch(FScene["MC_MountPoint"]);
         this.FBtn_Report = new TUIButton();
         this.FBtn_Report.Substrate = FScene["Btn_Report"];
         this.FBtn_Report.OnClick = this.ProcessorReport;
         this.FBtn_Bag_0 = new TUIButton();
         this.FBtn_Bag_0.Substrate = FScene["MC_Bag_0"];
         this.FBtn_Bag_0.OnClick = this.ProcessorGetBag0;
         this.FBtn_Bag_1 = new TUIButton();
         this.FBtn_Bag_1.Substrate = FScene["MC_Bag_1"];
         this.FBtn_Bag_1.OnClick = this.ProcessorGetBag1;
         this.FBtn_Perview_0 = new TUIButton();
         this.FBtn_Perview_0.Substrate = FScene["Btn_Perview_0"];
         this.FBtn_Perview_0.OnClick = this.ProcessorPerview0;
         this.FBtn_Perview_1 = new TUIButton();
         this.FBtn_Perview_1.Substrate = FScene["Btn_Perview_1"];
         this.FBtn_Perview_1.OnClick = this.ProcessorPerview1;
         this.FBtn_Shop = new TUIButton();
         this.FBtn_Shop.Substrate = FScene["Btn_Shop"];
         this.FBtn_Shop.OnClick = this.ShowShopOnClick;
         this.FBtn_ClosePerview = new TUIButton();
         this.FBtn_ClosePerview.Substrate = FScene["MC_Perview"]["Btn_ClosePerview"];
         this.FBtn_ClosePerview.OnClick = this.ProcessorClosePerview;
         _loc2_ = 6;
         this.FSlots = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSlots[_loc3_] = new TUISlot(this);
            this.FSlots[_loc3_].Resource = FScene["MC_Perview"]["slot" + _loc3_];
            this.FSlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots[_loc3_]);
            this.FSlots[_loc3_].Init();
            _loc3_++;
         }
         this.ProcessorClosePerview(this,null);
      }
   }
}

