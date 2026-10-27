package Logics.HDRandCard
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityRCGoldAward extends TActivityEntity
   {
      
      protected var FAwardCard:Vector.<TActivityRCAwardCard>;
      
      public function TActivityRCGoldAward(param1:uint)
      {
         super(param1);
         this.FAwardCard = new Vector.<TActivityRCAwardCard>();
      }
      
      public function get AwardCard() : Vector.<TActivityRCAwardCard>
      {
         return this.FAwardCard;
      }
      
      public function set AwardCard(param1:Vector.<TActivityRCAwardCard>) : void
      {
         this.FAwardCard = param1;
      }
   }
}

