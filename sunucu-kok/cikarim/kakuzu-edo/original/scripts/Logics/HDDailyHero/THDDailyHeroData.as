package Logics.HDDailyHero
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class THDDailyHeroData extends TActivityOSBase
   {
      
      protected var FScore:uint;
      
      protected var FAwardStates:Vector.<int>;
      
      public function THDDailyHeroData()
      {
         super();
         this.FAwardStates = new Vector.<int>();
      }
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function set Score(param1:uint) : void
      {
         this.FScore = param1;
      }
      
      public function get AwardStates() : Vector.<int>
      {
         return this.FAwardStates;
      }
      
      public function set AwardStates(param1:Vector.<int>) : void
      {
         this.FAwardStates = param1;
      }
   }
}

