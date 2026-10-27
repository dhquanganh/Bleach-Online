package Processors.Game.Lobby.Common.Map.AutoSearhWay
{
   import Resources.Constants.CONST_QUEST;
   
   public class TQuestAutoSearyHandleType14 extends TQuestAutoSearyHandle
   {
      
      public function TQuestAutoSearyHandleType14()
      {
         super();
      }
      
      override protected function HandleQuestInMainCity() : void
      {
         var _loc1_:int = 0;
         switch(FQuest.TaskState)
         {
            case CONST_QUEST.STATE_ACCEPT:
               GotoNpc(FQuest.AcceptTaskNpc);
               break;
            case CONST_QUEST.STATE_TASKING:
               EnterHome();
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
               EnterHome();
               break;
            case CONST_QUEST.STATE_TASKBACK:
               EnterMainCity();
         }
      }
      
      override protected function NotifyEventTypeEnterMainCity() : void
      {
      }
   }
}

