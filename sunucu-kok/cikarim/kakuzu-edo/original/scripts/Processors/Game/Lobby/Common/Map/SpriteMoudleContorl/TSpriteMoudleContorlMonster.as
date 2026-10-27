package Processors.Game.Lobby.Common.Map.SpriteMoudleContorl
{
   import Foundation.Common.TCoordinate;
   import Logics.Map.TMoudleInfor;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapMonster;
   
   public class TSpriteMoudleContorlMonster implements ISpriteMoudleContorl
   {
      
      public function TSpriteMoudleContorlMonster()
      {
         super();
      }
      
      public function GetRoleMoudleInfor(param1:TSceneSpriteMoudle, param2:uint, param3:uint, param4:uint, param5:TMoudleInfor) : void
      {
         var _loc6_:TSceneSpriteMoudleInMapMonster = null;
         _loc6_ = param1 as TSceneSpriteMoudleInMapMonster;
         param5.Scalx = 1;
         if(_loc6_.ReplaceID != 0)
         {
            param5.TextureID = 13610075;
         }
         else
         {
            param5.TextureID = _loc6_.MouduleID;
         }
      }
      
      public function GetDirectionByStartEndDirection(param1:TCoordinate, param2:TCoordinate) : int
      {
         return 0;
      }
   }
}

