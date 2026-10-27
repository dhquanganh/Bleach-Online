package Logics.Streamization.HDEaster2016
{
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDEaster2016_0;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDEaster2016.THDEasterData2016_0;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerEaster2016_0 extends TUnstreamizer
   {
      
      public function TUnstreamizerEaster2016_0()
      {
         super();
      }
      
      protected function ConfigHandle(param1:THDEasterData2016_0) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         var _loc6_:TInventories = null;
         var _loc7_:TInventories = null;
      }
      
      protected function Core(param1:uint, param2:Object, param3:THDEasterData2016_0) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDEaster2016_0 = null;
         _loc7_ = param3.Config;
         if(param1 == _loc7_.TimeAwardObj.index)
         {
            param3.LastTime = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.TimeAwardIndex)
         {
            param3.TimePeriod = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.Gift00.index)
         {
            param3.Rebirth = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.ServerLimit)
         {
            param3.ServerLimit = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.EggIndex)
         {
            param3.HaveEgg = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.Egg02Index)
         {
            param3.HaveEgg02 = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.Egg03Index)
         {
            param3.HaveEgg03 = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.Gift01.index)
         {
            param3.LastItemlevel_1 = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.Gift02.index)
         {
            param3.LastItemlevel_2 = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.Gift03.index)
         {
            param3.LastItemlevel_3 = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.BigAward.index)
         {
            param3.LastBigAward = TUtilityTool.ActState(param2);
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:uint = 0;
         var _loc8_:THDEasterData2016_0 = null;
         var _loc9_:THDEaster2016_0 = null;
         _loc8_ = param2 as THDEasterData2016_0;
         _loc9_ = param3 as THDEaster2016_0;
         if(_loc8_.Config == null)
         {
            _loc8_.Config = _loc9_;
            this.ConfigHandle(_loc8_);
         }
         _loc5_ = param1.AllBox.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.AllBox[_loc4_];
            this.Core(_loc6_.BoxIndex,_loc6_,_loc8_);
            _loc4_++;
         }
         _loc8_.CurDay = param1.ParameterVec[0];
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:THDEasterData2016_0 = null;
         var _loc5_:THDEaster2016_0 = null;
         _loc4_ = param2 as THDEasterData2016_0;
         _loc5_ = param3 as THDEaster2016_0;
         if(param1.Index == _loc5_.EggIndex)
         {
            if(param1.Status - _loc4_.HaveEgg > 0)
            {
               SToolReward.ShowMessage(TUtilityString.Format(_loc5_.Text,param1.Status - _loc4_.HaveEgg));
            }
         }
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

