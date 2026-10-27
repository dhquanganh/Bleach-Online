package Logics.HDRandCard
{
   public class TActivityRCStageData
   {
      
      protected var FStage:uint;
      
      protected var FAwardIndex:int;
      
      public function TActivityRCStageData()
      {
         super();
      }
      
      public function get Stage() : uint
      {
         return this.FStage;
      }
      
      public function set Stage(param1:uint) : void
      {
         this.FStage = param1;
      }
      
      public function get AwardIndex() : int
      {
         return this.FAwardIndex;
      }
      
      public function set AwardIndex(param1:int) : void
      {
         this.FAwardIndex = param1;
      }
   }
}

