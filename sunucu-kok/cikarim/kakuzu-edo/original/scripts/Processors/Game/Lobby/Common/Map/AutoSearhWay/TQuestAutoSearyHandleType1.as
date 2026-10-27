package Processors.Game.Lobby.Common.Map.AutoSearhWay
{
   import Resources.Constants.CONST_QUEST;
   
   public class TQuestAutoSearyHandleType1 extends TQuestAutoSearyHandle
   {
      
      public static const STATE_ACCEPT:int = 0;
      
      public static const STATE_TASKING:int = 1;
      
      public static const STATE_TASKBACK:int = 2;
      
      public function TQuestAutoSearyHandleType1()
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
            case CONST_QUEST.STATE_TASKBACK:
               GotoNpc(FQuest.BackTaskNpc);
         }
      }
      
      override protected function HandleQuestInWorldMap() : void
      {
         EnterMainCity();
      }
      
      override protected function NotifyEventTypeEnterMainCity() : void
      {
         this.HandleQuestInMainCity();
      }
   }
}

