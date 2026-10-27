package Processors.Game.Lobby.Common.Map.AutoSearhWay
{
   import Resources.Constants.CONST_QUEST;
   import Resources.Constants.CONST_SHORTCUTS;
   import Resources.Constants.CONST_SMITHY;
   
   public class TQuestAutoSearyHandleType8 extends TQuestAutoSearyHandle
   {
      
      public function TQuestAutoSearyHandleType8()
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
               OpenView(CONST_SHORTCUTS.POSITION_MainFunction,CONST_SHORTCUTS.TYPE_MainFunction_Strengthen,CONST_SMITHY.TAB_INDEX_ADVANCED);
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
               OpenView(CONST_SHORTCUTS.POSITION_MainFunction,CONST_SHORTCUTS.TYPE_MainFunction_Strengthen,CONST_SMITHY.TAB_INDEX_ADVANCED);
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

