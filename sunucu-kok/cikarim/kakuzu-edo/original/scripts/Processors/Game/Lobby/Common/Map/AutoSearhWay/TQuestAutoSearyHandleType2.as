package Processors.Game.Lobby.Common.Map.AutoSearhWay
{
   import Resources.Constants.CONST_QUEST;
   
   public class TQuestAutoSearyHandleType2 extends TQuestAutoSearyHandle
   {
      
      public function TQuestAutoSearyHandleType2()
      {
         super();
      }
      
      override protected function HandleQuestInMainCity() : void
      {
         switch(FQuest.TaskState)
         {
            case CONST_QUEST.STATE_ACCEPT:
               GotoNpc(FQuest.AcceptTaskNpc);
               break;
            case CONST_QUEST.STATE_TASKING:
               GotoNpc(FQuest.DoorID);
               break;
            case CONST_QUEST.STATE_TASKBACK:
               GotoNpc(FQuest.BackTaskNpc);
         }
      }
      
      override protected function HandleQuestInWorldMap() : void
      {
         switch(FQuest.TaskState)
         {
            case CONST_QUEST.STATE_ACCEPT:
            case CONST_QUEST.STATE_TASKBACK:
               EnterMainCity();
               break;
            case CONST_QUEST.STATE_TASKING:
               EnterMonsterMap(FQuest.CampId);
         }
      }
      
      override protected function NotifyEventTypeArriveCityDoor() : void
      {
         EnterMonsterMap(FQuest.CampId);
      }
      
      override protected function NotifyEventTypeEnterMainCity() : void
      {
         this.HandleQuestInMainCity();
      }
   }
}

