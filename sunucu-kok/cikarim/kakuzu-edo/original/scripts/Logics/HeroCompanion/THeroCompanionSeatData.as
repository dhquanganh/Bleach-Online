package Logics.HeroCompanion
{
   public class THeroCompanionSeatData
   {
      
      protected var FSeatCardId:int;
      
      protected var FNeedFever:int;
      
      protected var FNeedVip:int;
      
      protected var FSeat:int;
      
      public function THeroCompanionSeatData()
      {
         super();
      }
      
      public function get IsLocked() : Boolean
      {
         return this.FNeedFever > 0 || this.FNeedVip > 0;
      }
      
      public function get SeatCardId() : int
      {
         return this.FSeatCardId;
      }
      
      public function set SeatCardId(param1:int) : void
      {
         this.FSeatCardId = param1;
      }
      
      public function get NeedFever() : int
      {
         return this.FNeedFever;
      }
      
      public function set NeedFever(param1:int) : void
      {
         this.FNeedFever = param1;
      }
      
      public function get NeedVip() : int
      {
         return this.FNeedVip;
      }
      
      public function set NeedVip(param1:int) : void
      {
         this.FNeedVip = param1;
      }
      
      public function get Seat() : int
      {
         return this.FSeat;
      }
      
      public function set Seat(param1:int) : void
      {
         this.FSeat = param1;
      }
   }
}

