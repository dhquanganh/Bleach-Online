package Logics.Streamization.OrganizationalWar
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.OrganizationalWar.TOrganizationalWarGoalData;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerOrganizationalWar extends TUnstreamizer
   {
      
      public function TUnstreamizerOrganizationalWar()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TOrganizationalWarGoalData = null;
         var _loc5_:Vector.<uint> = null;
         var _loc6_:Vector.<Object> = null;
         var _loc7_:Array = null;
         var _loc8_:uint = 0;
         var _loc9_:int = 0;
         _loc4_ = param2 as TOrganizationalWarGoalData;
         _loc5_ = this.GetDeployTableByID(60220001) as Vector.<uint>;
         _loc4_.Time_Ready = this.ChangeTimeIntoSecond(_loc5_);
         _loc5_ = this.GetDeployTableByID(60220002) as Vector.<uint>;
         _loc4_.Time_StartSignUp = this.ChangeTimeIntoSecond(_loc5_);
         _loc5_ = this.GetDeployTableByID(60220003) as Vector.<uint>;
         _loc4_.Time_EndSignUp = this.ChangeTimeIntoSecond(_loc5_);
         _loc5_ = this.GetDeployTableByID(60220004) as Vector.<uint>;
         _loc4_.Time_BattleStart = this.ChangeTimeIntoSecond(_loc5_);
         _loc5_ = this.GetDeployTableByID(60220005) as Vector.<uint>;
         _loc4_.Time_BattleEnd = this.ChangeTimeIntoSecond(_loc5_);
         _loc8_ = this.GetDeployTableByID(60220006) as uint;
         _loc4_.Time_CanEnterScene = _loc8_;
         _loc8_ = this.GetDeployTableByID(60220007) as uint;
         _loc4_.DieColdDownTime = _loc8_;
         _loc8_ = this.GetDeployTableByID(60220009) as uint;
         _loc4_.Gold_ClearColdTime = _loc8_;
         _loc5_ = this.GetDeployTableByID(60220010) as Vector.<uint>;
         this.CommbineVector(_loc4_.InspironCost,_loc5_);
         _loc6_ = this.GetDeployTableByID(60220012) as Vector.<Object>;
         _loc9_ = 0;
         while(_loc9_ < _loc6_.length)
         {
            _loc7_ = _loc6_[_loc9_] as Array;
            _loc4_.InspironData.push(_loc7_[2]);
            _loc9_++;
         }
         _loc8_ = this.GetDeployTableByID(60220017) as uint;
         _loc4_.IntervalTime = _loc8_;
         _loc8_ = this.GetDeployTableByID(60220018) as uint;
         _loc4_.MoveTime = _loc8_;
         _loc6_ = this.GetDeployTableByID(60220019) as Vector.<Object>;
         _loc9_ = 0;
         while(_loc9_ < _loc6_.length)
         {
            _loc4_.RoleWinTimes[_loc9_] = new Vector.<uint>();
            this.CommbineArray(_loc4_.RoleWinTimes[_loc9_],_loc6_[_loc9_] as Array);
            _loc9_++;
         }
         _loc5_ = this.GetDeployTableByID(60220020) as Vector.<uint>;
         this.CommbineVector(_loc4_.RoleChangeColors,_loc5_);
      }
      
      protected function CommbineArray(param1:Vector.<uint>, param2:Array) : void
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < param2.length)
         {
            param1.push(param2[_loc3_]);
            _loc3_++;
         }
      }
      
      protected function CommbineVector(param1:Vector.<uint>, param2:Vector.<uint>) : void
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < param2.length)
         {
            param1.push(param2[_loc3_]);
            _loc3_++;
         }
      }
      
      protected function ChangeTimeIntoSecond(param1:Vector.<uint>) : uint
      {
         return param1[0] * 3600 + param1[1] * 60;
      }
      
      protected function GetDeployTableByID(param1:uint) : Object
      {
         var _loc2_:TConfigValue = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,param1) as TConfigValue;
         return _loc2_.Value;
      }
   }
}

