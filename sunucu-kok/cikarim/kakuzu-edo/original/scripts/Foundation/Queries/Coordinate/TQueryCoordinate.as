package Foundation.Queries.Coordinate
{
   import Foundation.Common.TCoordinate;
   import Foundation.Queries.TQueryUnknown;
   
   public class TQueryCoordinate extends TQueryUnknown
   {
      
      protected var FValue:TCoordinate;
      
      public function TQueryCoordinate()
      {
         super();
         this.FValue = new TCoordinate();
      }
      
      public function get Value() : TCoordinate
      {
         return this.FValue;
      }
      
      public function set Value(param1:TCoordinate) : void
      {
         this.FValue = param1;
      }
   }
}

