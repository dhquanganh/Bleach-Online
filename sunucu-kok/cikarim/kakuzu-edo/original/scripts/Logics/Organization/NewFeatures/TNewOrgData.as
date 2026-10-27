package Logics.Organization.NewFeatures
{
   import Foundation.Common.THint;
   import Foundation.Timing.STimingCore;
   import Logics.DatebaseVO.VO.TCity;
   import Logics.Organization.VO.TEnemyVO;
   import Logics.Organization.VO.THeroExchangeVO;
   import Logics.Organization.VO.TOrgApplyListBarVO;
   import Logics.Organization.VO.TOrgConfigValueVO;
   import Logics.Organization.VO.TOrgCopyVO;
   import Logics.Organization.VO.TOrgDamageRankBarVO;
   import Logics.Organization.VO.TOrgDistRecordBarVO;
   import Logics.Organization.VO.TOrgShopCommodityItemVO;
   import Logics.Organization.VO.TPointInfoVO;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_BATTLE;
   import flash.utils.*;
   
   public class TNewOrgData
   {
      
      public const CopyType_Single:uint = 0;
      
      public const CopyType_Group:uint = 1;
      
      protected var FSingleCopys:Vector.<TOrgCopyVO>;
      
      protected var FGroupCopys:Vector.<TOrgCopyVO>;
      
      protected var FDamageRankVOs:Vector.<TOrgDamageRankBarVO>;
      
      protected var FApplyListVOs:Vector.<TOrgApplyListBarVO>;
      
      protected var FDistRecordVOs:Vector.<TOrgDistRecordBarVO>;
      
      protected var FShopVOs:Vector.<TOrgShopCommodityItemVO>;
      
      protected var FSpecialVOs:Vector.<TOrgShopCommodityItemVO>;
      
      protected var FHeroExchangeVOs:Vector.<THeroExchangeVO>;
      
      protected var FCurrentCopy:TOrgCopyVO;
      
      protected var FCurrentPoint:TPointInfoVO;
      
      protected var FOrgConfigValue:TOrgConfigValueVO;
      
      protected var FNewOrgSystemLanguage:TNewOrgSystemLanguage;
      
      protected var FPointResetHint:THint;
      
      protected var FGroupMoney:uint;
      
      protected var FLinkGlobalIndex:uint;
      
      protected var FMallRefreshCounts:int;
      
      protected var FCurrentHaveApply:Boolean;
      
      protected var FApplyType:int;
      
      protected var FApplyCode:int;
      
      protected var FApplyRank:int;
      
      public function TNewOrgData()
      {
         super();
         this.FOrgConfigValue = new TOrgConfigValueVO();
         this.FSingleCopys = new Vector.<TOrgCopyVO>();
         this.FGroupCopys = new Vector.<TOrgCopyVO>();
         this.FDamageRankVOs = new Vector.<TOrgDamageRankBarVO>();
         this.FApplyListVOs = new Vector.<TOrgApplyListBarVO>();
         this.FDistRecordVOs = new Vector.<TOrgDistRecordBarVO>();
         this.FShopVOs = new Vector.<TOrgShopCommodityItemVO>();
         this.FSpecialVOs = new Vector.<TOrgShopCommodityItemVO>();
         this.FHeroExchangeVOs = new Vector.<THeroExchangeVO>();
      }
      
      public function get CurrentCopy() : TOrgCopyVO
      {
         return this.FCurrentCopy;
      }
      
      public function get CurrentPoint() : TPointInfoVO
      {
         return this.FCurrentPoint;
      }
      
      public function get OrgConfigValue() : TOrgConfigValueVO
      {
         return this.FOrgConfigValue;
      }
      
      public function get PointResetHint() : THint
      {
         return this.FPointResetHint;
      }
      
      public function set PointResetHint(param1:THint) : void
      {
         this.FPointResetHint = param1;
      }
      
      public function get NewOrgSystemLanguage() : TNewOrgSystemLanguage
      {
         return this.FNewOrgSystemLanguage;
      }
      
      public function set NewOrgSystemLanguage(param1:TNewOrgSystemLanguage) : void
      {
         this.FNewOrgSystemLanguage = param1;
      }
      
      public function get SingleCopys() : Vector.<TOrgCopyVO>
      {
         return this.FSingleCopys;
      }
      
      public function set SingleCopys(param1:Vector.<TOrgCopyVO>) : void
      {
         this.FSingleCopys = param1;
      }
      
      public function get GroupCopys() : Vector.<TOrgCopyVO>
      {
         return this.FGroupCopys;
      }
      
      public function set GroupCopys(param1:Vector.<TOrgCopyVO>) : void
      {
         this.FGroupCopys = param1;
      }
      
      public function get DamageRankVOs() : Vector.<TOrgDamageRankBarVO>
      {
         return this.FDamageRankVOs;
      }
      
      public function get ApplyListVOs() : Vector.<TOrgApplyListBarVO>
      {
         return this.FApplyListVOs;
      }
      
      public function get DistRecordVOs() : Vector.<TOrgDistRecordBarVO>
      {
         return this.FDistRecordVOs;
      }
      
      public function get ShopVOs() : Vector.<TOrgShopCommodityItemVO>
      {
         return this.FShopVOs;
      }
      
      public function get SpecialVOs() : Vector.<TOrgShopCommodityItemVO>
      {
         return this.FSpecialVOs;
      }
      
      public function get HeroExchangeVOs() : Vector.<THeroExchangeVO>
      {
         return this.FHeroExchangeVOs;
      }
      
      public function get GroupMoney() : uint
      {
         return this.FGroupMoney;
      }
      
      public function set GroupMoney(param1:uint) : void
      {
         this.FGroupMoney = param1;
      }
      
      public function get MallRefreshCounts() : int
      {
         return this.FMallRefreshCounts;
      }
      
      public function set MallRefreshCounts(param1:int) : void
      {
         this.FMallRefreshCounts = param1;
      }
      
      public function get LinkGlobalIndex() : uint
      {
         return this.FLinkGlobalIndex;
      }
      
      public function set LinkGlobalIndex(param1:uint) : void
      {
         this.FLinkGlobalIndex = param1;
      }
      
      public function get CurrentHaveApply() : Boolean
      {
         return this.FCurrentHaveApply;
      }
      
      public function set CurrentHaveApply(param1:Boolean) : void
      {
         this.FCurrentHaveApply = param1;
      }
      
      public function get ApplyType() : int
      {
         return this.FApplyType;
      }
      
      public function set ApplyType(param1:int) : void
      {
         this.FApplyType = param1;
      }
      
      public function get ApplyCode() : int
      {
         return this.FApplyCode;
      }
      
      public function set ApplyCode(param1:int) : void
      {
         this.FApplyCode = param1;
      }
      
      public function get ApplyRank() : int
      {
         return this.FApplyRank;
      }
      
      public function set ApplyRank(param1:int) : void
      {
         this.FApplyRank = param1;
      }
      
      public function SelectCopy(param1:uint, param2:uint) : void
      {
         if(param1 == this.CopyType_Single)
         {
            this.FCurrentCopy = this.FSingleCopys[param2];
         }
         else
         {
            this.FCurrentCopy = this.FGroupCopys[param2];
         }
      }
      
      public function SelectPoint(param1:uint) : void
      {
         var _loc2_:Vector.<TPointInfoVO> = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TPointInfoVO = null;
         _loc2_ = this.FCurrentCopy.PointInfoVOs;
         _loc3_ = _loc2_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            if(_loc5_.RoleTempleteID == param1)
            {
               this.FCurrentPoint = _loc5_;
            }
            _loc4_++;
         }
      }
      
      public function GetCurrentPointRemainFight() : uint
      {
         return Math.max(0,this.FCurrentPoint.PointInfo.RemainingNumber - this.FCurrentPoint.FightCount);
      }
      
      public function GetCopyRemainFight(param1:TOrgCopyVO) : uint
      {
         return Math.max(0,this.FOrgConfigValue.Legion_DailyTimes - param1.FightCount);
      }
      
      public function CurrentPointReaminReset() : uint
      {
         return Math.max(this.FOrgConfigValue.TotalResetCount - this.FCurrentPoint.ResetCount,0);
      }
      
      public function CurrentPointAllowReset() : Boolean
      {
         return this.CurrentPointReaminReset() > 0 && this.FOrgConfigValue.Personal_Reset_Price[this.FCurrentPoint.ResetCount] <= SLogicsCore.Character.CreditGold;
      }
      
      public function CurrentPointResetGold() : uint
      {
         return this.FOrgConfigValue.Personal_Reset_Price[Math.min(this.FCurrentPoint.ResetCount,this.FOrgConfigValue.TotalResetCount - 1)];
      }
      
      public function GetNextPointByCurrentPoint() : TPointInfoVO
      {
         var _loc1_:int = 0;
         _loc1_ = this.FCurrentCopy.PointInfoVOs.indexOf(this.FCurrentPoint);
         if(_loc1_ == this.FCurrentCopy.PointInfoVOs.length - 1)
         {
            return null;
         }
         return this.FCurrentCopy.PointInfoVOs[_loc1_ + 1];
      }
      
      public function GetNextCopyByCurrentCopy() : TOrgCopyVO
      {
         var _loc1_:int = 0;
         _loc1_ = this.FSingleCopys.indexOf(this.FCurrentCopy);
         if(_loc1_ == this.FSingleCopys.length - 1)
         {
            return null;
         }
         return this.FSingleCopys[_loc1_ + 1];
      }
      
      public function BattleReturn(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc4_:TPointInfoVO = null;
         var _loc5_:TOrgCopyVO = null;
         if(param3)
         {
            if(param1 == CONST_BATTLE.BattleType_OrgSingle)
            {
               if(!this.CurrentPoint.Pass)
               {
                  _loc4_ = this.GetNextPointByCurrentPoint();
                  this.CurrentPoint.Pass = true;
                  if(_loc4_ != null)
                  {
                     _loc4_.State = TPointInfoVO.STATE_ALLOWPLAY_SINGLE;
                  }
                  else
                  {
                     this.CurrentCopy.Pass = true;
                     _loc5_ = this.GetNextCopyByCurrentCopy();
                     if(_loc5_ != null)
                     {
                        _loc5_.Open = true;
                     }
                  }
               }
            }
         }
      }
      
      public function GetCurrentPointMaxCount() : uint
      {
         var _loc1_:uint = 0;
         _loc1_ = Math.floor(SLogicsCore.Character.CreditMilitaryOrders / this.CurrentPoint.PointInfo.ActionEexertion);
         return Math.min(_loc1_,this.GetCurrentPointRemainFight());
      }
      
      public function SingleAllowInto(param1:uint) : Boolean
      {
         var _loc2_:TOrgCopyVO = this.FSingleCopys[param1];
         return SLogicsCore.Character.GetMainLevel() >= _loc2_.City.OpenLevel && _loc2_.Open;
      }
      
      public function GroupAllowInto(param1:uint) : Boolean
      {
         return this.FSingleCopys[param1].Pass && this.FGroupCopys[param1].Open;
      }
      
      public function GetSingleCopyByID(param1:uint) : TOrgCopyVO
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TOrgCopyVO = null;
         _loc3_ = this.FSingleCopys.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FSingleCopys[_loc2_];
            if(_loc4_.City.Identifier == param1)
            {
               return _loc4_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function GetEnemyVOByPos(param1:TPointInfoVO, param2:uint) : TEnemyVO
      {
         var _loc3_:Vector.<TEnemyVO> = null;
         var _loc4_:TEnemyVO = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc3_ = param1.Enemys;
         _loc6_ = _loc3_.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = _loc3_[_loc5_];
            if(_loc4_.Pos == param2)
            {
               return _loc4_;
            }
            _loc5_++;
         }
         return null;
      }
      
      public function FormatTimeForGroupCopy(param1:TOrgCopyVO) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = param1.RewardRemainTime;
         param1.Day = _loc2_ / 86400;
         _loc2_ %= 86400;
         param1.Hours = _loc2_ / 3600;
         _loc2_ %= 3600;
         param1.Minute = _loc2_ / 60;
         param1.Second = _loc2_ % 60;
      }
      
      public function UpdateGroupCopyRestTime(param1:Number) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TOrgCopyVO = null;
         _loc3_ = this.GroupCopys.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.GroupCopys[_loc2_];
            if(_loc4_.Open)
            {
               _loc4_.RewardRemainTime -= param1;
               if(_loc4_.RewardRemainTime < 0)
               {
                  _loc4_.RewardRemainTime = 0;
               }
               this.FormatTimeForGroupCopy(_loc4_);
            }
            _loc2_++;
         }
      }
      
      public function GetRewardRemainTimeByOpenTime(param1:int) : uint
      {
         var _loc2_:int = this.FOrgConfigValue.Legion_Additional_AwardTime * 3600;
         var _loc3_:int = int(STimingCore.ServerTick);
         return Math.max(_loc2_ - (_loc3_ - param1),0);
      }
      
      public function GetCopyTypeByCityID(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TCity = null;
         var _loc5_:TOrgCopyVO = null;
         _loc3_ = this.FSingleCopys.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FSingleCopys[_loc2_];
            _loc4_ = _loc5_.City;
            if(_loc4_.Identifier == param1)
            {
               return this.CopyType_Single;
            }
            _loc2_++;
         }
         return this.CopyType_Group;
      }
      
      public function GetCopyIndexByCityID(param1:uint) : int
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TCity = null;
         var _loc5_:TOrgCopyVO = null;
         _loc3_ = this.FSingleCopys.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FSingleCopys[_loc2_];
            _loc4_ = _loc5_.City;
            if(_loc4_.Identifier == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         _loc3_ = this.FGroupCopys.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FGroupCopys[_loc2_];
            _loc4_ = _loc5_.City;
            if(_loc4_.Identifier == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
   }
}

