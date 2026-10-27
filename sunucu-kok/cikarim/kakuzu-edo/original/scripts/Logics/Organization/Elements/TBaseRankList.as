package Logics.Organization.Elements
{
   public class TBaseRankList
   {
      
      protected var FRankName:String;
      
      protected var FRankFamily:uint;
      
      protected var FRankScore:uint;
      
      public function TBaseRankList()
      {
         super();
      }
      
      public function get RankName() : String
      {
         return this.FRankName;
      }
      
      public function set RankName(param1:String) : void
      {
         this.FRankName = param1;
      }
      
      public function get RankFamily() : uint
      {
         return this.FRankFamily;
      }
      
      public function set RankFamily(param1:uint) : void
      {
         this.FRankFamily = param1;
      }
      
      public function get RankScore() : uint
      {
         return this.FRankScore;
      }
      
      public function set RankScore(param1:uint) : void
      {
         this.FRankScore = param1;
      }
   }
}

