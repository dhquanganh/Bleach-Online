package Logics.Streamization.TreasureMap
{
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.Spaces.LogicsSpace;
   import Logics.TreasureMap.TPoolTreasureMap;
   import Logics.TreasureMap.TTreasureMapData;
   import Logics.TreasureMap.TTreasureMapHero;
   import Logics.TreasureMap.TTreasureMapHeros;
   import Logics.TreasureMap.TTreasureMapReport;
   import Logics.TreasureMap.TTreasureMapReports;
   import flash.utils.ByteArray;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerTreasureMap extends TUnstreamizer
   {
      
      protected static var FPoolTreasureMap:TPoolTreasureMap;
      
      public function TUnstreamizerTreasureMap()
      {
         super();
      }
      
      LogicsSpace static function PoolsSetup(param1:TPoolTreasureMap) : void
      {
         FPoolTreasureMap = param1;
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TTreasureMapData = null;
         _loc4_ = param2 as TTreasureMapData;
         this.UnstreamizationBaseInfo(param1,_loc4_,param3);
         this.UnstreamizeTreasureMap_FightHero(param1,_loc4_.FightHeroList,param3);
      }
      
      protected function UnstreamizationBaseInfo(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TTreasureMapData = null;
         _loc4_ = param2 as TTreasureMapData;
         _loc4_.CurEnterTimes = param1.readUnsignedByte();
         _loc4_.CurRefreshTimes = param1.readUnsignedByte();
         _loc4_.CurQuality = param1.readUnsignedInt();
         _loc4_.TreasureStatus = Boolean(param1.readUnsignedByte());
         _loc4_.RobberyTimes = param1.readUnsignedByte();
         _loc4_.VipBuyCount = param1.readUnsignedByte();
         _loc4_.BlueStar = param1.readUnsignedInt();
         _loc4_.RedStar = param1.readUnsignedInt();
         _loc4_.TreasureTimes = param1.readUnsignedByte();
      }
      
      protected function UnstreamizeTreasureMap_FightHero(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:TTreasureMapHero = null;
         var _loc7_:TTreasureMapHeros = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         _loc7_ = param2 as TTreasureMapHeros;
         _loc7_.Clear();
         _loc5_ = int(param1.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_ = param1.readUnsignedInt();
            _loc9_ = param1.readUnsignedInt();
            _loc10_ = param1.readUnsignedByte();
            _loc6_ = _loc7_.GetMapHeroByUserIndex(_loc10_);
            if(_loc6_ == null)
            {
               _loc6_ = FPoolTreasureMap.AcquireMapHero(_loc8_,_loc9_);
               _loc7_.Add(_loc6_);
            }
            _loc6_.UserIndex = _loc10_;
            _loc6_.HeroId = param1.readUnsignedInt();
            _loc6_.PlayerNick = TUtilityString.FetchUTF(param1);
            _loc6_.Military = param1.readUnsignedInt();
            _loc6_.PlayerLevel = param1.readUnsignedShort();
            _loc6_.HeroUnionName = TUtilityString.FetchUTF(param1);
            _loc6_.IsGameWin = Boolean(param1.readUnsignedByte());
            _loc6_.LastTime = param1.readUnsignedInt();
            _loc6_.BeRobberyTimes = param1.readUnsignedByte();
            _loc6_.CurQuality = param1.readUnsignedInt();
            _loc4_++;
         }
      }
      
      protected function UnstreamizeTreasureMap_Report(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:TTreasureMapReport = null;
         var _loc7_:TTreasureMapReports = null;
         _loc7_ = param2 as TTreasureMapReports;
         _loc5_ = int(param1.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = FPoolTreasureMap.AcquireMapReport();
            _loc6_.PlayerNick = TUtilityString.FetchUTF(param1);
            _loc6_.PlayerGeneralStarId = param1.readUnsignedInt();
            _loc6_.RobberyPlayerNick = TUtilityString.FetchUTF(param1);
            _loc6_.RobberyGeneralStarId = param1.readUnsignedInt();
            _loc6_.MapQuality = param1.readUnsignedInt();
            _loc6_.GetMoney = param1.readUnsignedInt();
            _loc7_.Add(_loc6_);
            _loc4_++;
         }
      }
      
      public function UnstreamizeTreasureMapHero(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizeTreasureMap_FightHero(param1,param2,param3);
      }
      
      public function UnstreamizeTreasureMapReport(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizeTreasureMap_Report(param1,param2,param3);
      }
   }
}

