package Processors.Game.Lobby.MainSceneTwo
{
   import Logics.Map.TMapParameter;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMap;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapEnvironment;
   import Resources.Constants.CONST_MAP;
   
   public class TEnvironmentManager
   {
      
      protected static const SPRITESID:Vector.<int> = Vector.<int>([256002561,256002562,256002563,256002564,256002565]);
      
      protected var FSceneSprites:Vector.<TSceneSpriteMoudleInMap>;
      
      protected var FMapParameter:TMapParameter;
      
      public function TEnvironmentManager(param1:TMapParameter)
      {
         super();
         this.FSceneSprites = new Vector.<TSceneSpriteMoudleInMap>();
         this.FMapParameter = param1;
      }
      
      public function InitSceneSprites_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSceneSpriteMoudleInMap = null;
         _loc2_ = int(SPRITESID.length);
         _loc1_ = 0;
         while(_loc1_ < 0)
         {
            _loc3_ = new TSceneSpriteMoudleInMapEnvironment();
            _loc3_.RoleTempleteID = SPRITESID[_loc1_ % 5];
            _loc3_.MapParameter = this.FMapParameter;
            _loc3_.MouseEventHander = null;
            _loc3_.SpriteClassID = CONST_MAP.SPRITE_SYSTEMID_ENVIRONMENT;
            _loc3_.MapCoordinate.X = Math.random() * this.FMapParameter.MapData.MapWidth;
            _loc3_.MapCoordinate.Y = Math.random() * this.FMapParameter.MapData.MapHeight;
            this.FSceneSprites.push(_loc3_);
            _loc1_++;
         }
      }
      
      public function get SceneSprites() : Vector.<TSceneSpriteMoudleInMap>
      {
         return this.FSceneSprites;
      }
      
      public function InitSceneSprites() : void
      {
         this.InitSceneSprites_Perform();
      }
   }
}

