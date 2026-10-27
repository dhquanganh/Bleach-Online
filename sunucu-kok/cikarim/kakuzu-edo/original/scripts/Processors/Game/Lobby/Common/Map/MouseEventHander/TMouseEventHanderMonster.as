package Processors.Game.Lobby.Common.Map.MouseEventHander
{
   import Foundation.Utilities.TUtilityFilter;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapMonster;
   
   public class TMouseEventHanderMonster extends TMouseEventHander
   {
      
      protected static const Filters:Array = [TUtilityFilter.highLightFilters];
      
      public function TMouseEventHanderMonster()
      {
         super();
      }
      
      override public function HandleOnMouseOver(param1:Object) : void
      {
         var _loc2_:TSceneSpriteMoudleInMapMonster = null;
         _loc2_ = param1 as TSceneSpriteMoudleInMapMonster;
         _loc2_.filters = Filters;
      }
      
      override public function HandleOnMouseMove(param1:Object) : void
      {
      }
      
      override public function HandleOnMouseOut(param1:Object) : void
      {
         var _loc2_:TSceneSpriteMoudleInMapMonster = null;
         _loc2_ = param1 as TSceneSpriteMoudleInMapMonster;
         _loc2_.filters = null;
      }
      
      override public function HandleOnMouseClick(param1:Object) : void
      {
         var _loc2_:TSceneSpriteMoudleInMapMonster = null;
         _loc2_ = param1 as TSceneSpriteMoudleInMapMonster;
         if(FCallback != null)
         {
            FCallback(_loc2_);
         }
      }
   }
}

