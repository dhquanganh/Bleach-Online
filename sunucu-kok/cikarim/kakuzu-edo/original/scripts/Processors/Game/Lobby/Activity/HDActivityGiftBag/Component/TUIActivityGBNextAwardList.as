package Processors.Game.Lobby.Activity.HDActivityGiftBag.Component
{
   import Components.Slots.TUISlot;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Inventories.TInventories;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_LOBBY;
   import flash.display.Sprite;
   
   public class TUIActivityGBNextAwardList extends TUIComponent
   {
      
      protected var FMC:Sprite;
      
      protected var FSlotVect:Vector.<TUISlot>;
      
      protected var FSlotCount:int;
      
      protected var FBoxIndex:uint;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      protected var FOnQuerySequenceContext:Function;
      
      protected var FOnQuerySubscript:Function;
      
      public function TUIActivityGBNextAwardList(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Resources_UIDispatch(param1:Sprite, param2:Boolean = true) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUISlot = null;
         this.FMC = param1;
         if(param2)
         {
            addChild(this.FMC);
         }
         _loc4_ = this.FSlotCount;
         this.FSlotVect = new Vector.<TUISlot>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = new TUISlot(this);
            _loc5_.Resource = this.FMC[CONST_ACTIVITY.RESOURCE_Link_MC_Slot + _loc3_];
            _loc5_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc5_.OnQuerySequenceContext = this.FOnQuerySequenceContext;
            _loc5_.OnOver = this.FOnSlotOver;
            _loc5_.OnOut = this.FOnSlotOut;
            _loc5_.OnQuerySubscript = this.FOnQuerySubscript;
            _loc5_.Init();
            this.FSlotVect[_loc3_] = _loc5_;
            this.FSlotVect[_loc3_].Visible = false;
            _loc3_++;
         }
      }
      
      protected function UpdateUI(param1:TInventories = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1 != null)
         {
            _loc3_ = this.FSlotCount;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               if(_loc2_ < param1.Count)
               {
                  if(param1.GetInventoryByIndex(_loc2_) == null)
                  {
                     this.FSlotVect[_loc2_].Visible = false;
                  }
                  else
                  {
                     this.FSlotVect[_loc2_].Context = param1.GetInventoryByIndex(_loc2_);
                     this.FSlotVect[_loc2_].Visible = true;
                  }
               }
               else
               {
                  this.FSlotVect[_loc2_].Visible = false;
               }
               _loc2_++;
            }
         }
      }
      
      protected function DoClear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.FSlotVect.length <= 0)
         {
            return;
         }
         _loc2_ = int(this.FSlotVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlotVect[_loc1_].Context = null;
            _loc1_++;
         }
      }
      
      public function get OnSlotOver() : Function
      {
         return this.FOnSlotOver;
      }
      
      public function set OnSlotOver(param1:Function) : void
      {
         this.FOnSlotOver = param1;
      }
      
      public function get OnSlotOut() : Function
      {
         return this.FOnSlotOut;
      }
      
      public function set OnSlotOut(param1:Function) : void
      {
         this.FOnSlotOut = param1;
      }
      
      public function get OnQuerySequenceContext() : Function
      {
         return this.FOnQuerySequenceContext;
      }
      
      public function set OnQuerySequenceContext(param1:Function) : void
      {
         this.FOnQuerySequenceContext = param1;
      }
      
      public function get OnQuerySubscript() : Function
      {
         return this.FOnQuerySubscript;
      }
      
      public function set OnQuerySubscript(param1:Function) : void
      {
         this.FOnQuerySubscript = param1;
      }
      
      public function Perform_UIDispatch(param1:Sprite, param2:int, param3:Boolean = true) : void
      {
         this.FSlotCount = param2;
         this.Resources_UIDispatch(param1,param3);
      }
      
      public function UpDateUI(param1:uint, param2:TInventories = null) : void
      {
         this.FBoxIndex = param1;
         this.UpdateUI(param2);
      }
      
      public function UpDateSlot() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FSlotVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlotVect[_loc1_].Update();
            _loc1_++;
         }
      }
      
      public function Clear() : void
      {
         this.DoClear();
      }
   }
}

