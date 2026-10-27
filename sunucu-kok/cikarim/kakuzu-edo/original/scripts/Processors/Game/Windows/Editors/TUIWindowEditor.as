package Processors.Game.Windows.Editors
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Inventories.*;
   import Processors.Game.Windows.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIWindowEditor extends TUIWindow
   {
      
      protected var FBtnClose:SimpleButton;
      
      protected var FCaption:TextField;
      
      protected var FLabel:TextField;
      
      protected var FQuantity:TextField;
      
      protected var FText:TextField;
      
      protected var FButtonMax:TUIButton;
      
      protected var FUISlot:TUISlot;
      
      protected var FMax:int;
      
      protected var FMin:int;
      
      protected var FEditorCaption:String;
      
      protected var FButtonMaxCaption:String;
      
      protected var FInputName:String;
      
      protected var FPriceText:String;
      
      public function TUIWindowEditor(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ConstructComponentButtons() : void
      {
         FButtonOK = this.ConstructComponentButton(CONST_COMMON.RESOURCE_Link_Btn_Ok,CONST_COMMON.RESOURCE_Link_TF_BtnOkCaption,this.ButtonOKOnClick,FButtonOkCaption);
         FButtonCancel = this.ConstructComponentButton(CONST_COMMON.RESOURCE_Link_Btn_Cancel,CONST_COMMON.RESOURCE_Link_TF_BtnCancelCaption,this.ButtonCancelOnClick,FButtonCancelCaption);
         this.FButtonMax = this.ConstructComponentButton(CONST_COMMON.RESOURCE_Link_Btn_Max,CONST_COMMON.RESOURCE_Link_TF_BtnMaxCaption,this.ButtonMaxOnClick,this.FButtonMaxCaption);
      }
      
      protected function ConstructComponentButton(param1:String, param2:String = null, param3:Function = null, param4:String = null) : TUIButton
      {
         var _loc5_:TUIButton = null;
         var _loc6_:TextField = null;
         _loc5_ = new TUIButton();
         _loc5_.Substrate = FResource[param1];
         _loc5_.OnClick = param3;
         if(!TUtilityString.Empty(param2))
         {
            _loc6_ = _loc5_.Substrate[param2];
            _loc6_.selectable = false;
            _loc6_.mouseEnabled = false;
         }
         if(!TUtilityString.Empty(param4))
         {
            _loc6_.text = param4;
         }
         return _loc5_;
      }
      
      override protected function ConstruceComponentTextfield() : void
      {
         super.ConstruceComponentTextfield();
         this.FCaption = FResource[CONST_COMMON.RESOURCE_Link_TF_Caption];
         if(!TUtilityString.Empty(this.FEditorCaption))
         {
            this.FCaption.text = this.FEditorCaption;
         }
         this.FLabel = FResource[CONST_COMMON.RESOURCE_Link_TF_Label];
         this.FQuantity = FResource[CONST_COMMON.RESOURCE_Link_TF_Quantity];
         this.FText = FResource[CONST_COMMON.RESOURCE_Link_TF_Value];
         this.FText.restrict = "0-9";
         this.FText.addEventListener(Event.CHANGE,this.TextFieldOnChange);
      }
      
      override protected function ConstructComponentMovieClip() : void
      {
         this.FUISlot = new TUISlot(this);
         this.FUISlot.Resource = FResource[CONST_COMMON.RESOURCE_Link_MC_Slot];
         this.FUISlot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FUISlot.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         this.FUISlot.Init();
      }
      
      override protected function NCButtonCloseOnClick(param1:Object) : void
      {
         if(FOnCancel != null)
         {
            FOnCancel(this);
         }
         Visible = false;
      }
      
      protected function ButtonOKOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(FOnOK != null)
         {
            FOnOK(this);
         }
         Visible = false;
      }
      
      protected function ButtonCancelOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(FOnCancel != null)
         {
            FOnCancel(this);
         }
         Visible = false;
      }
      
      protected function ButtonMaxOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FText.text = this.FMax.toString();
      }
      
      protected function TextFieldOnChange(param1:Event) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(this.FText.text);
         if(_loc2_ < this.FMin)
         {
            this.FText.text = this.FMin.toString();
         }
         else if(_loc2_ > this.FMax)
         {
            this.FText.text = this.FMax.toString();
         }
         else
         {
            this.FText.text = _loc2_.toString();
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
      
      public function get EditorCaption() : String
      {
         return this.FEditorCaption;
      }
      
      public function set EditorCaption(param1:String) : void
      {
         this.FEditorCaption = param1;
      }
      
      public function get ButtonMaxCaption() : String
      {
         return this.FButtonMaxCaption;
      }
      
      public function set ButtonMaxCaption(param1:String) : void
      {
         this.FButtonMaxCaption = param1;
      }
      
      public function set Label(param1:String) : void
      {
         this.FLabel.text = param1;
      }
      
      public function get Label() : String
      {
         return this.FLabel.text;
      }
      
      public function get Quantity() : String
      {
         return this.FQuantity.text;
      }
      
      public function set Quantity(param1:String) : void
      {
         this.FQuantity.text = param1;
      }
      
      public function set Value(param1:uint) : void
      {
         if(param1 < this.FMin)
         {
            this.FText.text = this.FMin.toString();
         }
         if(param1 > this.FMax)
         {
            this.FText.text = this.FMax.toString();
         }
         this.FText.text = param1.toString();
      }
      
      public function get Value() : uint
      {
         return uint(this.FText.text);
      }
      
      public function get Max() : int
      {
         return this.FMax;
      }
      
      public function set Max(param1:int) : void
      {
         this.FMax = param1;
      }
      
      public function get Min() : int
      {
         return this.FMin;
      }
      
      public function set Min(param1:int) : void
      {
         this.FMin = param1;
      }
      
      override public function get Context() : Object
      {
         return this.FUISlot.Context;
      }
      
      override public function set Context(param1:Object) : void
      {
         this.FUISlot.Context = param1;
      }
      
      public function SetFocus() : void
      {
         if(FUICore.UIStage.focus != this.FText)
         {
            FUICore.UIStage.focus = this.FText;
         }
      }
      
      public function Update() : void
      {
         this.FUISlot.Update();
      }
      
      public function SetCountVisible(param1:Boolean) : void
      {
         this.FQuantity.visible = param1;
      }
   }
}

