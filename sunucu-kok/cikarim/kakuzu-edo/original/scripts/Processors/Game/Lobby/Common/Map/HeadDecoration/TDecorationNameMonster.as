package Processors.Game.Lobby.Common.Map.HeadDecoration
{
   import Foundation.Utilities.TUtilityString;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapMonster;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Resources.Constants.CONST_WORLDMAP;
   import flash.filters.GlowFilter;
   
   public class TDecorationNameMonster extends TDecorationName
   {
      
      protected static const NameFilters:Array = [new GlowFilter(0,1,2,2,12,1,false,false)];
      
      protected static const COLOR_NORMAL:uint = CONST_COMMON.TEXT_White_Color;
      
      protected static const COLOR_BOSS:uint = 16768512;
      
      protected static const COLOR_NextLevel:uint = 16711680;
      
      public function TDecorationNameMonster()
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
         var _loc2_:TSceneSpriteMoudleInMapMonster = null;
         var _loc3_:String = null;
         _loc2_ = param1 as TSceneSpriteMoudleInMapMonster;
         if(_loc2_.MonsterState == CONST_WORLDMAP.MonsterState_NextLevel)
         {
            _loc3_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MainScene_STRING_2),_loc2_.HeroLevelNeed);
            SetName(_loc3_);
            SetNameColor(COLOR_NextLevel);
         }
         else
         {
            SetName(_loc2_.Name);
            if(_loc2_.IsBoss)
            {
               SetNameColor(COLOR_BOSS);
            }
            else
            {
               SetNameColor(COLOR_NORMAL);
            }
         }
         FTextFiledName.x = -width / 2;
      }
   }
}

