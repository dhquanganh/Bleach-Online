package Logics.Quests
{
   public class TQuestListInfor
   {
      
      protected var FBindingQuestes:TQuests;
      
      protected var FFirstShowQuesteIndex:int;
      
      protected var FSelectedQuestIndex:int;
      
      protected var FIfHide:Boolean;
      
      protected var FShowQuestNum:int;
      
      public function TQuestListInfor()
      {
         super();
      }
      
      public function get BindingQuestes() : TQuests
      {
         return this.FBindingQuestes;
      }
      
      public function set BindingQuestes(param1:TQuests) : void
      {
         this.FBindingQuestes = param1;
      }
      
      public function get FirstShowQuesteIndex() : int
      {
         return this.FFirstShowQuesteIndex;
      }
      
      public function set FirstShowQuesteIndex(param1:int) : void
      {
         this.FFirstShowQuesteIndex = param1;
      }
      
      public function get SelectedQuestIndex() : int
      {
         return this.FSelectedQuestIndex;
      }
      
      public function set SelectedQuestIndex(param1:int) : void
      {
         this.FSelectedQuestIndex = param1;
      }
      
      public function get IfHide() : Boolean
      {
         return this.FIfHide;
      }
      
      public function set IfHide(param1:Boolean) : void
      {
         this.FIfHide = param1;
      }
      
      public function get ShowQuestNum() : int
      {
         return this.FShowQuestNum;
      }
      
      public function set ShowQuestNum(param1:int) : void
      {
         this.FShowQuestNum = param1;
      }
   }
}

