package Logics.Streamization.Quest
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TTask;
   import Logics.Quests.*;
   import Logics.Streamization.Characters.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TUnstreamizerQuests extends TUnstreamizerQuestUnknown
   {
      
      protected var FUnstreamizerQuest:TUnstreamizerQuest;
      
      public function TUnstreamizerQuests()
      {
         super();
         this.FUnstreamizerQuest = new TUnstreamizerQuest();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TQuest = null;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Vector.<TQuests> = null;
         var _loc10_:int = 0;
         _loc9_ = param2 as Vector.<TQuests>;
         _loc6_ = int(param1.readUnsignedShort());
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc5_ = param1.readUnsignedInt();
            _loc8_ = int(param1.readUnsignedShort());
            _loc10_ = this.GetIndexByQuestID(_loc5_,_loc9_);
            _loc4_ = _loc9_[_loc10_].GetQuestByIdentifier(_loc5_);
            _loc4_.CurrentfKillTime = _loc8_;
            switch(_loc4_.EventType)
            {
               case CONST_QUEST.QuestEventTypeJustRun:
                  _loc4_.TaskState = CONST_QUEST.STATE_TASKBACK;
                  break;
               default:
                  if(_loc4_.CurrentfKillTime >= _loc4_.KillTime)
                  {
                     _loc4_.TaskState = CONST_QUEST.STATE_TASKBACK;
                  }
                  else
                  {
                     _loc4_.TaskState = CONST_QUEST.STATE_TASKING;
                  }
            }
            _loc7_++;
         }
      }
      
      protected function UnstreamizationPerform_QuestsByDatabases(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TBins = null;
         var _loc7_:TTask = null;
         var _loc8_:Vector.<TQuests> = null;
         var _loc9_:TQuest = null;
         var _loc10_:int = 0;
         _loc6_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Task);
         _loc8_ = param2 as Vector.<TQuests>;
         _loc5_ = _loc6_.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = _loc6_.GetDatebaseByIndex(_loc4_) as TTask;
            _loc9_ = FPoolQuest.AcquireQuest(_loc7_.Identifier);
            this.FUnstreamizerQuest.UnstreamizeQuestByDatabases(null,_loc9_,_loc7_);
            _loc8_[_loc9_.Category].Add(_loc9_);
            _loc4_++;
         }
      }
      
      protected function GetIndexByQuestID(param1:uint, param2:Vector.<TQuests>) : int
      {
         var _loc3_:int = 0;
         var _loc4_:TQuests = null;
         _loc3_ = 0;
         while(_loc3_ < param2.length)
         {
            _loc4_ = param2[_loc3_];
            if(_loc4_.QuestIDMin <= param1 && _loc4_.QuestIDMax >= param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      public function UnstreamizeQuestsByDatabases(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_QuestsByDatabases(param1,param2,param3);
      }
   }
}

