package Processors.Game.Windows.Editors
{
   import Components.Standard.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Processors.Game.Windows.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIWindowEditorString extends TUIWindow
   {
      
      public static const DEFAULT_MAX_CHARS:uint = 10;
      
      protected var FBtnClose:SimpleButton;
      
      protected var FCaption:TextField;
      
      protected var FLabel:TextField;
      
      protected var FEditorCaption:String;
      
      protected var FEditorLabel:String;
      
      public function TUIWindowEditorString(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ConstructComponentButtons() : void
      {
         FButtonOK = this.ConstructComponentButton(CONST_COMMON.RESOURCE_Link_Btn_Ok,CONST_COMMON.RESOURCE_Link_TF_BtnOkCaption,this.ButtonOKOnClick,FButtonOkCaption);
         FButtonCancel = this.ConstructComponentButton(CONST_COMMON.RESOURCE_Link_Btn_Cancel,CONST_COMMON.RESOURCE_Link_TF_BtnCancelCaption,this.ButtonCancelOnClick,FButtonCancelCaption);
      }
      
      protected function ConstructComponentButton(param1:String, param2:String = null, param3:Function = null, param4:String = null) : TUIButton
      {
         var _loc5_:TUIButton = null;
         var _loc6_:TextField = null;
         _loc5_ = new TUIButton();
         _loc5_.Substrate = FResource[param1];
         _loc5_.OnClick = param3;
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
         this.FLabel.selectable = false;
         if(!TUtilityString.Empty(this.FEditorLabel))
         {
            this.FLabel.text = this.FEditorLabel;
         }
         FTextField = FResource[CONST_COMMON.RESOURCE_Link_TF_Value];
         FTextField.text = "";
         FTextField.maxChars = DEFAULT_MAX_CHARS;
      }
      
      override protected function NCButtonCloseOnClick(param1:Object) : void
      {
         if(FOnCancel != null)
         {
            FOnCancel(this);
         }
         this.Reset();
         Visible = false;
      }
      
      protected function ButtonOKOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(FOnOK != null)
         {
            FOnOK(this);
         }
         this.Reset();
         Visible = false;
      }
      
      protected function ButtonCancelOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(FOnCancel != null)
         {
            FOnCancel(this);
         }
         this.Reset();
         Visible = false;
      }
      
      public function get EditorCaption() : String
      {
         return this.FEditorCaption;
      }
      
      public function set EditorCaption(param1:String) : void
      {
         this.FEditorCaption = param1;
      }
      
      public function get EditorLabel() : String
      {
         return this.FEditorLabel;
      }
      
      public function set EditorLabel(param1:String) : void
      {
         this.FEditorLabel = param1;
      }
      
      public function set Label(param1:String) : void
      {
         this.FLabel.text = param1;
      }
      
      public function get Label() : String
      {
         return this.FLabel.text;
      }
      
      public function set Value(param1:String) : void
      {
         FTextField.text = param1;
      }
      
      public function get Value() : String
      {
         return FTextField.text;
      }
      
      public function set Restrict(param1:String) : void
      {
         FTextField.restrict = param1;
      }
      
      public function get Restrict() : String
      {
         return FTextField.restrict;
      }
      
      public function set MaxChars(param1:uint) : void
      {
         FTextField.maxChars = param1;
      }
      
      public function get MaxChars() : uint
      {
         return FTextField.maxChars;
      }
      
      public function SetFocus() : void
      {
         if(FUICore.UIStage.focus != FTextField)
         {
            FUICore.UIStage.focus = FTextField;
         }
      }
   }
}

