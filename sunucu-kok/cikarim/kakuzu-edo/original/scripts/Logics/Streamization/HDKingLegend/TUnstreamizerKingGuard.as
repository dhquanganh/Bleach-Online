package Logics.Streamization.HDKingLegend
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDKingGuard;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDKingLegend.TActivityKingGuardData;
   
   public class TUnstreamizerKingGuard extends TUnstreamizer
   {
      
      public function TUnstreamizerKingGuard()
      {
         super();
      }
      
      private function CoreConfigValue(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityInitRetData = null;
         var _loc7_:TActivityKingGuardData = null;
         var _loc8_:THDKingGuard = null;
         _loc6_ = param1 as TActivityInitRetData;
         _loc7_ = param2 as TActivityKingGuardData;
         _loc8_ = param3 as THDKingGuard;
         _loc5_ = int(_loc8_.KingIndexs.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_.AddChip(_loc8_.GetGuardType(_loc4_),0);
            _loc4_++;
         }
      }
      
      private function UnstreamizationPerform_InitData(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TActivityInitRetData = null;
         var _loc9_:TActivityKingGuardData = null;
         var _loc10_:THDKingGuard = null;
         var _loc11_:THDBoxStateData = null;
         _loc8_ = param1 as TActivityInitRetData;
         _loc9_ = param2 as TActivityKingGuardData;
         _loc10_ = param3 as THDKingGuard;
         if(_loc8_.AllBox.length == 0)
         {
            return;
         }
         _loc9_.CurDay = _loc8_.ParameterVec[0];
         _loc5_ = int(_loc8_.AllBox.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc11_ = _loc8_.AllBox[_loc4_];
            if(_loc11_.BoxIndex == _loc10_.TotalFreeIndex)
            {
               _loc9_.FreeCount = _loc11_.State;
            }
            else if(_loc11_.BoxIndex == _loc10_.GameStatusIndex)
            {
               _loc9_.CurGuard = _loc11_.State;
            }
            else
            {
               _loc7_ = int(_loc10_.KingIndexs.length);
               _loc6_ = 0;
               while(_loc6_ < _loc7_)
               {
                  if(_loc11_.BoxIndex == _loc10_.GetGuardType(_loc6_))
                  {
                     _loc9_.AddChip(_loc10_.GetGuardType(_loc6_),_loc11_.State);
                     break;
                  }
                  if(_loc11_.BoxIndex == _loc10_.KingIndexs[_loc6_])
                  {
                     _loc9_.SetExchange(_loc10_.GetGuardType(_loc6_),_loc11_.State);
                     break;
                  }
                  _loc6_++;
               }
            }
            _loc4_++;
         }
      }
      
      public function UnstreamizeInitActivity(param1:Object, param2:Object, param3:Object) : void
      {
         this.CoreConfigValue(param1,param2,param3);
         this.UnstreamizationPerform_InitData(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityKingGuardData = null;
         var _loc7_:THDKingGuard = null;
         var _loc8_:TActAwardStatusInfo = null;
         var _loc9_:THDBoxStateData = null;
         _loc8_ = param1;
         _loc6_ = param2 as TActivityKingGuardData;
         _loc7_ = param3 as THDKingGuard;
         _loc6_.IsResult = false;
         if(_loc8_.Index == _loc7_.TotalFreeIndex)
         {
            _loc6_.FreeCount = _loc8_.Status;
         }
         else if(_loc8_.Index == _loc7_.GameStatusIndex)
         {
            _loc6_.CurGuard = _loc8_.Status;
         }
         else if(_loc8_.Index == _loc7_.GameIndex)
         {
            _loc6_.Result = _loc8_.Status;
            _loc6_.IsResult = true;
         }
         else if(_loc8_.Index == _loc7_.LastResultIndex)
         {
            _loc6_.LastGameStatus = _loc8_.Status;
         }
         else
         {
            _loc4_ = int(_loc7_.KingIndexs.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               if(_loc8_.Index == _loc7_.GetGuardType(_loc5_))
               {
                  _loc6_.AddChip(_loc7_.GetGuardType(_loc5_),_loc8_.Status);
                  break;
               }
               if(_loc8_.Index == _loc7_.KingIndexs[_loc5_])
               {
                  _loc6_.SetExchange(_loc7_.GetGuardType(_loc5_),_loc8_.Status);
                  break;
               }
               if(_loc8_.Index == _loc7_.ChipIds[_loc5_])
               {
                  _loc6_.AddChip(_loc7_.GetGuardType(_loc5_),_loc8_.Status);
               }
               _loc5_++;
            }
         }
      }
   }
}

