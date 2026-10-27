package Logics.Dailywelfare
{
   public class TGetBackItem
   {
      
      protected var FIndex:uint;
      
      protected var FStatus:int;
      
      protected var FExp:uint;
      
      protected var FGold:uint;
      
      public function TGetBackItem()
      {
         super();
      }
      
      public function get Index() : uint
      {
         return this.FIndex;
      }
      
      public function set Index(param1:uint) : void
      {
         this.FIndex = param1;
      }
      
      public function get Status() : int
      {
         return this.FStatus;
      }
      
      public function set Status(param1:int) : void
      {
         this.FStatus = param1;
      }
      
      public function get Exp() : uint
      {
         return this.FExp;
      }
      
      public function set Exp(param1:uint) : void
      {
         this.FExp = param1;
      }
      
      public function get Gold() : uint
      {
         return this.FGold;
      }
      
      public function set Gold(param1:uint) : void
      {
         this.Gold = param1;
      }
   }
}

