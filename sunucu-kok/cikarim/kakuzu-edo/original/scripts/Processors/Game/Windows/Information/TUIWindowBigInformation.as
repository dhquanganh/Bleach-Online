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
   
   public class TUIWindowBigInformation extends TUIWindow
   {
      
      protected static const SIZE_TextWidthMin:int = 240;
      
      protected static const SIZE_TextWidthMax:int = 480;
      
      protected static const SIZE_TextMarginLeft:int = 32;
      
      protected static const SIZE_TextMarginRight:int = 32;
      
      protected static const SIZE_TextMarginTop:int = 60;
      
      protected static const SIZE_TextMarginBottom:int = 80;
      
      protected var FBtnClose:SimpleButton;
      
      public function TUIWindowBigInformation(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ConstructComponentButtons() : void
      {
         if(FResource != null)
         {
            FButtonOK = this.ConstructComponentButton(CONST_COMMON.RESOURCE_Link_Btn_Ok,CONST_COMMON.RESOURCE_Link_TF_BtnOkCaption,this.ButtonOKOnClick,FButtonOkCaption);
         }
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
         if(FResource != null)
         {
            FTextField = FResource[CONST_COMMON.RESOURCE_Link_TF_Text];
            FTextField.selectable = false;
            Text = "";
         }
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
      
      protected function ButtonCloseOnClick(param1:MouseEvent) : void
      {
         if(FOnCancel != null)
         {
            FOnCancel(this);
         }
         this.Reset();
         Visible = false;
      }
   }
}

