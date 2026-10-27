package Processors.Game.Lobby.Common.Map.HeadDecoration
{
   import Foundation.Utilities.TUtilityReflection;
   import Resources.Constants.CONST_COMMON;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   
   public class TDecorationNameSolider extends TDecorationName
   {
      
      protected static const NameFilters:Array = [new GlowFilter(0,1,2,2,12,1,false,false)];
      
      protected var FYellowDiamondLevel:MovieClip;
      
      protected var FYearYellowDiamondFlag:Sprite;
      
      protected var FWrapper:Sprite;
      
      public function TDecorationNameSolider()
      {
         super();
         this.FWrapper = new Sprite();
         addChild(this.FWrapper);
      }
      
      protected function LoadResource() : void
      {
         if(this.FYellowDiamondLevel == null)
         {
            this.FYellowDiamondLevel = TUtilityReflection.CreateDisplayObjectInstance("YellowDiamondLevel") as MovieClip;
            this.FYearYellowDiamondFlag = TUtilityReflection.CreateDisplayObjectInstance("YearYellowDiamondFlag") as Sprite;
         }
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
      
      public function UpdateName(param1:String, param2:int) : void
      {
         var _loc3_:int = 0;
         SetName(param1);
         SetNameColor(CONST_COMMON.QUALITYCOLOR_INDEX[param2]);
         FTextFiledName.x = 0;
         this.FWrapper.addChild(FTextFiledName);
         _loc3_ = FTextFiledName.width;
         this.FWrapper.x = -(width / 2);
      }
   }
}

