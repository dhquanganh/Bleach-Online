package Processors.Game.Lobby.Quests.QuestNew
{
   import Logics.Characters.TCharacter;
   import Logics.Quests.TQuest;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_QUEST;
   
   public class TQuestHandleMainQuest extends TQuestHandle
   {
      
      public function TQuestHandleMainQuest()
      {
         var _loc1_:TCharacter = null;
         super();
         _loc1_ = SLogicsCore.Character;
         FQuestCanAccept = _loc1_.MainQuestsCanAccept;
         FQuestAccepted = _loc1_.MainQuestsAlreadyAccept;
         FQuestCompleted = _loc1_.MainQuestComplete;
         FQuestBase = _loc1_.MainQuestBase;
      }
      
      override protected function RoutingRegist() : void
      {
         FRegistryRoutine.Register(CONST_QUEST.QUEST_INFOR_NPC_CLICKACCEPTBUTTON,this.InforHandle_ClickAcceptButton);
         FRegistryRoutine.Register(CONST_QUEST.QUEST_INFOR_NPC_CLICKCOMPLETEBUTTON,this.InforHandle_ClickCompleteButton);
      }
      
      protected function InforHandle_ClickAcceptButton(param1:TQuestInfor) : Boolean
      {
         var _loc2_:TQuest = null;
         var _loc3_:Boolean = false;
         _loc3_ = CheckIfContain(FQuestBase.QuestIDMin,FQuestBase.QuestIDMax,param1.InforArray[0]);
         if(!_loc3_)
         {
            return false;
         }
         _loc2_ = FQuestCanAccept.GetQuestByIdentifier(param1.InforArray[0]);
         if(_loc2_ != null)
         {
            RequestAccetpQuest(_loc2_.Identifier);
            return false;
         }
         return false;
      }
      
      protected function InforHandle_ClickCompleteButton(param1:TQuestInfor) : Boolean
      {
         var _loc2_:TQuest = null;
         var _loc3_:Boolean = false;
         _loc3_ = CheckIfContain(FQuestBase.QuestIDMin,FQuestBase.QuestIDMax,param1.InforArray[0]);
         if(!_loc3_)
         {
            return false;
         }
         _loc2_ = FQuestAccepted.GetQuestByIdentifier(param1.InforArray[0]);
         if(_loc2_ != null)
         {
            if(_loc2_.TaskState == CONST_QUEST.STATE_TASKBACK)
            {
               RequestCompleteQuest(_loc2_.Identifier);
            }
            return false;
         }
         return false;
      }
      
      protected function InforHandle_KillMonster(param1:TQuestInfor) : Boolean
      {
         var _loc2_:TQuest = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         _loc4_ = false;
         _loc3_ = 0;
         while(_loc3_ < FQuestAccepted.Count)
         {
            _loc2_ = FQuestAccepted.GetQuestByIndex(_loc3_);
            if(_loc2_.EventType == CONST_QUEST.QuestEventTypeKillMonster && _loc2_.CampId == param1.InforArray[0])
            {
               _loc2_.CurrentfKillTime += param1.InforArray[1];
               if(_loc2_.CurrentfKillTime >= _loc2_.KillTime)
               {
                  _loc2_.TaskState = CONST_QUEST.STATE_TASKBACK;
                  _loc4_ = true;
               }
            }
            _loc3_++;
         }
         return _loc4_;
      }
      
      override public function CheckCanAcceptQuest() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TQuest = null;
         var _loc4_:TQuest = null;
         var _loc5_:int = 0;
         if(FQuestCanAccept.Count != 0)
         {
            _loc3_ = FQuestCanAccept.GetQuestByIndex(0);
            if(_loc3_.PreView)
            {
               if(_loc3_.RequirementLevelMin > SLogicsCore.Character.GetMainLevel())
               {
                  return false;
               }
               _loc3_.PreView = false;
               return true;
            }
         }
         _loc1_ = 0;
         if(_loc1_ >= FQuestBase.Count)
         {
            return false;
         }
         _loc3_ = FQuestBase.GetQuestByIndex(_loc1_);
         _loc4_ = FQuestCompleted.GetQuestByIdentifier(_loc3_.PreQuestId);
         if(_loc3_.PreQuestId != 0 && _loc4_ == null)
         {
            return false;
         }
         _loc5_ = int(SLogicsCore.Character.GetMainLevel());
         if(_loc3_.RequirementLevelMin > SLogicsCore.Character.GetMainLevel())
         {
            if(!(FQuestAccepted.Count == 0 && FQuestCanAccept.Count == 0))
            {
               return false;
            }
            _loc3_.PreView = true;
         }
         _loc3_.TaskState = CONST_QUEST.STATE_ACCEPT;
         FQuestCanAccept.Add(_loc3_);
         FQuestBase.DeleteQuestByIdentifier(_loc3_.Identifier);
         return true;
      }
   }
}

