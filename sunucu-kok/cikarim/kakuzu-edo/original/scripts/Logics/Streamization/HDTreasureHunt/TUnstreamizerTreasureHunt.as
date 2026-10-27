package Logics.Streamization.HDTreasureHunt
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDTreasureHunt;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDTreasureHunt.TTreasureHunt;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerTreasureHunt extends TUnstreamizer
   {
      
      public function TUnstreamizerTreasureHunt()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TTreasureHunt) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         _loc3_ = 12;
         _loc5_ = new TInventories();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = uint(param1.Config.Items[_loc2_].awardId);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            _loc2_++;
         }
         param1.Invs = _loc5_;
      }
      
      protected function Core(param1:uint, param2:Object, param3:TTreasureHunt) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDTreasureHunt = null;
         var _loc8_:uint = 0;
         _loc7_ = param3.Config;
         if(param1 == _loc7_.UTCIndex)
         {
            param3.CurTime = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.VipIndex)
         {
            param3.CurMap = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.ItemIndex)
         {
            param3.CurItem = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.TimeIndex)
         {
            param3.CurLevel = TUtilityTool.ActState(param2);
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:uint = 0;
         var _loc8_:TTreasureHunt = null;
         var _loc9_:THDTreasureHunt = null;
         _loc8_ = param2 as TTreasureHunt;
         _loc9_ = param3 as THDTreasureHunt;
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
         var _loc4_:TTreasureHunt = null;
         var _loc5_:THDTreasureHunt = null;
         _loc4_ = param2 as TTreasureHunt;
         _loc5_ = param3 as THDTreasureHunt;
         if(param1.Index == _loc5_.Score)
         {
            SToolReward.ShowMessage(_loc5_.Hint + ":1");
         }
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

