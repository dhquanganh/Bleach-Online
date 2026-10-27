package Logics.HDServerPay
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivitySPExchangeShop extends TActivityEntity
   {
      
      protected var FGetType:uint;
      
      protected var FLimit:uint;
      
      protected var FCondition:uint;
      
      protected var FAwards:Vector.<uint>;
      
      protected var FName:uint;
      
      protected var FStatus:int;
      
      public function TActivitySPExchangeShop(param1:uint)
      {
         super(param1);
         this.FAwards = new Vector.<uint>();
      }
      
      public function get GetType() : uint
      {
         return this.FGetType;
      }
      
      public function set GetType(param1:uint) : void
      {
         this.FGetType = param1;
      }
      
      public function get Limit() : uint
      {
         return this.FLimit;
      }
      
      public function set Limit(param1:uint) : void
      {
         this.FLimit = param1;
      }
      
      public function get Condition() : uint
      {
         return this.FCondition;
      }
      
      public function set Condition(param1:uint) : void
      {
         this.FCondition = param1;
      }
      
      public function get Awards() : Vector.<uint>
      {
         return this.FAwards;
      }
      
      public function set Awards(param1:Vector.<uint>) : void
      {
         this.FAwards = param1;
      }
      
      public function get Name() : uint
      {
         return this.FName;
      }
      
      public function set Name(param1:uint) : void
      {
         this.FName = param1;
      }
      
      public function get Status() : int
      {
         return this.FStatus;
      }
      
      public function set Status(param1:int) : void
      {
         this.FStatus = param1;
      }
   }
}

