package Processors.Game.Lobby.Quests.QuestNew
{
   public class TQuestInfor
   {
      
      protected var FInforID:int;
      
      protected var FInforArray:Array;
      
      public function TQuestInfor()
      {
         super();
         this.FInforArray = new Array();
      }
      
      public function get InforArray() : Array
      {
         return this.FInforArray;
      }
      
      public function set InforArray(param1:Array) : void
      {
         this.FInforArray = param1;
      }
      
      public function get InforID() : int
      {
         return this.FInforID;
      }
      
      public function set InforID(param1:int) : void
      {
         this.FInforID = param1;
      }
   }
}

