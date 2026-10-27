package Logics.Streamization.HDActivityNewHalloween
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDNewHalloweenGameConfig;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDNewHalloween.THDNewHalloweenGameData;
   import Logics.Inventories.TInventories;
   import Logics.Streamization.HDActivityNewHalloween.GameVo.TCandyExchangeVo;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_NewHalloween;
   
   public class TUnstreamizerNewHalloweenGame extends TUnstreamizer
   {
      
      public function TUnstreamizerNewHalloweenGame()
      {
         super();
      }
      
      private function UnstreamizationPerform_InitData(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THDNewHalloweenGameData = null;
         var _loc7_:TActivityInitRetData = null;
         var _loc8_:THDNewHalloweenGameConfig = null;
         var _loc9_:THDBoxStateData = null;
         var _loc10_:TCandyExchangeVo = null;
         var _loc11_:TInventories = null;
         _loc7_ = param1 as TActivityInitRetData;
         _loc6_ = param2 as THDNewHalloweenGameData;
         _loc8_ = param3 as THDNewHalloweenGameConfig;
         _loc5_ = int(_loc8_.GiftIndexVec.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc11_ = new TInventories();
            _loc10_ = new TCandyExchangeVo();
            _loc10_.Index = _loc8_.GiftIndexVec[_loc4_];
            _loc10_.Condition = _loc8_.GiftCandyVec[_loc4_];
            _loc10_.State = CONST_NewHalloween.UnFinish;
            SToolReward.GetAwardsByAwardID(_loc8_.GiftAwardVec[_loc4_],_loc11_);
            _loc10_.Inventories = _loc11_;
            _loc6_.CandyVoVec[_loc4_] = _loc10_;
            _loc4_++;
         }
         _loc11_ = new TInventories();
         SToolReward.GetAwardsByAwardID(_loc8_.TitleObj.award,_loc11_);
         _loc6_.Inventories = _loc11_;
         if(_loc7_.AllBox.length == 0)
         {
            return;
         }
         _loc6_.ActivityConfig = _loc8_;
         _loc5_ = int(_loc7_.AllBox.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_ = _loc7_.AllBox[_loc4_];
            this.SetData(_loc9_.BoxIndex,_loc9_.State,_loc6_);
            _loc4_++;
         }
      }
      
      private function SetData(param1:int, param2:int, param3:THDNewHalloweenGameData) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TCandyExchangeVo = null;
         if(param3.ActivityConfig.TitleObj.index == param1)
         {
            param3.TitleState = param2;
         }
         else if(param3.ActivityConfig.NotifyIndex == param1)
         {
            param3.GameTimes = param2;
         }
         else if(param3.ActivityConfig.CandyIndex == param1)
         {
            param3.Candy = param2;
            if(param3.TitleState != -1)
            {
               param3.TitleState = param2 >= param3.ActivityConfig.TitleObj.candy ? 1 : 0;
            }
            _loc5_ = int(param3.CandyVoVec.length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = param3.CandyVoVec[_loc4_];
               _loc6_.Condition = param3.CurTurn * param3.ActivityConfig.GiftCandyVec[param3.ActivityConfig.GiftCandyVec.length - 1] + param3.ActivityConfig.GiftCandyVec[_loc4_];
               if(_loc6_.State != -1)
               {
                  _loc6_.State = param2 >= _loc6_.Condition ? 1 : 0;
               }
               _loc4_++;
            }
         }
         else if(param3.ActivityConfig.TurnIndex == param1)
         {
            param3.CurTurn = param2;
            _loc5_ = int(param3.CandyVoVec.length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = param3.CandyVoVec[_loc4_];
               _loc6_.Condition = param2 * param3.ActivityConfig.GiftCandyVec[param3.ActivityConfig.GiftCandyVec.length - 1] + param3.ActivityConfig.GiftCandyVec[_loc4_];
               _loc6_.State = param3.Candy >= _loc6_.Condition ? 1 : 0;
               _loc4_++;
            }
         }
         _loc5_ = int(param3.CandyVoVec.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param3.CandyVoVec[_loc4_];
            if(_loc6_.Index == param1)
            {
               _loc6_.State = param2;
               break;
            }
            _loc4_++;
         }
      }
      
      public function UnstreamizeInitActivity(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_InitData(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:Object, param3:Object) : void
      {
         var _loc4_:THDNewHalloweenGameData = null;
         var _loc5_:THDNewHalloweenGameConfig = null;
         var _loc6_:TActAwardStatusInfo = null;
         _loc6_ = param1 as TActAwardStatusInfo;
         _loc4_ = param2 as THDNewHalloweenGameData;
         _loc5_ = param3 as THDNewHalloweenGameConfig;
         this.SetData(_loc6_.Index,_loc6_.Status,_loc4_);
      }
   }
}

