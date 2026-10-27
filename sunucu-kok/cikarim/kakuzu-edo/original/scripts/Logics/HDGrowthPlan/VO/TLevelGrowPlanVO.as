package Logics.HDGrowthPlan.VO
{
   public class TLevelGrowPlanVO
   {
      
      private var FLevel:int;
      
      private var FGold:int;
      
      private var FGetAwardState:int;
      
      private var FIndex:int;
      
      public function TLevelGrowPlanVO()
      {
         super();
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function set Level(param1:int) : void
      {
         this.FLevel = param1;
      }
      
      public function get Gold() : int
      {
         return this.FGold;
      }
      
      public function set Gold(param1:int) : void
      {
         this.FGold = param1;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
      
      public function get GetAwardState() : int
      {
         return this.FGetAwardState;
      }
      
      public function set GetAwardState(param1:int) : void
      {
         this.FGetAwardState = param1;
      }
   }
}

