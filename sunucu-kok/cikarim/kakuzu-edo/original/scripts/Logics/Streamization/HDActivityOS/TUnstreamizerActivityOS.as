package Logics.Streamization.HDActivityOS
{
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.THDOSRank;
   import Logics.HDActivityOS.TActivityOSArenaRank;
   import Logics.HDActivityOS.TActivityOSCampBattle;
   import Logics.HDActivityOS.TActivityOSCityDefence;
   import Logics.HDActivityOS.TActivityOSCompoundStone;
   import Logics.HDActivityOS.TActivityOSEquipCollection;
   import Logics.HDActivityOS.TActivityOSGroupLv;
   import Logics.HDActivityOS.TActivityOSGroupWar;
   import Logics.HDActivityOS.TActivityOSKillHero;
   import Logics.HDActivityOS.TActivityOSLevelRank;
   import Logics.HDActivityOS.TActivityOSLevelSeat;
   import Logics.HDActivityOS.TActivityOSLevelTalisman;
   import Logics.HDActivityOS.TActivityOSPetSoulDefence;
   import Logics.HDActivityOS.TActivityOSPowerRank;
   import Logics.HDActivityOS.TActivityOSRecruitPartner;
   import Logics.HDActivityOS.THDDailyActivityInfo;
   import Logics.SLogicsCore;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerActivityOS extends TUnstreamizer
   {
      
      public function TUnstreamizerActivityOS()
      {
         super();
      }
      
      protected function UnstreamizationPerform_UpdateLevelRank(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<THDOSRank> = null;
         var _loc7_:TActivityOSLevelRank = null;
         var _loc8_:THDOSRank = null;
         _loc7_ = param2 as TActivityOSLevelRank;
         _loc7_.MyCurRank = -1;
         _loc5_ = param1.readShort();
         _loc6_ = new Vector.<THDOSRank>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_ = new THDOSRank();
            _loc8_.HighID = param1.readUnsignedInt();
            _loc8_.LowID = param1.readUnsignedInt();
            _loc8_.Rank = param1.readUnsignedInt();
            _loc8_.Level = param1.readUnsignedInt();
            _loc8_.Name = TUtilityString.FetchUTF(param1);
            _loc6_[_loc4_] = _loc8_;
            if(_loc8_.HighID == SLogicsCore.Character.Identifier0 && _loc8_.LowID == SLogicsCore.Character.Identifier1)
            {
               _loc7_.MyCurRank = _loc8_.Rank;
            }
            _loc4_++;
         }
         _loc7_.RankList = _loc6_;
      }
      
      protected function UnstreamizationPerform_UpdatePowerRank(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<int> = null;
         var _loc7_:Vector.<THDOSRank> = null;
         var _loc8_:THDOSRank = null;
         var _loc9_:TActivityOSPowerRank = null;
         _loc9_ = param2 as TActivityOSPowerRank;
         _loc9_.MyRank = -1;
         _loc9_.MyHistoryPower = param1.readUnsignedInt();
         _loc5_ = param1.readShort();
         _loc6_ = new Vector.<int>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_[_loc4_] = param1.readInt();
            _loc4_++;
         }
         _loc9_.BoxStatus = _loc6_;
         _loc5_ = param1.readShort();
         _loc7_ = new Vector.<THDOSRank>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_ = new THDOSRank();
            _loc8_.HighID = param1.readUnsignedInt();
            _loc8_.LowID = param1.readUnsignedInt();
            _loc8_.Rank = param1.readUnsignedInt();
            _loc8_.Level = param1.readUnsignedInt();
            _loc8_.Name = TUtilityString.FetchUTF(param1);
            _loc7_[_loc4_] = _loc8_;
            if(_loc8_.HighID == SLogicsCore.Character.Identifier0 && _loc8_.LowID == SLogicsCore.Character.Identifier1)
            {
               _loc9_.MyRank = _loc8_.Rank;
            }
            _loc4_++;
         }
         _loc9_.RankList = _loc7_;
      }
      
      protected function UnstreamizationPerform_UpdateArenaRank(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<THDOSRank> = null;
         var _loc7_:TActivityOSArenaRank = null;
         var _loc8_:THDOSRank = null;
         _loc7_ = param2 as TActivityOSArenaRank;
         _loc5_ = param1.readShort();
         _loc6_ = new Vector.<THDOSRank>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_ = new THDOSRank();
            _loc8_.HighID = param1.readUnsignedInt();
            _loc8_.LowID = param1.readUnsignedInt();
            _loc8_.Level = param1.readUnsignedInt();
            _loc8_.Name = TUtilityString.FetchUTF(param1);
            _loc6_[_loc4_] = _loc8_;
            _loc4_++;
         }
         _loc7_.RankList = _loc6_;
      }
      
      protected function UnstreamizationPerform_UpdateRecruitPartner(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityOSRecruitPartner = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:Vector.<uint> = null;
         _loc6_ = param2 as TActivityOSRecruitPartner;
         _loc5_ = param1.readShort();
         _loc7_ = new Vector.<int>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_[_loc4_] = param1.readInt();
            _loc4_++;
         }
         _loc5_ = param1.readShort();
         _loc8_ = new Vector.<uint>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_[_loc4_] = param1.readUnsignedInt();
            _loc4_++;
         }
         _loc6_.BoxStatus = _loc7_;
         _loc6_.Conditions = _loc8_;
      }
      
      protected function UnstreamizationPerform_UpdateKillHero(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityOSKillHero = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:Vector.<uint> = null;
         _loc6_ = param2 as TActivityOSKillHero;
         _loc5_ = param1.readShort();
         _loc7_ = new Vector.<int>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_[_loc4_] = param1.readInt();
            _loc4_++;
         }
         _loc5_ = param1.readShort();
         _loc8_ = new Vector.<uint>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_[_loc4_] = param1.readUnsignedInt();
            _loc4_++;
         }
         _loc6_.BoxStatus = _loc7_;
         _loc6_.LimitCount = _loc8_;
      }
      
      protected function UnstreamizationPerform_UpdateCampBattle(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityOSCampBattle = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:Vector.<uint> = null;
         _loc6_ = param2 as TActivityOSCampBattle;
         _loc5_ = param1.readShort();
         _loc7_ = new Vector.<int>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_[_loc4_] = param1.readInt();
            _loc4_++;
         }
         _loc5_ = param1.readShort();
         _loc8_ = new Vector.<uint>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_[_loc4_] = param1.readUnsignedInt();
            _loc4_++;
         }
         _loc6_.BoxStatus = _loc7_;
         _loc6_.LimitCount = _loc8_;
      }
      
      protected function UnstreamizationPerform_UpdateLevelSeat(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityOSLevelSeat = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:Vector.<uint> = null;
         _loc6_ = param2 as TActivityOSLevelSeat;
         _loc5_ = param1.readShort();
         _loc7_ = new Vector.<int>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_[_loc4_] = param1.readInt();
            _loc4_++;
         }
         _loc6_.BoxStatus = _loc7_;
         _loc5_ = param1.readShort();
         _loc8_ = new Vector.<uint>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_[_loc4_] = param1.readUnsignedInt();
            _loc4_++;
         }
         _loc6_.PrizeNums = _loc8_;
      }
      
      protected function UnstreamizationPerform_UpdateCompoundStone(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityOSCompoundStone = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:Vector.<uint> = null;
         _loc6_ = param2 as TActivityOSCompoundStone;
         _loc5_ = param1.readShort();
         _loc7_ = new Vector.<int>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_[_loc4_] = param1.readInt();
            _loc4_++;
         }
         _loc5_ = param1.readShort();
         _loc8_ = new Vector.<uint>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_[_loc4_] = param1.readUnsignedInt();
            _loc4_++;
         }
         _loc6_.BoxStatus = _loc7_;
         _loc6_.OwnedCounts = _loc8_;
      }
      
      protected function UnstreamizationPerform_UpdateEquipCollection(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityOSEquipCollection = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:Vector.<uint> = null;
         _loc6_ = param2 as TActivityOSEquipCollection;
         _loc5_ = param1.readShort();
         _loc7_ = new Vector.<int>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_[_loc4_] = param1.readInt();
            _loc4_++;
         }
         _loc5_ = param1.readShort();
         _loc8_ = new Vector.<uint>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_[_loc4_] = param1.readUnsignedInt();
            _loc4_++;
         }
         _loc6_.BoxStatus = _loc7_;
         _loc6_.OwnedCounts = _loc8_;
      }
      
      protected function UnstreamizationPerform_UpdateLevelTalisman(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityOSLevelTalisman = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:Vector.<uint> = null;
         _loc6_ = param2 as TActivityOSLevelTalisman;
         _loc5_ = param1.readShort();
         _loc7_ = new Vector.<int>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_[_loc4_] = param1.readInt();
            _loc4_++;
         }
         _loc5_ = param1.readShort();
         _loc8_ = new Vector.<uint>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_[_loc4_] = param1.readUnsignedInt();
            _loc4_++;
         }
         _loc6_.BoxStatus = _loc7_;
         _loc6_.OwnedCounts = _loc8_;
      }
      
      protected function UnstreamizationPerform_UpdatePetSoulDefence(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityOSPetSoulDefence = null;
         var _loc7_:THDDailyActivityInfo = null;
         _loc6_ = param2 as TActivityOSPetSoulDefence;
         _loc5_ = param1.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = new THDDailyActivityInfo();
            _loc7_.UserID0 = param1.readUnsignedInt();
            _loc7_.UserID1 = param1.readUnsignedInt();
            _loc7_.Family = param1.readUnsignedInt();
            _loc7_.Level = param1.readUnsignedInt();
            _loc7_.Name = TUtilityString.FetchUTF(param1);
            _loc7_.Hurt = param1.readUnsignedInt();
            _loc6_.Infos[_loc4_] = _loc7_;
            _loc4_++;
         }
      }
      
      protected function UnstreamizationPerform_UpdateGroupLv(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityOSGroupLv = null;
         var _loc7_:Vector.<String> = null;
         var _loc8_:Vector.<String> = null;
         var _loc9_:Vector.<String> = null;
         _loc6_ = param2 as TActivityOSGroupLv;
         _loc5_ = param1.readShort();
         _loc7_ = new Vector.<String>(3);
         _loc8_ = new Vector.<String>(3);
         _loc9_ = new Vector.<String>(3);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_[_loc4_] = TUtilityString.FetchUTF(param1);
            _loc4_++;
         }
         _loc6_.Info.OrgRank0 = _loc7_;
         _loc5_ = param1.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_[_loc4_] = TUtilityString.FetchUTF(param1);
            _loc4_++;
         }
         _loc6_.Info.OrgRank1 = _loc8_;
         _loc5_ = param1.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_[_loc4_] = TUtilityString.FetchUTF(param1);
            _loc4_++;
         }
         _loc6_.Info.OrgRank2 = _loc9_;
      }
      
      protected function UnstreamizationPerform_UpdateGroupWar(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityOSGroupWar = null;
         var _loc7_:THDDailyActivityInfo = null;
         _loc6_ = param2 as TActivityOSGroupWar;
         _loc5_ = param1.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = new THDDailyActivityInfo();
            _loc7_.Family = param1.readUnsignedInt();
            _loc7_.OrgLevel = param1.readUnsignedInt();
            _loc7_.OrgName = TUtilityString.FetchUTF(param1);
            _loc7_.Score = param1.readUnsignedInt();
            _loc6_.Infos[_loc4_] = _loc7_;
            _loc4_++;
         }
      }
      
      protected function UnstreamizationPerform_UpdateCityDefence(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityOSCityDefence = null;
         var _loc7_:THDDailyActivityInfo = null;
         _loc6_ = param2 as TActivityOSCityDefence;
         _loc5_ = param1.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = new THDDailyActivityInfo();
            _loc7_.Family = param1.readUnsignedInt();
            _loc7_.OrgLevel = param1.readUnsignedInt();
            _loc7_.OrgName = TUtilityString.FetchUTF(param1);
            _loc7_.IsWin = param1.readUnsignedInt();
            _loc6_.Infos[_loc4_] = _loc7_;
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateLevelRank(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateLevelRank(param1,param2,param3);
      }
      
      public function UnstreamizeUpdatePowerRank(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdatePowerRank(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateArenaRank(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateArenaRank(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateRecruitPartner(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateRecruitPartner(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateKillHero(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateKillHero(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateCampBattle(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateCampBattle(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateLevelSeat(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateLevelSeat(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateCompoundStone(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateCompoundStone(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateEquipCollection(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateEquipCollection(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateLevelTailsman(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateLevelTalisman(param1,param2,param3);
      }
      
      public function UnstreamizeUpdatePetSoulDefence(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdatePetSoulDefence(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateGroupLv(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateGroupLv(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateGroupWar(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateGroupWar(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateCityDefence(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateCityDefence(param1,param2,param3);
      }
   }
}

