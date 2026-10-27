package Processors.Game.Lobby.Activity.HDChineseYear.Component
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Processors.Game.Lobby.TacticalDeployment.Components.TKnifeInforTip;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TKnifePop extends TKnifeInforTip
   {
      
      protected var FBT_Close:TUIButton;
      
      protected var FClose:MovieClip;
      
      protected var FOnPopColse:Function;
      
      public function TKnifePop(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UIDispatch_Perform() : void
      {
         super.UIDispatch_Perform();
         this.FClose = TUtilityReflection.CreateDisplayObjectInstance("Btn_Close") as MovieClip;
         FMainUI.addChild(this.FClose);
         this.FClose.x = FMainUI.width - this.FClose.width - 3;
         this.FClose.y = 3;
         this.FBT_Close = new TUIButton();
         this.FBT_Close.Substrate = this.FClose;
         this.FBT_Close.OnClick = this.CloseOnClick;
      }
      
      protected function CloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnPopColse != null)
         {
            this.FOnPopColse(this);
         }
         Visible = false;
      }
      
      public function get OnPopColse() : Function
      {
         return this.FOnPopColse;
      }
      
      public function set OnPopColse(param1:Function) : void
      {
         this.FOnPopColse = param1;
      }
   }
}

