package Processors.Game.Lobby.RelatedPartner.PartnerTrain
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Resources.Constants.CONST_COMMON;
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class TWindowTrainBase extends TUIComponent
   {
      
      protected var FMainUI:Sprite;
      
      protected var FBtnClose:TUIButton;
      
      protected var FPos:Point;
      
      protected var FOnClose:Function;
      
      public function TWindowTrainBase(param1:TUIComponent, param2:Sprite)
      {
         this.FMainUI = param2;
         super(param1);
         this.WindowInit();
      }
      
      protected function WindowInit() : void
      {
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtnClose.OnClick = this.WindowOnClose;
         this.FPos = new Point();
      }
      
      protected function WindowOnClose(param1:Object, param2:MouseEvent) : void
      {
         this.Visible = false;
         if(this.FOnClose != null)
         {
            this.FOnClose(this);
         }
      }
      
      override public function get Visible() : Boolean
      {
         return this.FMainUI.visible;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         this.FMainUI.visible = param1;
      }
      
      public function get OnClose() : Function
      {
         return this.FOnClose;
      }
      
      public function set OnClose(param1:Function) : void
      {
         this.FOnClose = param1;
      }
      
      public function SetBackground(param1:Bitmap) : void
      {
         this.FMainUI.addChildAt(param1,0);
         param1.visible = true;
         param1.x = -this.FMainUI.localToGlobal(this.FPos).x;
         param1.y = -this.FMainUI.localToGlobal(this.FPos).y;
      }
   }
}

