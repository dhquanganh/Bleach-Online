package Logics.HeroCompanion
{
   import Logics.DatebaseVO.VO.TCompanionCard;
   import Processors.Game.Common.Effects.ListAutoScroll.IListAutoScrollDataRender;
   
   public class THeroCompanionCardData implements IListAutoScrollDataRender
   {
      
      protected var FCards:Vector.<TCompanionCard>;
      
      protected var FLastCard:int;
      
      protected var FSeat:int;
      
      protected var FLevel:int;
      
      public function THeroCompanionCardData()
      {
         super();
         this.FCards = new Vector.<TCompanionCard>();
      }
      
      public function get LastCard() : int
      {
         return this.FLastCard;
      }
      
      public function set LastCard(param1:int) : void
      {
         this.FLastCard = param1;
      }
      
      public function get Seat() : int
      {
         return this.FSeat;
      }
      
      public function set Seat(param1:int) : void
      {
         this.FSeat = param1;
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function set Level(param1:int) : void
      {
         this.FLevel = param1;
      }
      
      public function get Cards() : Vector.<TCompanionCard>
      {
         return this.FCards;
      }
      
      public function GetDisplayCard() : TCompanionCard
      {
         return this.FCards[0];
      }
      
      public function GetCurCard() : TCompanionCard
      {
         if(this.FLevel > 0)
         {
            return this.FCards[this.FLevel - 1];
         }
         return this.FCards[0];
      }
      
      public function GetCardByLevel(param1:int) : TCompanionCard
      {
         if(this.FCards.length < param1)
         {
            return null;
         }
         if(param1 > 0)
         {
            return this.FCards[param1 - 1];
         }
         return this.FCards[0];
      }
   }
}

