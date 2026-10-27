package Processors.Game.Windows.Information
{
   import Components.Standard.*;
   import Externals.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Agent.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Windows.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TUIWindowRecharge extends TUIWindow
   {
      
      protected var FBtn_Close:SimpleButton;
      
      public function TUIWindowRecharge(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ConstructComponentButtons() : void
      {
         FButtonOK = this.ConstructComponentButton(CONST_COMMON.RESOURCE_Link_Btn_Ok,CONST_COMMON.RESOURCE_Link_TF_BtnOkCaption,this.ButtonOKOnClick,FButtonOkCaption);
         this.FBtn_Close = FResource[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.ButtonCancelOnClick,false,0,true);
      }
      
      protected function ConstructComponentButton(param1:String, param2:String, param3:Function, param4:String) : TUIButton
      {
         var _loc5_:TUIButton = null;
         _loc5_ = new TUIButton();
         _loc5_.Substrate = FResource[param1];
         _loc5_.OnClick = param3;
         return _loc5_;
      }
      
      override protected function ConstruceComponentTextfield() : void
      {
         FTextField = FResource[CONST_COMMON.RESOURCE_Link_TF_Text];
         FTextField.selectable = false;
         Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GOTO_RECHARGE);
      }
      
      override protected function Reset() : void
      {
         super.Reset();
         Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GOTO_RECHARGE);
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
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
         Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GOTO_RECHARGE);
         if(FOnCancel != null)
         {
            FOnCancel(this);
         }
         this.Reset();
         Visible = false;
      }
      
      protected function ButtonCancelOnClick(param1:MouseEvent) : void
      {
         if(FOnCancel != null)
         {
            FOnCancel(this);
         }
         Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GOTO_RECHARGE);
         this.Reset();
         Visible = false;
      }
      
      public function SetGoldNum(param1:int) : void
      {
         Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GOTO_RECHARGEDETAIL),param1);
      }
   }
}

