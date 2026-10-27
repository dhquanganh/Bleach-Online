package Logics.HDThanksgivingDay
{
   import Logics.Inventories.TInventory;
   
   public class TThanksTreasureVO
   {
      
      public static const STATE_RECEIVE:int = 1;
      
      public static const STATE_NOTRECEIVE:int = 0;
      
      protected var FArticle:TInventory;
      
      protected var FState:int;
      
      public function TThanksTreasureVO()
      {
         super();
      }
      
      public function get State() : int
      {
         return this.FState;
      }
      
      public function set State(param1:int) : void
      {
         this.FState = param1;
      }
      
      public function get Article() : TInventory
      {
         return this.FArticle;
      }
      
      public function set Article(param1:TInventory) : void
      {
         this.FArticle = param1;
      }
   }
}

