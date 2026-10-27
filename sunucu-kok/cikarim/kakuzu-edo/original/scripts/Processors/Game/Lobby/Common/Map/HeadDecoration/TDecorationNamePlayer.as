package Processors.Game.Lobby.Common.Map.HeadDecoration
{
   import Foundation.Utilities.TUtilityString;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapCanRunPlayer;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   
   public class TDecorationNamePlayer extends TDecorationName
   {
      
      protected static const NameFilters:Array = [new GlowFilter(0,1,2,2,12,1,false,false)];
      
      protected var FYellowDiamondLevel:MovieClip;
      
      protected var FYearYellowDiamondFlag:Sprite;
      
      protected var FWrapper:Sprite;
      
      public function TDecorationNamePlayer()
      {
         super();
         this.FWrapper = new Sprite();
         addChild(this.FWrapper);
      }
      
      override protected function InitFilters() : void
      {
         FTextFiledName.filters = NameFilters;
      }
      
      override public function Release() : void
      {
         super.Release();
         while(this.FWrapper.numChildren != 0)
         {
            this.FWrapper.removeChildAt(0);
         }
      }
      
      override public function get Position() : int
      {
         return POSITION_TOP;
      }
      
      override public function Update(param1:Object) : void
      {
         var _loc2_:TSceneSpriteMoudleInMapCanRunPlayer = null;
         var _loc3_:int = 0;
         _loc2_ = param1 as TSceneSpriteMoudleInMapCanRunPlayer;
         if(_loc2_.RebirthNum > 0)
         {
            SetName(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_19),_loc2_.Name,_loc2_.RebirthNum));
         }
         else
         {
            SetName(_loc2_.Name);
         }
         SetNameColor(CONST_COMMON.QUALITYCOLOR_INDEX[_loc2_.Quality]);
         FTextFiledName.x = 0;
         this.FWrapper.addChild(FTextFiledName);
         _loc3_ = FTextFiledName.width;
         this.FWrapper.x = -(width / 2);
      }
   }
}

