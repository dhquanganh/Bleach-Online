package Logics.Streamization.HDActivityGB
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.HDActivityGB.TActivityGBCollectGame;
   import Logics.HDActivityGB.TActivityGBGold;
   import Logics.HDActivityGB.TActivityGBLevel;
   import Logics.HDActivityGB.TActivityGBOnline;
   import Logics.HDActivityGB.TActivityGBOpenServer;
   import Logics.HDActivityGB.TActivityGBOrder;
   import Logics.HDActivityGB.TActivityGBSevenDay;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TUnstreamizerActivityGB extends TUnstreamizer
   {
      
      public function TUnstreamizerActivityGB()
      {
         super();
      }
      
      protected function UnstreamizationPerform_UpdateOnlineGiftBag(param1:Object, param2:Object) : void
      {
         var _loc3_:TActivityGBOnline = null;
         var _loc4_:TActivityInitRetData = null;
         _loc3_ = param1 as TActivityGBOnline;
         _loc4_ = param2 as TActivityInitRetData;
         _loc3_.Step = _loc4_.ParameterVec[0];
      }
      
      protected function UnstreamizationPerform_UpdateGoldGiftBag(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<int> = null;
         var _loc6_:TActivityGBGold = null;
         var _loc7_:TActivityInitRetData = null;
         _loc6_ = param1 as TActivityGBGold;
         _loc7_ = param2 as TActivityInitRetData;
         _loc4_ = int(_loc7_.AwardStates.length);
         _loc5_ = new Vector.<int>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_[_loc3_] = _loc7_.AwardStates[_loc3_].State;
            _loc3_++;
         }
         _loc6_.BoxStatus = _loc5_;
         _loc6_.TotalCount = _loc5_.length;
         _loc3_ = _loc5_.indexOf(CONST_ACTIVITY_MODE.Activity_CanReceive) + 1;
         if(_loc3_ == -1)
         {
            _loc6_.CurCount = _loc6_.TotalCount;
         }
         else
         {
            _loc6_.CurCount = _loc5_.indexOf(CONST_ACTIVITY_MODE.Activity_CanReceive) + 1;
         }
      }
      
      protected function UnstreamizationPerform_UpdateSevenGiftBag(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<int> = null;
         var _loc6_:TActivityGBSevenDay = null;
         var _loc7_:TActivityInitRetData = null;
         _loc6_ = param1 as TActivityGBSevenDay;
         _loc7_ = param2 as TActivityInitRetData;
         _loc4_ = int(_loc7_.AwardStates.length);
         _loc5_ = new Vector.<int>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_[_loc3_] = _loc7_.AwardStates[_loc3_].State;
            _loc3_++;
         }
         _loc6_.BoxStatus = _loc5_;
         _loc6_.TotalCount = _loc5_.length;
         _loc3_ = _loc5_.indexOf(CONST_ACTIVITY_MODE.Activity_CanReceive) + 1;
         if(_loc3_ == -1)
         {
            _loc6_.CurCount = _loc6_.TotalCount;
         }
         else
         {
            _loc6_.CurCount = _loc5_.indexOf(CONST_ACTIVITY_MODE.Activity_CanReceive) + 1;
         }
      }
      
      protected function UnstreamizationPerform_UpdateOpenServerGiftBag(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<int> = null;
         var _loc6_:TActivityGBOpenServer = null;
         var _loc7_:TActivityInitRetData = null;
         _loc6_ = param1 as TActivityGBOpenServer;
         _loc7_ = param2 as TActivityInitRetData;
         _loc5_ = new Vector.<int>(1);
         _loc5_[0] = _loc7_.ParameterVec[0];
         _loc6_.BoxStatus = _loc5_;
      }
      
      protected function UnstreamizationPerform_UpdateCollectGameGiftBag(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<int> = null;
         var _loc6_:TActivityGBCollectGame = null;
         var _loc7_:TActivityInitRetData = null;
         _loc6_ = param1 as TActivityGBCollectGame;
         _loc7_ = param2 as TActivityInitRetData;
         _loc5_ = new Vector.<int>(1);
         _loc5_[0] = _loc7_.ParameterVec[0];
         _loc6_.BoxStatus = _loc5_;
      }
      
      protected function UnstreamizationPerform_UpdateLevelGiftBag(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<int> = null;
         var _loc6_:TActivityGBLevel = null;
         var _loc7_:TActivityInitRetData = null;
         _loc6_ = param1 as TActivityGBLevel;
         _loc7_ = param2 as TActivityInitRetData;
         _loc4_ = int(_loc7_.AwardStates.length);
         _loc5_ = new Vector.<int>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_[_loc3_] = _loc7_.AwardStates[_loc3_].State;
            _loc3_++;
         }
         _loc6_.BoxStatus = _loc5_;
      }
      
      protected function UnstreamizationPerform_UpdateOrderGiftBag(param1:Object, param2:Object) : void
      {
         var _loc3_:TActivityGBOrder = null;
         var _loc4_:TActivityInitRetData = null;
         _loc3_ = param1 as TActivityGBOrder;
         _loc4_ = param2 as TActivityInitRetData;
         _loc3_.Time = _loc4_.AllBox[0].State;
      }
      
      public function UnstreamizeUpdateOnlineGiftBag(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_UpdateOnlineGiftBag(param1,param2);
      }
      
      public function UnstreamizeUpdateGoldGiftBag(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_UpdateGoldGiftBag(param1,param2);
      }
      
      public function UnstreamizeUpdateSevenDayGiftBag(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_UpdateSevenGiftBag(param1,param2);
      }
      
      public function UnstreamizeUpdateOpenServerGiftBag(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_UpdateOpenServerGiftBag(param1,param2);
      }
      
      public function UnstreamizeUpdateOpenCollectGameGiftBag(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_UpdateCollectGameGiftBag(param1,param2);
      }
      
      public function UnstreamizeUpdateLevelGiftBag(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_UpdateLevelGiftBag(param1,param2);
      }
      
      public function UnstreamizeOrderGiftBag(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_UpdateOrderGiftBag(param1,param2);
      }
   }
}

