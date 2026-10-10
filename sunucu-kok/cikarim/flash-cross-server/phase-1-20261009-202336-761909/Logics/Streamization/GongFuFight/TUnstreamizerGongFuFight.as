package Logics.Streamization.GongFuFight
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.Buffs.*;
   import Logics.DatebaseVO.VO.Json.TRewards;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.DatebaseVO.VO.TGSPVPDailyAward;
   import Logics.DatebaseVO.VO.TGSPVP_Reward;
   import Logics.GongFuFight.TGongFuFightBaseInfor;
   import Logics.GongFuFight.TGongFuFightData;
   import Logics.GongFuFight.TGongFuFightPay;
   import Logics.GongFuFight.TGongFuFightPayRecord;
   import Logics.GongFuFight.TGongFuFightPlayerGroup;
   import Logics.GongFuFight.TGongFuFightPlayerInfor;
   import Logics.GongFuFight.TGongFuFightRankInfor;
   import Logics.GongFuFight.TGongFuFightRecord;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_GONGFUFIGHT;
   import flash.utils.*;
   
   public class TUnstreamizerGongFuFight extends TUnstreamizer
   {
      
      protected static const SortMap:Vector.<int> = Vector.<int>([18,17,16,15,14,13,12,11,9,8,6,10,7,4,3,5,2,1]);
      
      protected var GongFuFightPlayerInfors:Vector.<TGongFuFightPlayerInfor>;
      
      public function TUnstreamizerGongFuFight()
      {
         super();
         this.GongFuFightPlayerInfors = new Vector.<TGongFuFightPlayerInfor>();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
      }
      
      protected function UnstreamizationPerform_Properties(param1:ByteArray, param2:Object, param3:Object) : void
      {
      }
      
      protected function CreateAwardStringByAward(param1:TRewards) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc4_ = "";
         _loc3_ = int(param1.Count);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ += SToolReward.GetNameByTypeCode(param1.Type[_loc2_],param1.Code[_loc2_]);
            _loc4_ = _loc4_ + ("*" + param1.Amount[_loc2_] + "\n");
            _loc2_++;
         }
         return _loc4_.substr(0,_loc4_.length - 1);
      }
      
      protected function CreateChallengeList(param1:Vector.<uint>, param2:Vector.<TGongFuFightPlayerGroup>, param3:ByteArray, param4:Vector.<int> = null) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:TGongFuFightPlayerGroup = null;
         var _loc13_:TGongFuFightPlayerInfor = null;
         this.GongFuFightPlayerInfors.length = 0;
         _loc6_ = int(param3.readUnsignedShort());
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc13_ = new TGongFuFightPlayerInfor();
            _loc13_.PlayerIndex = param3.readUnsignedInt();
            _loc13_.PlayerName = TUtilityString.FetchUTF(param3);
            _loc13_.PlayerServerName = TUtilityString.FetchUTF(param3);
            _loc13_.PlayerMainHeroID = param3.readUnsignedInt();
            _loc13_.PlayerFriendID.push(_loc13_.PlayerMainHeroID);
            _loc10_ = int(param3.readUnsignedShort());
            _loc9_ = 0;
            while(_loc9_ < _loc10_)
            {
               _loc13_.PlayerFriendID.push(param3.readUnsignedInt());
               _loc9_++;
            }
            _loc13_.PlayerLevel = param3.readUnsignedInt();
            _loc13_.PlayerQuality = param3.readUnsignedInt();
            _loc13_.PlayerFightPowerValue = param3.readUnsignedInt();
            _loc13_.PlayerPet = param3.readUnsignedInt();
            _loc13_.KnifeID = param3.readUnsignedInt();
            _loc13_.PlayerScore = param3.readUnsignedInt();
            _loc13_.State = param3.readByte() == 1 ? CONST_GONGFUFIGHT.PlayerState_Killed : CONST_GONGFUFIGHT.PlayerState_Safe;
            this.GongFuFightPlayerInfors.push(_loc13_);
            _loc5_++;
         }
         if(param4 != null)
         {
            this.SortChallengeList(this.GongFuFightPlayerInfors,param4);
         }
         _loc9_ = 0;
         _loc6_ = int(param1.length);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc8_ = int(param1[_loc5_]);
            _loc12_ = new TGongFuFightPlayerGroup();
            _loc7_ = 0;
            while(_loc7_ < _loc8_)
            {
               _loc12_.PlayersInfor.push(this.GongFuFightPlayerInfors[_loc9_]);
               _loc9_++;
               _loc7_++;
            }
            param2.push(_loc12_);
            _loc5_++;
         }
      }
      
      protected function SortChallengeList(param1:Vector.<TGongFuFightPlayerInfor>, param2:Vector.<int>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TGongFuFightPlayerInfor = null;
         _loc4_ = int(SortMap.length);
         _loc6_ = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = SortMap[_loc3_];
            _loc5_ = _loc3_;
            while(_loc5_ < _loc6_)
            {
               _loc8_ = param1[_loc5_];
               if(_loc8_.PlayerIndex == _loc7_)
               {
                  param1[_loc5_] = param1[_loc3_];
                  param1[_loc3_] = _loc8_;
                  break;
               }
               _loc5_++;
            }
            _loc3_++;
         }
      }
      
      public function UnstreamizationPerformRankInfor(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TGongFuFightData = null;
         var _loc5_:TGongFuFightRankInfor = null;
         var _loc6_:Vector.<TGongFuFightRankInfor> = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc8_ = int(param1.readUnsignedShort());
         _loc4_ = param2 as TGongFuFightData;
         _loc6_ = _loc4_.GongFuFightRankInfors;
         _loc9_ = int(_loc6_.length);
         _loc4_.GongFuFightRankEffectNum = _loc8_;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            if(_loc7_ < _loc9_)
            {
               _loc5_ = _loc6_[_loc7_];
            }
            else
            {
               _loc5_ = new TGongFuFightRankInfor();
               _loc6_.push(_loc5_);
            }
            _loc5_.CurrentRank = param1.readUnsignedInt();
            _loc5_.PlayerName = TUtilityString.FetchUTF(param1);
            _loc5_.ServerName = TUtilityString.FetchUTF(param1);
            _loc5_.PlayerLevel = param1.readUnsignedInt();
            _loc5_.PlayerScore = param1.readUnsignedInt();
            _loc5_.PlayerGroupLevel = param1.readUnsignedInt();
            _loc7_++;
         }
      }
      
      public function UnstreamizationPerformPayRecord(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TGongFuFightData = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TGongFuFightPayRecord = null;
         var _loc8_:int = 0;
         _loc6_ = int(param1.readUnsignedShort());
         _loc4_ = param2 as TGongFuFightData;
         _loc8_ = int(_loc4_.GongFuPayRecord.length);
         _loc4_.GongFuPayEffectNum = _loc6_;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            if(_loc5_ < _loc8_)
            {
               _loc7_ = _loc4_.GongFuPayRecord[_loc5_];
            }
            else
            {
               _loc7_ = new TGongFuFightPayRecord();
               _loc4_.GongFuPayRecord.push(_loc7_);
            }
            _loc7_.PlayerName = TUtilityString.FetchUTF(param1);
            _loc7_.PayQuality = param1.readUnsignedInt();
            _loc7_.PayID = param1.readUnsignedInt();
            _loc5_++;
         }
      }
      
      public function UnstreamizationPerformBaseInfor(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TGongFuFightBaseInfor = null;
         _loc4_ = param2 as TGongFuFightBaseInfor;
         _loc4_.RankYesterday = param1.readUnsignedInt();
         _loc4_.RankToday = param1.readUnsignedInt();
         _loc4_.FightValue = param1.readUnsignedInt();
         _loc4_.GrounpLevel = param1.readUnsignedInt();
         _loc4_.ScoreYesterDay = param1.readUnsignedInt();
         _loc4_.ScoreToday = param1.readUnsignedInt();
         _loc4_.CurFightTimes = param1.readUnsignedInt();
         _loc4_.LastFightSce = param1.readUnsignedInt();
         _loc4_.IfApplyToday = param1.readUnsignedInt() != 0;
         _loc4_.ToastTimes = param1.readUnsignedInt();
         _loc4_.SpanFightFlag = param1.readUnsignedByte();
         _loc4_.CanBuyTime = param1.readUnsignedInt();
         _loc4_.ApplyYesterdaySce = param1.readUnsignedInt();
         _loc4_.BoxState = param1.readByte();
      }
      
      public function UnstreamizationPerformWorkTimes(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TGongFuFightBaseInfor = null;
         var _loc5_:TConfigValue = null;
         var _loc6_:Vector.<uint> = null;
         _loc4_ = param2 as TGongFuFightBaseInfor;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.GongFuFight_ApplyTime) as TConfigValue;
         _loc6_ = _loc5_.Value as Vector.<uint>;
         _loc4_.TimeCanApply = 0;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.GongFuFight_FightOpenTime) as TConfigValue;
         _loc6_ = _loc5_.Value as Vector.<uint>;
         _loc4_.TimeStartFight = 0;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.GongFuFight_FightCloseTime) as TConfigValue;
         _loc6_ = _loc5_.Value as Vector.<uint>;
         _loc4_.TimeEndFight = 86400;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.GongFuFight_EveryLayerPlayerNum) as TConfigValue;
         CONST_GONGFUFIGHT.GroupsPlayerNum = _loc5_.Value as Vector.<uint>;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.GongFuFight_SuperLevelLayerPlayerNum) as TConfigValue;
         CONST_GONGFUFIGHT.GroupsSuperLevelPlayerNum = _loc5_.Value as Vector.<uint>;
      }
      
      public function UnstreamizationPerformPayInfor(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TGongFuFightData = null;
         var _loc5_:TGongFuFightPay = null;
         var _loc6_:TGSPVPDailyAward = null;
         var _loc7_:TBins = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc4_ = param2 as TGongFuFightData;
         _loc7_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_GSPVP_DailyAward);
         _loc4_.GongFuFightPayInfors.length = 0;
         _loc9_ = _loc7_.Count;
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc5_ = new TGongFuFightPay();
            _loc6_ = _loc7_.GetDatebaseByIndex(_loc8_) as TGSPVPDailyAward;
            _loc5_.GSPVPDailyAward = _loc6_;
            SToolReward.CreateRewardInventoryByRewardInfor(_loc6_.Awards,_loc5_.PayReward);
            _loc4_.GongFuFightPayInfors.push(_loc5_);
            _loc8_++;
         }
      }
      
      public function UnstreamizationPerformChallengeList(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TGongFuFightData = null;
         _loc4_ = param2 as TGongFuFightData;
         this.CreateChallengeList(CONST_GONGFUFIGHT.GroupsPlayerNum,_loc4_.PlayerNormalGroups,param1,null);
         this.CreateChallengeList(CONST_GONGFUFIGHT.GroupsSuperLevelPlayerNum,_loc4_.PlayerSuperLevelGroups,param1,null);
         this.UnstreamizationPerformLayerAward(null,param2,null);
      }
      
      public function UnstreamizationPerformFightRecord(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:TGongFuFightData = null;
         var _loc7_:TGongFuFightRecord = null;
         var _loc8_:Vector.<TGongFuFightRecord> = null;
         var _loc9_:int = 0;
         var _loc10_:ByteArray = null;
         _loc6_ = param2 as TGongFuFightData;
         _loc10_ = param1 as ByteArray;
         _loc9_ = int(_loc6_.GongFuFightRecords.length);
         _loc5_ = _loc10_.readUnsignedShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(_loc4_ < _loc9_)
            {
               _loc7_ = _loc6_.GongFuFightRecords[_loc4_];
            }
            else
            {
               _loc7_ = new TGongFuFightRecord();
               _loc6_.GongFuFightRecords.push(_loc7_);
            }
            _loc7_.Name = TUtilityString.FetchUTF(_loc10_);
            _loc7_.Time = _loc10_.readUnsignedInt();
            _loc7_.ReportID = TUtilityString.FetchUTF(_loc10_);
            _loc7_.IsWin = Boolean(_loc10_.readUnsignedInt());
            _loc4_++;
         }
         _loc6_.GongFuRecordEffectNum = _loc5_;
      }
      
      public function UnstreamizationPerformLayerAward(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TGongFuFightData = null;
         var _loc5_:Vector.<TGongFuFightPlayerGroup> = null;
         var _loc6_:TGongFuFightPlayerGroup = null;
         var _loc7_:TBins = null;
         var _loc8_:TGSPVP_Reward = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         _loc7_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_GSPVP_Reward);
         _loc4_ = param2 as TGongFuFightData;
         _loc5_ = _loc4_.PlayerNormalGroups;
         _loc10_ = int(CONST_GONGFUFIGHT.GroupsPlayerNum.length);
         _loc11_ = _loc4_.GongFuFightBaseInfor.GrounpLevel * 5;
         _loc11_ = _loc11_ + CONST_GONGFUFIGHT.GongFuFightLayerAwardStartID;
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            _loc8_ = _loc7_.GetDatebaseByIdentifier(_loc11_) as TGSPVP_Reward;
            _loc6_ = _loc5_[_loc9_];
            _loc6_.Rewards.Clear();
            _loc6_.RewardID = _loc8_.Identifier;
            SToolReward.CreateRewardInventoryByRewardInfor(_loc8_.Rewards,_loc6_.Rewards);
            _loc11_++;
            _loc9_++;
         }
      }
   }
}

