package Processors.Game.Lobby.Quests.QuestNew
{
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Registries.TRegistryRoutine;
   import Logics.Quests.TQuest;
   import Logics.Quests.TQuests;
   import Logics.Quests.TTaskAction;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_QUEST;
   
   public class TQuestHandle
   {
      
      protected var FQuestCanAccept:TQuests;
      
      protected var FQuestAccepted:TQuests;
      
      protected var FQuestCompleted:TQuests;
      
      protected var FQuestBase:TQuests;
      
      protected var FRegistryRoutine:TRegistryRoutine;
      
      public function TQuestHandle()
      {
         super();
         this.FRegistryRoutine = new TRegistryRoutine();
         this.RoutingRegist();
      }
      
      protected function RoutingRegist() : void
      {
      }
      
      protected function QuestRequest(param1:int, param2:int) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Task_QuestActionReq);
         _loc3_.Data.writeInt(param2);
         _loc3_.Data.writeByte(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function RequestAccetpQuest(param1:uint) : void
      {
         this.QuestRequest(CONST_QUEST.ACTIONID_ACCEPT,param1);
      }
      
      protected function RequestCompleteQuest(param1:uint) : void
      {
         this.QuestRequest(CONST_QUEST.ACTIONID_COMPLETE,param1);
      }
      
      private function RequestCancleQuest(param1:uint) : void
      {
         this.QuestRequest(CONST_QUEST.ACTIONID_CANCLE,param1);
      }
      
      protected function ActionAcceptHandle(param1:uint) : void
      {
         var _loc2_:TQuest = null;
         _loc2_ = this.FQuestCanAccept.DeleteQuestByIdentifier(param1);
         this.FQuestAccepted.Add(_loc2_);
         switch(_loc2_.EventType)
         {
            case CONST_QUEST.QuestEventTypeJustRun:
               _loc2_.TaskState = CONST_QUEST.STATE_TASKBACK;
               break;
            default:
               _loc2_.TaskState = CONST_QUEST.STATE_TASKING;
         }
      }
      
      protected function ActionCompleteHandle(param1:uint) : void
      {
         var _loc2_:TQuest = null;
         _loc2_ = this.FQuestAccepted.DeleteQuestByIdentifier(param1);
         _loc2_.TaskState = CONST_QUEST.STATE_ALREADYBACK;
         this.FQuestCompleted.Add(_loc2_);
      }
      
      protected function DispatchQuest_Perform() : void
      {
         this.SelectQuestByState(CONST_QUEST.STATE_TASKING,this.FQuestBase,this.FQuestAccepted);
         this.SelectQuestByState(CONST_QUEST.STATE_TASKBACK,this.FQuestBase,this.FQuestAccepted);
         this.SelectQuestByState(CONST_QUEST.STATE_ALREADYBACK,this.FQuestBase,this.FQuestCompleted);
      }
      
      protected function SelectQuestByState(param1:int, param2:TQuests, param3:TQuests) : void
      {
         var _loc4_:* = 0;
         var _loc5_:TQuest = null;
         _loc4_ = 0;
         while(_loc4_ < param2.Count)
         {
            _loc5_ = param2.GetQuestByIndex(_loc4_);
            if(_loc5_.TaskState == param1)
            {
               param3.Add(_loc5_);
               param2.DeleteQuestByIdentifier(_loc5_.Identifier);
               _loc4_--;
            }
            _loc4_++;
         }
      }
      
      protected function CheckIfContain(param1:uint, param2:uint, param3:uint) : Boolean
      {
         return param1 <= param3 && param2 >= param3;
      }
      
      protected function QuestInforHandle_Peform(param1:TQuestInfor) : Boolean
      {
         var _loc2_:Function = null;
         _loc2_ = this.FRegistryRoutine.GetRoutineByIndentifier(param1.InforID);
         if(_loc2_ != null)
         {
            return _loc2_(param1);
         }
         return false;
      }
      
      public function CheckCanAcceptQuest() : Boolean
      {
         return false;
      }
      
      public function QuestInforHandle(param1:TQuestInfor) : Boolean
      {
         return this.QuestInforHandle_Peform(param1);
      }
      
      public function QuestActionRet(param1:TTaskAction) : void
      {
         switch(param1.ActionID)
         {
            case CONST_QUEST.ACTIONID_ACCEPT:
               this.ActionAcceptHandle(param1.QuestID);
               break;
            case CONST_QUEST.ACTIONID_COMPLETE:
               this.ActionCompleteHandle(param1.QuestID);
         }
      }
      
      public function DispatchQuest() : void
      {
         this.DispatchQuest_Perform();
      }
   }
}

