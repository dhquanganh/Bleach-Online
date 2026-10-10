package Logics.Streamization.CityDefend
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.CityDefend.TCityDefendData;
   import Logics.CityDefend.TCityDefendHero;
   import Logics.CityDefend.TCityDefendHeros;
   import Logics.CityDefend.TCityDefendRank;
   import Logics.CityDefend.TCityDefendRanks;
   import Logics.CityDefend.TCityDefendReport;
   import Logics.CityDefend.TCityDefendReports;
   import Logics.CityDefend.TPoolCityDefend;
   import Logics.DatebaseVO.VO.TKnifeExpand;
   import Logics.Spaces.LogicsSpace;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.ByteArray;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerCityDefend extends TUnstreamizer
   {
      
      protected static var FPoolCityDefend:TPoolCityDefend;
      
      public function TUnstreamizerCityDefend()
      {
         super();
      }
      
      LogicsSpace static function PoolsSetup(param1:TPoolCityDefend) : void
      {
         FPoolCityDefend = param1;
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TCityDefendData = null;
         _loc4_ = param2 as TCityDefendData;
         this.UnstreamizeCityDefend_BaseInfo(param1,_loc4_,param3);
         this.UnstreamizeCityDefend_Hero(param1,_loc4_,param3);
         this.UnstreamizeCityDefend_OrganizationRank(param1,_loc4_.OrganizationRank,param3);
         this.UnstreamizeCityDefend_HeroRank(param1,_loc4_.HeroRank,param3);
      }
      
      protected function UnstreamizeCityDefend_BaseInfo(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TCityDefendData = null;
         _loc4_ = param2 as TCityDefendData;
         _loc4_.CityDefendType = param1.readUnsignedByte();
         _loc4_.BeferStartColdDown = param1.readUnsignedInt();
         _loc4_.DefendOrganizationName = TUtilityString.FetchUTF(param1);
         _loc4_.CityDoorIndex = param1.readUnsignedByte();
         _loc4_.WorldLevel = param1.readUnsignedInt();
         _loc4_.CityDoorCurHp = param1.readDouble();
         _loc4_.BoomLevel = param1.readUnsignedByte();
         _loc4_.BuyCount = param1.readUnsignedInt();
      }
      
      protected function UnstreamizeCityDefend_Hero(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TCityDefendData = null;
         var _loc7_:TCityDefendHeros = null;
         var _loc8_:TCityDefendHero = null;
         var _loc9_:TCityDefendHero = null;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:TKnifeExpand = null;
         _loc6_ = param2 as TCityDefendData;
         _loc7_ = _loc6_.HeroList;
         _loc7_.Clear();
         _loc6_.DoorHeroList.Clear();
         _loc5_ = param1.readUnsignedShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc10_ = param1.readUnsignedInt();
            _loc11_ = param1.readUnsignedInt();
            _loc8_ = FPoolCityDefend.AcquireCityDefendHero(_loc10_,_loc11_);
            _loc8_.Status = param1.readByte();
            _loc8_.UserName = TUtilityString.FetchUTF(param1);
            _loc8_.Quality = param1.readUnsignedByte();
            _loc8_.MilitaryRank = param1.readUnsignedInt();
            _loc8_.PetStatus = Boolean(param1.readUnsignedByte());
            _loc8_.PetModelId = param1.readUnsignedInt();
            _loc8_.RoleTemplateId = param1.readUnsignedInt();
            _loc8_.UserType = param1.readUnsignedByte();
            _loc8_.UserLevel = param1.readUnsignedShort();
            _loc8_.UserPower = param1.readUnsignedInt();
            _loc8_.UserRebirthNum = param1.readUnsignedByte();
            if(_loc8_.PetModelId != 0)
            {
               _loc12_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,_loc8_.PetModelId) as TKnifeExpand;
               _loc8_.PetModelId = _loc12_.RelationID;
            }
            _loc7_.Add(_loc8_);
            if(_loc8_.Status == 1 && _loc8_.UserType != _loc6_.CityDefendType)
            {
               _loc9_ = FPoolCityDefend.AcquireCityDefendHero(_loc10_,_loc11_);
               _loc9_.UserName = _loc8_.UserName;
               _loc9_.UserLevel = _loc8_.UserLevel;
               _loc9_.UserRebirthNum = _loc8_.UserRebirthNum;
               _loc6_.DoorHeroList.Add(_loc9_);
            }
            _loc4_++;
         }
      }
      
      protected function UnstreamizeCityDefend_OrganizationRank(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TCityDefendRanks = null;
         var _loc7_:TCityDefendRank = null;
         _loc6_ = param2 as TCityDefendRanks;
         _loc5_ = param1.readUnsignedShort();
         if(_loc5_ > 0)
         {
            _loc6_.Clear();
         }
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = FPoolCityDefend.AcquireCityDefendRank();
            _loc7_.RankName = TUtilityString.FetchUTF(param1);
            _loc7_.RankHarm = param1.readDouble();
            _loc6_.Add(_loc7_);
            _loc4_++;
         }
      }
      
      protected function UnstreamizeCityDefend_HeroRank(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TCityDefendRanks = null;
         var _loc7_:TCityDefendRank = null;
         _loc6_ = param2 as TCityDefendRanks;
         _loc5_ = param1.readUnsignedShort();
         if(_loc5_ > 0)
         {
            _loc6_.Clear();
         }
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = FPoolCityDefend.AcquireCityDefendRank();
            _loc7_.RankName = TUtilityString.FetchUTF(param1);
            _loc7_.RankHarm = param1.readDouble();
            _loc6_.Add(_loc7_);
            _loc4_++;
         }
      }
      
      protected function UnstreamizeCityDefend_DoorHero(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:TCityDefendData = null;
         var _loc9_:TCityDefendHeros = null;
         var _loc10_:TCityDefendHero = null;
         var _loc11_:TCityDefendHero = null;
         _loc8_ = param2 as TCityDefendData;
         _loc9_ = _loc8_.DoorHeroList;
         _loc9_.Clear();
         _loc5_ = param1.readUnsignedShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.readUnsignedInt();
            _loc7_ = param1.readUnsignedInt();
            _loc10_ = FPoolCityDefend.AcquireCityDefendHero(_loc6_,_loc7_);
            _loc9_.Add(_loc10_);
            _loc11_ = _loc8_.HeroList.GetHeroById(_loc6_,_loc7_);
            _loc10_.UserName = _loc11_.UserName;
            _loc10_.UserLevel = _loc11_.UserLevel;
            _loc10_.UserRebirthNum = _loc11_.UserRebirthNum;
            _loc4_++;
         }
      }
      
      protected function UnstreamizeCityDefend_Report(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TCityDefendReports = null;
         var _loc5_:TCityDefendReport = null;
         _loc4_ = param2 as TCityDefendReports;
         _loc5_ = FPoolCityDefend.AcquireCityDefendReport();
         _loc5_.UserName = TUtilityString.FetchUTF(param1);
         _loc5_.IsInitiative = Boolean(param1.readUnsignedByte());
         _loc5_.IsWin = Boolean(param1.readUnsignedByte());
         _loc5_.ReportId = TUtilityString.FetchUTF(param1);
         _loc5_.LastHp = param1.readFloat();
         _loc4_.Add(_loc5_);
      }
      
      public function UnstreamizeCityDefendHero(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizeCityDefend_Hero(param1,param2,param3);
      }
      
      public function UnstreamizeCityDefendOrganizationRank(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizeCityDefend_OrganizationRank(param1,param2,param3);
      }
      
      public function UnstreamizeCityDefendHeroRank(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizeCityDefend_HeroRank(param1,param2,param3);
      }
      
      public function UnstreamizeCityDefendDoorHero(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizeCityDefend_DoorHero(param1,param2,param3);
      }
      
      public function UnstreamizeCityDefendReport(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizeCityDefend_Report(param1,param2,param3);
      }
   }
}

