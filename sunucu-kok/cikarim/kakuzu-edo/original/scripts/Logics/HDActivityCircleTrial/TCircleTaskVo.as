package Logics.HDActivityCircleTrial
{
   public class TCircleTaskVo
   {
      
      private var FTaskFinishState:int;
      
      private var FTaskDescribeStr:String;
      
      private var FCurrentTimes:int;
      
      private var FTotalTimes:int;
      
      private var FAwardDescribeStr:String;
      
      private var FGotoModuleId:int;
      
      public function TCircleTaskVo()
      {
         super();
      }
      
      public function get TaskFinishState() : int
      {
         return this.FTaskFinishState;
      }
      
      public function set TaskFinishState(param1:int) : void
      {
         this.FTaskFinishState = param1;
      }
      
      public function get CurrentTimes() : int
      {
         return this.FCurrentTimes;
      }
      
      public function set CurrentTimes(param1:int) : void
      {
         this.FCurrentTimes = param1;
      }
      
      public function get TotalTimes() : int
      {
         return this.FTotalTimes;
      }
      
      public function set TotalTimes(param1:int) : void
      {
         this.FTotalTimes = param1;
      }
      
      public function get GotoModuleId() : int
      {
         return this.FGotoModuleId;
      }
      
      public function set GotoModuleId(param1:int) : void
      {
         this.FGotoModuleId = param1;
      }
      
      public function get TaskDescribeStr() : String
      {
         return this.FTaskDescribeStr;
      }
      
      public function set TaskDescribeStr(param1:String) : void
      {
         this.FTaskDescribeStr = param1;
      }
      
      public function get AwardDescribeStr() : String
      {
         return this.FAwardDescribeStr;
      }
      
      public function set AwardDescribeStr(param1:String) : void
      {
         this.FAwardDescribeStr = param1;
      }
   }
}

