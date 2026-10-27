package Logics.Streamization.Organization
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TOrganizationBase;
   import Logics.Organization.Elements.TBaseRankList;
   import Logics.Organization.TBaseOrganization;
   import Logics.Organization.TBaseOrganizationMember;
   import Logics.Organization.TBaseOrganiztionList;
   import Logics.Organization.TMuyeGuardRank;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerOrganization extends TUnstreamizer
   {
      
      public function TUnstreamizerOrganization()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TBaseOrganization = null;
         var _loc7_:Vector.<Object> = null;
         var _loc8_:TBins = null;
         var _loc9_:TOrganizationBase = null;
         var _loc10_:Object = null;
         _loc6_ = param2 as TBaseOrganization;
         _loc8_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrganizationBase);
         _loc6_.OrgId = param1.readUnsignedInt();
         if(_loc6_.OrgId > 0)
         {
            _loc6_.OrgName = TUtilityString.FetchUTF(param1);
            _loc6_.OrgFamily = param1.readShort();
            _loc6_.OrgMoney = param1.readUnsignedInt();
            _loc6_.MasterName = TUtilityString.FetchUTF(param1);
            _loc6_.OrgLevel = param1.readUnsignedInt();
            _loc6_.OrgContribution = param1.readUnsignedInt();
            _loc6_.OrgMembers = param1.readUnsignedInt();
            _loc6_.OrgExploit = param1.readUnsignedInt();
            _loc6_.OrgNotice = TUtilityString.FetchUTF(param1);
            _loc6_.OrgPower = param1.readByte();
            _loc6_.MyActive = param1.readInt();
            _loc6_.GroupActive = param1.readInt();
            _loc5_ = param1.readShort();
            _loc7_ = new Vector.<Object>(_loc5_);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc10_ = {
                  "type":0,
                  "level":0
               };
               _loc7_[_loc4_] = _loc10_;
               _loc7_[_loc4_].type = param1.readUnsignedInt();
               _loc7_[_loc4_].level = param1.readUnsignedInt();
               _loc4_++;
            }
            _loc6_.OrgAddition = _loc7_;
            _loc9_ = _loc8_.GetDatebaseByIndex(_loc6_.OrgLevel - 1) as TOrganizationBase;
            _loc6_.MoneyAddition = _loc9_.GetMoreSiv;
            _loc6_.ExpAddition = _loc9_.GetMoreExp;
            _loc6_.OrgMaxMemberCount = _loc9_.OrgMaxNumber;
            _loc6_.MyActiveMax = _loc9_.DayMaxActivity;
            _loc6_.GroupActiveMax = _loc9_.GuildMaxActivity;
         }
         else
         {
            _loc6_.OrgName = "";
            _loc6_.OrgFamily = 0;
            _loc6_.OrgMoney = 0;
            _loc6_.MasterName = "";
            _loc6_.OrgLevel = 0;
            _loc6_.OrgContribution = 0;
            _loc6_.MyActive = 0;
            _loc6_.GroupActive = 0;
            _loc6_.OrgMembers = 0;
            _loc6_.OrgExploit = 0;
            _loc6_.OrgNotice = "";
            _loc6_.OrgPower = 0;
         }
      }
      
      protected function Unstreamization_OrgMembersList(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TBaseOrganizationMember = null;
         var _loc5_:Vector.<TBaseOrganizationMember> = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         _loc5_ = param2 as Vector.<TBaseOrganizationMember>;
         _loc7_ = param1.readShort();
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = param1.readUnsignedInt();
            _loc9_ = param1.readUnsignedInt();
            _loc4_ = new TBaseOrganizationMember(_loc8_,_loc9_);
            _loc4_.PlayerName = TUtilityString.FetchUTF(param1);
            _loc4_.Rank = param1.readUnsignedInt();
            _loc4_.PlayerLevel = param1.readUnsignedInt();
            _loc4_.OrgDuties = param1.readUnsignedInt();
            _loc4_.TodayContribution = param1.readUnsignedInt();
            _loc4_.TotalContribution = param1.readUnsignedInt();
            _loc4_.LastLogginTime = param1.readUnsignedInt();
            _loc4_.PlayerOrgPower = param1.readUnsignedInt();
            _loc4_.DayActive = param1.readUnsignedInt();
            _loc5_[_loc6_] = _loc4_;
            if(SLogicsCore.Organization.OrgMemberList != null)
            {
               SLogicsCore.Organization.OrgMemberList.Add(_loc4_);
            }
            _loc6_++;
         }
      }
      
      protected function Unstreamization_OrgApplyAndSwitchList(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TBaseOrganizationMember = null;
         var _loc5_:Vector.<TBaseOrganizationMember> = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         _loc5_ = param2 as Vector.<TBaseOrganizationMember>;
         _loc7_ = param1.readShort();
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = param1.readUnsignedInt();
            _loc9_ = param1.readUnsignedInt();
            _loc4_ = new TBaseOrganizationMember(_loc8_,_loc9_);
            _loc4_.PlayerName = TUtilityString.FetchUTF(param1);
            _loc4_.PlayerLevel = param1.readShort();
            _loc4_.Rank = param1.readUnsignedInt();
            _loc4_.PlayerOrgPower = param1.readUnsignedInt();
            _loc5_[_loc6_] = _loc4_;
            _loc6_++;
         }
      }
      
      protected function Unstreamization_OrgList(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TBaseOrganiztionList = null;
         var _loc7_:Vector.<TBaseOrganiztionList> = null;
         var _loc8_:TBins = null;
         var _loc9_:TOrganizationBase = null;
         _loc7_ = param2 as Vector.<TBaseOrganiztionList>;
         _loc8_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrganizationBase);
         _loc5_ = param1.readShort();
         if(_loc5_ > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = new TBaseOrganiztionList();
               _loc6_.OrgID = param1.readUnsignedInt();
               _loc6_.OrgName = TUtilityString.FetchUTF(param1);
               _loc6_.OrgLevel = param1.readShort();
               _loc6_.OrgMembersCount = param1.readShort();
               _loc6_.OrgMasterName = TUtilityString.FetchUTF(param1);
               _loc6_.OrgFamily = param1.readByte();
               _loc6_.OrgIsApply = false;
               _loc9_ = _loc8_.GetDatebaseByIndex(_loc6_.OrgLevel - 1) as TOrganizationBase;
               _loc6_.OrgMaxMemberCount = _loc9_.OrgMaxNumber;
               _loc7_[_loc4_] = _loc6_;
               _loc4_++;
            }
         }
      }
      
      protected function Unstreamize_MuyeGuardRank(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TBaseRankList = null;
         var _loc8_:TMuyeGuardRank = null;
         _loc8_ = param2 as TMuyeGuardRank;
         _loc6_ = param1.readUnsignedInt();
         if(_loc6_ != 0)
         {
            _loc8_.WinStatus = false;
            _loc8_.CurTurnOrgName = "";
            _loc8_.CurTurnOrgFamily = 0;
            _loc8_.BeferTurnOrgName = "";
            _loc8_.BeferTurnOrgFamily = 0;
            _loc8_.DefendDay = 0;
            _loc8_.OrgRankList.length = 0;
            return;
         }
         _loc8_.WinStatus = Boolean(param1.readUnsignedByte());
         _loc8_.CurTurnOrgName = TUtilityString.FetchUTF(param1);
         _loc8_.CurTurnOrgFamily = param1.readUnsignedByte();
         _loc8_.BeferTurnOrgName = TUtilityString.FetchUTF(param1);
         _loc8_.BeferTurnOrgFamily = param1.readUnsignedByte();
         _loc8_.DefendDay = param1.readUnsignedShort();
         _loc8_.DefendUserName = TUtilityString.FetchUTF(param1);
         _loc8_.DefendHeroId = param1.readUnsignedInt();
         _loc8_.DefendFightValue = param1.readUnsignedInt();
         _loc8_.OrgRankList.length = 0;
         _loc5_ = param1.readUnsignedShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = new TBaseRankList();
            _loc7_.RankName = TUtilityString.FetchUTF(param1);
            _loc7_.RankFamily = param1.readUnsignedByte();
            _loc7_.RankScore = param1.readUnsignedInt();
            _loc8_.OrgRankList.push(_loc7_);
            _loc4_++;
         }
      }
      
      protected function Unstreamize_MuyeBattleRank(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Vector.<TBaseOrganiztionList> = null;
         var _loc7_:TBaseOrganiztionList = null;
         var _loc8_:Vector.<TBaseOrganizationMember> = null;
         var _loc9_:TBaseOrganizationMember = null;
         _loc6_ = param2 as Vector.<TBaseOrganiztionList>;
         _loc8_ = param3 as Vector.<TBaseOrganizationMember>;
         _loc5_ = param1.readUnsignedShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = new TBaseOrganiztionList();
            _loc7_.OrgFamily = param1.readUnsignedByte();
            TUtilityString.FetchUTF(param1);
            _loc7_.OrgName = TUtilityString.FetchUTF(param1);
            _loc7_.Score = param1.readUnsignedInt();
            _loc6_.push(_loc7_);
            _loc4_++;
         }
         _loc5_ = param1.readUnsignedShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_ = new TBaseOrganizationMember(0,0);
            _loc9_.PlayerFamily = param1.readUnsignedByte();
            _loc9_.PlayerName = TUtilityString.FetchUTF(param1);
            _loc9_.OrgName = TUtilityString.FetchUTF(param1);
            _loc9_.Score = param1.readUnsignedInt();
            _loc8_.push(_loc9_);
            _loc4_++;
         }
      }
      
      public function UnstreamizeOrganizationMembers(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.Unstreamization_OrgMembersList(param1,param2,param3);
      }
      
      public function UnstreamizeOrganizationApplyAndSwitchList(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.Unstreamization_OrgApplyAndSwitchList(param1,param2,param3);
      }
      
      public function UnstreamizeOrganizationList(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.Unstreamization_OrgList(param1,param2,param3);
      }
      
      public function UnstreamizeMuyeGuardRank(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.Unstreamize_MuyeGuardRank(param1,param2,param3);
      }
      
      public function UnstreamizeMuyeBattleRank(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.Unstreamize_MuyeBattleRank(param1,param2,param3);
      }
   }
}

