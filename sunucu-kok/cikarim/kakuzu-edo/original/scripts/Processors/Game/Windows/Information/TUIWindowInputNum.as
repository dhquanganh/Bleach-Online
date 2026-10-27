package Processors.Game.Windows.Information
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Windows.TUIWindow;
   import Resources.Constants.CONST_COMMON;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIWindowInputNum extends TUIWindow
   {
      
      protected static const SIZE_Window_Width:uint = 280;
      
      protected static const SIZE_Window_Height:uint = 226;
      
      protected var FTF_Title:TextField;
      
      protected var FBtn_Add:SimpleButton;
      
      protected var FBtn_Sub:SimpleButton;
      
      protected var FBtn_Max:SimpleButton;
      
      protected var FTF_Num:TextField;
      
      protected var FCurrentNum:int;
      
      protected var FMax_Num:uint;
      
      protected var FFunOnChangeInputNumShowString:Function;
      
      public function TUIWindowInputNum(param1:TUIComponent)
      {
         super(param1);
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
         this.FBtn_Add = FResource["BTN_Add"];
         this.FBtn_Sub = FResource["BTN_Reduce"];
         this.FBtn_Max = FResource["Btn_Max"];
         this.FTF_Num = FResource["TF_Num"];
         this.FTF_Num.restrict = "0-9";
         this.FTF_Num.maxChars = 5;
         this.FBtn_Max.addEventListener(MouseEvent.CLICK,this.MaxNumBtnClicked);
         this.FBtn_Add.addEventListener(MouseEvent.CLICK,this.AddBtnClicked);
         this.FBtn_Sub.addEventListener(MouseEvent.CLICK,this.SubBtnClicked);
         this.FTF_Num.addEventListener(Event.CHANGE,this.InputNumChanged);
         this.SetCurrentNum(0);
      }
      
      protected function SetCurrentNum(param1:int) : void
      {
         this.FCurrentNum = param1;
         this.FCurrentNum = this.FCurrentNum < 0 ? 0 : this.FCurrentNum;
         this.FCurrentNum = this.FCurrentNum > this.FMax_Num ? int(this.FMax_Num) : this.FCurrentNum;
         this.FTF_Num.text = this.FCurrentNum.toString();
         if(this.FFunOnChangeInputNumShowString != null)
         {
            FTextField.text = this.FFunOnChangeInputNumShowString(this.FCurrentNum);
         }
      }
      
      protected function ButtonOKOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(FOnOK != null)
         {
            FOnOK(this,this.FCurrentNum);
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
      
      protected function MaxNumBtnClicked(param1:MouseEvent) : void
      {
         this.SetCurrentNum(this.FMax_Num);
      }
      
      protected function AddBtnClicked(param1:MouseEvent) : void
      {
         this.SetCurrentNum(++this.FCurrentNum);
      }
      
      protected function SubBtnClicked(param1:MouseEvent) : void
      {
         this.SetCurrentNum(--this.FCurrentNum);
      }
      
      protected function InputNumChanged(param1:Event) : void
      {
         this.SetCurrentNum(parseInt(this.FTF_Num.text));
      }
      
      override protected function NCButtonCloseOnClick(param1:Object) : void
      {
         if(FOnCancel != null)
         {
            FOnCancel(this);
         }
         Visible = false;
         this.SetCurrentNum(0);
      }
      
      public function set Max_Num(param1:uint) : void
      {
         this.FMax_Num = param1;
      }
      
      override public function get WindowWidth() : int
      {
         return SIZE_Window_Width;
      }
      
      override public function get WindowHeight() : int
      {
         return SIZE_Window_Height;
      }
      
      public function set FunOnChangeInputNumShowString(param1:Function) : void
      {
         this.FFunOnChangeInputNumShowString = param1;
         this.SetCurrentNum(0);
      }
   }
}

