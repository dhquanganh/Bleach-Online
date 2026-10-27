package Processors.Game.Lobby.Activity.HDAnniversary2017.windows
{
   import Components.Pages.TUIPage;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDAnniversaryOne;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDAnniversary.TAnniversaryOne;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowAnniversaryOne extends TProcessorHDSingleWindowBase
   {
      
      protected var FBtn_Award:TUIButton;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FBtn_Go:TUIButton;
      
      protected var FPageUI:TUIPage;
      
      protected var FCurrentPage:uint;
      
      protected var FData:TAnniversaryOne;
      
      protected var FConfig:THDAnniversaryOne;
      
      public function TProcessorHDWindowAnniversaryOne(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.UpdateUIConfig();
         this.FConfig = FHDActivityConfig as THDAnniversaryOne;
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
         this.FData = param1 as TAnniversaryOne;
         this.FBtn_Go.Enabled = this.FData.RushStatus == 1 ? true : false;
         FScene["MC_Man"].gotoAndStop(this.FData.CurProgress() + 2);
         _loc3_ = uint((this.FData.StepAwards[this.FData.CurExtraProgress()] as TInventories).Count);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FSlots[_loc2_].Context = this.FData.StepAwards[this.FData.CurExtraProgress()].GetInventoryByIndex(_loc2_);
            _loc2_++;
         }
         this.FPageUI.TotalQuantity = 3;
         this.FPageUI.Update();
         this.PageOnSwitch(this,this.FData.CurBagPos());
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
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         this.FCurrentPage = param2;
         FScene["Btn_Award"].gotoAndStop(this.FCurrentPage + 1);
         this.FBtn_Award = new TUIButton();
         this.FBtn_Award.Substrate = FScene["Btn_Award"]["Btn_Award"];
         this.FBtn_Award.OnClick = this.ProcessorGetAward;
         this.FBtn_Award.OnMove = this.ProcessorGiftOnMove;
         this.FBtn_Award.OnOut = this.ProcessorGiftOnOut;
         this.FBtn_Award.Enabled = this.FData.BigAwardStatus[this.FCurrentPage] == 1 ? true : false;
         FScene["Btn_Award"]["MC_Already"].visible = this.FData.BigAwardStatus[this.FCurrentPage] == -1 ? true : false;
         this.FPageUI.PageIndex = this.FCurrentPage;
         this.FPageUI.Update();
      }
      
      protected function ProcessorGiftOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         ProcessorOnGiftBoxMove(this,this.FData.BigAwards[this.FCurrentPage],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorGiftOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function ProcessorGetAward(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.ExtraAwardList[this.FCurrentPage].index);
      }
      
      protected function ProcessorRush(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.OnRushIndex);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         this.FBtn_Award = new TUIButton();
         this.FBtn_Award.Substrate = FScene["Btn_Award"]["Btn_Award"];
         this.FBtn_Award.OnClick = this.ProcessorGetAward;
         this.FBtn_Award.OnMove = this.ProcessorGiftOnMove;
         this.FBtn_Award.OnOut = this.ProcessorGiftOnOut;
         this.FBtn_Go = new TUIButton();
         this.FBtn_Go.Substrate = FScene["MC_Go"];
         this.FBtn_Go.OnClick = this.ProcessorRush;
         _loc2_ = 4;
         this.FSlots = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSlots[_loc3_] = new TUISlot(this);
            this.FSlots[_loc3_].Resource = FScene["Slot_" + _loc3_];
            this.FSlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots[_loc3_]);
            this.FSlots[_loc3_].Init();
            _loc3_++;
         }
         this.FPageUI = new TUIPage(this);
         this.FPageUI.ButtonNext.Substrate = FScene["MC_Page"]["MC_PageRight"];
         this.FPageUI.ButtonPrevious.Substrate = FScene["MC_Page"]["MC_PageLeft"];
         this.FPageUI.LabelPage = FScene["MC_Page"]["TF_Page"];
         FScene["MC_Page"]["TF_Page"].visible = false;
         this.FPageUI.PageSize = 1;
         this.FPageUI.OnChangePage = this.PageOnSwitch;
         this.FPageUI.Init();
         this.FPageUI.Update();
      }
   }
}

