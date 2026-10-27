package Processors.Game.Lobby.MakeEquip.EquipSlots
{
   import Components.Slots.*;
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TEquipSlot extends TUIComponent
   {
      
      protected static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      protected var FSlot:TUISlot;
      
      protected var FInitialization:Boolean;
      
      protected var FTF_EquipName:TextField;
      
      protected var FTF_EquipLevel:TextField;
      
      protected var FTF_MaterialNum:TextField;
      
      protected var FNumBounds:TBounds;
      
      protected var FInventory:TInventory;
      
      protected var FEquipSlotMC:MovieClip;
      
      protected var FContext:Object;
      
      protected var FEquipName:String;
      
      protected var FOnOut:Function;
      
      protected var FOnOver:Function;
      
      protected var FOnQuerySequenceContext:Function;
      
      protected var FOnClick:Function;
      
      protected var FBClick:Boolean;
      
      public function TEquipSlot(param1:TUIComponent)
      {
         super(param1);
         this.FSlot = new TUISlot(this);
         this.FBClick = false;
         this.FInitialization = false;
      }
      
      protected function Initialization() : void
      {
         this.FEquipSlotMC = TUtilityReflection.CreateDisplayObjectInstance(CONST_EQUIPMAKE.RESOURCED_ClassName_Equip_Single) as MovieClip;
         addChild(this.FEquipSlotMC);
         this.FTF_EquipName = this.FEquipSlotMC[CONST_EQUIPMAKE.RESOURCE_Link_TF_EquipName];
         this.FTF_EquipName.mouseEnabled = false;
         this.FTF_EquipLevel = this.FEquipSlotMC[CONST_EQUIPMAKE.RESOURCE_Link_TF_EquipLevel];
         this.FTF_EquipLevel.mouseEnabled = false;
         this.FTF_MaterialNum = this.FEquipSlotMC.TF_MaterialNum;
         this.FTF_MaterialNum.mouseEnabled = false;
         this.FNumBounds = new TBounds();
         this.FNumBounds.X = 186;
         this.FNumBounds.Y = 20;
         this.FNumBounds.Width = 38;
         this.FNumBounds.Height = 20;
         this.FSlot.Resource = this.FEquipSlotMC[CONST_EQUIPMAKE.RESOURCES_MCName_Equip_slot] as Sprite;
         this.FSlot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FSlot.OnQuerySequenceContext = this.FOnQuerySequenceContext;
         this.FSlot.OnOver = this.FOnOver;
         this.FSlot.OnOut = this.FOnOut;
         this.FSlot.Init();
         this.FInventory = this.FContext as TInventory;
         this.FSlot.Context = this.FInventory;
         if(this.FInventory == null)
         {
            this.FTF_EquipName.text = "";
            this.FTF_EquipLevel.text = "";
            this.FTF_MaterialNum.text = "";
            return;
         }
         this.FTF_EquipName.text = this.FInventory.Name;
         this.FTF_EquipName.textColor = QUALITYCOLOR_INDEX[this.FInventory.Quality];
         this.FTF_EquipLevel.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.EQUIPMAKE_STRING_01) + this.FInventory.RequirementLevel;
         this.FTF_MaterialNum.text = "x" + this.FInventory.Quantity;
         this.FEquipSlotMC.addEventListener(MouseEvent.MOUSE_OVER,this.EquipOnOver,false,0,true);
         this.FEquipSlotMC.addEventListener(MouseEvent.MOUSE_OUT,this.EquipOnOut,false,0,true);
         this.FEquipSlotMC.addEventListener(MouseEvent.CLICK,this.EquipOnClick,false,0,true);
         this.FInitialization = true;
      }
      
      protected function EquipOnOver(param1:MouseEvent) : void
      {
         this.buttonMode = true;
         if(this.FBClick)
         {
            return;
         }
         this.FEquipSlotMC.gotoAndStop(CONST_EQUIPMAKE.MC_Frame_Over);
      }
      
      protected function EquipOnOut(param1:MouseEvent) : void
      {
         this.buttonMode = false;
         if(this.FBClick)
         {
            return;
         }
         this.FEquipSlotMC.gotoAndStop(CONST_EQUIPMAKE.MC_Frame_Normal);
      }
      
      protected function EquipOnClick(param1:MouseEvent) : void
      {
         if(this.FOnClick != null)
         {
            this.FOnClick(this,this.FSlot.Context);
         }
         if(this.FBClick)
         {
            this.FEquipSlotMC.gotoAndStop(CONST_EQUIPMAKE.MC_Frame_Selected);
         }
         else
         {
            this.FEquipSlotMC.gotoAndStop(CONST_EQUIPMAKE.MC_Frame_Normal);
         }
      }
      
      public function set EquipSlotMC(param1:MovieClip) : void
      {
         this.FEquipSlotMC = param1;
      }
      
      public function get Context() : Object
      {
         return this.FContext;
      }
      
      public function set Context(param1:Object) : void
      {
         this.FContext = param1;
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
      
      public function get OnQuerySequenceContext() : Function
      {
         return this.FOnQuerySequenceContext;
      }
      
      public function set OnQuerySequenceContext(param1:Function) : void
      {
         this.FOnQuerySequenceContext = param1;
      }
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function get BClick() : Boolean
      {
         return this.FBClick;
      }
      
      public function set BClick(param1:Boolean) : void
      {
         this.FBClick = param1;
         if(this.FBClick == false)
         {
            this.FEquipSlotMC.gotoAndStop(CONST_EQUIPMAKE.MC_Frame_Normal);
         }
      }
      
      public function Init() : void
      {
         if(this.FInitialization)
         {
            return;
         }
         this.Initialization();
      }
      
      public function Update() : void
      {
         this.FSlot.Update();
      }
      
      public function SetPicture() : void
      {
         this.FSlot.Resource.visible = false;
         this.FEquipSlotMC.gotoAndStop(CONST_EQUIPMAKE.MC_Frame_Disabled);
      }
      
      public function ResetSlot() : void
      {
         this.FSlot.Context = null;
         this.FContext = null;
         this.FTF_EquipName.text = "";
         this.FTF_EquipLevel.text = "";
         this.FTF_MaterialNum.text = "";
      }
   }
}

