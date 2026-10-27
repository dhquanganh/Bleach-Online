package Processors.Game.Lobby.Activity.HDPrivilegeLease.Decoder
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.Characters.THero;
   import Logics.Characters.THeros;
   import Logics.DatebaseVO.VO.THDPrivilegeLease;
   import Logics.DatebaseVO.VO.TTimeHero;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDPrivilegeLease.PrivilegeLeaseVO;
   import Logics.HDPrivilegeLease.TActivityPrivilegeLeaseData;
   import Logics.Inventories.TInventories;
   import Logics.SLogicsCore;
   import Logics.Streamization.Characters.TUnstreamizerCharacter;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_PRIVILEGELEASE;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerPrivilegeLease extends TUnstreamizer
   {
      
      public function TUnstreamizerPrivilegeLease()
      {
         super();
      }
      
      public function CoreConfigValue(param1:ByteArray, param2:Object, param3:Object, param4:TBins) : void
      {
         var _loc5_:TActivityPrivilegeLeaseData = null;
         var _loc6_:THDPrivilegeLease = null;
         var _loc7_:TBins = null;
         var _loc8_:PrivilegeLeaseVO = null;
         var _loc9_:TInventories = null;
         var _loc10_:TTimeHero = null;
         var _loc11_:TUnstreamizerCharacter = null;
         var _loc12_:THeros = null;
         var _loc13_:Vector.<uint> = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         _loc5_ = param2 as TActivityPrivilegeLeaseData;
         _loc6_ = param3 as THDPrivilegeLease;
         _loc7_ = param4;
         _loc5_.DataList.length = 0;
         _loc15_ = int(_loc6_.ActAwardHeroIdList.length);
         _loc11_ = new TUnstreamizerCharacter();
         _loc12_ = new THeros();
         _loc13_ = new Vector.<uint>(1);
         _loc14_ = 0;
         while(_loc14_ < _loc15_)
         {
            _loc8_ = new PrivilegeLeaseVO();
            _loc8_.Index = _loc6_.ActAwardIndexList[_loc14_];
            _loc8_.HeroId = _loc6_.ActAwardHeroIdList[_loc14_];
            _loc13_[0] = _loc8_.HeroId;
            _loc10_ = _loc7_.GetDatebaseByIdentifier(_loc8_.HeroId) as TTimeHero;
            _loc8_.PriceA = _loc10_.OneDayCost;
            _loc8_.PriceB = _loc10_.ThreeDayCost;
            _loc8_.PriceC = _loc10_.SevenDayCost;
            _loc8_.PriceD = _loc10_.ForeverCost;
            _loc8_.DayA = _loc10_.TimeList[0];
            _loc8_.DayB = _loc10_.TimeList[1];
            _loc8_.DayC = _loc10_.TimeList[2];
            _loc8_.DayD = _loc10_.TimeList[3];
            _loc8_.HeroState = this.SetHeroState(_loc8_.HeroId);
            _loc11_.UnstreamizeGenerateHerosByIdentifiers(null,_loc12_,_loc13_);
            _loc8_.Hero = _loc12_.GetHeroByIdentifier(_loc8_.HeroId);
            _loc5_.DataList.push(_loc8_);
            _loc14_++;
         }
         _loc5_.PromptsList = (SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_PrivilegeLease).GetDatebaseByIndex(0) as THDPrivilegeLease).PromptLists;
      }
      
      protected function SetHeroState(param1:int, param2:int = 0) : int
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:THero = null;
         _loc6_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(param1);
         _loc4_ = _loc6_ == null ? false : true;
         if(_loc4_)
         {
            if(_loc6_.HeroOverTime == 0)
            {
               return CONST_PRIVILEGELEASE.HeroState_Have;
            }
            return CONST_PRIVILEGELEASE.HeroState_Renew;
         }
         return CONST_PRIVILEGELEASE.HeroState_Buy;
      }
      
      public function UnstreamizationPerform_InitData(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityPrivilegeLeaseData = null;
         var _loc5_:TActivityInitRetData = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Vector.<THDBoxStateData> = null;
         var _loc9_:THDBoxStateData = null;
         var _loc10_:PrivilegeLeaseVO = null;
         _loc4_ = param2 as TActivityPrivilegeLeaseData;
         _loc5_ = param3 as TActivityInitRetData;
      }
      
      public function FillBoxState(param1:int, param2:int, param3:TActivityPrivilegeLeaseData) : void
      {
         param3.DataList[param1].HeroState = this.SetHeroState(param2);
      }
      
      public function RefreshHeroState(param1:TActivityPrivilegeLeaseData) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TActivityPrivilegeLeaseData = null;
         var _loc5_:PrivilegeLeaseVO = null;
         _loc4_ = param1;
         _loc3_ = int(_loc4_.DataList.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = _loc4_.DataList[_loc2_];
            _loc5_.HeroState = this.SetHeroState(_loc5_.HeroId);
            _loc2_++;
         }
      }
   }
}

