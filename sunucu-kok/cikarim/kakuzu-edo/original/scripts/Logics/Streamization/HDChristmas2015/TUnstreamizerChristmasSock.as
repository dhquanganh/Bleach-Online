package Logics.Streamization.HDChristmas2015
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDChristmasSock;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.TActivityServerRank;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDChristmas2015.VO.TActivityChristmasSock;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerChristmasSock extends TUnstreamizer
   {
      
      public function TUnstreamizerChristmasSock()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TActivityChristmasSock) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         var _loc6_:TInventories = null;
         var _loc7_:TInventories = null;
         _loc6_ = new TInventories();
         _loc3_ = param1.Config.TaskAwards.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.TaskAwards[_loc2_].award);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.TaskGifts[_loc2_] = _loc5_;
            _loc7_ = new TInventories();
            SToolReward.GetInventoryByIDAmount(param1.Config.SockItemID,param1.Config.TaskAwards[_loc2_].getSocks,_loc7_);
            param1.TaskGifts[_loc2_].Add(_loc7_.GetInventoryByIndex(0));
            _loc2_++;
         }
         _loc3_ = param1.Config.SockAwards.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.SockAwards[_loc2_].award);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.SocksGift[_loc2_] = _loc5_;
            _loc2_++;
         }
      }
      
      protected function Core(param1:uint, param2:Object, param3:TActivityChristmasSock) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDChristmasSock = null;
         _loc7_ = param3.Config;
         if(param1 == _loc7_.Round)
         {
            param3.Round = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.SockNum)
         {
            param3.SockNum = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.JackPoint.index)
         {
            param3.JackPointStatus = TUtilityTool.ActState(param2);
         }
         _loc6_ = _loc7_.TaskAwards.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = _loc7_.TaskAwards[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.TaskStatus[_loc5_] = TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
         _loc6_ = _loc7_.SockAwards.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = _loc7_.SockAwards[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.SockStatus[_loc5_] = TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:uint = 0;
         var _loc8_:TActivityChristmasSock = null;
         var _loc9_:THDChristmasSock = null;
         _loc8_ = param2 as TActivityChristmasSock;
         _loc9_ = param3 as THDChristmasSock;
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
         _loc8_.RankVec.length = 0;
         if(param1.AddtionalVecs.length > 0)
         {
            _loc7_ = param1.AddtionalVecs[0].length;
            _loc4_ = 0;
            while(_loc4_ < _loc7_)
            {
               _loc8_.RankVec.push(param1.AddtionalVecs[0][_loc4_] as TActivityServerRank);
               _loc4_++;
            }
         }
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:TActivityChristmasSock = null;
         _loc4_ = param2 as TActivityChristmasSock;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

