package Processors.Game.MiniBattle
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import flash.display.Bitmap;
   
   public class TComponentBackGround extends TUIComponent
   {
      
      protected var FBackGroundMountPoint:Bitmap;
      
      protected var FBackGroundID:uint;
      
      public function TComponentBackGround(param1:TUIComponent)
      {
         super(param1);
         this.FBackGroundMountPoint = new Bitmap();
         addChild(this.FBackGroundMountPoint);
      }
      
      protected function LoadResource_Perform() : void
      {
      }
      
      protected function CallBack_PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         if(this.FBackGroundID == param3)
         {
            this.FBackGroundMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      public function SetBackGround(param1:uint) : void
      {
         if(this.FBackGroundID == param1)
         {
            return;
         }
         this.FBackGroundID = param1;
         SResourcesCore.TexturesBackgroundIcon.LoadAutoSecondary(this.FBackGroundID,this.CallBack_PicArrive);
      }
      
      public function LoadResource() : void
      {
         this.LoadResource_Perform();
      }
      
      public function Reset() : void
      {
         this.FBackGroundID = 0;
         this.FBackGroundMountPoint.bitmapData = null;
      }
   }
}

