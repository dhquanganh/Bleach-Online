package Logics.Campaign
{
   public class TNodalAutoMonsterInfo
   {
      
      protected var FCostTime:uint;
      
      protected var FCurAutoCityId:int;
      
      protected var FCurAutoMissionId:int;
      
      protected var FHootMonster:Vector.<TMonster>;
      
      protected var FBattleType:int;
      
      public function TNodalAutoMonsterInfo()
      {
         super();
         this.FHootMonster = new Vector.<TMonster>();
      }
      
      public function get CostTime() : uint
      {
         return this.FCostTime;
      }
      
      public function set CostTime(param1:uint) : void
      {
         this.FCostTime = param1;
      }
      
      public function get CurAutoCityId() : int
      {
         return this.FCurAutoCityId;
      }
      
      public function set CurAutoCityId(param1:int) : void
      {
         this.FCurAutoCityId = param1;
      }
      
      public function get CurAutoMissionId() : int
      {
         return this.FCurAutoMissionId;
      }
      
      public function set CurAutoMissionId(param1:int) : void
      {
         this.FCurAutoMissionId = param1;
      }
      
      public function get HootMonster() : Vector.<TMonster>
      {
         return this.FHootMonster;
      }
      
      public function set HootMonster(param1:Vector.<TMonster>) : void
      {
         this.FHootMonster = param1;
      }
      
      public function set BattleType(param1:int) : void
      {
         this.FBattleType = param1;
      }
      
      public function get BattleType() : int
      {
         return this.FBattleType;
      }
   }
}

