package Processors.Game.Lobby.Common.Map.AutoSearhWay
{
   import Resources.Constants.CONST_QUEST;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TQuestAutoSearyHandleType11 extends TQuestAutoSearyHandle
   {
      
      public function TQuestAutoSearyHandleType11()
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
               OpenView(CONST_SHORTCUTS.POSITION_Constantly,CONST_SHORTCUTS.TYPE_Constantly_GirlGame);
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
               OpenView(CONST_SHORTCUTS.POSITION_Constantly,CONST_SHORTCUTS.TYPE_Constantly_GirlGame);
               break;
            case CONST_QUEST.STATE_TASKBACK:
               EnterMainCity();
         }
      }
      
      override protected function NotifyEventTypeEnterMainCity() : void
      {
         this.HandleQuestInMainCity();
      }
   }
}

