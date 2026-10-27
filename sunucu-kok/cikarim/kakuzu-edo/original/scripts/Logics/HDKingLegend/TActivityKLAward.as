package Logics.HDKingLegend
{
   public class TActivityKLAward
   {
      
      protected var FCostCard:int;
      
      protected var FMaxGetCount:int;
      
      protected var FAwardId:int;
      
      protected var FDisplayId:int;
      
      public function TActivityKLAward()
      {
         super();
      }
      
      public function get CostCard() : int
      {
         return this.FCostCard;
      }
      
      public function set CostCard(param1:int) : void
      {
         this.FCostCard = param1;
      }
      
      public function get MaxGetCount() : int
      {
         return this.FMaxGetCount;
      }
      
      public function set MaxGetCount(param1:int) : void
      {
         this.FMaxGetCount = param1;
      }
      
      public function get AwardId() : int
      {
         return this.FAwardId;
      }
      
      public function set AwardId(param1:int) : void
      {
         this.FAwardId = param1;
      }
      
      public function get DisplayId() : int
      {
         return this.FDisplayId;
      }
      
      public function set DisplayId(param1:int) : void
      {
         this.FDisplayId = param1;
      }
   }
}

