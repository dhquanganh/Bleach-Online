package Logics.Dailytask
{
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import Logics.Quests.TQuest;
   
   public class TQuestDaily extends TQuest
   {
      
      protected var FSmallPic:uint;
      
      protected var FAwardPoint:uint;
      
      protected var FRate:uint;
      
      protected var FIsGoto:uint;
      
      protected var FRewards:Vector.<TFixedAward>;
      
      protected var FInstant:Array;
      
      public function TQuestDaily(param1:uint)
      {
         super(param1);
      }
      
      public function get SmallPic() : uint
      {
         return this.FSmallPic;
      }
      
      public function set SmallPic(param1:uint) : void
      {
         this.FSmallPic = param1;
      }
      
      public function get AwardPoint() : uint
      {
         return this.FAwardPoint;
      }
      
      public function set AwardPoint(param1:uint) : void
      {
         this.FAwardPoint = param1;
      }
      
      public function get Rate() : uint
      {
         return this.FRate;
      }
      
      public function set Rate(param1:uint) : void
      {
         this.FRate = param1;
      }
      
      public function get IsGoto() : uint
      {
         return this.FIsGoto;
      }
      
      public function set IsGoto(param1:uint) : void
      {
         this.FIsGoto = param1;
      }
      
      public function get Rewards() : Vector.<TFixedAward>
      {
         return this.FRewards;
      }
      
      public function set Rewards(param1:Vector.<TFixedAward>) : void
      {
         this.FRewards = param1;
      }
      
      public function get Instant() : Array
      {
         return this.FInstant;
      }
      
      public function set Instant(param1:Array) : void
      {
         this.FInstant = param1;
      }
   }
}

