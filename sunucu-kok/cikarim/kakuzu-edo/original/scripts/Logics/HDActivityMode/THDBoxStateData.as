package Logics.HDActivityMode
{
   public class THDBoxStateData
   {
      
      protected var FActivityID:uint;
      
      protected var FBoxIndex:uint;
      
      protected var FTypeAcquire:uint;
      
      protected var FConditions:Vector.<int>;
      
      protected var FState:int;
      
      public function THDBoxStateData()
      {
         super();
         this.FConditions = new Vector.<int>();
      }
      
      public function get ActivityID() : uint
      {
         return this.FActivityID;
      }
      
      public function set ActivityID(param1:uint) : void
      {
         this.FActivityID = param1;
      }
      
      public function get BoxIndex() : uint
      {
         return this.FBoxIndex;
      }
      
      public function set BoxIndex(param1:uint) : void
      {
         this.FBoxIndex = param1;
      }
      
      public function get TypeAcquire() : uint
      {
         return this.FTypeAcquire;
      }
      
      public function set TypeAcquire(param1:uint) : void
      {
         this.FTypeAcquire = param1;
      }
      
      public function get Conditions() : Vector.<int>
      {
         return this.FConditions;
      }
      
      public function set Conditions(param1:Vector.<int>) : void
      {
         this.FConditions = param1;
      }
      
      public function get State() : int
      {
         return this.FState;
      }
      
      public function set State(param1:int) : void
      {
         this.FState = param1;
      }
   }
}

