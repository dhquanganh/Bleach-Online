package Logics.Streamization.HDDuanwujie
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDDuanwujiePet;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDDuanwujie.TDuanwujiePet;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerDuanwujiePet extends TUnstreamizer
   {
      
      public function TUnstreamizerDuanwujiePet()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TDuanwujiePet) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         _loc3_ = param1.Config.Fund.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.Fund[_loc2_].awardId);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.FundBoxes[_loc2_] = _loc5_;
            _loc2_++;
         }
         _loc3_ = uint(param1.Config.ZongZiGift.awardIds.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.ZongZiGift.awardIds[_loc2_]);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.ZongziBoxes[_loc2_] = _loc5_;
            _loc2_++;
         }
         _loc3_ = param1.Config.Mall.length;
         _loc5_ = new TInventories();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = uint(param1.Config.Mall[_loc2_].awardId);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            _loc2_++;
         }
         param1.MailInvs = _loc5_;
         _loc5_ = new TInventories();
         _loc4_ = uint(param1.Config.FundGift.awardId);
         SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
         param1.FundGiftBox = _loc5_;
      }
      
      protected function Core(param1:uint, param2:Object, param3:TDuanwujiePet) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDDuanwujiePet = null;
         var _loc8_:uint = 0;
         _loc7_ = param3.Config;
         if(param1 == _loc7_.ZongziId)
         {
            param3.ZongziNum = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.ServerZongziId)
         {
            param3.ServerZongziNum = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.FundGift.index)
         {
            param3.FundGIftStatus = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.Pet.index)
         {
            param3.PetStatus = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.ZongZiGift.index)
         {
            _loc6_ = uint(_loc7_.ZongZiGift.awardIds.length);
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               param3.ZongziStatus[_loc5_] = TUtilityTool.GetValueByBit(TUtilityTool.ActState(param2),_loc5_);
               _loc5_++;
            }
         }
         _loc6_ = _loc7_.Fund.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = _loc7_.Fund[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.FundStatus[_loc5_] = TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
         this.ShopResult(param1,param2,param3);
      }
      
      protected function ShopResult(param1:uint, param2:Object, param3:TDuanwujiePet) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc6_ = param3.Config.Mall.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = param3.Config.Mall[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.MailStatus[_loc5_] = TUtilityTool.ActState(param2);
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
         var _loc8_:TDuanwujiePet = null;
         var _loc9_:THDDuanwujiePet = null;
         _loc8_ = param2 as TDuanwujiePet;
         _loc9_ = param3 as THDDuanwujiePet;
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
         var _loc4_:TDuanwujiePet = null;
         var _loc5_:THDDuanwujiePet = null;
         _loc4_ = param2 as TDuanwujiePet;
         _loc5_ = param3 as THDDuanwujiePet;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

