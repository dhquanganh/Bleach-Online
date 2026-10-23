package Logics.Streamization.DailyTask
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.Dailytask.TDailytask;
   import Logics.Dailytask.TQuestDaily;
   import Logics.Dailytask.TTargetTaskList;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerDailyTasks extends TUnstreamizer
   {
      
      protected var FUnstreamizerTask:TUnstreamizerTask;
      
      protected var FUnstreamizerTargetTask:TUnstreamizerTargetTask;
      
      public function TUnstreamizerDailyTasks()
      {
         super();
         this.FUnstreamizerTask = new TUnstreamizerTask();
         this.FUnstreamizerTargetTask = new TUnstreamizerTargetTask();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TDailytask = null;
         _loc4_ = param2 as TDailytask;
         _loc4_.FreshCount = param1.readShort();
         _loc4_.IsDouble = param1.readByte();
         _loc4_.Point = param1.readShort();
         _loc4_.IsAward = param1.readShort();
         _loc4_.CurrentID = param1.readUnsignedInt();
         _loc4_.CurrentProgress = param1.readByte();
         _loc4_.FinishCount = param1.readByte();
         this.UnstreamizationTask(param1,_loc4_,param3);
         this.UnstreamizationTargetTask(param1,_loc4_,param3);
      }
      
      public function UnstreamizationTask(param1:ByteArray, param2:TDailytask, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TQuestDaily = null;
         param2.ClearTaskList();
         _loc5_ = param1.readUnsignedShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = new TQuestDaily(0);
            this.FUnstreamizerTask.Unstreamize(param1,_loc6_,param3);
            param2.TaskListAdd(_loc6_);
            _loc4_++;
         }
      }
      
      public function UnstreamizationTargetTask(param1:ByteArray, param2:TDailytask, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TTargetTaskList = null;
         param2.ClearTargetTaskList();
         _loc5_ = param1.readUnsignedShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = new TTargetTaskList();
            this.FUnstreamizerTargetTask.Unstreamize(param1,_loc6_,param3);
            param2.TargetTaskListAdd(_loc6_);
            _loc4_++;
         }
      }
   }
}

