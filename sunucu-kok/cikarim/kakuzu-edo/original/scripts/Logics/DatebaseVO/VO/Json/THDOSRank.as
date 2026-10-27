package Logics.DatebaseVO.VO.Json
{
   public class THDOSRank
   {
      
      protected var FHighID:uint;
      
      protected var FLowID:uint;
      
      protected var FRank:uint;
      
      protected var FLevel:uint;
      
      protected var FPower:uint;
      
      protected var FName:String;
      
      protected var FFamily:uint;
      
      protected var FDamage:uint;
      
      protected var FParameter:int;
      
      public function THDOSRank()
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
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function set Level(param1:uint) : void
      {
         this.FLevel = param1;
      }
      
      public function get Power() : uint
      {
         return this.FPower;
      }
      
      public function set Power(param1:uint) : void
      {
         this.FPower = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get HighID() : uint
      {
         return this.FHighID;
      }
      
      public function set HighID(param1:uint) : void
      {
         this.FHighID = param1;
      }
      
      public function get LowID() : uint
      {
         return this.FLowID;
      }
      
      public function set LowID(param1:uint) : void
      {
         this.FLowID = param1;
      }
      
      public function get Family() : uint
      {
         return this.FFamily;
      }
      
      public function set Family(param1:uint) : void
      {
         this.FFamily = param1;
      }
      
      public function get Damage() : uint
      {
         return this.FDamage;
      }
      
      public function set Damage(param1:uint) : void
      {
         this.FDamage = param1;
      }
      
      public function get Parameter() : int
      {
         return this.FParameter;
      }
      
      public function set Parameter(param1:int) : void
      {
         this.FParameter = param1;
      }
   }
}

