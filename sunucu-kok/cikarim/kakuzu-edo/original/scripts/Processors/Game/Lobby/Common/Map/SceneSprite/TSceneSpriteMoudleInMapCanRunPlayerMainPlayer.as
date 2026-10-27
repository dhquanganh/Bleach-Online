package Processors.Game.Lobby.Common.Map.SceneSprite
{
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationBleachAgentIcon;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationMilitaryName;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationNamePlayer;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationShadow;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationTitle;
   import Processors.Game.Lobby.Common.Map.SpriteMoudleContorl.TSpriteActionContorlMainSceneSprite;
   import Processors.Game.Lobby.Common.Map.SpriteMoudleContorl.TSpriteMoudleContorlEightDirection;
   
   public class TSceneSpriteMoudleInMapCanRunPlayerMainPlayer extends TSceneSpriteMoudleInMapCanRunPlayer
   {
      
      protected var FOnArriveTargetPosition:Function;
      
      public function TSceneSpriteMoudleInMapCanRunPlayerMainPlayer()
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      override protected function ArriveTarget() : void
      {
         if(this.FOnArriveTargetPosition != null)
         {
            this.FOnArriveTargetPosition();
         }
      }
      
      override protected function CreateDecoration() : void
      {
         var _loc1_:TDecorationNamePlayer = null;
         var _loc2_:TDecorationMilitaryName = null;
         var _loc3_:TDecorationTitle = null;
         var _loc4_:TDecorationShadow = null;
         var _loc5_:TDecorationBleachAgentIcon = null;
         _loc1_ = new TDecorationNamePlayer();
         _loc2_ = new TDecorationMilitaryName();
         _loc3_ = new TDecorationTitle();
         _loc4_ = new TDecorationShadow();
         _loc5_ = new TDecorationBleachAgentIcon();
         AddHeadDecoration(_loc1_);
         AddHeadDecoration(_loc2_);
         AddHeadDecoration(_loc3_);
         AddHeadDecoration(_loc4_);
         AddHeadDecoration(_loc5_);
         addChild(_loc1_);
         addChild(_loc2_);
         addChild(_loc3_);
         addChildAt(_loc4_,0);
         addChild(_loc5_);
      }
      
      override protected function CreateSpriteMoudleContorl() : void
      {
         FSpriteMoudleContorl = new TSpriteMoudleContorlEightDirection();
      }
      
      override protected function CreateSpriteActionQuery() : void
      {
         FActionQuery = new TSpriteActionContorlMainSceneSprite();
      }
      
      public function set OnArriveTargetPosition(param1:Function) : void
      {
         this.FOnArriveTargetPosition = param1;
      }
   }
}

