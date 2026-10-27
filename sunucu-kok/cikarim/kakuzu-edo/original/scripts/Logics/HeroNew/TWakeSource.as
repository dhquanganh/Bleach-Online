package Logics.HeroNew
{
   public class TWakeSource
   {
      
      protected var FCityId:int;
      
      protected var FPointId:int;
      
      public function TWakeSource(param1:Object)
      {
         super();
         this.FCityId = param1.cityID;
         this.FPointId = param1.pointID;
      }
      
      public function get CityId() : int
      {
         return this.FCityId;
      }
      
      public function set CityId(param1:int) : void
      {
         this.FCityId = param1;
      }
      
      public function get PointId() : int
      {
         return this.FPointId;
      }
      
      public function set PointId(param1:int) : void
      {
         this.FPointId = param1;
      }
   }
}

