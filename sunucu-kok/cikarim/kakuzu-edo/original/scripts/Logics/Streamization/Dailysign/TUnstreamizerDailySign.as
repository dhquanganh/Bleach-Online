package Logics.Streamization.Dailysign
{
   import Foundation.Resources.*;
   import Foundation.Streamization.*;
   import Foundation.Timing.*;
   import Logics.*;
   import Logics.DailySign.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Inventories.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TUnstreamizerDailySign extends TUnstreamizer
   {
      
      public function TUnstreamizerDailySign()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_DailySignByDatabase(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_DailySignByDatabase(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var DailySign:TDailySign = null;
         var Days:uint = 0;
         var Str:String = null;
         var Index:int = 0;
         var Count:uint = 0;
         var RewardID:uint = 0;
         var SignReward:TSignReward = null;
         var TotalIntegral:uint = 0;
         var TempDateB:Date = null;
         var Stream:ByteArray = param1;
         var Destination:Object = param2;
         var Correlator:Object = param3;
         DailySign = Destination as TDailySign;
         DailySign.CurrentMonth = Stream.readUnsignedInt();
         Days = Stream.readUnsignedInt();
         Str = Days.toString(2);
         Count = uint(Str.length);
         Index = 0;
         while(Index < Count)
         {
            DailySign.DayList[Index] = Str.slice(Index,Index + 1);
            Index++;
         }
         TempDateB = new Date(STimingCore.ServerTime * 1000);
         DailySign.DayList.reverse();
         Index = int(Count);
         while(Index < TempDateB.date)
         {
            DailySign.DayList[Index] = "0";
            Index++;
         }
         TotalIntegral = Stream.readUnsignedInt();
         SLogicsCore.Character.CreditIntegral = TotalIntegral;
         RewardID = Stream.readUnsignedInt();
         DailySign.RewardID = RewardID;
         SignReward = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SignReward,RewardID) as TSignReward;
         DailySign.SignReward = SignReward;
         DailySign.SignTotalDays = Stream.readUnsignedInt();
         DailySign.ServerStartDate = Stream.readUnsignedInt();
         try
         {
            DailySign.OverTime = Stream.readUnsignedInt();
            DailySign.MonthRewardState = Stream.readUnsignedInt();
            DailySign.FirstRewardState = Stream.readUnsignedInt();
         }
         catch(Err:Error)
         {
         }
         this.UnstreamizationPerform_InventorySamplesByDatabase(Stream,DailySign,Correlator);
      }
      
      protected function UnstreamizationPerform_InventorySamplesByDatabase(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TDailySign = null;
         var _loc5_:TInventorySamples = null;
         var _loc6_:TInventorySamples = null;
         var _loc7_:TInventorySample = null;
         var _loc8_:int = 0;
         var _loc9_:uint = 0;
         _loc4_ = param2 as TDailySign;
         _loc5_ = param3 as TInventorySamples;
         _loc6_ = _loc4_.ExchangeReward;
         _loc6_.Clear();
         _loc9_ = uint(_loc5_.Count);
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc7_ = _loc5_.GetInventorySampleByIndex(_loc8_);
            if(_loc7_.Model == CONST_MALL.TYPE_MODEL_SIGN)
            {
               _loc6_.Add(_loc7_);
            }
            _loc8_++;
         }
      }
      
      public function MonthCardNotice(param1:ByteArray, param2:Object) : void
      {
         var _loc3_:TDailySign = null;
         _loc3_ = param2 as TDailySign;
         _loc3_.OverTime = param1.readUnsignedInt();
         _loc3_.MonthRewardState = param1.readUnsignedInt();
         _loc3_.FirstRewardState = param1.readUnsignedInt();
      }
   }
}

