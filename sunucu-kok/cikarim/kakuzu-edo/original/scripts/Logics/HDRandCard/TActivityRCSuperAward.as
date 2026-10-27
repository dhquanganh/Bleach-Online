package Logics.HDRandCard
{
   public class TActivityRCSuperAward
   {
      
      protected var FFixAward:uint;
      
      protected var FFixedAward:TActivityRCAwardCard;
      
      protected var FRandAwards:Vector.<TActivityRCAwardCard>;
      
      public function TActivityRCSuperAward()
      {
         super();
         this.FRandAwards = new Vector.<TActivityRCAwardCard>();
      }
      
      public function get FixAward() : uint
      {
         return this.FFixAward;
      }
      
      public function set FixAward(param1:uint) : void
      {
         this.FFixAward = param1;
      }
      
      public function get RandAwards() : Vector.<TActivityRCAwardCard>
      {
         return this.FRandAwards;
      }
      
      public function set RandAwards(param1:Vector.<TActivityRCAwardCard>) : void
      {
         this.FRandAwards = param1;
      }
      
      public function get FixedAward() : TActivityRCAwardCard
      {
         return this.FFixedAward;
      }
      
      public function set FixedAward(param1:TActivityRCAwardCard) : void
      {
         this.FFixedAward = param1;
      }
   }
}

