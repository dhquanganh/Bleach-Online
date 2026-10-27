package Processors.Game.Lobby.Common.Map.AutoSearhWay
{
   import Resources.Constants.CONST_QUEST;
   
   public class TQuestAutoSearyHandleType4 extends TQuestAutoSearyHandle
   {
      
      public function TQuestAutoSearyHandleType4()
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
               EnterMonsterMap(0);
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
               EnterMainCity();
               break;
            case CONST_QUEST.STATE_TASKING:
               EnterMonsterMap(0);
               break;
            case CONST_QUEST.STATE_TASKBACK:
               EnterMainCity();
         }
      }
      
      override protected function NotifyEventTypeEnterMainCity() : void
      {
         switch(FQuest.TaskState)
         {
            case CONST_QUEST.STATE_ACCEPT:
               GotoNpc(FQuest.AcceptTaskNpc);
               break;
            case CONST_QUEST.STATE_TASKBACK:
               GotoNpc(FQuest.BackTaskNpc);
         }
      }
   }
}

