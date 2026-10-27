package Processors.Game.Lobby.Activity.HDActivityRecharge.Component
{
   import Components.Slots.TUISlot;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.Repositories.TResourceRepositoryTexture;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Logics.Inventories.TInventory;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_LOBBY;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TDailyPayItem extends TUIComponent
   {
      
      protected var FScence:Sprite;
      
      protected var FSlot:TUISlot;
      
      protected var FTF_Name:TextField;
      
      protected var FContext:Object;
      
      protected var FOnOver:Function;
      
      protected var FOnOut:Function;
      
      protected var FOnQuerySubscript:Function;
      
      public function TDailyPayItem(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FScence = param2;
      }
      
      protected function ItemUIDispatch() : void
      {
         this.FSlot = new TUISlot(this);
         this.FSlot.Resource = this.FScence["MC_Slot"];
         this.FSlot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FSlot.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         this.FSlot.OnOver = this.BoxOnMove;
         this.FSlot.OnOut = this.OnBoxOut;
         this.FSlot.OnQuerySubscript = this.FOnQuerySubscript;
         this.FSlot.Init();
         this.FTF_Name = this.FScence["TF_Name"];
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
      
      protected function SetItemName() : void
      {
         var _loc1_:TInventory = null;
         _loc1_ = this.FContext as TInventory;
         this.FTF_Name.text = _loc1_.Name;
         this.FTF_Name.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc1_.Quality];
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
      
      public function get OnQuerySubscript() : Function
      {
         return this.FOnQuerySubscript;
      }
      
      public function set OnQuerySubscript(param1:Function) : void
      {
         this.FOnQuerySubscript = param1;
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
         this.FSlot.Context = this.FContext;
         if(param1 != null)
         {
            this.SetItemName();
         }
      }
      
      public function get Scence() : Sprite
      {
         return this.FScence;
      }
      
      public function set Scence(param1:Sprite) : void
      {
         this.FScence = param1;
      }
      
      public function ItemInit() : void
      {
         this.ItemUIDispatch();
      }
      
      public function UpdateItem() : void
      {
         this.FSlot.Update();
      }
      
      public function Reset() : void
      {
         this.FSlot.Context = null;
         this.FTF_Name.text = "";
      }
   }
}

