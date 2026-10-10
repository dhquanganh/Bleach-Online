package Processors.Game.Lobby.Talisman
{
   import Components.Slots.*;
   import Foundation.Common.Stubs.*;
   import Foundation.Queries.TQueryUInt;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Inventories.*;
   import Processors.Game.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TSingleEquip extends TProcessorGame
   {
      
      protected static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      protected var FScene:MovieClip;
      
      protected var FMC_Slot:TUISlot;
      
      protected var FTF_TalismanName:TextField;
      
      protected var FTF_TalismanLevel:TextField;
      
      protected var FContext:Object;
      
      protected var FBClick:Boolean;
      
      protected var FBSelect:Boolean;
      
      protected var FInventory:TInventory;
      
      protected var FInitialized:Boolean;
      
      protected var FStubReferences:TStubReferences;
      
      protected var FOnClick:Function;
      
      protected var FOnOut:Function;
      
      protected var FOnOver:Function;
      
      protected var FOnQuerySequenceContext:Function;
      
      protected var FOnQueryEuqipLevel:Function;
      
      public function TSingleEquip(param1:TUIComponent)
      {
         super(param1);
         this.UIDispatch();
         this.UILocation();
      }
      
      protected function UIDispatch() : void
      {
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance("MC_SingleEquip") as MovieClip;
         addChild(this.FScene);
         this.FTF_TalismanName = this.FScene["TF_TalismanName"];
         this.FTF_TalismanName.mouseEnabled = false;
         this.FTF_TalismanLevel = this.FScene["TF_TalismanLevel"];
         this.FTF_TalismanLevel.mouseEnabled = false;
         this.FMC_Slot = new TUISlot(this);
         this.FMC_Slot.visible = true;
         this.FMC_Slot.Resource = this.FScene["MC_Slot"] as Sprite;
         this.FMC_Slot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FMC_Slot.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect);
         this.FMC_Slot.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
         this.FMC_Slot.Init();
      }
      
      protected function UILocation() : void
      {
         this.FTF_TalismanName.selectable = false;
         this.FTF_TalismanLevel.selectable = false;
         this.addEventListener(MouseEvent.MOUSE_OVER,this.EquipOnOver,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.EquipOnOut,false,0,true);
         this.addEventListener(MouseEvent.CLICK,this.EquipOnClick,false,0,true);
         this.FBSelect = true;
         this.FStubReferences = new TStubReferences(this);
         this.buttonMode = true;
         this.Reset();
      }
      
      protected function ClearEventListener() : void
      {
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.EquipOnOver,false);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.EquipOnOut,false);
         this.removeEventListener(MouseEvent.CLICK,this.EquipOnClick,false);
      }
      
      protected function Reset() : void
      {
         this.FMC_Slot.Resource.visible = false;
         this.FMC_Slot.Context = null;
         this.FScene.gotoAndStop(CONST_TALISMAN.MC_Frame_disabled);
         this.FTF_TalismanName.text = "";
         this.FTF_TalismanLevel.text = "";
      }
      
      protected function EquipOnOver(param1:MouseEvent) : void
      {
         if(!this.FBClick && this.FMC_Slot.Context != null)
         {
            this.FScene.gotoAndStop(CONST_TALISMAN.MC_Frame_Over);
         }
      }
      
      protected function EquipOnOut(param1:MouseEvent) : void
      {
         if(!this.FBClick && this.FMC_Slot.Context != null)
         {
            this.FScene.gotoAndStop(CONST_TALISMAN.MC_Frame_Normal);
         }
      }
      
      protected function EquipOnClick(param1:MouseEvent) : void
      {
         if(this.FMC_Slot.Context == null)
         {
            return;
         }
         if(this.FOnClick != null)
         {
            this.FOnClick(this,this.FMC_Slot.Context);
         }
         if(this.FBSelect)
         {
            this.FBClick = true;
            this.FScene.gotoAndStop(CONST_TALISMAN.MC_Frame_Selected);
         }
         else
         {
            this.FScene.gotoAndStop(CONST_TALISMAN.MC_Frame_Normal);
         }
      }
      
      protected function SlotsOnQueryEdgeColor(param1:Object, param2:Object, param3:TQueryUInt) : void
      {
         var _loc4_:TEquipment = null;
         if(param2 is TEquipment)
         {
            _loc4_ = param2 as TEquipment;
            param3.Value = _loc4_.IsEdgeColor;
         }
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function set OnOver(param1:Function) : void
      {
         this.FMC_Slot.OnOver = param1;
      }
      
      public function set OnOut(param1:Function) : void
      {
         this.FMC_Slot.OnOut = param1;
      }
      
      public function set Context(param1:Object) : void
      {
         this.FMC_Slot.Context = param1;
      }
      
      public function get BClick() : Boolean
      {
         return this.FBClick;
      }
      
      public function set BClick(param1:Boolean) : void
      {
         this.FBClick = param1;
         if(!this.FBClick)
         {
            this.FScene.gotoAndStop(CONST_TALISMAN.MC_Frame_Normal);
         }
         else
         {
            this.FScene.gotoAndStop(CONST_TALISMAN.MC_Frame_Selected);
         }
      }
      
      public function get BSelect() : Boolean
      {
         return this.FBSelect;
      }
      
      public function set BSelect(param1:Boolean) : void
      {
         this.FBSelect = param1;
      }
      
      public function get OnQuerySequenceContext() : Function
      {
         return this.FOnQuerySequenceContext;
      }
      
      public function set OnQuerySequenceContext(param1:Function) : void
      {
         this.FMC_Slot.OnQuerySequenceContext = param1;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get OnQueryEuqipLevel() : Function
      {
         return this.FOnQueryEuqipLevel;
      }
      
      public function set OnQueryEuqipLevel(param1:Function) : void
      {
         this.FMC_Slot.OnQueryEuqipLevel = param1;
      }
      
      public function SetEquip(param1:TInventory, param2:String, param3:String, param4:uint) : void
      {
         if(this.FMC_Slot.Context != null)
         {
            this.FMC_Slot.Context = null;
         }
         this.FMC_Slot.Context = param1;
         this.FMC_Slot.Resource.visible = true;
         this.FScene.gotoAndStop(CONST_TALISMAN.MC_Frame_Normal);
         this.FTF_TalismanName.text = param2;
         this.FTF_TalismanLevel.text = param3;
         this.FTF_TalismanName.textColor = QUALITYCOLOR_INDEX[param4];
      }
      
      public function OnSelect() : void
      {
         this.EquipOnClick(null);
      }
      
      public function UpdateSingleEquip() : void
      {
         this.FMC_Slot.Update();
      }
      
      public function Release() : void
      {
         this.Reset();
      }
   }
}

