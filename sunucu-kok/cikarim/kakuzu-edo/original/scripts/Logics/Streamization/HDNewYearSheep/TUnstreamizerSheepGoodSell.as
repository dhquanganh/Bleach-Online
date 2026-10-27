package Logics.Streamization.HDNewYearSheep
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDSheepGoodSell;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDNewYearSheep.THDSheepGoodSellData;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerSheepGoodSell extends TUnstreamizer
   {
      
      public function TUnstreamizerSheepGoodSell()
      {
         super();
      }
      
      protected function AssignActivityData(param1:int, param2:int, param3:THDSheepGoodSellData) : void
      {
         var _loc4_:int = 0;
         _loc4_ = param3.SheepGoodSellVO.ActAwardIndex.indexOf(param1);
         if(_loc4_ >= 0)
         {
            param3.ActAwardBuyFlag[_loc4_] = param2;
            return;
         }
         if(param3.SheepGoodSellVO.LoadingAwardIndex == param1)
         {
            param3.LoadingAwardReciveFlag = param2 == -1;
            return;
         }
         if(param3.SheepGoodSellVO.FinalAwardIndex == param1)
         {
            param3.FinalAwardReciveFlag = param2 == -1;
            return;
         }
         if(param3.SheepGoodSellVO.ActivityNumIndex == param1)
         {
            param3.ActivityNum = param2;
            return;
         }
      }
      
      public function InitActivityData(param1:THDSheepGoodSellData, param2:THDSheepGoodSell) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param1.Inited)
         {
            return;
         }
         _loc4_ = int(param2.ActAwardAward.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = int(param2.ActAwardAward[_loc3_].length);
            param1.ActAwards[_loc3_] = new Vector.<TInventories>();
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               param1.ActAwards[_loc3_][_loc5_] = new TInventories();
               SToolReward.GetAwardsByAwardID(param2.ActAwardAward[_loc3_][_loc5_],param1.ActAwards[_loc3_][_loc5_],false);
               _loc5_++;
            }
            param1.FreeAwards[_loc3_] = new TInventories();
            SToolReward.GetAwardsByAwardID(param2.ActAwardFreeAwardID[_loc3_],param1.FreeAwards[_loc3_],false);
            param1.LoadingAwards[_loc3_] = new TInventories();
            SToolReward.GetAwardsByAwardID(param2.LoadingAwardAward[_loc3_],param1.LoadingAwards[_loc3_],false);
            _loc3_++;
         }
         SToolReward.GetAwardsByAwardID(param2.FinalAwardAwardID,param1.FinalAwards,false);
         param1.Inited = true;
      }
      
      public function UnstreamizeInitActivity(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityInitRetData = null;
         var _loc5_:THDSheepGoodSellData = null;
         var _loc6_:THDSheepGoodSell = null;
         var _loc7_:THDBoxStateData = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc4_ = param1 as TActivityInitRetData;
         _loc5_ = param2 as THDSheepGoodSellData;
         _loc6_ = param3 as THDSheepGoodSell;
         this.InitActivityData(_loc5_,_loc6_);
         _loc5_.SheepGoodSellVO = _loc6_;
         _loc9_ = int(_loc4_.AllBox.length);
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc7_ = _loc4_.AllBox[_loc8_];
            this.AssignActivityData(_loc7_.BoxIndex,_loc7_.State,_loc5_);
            _loc8_++;
         }
         _loc5_.ActivityNum = _loc4_.ParameterVec[0];
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:Object, param3:Object) : void
      {
         var _loc4_:THDSheepGoodSellData = null;
         _loc4_ = param2 as THDSheepGoodSellData;
         this.AssignActivityData(param1.Index,param1.Status,_loc4_);
      }
   }
}

