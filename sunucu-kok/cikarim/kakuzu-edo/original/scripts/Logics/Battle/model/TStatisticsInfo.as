package Logics.Battle.model
{
   public class TStatisticsInfo
   {
      
      protected var FMyInfoVec:Vector.<TStatisticsVO>;
      
      protected var FEnemyInfoVec:Vector.<TStatisticsVO>;
      
      protected var FMyTotalHurt:int;
      
      protected var FEnemyTotalHurt:int;
      
      public function TStatisticsInfo()
      {
         super();
         this.FMyInfoVec = new Vector.<TStatisticsVO>();
         this.FEnemyInfoVec = new Vector.<TStatisticsVO>();
      }
      
      public function get MyInfoVec() : Vector.<TStatisticsVO>
      {
         return this.FMyInfoVec;
      }
      
      public function get EnemyInfoVec() : Vector.<TStatisticsVO>
      {
         return this.FEnemyInfoVec;
      }
      
      public function get MyTotalHurt() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FMyTotalHurt = 0;
         _loc2_ = int(this.FMyInfoVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMyTotalHurt += this.FMyInfoVec[_loc1_].Hurt;
            _loc1_++;
         }
         return this.FMyTotalHurt;
      }
      
      public function get EnemyTotalHurt() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FEnemyTotalHurt = 0;
         _loc2_ = int(this.FEnemyInfoVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FEnemyTotalHurt += this.FEnemyInfoVec[_loc1_].Hurt;
            _loc1_++;
         }
         return this.FEnemyTotalHurt;
      }
      
      public function Clear() : void
      {
         this.FMyInfoVec.length = 0;
         this.FEnemyInfoVec.length = 0;
      }
   }
}

