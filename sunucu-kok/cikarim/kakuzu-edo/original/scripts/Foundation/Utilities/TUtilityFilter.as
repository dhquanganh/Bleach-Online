package Foundation.Utilities
{
   import flash.display.*;
   import flash.filters.*;
   import flash.geom.*;
   
   public class TUtilityFilter
   {
      
      private static var SKILL_ColorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,255,0,1,0,0,255,0,0,1,0,255,0,0,0,1,0]);
      
      private static var SKILL_GlowFilter:GlowFilter = new GlowFilter(16777215,1,6,6,2,1,false,false);
      
      public static var SKILL_FILTERS:Array = [SKILL_ColorMatrixFilter,SKILL_GlowFilter];
      
      public static var MissBlurFilter:BlurFilter = new BlurFilter(10,0,1);
      
      public static var MissDropShadowFilter_Left:DropShadowFilter = new DropShadowFilter(10,15,0,0.4980392156862745,10,0,2,5,false,false,false);
      
      public static var MissDropShadowFilter_Right:DropShadowFilter = new DropShadowFilter(-10,-15,0,0.4980392156862745,10,0,2,5,false,false,false);
      
      private static var NameFilters_0:GlowFilter = new GlowFilter(2302755,1,2,2,5);
      
      private static var NameFilters_1:GlowFilter = new GlowFilter(338944,1,2,2,5);
      
      private static var NameFilters_2:GlowFilter = new GlowFilter(3372,1,2,2,5);
      
      private static var NameFilters_3:GlowFilter = new GlowFilter(1507372,1,2,2,5);
      
      private static var NameFilters_4:GlowFilter = new GlowFilter(2891264,1,2,2,5);
      
      private static var NameFilters_5:GlowFilter = new GlowFilter(2883584,1,2,2,5);
      
      private static var NameFilters_6:GlowFilter = new GlowFilter(1573632,1,2,2,5);
      
      public static var NameFilters:Vector.<GlowFilter> = Vector.<GlowFilter>([NameFilters_0,NameFilters_0,NameFilters_1,NameFilters_2,NameFilters_3,NameFilters_4,NameFilters_5,NameFilters_6]);
      
      public static var highLightFilters:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,80,0,1,0,0,80,0,0,1,0,80,0,0,0,1,0]);
      
      public static var darkFilters:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,-50,0,1,0,0,-50,0,0,1,0,-50,0,0,0,1,0]);
      
      public static var rBlackFilters:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,1,0]);
      
      public static var gBlackFilters:ColorMatrixFilter = new ColorMatrixFilter([0,1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,1,0]);
      
      public static var bBlackFilters:ColorMatrixFilter = new ColorMatrixFilter([0,0,1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,1,0]);
      
      public static var ActiveDie:BlurFilter = new BlurFilter(3,15);
      
      public static var RedFilters:ColorMatrixFilter = new ColorMatrixFilter([1,0.5,255,255,255,1,0,0,0,0,1,0,0,0,0,0,0,0,1,0]);
      
      public static var RedAntiColorFilters:ColorMatrixFilter = new ColorMatrixFilter([-0.5,0,0,0,150,0,-1,0,0,13,0,0,-1,0,0,0,0,0,1,0]);
      
      public static var AntiColorFilters:ColorMatrixFilter = new ColorMatrixFilter([-1,0,0,0,255,0,-1,0,0,255,0,0,-1,0,255,0,0,0,1,0]);
      
      public static var GaryColorFilters:ColorMatrixFilter = new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0]);
      
      public static var GaryColorFiltersTwo:ColorMatrixFilter = new ColorMatrixFilter([0.3086,0.6094,0.082,0,30,0.3086,0.6094,0.082,0,30,0.3086,0.6094,0.082,0,30,0,0,0,1,0]);
      
      public static var GaryColorFiltersMask:ColorMatrixFilter = new ColorMatrixFilter([0.4,0,0,0,0,0,0.4,0,0,0,0,0,0.4,0,0,0,0,0,1,0]);
      
      public static var GaryColorFiltersThree:ColorMatrixFilter = new ColorMatrixFilter([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0]);
      
      public static var LeftShadowFilters:DropShadowFilter = new DropShadowFilter(10,0,0,0.3,0,0);
      
      public static var RightShadowFilters:DropShadowFilter = new DropShadowFilter(-10,0,0,0.3,0,0);
      
      public function TUtilityFilter()
      {
         super();
         throw new Error("TUtilityFilter Class Is Static Container Only");
      }
      
      public static function SetBrightness(param1:DisplayObject, param2:Number) : void
      {
         var _loc3_:ColorTransform = null;
         _loc3_ = param1.transform.colorTransform;
         if(param2 >= 0)
         {
            _loc3_.redOffset = 2.55 * param2;
            _loc3_.greenOffset = 2.55 * param2;
            _loc3_.blueOffset = 2.55 * param2;
         }
         param1.transform.colorTransform = _loc3_;
      }
   }
}

