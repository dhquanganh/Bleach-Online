package Processors.Game.Lobby.Common.Map.MouseEventHander
{
   import Foundation.Utilities.TUtilityFilter;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapCanRunPlayer;
   
   public class TMouseEventHanderPlayer extends TMouseEventHander
   {
      
      protected static const Filters:Array = [TUtilityFilter.highLightFilters];
      
      public function TMouseEventHanderPlayer()
      {
         super();
      }
      
      override public function HandleOnMouseOver(param1:Object) : void
      {
         var _loc2_:TSceneSpriteMoudleInMapCanRunPlayer = null;
         _loc2_ = param1 as TSceneSpriteMoudleInMapCanRunPlayer;
         _loc2_.filters = Filters;
      }
      
      override public function HandleOnMouseMove(param1:Object) : void
      {
      }
      
      override public function HandleOnMouseOut(param1:Object) : void
      {
         var _loc2_:TSceneSpriteMoudleInMapCanRunPlayer = null;
         _loc2_ = param1 as TSceneSpriteMoudleInMapCanRunPlayer;
         _loc2_.filters = null;
      }
      
      override public function HandleOnMouseClick(param1:Object) : void
      {
         var _loc2_:TSceneSpriteMoudleInMapCanRunPlayer = null;
         _loc2_ = param1 as TSceneSpriteMoudleInMapCanRunPlayer;
         if(FCallback != null)
         {
            FCallback(_loc2_);
         }
      }
   }
}

