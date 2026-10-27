package Logics.GongFuFight
{
   public class TGongFuFightRankInfor
   {
      
      protected var FCurrentRank:uint;
      
      protected var FPlayerName:String;
      
      protected var FServerName:String;
      
      protected var FPlayerLevel:uint;
      
      protected var FPlayerScore:uint;
      
      protected var FPlayerGroupLevel:uint;
      
      public function TGongFuFightRankInfor()
      {
         super();
      }
      
      public function get CurrentRank() : uint
      {
         return this.FCurrentRank;
      }
      
      public function set CurrentRank(param1:uint) : void
      {
         this.FCurrentRank = param1;
      }
      
      public function get PlayerName() : String
      {
         return this.FPlayerName;
      }
      
      public function set PlayerName(param1:String) : void
      {
         this.FPlayerName = param1;
      }
      
      public function get ServerName() : String
      {
         return this.FServerName;
      }
      
      public function set ServerName(param1:String) : void
      {
         this.FServerName = param1;
      }
      
      public function get PlayerLevel() : uint
      {
         return this.FPlayerLevel;
      }
      
      public function set PlayerLevel(param1:uint) : void
      {
         this.FPlayerLevel = param1;
      }
      
      public function get PlayerScore() : uint
      {
         return this.FPlayerScore;
      }
      
      public function set PlayerScore(param1:uint) : void
      {
         this.FPlayerScore = param1;
      }
      
      public function get PlayerGroupLevel() : uint
      {
         return this.FPlayerGroupLevel;
      }
      
      public function set PlayerGroupLevel(param1:uint) : void
      {
         this.FPlayerGroupLevel = param1;
      }
   }
}

