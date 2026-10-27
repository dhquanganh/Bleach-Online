package Processors.Game.Lobby.TokenShop.Components
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.Inventories.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUITokenSample extends TUIComponent
   {
      
      protected var FUISlot:TUISlot;
      
      protected var FTF_NeedCount:TextField;
      
      protected var FBtn_Exchange:TUIButton;
      
      protected var FResource:Sprite;
      
      protected var FContext:TInventorySample;
      
      protected var FOnExchange:Function;
      
      public function TUITokenSample(param1:TUIComponent)
      {
         super(param1);
         this.FUISlot = new TUISlot(this);
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         this.FTF_NeedCount = this.FResource["TF_NeedCount"];
         this.FTF_NeedCount.mouseEnabled = false;
         this.FBtn_Exchange = new TUIButton();
         this.FBtn_Exchange.Substrate = this.FResource["Btn_Exchange"];
         this.FUISlot.Resource = this.FResource[CONST_COMMON.RESOURCE_Link_MC_Slot];
         this.FUISlot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FUISlot.Init();
         this.Reset();
      }
      
      protected function UpdateUI() : void
      {
         this.FUISlot.Context = this.FContext.Inventory;
         this.FTF_NeedCount.text = this.FContext.Integration.toString();
      }
      
      protected function addEventListenerPlayer() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FBtn_Exchange.OnClick = this.Btn_ExchangeOnClick;
         this.FResource.addEventListener(MouseEvent.CLICK,this.ResourceOnClick,false,0,true);
      }
      
      protected function RemoveEventListenerPlayer() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FBtn_Exchange.OnClick = null;
         this.FResource.removeEventListener(MouseEvent.CLICK,this.ResourceOnClick);
      }
      
      protected function ResourceOnClick(param1:MouseEvent) : void
      {
         if(this.FContext == null)
         {
            return;
         }
         if(this.FOnExchange != null)
         {
            this.FOnExchange(this,this.FContext);
         }
      }
      
      protected function Btn_ExchangeOnClick(param1:Object, param2:MouseEvent) : void
      {
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
      
      public function get OnExchange() : Function
      {
         return this.FOnExchange;
      }
      
      public function set OnExchange(param1:Function) : void
      {
         this.FOnExchange = param1;
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
         this.FUISlot.Context = null;
         this.FTF_NeedCount.text = "";
         this.FTF_NeedCount.text = "";
      }
      
      override public function Dispose() : void
      {
         this.Reset();
         this.FUISlot.Dispose();
         this.FUISlot = null;
         this.FBtn_Exchange.Dispose();
         this.FBtn_Exchange = null;
         this.FTF_NeedCount = null;
         this.FOnExchange = null;
         this.FContext = null;
         this.FResource = null;
      }
      
      public function Update() : void
      {
         this.FUISlot.Update();
      }
   }
}

