package Logics.HDBleachBag
{
   import Logics.Inventories.TInventories;
   
   public class TBleachTaskVo
   {
      
      private var FIndex:int;
      
      private var FDesc:String;
      
      private var FGetAwardState:int;
      
      private var FInventories:TInventories;
      
      public function TBleachTaskVo()
      {
         super();
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function set Desc(param1:String) : void
      {
         this.FDesc = param1;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function set Inventories(param1:TInventories) : void
      {
         this.FInventories = param1;
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

