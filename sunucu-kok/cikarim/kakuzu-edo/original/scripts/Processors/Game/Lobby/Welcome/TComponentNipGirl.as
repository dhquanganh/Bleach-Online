package Processors.Game.Lobby.Welcome
{
   import Foundation.UI.TUIComponent;
   import flash.display.Bitmap;
   
   public class TComponentNipGirl extends TUIComponent
   {
      
      protected static const OrganMaxSize:int = 3;
      
      protected var FOrganID:Vector.<uint>;
      
      protected var FBody:Bitmap;
      
      protected var FOrganPic:Vector.<Bitmap>;
      
      public function TComponentNipGirl(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Bitmap = null;
         this.FBody = new Bitmap();
         addChild(this.FBody);
         _loc1_ = 0;
         while(_loc1_ < OrganMaxSize)
         {
            _loc2_ = new Bitmap();
            this.FOrganPic.push(_loc2_);
            _loc1_++;
         }
      }
      
      protected function UILocation() : void
      {
      }
      
      public function Reset() : void
      {
      }
      
      public function ReplaceOrgan(param1:uint) : void
      {
         this.FOrganID.push(this.FOrganID);
      }
      
      public function LoadResource() : void
      {
         this.UIDispatch();
         this.UILocation();
      }
   }
}

