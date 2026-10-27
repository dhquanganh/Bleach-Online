package Foundation.Movements
{
   import Foundation.Common.Spaces.CommonSpace;
   import Foundation.Common.TCoordinate;
   
   use namespace CommonSpace;
   
   public class TMovementCartisian extends TMovement
   {
      
      protected var FX:Number;
      
      protected var FY:Number;
      
      public function TMovementCartisian()
      {
         super();
      }
      
      public function get X() : Number
      {
         return this.FX;
      }
      
      public function get Y() : Number
      {
         return this.FY;
      }
      
      public function FlushCoordinate(param1:TCoordinate) : void
      {
         param1.FX = this.FX;
         param1.FY = this.FY;
      }
   }
}

