package Logics.Organization.VO
{
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.TMall;
   
   public class THeroExchangeVO
   {
      
      protected var FMall:TMall;
      
      protected var FHero:TBaseHero;
      
      protected var FNeedAwardName:String;
      
      protected var FIsExchange:Boolean;
      
      public function THeroExchangeVO()
      {
         super();
      }
      
      public function get Mall() : TMall
      {
         return this.FMall;
      }
      
      public function set Mall(param1:TMall) : void
      {
         this.FMall = param1;
      }
      
      public function get IsExchange() : Boolean
      {
         return this.FIsExchange;
      }
      
      public function set IsExchange(param1:Boolean) : void
      {
         this.FIsExchange = param1;
      }
      
      public function get Hero() : TBaseHero
      {
         return this.FHero;
      }
      
      public function set Hero(param1:TBaseHero) : void
      {
         this.FHero = param1;
      }
      
      public function get NeedAwardName() : String
      {
         return this.FNeedAwardName;
      }
      
      public function set NeedAwardName(param1:String) : void
      {
         this.FNeedAwardName = param1;
      }
   }
}

