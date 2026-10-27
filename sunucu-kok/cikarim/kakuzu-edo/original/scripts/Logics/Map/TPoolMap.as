package Logics.Map
{
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapCanRunPlayer;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapGuideBomb;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapGuidePoint;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapMonster;
   
   public class TPoolMap
   {
      
      protected static const CLASSNUM:int = 5;
      
      protected static const ClassReference:Vector.<Class> = Vector.<Class>([TSceneSpriteMoudleInMapMonster,TSceneSpriteMoudleInMapGuidePoint,TSceneSpriteMoudleInMapGuideBomb,TSceneSpriteMoudleInMapCanRunPlayer,TSceneSpriteMoudle]);
      
      protected var FPoolMonster:Vector.<TSceneSpriteMoudleInMapMonster>;
      
      protected var FPoolMonsterGuidePoint:Vector.<TSceneSpriteMoudleInMapGuidePoint>;
      
      protected var FPoolMonsterGuideBomb:Vector.<TSceneSpriteMoudleInMapGuideBomb>;
      
      protected var FPoolPlayer:Vector.<TSceneSpriteMoudleInMapCanRunPlayer>;
      
      protected var FPoolMoudle:Vector.<TSceneSpriteMoudle>;
      
      protected var Pools:Vector.<Object>;
      
      public function TPoolMap()
      {
         super();
         this.Pools = new Vector.<Object>();
         this.FPoolMonster = new Vector.<TSceneSpriteMoudleInMapMonster>();
         this.FPoolMonsterGuidePoint = new Vector.<TSceneSpriteMoudleInMapGuidePoint>();
         this.FPoolMonsterGuideBomb = new Vector.<TSceneSpriteMoudleInMapGuideBomb>();
         this.FPoolPlayer = new Vector.<TSceneSpriteMoudleInMapCanRunPlayer>();
         this.FPoolMoudle = new Vector.<TSceneSpriteMoudle>();
         this.Pools.push(this.FPoolMonster);
         this.Pools.push(this.FPoolMonsterGuidePoint);
         this.Pools.push(this.FPoolMonsterGuideBomb);
         this.Pools.push(this.FPoolPlayer);
         this.Pools.push(this.FPoolMoudle);
      }
      
      public function AcquireMonster() : TSceneSpriteMoudleInMapMonster
      {
         if(this.FPoolMonster.length > 0)
         {
            return this.FPoolMonster.pop();
         }
         return new TSceneSpriteMoudleInMapMonster();
      }
      
      public function AcquireMonsterGuidePoint() : TSceneSpriteMoudleInMapGuidePoint
      {
         if(this.FPoolMonsterGuidePoint.length > 0)
         {
            return this.FPoolMonsterGuidePoint.pop();
         }
         return new TSceneSpriteMoudleInMapGuidePoint();
      }
      
      public function AcquireMonsterGuideBomb() : TSceneSpriteMoudleInMapGuideBomb
      {
         if(this.FPoolMonsterGuideBomb.length > 0)
         {
            return this.FPoolMonsterGuideBomb.pop();
         }
         return new TSceneSpriteMoudleInMapGuideBomb();
      }
      
      public function AcquirePlayer() : TSceneSpriteMoudleInMapCanRunPlayer
      {
         if(this.FPoolPlayer.length > 0)
         {
            return this.FPoolPlayer.pop();
         }
         return new TSceneSpriteMoudleInMapCanRunPlayer();
      }
      
      public function AcquireMoudel() : TSceneSpriteMoudle
      {
         if(this.FPoolMoudle.length > 0)
         {
            return this.FPoolMoudle.pop();
         }
         return new TSceneSpriteMoudle();
      }
      
      public function Release(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < CLASSNUM)
         {
            if(param1 is ClassReference[_loc2_])
            {
               this.Pools[_loc2_].push(param1);
               return;
            }
            _loc2_++;
         }
      }
      
      public function Count() : int
      {
         return this.FPoolMonster.length + this.FPoolMonsterGuidePoint.length + this.FPoolMonsterGuideBomb.length;
      }
   }
}

