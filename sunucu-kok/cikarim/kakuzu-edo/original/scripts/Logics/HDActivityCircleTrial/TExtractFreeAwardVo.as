package Logics.HDActivityCircleTrial
{
   import Logics.Inventories.TInventories;
   
   public class TExtractFreeAwardVo
   {
      
      protected var FInventories:TInventories;
      
      protected var FIsGetAward:Boolean;
      
      protected var FTotalTimes:int;
      
      protected var FGetDebrisState:int;
      
      protected var FIndex:int;
      
      public function TExtractFreeAwardVo()
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
      
      public function get IsGetAward() : Boolean
      {
         return this.FIsGetAward;
      }
      
      public function set IsGetAward(param1:Boolean) : void
      {
         this.FIsGetAward = param1;
      }
      
      public function get TotalTimes() : int
      {
         return this.FTotalTimes;
      }
      
      public function set TotalTimes(param1:int) : void
      {
         this.FTotalTimes = param1;
      }
      
      public function get GetDebrisState() : int
      {
         return this.FGetDebrisState;
      }
      
      public function set GetDebrisState(param1:int) : void
      {
         this.FGetDebrisState = param1;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
   }
}

