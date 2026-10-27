package Processors.Game.Lobby.Common.Map.SpriteMoudleContorl
{
   import Foundation.Common.TCoordinate;
   import Logics.Map.TMoudleInfor;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapEnvironment;
   
   public class TSpriteMoudleContorlEnvironment implements ISpriteMoudleContorl
   {
      
      public function TSpriteMoudleContorlEnvironment()
      {
         super();
      }
      
      public function GetRoleMoudleInfor(param1:TSceneSpriteMoudle, param2:uint, param3:uint, param4:uint, param5:TMoudleInfor) : void
      {
         var _loc6_:TSceneSpriteMoudleInMapEnvironment = null;
         _loc6_ = param1 as TSceneSpriteMoudleInMapEnvironment;
         param5.Scalx = 1;
         param5.TextureID = _loc6_.RoleTempleteID;
      }
      
      public function GetDirectionByStartEndDirection(param1:TCoordinate, param2:TCoordinate) : int
      {
         return 0;
      }
   }
}

