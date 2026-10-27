package Logics.Streamization.Organization
{
   import Foundation.Common.Integer.UInt64;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.TBlackMarket;
   import Logics.DatebaseVO.VO.TCity;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.DatebaseVO.VO.TEnemyArmy;
   import Logics.DatebaseVO.VO.TMall;
   import Logics.DatebaseVO.VO.TOrgPointAward;
   import Logics.DatebaseVO.VO.TOrgPointInfo;
   import Logics.Organization.NewFeatures.TNewOrgData;
   import Logics.Organization.NewFeatures.TNewOrgSystemLanguage;
   import Logics.Organization.TBaseOrganization;
   import Logics.Organization.VO.TEnemyVO;
   import Logics.Organization.VO.THeroExchangeVO;
   import Logics.Organization.VO.TOrgApplyListBarVO;
   import Logics.Organization.VO.TOrgConfigValueVO;
   import Logics.Organization.VO.TOrgCopyVO;
   import Logics.Organization.VO.TOrgDamageRankBarVO;
   import Logics.Organization.VO.TOrgDistRecordBarVO;
   import Logics.Organization.VO.TOrgShopCommodityItemVO;
   import Logics.Organization.VO.TOrgSpoilsBarVO;
   import Logics.Organization.VO.TPointInfoVO;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_BLACKMARKET;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_MALL;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerOrganizationNew
   {
      
      protected const Single_Type:uint = 6;
      
      protected const Group_Type:uint = 7;
      
      protected var FData:TNewOrgData;
      
      public function TUnstreamizerOrganizationNew(param1:TNewOrgData)
      {
         super();
         this.FData = param1;
      }
      
      protected function UnstreamizerCopyConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TBins = null;
         var _loc5_:TBins = null;
         var _loc6_:uint = 0;
         var _loc7_:TCity = null;
         var _loc8_:TOrgCopyVO = null;
         var _loc9_:TOrgPointInfo = null;
         var _loc10_:TPointInfoVO = null;
         var _loc11_:TEnemyArmy = null;
         var _loc12_:TBins = null;
         var _loc13_:Vector.<uint> = null;
         var _loc14_:uint = 0;
         var _loc15_:TEnemyVO = null;
         _loc4_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_City);
         _loc5_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrgPointInfo);
         _loc12_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_EnemyArmy);
         _loc6_ = uint(_loc4_.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc6_)
         {
            _loc7_ = _loc4_.GetDatebaseByIndex(_loc1_) as TCity;
            if(_loc7_.Type == this.Single_Type || _loc7_.Type == this.Group_Type)
            {
               _loc8_ = new TOrgCopyVO();
               _loc8_.City = _loc7_;
               _loc2_ = uint(_loc7_.Start);
               while(_loc2_ <= _loc7_.Last)
               {
                  _loc9_ = _loc5_.GetDatebaseByIdentifier(_loc2_) as TOrgPointInfo;
                  _loc10_ = new TPointInfoVO();
                  _loc10_.PointInfo = _loc9_;
                  _loc10_.RoleTempleteID = _loc2_;
                  _loc10_.Index = _loc2_ - _loc7_.Start;
                  _loc8_.PointInfoVOs.push(_loc10_);
                  _loc11_ = _loc12_.GetDatebaseByIdentifier(_loc9_.Army.army[0]) as TEnemyArmy;
                  _loc13_ = _loc11_.EnemyPosVect;
                  _loc14_ = _loc13_.length;
                  _loc3_ = 0;
                  while(_loc3_ < _loc14_)
                  {
                     _loc15_ = new TEnemyVO();
                     _loc15_.Pos = _loc13_[_loc3_];
                     _loc10_.Enemys[_loc3_] = _loc15_;
                     _loc3_++;
                  }
                  _loc2_++;
               }
               if(_loc7_.Type == this.Single_Type)
               {
                  this.FData.SingleCopys.push(_loc8_);
               }
               else if(_loc7_.Type == this.Group_Type)
               {
                  this.FData.GroupCopys.push(_loc8_);
               }
            }
            _loc1_++;
         }
      }
      
      protected function UnstreamizerConfigValue() : void
      {
         var _loc1_:TBins = null;
         var _loc2_:TConfigValue = null;
         var _loc3_:TOrgConfigValueVO = null;
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc3_ = this.FData.OrgConfigValue;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Personal_Daily_Number) as TConfigValue;
         _loc3_.Personal_Daily_Number = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Personal_Everyone_ActionForce) as TConfigValue;
         _loc3_.Personal_Everyone_ActionForce = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Personal_Reset_Price) as TConfigValue;
         _loc3_.Personal_Reset_Price = _loc2_.Value as Vector.<uint>;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.ActionForce_LegionActive) as TConfigValue;
         _loc3_.ActionForce_LegionActive = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.ActionForce_LegionActive) as TConfigValue;
         _loc3_.ActionForce_LegionActive = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Legion_DailyTimes) as TConfigValue;
         _loc3_.Legion_DailyTimes = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Legion_Additional_AwardTime) as TConfigValue;
         _loc3_.Legion_Additional_AwardTime = int(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Legion_Additional_Award) as TConfigValue;
         _loc3_.Legion_Additional_Award = _loc2_.Value as Vector.<uint>;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Legion_Open_Consumption) as TConfigValue;
         _loc3_.Legion_Open_Consumption = _loc2_.Value as Vector.<uint>;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Legion_Reset_Consumption) as TConfigValue;
         _loc3_.Legion_Reset_Consumption = _loc2_.Value as Vector.<uint>;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.ORG_Mall_RefleshTime) as TConfigValue;
         _loc3_.ORG_Mall_RefleshTime = _loc2_.Value as Vector.<uint>;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.ORG_Mall_DailyRefleshTime) as TConfigValue;
         _loc3_.ORG_Mall_DailyRefleshTime = _loc2_.Value as Vector.<uint>;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.ORG_Mall_RefleshPrice) as TConfigValue;
         _loc3_.Mall_Reset_Price = _loc2_.Value as Vector.<uint>;
      }
      
      protected function UnstreamizerCopyAward() : void
      {
         var _loc1_:TBins = null;
         var _loc2_:TOrgPointAward = null;
         var _loc3_:TOrgSpoilsBarVO = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:TOrgCopyVO = null;
         var _loc10_:Array = null;
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrgPointAward);
         _loc5_ = this.FData.GroupCopys.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_ = this.FData.GroupCopys[_loc4_];
            _loc8_ = uint(_loc9_.City.Identifier);
            _loc2_ = _loc1_.GetDatebaseByIdentifier(_loc8_) as TOrgPointAward;
            _loc10_ = _loc2_.Arr;
            _loc7_ = _loc10_.length;
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc3_ = new TOrgSpoilsBarVO();
               _loc3_.Code = _loc10_[_loc6_];
               _loc9_.SpoilsVOs.push(_loc3_);
               _loc6_++;
            }
            _loc4_++;
         }
      }
      
      protected function UnstreamizerMall() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TBins = null;
         var _loc4_:TBins = null;
         var _loc5_:TBins = null;
         var _loc6_:TArticle = null;
         var _loc7_:TMall = null;
         var _loc8_:THeroExchangeVO = null;
         _loc3_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Mall);
         _loc4_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Article);
         _loc5_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         _loc2_ = uint(_loc3_.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc7_ = _loc3_.GetDatebaseByIndex(_loc1_) as TMall;
            if(_loc7_.Model == CONST_MALL.TYPE_MODEL_ORGSHOP && _loc7_.MajorType == CONST_MALL.MAJORTYPE_MALL_Hero)
            {
               _loc8_ = new THeroExchangeVO();
               _loc8_.Hero = _loc5_.GetDatebaseByIdentifier(_loc7_.ItemID) as TBaseHero;
               _loc8_.IsExchange = false;
               _loc8_.Mall = _loc7_;
               _loc6_ = _loc4_.GetDatebaseByIdentifier(_loc7_.Items.Code) as TArticle;
               _loc8_.NeedAwardName = _loc6_.Name;
               this.FData.HeroExchangeVOs.push(_loc8_);
            }
            _loc1_++;
         }
      }
      
      public function UnstreamizerConfig() : void
      {
         var _loc1_:TNewOrgSystemLanguage = null;
         this.UnstreamizerCopyConfig();
         this.UnstreamizerConfigValue();
         this.UnstreamizerCopyAward();
         _loc1_ = new TNewOrgSystemLanguage(this.FData);
      }
      
      public function SingleInitRet(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         _loc3_ = Math.min(param1.readInt(),this.FData.SingleCopys.length - 1);
         _loc2_ = 0;
         while(_loc2_ <= _loc3_)
         {
            this.FData.SingleCopys[_loc2_].Open = true;
            _loc2_++;
         }
      }
      
      public function SingleEnterRet(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TPointInfoVO = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         _loc6_ = uint(param1.readInt());
         _loc5_ = this.FData.CurrentCopy.PointInfoVOs.length;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc4_ = this.FData.CurrentCopy.PointInfoVOs[_loc3_];
            if(_loc3_ < _loc6_)
            {
               _loc4_.State = TPointInfoVO.STATE_ALLOWPLAY_SINGLE;
               _loc4_.Pass = true;
            }
            else if(_loc3_ == _loc6_)
            {
               _loc4_.State = TPointInfoVO.STATE_ALLOWPLAY_SINGLE;
               _loc4_.Pass = false;
            }
            else
            {
               _loc4_.State = TPointInfoVO.STATE_NOTPLAY_SINGLE;
               _loc4_.Pass = false;
            }
            _loc3_++;
         }
         _loc2_ = param1.readShort();
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc7_ = uint(param1.readInt());
            _loc8_ = uint(param1.readInt());
            _loc9_ = uint(param1.readInt());
            _loc4_ = this.FData.CurrentCopy.PointInfoVOs[_loc7_];
            _loc4_.FightCount = _loc8_;
            _loc4_.ResetCount = _loc9_;
            _loc3_++;
         }
      }
      
      public function SingleChallengeRet(param1:ByteArray) : void
      {
         ++this.FData.CurrentPoint.FightCount;
      }
      
      public function PointRefreshRet(param1:ByteArray) : void
      {
         this.FData.CurrentPoint.ResetCount = param1.readInt();
         this.FData.CurrentPoint.FightCount = 0;
      }
      
      public function AutoFightRet(param1:ByteArray) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TArticle = null;
         var _loc6_:TBins = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         this.FData.CurrentPoint.FightCount = param1.readInt();
         _loc2_ = "";
         _loc6_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Article);
         _loc4_ = int(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc8_ = param1.readUnsignedShort();
            _loc7_ = param1.readUnsignedInt();
            _loc7_ = CONST_COMMON.RewardIDToTemplateID(_loc8_,_loc7_);
            _loc5_ = _loc6_.GetDatebaseByIdentifier(_loc7_) as TArticle;
            if(_loc3_ != 0)
            {
               _loc2_ += "\n";
            }
            _loc2_ += TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_09),_loc5_.Name,param1.readUnsignedInt());
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function GroupInitRet(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:TOrgCopyVO = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc5_ = param1.readInt();
         if(_loc5_ != -1)
         {
            _loc2_ = 0;
            while(_loc2_ <= _loc5_)
            {
               this.FData.SingleCopys[_loc2_].Pass = true;
               _loc2_++;
            }
         }
         _loc3_ = param1.readShort();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FData.GroupCopys[_loc2_];
            _loc4_.Open = true;
            _loc4_.FightCount = param1.readInt();
            _loc6_ = param1.readInt();
            _loc4_.RewardRemainTime = this.FData.GetRewardRemainTimeByOpenTime(_loc6_);
            this.FData.FormatTimeForGroupCopy(_loc4_);
            _loc2_++;
         }
      }
      
      public function GroupOpenRet(param1:ByteArray, param2:TBaseOrganization) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TOrgCopyVO = null;
         var _loc5_:uint = 0;
         _loc3_ = uint(param1.readInt());
         _loc5_ = this.FData.OrgConfigValue.Legion_Open_Consumption[_loc3_];
         _loc4_ = this.FData.GroupCopys[_loc3_];
         _loc4_.RewardRemainTime = this.FData.GetRewardRemainTimeByOpenTime(param1.readInt());
         _loc4_.Open = true;
         param2.GroupActive = Math.max(param2.GroupActive - _loc5_,0);
      }
      
      public function GroupEnterRet(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TOrgCopyVO = null;
         var _loc4_:TPointInfoVO = null;
         var _loc5_:Vector.<TPointInfoVO> = null;
         var _loc6_:uint = 0;
         var _loc7_:TEnemyVO = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         _loc8_ = uint(param1.readInt());
         _loc9_ = uint(param1.readInt());
         _loc12_ = uint(param1.readShort());
         _loc3_ = this.FData.CurrentCopy;
         _loc5_ = _loc3_.PointInfoVOs;
         _loc6_ = _loc5_.length;
         _loc2_ = 0;
         while(_loc2_ < _loc6_)
         {
            _loc4_ = _loc5_[_loc2_];
            if(_loc2_ < _loc8_)
            {
               _loc4_.HP = 0;
               _loc4_.State = TPointInfoVO.STATE_DIE_GROUP;
               _loc4_.Pass = true;
            }
            else if(_loc2_ == _loc8_)
            {
               _loc4_.HP = _loc9_;
               _loc4_.State = TPointInfoVO.STATE_PLAYING_GROUP;
               _loc4_.Pass = false;
            }
            else
            {
               _loc4_.HP = TPointInfoVO.MAXHP;
               _loc4_.State = TPointInfoVO.STATE_NOTPLAY_GROUP;
               _loc4_.Pass = false;
            }
            _loc2_++;
         }
         _loc3_.Pass = _loc4_.Pass;
         if(_loc8_ < _loc5_.length)
         {
            _loc4_ = _loc5_[_loc8_];
            _loc2_ = 0;
            while(_loc2_ < _loc12_)
            {
               _loc10_ = uint(param1.readInt());
               _loc11_ = uint(param1.readInt());
               _loc7_ = this.FData.GetEnemyVOByPos(_loc4_,_loc10_);
               _loc7_.HP = _loc11_;
               _loc2_++;
            }
         }
      }
      
      public function CopyRefreshRet(param1:ByteArray, param2:TBaseOrganization) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TOrgCopyVO = null;
         var _loc5_:uint = 0;
         _loc3_ = uint(param1.readInt());
         _loc5_ = this.FData.OrgConfigValue.Legion_Reset_Consumption[_loc3_];
         _loc4_ = this.FData.GroupCopys[_loc3_];
         _loc4_.RewardRemainTime = this.FData.GetRewardRemainTimeByOpenTime(param1.readInt());
         param2.GroupActive = Math.max(param2.GroupActive - _loc5_,0);
      }
      
      public function AllocationRet(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TOrgDistRecordBarVO = null;
         var _loc5_:Date = new Date(0);
         this.FData.DistRecordVOs.length = 0;
         _loc3_ = uint(param1.readShort());
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            param1.readInt();
            param1.readInt();
            _loc4_ = new TOrgDistRecordBarVO();
            _loc4_.Name = TUtilityString.FetchUTF(param1);
            _loc4_.Type = param1.readShort();
            _loc4_.Code = param1.readInt();
            _loc4_.Count = param1.readInt();
            _loc5_.setTime(param1.readInt() * 1000);
            _loc4_.Time = this.FData.NewOrgSystemLanguage.GetStr24(_loc5_.month,_loc5_.date,_loc5_.hours,_loc5_.minutes);
            this.FData.DistRecordVOs.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function SpoilsRet(param1:ByteArray) : void
      {
         var _loc2_:TOrgCopyVO = null;
         var _loc3_:TOrgSpoilsBarVO = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         _loc2_ = this.FData.CurrentCopy;
         _loc5_ = uint(param1.readShort());
         _loc7_ = _loc2_.SpoilsVOs.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_ = uint(param1.readShort());
            _loc9_ = uint(param1.readInt());
            _loc10_ = uint(param1.readInt());
            _loc11_ = uint(param1.readInt());
            _loc12_ = uint(param1.readInt());
            _loc13_ = uint(param1.readInt());
            _loc3_ = null;
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc3_ = _loc2_.SpoilsVOs[_loc6_];
               if(_loc3_.Code == _loc9_ && _loc3_.Type == _loc8_)
               {
                  break;
               }
               _loc6_++;
            }
            if(_loc3_ == null)
            {
               return;
            }
            _loc3_.Count = _loc10_;
            _loc3_.IsApp = Boolean(_loc11_);
            _loc3_.Rank = _loc12_;
            _loc3_.AppCount = _loc13_;
            _loc4_++;
         }
         this.FData.CurrentHaveApply = Boolean(param1.readInt());
         if(this.FData.CurrentHaveApply)
         {
            this.FData.ApplyType = param1.readInt();
            this.FData.ApplyCode = param1.readInt();
            this.FData.ApplyRank = param1.readInt();
         }
      }
      
      public function AttValueRet(param1:ByteArray) : void
      {
         var _loc2_:TOrgDamageRankBarVO = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:UInt64 = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         _loc4_ = uint(param1.readShort());
         this.FData.DamageRankVOs.length = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = new TOrgDamageRankBarVO();
            param1.readInt();
            param1.readInt();
            _loc2_.Name = TUtilityString.FetchUTF(param1);
            _loc7_ = uint(param1.readInt());
            _loc6_ = uint(param1.readInt());
            _loc5_ = new UInt64(_loc6_,_loc7_);
            _loc2_.Damage = _loc5_.ToNumber();
            _loc2_.Rank = param1.readInt();
            this.FData.DamageRankVOs.push(_loc2_);
            _loc3_++;
         }
      }
      
      public function GroupChallengeRet(param1:ByteArray) : void
      {
         ++this.FData.CurrentCopy.FightCount;
      }
      
      public function ApplyRet(param1:ByteArray) : void
      {
         this.SpoilsRet(param1);
      }
      
      public function ApplyListRet(param1:ByteArray) : void
      {
         var _loc2_:TOrgApplyListBarVO = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc4_ = uint(param1.readShort());
         this.FData.ApplyListVOs.length = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = new TOrgApplyListBarVO();
            param1.readInt();
            param1.readInt();
            _loc2_.Name = TUtilityString.FetchUTF(param1);
            _loc2_.Rank = param1.readInt();
            this.FData.ApplyListVOs.push(_loc2_);
            _loc3_++;
         }
      }
      
      public function UpDateRet(param1:ByteArray) : void
      {
         this.GroupEnterRet(param1);
      }
      
      public function MallInitRet(param1:int, param2:ByteArray) : void
      {
         var _loc3_:Vector.<TOrgShopCommodityItemVO> = null;
         var _loc4_:TOrgShopCommodityItemVO = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TArticle = null;
         var _loc8_:TBins = null;
         var _loc9_:TBins = null;
         var _loc10_:int = 0;
         _loc8_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Article);
         _loc9_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BlackMarket);
         _loc3_ = param1 == CONST_BLACKMARKET.MarketID_OrgNormalMarket ? this.FData.ShopVOs : this.FData.SpecialVOs;
         _loc3_.length = 0;
         this.FData.MallRefreshCounts = param2.readInt();
         param2.readInt();
         this.FData.GroupMoney = param2.readInt();
         _loc6_ = uint(param2.readShort());
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc10_ = param2.readInt();
            _loc4_ = new TOrgShopCommodityItemVO();
            _loc4_.Market = _loc9_.GetDatebaseByIdentifier(_loc10_) as TBlackMarket;
            _loc4_.BuyCount = param2.readInt();
            _loc7_ = _loc8_.GetDatebaseByIdentifier(_loc4_.Market.ItemID) as TArticle;
            _loc4_.Name = _loc7_.Name;
            _loc3_.push(_loc4_);
            _loc5_++;
         }
      }
      
      public function MallRefreshRet(param1:int, param2:ByteArray) : void
      {
         var _loc3_:Vector.<TOrgShopCommodityItemVO> = null;
         var _loc4_:TOrgShopCommodityItemVO = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TArticle = null;
         var _loc8_:TBins = null;
         var _loc9_:TBins = null;
         var _loc10_:int = 0;
         _loc8_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Article);
         _loc9_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BlackMarket);
         _loc3_ = param1 == CONST_BLACKMARKET.MarketID_OrgNormalMarket ? this.FData.ShopVOs : this.FData.SpecialVOs;
         _loc3_.length = 0;
         this.FData.MallRefreshCounts = param2.readInt();
         param2.readInt();
         this.FData.GroupMoney = param2.readInt();
         _loc6_ = uint(param2.readShort());
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc10_ = param2.readInt();
            _loc4_ = new TOrgShopCommodityItemVO();
            _loc4_.Market = _loc9_.GetDatebaseByIdentifier(_loc10_) as TBlackMarket;
            _loc4_.BuyCount = 0;
            _loc7_ = _loc8_.GetDatebaseByIdentifier(_loc4_.Market.ItemID) as TArticle;
            _loc4_.Name = _loc7_.Name;
            _loc3_.push(_loc4_);
            _loc5_++;
         }
      }
      
      public function MallBuyGoodRet(param1:int, param2:ByteArray) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Vector.<TOrgShopCommodityItemVO> = null;
         var _loc5_:TOrgShopCommodityItemVO = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         _loc3_ = uint(param2.readInt());
         _loc4_ = param1 == CONST_BLACKMARKET.MarketID_OrgNormalMarket ? this.FData.ShopVOs : this.FData.SpecialVOs;
         _loc7_ = _loc4_.length;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc5_ = _loc4_[_loc6_];
            if(_loc5_.Market.Identifier == _loc3_)
            {
               ++_loc5_.BuyCount;
               this.FData.GroupMoney = Math.max(this.FData.GroupMoney - _loc5_.Market.Price.amount,0);
               return;
            }
            _loc6_++;
         }
         this.FData.GroupMoney = param2.readInt();
      }
      
      public function HeroExchangeRet(param1:THeroExchangeVO) : void
      {
         param1.IsExchange = true;
      }
      
      public function UpdateGroupMoney(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.readInt();
         this.FData.GroupMoney += _loc2_;
      }
      
      public function SingleInitReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_SingleInitReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function SingleEnterReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_SingleEnterReq);
         _loc1_.Data.writeInt(this.FData.CurrentCopy.City.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function SingleChallengeReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_OrgPointMap_SingleChallengeReq);
         _loc1_.Data.writeInt(this.FData.CurrentCopy.City.Identifier);
         _loc1_.Data.writeInt(this.FData.CurrentPoint.Index);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function PointRefreshReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_OrgPointMap_PointRefreshReq);
         _loc1_.Data.writeInt(this.FData.CurrentCopy.City.Identifier);
         _loc1_.Data.writeInt(this.FData.CurrentPoint.Index);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function AutoFightReq(param1:uint) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_OrgPointMap_AutoFightReq);
         _loc2_.Data.writeInt(this.FData.CurrentCopy.City.Identifier);
         _loc2_.Data.writeInt(this.FData.CurrentPoint.Index);
         _loc2_.Data.writeInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      public function GroupInitReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_GroupInitReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function GroupOpenReq(param1:uint) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:TOrgCopyVO = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_GroupOpenReq);
         _loc3_ = this.FData.GroupCopys[param1];
         _loc2_.Data.writeInt(_loc3_.City.Identifier);
         _loc2_.Data.writeInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      public function GroupEnterReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_GroupEnterReq);
         _loc1_.Data.writeInt(this.FData.CurrentCopy.City.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function CopyRefreshReq(param1:uint) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:TOrgCopyVO = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_CopyRefreshReq);
         _loc3_ = this.FData.GroupCopys[param1];
         _loc2_.Data.writeInt(_loc3_.City.Identifier);
         _loc2_.Data.writeInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      public function QuitMapReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_OrgPointMap_QuitMapReq);
         _loc1_.Data.writeInt(this.FData.CurrentCopy.City.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function AllocationReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_PointMapInfoUI_AllocationReq);
         _loc1_.Data.writeInt(this.FData.CurrentCopy.City.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function SpoilsReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_PointMapInfoUI_SpoilsReq);
         _loc1_.Data.writeInt(this.FData.CurrentCopy.City.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function AttValueReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_PointMapInfoUI_AttValueReq);
         _loc1_.Data.writeInt(this.FData.CurrentCopy.City.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function GroupChallengeReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_OrgPointMap_GroupChallengeReq);
         _loc1_.Data.writeInt(this.FData.CurrentCopy.City.Identifier);
         _loc1_.Data.writeInt(this.FData.CurrentPoint.Index);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function ApplyReq(param1:uint) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:TOrgSpoilsBarVO = null;
         _loc3_ = this.FData.CurrentCopy.SpoilsVOs[param1];
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_PointMapInfoUI_ApplyReq);
         _loc2_.Data.writeInt(this.FData.CurrentCopy.City.Identifier);
         _loc2_.Data.writeShort(_loc3_.Type);
         _loc2_.Data.writeInt(_loc3_.Code);
         _loc2_.Data.writeInt(_loc3_.Count);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      public function ApplyListReq(param1:uint) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:TOrgSpoilsBarVO = null;
         _loc3_ = this.FData.CurrentCopy.SpoilsVOs[param1];
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_PointMapInfoUI_ApplyListReq);
         _loc2_.Data.writeInt(this.FData.CurrentCopy.City.Identifier);
         _loc2_.Data.writeShort(_loc3_.Type);
         _loc2_.Data.writeInt(_loc3_.Code);
         _loc2_.Data.writeInt(_loc3_.Count);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      public function MallInitReq(param1:int) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TimeMall_InitDataReq);
         _loc2_.Data.writeInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      public function MallRefreshReq(param1:int) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TimeMall_RefreshReq);
         _loc2_.Data.writeInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      public function MallBuyReq(param1:int, param2:int) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TimeMall_BuyGoodReq);
         _loc3_.Data.writeInt(param1);
         _loc3_.Data.writeInt(param2);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
   }
}

