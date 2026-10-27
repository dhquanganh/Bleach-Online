package Logics.Battle.model
{
   public class TStatisticsVO
   {
      
      protected var FHeroId:int;
      
      protected var FHurt:int;
      
      protected var FRemainHp:Number;
      
      public function TStatisticsVO()
      {
         super();
      }
      
      public function get HeroId() : int
      {
         return this.FHeroId;
      }
      
      public function set HeroId(param1:int) : void
      {
         this.FHeroId = param1;
      }
      
      public function get Hurt() : int
      {
         return this.FHurt;
      }
      
      public function set Hurt(param1:int) : void
      {
         this.FHurt = param1;
      }
      
      public function get RemainHp() : Number
      {
         return this.FRemainHp;
      }
      
      public function set RemainHp(param1:Number) : void
      {
         this.FRemainHp = param1;
      }
   }
}

