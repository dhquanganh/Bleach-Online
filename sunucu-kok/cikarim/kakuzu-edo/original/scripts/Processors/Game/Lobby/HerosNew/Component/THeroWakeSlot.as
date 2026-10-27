package Processors.Game.Lobby.HerosNew.Component
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.Inventories.TInventoryWake;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class THeroWakeSlot extends TUIButton
   {
      
      protected var FSlot:TUISlot;
      
      protected var FParent:TUIComponent;
      
      protected var FMcLit:Sprite;
      
      protected var FMcCompose:Sprite;
      
      protected var FMcNot:Sprite;
      
      protected var FCanLit:Boolean;
      
      protected var FCanCompose:Boolean;
      
      protected var FWakeEquipId:int;
      
      protected var FStatus:Boolean;
      
      public function THeroWakeSlot(param1:TUIComponent)
      {
         super();
         this.FParent = param1;
      }
      
      override protected function Initialization() : void
      {
         super.Initialization();
         this.FMcLit = FSubstrate["Btn_CanLit"];
         this.FMcCompose = FSubstrate["Btn_CanCompose"];
         this.FMcNot = FSubstrate["Btn_Not"];
         this.FSlot = new TUISlot(this.FParent);
         this.FSlot.Resource = FSubstrate["MC_Slot"];
         TJadeCommon.InitSlot(this.FSlot);
         this.FSlot.OnQuerySubscript = null;
         this.FSlot.Init();
         this.CanLit = false;
         this.CanCompose = false;
      }
      
      override protected function ButtonOnMove(param1:MouseEvent) : void
      {
         super.ButtonOnMove(param1);
         if(!this.FStatus)
         {
            return;
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this.FSlot,this.FSlot.Context);
      }
      
      override protected function ButtonOnOut(param1:MouseEvent) : void
      {
         super.ButtonOnOut(param1);
         SUtilityOverLayer.UIComponentsHintOnOut(this.FSlot,this.FSlot.Context);
      }
      
      public function Update() : void
      {
         this.FSlot.Update();
      }
      
      public function Clear() : void
      {
         this.Context = null;
         this.CanLit = false;
         this.CanCompose = false;
         this.FMcNot.visible = false;
         this.FWakeEquipId = 0;
      }
      
      public function set Context(param1:TInventoryWake) : void
      {
         this.FSlot.Context = param1;
      }
      
      public function get CanLit() : Boolean
      {
         return this.FCanLit;
      }
      
      public function set CanLit(param1:Boolean) : void
      {
         this.FCanLit = param1;
         this.FMcLit.visible = param1;
      }
      
      public function get CanCompose() : Boolean
      {
         return this.FCanCompose;
      }
      
      public function set CanCompose(param1:Boolean) : void
      {
         this.FCanCompose = param1;
         this.FMcCompose.visible = param1;
      }
      
      public function get WakeEquipId() : int
      {
         return this.FWakeEquipId;
      }
      
      public function set WakeEquipId(param1:int) : void
      {
         this.FWakeEquipId = param1;
      }
      
      public function get Status() : Boolean
      {
         return this.FStatus;
      }
      
      public function set Status(param1:Boolean) : void
      {
         this.FStatus = param1;
         this.FSlot.SetDefaultFilters(!this.FStatus);
         this.FMcNot.visible = !this.FStatus;
      }
   }
}

