package Processors.Game.Lobby.RelatedPartner.RelatedAssistance
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Logics.Characters.THero;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class THeadAssistance
   {
      
      protected var FMainUI:Sprite;
      
      protected var FMountPoint:Bitmap;
      
      protected var FLight:Sprite;
      
      protected var FHero:THero;
      
      protected var FOnOver:Function;
      
      protected var FOnOut:Function;
      
      protected var FOnClick:Function;
      
      public function THeadAssistance(param1:Sprite)
      {
         super();
         this.FMainUI = param1;
         this.FMainUI.mouseChildren = false;
         this.FMountPoint = new Bitmap();
         this.FMainUI["MC_Pos"].addChild(this.FMountPoint);
         this.FLight = this.FMainUI["MC_Light"];
         this.FLight.visible = false;
         this.FMainUI.addEventListener(MouseEvent.MOUSE_MOVE,this.HeadOnOver);
         this.FMainUI.addEventListener(MouseEvent.MOUSE_OUT,this.HeadOnOut);
         this.FMainUI.addEventListener(MouseEvent.CLICK,this.HeadOnClick);
      }
      
      protected function PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         this.FMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function HeadOnOver(param1:MouseEvent) : void
      {
         if(this.FHero == null)
         {
            return;
         }
         this.FLight.visible = true;
         this.FOnOver(this,this.FHero);
      }
      
      protected function HeadOnOut(param1:MouseEvent) : void
      {
         if(this.FHero == null)
         {
            return;
         }
         this.FLight.visible = false;
         this.FOnOut(this);
      }
      
      protected function HeadOnClick(param1:MouseEvent) : void
      {
         if(this.FHero == null)
         {
            return;
         }
         this.FOnClick(this.FHero.Identifier);
      }
      
      public function get OnOver() : Function
      {
         return this.FOnOver;
      }
      
      public function set OnOver(param1:Function) : void
      {
         this.FOnOver = param1;
      }
      
      public function get OnOut() : Function
      {
         return this.FOnOut;
      }
      
      public function set OnOut(param1:Function) : void
      {
         this.FOnOut = param1;
      }
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function Render(param1:THero = null) : void
      {
         this.FHero = param1;
         if(this.FHero != null)
         {
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(this.FHero.SmallID,this.PicArrive);
         }
         else
         {
            this.FMountPoint.bitmapData = null;
         }
      }
   }
}

