package Processors.Game.Lobby.Common.Map.HeadDecoration
{
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TMilitary;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapCanRunPlayer;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.filters.GlowFilter;
   
   public class TDecorationMilitaryName extends TDecorationName
   {
      
      protected static const NameFilters:Array = [new GlowFilter(0,1,2,2,12,1,false,false)];
      
      protected static const MILITARY_COLOR:uint = 16435253;
      
      public function TDecorationMilitaryName()
      {
         super();
      }
      
      override protected function InitFilters() : void
      {
         FTextFiledName.filters = NameFilters;
         FTextFiledName.textColor = MILITARY_COLOR;
      }
      
      override public function get Position() : int
      {
         return POSITION_TOP;
      }
      
      override public function Update(param1:Object) : void
      {
         var _loc2_:TSceneSpriteMoudleInMapCanRunPlayer = null;
         var _loc3_:TMilitary = null;
         _loc2_ = param1 as TSceneSpriteMoudleInMapCanRunPlayer;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Military,_loc2_.MilitaryRank) as TMilitary;
         if(_loc3_ == null)
         {
            SetName("");
            return;
         }
         SetName(_loc3_.Name);
         FTextFiledName.x = -width / 2;
      }
   }
}

