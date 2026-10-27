package Processors.Game.Lobby.MakeEquip.EquipSlots
{
   import Components.ScrollBar.TScrollBar;
   import Foundation.UI.TUIComponent;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   
   public class TEquipSlotList extends TUIComponent
   {
      
      protected var FEquip:TInventory;
      
      protected var FInventories:TInventories;
      
      protected var FSlotList:Vector.<TEquipSlot>;
      
      protected var FEquipTypes:Vector.<TInventories>;
      
      public function TEquipSlotList(param1:TUIComponent)
      {
         super(param1);
         this.FSlotList = new Vector.<TEquipSlot>();
      }
      
      protected function DataOnUpdate() : void
      {
      }
      
      protected function ListOnUpdate() : void
      {
      }
      
      public function get EquipTypes() : Vector.<TInventories>
      {
         return this.FEquipTypes;
      }
      
      public function set EquipTypes(param1:Vector.<TInventories>) : void
      {
         this.FEquipTypes = param1;
      }
      
      public function get SlotList() : Vector.<TEquipSlot>
      {
         return this.FSlotList;
      }
      
      public function set SlotList(param1:Vector.<TEquipSlot>) : void
      {
         this.FSlotList = param1;
      }
      
      public function get Count() : uint
      {
         return this.FSlotList.length;
      }
      
      public function ListOnSort(param1:int, param2:int, param3:int, param4:Boolean) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param1 == 0)
         {
            return;
         }
         this.FInventories = this.FEquipTypes[param1];
         _loc6_ = this.FInventories.Count;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            this.FEquip = this.FInventories.GetInventoryByIndex(_loc5_);
            if(param2 != 0)
            {
            }
            _loc5_++;
         }
         this.ListOnUpdate();
         this.DataOnUpdate();
      }
      
      public function AddDisplay(param1:TEquipSlot, param2:TScrollBar) : void
      {
         param2.AddItem(param1);
         this.FSlotList.push(param1);
      }
      
      public function AddData(param1:TInventory) : void
      {
      }
      
      public function GetSlotByIndex(param1:uint) : TEquipSlot
      {
         return this.FSlotList[param1];
      }
      
      public function Clear(param1:TScrollBar) : void
      {
         var _loc2_:TEquipSlot = null;
         if(param1.Count > 0)
         {
            param1.Clear();
         }
         while(this.FSlotList.length > 0)
         {
            _loc2_ = this.FSlotList.pop();
            _loc2_.ResetSlot();
         }
      }
   }
}

