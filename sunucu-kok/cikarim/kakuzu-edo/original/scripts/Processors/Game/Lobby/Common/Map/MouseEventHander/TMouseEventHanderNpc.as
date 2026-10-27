package Processors.Game.Lobby.Common.Map.MouseEventHander
{
   import Foundation.Utilities.TUtilityFilter;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapNpc;
   
   public class TMouseEventHanderNpc extends TMouseEventHander
   {
      
      protected static const Filters:Array = [TUtilityFilter.highLightFilters];
      
      public function TMouseEventHanderNpc()
      {
         super();
      }
      
      override public function HandleOnMouseOver(param1:Object) : void
      {
         var _loc2_:TSceneSpriteMoudleInMapNpc = null;
         _loc2_ = param1 as TSceneSpriteMoudleInMapNpc;
         _loc2_.filters = Filters;
      }
      
      override public function HandleOnMouseMove(param1:Object) : void
      {
      }
      
      override public function HandleOnMouseOut(param1:Object) : void
      {
         var _loc2_:TSceneSpriteMoudleInMapNpc = null;
         _loc2_ = param1 as TSceneSpriteMoudleInMapNpc;
         _loc2_.filters = null;
      }
      
      override public function HandleOnMouseClick(param1:Object) : void
      {
         var _loc2_:TSceneSpriteMoudleInMapNpc = null;
         _loc2_ = param1 as TSceneSpriteMoudleInMapNpc;
         if(FCallback != null)
         {
            FCallback(_loc2_);
         }
      }
   }
}

