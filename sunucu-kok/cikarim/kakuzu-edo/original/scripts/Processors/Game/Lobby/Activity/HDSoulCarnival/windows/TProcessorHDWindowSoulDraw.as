package Processors.Game.Lobby.Activity.HDSoulCarnival.windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDSoulDraw;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDSoulCarnival.TSoulDraw;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowSoulDraw extends TProcessorHDSingleWindowBase
   {
      
      protected var FShowGold:Sprite;
      
      protected var FShowSilver:Sprite;
      
      protected var FBtn_GoldClose:TUIButton;
      
      protected var FBtn_SilverClose:TUIButton;
      
      protected var FShowGoldSlots:Vector.<TUISlot>;
      
      protected var FShowSilverSlots:Vector.<TUISlot>;
      
      protected var FCurGoldSlot:TUISlot;
      
      protected var FCurSilverSlot:Vector.<TUISlot>;
      
      protected var FBtn_LookGold:TUIButton;
      
      protected var FBtn_LookSilver:TUIButton;
      
      protected var FBtn_ReflashAll:TUIButton;
      
      protected var FBtn_Buy:TUIButton;
      
      protected var FData:TSoulDraw;
      
      public function TProcessorHDWindowSoulDraw(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDSoulDraw = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDSoulDraw;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
         FScene["TF_Cost_1"].text = _loc3_.RefreshGold + "";
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.FData = param1 as TSoulDraw;
         this.FCurGoldSlot.Context = this.FData.CurGoldAward.GetInventoryByIndex(0);
         _loc3_ = 3;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FCurSilverSlot[_loc2_].Context = this.FData.CurFreeAward[_loc2_];
            _loc2_++;
         }
         _loc3_ = 6;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FShowGoldSlots[_loc2_].Context = this.FData.ShowGoldAward.GetInventoryByIndex(_loc2_);
            _loc2_++;
         }
         _loc3_ = 9;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FShowSilverSlots[_loc2_].Context = this.FData.ShowFreeAward.GetInventoryByIndex(_loc2_);
            _loc2_++;
         }
         FScene["TF_Cost_0"].text = this.FData.Config.GoldAward[this.FData.CurGoldIndex].gold + "";
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.LogicsPerform();
         if(Visible && this.FData != null)
         {
            this.FCurGoldSlot.Update();
            _loc2_ = 3;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FCurSilverSlot[_loc1_].Update();
               _loc1_++;
            }
            _loc2_ = 6;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FShowGoldSlots[_loc1_].Update();
               _loc1_++;
            }
            _loc2_ = 9;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FShowSilverSlots[_loc1_].Update();
               _loc1_++;
            }
         }
      }
      
      protected function ProcessorWinClose(param1:Object, param2:MouseEvent) : void
      {
         this.FShowGold.visible = false;
         this.FShowSilver.visible = false;
      }
      
      protected function ProcessorGoldOpen(param1:Object, param2:MouseEvent) : void
      {
         this.FShowGold.visible = true;
      }
      
      protected function ProcessorSilverOpen(param1:Object, param2:MouseEvent) : void
      {
         this.FShowSilver.visible = true;
      }
      
      protected function ProcessorReflash(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FData.Config.RefreshGold,this.ProcessorReflashGold);
      }
      
      protected function ProcessorBuy(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FData.Config.GoldAward[this.FData.CurGoldIndex].gold,this.ProcessorBuyGold);
      }
      
      protected function ProcessorReflashGold(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.RefreshIndex);
         this.PlayEffect();
      }
      
      protected function ProcessorBuyGold(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.BuyIndex);
         this.PlayEffect();
      }
      
      protected function PlayEffect() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = 4;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            FScene["MC_Slot" + _loc1_]["Effect"].play();
            _loc1_++;
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         this.FShowGold = FScene["MC_ShowGold"];
         this.FShowGold.visible = false;
         this.FShowSilver = FScene["MC_ShowSliver"];
         this.FShowSilver.visible = false;
         this.FBtn_GoldClose = new TUIButton();
         this.FBtn_GoldClose.Substrate = this.FShowGold["btn_close"];
         this.FBtn_GoldClose.OnClick = this.ProcessorWinClose;
         this.FBtn_SilverClose = new TUIButton();
         this.FBtn_SilverClose.Substrate = this.FShowSilver["btn_close"];
         this.FBtn_SilverClose.OnClick = this.ProcessorWinClose;
         this.FBtn_LookGold = new TUIButton();
         this.FBtn_LookGold.Substrate = FScene["Btn_LookGold"];
         this.FBtn_LookGold.OnClick = this.ProcessorGoldOpen;
         this.FBtn_LookSilver = new TUIButton();
         this.FBtn_LookSilver.Substrate = FScene["Btn_LookSilver"];
         this.FBtn_LookSilver.OnClick = this.ProcessorSilverOpen;
         this.FBtn_ReflashAll = new TUIButton();
         this.FBtn_ReflashAll.Substrate = FScene["Btn_Reflash"];
         this.FBtn_ReflashAll.OnClick = this.ProcessorReflash;
         this.FBtn_Buy = new TUIButton();
         this.FBtn_Buy.Substrate = FScene["Btn_Buy"];
         this.FBtn_Buy.OnClick = this.ProcessorBuy;
         this.FCurGoldSlot = new TUISlot(this);
         this.FCurGoldSlot.Resource = FScene["MC_Slot" + _loc3_]["Slot"];
         this.FCurGoldSlot.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FCurGoldSlot.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         TJadeCommon.InitSlot(this.FCurGoldSlot);
         this.FCurGoldSlot.Init();
         _loc2_ = 3;
         this.FCurSilverSlot = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FCurSilverSlot[_loc3_] = new TUISlot(this);
            this.FCurSilverSlot[_loc3_].Resource = FScene["MC_Slot" + (_loc3_ + 1)]["Slot"];
            this.FCurSilverSlot[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FCurSilverSlot[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FCurSilverSlot[_loc3_]);
            this.FCurSilverSlot[_loc3_].Init();
            _loc3_++;
         }
         _loc2_ = 6;
         this.FShowGoldSlots = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FShowGoldSlots[_loc3_] = new TUISlot(this);
            this.FShowGoldSlots[_loc3_].Resource = this.FShowGold["slot" + _loc3_];
            this.FShowGoldSlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FShowGoldSlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FShowGoldSlots[_loc3_]);
            this.FShowGoldSlots[_loc3_].Init();
            _loc3_++;
         }
         _loc2_ = 9;
         this.FShowSilverSlots = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FShowSilverSlots[_loc3_] = new TUISlot(this);
            this.FShowSilverSlots[_loc3_].Resource = this.FShowSilver["slot" + _loc3_];
            this.FShowSilverSlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FShowSilverSlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FShowSilverSlots[_loc3_]);
            this.FShowSilverSlots[_loc3_].Init();
            _loc3_++;
         }
      }
   }
}

