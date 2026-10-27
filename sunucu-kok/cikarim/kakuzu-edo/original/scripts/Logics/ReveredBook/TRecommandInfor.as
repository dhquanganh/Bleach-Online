package Logics.ReveredBook
{
   public class TRecommandInfor
   {
      
      protected var FRecommandInfor:Vector.<Vector.<TRecommandHeroInfor>>;
      
      protected var FTabName:Vector.<String>;
      
      public function TRecommandInfor()
      {
         super();
         this.FTabName = new Vector.<String>();
         this.FRecommandInfor = new Vector.<Vector.<TRecommandHeroInfor>>();
      }
      
      public function get RecommandInfor() : Vector.<Vector.<TRecommandHeroInfor>>
      {
         return this.FRecommandInfor;
      }
      
      public function get TabName() : Vector.<String>
      {
         return this.FTabName;
      }
   }
}

