package Logics.Streamization.Battle
{
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.Battle.model.TRoleBattleInfo;
   import Resources.Constants.CONST_BATTLE;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerRoleBattleInfo extends TUnstreamizer
   {
      
      private var FUnstreamizerRoleBattleInfo:TUnstreamizerRoleBattleInfo;
      
      public function TUnstreamizerRoleBattleInfo()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TRoleBattleInfo = null;
         _loc4_ = param2 as TRoleBattleInfo;
         _loc4_.Pos = param1.readByte();
         _loc4_.RoleId = param1.readUnsignedInt();
         _loc4_.Quality = param1.readByte();
         _loc4_.RoleLevel = param1.readShort();
         _loc4_.CurHealth = TUnstreamizerBattleRepot.CurBattleDataVersion >= 4 ? param1.readDouble() : param1.readInt();
         _loc4_.StartHealth = _loc4_.CurHealth;
         _loc4_.TotleHealth = TUnstreamizerBattleRepot.CurBattleDataVersion >= 4 ? param1.readDouble() : param1.readInt();
         _loc4_.CurAnger = param1.readInt();
         _loc4_.StartAnger = _loc4_.CurAnger;
         _loc4_.TotleAnger = 100;
         _loc4_.SkillId = param1.readInt();
         _loc4_.RoleName = TUtilityString.FetchUTF(param1);
         if(TUnstreamizerBattleRepot.CurBattleDataVersion > CONST_BATTLE.BATTLE_VERSION_2_0)
         {
            _loc4_.RebirthNum = param1.readByte();
         }
      }
   }
}

