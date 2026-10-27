package Logics.Streamization.HDSoulCarnival
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDSoulDraw;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDSoulCarnival.TSoulDraw;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerSoulDraw extends TUnstreamizer
   {
      
      public function TUnstreamizerSoulDraw()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TSoulDraw) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         _loc3_ = param1.Config.FreeAward.length;
         _loc5_ = new TInventories();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = uint(param1.Config.FreeAward[_loc2_].award);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            _loc2_++;
         }
         param1.ShowFreeAward = _loc5_;
         _loc3_ = param1.Config.GoldAward.length;
         _loc5_ = new TInventories();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = uint(param1.Config.GoldAward[_loc2_].award);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            _loc2_++;
         }
         param1.ShowGoldAward = _loc5_;
      }
      
      protected function Core(param1:uint, param2:Object, param3:TSoulDraw) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:THDSoulDraw = null;
         var _loc6_:TInventories = null;
         _loc5_ = param3.Config;
         if(param1 == 0)
         {
            _loc6_ = new TInventories();
            param3.CurGoldAward.Clear();
            SToolReward.GetAwardsByAwardID(param3.Config.GoldAward[TUtilityTool.ActState(param2) - 1].award,_loc6_);
            param3.CurGoldAward.Add(_loc6_.GetInventoryByIndex(0));
            param3.CurGoldIndex = TUtilityTool.ActState(param2) - 1;
         }
         else if(param1 == 1)
         {
            _loc6_ = new TInventories();
            SToolReward.GetAwardsByAwardID(param3.Config.FreeAward[TUtilityTool.ActState(param2) - 21].award,_loc6_);
            param3.CurFreeAward[0] = _loc6_.GetInventoryByIndex(0);
         }
         else if(param1 == 2)
         {
            _loc6_ = new TInventories();
            SToolReward.GetAwardsByAwardID(param3.Config.FreeAward[TUtilityTool.ActState(param2) - 21].award,_loc6_);
            param3.CurFreeAward[1] = _loc6_.GetInventoryByIndex(0);
         }
         else if(param1 == 3)
         {
            _loc6_ = new TInventories();
            SToolReward.GetAwardsByAwardID(param3.Config.FreeAward[TUtilityTool.ActState(param2) - 21].award,_loc6_);
            param3.CurFreeAward[2] = _loc6_.GetInventoryByIndex(0);
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:uint = 0;
         var _loc8_:TSoulDraw = null;
         var _loc9_:THDSoulDraw = null;
         _loc8_ = param2 as TSoulDraw;
         _loc9_ = param3 as THDSoulDraw;
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
         var _loc4_:TSoulDraw = null;
         var _loc5_:THDSoulDraw = null;
         _loc4_ = param2 as TSoulDraw;
         _loc5_ = param3 as THDSoulDraw;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

