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
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TGalleryItem extends TUIComponent
   {
      
      protected var FMainUI:Sprite;
      
      protected var FSelectBox:Sprite;
      
      protected var FSlot:TUISlot;
      
      protected var FMCBorder:MovieClip;
      
      protected var FMCGet:MovieClip;
      
      protected var FMCBg:MovieClip;
      
      protected var FOnOver:Function;
      
      protected var FOnOut:Function;
      
      protected var FIsMask:Boolean;
      
      public function TGalleryItem(param1:TUIComponent)
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
         this.FMCBorder = this.FMainUI["MC_Slot"]["MC_Mask"]["MC_Border"];
         this.FMCGet = this.FMainUI["MC_Slot"]["MC_Mask"]["MC_Get"];
         this.FMCBg = this.FMainUI["MC_Bg"];
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
         SToolReward.GetInventoryByID(CONST_COMMON.RewardIDToTemplateID(_loc2_.FixedAwards[0].Type,_loc2_.FixedAwards[0].Code),_loc3_);
         _loc4_ = _loc3_.GetInventoryByIndex(0);
         _loc4_.Quantity = _loc2_.FixedAwards[0].Amount;
         this.FSlot.Context = _loc4_;
      }
      
      public function SetLight(param1:Boolean) : void
      {
         if(param1)
         {
            this.FMCBorder.gotoAndStop(2);
         }
         else
         {
            this.FMCBorder.gotoAndStop(1);
         }
      }
      
      public function SetMask(param1:Boolean) : void
      {
         if(param1)
         {
            this.FMCBg.gotoAndStop(2);
            this.FSlot.Visible = false;
            this.FMainUI.removeEventListener(MouseEvent.MOUSE_MOVE,this.SlotOnOver);
         }
         else
         {
            this.FMCBg.gotoAndStop(1);
            this.FSlot.Visible = true;
            this.FMainUI.addEventListener(MouseEvent.MOUSE_MOVE,this.SlotOnOver);
         }
      }
      
      public function PlayEffect() : void
      {
         this.FMCGet.gotoAndPlay(1);
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
      
      public function get IsMask() : Boolean
      {
         return this.FIsMask;
      }
   }
}

