package Logics.Map
{
   import Foundation.Common.TBounds;
   
   public class TMapParameter
   {
      
      protected var FMapData:TMapData;
      
      protected var FScreenBounds:TBounds;
      
      public function TMapParameter()
      {
         super();
      }
      
      public function get MapData() : TMapData
      {
         return this.FMapData;
      }
      
      public function set MapData(param1:TMapData) : void
      {
         this.FMapData = param1;
      }
      
      public function get ScreenBounds() : TBounds
      {
         return this.FScreenBounds;
      }
      
      public function set ScreenBounds(param1:TBounds) : void
      {
         this.FScreenBounds = param1;
      }
   }
}

