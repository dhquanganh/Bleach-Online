package Logics.HDServerPay
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivitySPHero extends TActivityEntity
   {
      
      protected var FGetType:uint;
      
      protected var FLimit:uint;
      
      protected var FCondition:uint;
      
      protected var FAwardType:uint;
      
      protected var FAwardID:uint;
      
      protected var FStatus:int;
      
      protected var FReportAddr:String;
      
      public function TActivitySPHero(param1:uint)
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
      
      public function get Condition() : uint
      {
         return this.FCondition;
      }
      
      public function set Condition(param1:uint) : void
      {
         this.FCondition = param1;
      }
      
      public function get AwardType() : uint
      {
         return this.FAwardType;
      }
      
      public function set AwardType(param1:uint) : void
      {
         this.FAwardType = param1;
      }
      
      public function get AwardID() : uint
      {
         return this.FAwardID;
      }
      
      public function set AwardID(param1:uint) : void
      {
         this.FAwardID = param1;
      }
      
      public function get Status() : int
      {
         return this.FStatus;
      }
      
      public function set Status(param1:int) : void
      {
         this.FStatus = param1;
      }
      
      public function get ReportAddr() : String
      {
         return this.FReportAddr;
      }
      
      public function set ReportAddr(param1:String) : void
      {
         this.FReportAddr = param1;
      }
   }
}

