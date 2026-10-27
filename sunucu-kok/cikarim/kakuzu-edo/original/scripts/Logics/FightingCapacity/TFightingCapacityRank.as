package Logics.FightingCapacity
{
   public class TFightingCapacityRank
   {
      
      protected var FRank:uint;
      
      protected var FFamily:uint;
      
      protected var FfName:String;
      
      protected var FLevel:uint;
      
      protected var FFightingCapacity:uint;
      
      public function TFightingCapacityRank()
      {
         super();
      }
      
      public function get Rank() : uint
      {
         return this.FRank;
      }
      
      public function set Rank(param1:uint) : void
      {
         this.FRank = param1;
      }
      
      public function get Family() : uint
      {
         return this.FFamily;
      }
      
      public function set Family(param1:uint) : void
      {
         this.FFamily = param1;
      }
      
      public function get Name() : String
      {
         return this.FfName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FfName = param1;
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function set Level(param1:uint) : void
      {
         this.FLevel = param1;
      }
      
      public function get FightingCapacity() : uint
      {
         return this.FFightingCapacity;
      }
      
      public function set FightingCapacity(param1:uint) : void
      {
         this.FFightingCapacity = param1;
      }
   }
}

