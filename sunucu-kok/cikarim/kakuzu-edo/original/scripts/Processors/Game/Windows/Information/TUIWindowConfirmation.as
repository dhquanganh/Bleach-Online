package Processors.Game.Windows.Information
{
   import Components.Standard.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Processors.Game.Windows.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIWindowConfirmation extends TUIWindow
   {
      
      protected var FMC_CheckBox:Sprite;
      
      protected var FMC_Selected:TUIButton;
      
      protected var FMC_UnSelect:TUIButton;
      
      protected var FTF_CheckBox:TextField;
      
      protected var FIsSelected:Boolean;
      
      public function TUIWindowConfirmation(param1:TUIComponent)
      {
         super(param1);
         this.FIsSelected = false;
      }
      
      override protected function ConstructComponentButtons() : void
      {
         FButtonOK = this.ConstructComponentButton(CONST_COMMON.RESOURCE_Link_Btn_Ok,CONST_COMMON.RESOURCE_Link_TF_BtnOkCaption,this.ButtonOKOnClick,FButtonOkCaption);
         FButtonCancel = this.ConstructComponentButton(CONST_COMMON.RESOURCE_Link_Btn_Cancel,CONST_COMMON.RESOURCE_Link_TF_BtnCancelCaption,this.ButtonCancelOnClick,FButtonCancelCaption);
      }
      
      protected function ConstructComponentButton(param1:String, param2:String, param3:Function, param4:String) : TUIButton
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
         FTextField = FResource[CONST_COMMON.RESOURCE_Link_TF_Text];
         FTextField.selectable = false;
         Text = "";
      }
      
      override protected function ConstructComponentMovieClip() : void
      {
         var _loc1_:Sprite = null;
         this.FMC_CheckBox = FResource[CONST_COMMON.RESOURCE_Link_MC_CheckBox];
         this.FMC_CheckBox.visible = false;
         _loc1_ = this.FMC_CheckBox[CONST_COMMON.RESOURCE_Link_Btn_CheckBox];
         this.FMC_UnSelect = new TUIButton();
         this.FMC_UnSelect.Substrate = _loc1_[CONST_COMMON.RESOURCE_Link_MC_UnSelect];
         this.FMC_UnSelect.OnClick = this.CheckBoxOnClick;
         this.FMC_Selected = new TUIButton();
         this.FMC_Selected.Substrate = _loc1_[CONST_COMMON.RESOURCE_Link_MC_Selected];
         this.FMC_Selected.OnClick = this.CheckBoxOnClick;
         this.FMC_Selected.Visible = false;
         this.FTF_CheckBox = this.FMC_CheckBox[CONST_COMMON.RESOURCE_Link_TF_CheckBox];
      }
      
      override protected function NCButtonCloseOnClick(param1:Object) : void
      {
         if(this.FIsSelected)
         {
            this.FIsSelected = false;
         }
         if(FOnCancel != null)
         {
            FOnCancel(this);
         }
         SetWindowCenter();
         Visible = false;
      }
      
      protected function ButtonOKOnClick(param1:Object, param2:MouseEvent) : void
      {
         SetWindowCenter();
         Visible = false;
         if(FOnOK != null)
         {
            FOnOK(this);
         }
      }
      
      protected function ButtonCancelOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FIsSelected)
         {
            this.FIsSelected = false;
         }
         if(FOnCancel != null)
         {
            FOnCancel(this);
         }
         SetWindowCenter();
         Visible = false;
      }
      
      protected function CheckBoxOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FIsSelected = !this.FIsSelected;
         if(this.FIsSelected)
         {
            this.FMC_Selected.Visible = true;
            this.FMC_UnSelect.Visible = false;
         }
         else
         {
            this.FMC_Selected.Visible = false;
            this.FMC_UnSelect.Visible = true;
         }
         param2.stopPropagation();
      }
      
      public function SetCheckBoxUsable(param1:Boolean) : void
      {
         if(param1 != this.FMC_CheckBox.visible)
         {
            this.FMC_CheckBox.visible = param1;
         }
      }
      
      public function SetSelected(param1:Boolean) : void
      {
         if(param1)
         {
            this.FMC_Selected.Visible = true;
            this.FMC_UnSelect.Visible = false;
         }
         else
         {
            this.FMC_Selected.Visible = false;
            this.FMC_UnSelect.Visible = true;
         }
      }
      
      public function get IsSelected() : Boolean
      {
         return this.FIsSelected;
      }
      
      public function set IsSelected(param1:Boolean) : void
      {
         this.FIsSelected = param1;
      }
   }
}

