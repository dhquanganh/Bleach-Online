package Processors.Game.Lobby.Activity.HDPartner.Decoder
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.THDPartner;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDPartner.TActivityPartnerData;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerActivityPartner extends TUnstreamizer
   {
      
      public function TUnstreamizerActivityPartner()
      {
         super();
      }
      
      public function CoreConfigValue(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityPartnerData = null;
         var _loc5_:THDPartner = null;
         var _loc6_:TInventories = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc4_ = param2 as TActivityPartnerData;
         _loc5_ = param3 as THDPartner;
         _loc4_.TaskIndexs = _loc5_.TaskIndexs;
         _loc4_.TaskPrompts = _loc5_.TaskPrompts;
         _loc4_.TaskTotalSchedules = _loc5_.TaskTotalSchedules;
         _loc4_.TaskConditions = _loc5_.TaskConditions;
         _loc4_.BoxIndexs = _loc5_.BoxIndexs;
         _loc4_.BoxCosts = _loc5_.BoxCosts;
         _loc4_.BoxAwards = _loc5_.BoxAwards;
         _loc4_.BuyRoseIndexs = _loc5_.BuyRoseIndexs;
         _loc4_.BuyRoseCosts = _loc5_.BuyRoseCosts;
         _loc4_.BuyRoseNum = _loc5_.BuyRoseNum;
         _loc4_.RoseNumIndex = _loc5_.RoseNumIndex;
         _loc4_.BuyRoseAward = _loc5_.BuyRoseAward;
         _loc4_.ExchangeHeroIndexs = _loc5_.ExchangeHeroIndexs;
         _loc4_.ExchangeHeroNeedRoses = _loc5_.ExchangeHeroNeedRoses;
         _loc4_.ExchangeHeroHeroIDs = _loc5_.ExChangeHeroHeroIDs;
         _loc4_.ExchangeHeroFightReportAddr = _loc5_.ExchangeHeroFightReportAddr;
         _loc4_.TitleIndex = _loc5_.TitleIndex;
         _loc4_.TitleID = _loc5_.TitleID;
         _loc8_ = int(_loc4_.BoxAwards.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc6_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc4_.BoxAwards[_loc7_],_loc6_);
            _loc4_.BoxInventories.push(_loc6_);
            _loc7_++;
         }
         _loc8_ = int(_loc5_.TaskAwards.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc6_ = new TInventories();
            SToolReward.GetInventoryByID(_loc5_.RoseID,_loc6_);
            _loc6_.GetInventoryByIndex(0).Quantity = _loc5_.TaskAwards[_loc7_];
            _loc4_.TaskInventories.push(_loc6_);
            _loc7_++;
         }
         _loc8_ = int(_loc4_.BuyRoseAward.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc6_ = new TInventories();
            SToolReward.GetInventoryByID(_loc5_.RoseID,_loc6_);
            _loc6_.GetInventoryByIndex(0).Quantity = _loc5_.BuyRoseAwardRoseNum[_loc7_];
            SToolReward.GetAwardsByAwardID(_loc4_.BuyRoseAward[_loc7_],_loc6_);
            _loc4_.BuyRoseArticls.push(_loc6_);
            _loc7_++;
         }
      }
      
      public function UnstreamizationPerform_InitData(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityPartnerData = null;
         var _loc5_:TActivityInitRetData = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Vector.<THDBoxStateData> = null;
         var _loc9_:THDBoxStateData = null;
         _loc4_ = param2 as TActivityPartnerData;
         _loc5_ = param3 as TActivityInitRetData;
         _loc7_ = int(_loc5_.AllBox.length);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc9_ = _loc5_.AllBox[_loc6_];
            this.FillBoxState(_loc9_.BoxIndex,_loc9_.State,_loc4_);
            _loc6_++;
         }
      }
      
      public function FillBoxState(param1:int, param2:int, param3:TActivityPartnerData) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc5_ = int(param3.TaskIndexs.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(param1 == param3.TaskIndexs[_loc4_])
            {
               param3.TaskReciveRecored[_loc4_] = param2 != 0;
               return;
            }
            _loc4_++;
         }
         _loc5_ = int(param3.ExchangeHeroIndexs.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(param1 == param3.ExchangeHeroIndexs[_loc4_])
            {
               param3.ExchangeHeroRecore[_loc4_] = param2 != 0;
               return;
            }
            _loc4_++;
         }
         if(param1 == param3.TitleIndex)
         {
            param3.TitleIfGet = param2 != 0;
            return;
         }
         if(param1 == param3.RoseNumIndex)
         {
            param3.RoseCurrentNum = param2;
            return;
         }
      }
   }
}

