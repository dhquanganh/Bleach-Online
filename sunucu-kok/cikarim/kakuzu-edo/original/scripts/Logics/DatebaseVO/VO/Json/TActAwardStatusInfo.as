package Logics.DatebaseVO.VO.Json
{
   public class TActAwardStatusInfo
   {
      
      protected var FID:uint;
      
      protected var FIndex:int;
      
      protected var FStatus:int;
      
      protected var FCondition:Vector.<int>;
      
      protected var FStrs:Vector.<String>;
      
      public function TActAwardStatusInfo()
      {
         super();
         this.FCondition = new Vector.<int>();
         this.FStrs = new Vector.<String>();
      }
      
      public function get ID() : uint
      {
         return this.FID;
      }
      
      public function set ID(param1:uint) : void
      {
         this.FID = param1;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
      
      public function get Status() : int
      {
         return this.FStatus;
      }
      
      public function set Status(param1:int) : void
      {
         this.FStatus = param1;
      }
      
      public function get Condition() : Vector.<int>
      {
         return this.FCondition;
      }
      
      public function set Condition(param1:Vector.<int>) : void
      {
         this.FCondition = param1;
      }
      
      public function get Strs() : Vector.<String>
      {
         return this.FStrs;
      }
      
      public function set Strs(param1:Vector.<String>) : void
      {
         this.FStrs = param1;
      }
   }
}

