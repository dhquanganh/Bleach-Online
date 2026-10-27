package Logics.HDFirstPayGift.VO
{
   import Logics.Inventories.TInventories;
   
   public class TRechargeGoldVo
   {
      
      private var FInventories:TInventories;
      
      private var FGold:int;
      
      private var FGetAwardState:int;
      
      private var FIndex:int;
      
      public function TRechargeGoldVo()
      {
         super();
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function set Inventories(param1:TInventories) : void
      {
         this.FInventories = param1;
      }
      
      public function get Gold() : int
      {
         return this.FGold;
      }
      
      public function set Gold(param1:int) : void
      {
         this.FGold = param1;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
      
      public function get GetAwardState() : int
      {
         return this.FGetAwardState;
      }
      
      public function set GetAwardState(param1:int) : void
      {
         this.FGetAwardState = param1;
      }
   }
}

