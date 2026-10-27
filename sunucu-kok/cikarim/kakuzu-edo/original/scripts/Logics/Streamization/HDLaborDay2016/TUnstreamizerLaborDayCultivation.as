package Logics.Streamization.HDLaborDay2016
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDLaborDayCultivation;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDLaborDay2016.TLaborDayCultivation;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerLaborDayCultivation extends TUnstreamizer
   {
      
      public function TUnstreamizerLaborDayCultivation()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TLaborDayCultivation) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         _loc3_ = uint(param1.Config.Gift.awardId.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.Gift.awardId[_loc2_]);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.Gifts[_loc2_] = _loc5_;
            _loc2_++;
         }
      }
      
      protected function Core(param1:uint, param2:Object, param3:TLaborDayCultivation) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDLaborDayCultivation = null;
         var _loc8_:uint = 0;
         _loc7_ = param3.Config;
         if(param1 == _loc7_.Water.index)
         {
            param3.WaterCount = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.Weeding.index)
         {
            param3.WeedingCount = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.Score)
         {
            param3.Score = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.Gift.index)
         {
            _loc6_ = uint(_loc7_.Gift.awardId.length);
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               param3.BagStatus[_loc5_] = TUtilityTool.GetValueByBit(TUtilityTool.ActState(param2),_loc5_);
               _loc5_++;
            }
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:uint = 0;
         var _loc8_:TLaborDayCultivation = null;
         var _loc9_:THDLaborDayCultivation = null;
         _loc8_ = param2 as TLaborDayCultivation;
         _loc9_ = param3 as THDLaborDayCultivation;
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
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:TLaborDayCultivation = null;
         var _loc5_:THDLaborDayCultivation = null;
         _loc4_ = param2 as TLaborDayCultivation;
         _loc5_ = param3 as THDLaborDayCultivation;
         if(param1.Index == 99)
         {
            SToolReward.ShowMessage(_loc5_.Text + param1.Status);
         }
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

