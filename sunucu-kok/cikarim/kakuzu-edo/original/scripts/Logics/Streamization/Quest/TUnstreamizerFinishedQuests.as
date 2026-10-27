package Logics.Streamization.Quest
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.Quests.*;
   import Resources.Constants.CONST_QUEST;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerFinishedQuests extends TUnstreamizer
   {
      
      public function TUnstreamizerFinishedQuests()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TQuest = null;
         var _loc8_:Vector.<TQuests> = null;
         var _loc9_:int = 0;
         _loc8_ = param2 as Vector.<TQuests>;
         _loc5_ = param1.readShort();
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = param1.readInt();
            _loc9_ = this.GetIndexByQuestID(_loc4_,_loc8_);
            _loc7_ = _loc8_[_loc9_].GetQuestByIdentifier(_loc4_);
            _loc7_.TaskState = CONST_QUEST.STATE_ALREADYBACK;
            _loc6_++;
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
   }
}

