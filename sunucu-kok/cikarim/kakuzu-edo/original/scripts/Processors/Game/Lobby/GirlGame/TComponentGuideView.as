package Processors.Game.Lobby.GirlGame
{
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class TComponentGuideView extends TUIComponent
   {
      
      protected var FGameGuide:Sprite;
      
      protected var FBtnGameGuide:MovieClip;
      
      protected var FOnUserTapKey:Function;
      
      public function TComponentGuideView(param1:TUIComponent)
      {
         super(param1);
      }
      
      public function UIDispatch() : void
      {
         this.FGameGuide = TUtilityReflection.CreateDisplayObjectInstance("GuideView") as Sprite;
         addChild(this.FGameGuide);
         this.FBtnGameGuide = this.FGameGuide["BlankSpace"];
      }
      
      public function UILocation() : void
      {
      }
      
      protected function EndGuide() : void
      {
         this.UnlistenKeyBoardEvent();
         this.FBtnGameGuide.stop();
      }
      
      protected function ListenKeyBoardEvent() : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.CallBack_KeyDown);
      }
      
      protected function UnlistenKeyBoardEvent() : void
      {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.CallBack_KeyDown);
      }
      
      protected function CallBack_KeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.SPACE)
         {
            this.EndGuide();
            if(this.FOnUserTapKey != null)
            {
               this.FOnUserTapKey(this);
            }
         }
      }
      
      public function set OnUserTapKey(param1:Function) : void
      {
         this.FOnUserTapKey = param1;
      }
      
      public function LoadResources() : void
      {
         this.UIDispatch();
         this.UILocation();
      }
      
      public function StartGuide() : void
      {
         this.ListenKeyBoardEvent();
         this.FBtnGameGuide.play();
      }
      
      public function Reset() : void
      {
         this.FBtnGameGuide.stop();
      }
   }
}

