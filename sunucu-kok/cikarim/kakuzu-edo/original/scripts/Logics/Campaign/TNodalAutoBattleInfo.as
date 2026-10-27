package Logics.Campaign
{
   import Logics.Campaign.AutoBattle.TTurnResult;
   
   public class TNodalAutoBattleInfo
   {
      
      protected var FBattleID:int;
      
      protected var FTotleCount:int;
      
      protected var FCostTimer:uint;
      
      protected var FIsWorldLevel:Boolean;
      
      protected var FBattleResult:Vector.<TTurnResult>;
      
      public function TNodalAutoBattleInfo()
      {
         super();
         this.FBattleResult = new Vector.<TTurnResult>();
      }
      
      public function get BattleID() : int
      {
         return this.FBattleID;
      }
      
      public function set BattleID(param1:int) : void
      {
         this.FBattleID = param1;
      }
      
      public function get TotleCount() : int
      {
         return this.FTotleCount;
      }
      
      public function set TotleCount(param1:int) : void
      {
         this.FTotleCount = param1;
      }
      
      public function get CostTimer() : uint
      {
         return this.FCostTimer;
      }
      
      public function set CostTimer(param1:uint) : void
      {
         this.FCostTimer = param1;
      }
      
      public function get IsWorldLevel() : Boolean
      {
         return this.FIsWorldLevel;
      }
      
      public function set IsWorldLevel(param1:Boolean) : void
      {
         this.FIsWorldLevel = param1;
      }
      
      public function get BattleResult() : Vector.<TTurnResult>
      {
         return this.FBattleResult;
      }
      
      public function set BattleResult(param1:Vector.<TTurnResult>) : void
      {
         this.FBattleResult = param1;
      }
   }
}

