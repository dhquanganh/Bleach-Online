package Logics.HDActivityOS
{
   public class TActivityOSBase
   {
      
      protected var FActivityID:uint;
      
      protected var FTypeAcquire:uint;
      
      protected var FBoxStatus:Vector.<int>;
      
      protected var FConditions:Vector.<uint>;
      
      public function TActivityOSBase()
      {
         super();
      }
      
      public function get BoxStatus() : Vector.<int>
      {
         return this.FBoxStatus;
      }
      
      public function set BoxStatus(param1:Vector.<int>) : void
      {
         this.FBoxStatus = param1;
      }
      
      public function get Conditions() : Vector.<uint>
      {
         return this.FConditions;
      }
      
      public function set Conditions(param1:Vector.<uint>) : void
      {
         this.FConditions = param1;
      }
      
      public function get TypeAcquire() : uint
      {
         return this.FTypeAcquire;
      }
      
      public function set TypeAcquire(param1:uint) : void
      {
         this.FTypeAcquire = param1;
      }
      
      public function get ActivityID() : uint
      {
         return this.FActivityID;
      }
      
      public function set ActivityID(param1:uint) : void
      {
         this.FActivityID = param1;
      }
   }
}

