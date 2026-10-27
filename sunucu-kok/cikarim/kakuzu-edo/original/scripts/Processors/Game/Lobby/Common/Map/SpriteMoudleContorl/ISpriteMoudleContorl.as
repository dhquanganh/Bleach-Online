package Processors.Game.Lobby.Common.Map.SpriteMoudleContorl
{
   import Foundation.Common.TCoordinate;
   import Logics.Map.TMoudleInfor;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   
   public interface ISpriteMoudleContorl
   {
      
      function GetRoleMoudleInfor(param1:TSceneSpriteMoudle, param2:uint, param3:uint, param4:uint, param5:TMoudleInfor) : void;
      
      function GetDirectionByStartEndDirection(param1:TCoordinate, param2:TCoordinate) : int;
   }
}

