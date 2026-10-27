package Processors.Game.Lobby.Activity.HDNewYear2017.windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDNewYear2017Discount;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYear2017.TNewYear2017Discount;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYear2017.components.Tlantern;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowNewYear2017Discount extends TProcessorHDSingleWindowBase
   {
      
      protected var FBtn_Discount:TUIButton;
      
      protected var FBtn_Get_0:TUIButton;
      
      protected var FBtn_Get_1:TUIButton;
      
      protected var FItems:Vector.<Tlantern>;
      
      protected var FBtn_Buy:TUIButton;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FBtn_ClosePerview:TUIButton;
      
      protected var FRefreshIndex:uint;
      
      protected var FData:TNewYear2017Discount;
      
      protected var FConfig:THDNewYear2017Discount;
      
      public function TProcessorHDWindowNewYear2017Discount(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDNewYear2017Discount = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDNewYear2017Discount;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
         FScene["TF_Cost_0"].text = _loc3_.FOrgRatio + "";
         FScene["TF_Cost_1"].text = _loc3_.FRedRatio + "";
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Vector.<Object> = null;
         this.FData = param1 as TNewYear2017Discount;
         FScene["TF_Score"].text = this.FData.Score + "";
         FScene["TF_Discount"].text = this.FData.Discount / 10 + "";
         FScene["TF_Cost"].text = this.NeedGold() + "";
         this.FBtn_Buy.Enabled = this.FItems[0].Flag != -1 && this.FItems[1].Flag != -1 && this.FItems[2].Flag != -1;
         this.FBtn_Get_0.Enabled = this.FData.Score >= this.FData.Config.FOrgRatio;
         this.FBtn_Get_1.Enabled = this.FData.Score >= this.FData.Config.FRedRatio;
         this.FBtn_Discount.Enabled = this.FData.Discount > this.FData.Config.FRand[0] * 10;
         _loc3_ = 3;
         this.FData.CurInvs[0].Clear();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = new Vector.<Object>(_loc3_);
            _loc5_ = 3;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc6_[_loc4_] = this.FData.GetInfo(this.FData.CurItemsIndex[_loc4_ + _loc2_ * _loc3_]);
               this.FData.CurCosts[_loc4_ + _loc2_ * _loc3_] = this.FData.GetInfo(this.FData.CurItemsIndex[_loc4_ + _loc2_ * _loc3_]).cost;
               this.FData.CurInvs[0].Add(this.FData.GetInfo(this.FData.CurItemsIndex[_loc4_ + _loc2_ * _loc3_]).inv);
               _loc4_++;
            }
            this.FItems[_loc2_].SetData(_loc6_);
            _loc2_++;
         }
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
         _loc2_ = 3;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FItems[_loc1_].Update();
            _loc1_++;
         }
         _loc2_ = 6;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      protected function ProcessorDiscount(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FData.Config.FSaleCost,this.ProcessorGoldDiscount);
      }
      
      protected function ProcessorGoldDiscount(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.FSaleIndex);
      }
      
      protected function ProcessorGet0(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.FChargeOrgIndex);
      }
      
      protected function ProcessorGet1(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.FChargeRedIndex);
      }
      
      protected function ProcessorBuy(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.NeedGold(),this.ProcessorGoldBuy);
      }
      
      protected function ProcessorGoldBuy(param1:Object) : void
      {
         var _loc2_:Vector.<int> = null;
         _loc2_ = new Vector.<int>(3);
         _loc2_[0] = this.FData.CurItemsIndex[this.FItems[0].Flag];
         _loc2_[1] = this.FData.CurItemsIndex[this.FItems[1].Flag + 3];
         _loc2_[2] = this.FData.CurItemsIndex[this.FItems[2].Flag + 6];
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.FBuyIndex,0,_loc2_);
      }
      
      protected function ProcessorClosePerview(param1:Object, param2:MouseEvent) : void
      {
         FScene["MC_Perview"].visible = false;
      }
      
      protected function NeedGold() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(this.FItems[0].Flag == -1 || this.FItems[1].Flag == -1 || this.FItems[2].Flag == -1)
         {
            return 0;
         }
         _loc1_ = this.FData.CurCosts[0 * 3 + this.FItems[0].Flag];
         _loc2_ = this.FData.CurCosts[1 * 3 + this.FItems[1].Flag];
         _loc3_ = this.FData.CurCosts[2 * 3 + this.FItems[2].Flag];
         return uint(this.FData.Discount / 100 * (_loc1_ + _loc2_ + _loc3_));
      }
      
      protected function ProcessorPeriew(param1:uint) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = 6;
         switch(param1)
         {
            case 0:
               param1 = 0;
               while(param1 < _loc2_)
               {
                  this.FSlots[param1].Context = this.FData.PerviewInvs[0].GetInventoryByIndex(param1);
                  param1++;
               }
               break;
            case 1:
               param1 = 0;
               while(param1 < _loc2_)
               {
                  this.FSlots[param1].Context = this.FData.PerviewInvs[0].GetInventoryByIndex(param1 + _loc2_);
                  param1++;
               }
               break;
            case 2:
               param1 = 0;
               while(param1 < _loc2_)
               {
                  this.FSlots[param1].Context = this.FData.PerviewInvs[0].GetInventoryByIndex(param1 + _loc2_ * 2);
                  param1++;
               }
         }
         FScene["MC_Perview"].visible = true;
      }
      
      protected function ProcessorGoldRefresh(param1:Object) : void
      {
         switch(this.FRefreshIndex)
         {
            case 0:
               Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.FFreshOneAward);
               break;
            case 1:
               Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.FFreshTwoAward);
               break;
            case 2:
               Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.FFreshThreeAward);
         }
      }
      
      protected function ProcessorReflesh(param1:uint) : void
      {
         this.FRefreshIndex = param1;
         GoldBuy(this.FData.Config.FAwardCost,this.ProcessorGoldRefresh);
      }
      
      protected function ProcessorUpdatePrice() : void
      {
         FScene["TF_Cost"].text = this.NeedGold() + "";
         this.FBtn_Buy.Enabled = this.FItems[0].Flag != -1 && this.FItems[1].Flag != -1 && this.FItems[2].Flag != -1;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         _loc2_ = 3;
         this.FItems = new Vector.<Tlantern>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FItems[_loc3_] = new Tlantern(this,_loc3_);
            this.FItems[_loc3_].OnPerview = this.ProcessorPeriew;
            this.FItems[_loc3_].OnReflesh = this.ProcessorReflesh;
            this.FItems[_loc3_].OnUpdatePrice = this.ProcessorUpdatePrice;
            this.FItems[_loc3_].Init(FScene["SP_List_" + _loc3_]);
            _loc3_++;
         }
         this.FBtn_Discount = new TUIButton();
         this.FBtn_Discount.Substrate = FScene["Btn_RefreshDiscount"];
         this.FBtn_Discount.OnClick = this.ProcessorDiscount;
         this.FBtn_Get_0 = new TUIButton();
         this.FBtn_Get_0.Substrate = FScene["Btn_Get_0"];
         this.FBtn_Get_0.OnClick = this.ProcessorGet0;
         this.FBtn_Get_1 = new TUIButton();
         this.FBtn_Get_1.Substrate = FScene["Btn_Get_1"];
         this.FBtn_Get_1.OnClick = this.ProcessorGet1;
         this.FBtn_Buy = new TUIButton();
         this.FBtn_Buy.Substrate = FScene["Btn_Buy"];
         this.FBtn_Buy.OnClick = this.ProcessorBuy;
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

