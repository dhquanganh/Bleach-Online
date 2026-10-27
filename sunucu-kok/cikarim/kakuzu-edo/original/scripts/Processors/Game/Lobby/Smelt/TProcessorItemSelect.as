package Processors.Game.Lobby.Smelt
{
   import Components.Pages.TUIPage;
   import Components.Slots.TUISlot;
   import Foundation.UI.TUIComponent;
   import Logics.Inventories.TEquipment;
   import Logics.Inventories.TInventories;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TProcessorItemSelect extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FInventories:TInventories;
      
      protected var FPage:TUIPage;
      
      protected var FPageIndex:uint;
      
      protected var FSelect:Function;
      
      public function TProcessorItemSelect(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         _loc2_ = 36;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      protected function ProcessorSlotOnClick(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc3_ = uint(param1.currentTarget.name.split("_")[2]);
         _loc2_ = uint(param1.currentTarget.name.split("_")[2]);
         _loc2_ = this.LoaclIndexToGlobalIndex(_loc2_);
         if(_loc2_ >= this.FInventories.Count)
         {
            return;
         }
         this.HideFlag();
         this.FSelect(this.FInventories.GetInventoryByIndex(_loc2_).Identifier,this.FInventories.GetInventoryByIndex(_loc2_).IDTemplate,_loc2_);
         this.FMainUI["MC_SelectedBox_" + _loc3_].visible = true;
      }
      
      public function Update() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TInventories = null;
         var _loc4_:TEquipment = null;
         this.Visible = true;
         this.FInventories = new TInventories();
         _loc3_ = SLogicsCore.Character.Ornaments;
         _loc2_ = uint(SLogicsCore.Character.Ornaments.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc3_.GetInventoryByIndex(_loc1_) as TEquipment;
            if(_loc4_.UpgradingLevel > 0)
            {
               this.FInventories.Add(_loc4_);
            }
            _loc1_++;
         }
         this.FPage.SetupPage(this.FInventories.Count,this.FPageIndex);
         this.UpdatePage();
      }
      
      private function HideFlag() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = 36;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMainUI["MC_SelectedBox_" + _loc1_].visible = false;
            _loc1_++;
         }
      }
      
      protected function UpdatePage() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc3_ = 36;
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            this.FSlots[_loc1_].Context = null;
            _loc1_++;
         }
         this.HideFlag();
         _loc2_ = uint(this.FInventories.Count);
         _loc1_ = 0;
         while(_loc1_ < 36)
         {
            _loc4_ = this.LoaclIndexToGlobalIndex(_loc1_);
            if(_loc4_ < _loc2_)
            {
               this.FSlots[_loc1_].Context = this.FInventories.GetInventoryByIndex(_loc4_);
            }
            _loc1_++;
         }
      }
      
      protected function LoaclIndexToGlobalIndex(param1:uint) : uint
      {
         return this.FPageIndex * 36 + param1;
      }
      
      public function set Select(param1:Function) : void
      {
         this.FSelect = param1;
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdatePage();
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FMainUI = param1;
         addChild(this.FMainUI);
         _loc3_ = 36;
         this.FSlots = new Vector.<TUISlot>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FSlots[_loc2_] = new TUISlot(this);
            this.FSlots[_loc2_].Resource = this.FMainUI["MC_Slot_" + _loc2_];
            this.FSlots[_loc2_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots[_loc2_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots[_loc2_]);
            this.FSlots[_loc2_].Init();
            this.FMainUI["MC_Slot_" + _loc2_].addEventListener(MouseEvent.CLICK,this.ProcessorSlotOnClick);
            _loc2_++;
         }
         this.HideFlag();
         this.FPage = new TUIPage(this);
         this.FPage.ButtonNext.Substrate = this.FMainUI.MC_PageRight;
         this.FPage.ButtonPrevious.Substrate = this.FMainUI.MC_PageLeft;
         this.FPage.PageSize = 36;
         this.FPage.OnChangePage = this.PageOnSwitch;
         this.FPage.LabelPage = this.FMainUI.TF_Page;
         this.FPage.Init();
         this.FPage.Update();
      }
   }
}

