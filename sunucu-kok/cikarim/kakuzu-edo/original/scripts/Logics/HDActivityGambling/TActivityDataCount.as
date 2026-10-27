package Logics.HDActivityGambling
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityDataCount extends TActivityEntity
   {
      
      protected var FGetType:uint;
      
      protected var FLimit:uint;
      
      protected var FCost:uint;
      
      protected var FUsedCount:uint;
      
      protected var FCount:uint;
      
      public function TActivityDataCount(param1:uint)
      {
         super(param1);
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
      
      public function get Cost() : uint
      {
         return this.FCost;
      }
      
      public function set Cost(param1:uint) : void
      {
         this.FCost = param1;
      }
      
      public function get UsedCount() : uint
      {
         return this.FUsedCount;
      }
      
      public function set UsedCount(param1:uint) : void
      {
         this.FUsedCount = param1;
      }
      
      public function get Count() : uint
      {
         return this.FLimit - this.FUsedCount;
      }
   }
}

