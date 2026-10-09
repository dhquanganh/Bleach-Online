package Logics.Streamization.VainTravel
{
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.VainTravel.TVainTravelData;
   import Logics.VainTravel.TVainTravelFightReport;
   import Logics.VainTravel.TVainTravelPlayerInfor;
   import Resources.Constants.CONST_VAINTRAVEL;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerVainTravel extends TUnstreamizer
   {
      
      public function TUnstreamizerVainTravel()
      {
         super();
      }
      
      public function UnstreamizationInitPlayerList(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:TVainTravelData = null;
         var _loc10_:TVainTravelPlayerInfor = null;
         var _loc11_:TVainTravelFightReport = null;
         _loc9_ = param2 as TVainTravelData;
         _loc9_.CurrentResetTime = param1.readInt();
         _loc9_.CurrentResetTimeBuied = param1.readInt();
         _loc9_.CurrentReliveTime = param1.readInt();
         _loc9_.CurrentReliveTimeBuied = param1.readInt();
         _loc5_ = param1.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_ = param1.readByte();
            _loc10_ = _loc9_.PlayerInforByIndex(_loc8_);
            _loc10_.Index = _loc8_;
            _loc10_.PlayerIDHigh = param1.readUnsignedInt();
            _loc10_.PlayerIDLow = param1.readUnsignedInt();
            _loc10_.CurrentState = param1.readInt();
            param1.readInt();
            _loc10_.ServerID = param1.readInt();
            _loc10_.PlatformName = TUtilityString.FetchUTF(param1);
            _loc10_.PlayerName = TUtilityString.FetchUTF(param1);
            _loc10_.PlayerLevel = param1.readInt();
            _loc10_.KnifeID = param1.readInt();
            _loc10_.PlayerSkillID = param1.readInt();
            _loc10_.PlayerPower = param1.readInt();
            _loc10_.HeroTemplateID.length = 0;
            _loc10_.HeroLevel.length = 0;
            _loc10_.HeroBloodRate.length = 0;
            _loc10_.HeroChangeSchdule.length = 0;
            _loc10_.HeroFightPos.length = 0;
            _loc7_ = param1.readShort();
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               param1.readInt();
               _loc10_.HeroTemplateID.push(param1.readInt());
               _loc10_.HeroLevel.push(param1.readInt());
               _loc10_.HeroFightPos.push(param1.readByte());
               _loc10_.HeroBloodRate.push(param1.readByte());
               param1.readInt();
               param1.readInt();
               param1.readInt();
               _loc6_++;
            }
            _loc4_++;
         }
         _loc9_.MyHeroIDS.length = 0;
         _loc9_.MyHeroBloodRate.length = 0;
         _loc5_ = param1.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_.MyHeroIDS.push(param1.readInt());
            _loc9_.MyHeroBloodRate.push(param1.readByte());
            _loc4_++;
         }
         _loc9_.VainTravelTodayFightReports.length = 0;
         _loc9_.VainTravelNiceFightReports.length = 0;
         _loc5_ = param1.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc11_ = new TVainTravelFightReport();
            this.UnstreamizationSingleFightReport(param1,_loc11_,null);
            switch(_loc11_.FightReportType)
            {
               case CONST_VAINTRAVEL.BattleReportType_Today:
                  _loc9_.VainTravelTodayFightReports.push(_loc11_);
                  break;
               case CONST_VAINTRAVEL.BattleReportType_Nice:
                  _loc9_.VainTravelNiceFightReports.push(_loc11_);
            }
            _loc4_++;
         }
      }
      
      public function UnstreamizationSingleFightReport(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TVainTravelFightReport = null;
         _loc4_ = param2 as TVainTravelFightReport;
         _loc4_.FightReportTime = param1.readInt();
         _loc4_.FightReportType = param1.readByte();
         _loc4_.FightResult = param1.readByte();
         _loc4_.PlayerNameSources = TUtilityString.FetchUTF(param1);
         _loc4_.PlayerNameDestination = TUtilityString.FetchUTF(param1);
         _loc4_.FightAddr = TUtilityString.FetchUTF(param1);
      }
   }
}

