package Logics.Streamization.HDCoolSummer
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDCoolSummer;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDCoolSummer.TCoolSummerData;
   
   public class TUnstreamizerCoolSummer extends TUnstreamizer
   {
      
      public function TUnstreamizerCoolSummer()
      {
         super();
      }
      
      protected function Core(param1:uint, param2:int, param3:Vector.<int>, param4:TCoolSummerData) : void
      {
         if(this.DisposeShell(param1,param2,param3,param4))
         {
            return;
         }
         if(this.DisposeOpenOnce(param1,param2,param3,param4))
         {
            return;
         }
         if(this.DisposeRefresh(param1,param2,param3,param4))
         {
            return;
         }
         if(this.DisposeChoose(param1,param2,param3,param4))
         {
            return;
         }
         if(this.DisposeScore(param1,param2,param3,param4))
         {
            return;
         }
         if(this.DisposeScoreShop(param1,param2,param3,param4))
         {
            return;
         }
         if(this.DisposeMainAward(param1,param2,param3,param4))
         {
            return;
         }
      }
      
      protected function DisposeShell(param1:uint, param2:int, param3:Vector.<int>, param4:TCoolSummerData) : Boolean
      {
         var _loc5_:int = 0;
         _loc5_ = param4.Config.ShellIndex.indexOf(param1);
         if(_loc5_ != -1)
         {
            param4.RandomItemStates[_loc5_] = param2;
            return true;
         }
         return false;
      }
      
      protected function DisposeOpenOnce(param1:uint, param2:int, param3:Vector.<int>, param4:TCoolSummerData) : Boolean
      {
         if(param1 == param4.Config.OpenOnce.index)
         {
            param4.FreeCount = Math.max(0,param4.Config.OpenOnce.freeCount - param2);
            return true;
         }
         return false;
      }
      
      protected function DisposeRefresh(param1:uint, param2:int, param3:Vector.<int>, param4:TCoolSummerData) : Boolean
      {
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         if(param1 == param4.Config.Refresh.index)
         {
            param1 = 0;
            for each(_loc5_ in param3)
            {
               _loc6_ = int(param4.AwardIDToPos[_loc5_]);
               param4.RandomItemIndexs[param1] = _loc6_;
               param1++;
            }
            param4.UpdateSelectItems = true;
            return true;
         }
         return false;
      }
      
      protected function DisposeChoose(param1:uint, param2:int, param3:Vector.<int>, param4:TCoolSummerData) : Boolean
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         if(param1 == param4.Config.Choose)
         {
            _loc5_ = param3.length / 2;
            param4.LockItems.length = 0;
            param4.LockItemsPos.length = 0;
            param1 = 0;
            while(param1 < _loc5_)
            {
               _loc7_ = uint(param3[param1 * 2]);
               _loc6_ = uint(param3[param1 * 2 + 1]);
               param4.LockItems[param1] = param4.AwardIDToPos[_loc7_];
               param4.LockItemsPos[param1] = _loc6_;
               param1++;
            }
            return true;
         }
         return false;
      }
      
      protected function DisposeScore(param1:uint, param2:int, param3:Vector.<int>, param4:TCoolSummerData) : Boolean
      {
         if(param1 == param4.Config.Score)
         {
            param4.Score = param2;
            return true;
         }
         return false;
      }
      
      protected function DisposeScoreShop(param1:uint, param2:int, param3:Vector.<int>, param4:TCoolSummerData) : Boolean
      {
         var _loc5_:Object = null;
         var _loc6_:uint = 0;
         _loc6_ = 0;
         for each(_loc5_ in param4.Config.ScoreShop)
         {
            if(param1 == _loc5_.index)
            {
               param4.ScoreItemStates[_loc6_] = param2;
               return true;
            }
            _loc6_++;
         }
         return false;
      }
      
      protected function DisposeMainAward(param1:uint, param2:int, param3:Vector.<int>, param4:TCoolSummerData) : Boolean
      {
         if(param1 == param4.Config.MainAward.index)
         {
            param4.MainAwardState = param2;
            return true;
         }
         return false;
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:TCoolSummerData = null;
         var _loc8_:THDCoolSummer = null;
         _loc7_ = param2 as TCoolSummerData;
         _loc8_ = param3 as THDCoolSummer;
         _loc7_.Config = _loc8_;
         _loc5_ = param1.AllBox.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.AllBox[_loc4_];
            this.Core(_loc6_.BoxIndex,_loc6_.State,_loc6_.Conditions,_loc7_);
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:TCoolSummerData = null;
         _loc4_ = param2 as TCoolSummerData;
         this.Core(param1.Index,param1.Status,param1.Condition,_loc4_);
      }
   }
}

