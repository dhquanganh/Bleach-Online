package Logics.Streamization.NewYear2017
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDNewYear2017Task;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYear2017.TNewYear2017Task;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   
   public class TUnstreamizerNYTask extends TUnstreamizer
   {
      
      public function TUnstreamizerNYTask()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TNewYear2017Task) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         _loc3_ = 1;
         _loc5_ = new TInventories();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.Config.ThreeAward;
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            _loc2_++;
         }
         param1.Bags[0] = _loc5_;
         _loc3_ = 1;
         _loc5_ = new TInventories();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.Config.SixAward;
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            _loc2_++;
         }
         param1.Bags[1] = _loc5_;
      }
      
      protected function Core(param1:uint, param2:Object, param3:TNewYear2017Task) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDNewYear2017Task = null;
         var _loc8_:uint = 0;
         _loc7_ = param3.Config;
         if(param1 == _loc7_.ScoreIndex)
         {
            param3.Score = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.ThreeIndex)
         {
            param3.BagStatus[0] = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.SixIndex)
         {
            param3.BagStatus[1] = TUtilityTool.ActState(param2);
         }
         else if(param1 >= _loc7_.Tasks[0].index && param1 <= _loc7_.Tasks[5].index)
         {
            param3.TasksProgress[param1 - 1] = TUtilityTool.ActState(param2);
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:uint = 0;
         var _loc8_:TNewYear2017Task = null;
         var _loc9_:THDNewYear2017Task = null;
         _loc8_ = param2 as TNewYear2017Task;
         _loc9_ = param3 as THDNewYear2017Task;
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
         var _loc4_:TNewYear2017Task = null;
         var _loc5_:THDNewYear2017Task = null;
         _loc4_ = param2 as TNewYear2017Task;
         _loc5_ = param3 as THDNewYear2017Task;
         if(param1.Index == _loc5_.ScoreIndex && param1.Status - _loc4_.Score > 0)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Integral) + "*" + (param1.Status - _loc4_.Score));
         }
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

