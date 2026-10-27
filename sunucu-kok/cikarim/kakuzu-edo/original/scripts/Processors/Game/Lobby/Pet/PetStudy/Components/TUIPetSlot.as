package Processors.Game.Lobby.Pet.PetStudy.Components
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Pet.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TUIPetSlot extends TUIComponent
   {
      
      protected var FUISlot:TUISlot;
      
      protected var FBtn_Dismissal:TUIButton;
      
      protected var FInitialization:Boolean;
      
      protected var FResource:Sprite;
      
      protected var FContext:TVicePet;
      
      protected var FOnClick:Function;
      
      protected var FOnDismissal:Function;
      
      protected var FOnOver:Function;
      
      protected var FOnOut:Function;
      
      public function TUIPetSlot(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Initialization() : void
      {
         this.FUISlot = new TUISlot(this);
         this.FUISlot.Resource = this.FResource[CONST_COMMON.RESOURCE_Link_MC_Slot];
         this.FUISlot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FUISlot.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         this.FUISlot.OnQuerySubscript = this.SlotsOnQuerySubscript;
         this.FUISlot.OnOver = this.ProcessorOnSlotOver;
         this.FUISlot.OnOut = this.ProcessorOnSlotOut;
         this.FUISlot.OnClick = this.ProcessorOnClick;
         this.FUISlot.Init();
         this.FBtn_Dismissal = new TUIButton();
         this.FBtn_Dismissal.Substrate = this.FResource["Btn_Dismissal"];
         this.FBtn_Dismissal.OnClick = this.Btn_DismissalOnClick;
         this.Reset();
         this.FInitialization = true;
      }
      
      protected function UpdateUIPetSlot() : void
      {
         if(this.FResource == null)
         {
            return;
         }
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TPetBase = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TPetBase;
         _loc6_ = SResourcesCore.TexturesHeadIcon;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.HeadIconID);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.HeadIconID);
         }
      }
      
      protected function SlotsOnQuerySubscript(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TPetBase = null;
         if(param2 is TPetBase)
         {
            _loc4_ = param2 as TPetBase;
            param3.Value = TUtilityString.Format(STRING_COMMON.FORMAT_05,_loc4_.Level);
         }
      }
      
      protected function Btn_DismissalOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnDismissal != null)
         {
            this.FOnDismissal(this,this.FContext);
         }
      }
      
      protected function ProcessorOnSlotOver(param1:Object, param2:Object) : void
      {
         if(this.FOnOver != null)
         {
            this.FOnOver(param1,param2);
         }
      }
      
      protected function ProcessorOnSlotOut(param1:Object, param2:Object) : void
      {
         if(this.FOnOut != null)
         {
            this.FOnOut(param1,param2);
         }
      }
      
      protected function ProcessorOnClick(param1:Object, param2:Object) : void
      {
         if(this.FOnClick != null)
         {
            this.FOnClick(param1,param2);
         }
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1 != this.FResource)
         {
            this.FResource = param1;
         }
         if(!this.FInitialization)
         {
            this.Initialization();
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
      
      public function get OnDismissal() : Function
      {
         return this.FOnDismissal;
      }
      
      public function set OnDismissal(param1:Function) : void
      {
         this.FOnDismissal = param1;
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
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(!this.FInitialization)
         {
            return;
         }
         this.FResource.visible = param1;
      }
      
      public function get Context() : TVicePet
      {
         return this.FContext;
      }
      
      public function set Context(param1:TVicePet) : void
      {
         this.FContext = param1;
         this.FUISlot.Context = param1;
         if(param1 != null)
         {
            this.UpdateUIPetSlot();
         }
         else
         {
            this.Reset();
         }
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         if(this.FResource == null)
         {
            return;
         }
         this.FUISlot.Context = null;
      }
      
      public function Update() : void
      {
         this.FUISlot.Update();
      }
   }
}

