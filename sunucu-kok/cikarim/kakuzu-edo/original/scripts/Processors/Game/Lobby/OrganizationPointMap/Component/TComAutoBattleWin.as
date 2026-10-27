package Processors.Game.Lobby.OrganizationPointMap.Component
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TComAutoBattleWin extends TUIComponent
   {
      
      protected const Default_Count:uint = 1;
      
      protected var FMainUI:MovieClip;
      
      protected var FBtn_Max:TUIButton;
      
      protected var FBtn_Battle:TUIButton;
      
      protected var FTF_CountInput:TextField;
      
      protected var FMaxCount:uint;
      
      protected var FOnAutoBattle:Function;
      
      protected var FOnClickCloseCall:Function;
      
      public function TComAutoBattleWin(param1:TUIComponent)
      {
         super(param1);
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         this.FMainUI = param1;
         this.FMainUI.Btn_Close.addEventListener(MouseEvent.CLICK,this.OnCloseBtnClickCall);
         this.FBtn_Max = new TUIButton();
         this.FBtn_Max.OnClick = this.OnMaxBtnClickCall;
         this.FBtn_Max.Substrate = this.FMainUI["Btn_Max"];
         this.FBtn_Battle = new TUIButton();
         this.FBtn_Battle.OnClick = this.OnBattleBtnCliakCall;
         this.FBtn_Battle.Substrate = this.FMainUI["Btn_Battle"];
         this.FTF_CountInput = this.FMainUI["TF_CountInput"];
         this.FTF_CountInput.restrict = "0-9";
         this.FTF_CountInput.addEventListener(Event.CHANGE,this.OnInput);
         addChild(this.FMainUI);
      }
      
      protected function OnCloseBtnClickCall(param1:MouseEvent) : void
      {
         if(this.FOnClickCloseCall != null)
         {
            this.FOnClickCloseCall();
         }
      }
      
      protected function OnMaxBtnClickCall(param1:Object, param2:MouseEvent) : void
      {
         this.FTF_CountInput.text = this.FMaxCount.toString();
      }
      
      protected function OnBattleBtnCliakCall(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnAutoBattle != null)
         {
            this.FOnAutoBattle(int(this.FTF_CountInput.text));
         }
      }
      
      protected function OnInput(param1:Event) : void
      {
         var _loc2_:int = 0;
         _loc2_ = Math.max(int(this.FTF_CountInput.text),0);
         this.FTF_CountInput.text = Math.min(_loc2_,this.FMaxCount).toString();
      }
      
      public function set OnAutoBattle(param1:Function) : void
      {
         this.FOnAutoBattle = param1;
      }
      
      public function set OnClickCloseCall(param1:Function) : void
      {
         this.FOnClickCloseCall = param1;
      }
      
      public function Show(param1:uint) : void
      {
         this.FMaxCount = param1;
         this.FTF_CountInput.text = Math.min(1,this.FMaxCount).toString();
         Visible = true;
      }
   }
}

