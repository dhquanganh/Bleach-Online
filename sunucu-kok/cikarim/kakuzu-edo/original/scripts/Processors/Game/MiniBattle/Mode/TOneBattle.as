package Processors.Game.MiniBattle.Mode
{
   import Logics.SLogicsCore;
   
   public class TOneBattle
   {
      
      protected var FBattleResult:int;
      
      protected var FBattleReportAddr:String;
      
      protected var FEnemyID:uint;
      
      protected var FSoldierFriend:TBattleSoldierInfor;
      
      protected var FSoldierEnemy:TBattleSoldierInfor;
      
      protected var FAttackRecord:Vector.<TOneAttrack>;
      
      protected var FTotalTurn:int;
      
      public function TOneBattle()
      {
         super();
         this.FAttackRecord = new Vector.<TOneAttrack>();
         this.FSoldierFriend = new TBattleSoldierInfor();
         this.FSoldierEnemy = new TBattleSoldierInfor();
      }
      
      public function get Count() : int
      {
         return this.FAttackRecord.length;
      }
      
      public function get BattleResult() : int
      {
         return this.FBattleResult;
      }
      
      public function set BattleResult(param1:int) : void
      {
         this.FBattleResult = param1;
      }
      
      public function get SoldierFriend() : TBattleSoldierInfor
      {
         return this.FSoldierFriend;
      }
      
      public function get SoldierEnemy() : TBattleSoldierInfor
      {
         return this.FSoldierEnemy;
      }
      
      public function get TotalTurn() : int
      {
         return this.FTotalTurn;
      }
      
      public function set TotalTurn(param1:int) : void
      {
         this.FTotalTurn = param1;
      }
      
      public function get AttackRecord() : Vector.<TOneAttrack>
      {
         return this.FAttackRecord;
      }
      
      public function set AttackRecord(param1:Vector.<TOneAttrack>) : void
      {
         this.FAttackRecord = param1;
      }
      
      public function get EnemyID() : uint
      {
         return this.FEnemyID;
      }
      
      public function set EnemyID(param1:uint) : void
      {
         this.FEnemyID = param1;
      }
      
      public function get BattleReportAddr() : String
      {
         return this.FBattleReportAddr;
      }
      
      public function set BattleReportAddr(param1:String) : void
      {
         this.FBattleReportAddr = param1;
      }
      
      public function Add(param1:TOneAttrack) : void
      {
         this.FAttackRecord.push(param1);
      }
      
      public function Clear(param1:TOneAttrack) : void
      {
         this.FAttackRecord.length = 0;
      }
      
      public function GetOneAttrackByIndex(param1:int) : TOneAttrack
      {
         return this.FAttackRecord[param1];
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FSoldierEnemy.Reset();
         this.FSoldierFriend.Reset();
         this.FBattleResult = 0;
         this.FBattleReportAddr = "";
         this.FEnemyID = 0;
         this.FTotalTurn = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAttackRecord[_loc1_].Reset();
            SLogicsCore.PoolMiniBattle.Release(this.FAttackRecord[_loc1_]);
            _loc1_++;
         }
         this.FAttackRecord.length = 0;
      }
   }
}

