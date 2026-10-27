package Logics.GongFuFight
{
   public class TGongFuFightPayRecord
   {
      
      protected var FPlayerName:String;
      
      protected var FPayQuality:int;
      
      protected var FPayID:uint;
      
      public function TGongFuFightPayRecord()
      {
         super();
      }
      
      public function get PlayerName() : String
      {
         return this.FPlayerName;
      }
      
      public function set PlayerName(param1:String) : void
      {
         this.FPlayerName = param1;
      }
      
      public function get PayQuality() : int
      {
         return this.FPayQuality;
      }
      
      public function set PayQuality(param1:int) : void
      {
         this.FPayQuality = param1;
      }
      
      public function get PayID() : uint
      {
         return this.FPayID;
      }
      
      public function set PayID(param1:uint) : void
      {
         this.FPayID = param1;
      }
   }
}

