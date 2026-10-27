package Processors.Game.Lobby.RelatedPartner.BattleReady
{
   import Foundation.UI.TUIComponent;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TItemReadyBackupSlot extends TUIComponent implements IRelatedReadySlot
   {
      
      protected var FMainUI:Sprite;
      
      protected var FTFLevel:TextField;
      
      protected var FMountPoint:Bitmap;
      
      protected var FSlotOnDown:Function;
      
      protected var FSlotOnOver:Function;
      
      protected var FSlotOnOut:Function;
      
      protected var FSlotIndex:int;
      
      protected var FLevel:int;
      
      public function TItemReadyBackupSlot(param1:TUIComponent, param2:Sprite)
      {
         this.FMainUI = param2;
         super(param1);
      }
      
      protected function BackupSlotOnDown(param1:MouseEvent) : void
      {
         if(this.FSlotOnDown != null)
         {
            this.FSlotOnDown(this.FSlotIndex);
         }
      }
      
      protected function BackupSlotOnOver(param1:MouseEvent) : void
      {
         if(this.FSlotOnOver != null)
         {
            this.FSlotOnOver(this.FSlotIndex);
         }
      }
      
      protected function BackupSlotOnOut(param1:MouseEvent) : void
      {
         if(this.FSlotOnOut != null)
         {
            this.FSlotOnOut(this.FSlotIndex);
         }
      }
      
      public function get MountPoint() : Bitmap
      {
         return this.FMountPoint;
      }
      
      public function get SlotOnDown() : Function
      {
         return this.FSlotOnDown;
      }
      
      public function set SlotOnDown(param1:Function) : void
      {
         this.FSlotOnDown = param1;
      }
      
      public function get SlotIndex() : int
      {
         return this.FSlotIndex;
      }
      
      public function set SlotIndex(param1:int) : void
      {
         this.FSlotIndex = param1;
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function set Level(param1:int) : void
      {
         this.FLevel = param1;
         this.FTFLevel.text = this.FLevel + "";
      }
      
      override public function get Visible() : Boolean
      {
         return super.Visible;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         this.FMainUI.visible = param1;
      }
      
      public function get SlotOnOver() : Function
      {
         return this.FSlotOnOver;
      }
      
      public function set SlotOnOver(param1:Function) : void
      {
         this.FSlotOnOver = param1;
      }
      
      public function get SlotOnOut() : Function
      {
         return this.FSlotOnOut;
      }
      
      public function set SlotOnOut(param1:Function) : void
      {
         this.FSlotOnOut = param1;
      }
      
      public function Init() : void
      {
         this.FMountPoint = new Bitmap();
         this.FMainUI["MountPoint"].addChild(this.FMountPoint);
         this.FTFLevel = this.FMainUI["TF_Level"];
         this.FMainUI.addEventListener(MouseEvent.MOUSE_DOWN,this.BackupSlotOnDown);
         this.FMainUI.addEventListener(MouseEvent.MOUSE_MOVE,this.BackupSlotOnOver);
         this.FMainUI.addEventListener(MouseEvent.MOUSE_OUT,this.BackupSlotOnOut);
      }
   }
}

