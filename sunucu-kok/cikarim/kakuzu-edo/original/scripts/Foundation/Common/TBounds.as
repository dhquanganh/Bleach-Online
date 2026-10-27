package Foundation.Common
{
   import Foundation.Common.Spaces.CommonSpace;
   import flash.geom.Rectangle;
   
   use namespace CommonSpace;
   
   public class TBounds extends TCoordinate
   {
      
      CommonSpace var FWidth:int;
      
      CommonSpace var FHeight:int;
      
      public function TBounds()
      {
         super();
         this.FWidth = 0;
         this.FHeight = 0;
      }
      
      public function get Width() : int
      {
         return this.FWidth;
      }
      
      public function get Height() : int
      {
         return this.FHeight;
      }
      
      public function set Width(param1:int) : void
      {
         this.FWidth = param1;
      }
      
      public function set Height(param1:int) : void
      {
         this.FHeight = param1;
      }
      
      public function get XEnd() : int
      {
         return FX + this.FWidth;
      }
      
      public function get YEnd() : int
      {
         return FY + this.FHeight;
      }
      
      override public function Reset() : void
      {
         FX = 0;
         FY = 0;
         this.FWidth = 0;
         this.FHeight = 0;
      }
      
      override public function Assign(param1:TCoordinate) : void
      {
         var _loc2_:TBounds = null;
         super.Assign(param1);
         if(param1 is TBounds)
         {
            _loc2_ = param1 as TBounds;
            this.FWidth = _loc2_.FWidth;
            this.FHeight = _loc2_.FHeight;
         }
      }
      
      public function FlushRectangle(param1:Rectangle) : void
      {
         param1.x = FX;
         param1.y = FY;
         param1.width = this.FWidth;
         param1.height = this.FHeight;
      }
   }
}

