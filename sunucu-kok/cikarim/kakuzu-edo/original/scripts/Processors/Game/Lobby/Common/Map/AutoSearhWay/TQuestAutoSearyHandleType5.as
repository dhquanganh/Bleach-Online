package Processors.Game.Lobby.Common.Map.AutoSearhWay
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TNPC;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NPC;
   import Resources.Constants.CONST_QUEST;
   
   public class TQuestAutoSearyHandleType5 extends TQuestAutoSearyHandle
   {
      
      public function TQuestAutoSearyHandleType5()
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
               _loc1_ = this.FindMakeEquipNpc();
               GotoNpc(_loc1_);
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
      
      protected function FindMakeEquipNpc() : int
      {
         var _loc1_:TBins = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TNPC = null;
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_NPC);
         _loc3_ = _loc1_.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc1_.GetDatebaseByIndex(_loc2_) as TNPC;
            if(_loc4_.UserType == CONST_NPC.NPC_FUNCTION_MADE)
            {
               return _loc4_.Identifier;
            }
            _loc2_++;
         }
         return 0;
      }
   }
}

