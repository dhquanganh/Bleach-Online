package Logics.ExpDuplicate
{
   import Logics.ExpDuplicate.VO.TDuplicateVO;
   import Logics.ExpDuplicate.VO.TExpDupConfigValueVO;
   
   public class TExpDuplicateData
   {
      
      protected var FEnemyArmy:Vector.<TDuplicateVO>;
      
      protected var FRemainBattle:uint;
      
      protected var FConfigValueVO:TExpDupConfigValueVO;
      
      public function TExpDuplicateData()
      {
         super();
         this.FEnemyArmy = new Vector.<TDuplicateVO>();
         this.FConfigValueVO = new TExpDupConfigValueVO();
      }
      
      public function get EnemyArmy() : Vector.<TDuplicateVO>
      {
         return this.FEnemyArmy;
      }
      
      public function get RemainBattle() : uint
      {
         return this.FRemainBattle;
      }
      
      public function set RemainBattle(param1:uint) : void
      {
         this.FRemainBattle = param1;
      }
      
      public function get ConfigValueVO() : TExpDupConfigValueVO
      {
         return this.FConfigValueVO;
      }
      
      public function GetVOByID(param1:uint) : TDuplicateVO
      {
         var _loc2_:TDuplicateVO = null;
         for each(_loc2_ in this.FEnemyArmy)
         {
            if(_loc2_.Config.Identifier == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}

