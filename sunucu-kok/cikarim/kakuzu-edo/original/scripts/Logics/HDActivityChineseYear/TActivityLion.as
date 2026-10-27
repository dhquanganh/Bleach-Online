package Logics.HDActivityChineseYear
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityLion extends TActivityEntity
   {
      
      protected var FGetType:uint;
      
      protected var FCondition:uint;
      
      protected var FLimit:uint;
      
      protected var FCost:uint;
      
      protected var FAwards:Vector.<uint>;
      
      protected var FDefaultCost:uint;
      
      protected var FRate:uint;
      
      protected var FRateStr:String;
      
      protected var FStatus:int;
      
      public function TActivityLion(param1:uint)
      {
         super(param1);
      }
      
      public function get Condition() : uint
      {
         return this.FCondition;
      }
      
      public function set Condition(param1:uint) : void
      {
         this.FCondition = param1;
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
      
      public function get Awards() : Vector.<uint>
      {
         return this.FAwards;
      }
      
      public function set Awards(param1:Vector.<uint>) : void
      {
         this.FAwards = param1;
      }
      
      public function get DefaultCost() : uint
      {
         return this.FDefaultCost;
      }
      
      public function set DefaultCost(param1:uint) : void
      {
         this.FDefaultCost = param1;
      }
      
      public function get Rate() : uint
      {
         return this.FRate;
      }
      
      public function set Rate(param1:uint) : void
      {
         this.FRate = param1;
      }
      
      public function get Status() : int
      {
         return this.FStatus;
      }
      
      public function set Status(param1:int) : void
      {
         this.FStatus = param1;
      }
      
      public function get RateStr() : String
      {
         return this.FRateStr;
      }
      
      public function set RateStr(param1:String) : void
      {
         this.FRateStr = param1;
      }
      
      public function get GetType() : uint
      {
         return this.FGetType;
      }
      
      public function set GetType(param1:uint) : void
      {
         this.FGetType = param1;
      }
   }
}

