package Logics.Streamization.DailyTask
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.Dailytask.TQuestDaily;
   import Logics.DatebaseVO.VO.TDailyTask;
   import Logics.Spaces.LogicsSpace;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.ByteArray;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerTask extends TUnstreamizer
   {
      
      protected static const STATE_CANCEL:uint = 1;
      
      public function TUnstreamizerTask()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TQuestDaily = null;
         var _loc5_:int = 0;
         _loc4_ = param2 as TQuestDaily;
         _loc5_ = int(param1.readUnsignedInt());
         _loc4_.Coerce(_loc5_);
         this.UnstreamizationPerform_TaskListByDatabase(_loc4_,_loc5_);
      }
      
      protected function UnstreamizationPerform_TaskListByDatabase(param1:TQuestDaily, param2:uint) : void
      {
         var _loc3_:TQuestDaily = null;
         var _loc4_:TDailyTask = null;
         _loc3_ = param1 as TQuestDaily;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_DailyTask,param2) as TDailyTask;
         _loc3_.AwardPoint = _loc4_.Point;
         if(_loc4_.Cancel == STATE_CANCEL)
         {
            _loc3_.CanCancle = true;
         }
         else
         {
            _loc3_.CanCancle = false;
         }
         _loc3_.KillTime = _loc4_.Complete;
         _loc3_.Description = _loc4_.Description;
         _loc3_.IsGoto = _loc4_.Isgoto;
         _loc3_.Rate = _loc4_.Rate;
         _loc3_.SmallPic = _loc4_.Smallpicture;
         _loc3_.Name = _loc4_.Taskname;
         _loc3_.Rewards = _loc4_.RewardVect;
         _loc3_.Instant = _loc4_.InstantVect;
         _loc3_.EventType = _loc4_.EventType;
      }
   }
}

