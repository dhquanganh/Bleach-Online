package Logics.Streamization.HDEaster2016
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDEaster2016_2;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.TActivityServerRank;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDEaster2016.THDEasterData2016_2;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   
   public class TUnstreamizerEaster2016_2 extends TUnstreamizer
   {
      
      public function TUnstreamizerEaster2016_2()
      {
         super();
      }
      
      protected function ConfigHandle(param1:THDEasterData2016_2) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         _loc3_ = uint(param1.Config.ScoreGift["infos"].length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.ScoreGift["infos"][_loc2_].awardId);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.GiftInvs[_loc2_] = _loc5_;
            _loc2_++;
         }
         _loc3_ = param1.Config.Awards.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.Awards[_loc2_].awardId);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.Rewards[_loc2_] = _loc5_.GetInventoryByIndex(0);
            _loc2_++;
         }
      }
      
      protected function Core(param1:uint, param2:Object, param3:THDEasterData2016_2) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDEaster2016_2 = null;
         _loc7_ = param3.Config;
         if(param1 == _loc7_.ScoreIndex)
         {
            param3.CurScore = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.CopperEgg.index)
         {
            param3.Time = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.ScoreGift.index)
         {
            _loc6_ = uint(_loc7_.ScoreGift["infos"].length);
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               param3.GiftStatus[_loc5_] = TUtilityTool.GetValueByBit(TUtilityTool.ActState(param2),_loc5_);
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
         var _loc8_:THDEasterData2016_2 = null;
         var _loc9_:THDEaster2016_2 = null;
         _loc8_ = param2 as THDEasterData2016_2;
         _loc9_ = param3 as THDEaster2016_2;
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
         var _loc4_:THDEasterData2016_2 = null;
         var _loc5_:THDEaster2016_2 = null;
         _loc4_ = param2 as THDEasterData2016_2;
         _loc5_ = param3 as THDEaster2016_2;
         if(param1.Index == _loc5_.ScoreIndex)
         {
            if(param1.Status - _loc4_.CurScore > 0)
            {
               SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Integral) + ":" + (param1.Status - _loc4_.CurScore));
            }
         }
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

