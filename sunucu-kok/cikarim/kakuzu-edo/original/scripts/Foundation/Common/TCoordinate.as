package Foundation.Common
{
   import Foundation.Common.Spaces.CommonSpace;
   import flash.geom.Point;
   
   use namespace CommonSpace;
   
   public class TCoordinate
   {
      
      CommonSpace var FX:int;
      
      CommonSpace var FY:int;
      
      public function TCoordinate()
      {
         super();
         this.FX = 0;
         this.FY = 0;
      }
      
      public function get X() : int
      {
         return this.FX;
      }
      
      public function get Y() : int
      {
         return this.FY;
      }
      
      public function set X(param1:int) : void
      {
         this.FX = param1;
      }
      
      public function set Y(param1:int) : void
      {
         this.FY = param1;
      }
      
      public function Reset() : void
      {
         this.FX = 0;
         this.FY = 0;
      }
      
      public function Assign(param1:TCoordinate) : void
      {
         this.FX = param1.FX;
         this.FY = param1.FY;
      }
      
      public function FlushPoint(param1:Point) : void
      {
         param1.x = this.FX;
         param1.y = this.FY;
      }
   }
}

