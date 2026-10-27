package Processors.Game.Lobby.HeroCompanion
{
   import Foundation.UI.TUIComponent;
   import Logics.HeroCompanion.THeroCompanionData;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import flash.display.Sprite;
   
   public class TCompanionBaseView extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:Sprite;
      
      protected var FData:THeroCompanionData;
      
      protected var FTipOnOver:Function;
      
      protected var FTipOnOut:Function;
      
      protected var FIsDataInit:Boolean;
      
      public var NeedRefresh:Boolean;
      
      public function TCompanionBaseView(param1:TUIComponent)
      {
         super(param1);
      }
      
      override public function get Visible() : Boolean
      {
         return super.Visible;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         if(this.FMainUI != null)
         {
            this.FMainUI.visible = param1;
         }
         super.Visible = param1;
      }
      
      public function get TipOnOver() : Function
      {
         return this.FTipOnOver;
      }
      
      public function set TipOnOver(param1:Function) : void
      {
         this.FTipOnOver = param1;
      }
      
      public function get TipOnOut() : Function
      {
         return this.FTipOnOut;
      }
      
      public function set TipOnOut(param1:Function) : void
      {
         this.FTipOnOut = param1;
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         this.FMainUI = param1;
      }
      
      public function SetData(param1:THeroCompanionData) : void
      {
         this.FData = param1;
         this.NeedRefresh = false;
      }
   }
}

