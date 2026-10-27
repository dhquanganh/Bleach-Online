package Logics.Streamization.HDThanksGivingDay2016
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDTGD_2;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDThanksGivingDay2016.TTGD_2;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   
   public class TUnstreamizerTGD_2 extends TUnstreamizer
   {
      
      public function TUnstreamizerTGD_2()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TTGD_2) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         _loc3_ = 9;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.Items[_loc2_].award);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.PerviewIns[_loc2_] = _loc5_;
            _loc2_++;
         }
         _loc3_ = param1.Config.Mall.length;
         _loc5_ = new TInventories();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = uint(param1.Config.Mall[_loc2_].award);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            _loc2_++;
         }
         param1.MailInvs = _loc5_;
         param1.MailStatus = new Vector.<int>(_loc3_);
      }
      
      protected function Core(param1:uint, param2:Object, param3:TTGD_2) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDTGD_2 = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:TInventories = null;
         _loc7_ = param3.Config;
         if(param1 == _loc7_.BlueIndex)
         {
            param3.HaveCard_0 = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.PurpleIndex)
         {
            param3.HaveCard_1 = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.GoldIndex)
         {
            param3.HaveCard_2 = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.RedIndex)
         {
            param3.HaveCard_3 = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.FreeIndex)
         {
            param3.FreeCount = TUtilityTool.ActState(param2);
         }
         else if(param1 >= _loc7_.CurItems[0] && param1 <= _loc7_.CurItems[4])
         {
            param3.CurInsIndex[param1 - _loc7_.CurItems[0]] = TUtilityTool.ActState(param2);
            if(TUtilityTool.ActState(param2) == 0)
            {
               param3.CurIns[param1 - 1] = null;
            }
            else
            {
               _loc10_ = new TInventories();
               _loc9_ = uint(param3.Config.Items[TUtilityTool.ActState(param2) - 10].award);
               SToolReward.GetAwardsByAwardID(_loc9_,_loc10_);
               param3.CurIns[param1 - 1] = _loc10_.GetInventoryByIndex(0);
               param3.CurCard = param1 - 1;
            }
         }
         this.ShopResult(param1,param2,param3);
      }
      
      protected function ShopResult(param1:uint, param2:Object, param3:TTGD_2) : void
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
               param3.MailStatus[_loc5_] = 0 - TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:TTGD_2 = null;
         var _loc8_:THDTGD_2 = null;
         _loc7_ = param2 as TTGD_2;
         _loc8_ = param3 as THDTGD_2;
         if(_loc7_.Config == null)
         {
            _loc7_.Config = _loc8_;
            this.ConfigHandle(_loc7_);
         }
         _loc5_ = param1.AllBox.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.AllBox[_loc4_];
            this.Core(_loc6_.BoxIndex,_loc6_,_loc7_);
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:TTGD_2 = null;
         var _loc5_:THDTGD_2 = null;
         _loc4_ = param2 as TTGD_2;
         _loc5_ = param3 as THDTGD_2;
         if(param1.Index == _loc5_.PurpleIndex && param1.Status < _loc4_.HaveCard_1)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_45));
         }
         if(param1.Index == _loc5_.RedIndex && param1.Status < _loc4_.HaveCard_3)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_45));
         }
         if(param1.Index == _loc5_.GoldIndex && param1.Status < _loc4_.HaveCard_2)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_45));
         }
         if(param1.Index == _loc5_.BlueIndex && param1.Status < _loc4_.HaveCard_0)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_45));
         }
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

