package Processors.Game.MiniBattle.Mode
{
   import Logics.SLogicsCore;
   
   public class TMiniBattleInfor
   {
      
      protected var FBattleType:int;
      
      protected var FBattleID:int;
      
      protected var FAddInfor:Vector.<int>;
      
      protected var FBattleResult:int;
      
      protected var FSoliderRewards:Vector.<TSoliderReward>;
      
      protected var FOneScreenBattles:Vector.<TOneScreenBattle>;
      
      protected var FMapID:uint;
      
      public function TMiniBattleInfor()
      {
         super();
         this.FOneScreenBattles = new Vector.<TOneScreenBattle>();
         this.FSoliderRewards = new Vector.<TSoliderReward>();
      }
      
      public function get BattleType() : int
      {
         return this.FBattleType;
      }
      
      public function set BattleType(param1:int) : void
      {
         this.FBattleType = param1;
      }
      
      public function get BattleCount() : int
      {
         return this.FOneScreenBattles.length;
      }
      
      public function get OneScreenBattles() : Vector.<TOneScreenBattle>
      {
         return this.FOneScreenBattles;
      }
      
      public function get BattleID() : int
      {
         return this.FBattleID;
      }
      
      public function set BattleID(param1:int) : void
      {
         this.FBattleID = param1;
      }
      
      public function get BattleResult() : int
      {
         return this.FBattleResult;
      }
      
      public function set BattleResult(param1:int) : void
      {
         this.FBattleResult = param1;
      }
      
      public function get SoliderRewards() : Vector.<TSoliderReward>
      {
         return this.FSoliderRewards;
      }
      
      public function get MapID() : uint
      {
         return this.FMapID;
      }
      
      public function set MapID(param1:uint) : void
      {
         this.FMapID = param1;
      }
      
      public function get AddInfor() : Vector.<int>
      {
         return this.FAddInfor;
      }
      
      public function set AddInfor(param1:Vector.<int>) : void
      {
         this.FAddInfor = param1;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FOneScreenBattles.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FOneScreenBattles[_loc1_].Reset();
            SLogicsCore.PoolMiniBattle.Release(this.FOneScreenBattles[_loc1_]);
            _loc1_++;
         }
         this.FOneScreenBattles.length = 0;
         _loc2_ = int(this.FSoliderRewards.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSoliderRewards[_loc1_].Reset();
            SLogicsCore.PoolMiniBattle.Release(this.FSoliderRewards[_loc1_]);
            _loc1_++;
         }
         this.FSoliderRewards.length = 0;
      }
   }
}

