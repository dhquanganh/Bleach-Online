package Logics.HyperStrings.Atoms
{
   import Components.Standard.TUIImage;
   import Foundation.Common.TCoordinate;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.UI.TUIComponent;
   
   public class THyperStringAtomGraphical extends THyperStringAtom
   {
      
      protected var FUIImage:TUIImage;
      
      protected var FPivot:TCoordinate;
      
      public function THyperStringAtomGraphical(param1:TUIComponent)
      {
         super(param1);
         this.FUIImage = new TUIImage(this);
         this.FPivot = new TCoordinate();
      }
      
      public function get Pivot() : TCoordinate
      {
         return this.FPivot;
      }
      
      public function get Sequence() : TAnimationSequence
      {
         return this.FUIImage.Sequence;
      }
      
      public function set Sequence(param1:TAnimationSequence) : void
      {
         this.FUIImage.Sequence = param1;
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FPivot.Reset();
         this.FUIImage.Sequence = null;
      }
      
      public function RenderingPerformByTick(param1:int) : void
      {
         this.FUIImage.RenderingPerformByTick(param1);
      }
   }
}

