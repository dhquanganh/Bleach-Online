package Processors.Game.Windows.Input
{
   import Components.Standard.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Processors.Game.Windows.*;
   import Resources.Constants.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIWindowInputString extends TUIWindow
   {
      
      protected var FCaption:TextField;
      
      protected var FLabel:TextField;
      
      protected var FText:TextField;
      
      protected var FBFocus:Boolean;
      
      protected var FEditorString:String;
      
      public function TUIWindowInputString(param1:TUIComponent)
      {
         super(param1);
         this.FBFocus = false;
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
         this.FText = FResource[CONST_COMMON.RESOURCE_Link_TF_Text];
         if(!TUtilityString.Empty(this.FEditorString))
         {
            this.FText.text = this.FEditorString;
         }
         this.FText = FResource[CONST_COMMON.RESOURCE_Link_TF_Text];
         this.FText.addEventListener(Event.CHANGE,this.TextFieldOnChange);
         this.FText.addEventListener(FocusEvent.FOCUS_IN,this.OnTextFocusIn);
         this.FText.addEventListener(FocusEvent.FOCUS_OUT,this.OnTextFocusOut);
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
            FOnOK(this,String(this.FText.text));
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
      
      protected function TextFieldOnChange(param1:Event) : void
      {
      }
      
      protected function OnTextFocusIn(param1:FocusEvent) : void
      {
         if(!this.FBFocus)
         {
            this.FText.text = "";
            this.FBFocus = true;
         }
      }
      
      protected function OnTextFocusOut(param1:FocusEvent) : void
      {
         if(this.FText.text == "")
         {
            this.FText.text = this.FEditorString;
            this.FBFocus = false;
         }
      }
      
      public function get EditorString() : String
      {
         return this.FEditorString;
      }
      
      public function set EditorString(param1:String) : void
      {
         this.FEditorString = param1;
      }
      
      public function SetFocus() : void
      {
         if(FUICore.UIStage.focus != this.FText)
         {
            FUICore.UIStage.focus = this.FText;
         }
      }
      
      public function Update(param1:String) : void
      {
      }
   }
}

