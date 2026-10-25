package Logics.Streamization.Rooms
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.TEnemy;
   import Logics.DatebaseVO.VO.TEnemyArmy;
   import Logics.DatebaseVO.VO.TLeaguePointPath;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.Rooms.*;
   import Logics.Rooms.Seat.Player.Hero.TCollectionHero;
   import Logics.Rooms.Seat.Player.Hero.THero;
   import Logics.Rooms.Seat.Player.TPlayerRoomDigest;
   import Logics.Rooms.Seat.TRoomSeatInfo;
   import Processors.Game.Lobby.Spaces.LobbySpace;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_TEAMBATTLE;
   import flash.utils.*;
   
   use namespace LobbySpace;
   
   public class TUnstreamizerPlayerRoomInfo extends TUnstreamizer
   {
      
      protected static const POSITION_HERO_MAPPING:Vector.<uint> = CONST_TEAMBATTLE.POSITION_HERO_MAPPING;
      
      protected var FUnstreamizerPlayerRoomDigest:TUnstreamizerPlayerRoomDigest;
      
      public function TUnstreamizerPlayerRoomInfo()
      {
         super();
         this.FUnstreamizerPlayerRoomDigest = new TUnstreamizerPlayerRoomDigest();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Properties(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_Properties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:TRoomSeatInfo = null;
         var _loc9_:TPlayerRoomDigest = null;
         _loc8_ = param2 as TRoomSeatInfo;
         _loc6_ = param1.readUnsignedInt();
         _loc8_.Coerce(_loc6_);
         _loc8_.Password = TUtilityString.FetchUTF(param1);
         _loc8_.ModelID = param1.readUnsignedInt();
         _loc8_.RoomOwnerIndex = param1.readUnsignedByte();
         _loc8_.OneselfIndex = param1.readUnsignedByte();
         _loc5_ = int(param1.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_ = _loc8_.PlayerRoomDigests[_loc4_];
            this.FUnstreamizerPlayerRoomDigest.Unstreamize(param1,_loc9_,null);
            _loc4_++;
         }
      }
      
      protected function UnstreamizationPerform_TeamBattlePVEMonsterInfo(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:TRoomSeatInfo = null;
         var _loc10_:TPlayerRoomDigest = null;
         var _loc11_:Vector.<TPlayerRoomDigest> = null;
         var _loc12_:TLeaguePointPath = null;
         var _loc13_:TEnemyArmy = null;
         var _loc14_:TBins = null;
         var _loc15_:TEnemy = null;
         var _loc16_:TBins = null;
         var _loc17_:TRoleModel = null;
         var _loc18_:Vector.<uint> = null;
         var _loc19_:Vector.<uint> = null;
         var _loc20_:Vector.<uint> = null;
         var _loc21_:TCollectionHero = null;
         var _loc22_:THero = null;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         _loc9_ = param2 as TRoomSeatInfo;
         _loc11_ = _loc9_.MonsterDigests;
         _loc12_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_LeaguePointPath,_loc9_.ModelID) as TLeaguePointPath;
         _loc16_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RoleModel);
         _loc14_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Enemy);
         _loc5_ = int(_loc11_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc11_[_loc4_].Reset();
            _loc4_++;
         }
         _loc18_ = _loc12_.ArmyID;
         _loc5_ = int(_loc18_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_ = _loc18_[_loc4_];
            _loc10_ = _loc11_[_loc4_];
            _loc10_.Coerce(_loc8_,0);
            _loc10_.IsMonster = true;
            _loc13_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_EnemyArmy,_loc8_) as TEnemyArmy;
            _loc15_ = _loc14_.GetDatebaseByIdentifier(_loc13_.LeaderID) as TEnemy;
            _loc17_ = _loc16_.GetDatebaseByIdentifier(_loc13_.LeaderID) as TRoleModel;
            _loc10_.Nickname = _loc15_.Name;
            _loc10_.Level = _loc15_.Level;
            _loc10_.RoleTempleteID = _loc13_.LeaderID;
            _loc10_.RoleModelID = _loc17_.Model;
            _loc10_.RoleHeadID = _loc17_.RoleHead;
            _loc19_ = _loc13_.EnemyIdVect;
            _loc20_ = _loc13_.EnemyPosVect;
            _loc21_ = _loc10_.Heros;
            _loc7_ = int(_loc20_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc23_ = int(_loc20_[_loc6_]);
               if(_loc23_ > 0)
               {
                  _loc8_ = _loc19_[_loc6_];
                  _loc22_ = new THero(_loc8_);
                  _loc15_ = _loc14_.GetDatebaseByIdentifier(_loc8_) as TEnemy;
                  _loc17_ = _loc16_.GetDatebaseByIdentifier(_loc8_) as TRoleModel;
                  _loc22_.Name = _loc15_.Name;
                  _loc22_.Position = _loc23_;
                  _loc22_.HeadIconID = _loc17_.RoleHead;
                  _loc24_ = POSITION_HERO_MAPPING.indexOf(_loc23_);
                  _loc21_.SetHeroByIndex(_loc24_,_loc22_);
               }
               _loc6_++;
            }
            _loc4_++;
         }
      }
      
      public function UnstreamizeTeamBattlePVEMonsterInfo(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_TeamBattlePVEMonsterInfo(param1,param2,param3);
      }
   }
}

