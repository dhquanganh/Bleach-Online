package Logics.Organization.VO
{
   import Logics.DatebaseVO.VO.TOrgPointInfo;
   
   public class TPointInfoVO
   {
      
      public static const MAXHP:uint = 100;
      
      public static const EFFECT_GRAY:int = 1 << 0;
      
      public static const EFFECT_MOUSE:int = 1 << 1;
      
      public static const EFFECT_KNIFE:int = 1 << 2;
      
      public static const EFFECT_DEATH:int = 1 << 3;
      
      public static const STATE_ALLOWPLAY_SINGLE:int = EFFECT_MOUSE;
      
      public static const STATE_NOTPLAY_SINGLE:int = EFFECT_GRAY;
      
      public static const STATE_DIE_GROUP:int = EFFECT_DEATH;
      
      public static const STATE_PLAYING_GROUP:int = EFFECT_KNIFE | EFFECT_MOUSE;
      
      public static const STATE_NOTPLAY_GROUP:int = EFFECT_GRAY;
      
      protected var FPointInfo:TOrgPointInfo;
      
      protected var FRoleTempleteID:uint;
      
      protected var FFightCount:uint;
      
      protected var FResetCount:uint;
      
      protected var FState:uint;
      
      protected var FIndex:uint;
      
      protected var FPass:Boolean;
      
      protected var FHP:uint;
      
      protected var FEnemys:Vector.<TEnemyVO>;
      
      public function TPointInfoVO()
      {
         super();
         this.FState = STATE_ALLOWPLAY_SINGLE;
         this.FEnemys = new Vector.<TEnemyVO>();
      }
      
      public function get PointInfo() : TOrgPointInfo
      {
         return this.FPointInfo;
      }
      
      public function set PointInfo(param1:TOrgPointInfo) : void
      {
         this.FPointInfo = param1;
      }
      
      public function get RoleTempleteID() : uint
      {
         return this.FRoleTempleteID;
      }
      
      public function set RoleTempleteID(param1:uint) : void
      {
         this.FRoleTempleteID = param1;
      }
      
      public function get State() : uint
      {
         return this.FState;
      }
      
      public function set State(param1:uint) : void
      {
         this.FState = param1;
      }
      
      public function get FightCount() : uint
      {
         return this.FFightCount;
      }
      
      public function set FightCount(param1:uint) : void
      {
         this.FFightCount = param1;
      }
      
      public function get ResetCount() : uint
      {
         return this.FResetCount;
      }
      
      public function set ResetCount(param1:uint) : void
      {
         this.FResetCount = param1;
      }
      
      public function get Index() : uint
      {
         return this.FIndex;
      }
      
      public function set Index(param1:uint) : void
      {
         this.FIndex = param1;
      }
      
      public function get Pass() : Boolean
      {
         return this.FPass;
      }
      
      public function set Pass(param1:Boolean) : void
      {
         this.FPass = param1;
      }
      
      public function get Enemys() : Vector.<TEnemyVO>
      {
         return this.FEnemys;
      }
      
      public function set Enemys(param1:Vector.<TEnemyVO>) : void
      {
         this.FEnemys = param1;
      }
      
      public function get HP() : uint
      {
         return this.FHP;
      }
      
      public function set HP(param1:uint) : void
      {
         this.FHP = param1;
      }
   }
}

