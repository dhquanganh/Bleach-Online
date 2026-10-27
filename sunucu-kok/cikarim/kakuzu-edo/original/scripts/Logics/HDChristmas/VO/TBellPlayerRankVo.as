package Logics.HDChristmas.VO
{
   public class TBellPlayerRankVo
   {
      
      private var FPlayerName:String;
      
      private var FPlayerBellValue:int;
      
      private var FPlayerRank:int;
      
      public function TBellPlayerRankVo()
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
      
      public function get PlayerBellValue() : int
      {
         return this.FPlayerBellValue;
      }
      
      public function set PlayerBellValue(param1:int) : void
      {
         this.FPlayerBellValue = param1;
      }
      
      public function get PlayerRank() : int
      {
         return this.FPlayerRank;
      }
      
      public function set PlayerRank(param1:int) : void
      {
         this.FPlayerRank = param1;
      }
   }
}

