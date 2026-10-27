package Foundation.Utilities
{
   import Debugging.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.utils.*;
   
   public class TGameUtil
   {
      
      protected static const RENDERINGSTATE_Normal:int = 1;
      
      protected static const RENDERINGSTATE_Hovering:int = 2;
      
      protected static const RENDERINGSTATE_Pressed:int = 3;
      
      protected static const RENDERINGSTATE_Disabled:int = 4;
      
      public static var Type_None:int = 0;
      
      public static var Type_HeadIcon:int = 1;
      
      public static var Type_BackgroundIcon:int = 2;
      
      public static var Type_Model:int = 3;
      
      public static var Type_LargeIcon:int = 4;
      
      public static var Type_SmallIcon:int = 5;
      
      public static var Type_Inventory:int = 6;
      
      public static var Type_Skill:int = 7;
      
      public static var Type_Buff:int = 8;
      
      public static var Type_SkillPic:int = 9;
      
      public static var Type_DailyTask:int = 10;
      
      public function TGameUtil()
      {
         super();
      }
      
      public static function setButtonMode(param1:MovieClip, param2:Boolean) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param2)
         {
            param1.buttonMode = true;
            if(!param1.hasEventListener(MouseEvent.ROLL_OVER))
            {
               param1.addEventListener(MouseEvent.ROLL_OVER,onBtnResponse,false,0,true);
            }
            if(!param1.hasEventListener(MouseEvent.ROLL_OUT))
            {
               param1.addEventListener(MouseEvent.ROLL_OUT,onBtnResponse,false,0,true);
            }
            if(!param1.hasEventListener(MouseEvent.MOUSE_DOWN))
            {
               param1.addEventListener(MouseEvent.MOUSE_DOWN,onBtnResponse,false,0,true);
            }
            if(!param1.hasEventListener(MouseEvent.MOUSE_UP))
            {
               param1.addEventListener(MouseEvent.MOUSE_UP,onBtnResponse,false,0,true);
            }
            param1.gotoAndStop(RENDERINGSTATE_Normal);
         }
         else
         {
            param1.buttonMode = false;
            if(param1.hasEventListener(MouseEvent.ROLL_OVER))
            {
               param1.removeEventListener(MouseEvent.ROLL_OVER,onBtnResponse);
            }
            if(param1.hasEventListener(MouseEvent.ROLL_OUT))
            {
               param1.removeEventListener(MouseEvent.ROLL_OUT,onBtnResponse);
            }
            if(param1.hasEventListener(MouseEvent.MOUSE_DOWN))
            {
               param1.removeEventListener(MouseEvent.MOUSE_DOWN,onBtnResponse);
            }
            if(param1.hasEventListener(MouseEvent.MOUSE_UP))
            {
               param1.removeEventListener(MouseEvent.MOUSE_UP,onBtnResponse);
            }
            param1.gotoAndStop(RENDERINGSTATE_Disabled);
         }
         param1.mouseChildren = false;
         param1.tabEnabled = false;
      }
      
      private static function onBtnResponse(param1:MouseEvent) : void
      {
         if(!param1.currentTarget.buttonMode)
         {
            return;
         }
         if(param1.type == MouseEvent.ROLL_OVER)
         {
            param1.currentTarget.gotoAndStop(RENDERINGSTATE_Hovering);
         }
         else if(param1.type == MouseEvent.ROLL_OUT)
         {
            param1.currentTarget.gotoAndStop(RENDERINGSTATE_Normal);
         }
         else if(param1.type == MouseEvent.MOUSE_DOWN)
         {
            param1.currentTarget.gotoAndStop(RENDERINGSTATE_Pressed);
         }
         else if(param1.type == MouseEvent.MOUSE_UP)
         {
            param1.currentTarget.gotoAndStop(RENDERINGSTATE_Normal);
         }
      }
      
      public static function setMovieClipButton(param1:MovieClip, param2:Boolean, param3:Boolean = true) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param2)
         {
            param1.buttonMode = true;
            if(!param1.hasEventListener(MouseEvent.ROLL_OVER))
            {
               if(param3)
               {
                  param1.addEventListener(MouseEvent.ROLL_OVER,onMcResponse,false,10,true);
                  param1.addEventListener(MouseEvent.ROLL_OUT,onMcResponse,false,10,true);
                  param1.addEventListener(MouseEvent.MOUSE_DOWN,onMcResponse,false,10,true);
                  param1.addEventListener(MouseEvent.MOUSE_UP,onMcResponse,false,10,true);
               }
               else
               {
                  param1.addEventListener(MouseEvent.ROLL_OVER,onMcNormalResponse,false,10,true);
                  param1.addEventListener(MouseEvent.ROLL_OUT,onMcNormalResponse,false,10,true);
                  param1.addEventListener(MouseEvent.MOUSE_DOWN,onMcNormalResponse,false,10,true);
                  param1.addEventListener(MouseEvent.MOUSE_UP,onMcNormalResponse,false,10,true);
               }
            }
            param1.filters = [];
         }
         else
         {
            param1.buttonMode = false;
            if(param3)
            {
               if(param1.hasEventListener(MouseEvent.ROLL_OVER))
               {
                  param1.removeEventListener(MouseEvent.ROLL_OVER,onMcResponse);
               }
               if(param1.hasEventListener(MouseEvent.ROLL_OUT))
               {
                  param1.removeEventListener(MouseEvent.ROLL_OUT,onMcResponse);
               }
               if(param1.hasEventListener(MouseEvent.MOUSE_DOWN))
               {
                  param1.removeEventListener(MouseEvent.MOUSE_DOWN,onMcResponse);
               }
               if(param1.hasEventListener(MouseEvent.MOUSE_UP))
               {
                  param1.removeEventListener(MouseEvent.MOUSE_UP,onMcResponse);
               }
               param1.filters = [TUtilityFilter.rBlackFilters];
            }
            else
            {
               if(param1.hasEventListener(MouseEvent.ROLL_OVER))
               {
                  param1.removeEventListener(MouseEvent.ROLL_OVER,onMcNormalResponse);
               }
               if(param1.hasEventListener(MouseEvent.ROLL_OUT))
               {
                  param1.removeEventListener(MouseEvent.ROLL_OUT,onMcNormalResponse);
               }
               if(param1.hasEventListener(MouseEvent.MOUSE_DOWN))
               {
                  param1.removeEventListener(MouseEvent.MOUSE_DOWN,onMcNormalResponse);
               }
               if(param1.hasEventListener(MouseEvent.MOUSE_UP))
               {
                  param1.removeEventListener(MouseEvent.MOUSE_UP,onMcNormalResponse);
               }
            }
         }
         param1.mouseChildren = false;
         param1.tabEnabled = false;
      }
      
      private static function onMcResponse(param1:MouseEvent) : void
      {
         if(param1.type == MouseEvent.ROLL_OVER)
         {
            param1.currentTarget.filters = [TUtilityFilter.highLightFilters];
         }
         else if(param1.type == MouseEvent.ROLL_OUT)
         {
            param1.currentTarget.filters = [];
         }
         else if(param1.type == MouseEvent.MOUSE_DOWN)
         {
            param1.currentTarget.filters = [TUtilityFilter.darkFilters];
         }
         else if(param1.type == MouseEvent.MOUSE_UP)
         {
            param1.currentTarget.filters = [];
         }
      }
      
      private static function onMcNormalResponse(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         if(param1.type == MouseEvent.ROLL_OVER)
         {
            _loc2_.gotoAndStop(2);
         }
         else if(param1.type == MouseEvent.ROLL_OUT)
         {
            _loc2_.gotoAndStop(1);
         }
         else if(param1.type == MouseEvent.MOUSE_DOWN)
         {
            _loc2_.gotoAndStop(3);
         }
         else if(param1.type == MouseEvent.MOUSE_UP)
         {
            _loc2_.gotoAndStop(1);
         }
      }
      
      public static function GetIMG(param1:int, param2:int = 0, param3:int = 0, param4:int = 0) : TAnimationFrame
      {
         var _loc5_:TResourceRepositoryTexture = null;
         var _loc6_:TTexture = null;
         var _loc7_:TAnimationFrame = null;
         var _loc8_:TAnimationSequence = null;
         var _loc9_:BitmapData = null;
         if(param1 == Type_HeadIcon)
         {
            _loc5_ = SResourcesCore.TexturesHeadIcon;
         }
         else if(param1 == Type_BackgroundIcon)
         {
            _loc5_ = SResourcesCore.TexturesBackgroundIcon;
         }
         else if(param1 == Type_Model)
         {
            _loc5_ = SResourcesCore.TexturesModel;
         }
         else if(param1 == Type_LargeIcon)
         {
            _loc5_ = SResourcesCore.TexturesLargeIcon;
         }
         else if(param1 == Type_SmallIcon)
         {
            _loc5_ = SResourcesCore.TexturesSmallIcon;
         }
         else if(param1 == Type_Inventory)
         {
            _loc5_ = SResourcesCore.TexturesInventory;
         }
         else if(param1 == Type_Skill)
         {
            _loc5_ = SResourcesCore.TexturesSkill;
         }
         else if(param1 == Type_Buff)
         {
            _loc5_ = SResourcesCore.TexturesBuffIcon;
         }
         else if(param1 == Type_SkillPic)
         {
            _loc5_ = SResourcesCore.TexturesSkillIcon;
         }
         else
         {
            if(param1 != Type_DailyTask)
            {
               return null;
            }
            _loc5_ = SResourcesCore.TexturesDailytaskPicture;
         }
         _loc6_ = _loc5_.GetTextureByIdentifier(param2);
         if(_loc6_ != null)
         {
            _loc8_ = _loc6_.GetAnimationSequenceByIndex(param3);
            if(_loc8_ != null)
            {
               _loc7_ = _loc8_.GetAnimationFrameByIndex(param4);
               if(_loc7_ != null)
               {
                  return _loc7_;
               }
            }
         }
         else
         {
            _loc5_.LoadSecondary(param2);
         }
         return null;
      }
      
      public static function ShowImageByID(param1:int, param2:Bitmap, param3:int = 0, param4:int = 0, param5:int = 0) : void
      {
         var _loc6_:BitmapData = null;
         var _loc7_:TAnimationFrame = null;
         var _loc8_:DisplayObject = null;
         if(param2.bitmapData != null)
         {
            return;
         }
         _loc7_ = GetIMG(param1,param3,param4,param5);
         if(_loc7_ == null)
         {
            _loc6_ = null;
         }
         else
         {
            _loc6_ = _loc7_.Surface;
         }
         if(param2 != null)
         {
            if(param2.bitmapData != _loc6_)
            {
               param2.bitmapData = _loc6_;
               if(_loc7_ != null)
               {
                  param2.x = -_loc7_.Pivot.X;
                  param2.y = -_loc7_.Pivot.Y;
               }
            }
         }
      }
      
      public static function LockOrUnlockButton(param1:MovieClip, param2:Boolean) : void
      {
         if(param2)
         {
            param1.filters = [];
            param1.mouseEnabled = param2;
         }
         else
         {
            param1.filters = [TUtilityFilter.gBlackFilters];
            param1.mouseEnabled = param2;
         }
      }
   }
}

