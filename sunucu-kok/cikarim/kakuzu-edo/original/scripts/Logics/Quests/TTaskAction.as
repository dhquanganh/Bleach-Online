package Logics.Quests
{
   public class TTaskAction
   {
      
      protected var FResultCode:uint;
      
      protected var FQuestID:uint;
      
      protected var FActionID:int;
      
      public function TTaskAction()
      {
         super();
      }
      
      public function get ActionID() : int
      {
         return this.FActionID;
      }
      
      public function set ActionID(param1:int) : void
      {
         this.FActionID = param1;
      }
      
      public function get ResultCode() : uint
      {
         return this.FResultCode;
      }
      
      public function set ResultCode(param1:uint) : void
      {
         this.FResultCode = param1;
      }
      
      public function get QuestID() : uint
      {
         return this.FQuestID;
      }
      
      public function set QuestID(param1:uint) : void
      {
         this.FQuestID = param1;
      }
   }
}

