package Logics.Streamization.HDFirstPayGift
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDFirstPayBagConfig;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDFirstPayGift.TActivityFirstPayGiftData;
   import Logics.HDFirstPayGift.VO.TRechargeGoldVo;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_GROWTHPLAN;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerFirstPayGift extends TUnstreamizer
   {
      
      public function TUnstreamizerFirstPayGift()
      {
         super();
      }
      
      public function CoreConfigValue(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityFirstPayGiftData = null;
         var _loc5_:THDFirstPayBagConfig = null;
         var _loc6_:TRechargeGoldVo = null;
         var _loc7_:TInventories = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc4_ = param2 as TActivityFirstPayGiftData;
         _loc5_ = param3 as THDFirstPayBagConfig;
         _loc4_.ActivityConfig = _loc5_;
         _loc9_ = int(_loc5_.PayAwardIndexVec.length);
         _loc4_.RechargeGoldGiftVec.length = 0;
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc6_ = new TRechargeGoldVo();
            _loc6_.GetAwardState = 0;
            _loc6_.Gold = _loc5_.PayAwardGoldVec[_loc8_];
            _loc6_.Index = _loc5_.PayAwardIndexVec[_loc8_];
            _loc7_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc5_.PayAwardIDVec[_loc8_],_loc7_);
            _loc6_.Inventories = _loc7_;
            _loc4_.RechargeGoldGiftVec[_loc8_] = _loc6_;
            _loc8_++;
         }
         _loc7_ = new TInventories();
         SToolReward.GetAwardsByAwardID(_loc5_.LoginAwardId,_loc7_);
         _loc4_.FirstInventories = _loc7_;
      }
      
      public function UnstreamizationPerform_InitData(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityFirstPayGiftData = null;
         var _loc5_:TActivityInitRetData = null;
         var _loc6_:THDFirstPayBagConfig = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:THDBoxStateData = null;
         _loc4_ = param2 as TActivityFirstPayGiftData;
         _loc5_ = param3 as TActivityInitRetData;
         _loc6_ = _loc4_.ActivityConfig;
         _loc8_ = int(_loc5_.AllBox.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc9_ = _loc5_.AllBox[_loc7_];
            this.SetData(_loc9_.BoxIndex,_loc9_.State,_loc4_);
            _loc7_++;
         }
      }
      
      private function SetData(param1:int, param2:int, param3:TActivityFirstPayGiftData) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TRechargeGoldVo = null;
         _loc5_ = int(param3.RechargeGoldGiftVec.length);
         if(param1 == param3.ActivityConfig.LoginIndex)
         {
            param3.FirstState = param2;
         }
         else if(param1 == param3.ActivityConfig.RechargeIndex)
         {
            param3.RechargeGoldValue = param2;
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = param3.RechargeGoldGiftVec[_loc4_];
               if(param1 == _loc6_.Index)
               {
                  _loc6_.GetAwardState = param2;
                  break;
               }
               _loc4_++;
            }
         }
         param3.IsFinishAllTask = this.GetFinshTaskBol(param3);
      }
      
      private function GetFinshTaskBol(param1:TActivityFirstPayGiftData) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         _loc4_ = param1.FirstState == CONST_GROWTHPLAN.Activity_AlreadyFinish;
         _loc3_ = int(param1.RechargeGoldGiftVec.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1.RechargeGoldGiftVec[_loc2_].GetAwardState == CONST_GROWTHPLAN.Activity_AlreadyFinish)
            {
               _loc5_ = true;
            }
            else
            {
               _loc5_ = false;
            }
            _loc4_ &&= _loc5_;
            _loc2_++;
         }
         return _loc4_;
      }
      
      public function FillBoxState(param1:TActAwardStatusInfo, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityFirstPayGiftData = null;
         var _loc5_:* = undefined;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TActAwardStatusInfo = null;
         _loc8_ = param1;
         _loc4_ = param2 as TActivityFirstPayGiftData;
         _loc5_ = param3;
         this.SetData(_loc8_.Index,_loc8_.Status,_loc4_);
      }
   }
}

