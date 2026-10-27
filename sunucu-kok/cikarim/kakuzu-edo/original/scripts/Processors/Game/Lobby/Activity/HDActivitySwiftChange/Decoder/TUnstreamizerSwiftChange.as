package Processors.Game.Lobby.Activity.HDActivitySwiftChange.Decoder
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.THSwiftChangeConfig;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDSwiftChange.SwiftChangeVO;
   import Logics.HDSwiftChange.TActivitySwiftChangData;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerSwiftChange extends TUnstreamizer
   {
      
      public function TUnstreamizerSwiftChange()
      {
         super();
      }
      
      public function CoreConfigValue(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivitySwiftChangData = null;
         var _loc5_:THSwiftChangeConfig = null;
         var _loc6_:SwiftChangeVO = null;
         var _loc7_:TInventories = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc4_ = param2 as TActivitySwiftChangData;
         _loc5_ = param3 as THSwiftChangeConfig;
         _loc4_.DataList.length = 0;
         _loc9_ = int(_loc5_.BuyProAwardList.length);
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc6_ = new SwiftChangeVO();
            _loc6_.Index = _loc5_.BuyProIndexList[_loc8_];
            _loc6_.Cost = _loc5_.BuyProCostList[_loc8_];
            _loc6_.Award = _loc5_.BuyProAwardList[_loc8_];
            _loc6_.Limit = _loc5_.BuyProLimitList[_loc8_];
            _loc6_.HeroId = _loc5_.buyProHeroIdList[_loc8_];
            _loc6_.DebrisHeroName = (SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero).GetDatebaseByIdentifier(_loc6_.HeroId) as TBaseHero).Name;
            _loc4_.DataList.push(_loc6_);
            _loc8_++;
         }
         _loc4_.HeroList = _loc5_.HeroList;
         _loc4_.ExchangeInventories.length = 0;
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc7_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc5_.BuyProAwardList[_loc8_],_loc7_);
            _loc4_.ExchangeInventories.push(_loc7_);
            _loc8_++;
         }
      }
      
      public function UnstreamizationPerform_InitData(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivitySwiftChangData = null;
         var _loc5_:TActivityInitRetData = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Vector.<THDBoxStateData> = null;
         var _loc9_:THDBoxStateData = null;
         var _loc10_:SwiftChangeVO = null;
         _loc4_ = param2 as TActivitySwiftChangData;
         _loc5_ = param3 as TActivityInitRetData;
         _loc7_ = int(_loc5_.AllBox.length);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc9_ = _loc5_.AllBox[_loc6_];
            _loc10_ = _loc4_.DataList[_loc6_];
            _loc10_.UseLimit = _loc9_.State;
            _loc6_++;
         }
      }
      
      public function FillBoxState(param1:int, param2:int, param3:TActivitySwiftChangData) : void
      {
         param3.DataList[param1].UseLimit = param2;
      }
   }
}

