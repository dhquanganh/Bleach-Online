package Processors.Game.Lobby.StoneShop.Components
{
   import Components.Slots.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.Inventories.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIStoneSample extends TUIComponent
   {
      
      protected static const FRAMEINDEX_Normal:uint = 1;
      
      protected static const FRAMEINDEX_Over:uint = 2;
      
      private static const TYPE_STONE_A:uint = 14100283;
      
      private static const TYPE_STONE_B:uint = 14100733;
      
      protected var FTF_Name:TextField;
      
      protected var FUISlot:TUISlot;
      
      protected var FMC_Stone:MovieClip;
      
      protected var FTF_NeedCount:TextField;
      
      protected var FMC_Bg:MovieClip;
      
      protected var FResource:Sprite;
      
      protected var FContext:TInventorySample;
      
      protected var FOnClick:Function;
      
      public function TUIStoneSample(param1:TUIComponent)
      {
         super(param1);
         this.FUISlot = new TUISlot(this);
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         this.FTF_Name = this.FResource["TF_Name"];
         this.FTF_Name.mouseEnabled = false;
         this.FMC_Stone = this.FResource["MC_Stone"];
         this.FMC_Stone.mouseEnabled = false;
         this.FTF_NeedCount = this.FResource["TF_NeedCount"];
         this.FTF_NeedCount.mouseEnabled = false;
         this.FMC_Bg = this.FResource["MC_Bg"];
         this.FUISlot.Resource = this.FResource[CONST_COMMON.RESOURCE_Link_MC_Slot];
         this.FUISlot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FUISlot.Init();
         this.Reset();
      }
      
      protected function UpdateUI() : void
      {
         this.FTF_Name.text = this.FContext.Name;
         this.FUISlot.Context = this.FContext.Inventory;
         switch(this.FContext.Items.Code)
         {
            case TYPE_STONE_A:
               this.FMC_Stone.gotoAndStop(1);
               break;
            case TYPE_STONE_B:
               this.FMC_Stone.gotoAndStop(2);
         }
         this.FTF_NeedCount.text = this.FContext.Integration.toString();
      }
      
      protected function addEventListenerPlayer() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FResource.addEventListener(MouseEvent.CLICK,this.ResourceOnClick,false,0,true);
         this.FResource.addEventListener(MouseEvent.MOUSE_MOVE,this.ResourceOnOver,false,0,true);
         this.FResource.addEventListener(MouseEvent.MOUSE_OUT,this.ResourceOnOut,false,0,true);
      }
      
      protected function RemoveEventListenerPlayer() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FResource.removeEventListener(MouseEvent.CLICK,this.ResourceOnClick);
         this.FResource.removeEventListener(MouseEvent.MOUSE_MOVE,this.ResourceOnOver);
         this.FResource.removeEventListener(MouseEvent.MOUSE_OUT,this.ResourceOnOut);
      }
      
      protected function ResourceOnClick(param1:MouseEvent) : void
      {
         if(this.FContext == null)
         {
            return;
         }
         if(this.FOnClick != null)
         {
            this.FOnClick(this,this.FContext);
         }
      }
      
      protected function ResourceOnOver(param1:MouseEvent) : void
      {
         this.FMC_Bg.gotoAndStop(FRAMEINDEX_Over);
      }
      
      protected function ResourceOnOut(param1:MouseEvent) : void
      {
         this.FMC_Bg.gotoAndStop(FRAMEINDEX_Normal);
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         this.FResource = param1;
      }
      
      public function get Context() : TInventorySample
      {
         return this.FContext;
      }
      
      public function set Context(param1:TInventorySample) : void
      {
         this.Reset();
         if(this.FContext == null && param1 != null)
         {
            this.addEventListenerPlayer();
         }
         else if(param1 == null)
         {
            this.RemoveEventListenerPlayer();
         }
         this.FContext = param1;
         this.FUISlot.Context = param1;
         if(param1 != null)
         {
            this.UpdateUI();
         }
      }
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function get OnQuerySequenceContext() : Function
      {
         return this.FUISlot.OnQuerySequenceContext;
      }
      
      public function set OnQuerySequenceContext(param1:Function) : void
      {
         this.FUISlot.OnQuerySequenceContext = param1;
      }
      
      public function get OnSlotOver() : Function
      {
         return this.FUISlot.OnOver;
      }
      
      public function set OnSlotOver(param1:Function) : void
      {
         this.FUISlot.OnOver = param1;
      }
      
      public function get OnSlotOut() : Function
      {
         return this.FUISlot.OnOut;
      }
      
      public function set OnSlotOut(param1:Function) : void
      {
         this.FUISlot.OnOut = param1;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         if(this.FResource != null)
         {
            this.FResource.visible = param1;
         }
      }
      
      public function Perform_UIDispatch() : void
      {
         this.ResourcesPerform_UIDispatch();
      }
      
      public function Reset() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FMC_Bg.gotoAndStop(FRAMEINDEX_Normal);
         this.FUISlot.Context = null;
         this.FTF_Name.text = "";
         this.FTF_NeedCount.text = "";
         this.FTF_NeedCount.text = "";
      }
      
      override public function Dispose() : void
      {
         this.Reset();
         this.FUISlot.Dispose();
         this.FUISlot = null;
         this.FTF_Name = null;
         this.FTF_NeedCount = null;
         this.FMC_Bg = null;
         this.FOnClick = null;
         this.FContext = null;
         this.FResource = null;
      }
      
      public function Update() : void
      {
         this.FUISlot.Update();
      }
   }
}

