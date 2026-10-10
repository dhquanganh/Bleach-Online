package Logics.Battle.model
{
   import Debugging.*;
   import flash.utils.*;
   
   public class TRoleBattleInfo
   {
      
      protected var FCamp:int;
      
      protected var FPos:int;
      
      protected var FRoleId:int;
      
      protected var FCurHealth:Number;
      
      protected var FTotleHealth:Number;
      
      protected var FCurAnger:int;
      
      protected var FTotleAnger:int;
      
      protected var FSkillId:int;
      
      protected var FRoleLevel:int;
      
      protected var FRoleName:String;
      
      protected var FQuality:int;
      
      protected var FRebirthNum:int;
      
      protected var FStartHealth:Number;
      
      protected var FStartAnger:int;
      
      public function TRoleBattleInfo(param1:int)
      {
         super();
         this.FCamp = param1;
         this.FTotleAnger = 100;
         this.FQuality = 1;
      }
      
      public function get Camp() : int
      {
         return this.FCamp;
      }
      
      public function set Camp(param1:int) : void
      {
         this.FCamp = param1;
      }
      
      public function get Pos() : int
      {
         return this.FPos;
      }
      
      public function set Pos(param1:int) : void
      {
         this.FPos = param1;
      }
      
      public function get RoleId() : int
      {
         return this.FRoleId;
      }
      
      public function set RoleId(param1:int) : void
      {
         this.FRoleId = param1;
      }
      
      public function get CurHealth() : Number
      {
         return this.FCurHealth;
      }
      
      public function set CurHealth(param1:Number) : void
      {
         this.FCurHealth = param1;
      }
      
      public function get TotleHealth() : Number
      {
         return this.FTotleHealth;
      }
      
      public function set TotleHealth(param1:Number) : void
      {
         this.FTotleHealth = param1;
      }
      
      public function get CurAnger() : int
      {
         return this.FCurAnger;
      }
      
      public function set CurAnger(param1:int) : void
      {
         this.FCurAnger = param1;
      }
      
      public function get TotleAnger() : int
      {
         return this.FTotleAnger;
      }
      
      public function set TotleAnger(param1:int) : void
      {
         this.FTotleAnger = param1;
      }
      
      public function get SkillId() : int
      {
         return this.FSkillId;
      }
      
      public function set SkillId(param1:int) : void
      {
         this.FSkillId = param1;
      }
      
      public function get RoleLevel() : int
      {
         return this.FRoleLevel;
      }
      
      public function set RoleLevel(param1:int) : void
      {
         this.FRoleLevel = param1;
      }
      
      public function get RoleName() : String
      {
         return this.FRoleName;
      }
      
      public function set RoleName(param1:String) : void
      {
         this.FRoleName = param1;
      }
      
      public function get Quality() : int
      {
         return this.FQuality;
      }
      
      public function set Quality(param1:int) : void
      {
         this.FQuality = param1;
      }
      
      public function get StartHealth() : Number
      {
         return this.FStartHealth;
      }
      
      public function set StartHealth(param1:Number) : void
      {
         this.FStartHealth = param1;
      }
      
      public function get StartAnger() : int
      {
         return this.FStartAnger;
      }
      
      public function set StartAnger(param1:int) : void
      {
         this.FStartAnger = param1;
      }
      
      public function get RebirthNum() : int
      {
         return this.FRebirthNum;
      }
      
      public function set RebirthNum(param1:int) : void
      {
         this.FRebirthNum = param1;
      }
      
      public function Clone(param1:int) : TRoleBattleInfo
      {
         var _loc2_:TRoleBattleInfo = null;
         _loc2_ = new TRoleBattleInfo(param1);
         _loc2_.Pos = this.FPos;
         _loc2_.RoleId = this.FRoleId;
         _loc2_.CurHealth = this.FCurHealth;
         _loc2_.TotleHealth = this.FTotleHealth;
         _loc2_.CurAnger = this.FCurAnger;
         _loc2_.TotleAnger = this.FTotleAnger;
         _loc2_.SkillId = this.FSkillId;
         _loc2_.RoleLevel = this.FRoleLevel;
         _loc2_.RoleName = this.FRoleName;
         _loc2_.Quality = this.FQuality;
         _loc2_.StartHealth = this.FStartHealth;
         _loc2_.StartAnger = this.FStartAnger;
         _loc2_.RebirthNum = this.FRebirthNum;
         return _loc2_;
      }
      
      public function Reset() : void
      {
         this.FCamp = 0;
         this.FPos = 0;
         this.FRoleId = 0;
         this.FCurHealth = 0;
         this.FTotleHealth = 0;
         this.FCurAnger = 0;
         this.FTotleAnger = 0;
         this.FSkillId = 0;
         this.FRoleLevel = 0;
         this.FRoleName = "";
         this.FQuality = 0;
         this.FStartHealth = 0;
         this.FStartAnger = 0;
         this.FRebirthNum = 0;
      }
      
      public function SetDataByObj(param1:Object) : void
      {
         this.FCamp = param1.Camp;
         this.FPos = param1.Pos;
         this.FRoleId = param1.RoleId;
         this.FCurHealth = param1.CurHealth;
         this.FTotleHealth = param1.TotleHealth;
         this.FCurAnger = param1.CurAnger;
         this.FTotleAnger = param1.TotleAnger;
         this.FSkillId = param1.SkillId;
         this.FRoleLevel = param1.RoleLevel;
         this.FRoleName = param1.RoleName;
         this.FQuality = param1.Quality;
         this.FRebirthNum = param1.RebirthNum;
      }
      
      public function toString() : String
      {
         return " { \"Camp\":" + this.FCamp + ", \"Pos\":" + this.FPos + ", \"RoleId\":" + this.FRoleId + ", \"CurHealth\":" + this.FStartHealth + ", \"TotleHealth\":" + this.FTotleHealth + ", \"CurAnger\":" + this.FStartAnger + ", \"TotleAnger\":" + this.FTotleAnger + ", \"SkillId\":" + this.FSkillId + ", \"RoleLevel\":" + this.FRoleLevel + ", \"RoleName\":\"" + this.FRoleName + "\", \"Quality\":" + this.FQuality + ", \"RebirthNum\":" + this.FRebirthNum + "}";
      }
   }
}

