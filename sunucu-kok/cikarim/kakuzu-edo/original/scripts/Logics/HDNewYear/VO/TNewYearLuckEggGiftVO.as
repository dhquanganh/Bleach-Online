package Logics.HDNewYear.VO
{
   import Logics.Inventories.TInventories;
   
   public class TNewYearLuckEggGiftVO
   {
      
      protected var FInventories:TInventories;
      
      protected var FGeted:Boolean;
      
      protected var FAllowGet:Boolean;
      
      protected var FCondition:uint;
      
      protected var FGiftState:int;
      
      public function TNewYearLuckEggGiftVO()
      {
         super();
      }
      
      public function get Geted() : Boolean
      {
         return this.FGeted;
      }
      
      public function set Geted(param1:Boolean) : void
      {
         this.FGeted = param1;
      }
      
      public function get AllowGet() : Boolean
      {
         return this.FAllowGet;
      }
      
      public function set AllowGet(param1:Boolean) : void
      {
         this.FAllowGet = param1;
      }
      
      public function get Condition() : uint
      {
         return this.FCondition;
      }
      
      public function set Condition(param1:uint) : void
      {
         this.FCondition = param1;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function set Inventories(param1:TInventories) : void
      {
         this.FInventories = param1;
      }
      
      public function get GiftState() : int
      {
         return this.FGiftState;
      }
      
      public function set GiftState(param1:int) : void
      {
         this.FGiftState = param1;
      }
   }
}

