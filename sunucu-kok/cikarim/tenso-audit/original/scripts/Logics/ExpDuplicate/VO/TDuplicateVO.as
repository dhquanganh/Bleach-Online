package Logics.ExpDuplicate.VO
{
   import Logics.DatebaseVO.VO.TExpDuplicate;
   
   public class TDuplicateVO
   {
      
      protected var FEnemyArmyID:uint;
      
      protected var FConfig:TExpDuplicate;
      
      protected var FExp:Number;
      
      protected var FSkillBuff:Vector.<uint>;
      
      protected var FIsOpen:Boolean;
      
      protected var FRefreshCount:uint;
      
      public function TDuplicateVO()
      {
         super();
         this.FSkillBuff = new Vector.<uint>();
      }
      
      public function get EnemyArmyID() : uint
      {
         return this.FEnemyArmyID;
      }
      
      public function set EnemyArmyID(param1:uint) : void
      {
         this.FEnemyArmyID = param1;
      }
      
      public function get Config() : TExpDuplicate
      {
         return this.FConfig;
      }
      
      public function set Config(param1:TExpDuplicate) : void
      {
         this.FConfig = param1;
      }
      
      public function get Exp() : Number
      {
         return this.FExp;
      }
      
      public function set Exp(param1:Number) : void
      {
         this.FExp = param1;
      }
      
      public function get SkillBuff() : Vector.<uint>
      {
         return this.FSkillBuff;
      }
      
      public function get IsOpen() : Boolean
      {
         return this.FIsOpen;
      }
      
      public function set IsOpen(param1:Boolean) : void
      {
         this.FIsOpen = param1;
      }
      
      public function get RefreshCount() : uint
      {
         return this.FRefreshCount;
      }
      
      public function set RefreshCount(param1:uint) : void
      {
         this.FRefreshCount = param1;
      }
   }
}

