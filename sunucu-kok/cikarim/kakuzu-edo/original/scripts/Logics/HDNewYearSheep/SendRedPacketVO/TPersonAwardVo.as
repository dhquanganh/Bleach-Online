package Logics.HDNewYearSheep.SendRedPacketVO
{
   import Logics.Inventories.TInventories;
   
   public class TPersonAwardVo
   {
      
      private var FInventories:TInventories;
      
      private var FGetAwardState:int;
      
      public function TPersonAwardVo()
      {
         super();
      }
      
      public function set Inventories(param1:TInventories) : void
      {
         this.FInventories = param1;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function set GetAwardState(param1:int) : void
      {
         this.FGetAwardState = param1;
      }
      
      public function get GetAwardState() : int
      {
         return this.FGetAwardState;
      }
   }
}

