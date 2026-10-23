package Logics.Dailytask
{
   public class TDailytask
   {
      
      protected var FType:uint;
      
      protected var FPoint:uint;
      
      protected var FIsDouble:uint;
      
      protected var FFreshCount:uint;
      
      protected var FIsAward:uint;
      
      protected var FCurrentID:uint;
      
      protected var FCurrentProgress:uint;
      
      protected var FFinishCount:uint;
      
      protected var FTaskList:Vector.<TQuestDaily>;
      
      protected var FTargetTaskList:Vector.<TTargetTaskList>;
      
      public function TDailytask()
      {
         super();
         this.FTaskList = new Vector.<TQuestDaily>();
         this.FTargetTaskList = new Vector.<TTargetTaskList>();
      }
      
      public function get Type() : uint
      {
         return this.FType;
      }
      
      public function set Type(param1:uint) : void
      {
         this.FType = param1;
      }
      
      public function get Point() : uint
      {
         return this.FPoint;
      }
      
      public function set Point(param1:uint) : void
      {
         this.FPoint = param1;
      }
      
      public function get IsDouble() : uint
      {
         return this.FIsDouble;
      }
      
      public function set IsDouble(param1:uint) : void
      {
         this.FIsDouble = param1;
      }
      
      public function get FreshCount() : uint
      {
         return this.FFreshCount;
      }
      
      public function set FreshCount(param1:uint) : void
      {
         this.FFreshCount = param1;
      }
      
      public function get IsAward() : uint
      {
         return this.FIsAward;
      }
      
      public function set IsAward(param1:uint) : void
      {
         this.FIsAward = param1;
      }
      
      public function get CurrentID() : uint
      {
         return this.FCurrentID;
      }
      
      public function set CurrentID(param1:uint) : void
      {
         this.FCurrentID = param1;
      }
      
      public function get CurrentProgress() : uint
      {
         return this.FCurrentProgress;
      }
      
      public function set CurrentProgress(param1:uint) : void
      {
         this.FCurrentProgress = param1;
      }
      
      public function get FinishCount() : uint
      {
         return this.FFinishCount;
      }
      
      public function set FinishCount(param1:uint) : void
      {
         this.FFinishCount = param1;
      }
      
      public function CountForTask() : uint
      {
         return this.FTaskList.length;
      }
      
      public function CountForTargetTask() : uint
      {
         return this.FTargetTaskList.length;
      }
      
      public function TaskListAdd(param1:TQuestDaily) : void
      {
         this.FTaskList.push(param1);
      }
      
      public function TargetTaskListAdd(param1:TTargetTaskList) : void
      {
         this.FTargetTaskList.push(param1);
      }
      
      public function GetTaskByIndex(param1:uint) : TQuestDaily
      {
         return this.FTaskList[param1];
      }
      
      public function GetTaskByIdentifier(param1:uint) : TQuestDaily
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TQuestDaily = null;
         _loc2_ = int(this.FTaskList.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FTaskList[_loc3_];
            if(_loc4_.Identifier == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function GetTargetTaskByIndex(param1:uint) : TTargetTaskList
      {
         return this.FTargetTaskList[param1];
      }
      
      public function ClearTaskList() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:TQuestDaily = null;
         _loc1_ = int(this.FTaskList.length);
         while(_loc1_ > 0)
         {
            _loc3_ = this.FTaskList[_loc1_ - 1];
            _loc3_ = null;
            this.FTaskList.pop();
            _loc1_--;
         }
      }
      
      public function ClearTargetTaskList() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:TTargetTaskList = null;
         _loc1_ = int(this.FTargetTaskList.length);
         while(_loc1_ > 0)
         {
            _loc3_ = this.FTargetTaskList[_loc1_ - 1];
            _loc3_ = null;
            this.FTargetTaskList.pop();
            _loc1_--;
         }
      }
   }
}

