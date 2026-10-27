package Processors.Game.Lobby.Common.Map.SceneSprite
{
   import Processors.Game.Lobby.Common.Map.SpriteMoudleContorl.TSpriteActionContorlMainSceneSprite;
   import Processors.Game.Lobby.Common.Map.SpriteMoudleContorl.TSpriteMoudleContorlEnvironment;
   
   public class TSceneSpriteMoudleInMapEnvironment extends TSceneSpriteMoudleInMap
   {
      
      public function TSceneSpriteMoudleInMapEnvironment()
      {
         super();
      }
      
      override protected function CreateSpriteActionQuery() : void
      {
         FActionQuery = new TSpriteActionContorlMainSceneSprite();
      }
      
      override protected function CreateSpriteMoudleContorl() : void
      {
         FSpriteMoudleContorl = new TSpriteMoudleContorlEnvironment();
      }
   }
}

