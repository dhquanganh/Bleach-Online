package Processors.Game.Lobby.HeroCompanion.Components
{
   import Components.Standard.TUIButton;
   import Foundation.Utilities.TUtilityString;
   import Logics.HeroCompanion.THeroCompanionCardData;
   import Logics.HeroCompanion.THeroCompanionSeatData;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TCompanionSeatItem extends TCompanionCardItem
   {
      
      protected var FSeatMainUI:Sprite;
      
      protected var FSeatData:THeroCompanionSeatData;
      
      protected var FBtnDisMount:TUIButton;
      
      protected var FTFLock:TextField;
      
      protected var FLock:Sprite;
      
      protected var FSeatOnOver:Function;
      
      protected var FSeatOnOut:Function;
      
      protected var FOnDismount:Function;
      
      protected var FUIIndex:int;
      
      public function TCompanionSeatItem(param1:Sprite)
      {
         this.FSeatMainUI = param1;
         super(this.FSeatMainUI["MC_Card"]);
         this.FBtnDisMount = new TUIButton();
         this.FBtnDisMount.Substrate = this.FSeatMainUI["Btn_Dismount"];
         this.FBtnDisMount.OnOver = this.DisMountOnOver;
         this.FBtnDisMount.OnOut = this.DisMountOnOut;
         this.FBtnDisMount.OnClick = this.DisMountOnClick;
         this.FLock = this.FSeatMainUI["MC_Lock"];
         this.FLock.mouseChildren = false;
         this.FLock.mouseEnabled = false;
         this.FTFLock = this.FLock["TF_Lock"];
         this.FSeatMainUI.addEventListener(MouseEvent.MOUSE_OVER,this.OnSeatOver);
         this.FSeatMainUI.addEventListener(MouseEvent.MOUSE_OUT,this.OnSeatOut);
      }
      
      protected function OnSeatOver(param1:MouseEvent) : void
      {
         this.FSeatOnOver(this.FUIIndex);
      }
      
      protected function OnSeatOut(param1:MouseEvent) : void
      {
         this.FSeatOnOut();
      }
      
      private function DisMountOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnDismount != null)
         {
            this.FOnDismount(FData.Identifier,this.FSeatData.Seat);
         }
      }
      
      private function DisMountOnOver(param1:Object, param2:MouseEvent) : void
      {
         this.OnOver(param2);
      }
      
      private function DisMountOnOut(param1:Object, param2:MouseEvent) : void
      {
         this.OnOut(param2);
      }
      
      override protected function OnOver(param1:MouseEvent) : void
      {
         super.OnOver(param1);
         this.FBtnDisMount.Visible = true;
      }
      
      override protected function OnOut(param1:MouseEvent) : void
      {
         super.OnOut(param1);
         this.FBtnDisMount.Visible = false;
      }
      
      public function get IsLock() : Boolean
      {
         return this.FSeatData.IsLocked;
      }
      
      public function get SeatOnOver() : Function
      {
         return this.FSeatOnOver;
      }
      
      public function set SeatOnOver(param1:Function) : void
      {
         this.FSeatOnOver = param1;
      }
      
      public function get UIIndex() : int
      {
         return this.FUIIndex;
      }
      
      public function set UIIndex(param1:int) : void
      {
         this.FUIIndex = param1;
      }
      
      public function get SeatOnOut() : Function
      {
         return this.FSeatOnOut;
      }
      
      public function set SeatOnOut(param1:Function) : void
      {
         this.FSeatOnOut = param1;
      }
      
      public function get OnDismount() : Function
      {
         return this.FOnDismount;
      }
      
      public function set OnDismount(param1:Function) : void
      {
         this.FOnDismount = param1;
      }
      
      public function SetSeatData(param1:THeroCompanionSeatData, param2:THeroCompanionCardData = null) : void
      {
         this.FSeatData = param1;
         super.ClearData();
         this.FBtnDisMount.Visible = false;
         if(param2 != null)
         {
            SetData(param2.GetCurCard());
         }
         if(this.FSeatData.NeedFever > 0)
         {
            this.FTFLock.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_09),this.FSeatData.NeedFever);
            this.FLock.visible = true;
         }
         else if(this.FSeatData.NeedVip > 0)
         {
            this.FTFLock.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_10),this.FSeatData.NeedVip);
            this.FLock.visible = true;
         }
         else
         {
            this.FLock.visible = false;
         }
      }
      
      override public function ClearData() : void
      {
         super.ClearData();
         this.FBtnDisMount.Visible = false;
         this.FTFLock.text = "";
      }
   }
}

