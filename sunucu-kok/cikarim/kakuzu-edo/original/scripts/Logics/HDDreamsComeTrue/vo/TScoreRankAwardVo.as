package Logics.HDDreamsComeTrue.vo
{
   import Logics.Inventories.TInventories;
   
   public class TScoreRankAwardVo
   {
      
      private var FInventories:TInventories;
      
      private var FRankInfo:String;
      
      public function TScoreRankAwardVo()
      {
         super();
      }
      
      public function get RankInfo() : String
      {
         return this.FRankInfo;
      }
      
      public function set RankInfo(param1:String) : void
      {
         this.FRankInfo = param1;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function set Inventories(param1:TInventories) : void
      {
         this.FInventories = param1;
      }
   }
}

