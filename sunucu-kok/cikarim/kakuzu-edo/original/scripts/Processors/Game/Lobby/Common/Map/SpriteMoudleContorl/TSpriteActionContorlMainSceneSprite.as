package Processors.Game.Lobby.Common.Map.SpriteMoudleContorl
{
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMap;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapCanRun;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapNpc;
   import Resources.Constants.CONST_MAP;
   
   public class TSpriteActionContorlMainSceneSprite implements ISpriteActionContorl
   {
      
      public function TSpriteActionContorlMainSceneSprite()
      {
         super();
      }
      
      protected function ActionQueryByNpc(param1:TSceneSpriteMoudleInMapNpc) : int
      {
         return CONST_MAP.ACTION_IDLE;
      }
      
      protected function ActionQueryByMainScenePlayer(param1:TSceneSpriteMoudleInMapCanRun) : int
      {
         if(param1.RunOver)
         {
            return CONST_MAP.ACTION_IDLE;
         }
         return CONST_MAP.ACTION_RUN;
      }
      
      protected function ActionQueryByEnvironment(param1:TSceneSpriteMoudleInMap) : int
      {
         return CONST_MAP.ACTION_IDLE;
      }
      
      public function ActionQuery(param1:Object) : int
      {
         if(param1 is TSceneSpriteMoudleInMapCanRun)
         {
            return this.ActionQueryByMainScenePlayer(param1 as TSceneSpriteMoudleInMapCanRun);
         }
         if(param1 is TSceneSpriteMoudleInMapNpc)
         {
            return this.ActionQueryByNpc(param1 as TSceneSpriteMoudleInMapNpc);
         }
         return this.ActionQueryByEnvironment(param1 as TSceneSpriteMoudleInMap);
      }
   }
}

