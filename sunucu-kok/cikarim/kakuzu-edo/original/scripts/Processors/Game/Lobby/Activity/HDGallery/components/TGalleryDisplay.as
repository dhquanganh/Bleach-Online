package Processors.Game.Lobby.Activity.HDGallery.components
{
   import Components.Slots.TUISlot;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.TAward;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TGalleryDisplay extends TUIComponent
   {
      
      protected var FMainUI:Sprite;
      
      protected var FSelectBox:Sprite;
      
      protected var FSlot:TUISlot;
      
      protected var FOnOver:Function;
      
      protected var FOnOut:Function;
      
      public function TGalleryDisplay(param1:TUIComponent)
      {
         super(param1);
      }
      
      public function Init(param1:Sprite) : void
      {
         this.FMainUI = param1;
         this.FSlot = new TUISlot(Parent);
         this.FSlot.Resource = this.FMainUI["MC_Slot"];
         TJadeCommon.InitSlot(this.FSlot);
         this.FSlot.Init();
         this.FSelectBox = this.FMainUI["SelectBox"];
         this.FSelectBox.visible = false;
         this.FMainUI.addEventListener(MouseEvent.MOUSE_MOVE,this.SlotOnOver);
         this.FMainUI.addEventListener(MouseEvent.MOUSE_OUT,this.SlotOnOut);
      }
      
      protected function SlotOnOver(param1:MouseEvent) : void
      {
         this.FOnOver(this,this.FSlot.Context);
      }
      
      protected function SlotOnOut(param1:MouseEvent) : void
      {
         this.FOnOut(this,this.FSlot.Context);
      }
      
      public function SetData(param1:int) : void
      {
         var _loc2_:TAward = null;
         var _loc3_:TInventories = null;
         var _loc4_:TInventory = null;
         _loc3_ = new TInventories();
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Award,param1) as TAward;
         SToolReward.GetInventoryByID(_loc2_.FixedAwards[0].Code,_loc3_);
         _loc4_ = _loc3_.GetInventoryByIndex(0);
         _loc4_.Quantity = _loc2_.FixedAwards[0].Amount;
         this.FSlot.Context = _loc4_;
      }
      
      public function Update() : void
      {
         this.FSlot.Update();
      }
      
      public function get OnOver() : Function
      {
         return this.FOnOver;
      }
      
      public function set OnOver(param1:Function) : void
      {
         this.FOnOver = param1;
      }
      
      public function get OnOut() : Function
      {
         return this.FOnOut;
      }
      
      public function set OnOut(param1:Function) : void
      {
         this.FOnOut = param1;
      }
   }
}

