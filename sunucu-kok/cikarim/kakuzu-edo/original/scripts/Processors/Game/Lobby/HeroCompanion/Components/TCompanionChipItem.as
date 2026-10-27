package Processors.Game.Lobby.HeroCompanion.Components
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Logics.HeroCompanion.THeroCompanionChipData;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TCompanionChipItem extends TCompanionBaseItem
   {
      
      protected var FMountPoint:Bitmap;
      
      protected var FTFCount:TextField;
      
      protected var FChipData:THeroCompanionChipData;
      
      protected var FAnimationSequence:TAnimationSequence;
      
      public function TCompanionChipItem(param1:Sprite)
      {
         super(param1);
         this.FMountPoint = new Bitmap();
         FMainUI["MC_MountPoint"].addChild(this.FMountPoint);
         this.FTFCount = FMainUI["TF_Count"];
      }
      
      private function PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         this.FMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         this.FAnimationSequence = param2.GetAnimationSequenceByIndex(0);
      }
      
      public function get Data() : THeroCompanionChipData
      {
         return this.FChipData;
      }
      
      public function get AnimationSequence() : TAnimationSequence
      {
         return this.FAnimationSequence;
      }
      
      public function SetChipData(param1:THeroCompanionChipData) : void
      {
         this.FChipData = param1;
         SResourcesCore.TexturesInventory.LoadAutoSecondary(param1.ChipData.Picture,this.PicArrive);
         this.FTFCount.text = param1.Amount + "";
         this.Visible = true;
      }
      
      public function ClearData() : void
      {
         this.FTFCount.text = "";
         this.FMountPoint.bitmapData = null;
         this.Visible = false;
      }
   }
}

