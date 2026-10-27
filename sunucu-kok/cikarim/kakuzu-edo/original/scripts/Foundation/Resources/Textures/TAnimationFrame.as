package Foundation.Resources.Textures
{
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Resources.Spaces.ResourcesSpace;
   import flash.display.BitmapData;
   
   use namespace ResourcesSpace;
   
   public class TAnimationFrame
   {
      
      protected var FSurface:BitmapData;
      
      protected var FBounds:TBounds;
      
      protected var FPivot:TCoordinate;
      
      protected var FDuration:int;
      
      public function TAnimationFrame(param1:BitmapData)
      {
         super();
         this.FSurface = param1;
         this.FBounds = new TBounds();
         this.FPivot = new TCoordinate();
      }
      
      ResourcesSpace function CoerceProperties(param1:BitmapData = null, param2:int = -1) : void
      {
         if(param1 != null)
         {
            this.FSurface = param1;
         }
         if(param2 >= 0)
         {
            this.FDuration = param2;
         }
      }
      
      public function get Surface() : BitmapData
      {
         return this.FSurface;
      }
      
      public function get Bounds() : TBounds
      {
         return this.FBounds;
      }
      
      public function get Pivot() : TCoordinate
      {
         return this.FPivot;
      }
      
      public function get Duration() : int
      {
         return this.FDuration;
      }
      
      ResourcesSpace function Clear() : void
      {
         this.FSurface = null;
      }
      
      public function Evaluate(param1:TCoordinate, param2:TBounds) : void
      {
         param2.X = param1.X - this.FPivot.X;
         param2.Y = param1.Y - this.FPivot.Y;
         param2.Width = this.FBounds.Width;
         param2.Height = this.FBounds.Height;
      }
      
      public function GetPixelByCoordinatePivotBased(param1:TCoordinate) : uint
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = this.FPivot.X + param1.X;
         _loc3_ = this.FPivot.Y + param1.Y;
         if(_loc2_ < 0 || _loc3_ < 0 || _loc2_ >= this.FBounds.Width || _loc3_ >= this.FBounds.Height)
         {
            return 0;
         }
         _loc2_ += this.FBounds.X;
         _loc3_ += this.FBounds.Y;
         return this.FSurface.getPixel32(_loc2_,_loc3_);
      }
   }
}

