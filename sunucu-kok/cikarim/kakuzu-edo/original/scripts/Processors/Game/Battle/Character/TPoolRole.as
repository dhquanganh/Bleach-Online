package Processors.Game.Battle.Character
{
   import Foundation.UI.TUIComponent;
   import Logics.Battle.model.TRoleBattleInfo;
   import Processors.Game.Battle.TBattleStage;
   
   public class TPoolRole
   {
      
      protected static var FPoolActive:Vector.<TActive> = new Vector.<TActive>();
      
      protected static var FPoolRole:Vector.<TRole> = new Vector.<TRole>();
      
      public function TPoolRole()
      {
         super();
      }
      
      public static function GetActive(param1:TUIComponent, param2:uint, param3:Boolean = true, param4:Boolean = false) : TActive
      {
         var _loc5_:TActive = null;
         if(FPoolActive.length > 0)
         {
            _loc5_ = FPoolActive.pop();
            _loc5_.ResetActive(param1,param2,param3,param4);
         }
         else
         {
            _loc5_ = new TActive(param1,param2,param3,param4);
         }
         return _loc5_;
      }
      
      public static function SaveActive(param1:TActive) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(FPoolActive.indexOf(param1) >= 0)
         {
            return;
         }
         if(Boolean(param1) && Boolean(param1.parent))
         {
            param1.parent.removeChild(param1);
         }
         FPoolActive.push(param1);
      }
      
      public static function GetRole(param1:TUIComponent, param2:TRoleBattleInfo, param3:TBattleStage, param4:Function = null) : TRole
      {
         var _loc5_:TRole = null;
         if(FPoolRole.length > 0)
         {
            _loc5_ = FPoolRole.pop();
            _loc5_.ResetRole(param1,param2,param3,param4);
         }
         else
         {
            _loc5_ = new TRole(param1,param2,param3,param4);
         }
         return _loc5_;
      }
      
      public static function SaveRole(param1:TRole) : void
      {
         var _loc2_:int = 0;
         if(param1 == null)
         {
            return;
         }
         if(param1.parent)
         {
            param1.parent.removeChild(param1);
         }
         param1.Reset();
         _loc2_ = FPoolRole.indexOf(param1);
         if(_loc2_ >= 0)
         {
            return;
         }
         FPoolRole.push(param1);
      }
   }
}

