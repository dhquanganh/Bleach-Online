package Logics.Streamization.Rooms
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TLeagueMapPve;
   import Logics.DatebaseVO.VO.TLeagueMapPvp;
   import Logics.Rooms.TRoomDigest;
   import Processors.Game.Lobby.Spaces.LobbySpace;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_TEAMBATTLE;
   import flash.utils.ByteArray;
   
   use namespace LobbySpace;
   
   public class TUnstreamizerRoomDigest extends TUnstreamizer
   {
      
      public function TUnstreamizerRoomDigest()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Properties(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_Properties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:TRoomDigest = null;
         var _loc6_:TLeagueMapPve = null;
         var _loc7_:TLeagueMapPvp = null;
         var _loc8_:uint = 0;
         _loc5_ = param2 as TRoomDigest;
         _loc8_ = param3 as uint;
         _loc5_.OperatingType = param1.readUnsignedByte();
         _loc4_ = param1.readUnsignedInt();
         _loc5_.Coerce(_loc4_);
         _loc5_.ModelID = param1.readUnsignedInt();
         _loc5_.Name = TUtilityString.FetchUTF(param1);
         _loc5_.PlayerCount = param1.readUnsignedInt();
         _loc5_.Passworded = param1.readBoolean();
         _loc5_.IsFighting = param1.readBoolean();
         if(_loc8_ == CONST_TEAMBATTLE.MODE_TEAMBATTLE_PVP)
         {
            _loc5_.ModeType = CONST_TEAMBATTLE.MODE_TEAMBATTLE_PVP;
            _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_LeagueMapPvp,_loc5_.ModelID) as TLeagueMapPvp;
            if(_loc7_ != null)
            {
               _loc5_.ModelName = _loc7_.Name;
               _loc5_.SuitableLevel = "";
               _loc5_.ResourceID = _loc7_.ImageID;
            }
         }
         else if(_loc8_ == CONST_TEAMBATTLE.MODE_TEAMBATTLE_PVE)
         {
            _loc5_.ModeType = CONST_TEAMBATTLE.MODE_TEAMBATTLE_PVE;
            _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_LeagueMapPve,_loc5_.ModelID) as TLeagueMapPve;
            if(_loc6_ != null)
            {
               _loc5_.ModelName = _loc6_.Name;
               _loc5_.SuitableLevel = _loc6_.SuitableLevel;
               _loc5_.ResourceID = _loc6_.ImageID;
            }
         }
         _loc5_.PlayerCapacity = CONST_TEAMBATTLE.CAPACITY_PLAYERS;
      }
   }
}

