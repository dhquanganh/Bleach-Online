package Processors.Game.Lobby.Common.Map.HeadDecoration
{
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapNpc;
   import flash.filters.GlowFilter;
   
   public class TDecorationNameNpc extends TDecorationName
   {
      
      protected static const NameFilters:Array = [new GlowFilter(0,1,2,2,12,1,false,false)];
      
      public function TDecorationNameNpc()
      {
         super();
      }
      
      override protected function InitFilters() : void
      {
         FTextFiledName.filters = NameFilters;
      }
      
      override public function get Position() : int
      {
         return POSITION_TOP;
      }
      
      override public function Update(param1:Object) : void
      {
         var _loc2_:TSceneSpriteMoudleInMapNpc = null;
         _loc2_ = param1 as TSceneSpriteMoudleInMapNpc;
         SetName(_loc2_.Name);
         SetNameColor(16777215);
         FTextFiledName.x = -width / 2;
      }
   }
}

