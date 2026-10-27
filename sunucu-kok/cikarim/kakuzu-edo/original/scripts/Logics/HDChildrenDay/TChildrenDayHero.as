package Logics.HDChildrenDay
{
   import Logics.DatebaseVO.VO.THDChildrenDayHero;
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TChildrenDayHero extends TActivityOSBase
   {
      
      protected var FConfig:THDChildrenDayHero;
      
      public function TChildrenDayHero()
      {
         super();
      }
      
      public function get Config() : THDChildrenDayHero
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDChildrenDayHero) : void
      {
         this.FConfig = param1;
      }
   }
}

