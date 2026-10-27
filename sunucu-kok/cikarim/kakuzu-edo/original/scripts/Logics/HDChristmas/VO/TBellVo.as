package Logics.HDChristmas.VO
{
   import Logics.Inventories.TInventories;
   
   public class TBellVo
   {
      
      private var FGetAwardState:int;
      
      private var FInventories:TInventories;
      
      private var FNeedBellValue:int;
      
      public function TBellVo()
      {
         super();
      }
      
      public function get GetAwardState() : int
      {
         return this.FGetAwardState;
      }
      
      public function set GetAwardState(param1:int) : void
      {
         this.FGetAwardState = param1;
      }
      
      public function get NeedBellValue() : int
      {
         return this.FNeedBellValue;
      }
      
      public function set NeedBellValue(param1:int) : void
      {
         this.FNeedBellValue = param1;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function set Inventories(param1:TInventories) : void
      {
         this.FInventories = param1;
      }
   }
}

