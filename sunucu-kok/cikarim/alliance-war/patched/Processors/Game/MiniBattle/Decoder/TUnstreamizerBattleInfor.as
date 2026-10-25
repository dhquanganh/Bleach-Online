package Processors.Game.MiniBattle.Decoder
{
   import Foundation.Resources.*;
   import Foundation.Streamization.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Battle.model.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Mail.*;
   import Logics.Streamization.Battle.*;
   import Logics.Streamization.Inventories.*;
   import Processors.Game.MiniBattle.BattleControl.*;
   import Processors.Game.MiniBattle.Mode.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TUnstreamizerBattleInfor extends TUnstreamizer
   {
      
      protected static const ScpritActionID:Vector.<int> = Vector.<int>([0,1,2,3,4,5,6]);
      
      protected static const ScpritActionParamLength:Vector.<int> = Vector.<int>([3,4,5,8,4,3,3]);
      
      protected var FUnstreamizerBattleRepot:TUnstreamizerBattleRepot;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FBattleInfo:TBattleInfo;
      
      protected var FResourcesQuery:Vector.<uint>;
      
      protected var FTempleteIDS:Vector.<uint>;
      
      protected var FAmount:Vector.<int>;
      
      public function TUnstreamizerBattleInfor()
      {
         super();
         this.FUnstreamizerBattleRepot = new TUnstreamizerBattleRepot();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FBattleInfo = new TBattleInfo();
         this.FResourcesQuery = new Vector.<uint>();
         this.FTempleteIDS = new Vector.<uint>();
         this.FAmount = new Vector.<int>();
      }
      
      protected function GetHpHurtByCampID(param1:TActiveInfo, param2:uint) : Number
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TTargetInfo = null;
         var _loc6_:Number = 0;
         _loc6_ = 0;
         _loc4_ = param1.TargetCount;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1.TargetInfos[_loc3_];
            if(_loc5_.TargetCamp == param2)
            {
               _loc6_ += _loc5_.ResultInfo.HurtHp;
            }
            _loc3_++;
         }
         return _loc6_;
      }
      
      protected function GetTotalHpHurtByCampID(param1:TTurnInfo, param2:int, param3:int) : Number
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActiveInfo = null;
         var _loc7_:Number = 0;
         _loc7_ = 0;
         _loc5_ = param1.ActiveCount;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.ActiveInfos[_loc4_];
            if(_loc6_.ActiveCamp == param2)
            {
               _loc7_ += this.GetHpHurtByCampID(_loc6_,param3);
            }
            _loc4_++;
         }
         return _loc7_;
      }
      
      protected function HaveTwoCampAttrackInOneTurn(param1:TTurnInfo) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc2_ = param1.ActiveInfos[0].ActiveCamp;
         _loc4_ = int(param1.ActiveInfos.length);
         _loc3_ = 1;
         while(_loc3_ < _loc4_)
         {
            if(param1.ActiveInfos[_loc3_].ActiveCamp != _loc2_)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      protected function GetOtherCampIDByMyCampID(param1:int) : int
      {
         return param1 + 1 & 1;
      }
      
      protected function FlushAttrack(param1:TBattleInfo, param2:Vector.<TOneAttrack>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TTurnInfo = null;
         var _loc6_:TActiveInfo = null;
         var _loc7_:TOneAttrack = null;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         _loc4_ = param1.TotleTurn;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1.TurnInfos[_loc3_];
            _loc7_ = SLogicsCore.PoolMiniBattle.AcquireOneAttrack();
            _loc7_.AtrrackRoleCamp = _loc5_.ActiveInfos[0].ActiveCamp;
            _loc9_ = this.GetOtherCampIDByMyCampID(_loc7_.AtrrackRoleCamp);
            _loc7_.MyBloodChangeValue = this.GetTotalHpHurtByCampID(_loc5_,_loc7_.AtrrackRoleCamp,_loc7_.AtrrackRoleCamp);
            _loc7_.EnemyBloodChangeValue = this.GetTotalHpHurtByCampID(_loc5_,_loc7_.AtrrackRoleCamp,_loc9_);
            _loc7_.CurrentTurn = _loc3_ + 1;
            _loc7_.TotalTurn = param1.TotleTurn;
            param2.push(_loc7_);
            _loc8_ = this.HaveTwoCampAttrackInOneTurn(_loc5_);
            _loc7_.HaveNext = _loc8_;
            if(_loc8_)
            {
               _loc7_ = SLogicsCore.PoolMiniBattle.AcquireOneAttrack();
               _loc9_ = _loc5_.ActiveInfos[0].ActiveCamp;
               _loc7_.AtrrackRoleCamp = this.GetOtherCampIDByMyCampID(_loc9_);
               _loc7_.MyBloodChangeValue = this.GetTotalHpHurtByCampID(_loc5_,_loc7_.AtrrackRoleCamp,_loc7_.AtrrackRoleCamp);
               _loc7_.EnemyBloodChangeValue = this.GetTotalHpHurtByCampID(_loc5_,_loc7_.AtrrackRoleCamp,_loc9_);
               _loc7_.CurrentTurn = _loc3_ + 1;
               _loc7_.TotalTurn = param1.TotleTurn;
               _loc7_.HaveNext = _loc7_.CurrentTurn != param1.TotleTurn;
               param2.push(_loc7_);
            }
            _loc3_++;
         }
      }
      
      protected function GetTotalHpByCampID(param1:TBattleInfo, param2:int) : Number
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TGroupRoleInfo = null;
         var _loc6_:Number = 0;
         _loc5_ = param1.PlayerInfo_1.Camp == param2 ? param1.PlayerInfo_1 : param1.PlayerInfo_2;
         _loc6_ = 0;
         _loc4_ = _loc5_.RoleCount;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ += _loc5_.RoleBattleInfos[_loc3_].TotleHealth;
            _loc3_++;
         }
         return _loc6_;
      }
      
      protected function GetCurrentHpByCampID(param1:TBattleInfo, param2:int) : Number
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TGroupRoleInfo = null;
         var _loc6_:Number = 0;
         _loc5_ = param1.PlayerInfo_1.Camp == param2 ? param1.PlayerInfo_1 : param1.PlayerInfo_2;
         _loc6_ = 0;
         _loc4_ = _loc5_.RoleCount;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ += _loc5_.RoleBattleInfos[_loc3_].CurHealth;
            _loc3_++;
         }
         return _loc6_;
      }
      
      protected function AllBattleSoliderResourceRequest(param1:uint, param2:TResroucesControl) : void
      {
         param2.ResourceRequest(CONST_ROLE.GetModelIDByIndex(param1,CONST_ROLE.ROLE_SEQUENCEINDEX_FIGHTING_Standby),CONST_COMMON.ResourceType_Model);
         param2.ResourceRequest(CONST_ROLE.GetModelIDByIndex(param1,CONST_ROLE.ROLE_SEQUENCEINDEX_FIGHTING_Blow),CONST_COMMON.ResourceType_Model);
      }
      
      protected function LoadSkillResourceByID(param1:uint, param2:uint, param3:TResroucesControl) : void
      {
         var _loc4_:Vector.<int> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:TLeagueAction = null;
         var _loc11_:uint = 0;
         _loc8_ = 0;
         _loc10_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_LeagueAction,param1) as TLeagueAction;
         if(_loc10_==null)_loc10_=SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_LeagueAction,11100005) as TLeagueAction;
         _loc4_ = _loc10_.ScriptAction;
         _loc7_ = int(_loc4_.length);
         while(_loc6_ < _loc7_)
         {
            _loc8_ = _loc4_[_loc6_];
            switch(_loc8_)
            {
               case 3:
                  param3.ResourceRequest(_loc4_[_loc6_ + 3],CONST_COMMON.TextureTypeArr[_loc4_[_loc6_ + 2]]);
               case 6:
                  if(_loc4_[_loc6_ + 2] == CONST_MINIBATTLE.SoldierAnimatSequnce_NormalAttrack)
                  {
                     param3.ResourceRequest(CONST_ROLE.GetModelIDByIndex(param2,CONST_ROLE.ROLE_SEQUENCEINDEX_FIGHTING_NormalAttract),CONST_COMMON.ResourceType_Model);
                  }
                  else if(_loc4_[_loc6_ + 2] == CONST_MINIBATTLE.SoldierAnimatSequnce_SkillAttrack)
                  {
                     param3.ResourceRequest(CONST_ROLE.GetModelIDByIndex(param2,CONST_ROLE.ROLE_SEQUENCEINDEX_FIGHTING_SkillAttract),CONST_COMMON.ResourceType_Model);
                  }
            }
            _loc9_ = ScpritActionID.indexOf(_loc8_);
            _loc6_ += ScpritActionParamLength[_loc9_];
         }
      }
      
      protected function GetEnemyLeaderInfor(param1:TMiniBattleInfor, param2:TBattleInfo, param3:TOneBattle, param4:uint) : TRoleBattleInfo
      {
         var _loc5_:TGroupRoleInfo = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TEnemyArmy = null;
         if(param4 == CONST_MINIBATTLE.CampType_Friend)
         {
            return param2.PlayerInfo_1.RoleBattleInfos[0];
         }
         if(param1.BattleType == CONST_MINIBATTLE.MiniBattleType_PVP)
         {
            return param2.PlayerInfo_2.RoleBattleInfos[0];
         }
         _loc5_ = param2.PlayerInfo_2;
         _loc7_ = _loc5_.RoleCount;
         _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_EnemyArmy,param3.EnemyID) as TEnemyArmy;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            if(_loc5_.RoleBattleInfos[_loc6_].RoleId == _loc8_.LeaderID)
            {
               return _loc5_.RoleBattleInfos[_loc6_];
            }
            _loc6_++;
         }
         return _loc5_.RoleCount>0?_loc5_.RoleBattleInfos[0]:null;
      }
      
      protected function GetLeaderMoudleIDByTempleteID(param1:int) : uint
      {
         var _loc2_:TRoleModel = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,param1) as TRoleModel;
         return _loc2_.Model;
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
      }
      
      protected function UnstreamizationBattleStream(param1:ByteArray, param2:TMiniBattleInfor, param3:TOneBattle, param4:TResroucesControl) : void
      {
         var _loc5_:TRoleBattleInfo = null;
         this.FBattleInfo = new TBattleInfo();
         this.FUnstreamizerBattleRepot.Unstreamize(param1,this.FBattleInfo,null);
         param3.SoldierFriend.CurrentHP = this.GetCurrentHpByCampID(this.FBattleInfo,CONST_MINIBATTLE.CampType_Friend);
         param3.SoldierFriend.TotalHP = this.GetTotalHpByCampID(this.FBattleInfo,CONST_MINIBATTLE.CampType_Friend);
         param3.SoldierEnemy.CurrentHP = this.GetCurrentHpByCampID(this.FBattleInfo,CONST_MINIBATTLE.CampType_Enemy);
         param3.SoldierEnemy.TotalHP = this.GetTotalHpByCampID(this.FBattleInfo,CONST_MINIBATTLE.CampType_Enemy);
         param3.TotalTurn = this.FBattleInfo.TotleTurn;
         this.FlushAttrack(this.FBattleInfo,param3.AttackRecord);
         _loc5_ = this.GetEnemyLeaderInfor(param2,this.FBattleInfo,param3,CONST_MINIBATTLE.CampType_Friend);
         param3.SoldierFriend.TemplateID = _loc5_.RoleId;
         param3.SoldierFriend.MoudleID = this.GetLeaderMoudleIDByTempleteID(_loc5_.RoleId);
         param3.SoldierFriend.Name = _loc5_.RoleName;
         param3.SoldierFriend.Quality = _loc5_.Quality;
         this.AllBattleSoliderResourceRequest(param3.SoldierFriend.MoudleID,param4);
         this.LoadSkillResourceByID(param3.SoldierFriend.TemplateID,param3.SoldierFriend.MoudleID,param4);
         _loc5_ = this.GetEnemyLeaderInfor(param2,this.FBattleInfo,param3,CONST_MINIBATTLE.CampType_Enemy);
         param3.SoldierEnemy.TemplateID = _loc5_.RoleId;
         param3.SoldierEnemy.MoudleID = this.GetLeaderMoudleIDByTempleteID(_loc5_.RoleId);
         param3.SoldierEnemy.Name = _loc5_.RoleName;
         param3.SoldierEnemy.Quality = _loc5_.Quality;
         this.AllBattleSoliderResourceRequest(param3.SoldierEnemy.MoudleID,param4);
         this.LoadSkillResourceByID(param3.SoldierEnemy.TemplateID,param3.SoldierEnemy.MoudleID,param4);
      }
      
      protected function UnstreamizationRewards(param1:ByteArray, param2:TInventories, param3:TSoliderReward) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:int = 0;
         this.FTempleteIDS.length = 0;
         this.FAmount.length = 0;
         _loc5_ = int(param1.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.readUnsignedShort();
            _loc7_ = param1.readUnsignedInt();
            _loc8_ = param1.readUnsignedInt();
            _loc9_ = CONST_COMMON.RewardIDToTemplateID(_loc6_,_loc7_);
            if(_loc9_ == 0)
            {
               param3.RewardHonor = _loc8_;
            }
            else
            {
               this.FTempleteIDS.push(_loc9_);
               this.FAmount.push(_loc8_);
            }
            _loc4_++;
         }
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,param2,this.FTempleteIDS);
         _loc5_ = param2.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            param2.GetInventoryByIndex(_loc4_).Quantity = this.FAmount[_loc4_];
            _loc4_++;
         }
      }
      
      public function UnstreamizationBattleInfor(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TMiniBattleInfor = null;
         var _loc8_:TLeagueMapPve = null;
         var _loc9_:TLeagueMapPvp = null;
         _loc7_ = param2 as TMiniBattleInfor;
         _loc4_ = param1.readUnsignedByte();
         _loc5_ = param1.readUnsignedInt();
         if(_loc4_ == CONST_MINIBATTLE.MiniBattleType_PVE)
         {
            _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_LeagueMapPve,_loc5_) as TLeagueMapPve;
            _loc6_ = _loc8_.MapID;
            _loc7_.AddInfor = _loc8_.AddInfor;
         }
         else if(_loc4_ == CONST_MINIBATTLE.MiniBattleType_PVP)
         {
            _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_LeagueMapPvp,_loc5_) as TLeagueMapPvp;
            _loc6_ = _loc9_.MapID;
         }
         _loc7_.BattleType = _loc4_;
         _loc7_.BattleID = _loc5_;
         _loc7_.MapID = _loc6_;
      }
      
      public function UnstreamizationBattleReportInfor(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TMiniBattleInfor = null;
         var _loc5_:TOneScreenBattle = null;
         var _loc6_:TOneBattle = null;
         var _loc7_:TBattleSoldierInfor = null;
         var _loc8_:TResroucesControl = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         _loc4_ = param2 as TMiniBattleInfor;
         _loc5_ = SLogicsCore.PoolMiniBattle.AcquireOneScreenBattle();
         _loc8_ = param3 as TResroucesControl;
         _loc10_ = int(param1.readUnsignedShort());
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            _loc6_ = SLogicsCore.PoolMiniBattle.AcquireOneBattle();
            _loc6_.BattleResult = param1.readUnsignedByte();
            _loc6_.EnemyID = param1.readUnsignedInt();
            _loc6_.SoldierFriend.LastHp = param1.readDouble();
            _loc6_.SoldierFriend.CampID = CONST_MINIBATTLE.CampType_Friend;
            _loc6_.SoldierFriend.Direction = CONST_MAP.DIRECTION_RIGHT;
            _loc6_.SoldierFriend.SoldierType = CONST_MINIBATTLE.SoldierType_Hero;
            _loc6_.SoldierEnemy.LastHp = param1.readDouble();
            _loc6_.SoldierEnemy.CampID = CONST_MINIBATTLE.CampType_Enemy;
            _loc6_.SoldierEnemy.Direction = CONST_MAP.DIRECTION_LEFT;
            _loc6_.SoldierEnemy.SoldierType = _loc4_.BattleType == CONST_MINIBATTLE.MiniBattleType_PVE ? CONST_MINIBATTLE.SoldierType_Monster : CONST_MINIBATTLE.SoldierType_Hero;
            _loc6_.BattleReportAddr = TUtilityString.FetchUTF(param1);
            this.UnstreamizationBattleStream(param1,_loc4_,_loc6_,_loc8_);
            _loc5_.Battles.push(_loc6_);
            _loc9_++;
         }
         _loc4_.OneScreenBattles.push(_loc5_);
      }
      
      public function UnstreamizationBattleReward(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TMiniBattleInfor = null;
         var _loc5_:TSoliderReward = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc4_ = param2 as TMiniBattleInfor;
         _loc4_.BattleResult = param1.readUnsignedByte();
         if(_loc4_.BattleResult == CONST_MINIBATTLE.BattleResult_Lose && _loc4_.BattleType == CONST_MINIBATTLE.MiniBattleType_PVE)
         {
            return;
         }
         _loc7_ = int(param1.readUnsignedShort());
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc5_ = SLogicsCore.PoolMiniBattle.AcquireSoliderReward();
            _loc5_.SoliderName = TUtilityString.FetchUTF(param1);
            _loc5_.SoliderTempleteID = param1.readUnsignedInt();
            _loc5_.KillNum = param1.readUnsignedInt();
            _loc5_.FriendAdded = param1.readUnsignedByte() == 1;
            _loc5_.GuideAdded = param1.readUnsignedByte() == 1;
            this.UnstreamizationRewards(param1,_loc5_.AddedReward,_loc5_);
            this.UnstreamizationRewards(param1,_loc5_.Rewards,_loc5_);
            _loc4_.SoliderRewards.push(_loc5_);
            _loc6_++;
         }
      }
   }
}

