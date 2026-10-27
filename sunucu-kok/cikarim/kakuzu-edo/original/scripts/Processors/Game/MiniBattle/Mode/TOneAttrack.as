package Processors.Game.MiniBattle.Mode
{
   public class TOneAttrack
   {
      
      protected var FMyBloodChangeValue:Number;
      
      protected var FEnemyBloodChangeValue:Number;
      
      protected var FAtrrackRoleCamp:int;
      
      protected var FCurrentTurn:int;
      
      protected var FTotalTurn:int;
      
      protected var FHaveNext:Boolean;
      
      public function TOneAttrack()
      {
         super();
      }
      
      public function get MyBloodChangeValue() : Number
      {
         return this.FMyBloodChangeValue;
      }
      
      public function set MyBloodChangeValue(param1:Number) : void
      {
         this.FMyBloodChangeValue = param1;
      }
      
      public function get EnemyBloodChangeValue() : Number
      {
         return this.FEnemyBloodChangeValue;
      }
      
      public function set EnemyBloodChangeValue(param1:Number) : void
      {
         this.FEnemyBloodChangeValue = param1;
      }
      
      public function get AtrrackRoleCamp() : int
      {
         return this.FAtrrackRoleCamp;
      }
      
      public function set AtrrackRoleCamp(param1:int) : void
      {
         this.FAtrrackRoleCamp = param1;
      }
      
      public function get CurrentTurn() : int
      {
         return this.FCurrentTurn;
      }
      
      public function set CurrentTurn(param1:int) : void
      {
         this.FCurrentTurn = param1;
      }
      
      public function get TotalTurn() : int
      {
         return this.FTotalTurn;
      }
      
      public function set TotalTurn(param1:int) : void
      {
         this.FTotalTurn = param1;
      }
      
      public function get HaveNext() : Boolean
      {
         return this.FHaveNext;
      }
      
      public function set HaveNext(param1:Boolean) : void
      {
         this.FHaveNext = param1;
      }
      
      public function Reset() : void
      {
         this.FMyBloodChangeValue = 0;
         this.FEnemyBloodChangeValue = 0;
         this.FAtrrackRoleCamp = 0;
         this.FCurrentTurn = 0;
         this.FTotalTurn = 0;
      }
   }
}

