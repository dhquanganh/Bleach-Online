package Processors.Game.Lobby.Activity.HDThankssgivingDay.Components
{
   import Components.Slots.TUISlot;
   import Foundation.UI.TUIComponent;
   import Logics.Inventories.TInventory;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import flash.display.MovieClip;
   
   public class TTreasure extends TUIComponent
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FSlot:TUISlot;
      
      protected var FIsBomb:Boolean;
      
      protected var FIsOpen:Boolean;
      
      protected var FIsBright:Boolean;
      
      protected var FReceive:Boolean;
      
      protected var FContext:TInventory;
      
      public function TTreasure(param1:TUIComponent)
      {
         super(param1);
      }
      
      public function set IsBomb(param1:Boolean) : void
      {
         this.FIsBomb = param1;
         if(this.FIsBomb)
         {
            this.FMainUI.MC_Bomb.play();
         }
         else
         {
            this.FMainUI.MC_Bomb.stop();
         }
      }
      
      public function set IsOpen(param1:Boolean) : void
      {
         this.FIsOpen = param1;
         if(this.FIsOpen)
         {
            this.FMainUI.MC_NotOpen.visible = false;
            this.FMainUI.MC_Open.visible = true;
            if(this.IsBomb)
            {
               this.FMainUI.MC_Bomb.visible = true;
               this.FMainUI.MC_Slot.visible = false;
            }
            else
            {
               this.FMainUI.MC_Bomb.visible = false;
               this.FMainUI.MC_Slot.visible = true;
            }
         }
         else
         {
            this.FMainUI.MC_NotOpen.visible = true;
            this.FMainUI.MC_Open.visible = false;
            this.FMainUI.MC_Bomb.visible = false;
            this.FMainUI.MC_Slot.visible = false;
         }
      }
      
      public function set Context(param1:TInventory) : void
      {
         this.FContext = param1;
         this.FSlot.Context = this.FContext;
      }
      
      public function set IsBright(param1:Boolean) : void
      {
         this.FIsBright = param1;
         if(this.FIsBright)
         {
            this.FMainUI.MC_Open.gotoAndStop(2);
            this.FMainUI.MC_NotOpen.gotoAndStop(2);
         }
         else
         {
            this.FMainUI.MC_Open.gotoAndStop(1);
            this.FMainUI.MC_NotOpen.gotoAndStop(1);
         }
      }
      
      public function set Receive(param1:Boolean) : void
      {
         this.FReceive = param1;
         this.FSlot.SetDefaultFilters(this.FReceive);
      }
      
      public function get IsBomb() : Boolean
      {
         return this.FIsBomb;
      }
      
      public function InitUI(param1:MovieClip) : void
      {
         this.FMainUI = param1;
         this.FSlot = new TUISlot(this);
         this.FSlot.Resource = this.FMainUI["MC_Slot"];
         this.FSlot.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FSlot.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         TJadeCommon.InitSlot(this.FSlot);
         this.FSlot.Init();
         this.FMainUI.MC_Bomb.visible = false;
         this.FMainUI.MC_Slot.visible = false;
         this.FMainUI.MC_BombEffect.mouseEnabled = false;
      }
      
      public function Loop() : void
      {
         if(!this.FIsBomb)
         {
            this.FSlot.Update();
         }
      }
      
      public function PlayEffect() : void
      {
         this.FMainUI.MC_BombEffect.gotoAndPlay(2);
      }
   }
}

