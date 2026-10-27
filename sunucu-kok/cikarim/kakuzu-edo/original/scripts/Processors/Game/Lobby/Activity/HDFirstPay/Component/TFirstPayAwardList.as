package Processors.Game.Lobby.Activity.HDFirstPay.Component
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Queries.TQueryString;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.Repositories.TResourceRepositoryTexture;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Logics.Inventories.TAppliance;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_LOBBY;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TFirstPayAwardList extends TUIComponent
   {
      
      protected static const SLOT_NUM:uint = 6;
      
      protected var FScence:Sprite;
      
      protected var FBT_GotoRecharge:TUIButton;
      
      protected var FBT_GetAward:TUIButton;
      
      protected var FSP_Got:Sprite;
      
      protected var FSlotList:Vector.<TUISlot>;
      
      protected var FMC_Effect:MovieClip;
      
      protected var FContext:Object;
      
      protected var FOnOver:Function;
      
      protected var FOnOut:Function;
      
      protected var FOnRecharge:Function;
      
      protected var FOnAwardClick:Function;
      
      public function TFirstPayAwardList(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FScence = param2;
         this.FSlotList = new Vector.<TUISlot>(SLOT_NUM);
      }
      
      private function AwardListInit() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUISlot = null;
         this.FBT_GotoRecharge = new TUIButton();
         this.FBT_GotoRecharge.Substrate = this.FScence["Btn_GotoLink"];
         this.FBT_GotoRecharge.OnClick = this.RechargeOnClick;
         this.FBT_GetAward = new TUIButton();
         this.FBT_GetAward.Substrate = this.FScence["BT_GetAward"];
         this.FBT_GetAward.OnClick = this.AwardOnClick;
         this.FSP_Got = this.FScence["MC_Got"];
         _loc2_ = SLOT_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = this.FScence["MC_Slot_" + _loc1_];
            _loc3_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc3_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc3_.OnOver = this.BoxOnMove;
            _loc3_.OnOut = this.OnBoxOut;
            _loc3_.OnQuerySubscript = this.SlotsOnQuerySubscript;
            _loc3_.Init();
            this.FSlotList[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.FMC_Effect = this.FScence["MC_Effect"];
         this.FMC_Effect.stop();
         this.FMC_Effect.visible = false;
         this.FMC_Effect.mouseEnabled = false;
      }
      
      protected function SlotsOnQuerySubscript(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TAppliance = null;
         if(param2 is TAppliance)
         {
            _loc4_ = param2 as TAppliance;
            param3.Value = _loc4_.Quantity.toString();
         }
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TInventory = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TInventory;
         _loc6_ = SResourcesCore.TexturesInventory;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.IDTexture);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.IDTexture);
         }
      }
      
      private function SetSlot(param1:Object) : void
      {
         var _loc2_:TInventories = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = param1 as TInventories;
         _loc4_ = SLOT_NUM;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FSlotList[_loc3_].Context = null;
            this.FSlotList[_loc3_].Resource.visible = false;
            _loc3_++;
         }
         if(_loc2_ != null)
         {
            _loc4_ = SLOT_NUM;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               if(_loc3_ < _loc2_.Count)
               {
                  this.FSlotList[_loc3_].Context = _loc2_.GetInventoryByIndex(_loc3_);
                  this.FSlotList[_loc3_].Resource.visible = true;
               }
               _loc3_++;
            }
         }
      }
      
      private function SetButtonState(param1:int) : void
      {
         switch(param1)
         {
            case CONST_ACTIVITY_MODE.Activity_CanNotReceive:
               this.FBT_GetAward.Enabled = false;
               this.FBT_GetAward.Visible = true;
               this.FSP_Got.visible = false;
               break;
            case CONST_ACTIVITY_MODE.Activity_AlreadyReceive:
               this.FBT_GetAward.Enabled = Enabled;
               this.FBT_GetAward.Visible = false;
               this.FSP_Got.visible = true;
               break;
            case CONST_ACTIVITY_MODE.Activity_CanReceive:
               this.FBT_GetAward.Enabled = true;
               this.FBT_GetAward.Visible = true;
               this.FSP_Got.visible = false;
         }
      }
      
      private function RechargeOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnRecharge != null)
         {
            this.FOnRecharge(this);
         }
      }
      
      private function AwardOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnAwardClick != null)
         {
            this.FOnAwardClick(this);
         }
      }
      
      private function BoxOnMove(param1:Object, param2:Object) : void
      {
         if(this.FOnOver != null)
         {
            this.FOnOver(this,param2);
         }
      }
      
      private function OnBoxOut(param1:Object, param2:Object) : void
      {
         if(this.FOnOut != null)
         {
            this.FOnOut(this,param2);
         }
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
      
      public function get Context() : Object
      {
         return this.FContext;
      }
      
      public function set Context(param1:Object) : void
      {
         this.FContext = param1;
         this.SetSlot(this.FContext);
      }
      
      public function get OnAwardClick() : Function
      {
         return this.FOnAwardClick;
      }
      
      public function set OnAwardClick(param1:Function) : void
      {
         this.FOnAwardClick = param1;
      }
      
      public function get OnRecharge() : Function
      {
         return this.FOnRecharge;
      }
      
      public function set OnRecharge(param1:Function) : void
      {
         this.FOnRecharge = param1;
      }
      
      public function ListInit() : void
      {
         this.AwardListInit();
      }
      
      public function UpdateSlot() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = SLOT_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlotList[_loc1_].Update();
            _loc1_++;
         }
      }
      
      public function Reset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = SLOT_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlotList[_loc1_].Context = null;
            this.FSlotList[_loc1_].Resource.visible = false;
            _loc1_++;
         }
         this.SetEffect(false);
      }
      
      public function SetButton(param1:int) : void
      {
         this.SetButtonState(param1);
      }
      
      public function SetEffect(param1:Boolean) : void
      {
         if(param1)
         {
            this.FMC_Effect.play();
            this.FMC_Effect.visible = true;
         }
         else
         {
            this.FMC_Effect.stop();
            this.FMC_Effect.visible = false;
         }
      }
   }
}

