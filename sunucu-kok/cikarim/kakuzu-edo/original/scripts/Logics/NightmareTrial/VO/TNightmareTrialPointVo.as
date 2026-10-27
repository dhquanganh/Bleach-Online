package Logics.NightmareTrial.VO
{
   import Logics.DatebaseVO.VO.TNightmareTrialPointConfig;
   
   public class TNightmareTrialPointVo
   {
      
      public static const MAXHP:uint = 100;
      
      public static const EFFECT_GRAY:int = 1 << 0;
      
      public static const EFFECT_MOUSE:int = 1 << 1;
      
      public static const EFFECT_KNIFE:int = 1 << 2;
      
      public static const EFFECT_DEATH:int = 1 << 3;
      
      protected var FRoleTempleteID:uint;
      
      protected var FIndex:uint;
      
      protected var FIsPass:Boolean;
      
      protected var FEnemys:TNightmareTrialEnemyVo;
      
      protected var FNightmareTrialPointInfo:TNightmareTrialPointConfig;
      
      protected var FState:int;
      
      public function TNightmareTrialPointVo()
      {
         super();
         this.FEnemys = new TNightmareTrialEnemyVo();
      }
      
      public function get RoleTempleteID() : int
      {
         return this.FRoleTempleteID;
      }
      
      public function set RoleTempleteID(param1:int) : void
      {
         this.FRoleTempleteID = param1;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
      
      public function get IsPass() : Boolean
      {
         return this.FIsPass;
      }
      
      public function set IsPass(param1:Boolean) : void
      {
         this.FIsPass = param1;
      }
      
      public function get Enemys() : TNightmareTrialEnemyVo
      {
         return this.FEnemys;
      }
      
      public function set Enemys(param1:TNightmareTrialEnemyVo) : void
      {
         this.FEnemys = param1;
      }
      
      public function get NightmareTrialPointInfo() : TNightmareTrialPointConfig
      {
         return this.FNightmareTrialPointInfo;
      }
      
      public function set NightmareTrialPointInfo(param1:TNightmareTrialPointConfig) : void
      {
         this.FNightmareTrialPointInfo = param1;
      }
      
      public function get State() : int
      {
         return this.FState;
      }
      
      public function set State(param1:int) : void
      {
         this.FState = param1;
      }
   }
}

