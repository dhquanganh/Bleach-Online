package Logics.Streamization.Rooms
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.TKnife;
   import Logics.DatebaseVO.VO.TKnifeExpand;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.DatebaseVO.VO.TSystemLanguage;
   import Logics.Rooms.*;
   import Logics.Rooms.Seat.Player.Hero.THero;
   import Logics.Rooms.Seat.Player.TPlayerRoomDigest;
   import Processors.Game.Lobby.Spaces.LobbySpace;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Resources.Constants.CONST_TEAMBATTLE;
   import flash.utils.*;
   import ghostcat.util.data.Json;
   
   use namespace LobbySpace;
   
   public class TUnstreamizerPlayerRoomDigest extends TUnstreamizer
   {
      
      protected static const POSITION_HERO_MAPPING:Vector.<uint> = CONST_TEAMBATTLE.POSITION_HERO_MAPPING;
      
      public function TUnstreamizerPlayerRoomDigest()
      {
         super();
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
         var _loc8_:TPlayerRoomDigest = null;
         var _loc9_:THero = null;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:Array = null;
         var _loc14_:TKnifeExpand = null;
         var _loc15_:TKnife = null;
         var _loc16_:TSystemLanguage = null;
         var _loc17_:TBins = null;
         var _loc18_:TBaseHero = null;
         var _loc19_:TBins = null;
         var _loc20_:TRoleModel = null;
         var _loc21_:String = null;
         _loc8_ = param2 as TPlayerRoomDigest;
         _loc8_.SeatIndex = param1.readUnsignedByte();
         _loc6_ = param1.readUnsignedInt();
         _loc7_ = param1.readUnsignedInt();
         _loc8_.Coerce(_loc6_,_loc7_);
         _loc8_.RoleTempleteID = param1.readUnsignedInt();
         _loc19_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RoleModel);
         _loc20_ = _loc19_.GetDatebaseByIdentifier(_loc8_.RoleTempleteID) as TRoleModel;
         _loc8_.RoleModelID = _loc20_.Model;
         _loc8_.RoleHeadID = _loc20_.RoleHead;
         _loc8_.Nickname = TUtilityString.FetchUTF(param1);
         _loc8_.Level = param1.readUnsignedShort();
         _loc8_.FightingPower = param1.readUnsignedInt();
         _loc8_.Ready = param1.readBoolean();
         _loc8_.FriendBuffStatus = param1.readBoolean();
         _loc8_.OrganizationBuffStatus = param1.readBoolean();
         _loc8_.KnifeExpandID = param1.readUnsignedInt();
         if(_loc8_.KnifeExpandID != 0)
         {
            _loc14_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,_loc8_.KnifeExpandID) as TKnifeExpand;
            _loc8_.KnifeID = _loc14_.RelationID;
            _loc15_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Knife,_loc14_.RelationID) as TKnife;
            _loc16_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_3) as TSystemLanguage;
            _loc13_ = Json.decode(_loc16_.Desc);
            _loc11_ = _loc15_.Name;
            _loc12_ = _loc13_[_loc14_.Level - 1];
            _loc8_.KnifeCaption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_44),_loc12_,_loc11_);
         }
         else
         {
            _loc8_.KnifeCaption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_43);
         }
         _loc17_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         _loc8_.Heros.Clear();
         _loc5_ = int(param1.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.readUnsignedInt();
            _loc9_ = new THero(_loc6_);
            _loc9_.Position = param1.readUnsignedByte();
            _loc18_ = _loc17_.GetDatebaseByIdentifier(_loc6_) as TBaseHero;
            if(_loc18_.IsMain)
            {
               _loc21_ = _loc8_.Nickname;
            }
            else
            {
               _loc21_ = _loc18_.Name;
            }
            _loc9_.Name = _loc21_;
            _loc20_ = _loc19_.GetDatebaseByIdentifier(_loc6_) as TRoleModel;
            _loc9_.HeadIconID = _loc20_.RoleHead;
            _loc10_ = POSITION_HERO_MAPPING.indexOf(_loc9_.Position);
            _loc8_.Heros.SetHeroByIndex(_loc10_,_loc9_);
            _loc4_++;
         }
      }
   }
}

