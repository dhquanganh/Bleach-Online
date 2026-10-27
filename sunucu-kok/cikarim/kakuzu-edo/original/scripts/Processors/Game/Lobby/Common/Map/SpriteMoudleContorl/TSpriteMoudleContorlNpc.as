package Processors.Game.Lobby.Common.Map.SpriteMoudleContorl
{
   import Foundation.Common.TCoordinate;
   import Logics.Map.TMoudleInfor;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapNpc;
   
   public class TSpriteMoudleContorlNpc implements ISpriteMoudleContorl
   {
      
      public function TSpriteMoudleContorlNpc()
      {
         super();
      }
      
      public function GetRoleMoudleInfor(param1:TSceneSpriteMoudle, param2:uint, param3:uint, param4:uint, param5:TMoudleInfor) : void
      {
         var _loc6_:TSceneSpriteMoudleInMapNpc = null;
         _loc6_ = param1 as TSceneSpriteMoudleInMapNpc;
         param5.Scalx = 1;
         param5.TextureID = _loc6_.NpcStartTextureID;
      }
      
      public function GetDirectionByStartEndDirection(param1:TCoordinate, param2:TCoordinate) : int
      {
         return 0;
      }
   }
}

