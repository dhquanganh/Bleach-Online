package Logics.HDNewYear2017
{
   import Logics.DatebaseVO.VO.THDNewYear2017Task;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TNewYear2017Task extends TActivityOSBase
   {
      
      protected var FTasksProgress:Vector.<int>;
      
      protected var FBags:Vector.<TInventories>;
      
      protected var FBagStatus:Vector.<int>;
      
      protected var FScore:uint;
      
      protected var FConfig:THDNewYear2017Task;
      
      public function TNewYear2017Task()
      {
         super();
         this.FBags = new Vector.<TInventories>(2);
         this.FBagStatus = new Vector.<int>(2);
         this.TasksProgress = new Vector.<int>(6);
      }
      
      public function get TasksProgress() : Vector.<int>
      {
         return this.FTasksProgress;
      }
      
      public function set TasksProgress(param1:Vector.<int>) : void
      {
         this.FTasksProgress = param1;
      }
      
      public function get Bags() : Vector.<TInventories>
      {
         return this.FBags;
      }
      
      public function set Bags(param1:Vector.<TInventories>) : void
      {
         this.FBags = param1;
      }
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function set Score(param1:uint) : void
      {
         this.FScore = param1;
      }
      
      public function get Config() : THDNewYear2017Task
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDNewYear2017Task) : void
      {
         this.FConfig = param1;
      }
      
      public function get BagStatus() : Vector.<int>
      {
         return this.FBagStatus;
      }
      
      public function set BagStatus(param1:Vector.<int>) : void
      {
         this.FBagStatus = param1;
      }
   }
}

