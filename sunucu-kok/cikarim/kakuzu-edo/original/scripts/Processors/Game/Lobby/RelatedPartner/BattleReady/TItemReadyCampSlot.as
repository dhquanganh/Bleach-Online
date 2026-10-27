package Processors.Game.Lobby.RelatedPartner.BattleReady
{
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TItemReadyCampSlot extends TUIComponent implements IRelatedReadySlot
   {
      
      protected static const LevelFormat:String = "Lv.%0";
      
      protected var FMainUI:Sprite;
      
      protected var FMask:Sprite;
      
      protected var FTFLevel:TextField;
      
      protected var FSlotOnDown:Function;
      
      protected var FSlotOnOut:Function;
      
      protected var FSlotOnOver:Function;
      
      protected var FSlotOnMove:Function;
      
      protected var FMountPoint:Bitmap;
      
      protected var FIsOperatable:Boolean;
      
      protected var FSlotIndex:int;
      
      protected var FLevel:int;
      
      public function TItemReadyCampSlot(param1:TUIComponent, param2:Sprite)
      {
         this.FMainUI = param2;
         super(param1);
      }
      
      public function Init() : void
      {
         this.FMountPoint = new Bitmap();
         this.FMask = this.FMainUI["Mask"];
         this.FTFLevel = this.FMainUI["TF_Level"];
         this.FMainUI["MountPoint"].addChild(this.FMountPoint);
         if(this.FIsOperatable)
         {
            this.FMainUI.addEventListener(MouseEvent.MOUSE_DOWN,this.CampSlotOnDown);
         }
         this.FMainUI.addEventListener(MouseEvent.MOUSE_OVER,this.CampSlotOnOver);
         this.FMainUI.addEventListener(MouseEvent.MOUSE_MOVE,this.CampSlotOnMove);
         this.FMainUI.addEventListener(MouseEvent.MOUSE_OUT,this.CampSlotOnOut);
      }
      
      protected function CampSlotOnDown(param1:MouseEvent) : void
      {
         if(this.FSlotOnDown != null)
         {
            this.FSlotOnDown(this.FSlotIndex);
         }
      }
      
      protected function CampSlotOnMove(param1:MouseEvent) : void
      {
         if(this.FSlotOnMove != null)
         {
            this.FSlotOnMove(this.FSlotIndex);
         }
      }
      
      protected function CampSlotOnOver(param1:MouseEvent) : void
      {
         if(this.FSlotOnOver != null)
         {
            this.FSlotOnOver(this.FSlotIndex);
         }
      }
      
      protected function CampSlotOnOut(param1:MouseEvent) : void
      {
         if(this.FSlotOnOut != null)
         {
            this.FSlotOnOut(this.FSlotIndex);
         }
      }
      
      public function get IsOperatable() : Boolean
      {
         return this.FIsOperatable;
      }
      
      public function set IsOperatable(param1:Boolean) : void
      {
         this.FIsOperatable = param1;
      }
      
      public function get SlotOnDown() : Function
      {
         return this.FSlotOnDown;
      }
      
      public function set SlotOnDown(param1:Function) : void
      {
         this.FSlotOnDown = param1;
      }
      
      public function get SlotOnOut() : Function
      {
         return this.FSlotOnOut;
      }
      
      public function set SlotOnOut(param1:Function) : void
      {
         this.FSlotOnOut = param1;
      }
      
      public function get SlotOnOver() : Function
      {
         return this.FSlotOnOver;
      }
      
      public function set SlotOnOver(param1:Function) : void
      {
         this.FSlotOnOver = param1;
      }
      
      public function get SlotOnMove() : Function
      {
         return this.FSlotOnMove;
      }
      
      public function set SlotOnMove(param1:Function) : void
      {
         this.FSlotOnMove = param1;
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
         if(this.FLevel > 0)
         {
            this.FTFLevel.text = TUtilityString.Format(LevelFormat,this.FLevel);
            return;
         }
         this.FTFLevel.text = "";
      }
      
      public function get MountPoint() : Bitmap
      {
         return this.FMountPoint;
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
      
      public function SetMask(param1:Boolean) : void
      {
         this.FMask.visible = param1;
      }
   }
}

