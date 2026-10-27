package Logics.Streamization.Quest
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.Quests.TTaskAction;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerQuestAction extends TUnstreamizer
   {
      
      public function TUnstreamizerQuestAction()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TTaskAction = null;
         _loc4_ = param2 as TTaskAction;
         _loc4_.ResultCode = param1.readUnsignedInt();
         _loc4_.QuestID = param1.readUnsignedInt();
         _loc4_.ActionID = param1.readByte();
      }
   }
}

