package Processors.Game.Battle.Effect
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Battle.*;
   import Logics.Battle.model.*;
   import Processors.Game.Battle.*;
   import Processors.Game.Battle.Character.*;
   import Rendering.Texts.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.utils.*;
   import ghostcat.util.easing.*;
   
   public class TEffectControl
   {
      
      protected static var FBoundsTitle:TBounds;
      
      protected static var FPainterTextEffect:TPainterTextEffect;
      
      protected static var FBigBmp:Bitmap;
      
      protected static var FBigBlackLine:Bitmap;
      
      protected static var FlickerTimerId:uint;
      
      protected static const EFFECT_Critical:String = "EffectCritical_jsj";
      
      protected static const EFFECT_TARGET:int = 0;
      
      protected static const EFFECT_RESOURCE_ID:int = 1;
      
      protected static const EFFECT_SEQUENCE:int = 2;
      
      protected static const EFFECT_LOGIC:int = 3;
      
      protected static const EFFECT_SOURCE:int = 4;
      
      protected static const EFFECT_INITIATOR:int = 5;
      
      protected static const EFFECT_TARGETS:int = 6;
      
      protected static const EFFECT_RESULTS:int = 7;
      
      protected static const EFFECT_RESETPOSINT_X:int = 8;
      
      protected static const EFFECT_RESETPOSINT_Y:int = 9;
      
      protected static const EFFECT_POINT_X:int = 10;
      
      protected static const EFFECT_POINT_Y:int = 11;
      
      protected static const EFFECT_BMP:int = 12;
      
      protected static const EFFECT_TICK:int = 13;
      
      protected static const EFFECT_TEXTFUNCTION:int = 14;
      
      protected static const EFFECT_SPEED_X:int = 15;
      
      protected static const EFFECT_SPEED_Y:int = 16;
      
      protected static const EFFECT_MOVE_TICK:int = 17;
      
      protected static const EFFECT_MOVE_X:int = 18;
      
      protected static const EFFECT_MOVE_Y:int = 19;
      
      protected static const EFFECT_FRAME_INDEX:int = 20;
      
      protected static const EFFECT_PUBLIC_TARGET:int = 0;
      
      protected static const EFFECT_PUBLIC_RESOURCE_ID:int = 1;
      
      protected static const EFFECT_PUBLIC_BMP:int = 2;
      
      protected static const EFFECT_PUBLIC_SEQUENCE:int = 3;
      
      protected static const EFFECT_PUBLIC_POINT_X:int = 4;
      
      protected static const EFFECT_PUBLIC_POINT_Y:int = 5;
      
      protected static const EFFECT_PUBLIC_TICK:int = 6;
      
      protected static const EFFECT_PUBLIC_CALLBACK:int = 7;
      
      protected static const EFFECT_SPECIALCHAIN_SPRITELIST:int = 0;
      
      protected static const EFFECT_SPECIALCHAIN_SEQUENCE:int = 1;
      
      protected static const EFFECT_SPECIALCHAIN_SOUND_ID:int = 2;
      
      protected static const EFFECT_SPECIALCHAIN_ATTACKEFFECT:int = 3;
      
      protected static const EFFECT_SPECIALCHAIN_TARGETS:int = 4;
      
      protected static const EFFECT_SPECIALCHAIN_RESULTS:int = 5;
      
      protected static const EFFECT_SPECIALCHAIN_SHOWINDEX:int = 6;
      
      protected static const EFFECT_SPECIALCHAIN_INDEXTICK:int = 7;
      
      protected static const EFFECT_SPECIALCHAIN_TICK:int = 8;
      
      protected static const EFFECT_SPECIALCHAIN_TEXTFUNCTION:int = 9;
      
      protected static var FSharkDict:Dictionary = new Dictionary(true);
      
      protected static var FRoleVect:Vector.<Vector.<Object>> = new Vector.<Vector.<Object>>();
      
      protected static var FRoleSpecialChainVect:Vector.<Vector.<Object>> = new Vector.<Vector.<Object>>();
      
      protected static var FPublicEffectVect:Vector.<Vector.<Object>> = new Vector.<Vector.<Object>>();
      
      public function TEffectControl()
      {
         super();
      }
      
      public static function get EffectCount() : int
      {
         return FRoleVect.length + FRoleSpecialChainVect.length;
      }
      
      public static function ShowEffect(param1:DisplayObjectContainer, param2:uint, param3:Object = null, param4:TRole = null, param5:TRole = null, param6:Vector.<TRole> = null, param7:Vector.<TTargetInfo> = null, param8:Number = 0, param9:Number = 0, param10:Number = 0, param11:Number = 0, param12:Function = null, param13:int = 0, param14:int = 0, param15:int = 0, param16:int = 1, param17:int = -1) : void
      {
         var _loc18_:TResourceRepositoryTexture = null;
         var _loc19_:TTexture = null;
         var _loc20_:TAnimationSequence = null;
         var _loc21_:uint = 0;
         var _loc22_:Bitmap = null;
         _loc18_ = SResourcesCore.TexturesSkill;
         _loc19_ = _loc18_.GetTextureByIdentifier(param2);
         if(_loc19_ != null)
         {
            if(_loc19_.Count > 1)
            {
               _loc21_ = Math.random() * _loc19_.Count;
            }
            else
            {
               _loc21_ = 0;
            }
            _loc20_ = _loc19_.GetAnimationSequenceByIndex(_loc21_);
         }
         _loc22_ = TPoolBitmap.GetBitmap();
         _loc22_.scaleX = param16;
         if(param1 is TRole)
         {
            (param1 as TRole).EffectSprite.addChild(_loc22_);
         }
         else if(param1 is TBattleStage)
         {
            (param1 as TBattleStage).EffectSprite.addChild(_loc22_);
         }
         else
         {
            if(!(param1 is TUIComponent))
            {
               return;
            }
            if(param17 < 0)
            {
               (param1 as TUIComponent).addChild(_loc22_);
            }
            else
            {
               (param1 as TUIComponent).addChildAt(_loc22_,param17);
            }
         }
         FRoleVect.push(Vector.<Object>([param1,param2,_loc20_,param3,param4,param5,param6,param7,param8,param9,param10,param11,_loc22_,0,param12,param13,param14,param15,0,0,-1]));
      }
      
      public static function ShowSpecialChainEffect(param1:TBattleStage, param2:uint, param3:Object, param4:Vector.<TRole>, param5:Vector.<TTargetInfo>, param6:Function = null) : void
      {
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:TResourceRepositoryTexture = null;
         var _loc10_:TTexture = null;
         var _loc11_:TAnimationSequence = null;
         var _loc12_:uint = 0;
         var _loc13_:Vector.<Sprite> = null;
         var _loc14_:Vector.<uint> = null;
         var _loc15_:Bitmap = null;
         var _loc16_:Number = Number(NaN);
         var _loc17_:Number = Number(NaN);
         var _loc18_:Number = Number(NaN);
         var _loc19_:Number = Number(NaN);
         var _loc20_:Sprite = null;
         _loc9_ = SResourcesCore.TexturesSkill;
         _loc10_ = _loc9_.GetTextureByIdentifier(param2);
         if(_loc10_ != null)
         {
            if(_loc10_.Count > 1)
            {
               _loc12_ = Math.random() * _loc10_.Count;
            }
            else
            {
               _loc12_ = 0;
            }
            _loc11_ = _loc10_.GetAnimationSequenceByIndex(_loc12_);
         }
         _loc8_ = param4.length;
         _loc13_ = new Vector.<Sprite>();
         _loc14_ = new Vector.<uint>();
         _loc7_ = 0;
         while(_loc7_ < _loc8_ - 1)
         {
            _loc15_ = TPoolBitmap.GetBitmap();
            _loc20_ = new Sprite();
            _loc13_.push(_loc20_);
            _loc14_.push(0);
            _loc16_ = param4[_loc7_].x;
            _loc17_ = param4[_loc7_].y;
            _loc18_ = param4[_loc7_ + 1].x;
            _loc19_ = param4[_loc7_ + 1].y;
            _loc20_.x = (_loc16_ + _loc18_) / 2;
            _loc20_.y = (_loc17_ + _loc19_) / 2;
            _loc20_.visible = false;
            _loc20_.scaleX = Math.sqrt(Math.pow(_loc18_ - _loc16_,2) + Math.pow(_loc19_ - _loc17_,2)) / 270;
            _loc20_.rotation = Math.atan((_loc19_ - _loc17_) / (_loc18_ - _loc16_)) / Math.PI * 180;
            _loc20_.y -= 60;
            _loc20_.addChild(_loc15_);
            param1.EffectSprite.addChild(_loc20_);
            _loc7_++;
         }
         FRoleSpecialChainVect.push(Vector.<Object>([_loc13_,_loc11_,param3.voice,param3.AttackedEffectId,param4,param5,-1,350,_loc14_,param6]));
      }
      
      public static function ShowPublicEffect(param1:DisplayObjectContainer, param2:uint, param3:Number = 0, param4:Number = 0, param5:Function = null) : void
      {
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         var _loc8_:TAnimationSequence = null;
         var _loc9_:Bitmap = null;
         _loc6_ = SResourcesCore.TexturesSkill;
         _loc7_ = _loc6_.GetTextureByIdentifier(param2);
         if(_loc7_ == null)
         {
            if(param5 != null)
            {
               param5();
            }
            return;
         }
         _loc8_ = _loc7_.GetAnimationSequenceByIndex(0);
         if(_loc8_ == null)
         {
            return;
         }
         _loc9_ = TPoolBitmap.GetBitmap();
         param1.addChild(_loc9_);
         FPublicEffectVect.push(Vector.<Object>([param1,param2,_loc9_,_loc8_,param3,param4,0,param5]));
      }
      
      public static function ShowMoveEffect(param1:DisplayObject, param2:Number, param3:Number, param4:uint, param5:Function = null) : void
      {
         var EndMove:Function = null;
         var Container:DisplayObject = param1;
         var EndPosX:Number = param2;
         var EndPosY:Number = param3;
         var CostTime:uint = param4;
         var Callback:Function = param5;
         EndMove = function():void
         {
            if(Callback != null)
            {
               Callback(Container);
            }
         };
         TweenUtil.to(Container,CostTime / TBattleHandle.PlaybackRate,{
            "x":EndPosX,
            "y":EndPosY,
            "onComplete":EndMove
         });
      }
      
      public static function ShowUIEffect(param1:TBattleStage, param2:uint, param3:int, param4:String, param5:Function = null) : void
      {
         var Textures:TResourceRepositoryTexture = null;
         var Texture:TTexture = null;
         var Frame:TAnimationFrame = null;
         var Sequence:TAnimationSequence = null;
         var BmpData:BitmapData = null;
         var OnMoveEnd:Function = null;
         var BattleStage:TBattleStage = param1;
         var Id:uint = param2;
         var Direction:int = param3;
         var NameTxt:String = param4;
         var CallBack:Function = param5;
         OnMoveEnd = function():void
         {
            FBigBmp.visible = false;
            FPainterTextEffect.visible = false;
            FBigBlackLine.visible = false;
            if(CallBack != null)
            {
               TBattleHandle.PlaybackTimeout(CallBack,400);
            }
         };
         if(FBigBlackLine == null)
         {
            Textures = SResourcesCore.TexturesSkill;
            Texture = Textures.GetTextureByIdentifier(CONST_BATTLE.EFFECT_BIGBLACK_ID);
            FBigBlackLine = TPoolBitmap.GetBitmap();
            if(Texture != null)
            {
               Sequence = Texture.GetAnimationSequenceByIndex(0);
               if(Sequence != null)
               {
                  Frame = Sequence.GetAnimationFrameByIndex(0);
                  if(Frame != null)
                  {
                     BmpData = Frame.Surface;
                     if(FBigBlackLine.bitmapData != BmpData)
                     {
                        FBigBlackLine.bitmapData = BmpData;
                     }
                  }
               }
            }
            FBigBlackLine.y = 186 + 170;
         }
         BattleStage.addChild(FBigBlackLine);
         if(FBigBmp == null)
         {
            FBigBmp = TPoolBitmap.GetBitmap();
         }
         BattleStage.addChild(FBigBmp);
         Textures = SResourcesCore.TexturesLargeIcon;
         Texture = Textures.GetTextureByIdentifier(Id);
         if(Texture == null)
         {
            FBigBmp.visible = false;
            if(FPainterTextEffect != null)
            {
               FPainterTextEffect.visible = false;
            }
            FBigBlackLine.visible = false;
            if(CallBack != null)
            {
               CallBack();
            }
            return;
         }
         Sequence = Texture.GetAnimationSequenceByIndex(0);
         if(Sequence != null)
         {
            Frame = Sequence.GetAnimationFrameByIndex(0);
            if(Frame != null)
            {
               BmpData = Frame.Surface;
               if(FBigBmp.bitmapData != BmpData)
               {
                  FBigBmp.bitmapData = BmpData;
               }
            }
         }
         if(FBoundsTitle == null)
         {
            FBoundsTitle = new TBounds();
            FBoundsTitle.X = 450;
            FBoundsTitle.Y = 223 + 160;
            FBoundsTitle.Width = 400;
            FBoundsTitle.Height = 40;
         }
         if(FPainterTextEffect == null)
         {
            FPainterTextEffect = new TPainterTextEffect(BattleStage);
            FPainterTextEffect.Font.Name = CONST_FONTLIBRARY.FONT_NAME_Bleach_UI_00;
            FPainterTextEffect.Font.Size = 90;
            FPainterTextEffect.Font.Color = 16777215;
            FPainterTextEffect.FontEffect.Outlined = true;
            FPainterTextEffect.FontEffect.OutlineColor = 4281475875;
            FPainterTextEffect.FontEffect.OutlineSize = 5;
         }
         BattleStage.addChild(FPainterTextEffect);
         FBigBlackLine.visible = true;
         FBigBmp.visible = true;
         FPainterTextEffect.visible = true;
         FPainterTextEffect.Text = NameTxt;
         FPainterTextEffect.RenderBounds(FBoundsTitle,TAlignment.HORIZONTAL_Center);
         if(Direction == 0)
         {
            FBigBmp.filters = [TUtilityFilter.LeftShadowFilters];
            FBigBmp.x = 228;
            FBigBmp.y = 140;
            FPainterTextEffect.x = 620;
            TweenUtil.to(FBigBmp,1000 / TBattleHandle.PlaybackRate,{
               "x":FBigBmp.x - 20,
               "onComplete":OnMoveEnd
            });
            TweenUtil.to(FPainterTextEffect,1000 / TBattleHandle.PlaybackRate,{"x":FPainterTextEffect.x + 20});
         }
         else
         {
            FBigBmp.filters = [TUtilityFilter.RightShadowFilters];
            FBigBmp.x = 699;
            FBigBmp.y = 140;
            FPainterTextEffect.x = 600 - FPainterTextEffect.TextWidth;
            TweenUtil.to(FBigBmp,1000 / TBattleHandle.PlaybackRate,{
               "x":FBigBmp.x + 20,
               "onComplete":OnMoveEnd
            });
            TweenUtil.to(FPainterTextEffect,1000 / TBattleHandle.PlaybackRate,{"x":FPainterTextEffect.x - 20});
         }
      }
      
      public static function MakeCritical(param1:TBattleHandle) : void
      {
         var Sequence:TAnimationSequence = null;
         var Frame:TAnimationFrame = null;
         var BmpData:BitmapData = null;
         var FBmp:Bitmap = null;
         var Critical:DisplayObjectContainer = null;
         var ClearCritical:Function = null;
         var Textures:TResourceRepositoryTexture = null;
         var FTexture:TTexture = null;
         var Container:TBattleHandle = param1;
         ClearCritical = function():void
         {
            Critical.visible = false;
            clearInterval(FlickerTimerId);
         };
         Critical = Container.getChildByName(EFFECT_Critical) as DisplayObjectContainer;
         if(Critical == null)
         {
            Critical = new Sprite();
            Critical.name = EFFECT_Critical;
            Container.addChild(Critical);
            Textures = SResourcesCore.TexturesSkill;
            FTexture = Textures.GetTextureByIdentifier(CONST_BATTLE.Public_Effect_Crit);
            if(FTexture)
            {
               Sequence = FTexture.GetAnimationSequenceByIndex(0);
               if(Sequence != null)
               {
                  Frame = Sequence.GetAnimationFrameByIndex(0);
                  if(Frame != null)
                  {
                     BmpData = Frame.Surface;
                     FBmp = TPoolBitmap.GetBitmap();
                     FBmp.bitmapData = BmpData;
                     FBmp.x = -Frame.Pivot.X;
                     FBmp.y = -Frame.Pivot.Y;
                     FBmp.x += Container.width > CONST_COMMON.STAGE_Width ? CONST_COMMON.STAGE_Width : Container.width;
                     Critical.addChild(FBmp);
                     FBmp = TPoolBitmap.GetBitmap();
                     FBmp.bitmapData = BmpData;
                     FBmp.x = Frame.Pivot.X;
                     FBmp.y = -Frame.Pivot.Y;
                     FBmp.scaleX = -1;
                     Critical.addChild(FBmp);
                     FBmp = TPoolBitmap.GetBitmap();
                     FBmp.bitmapData = BmpData;
                     FBmp.x = Frame.Pivot.X;
                     FBmp.y = Frame.Pivot.Y;
                     FBmp.scaleX = -1;
                     FBmp.scaleY = -1;
                     FBmp.y += Container.height > CONST_COMMON.STAGE_Height ? CONST_COMMON.STAGE_Height : Container.height;
                     Critical.addChild(FBmp);
                     FBmp = TPoolBitmap.GetBitmap();
                     FBmp.bitmapData = BmpData;
                     FBmp.x = -Frame.Pivot.X;
                     FBmp.y = Frame.Pivot.Y;
                     FBmp.scaleY = -1;
                     FBmp.x += Container.width > CONST_COMMON.STAGE_Width ? CONST_COMMON.STAGE_Width : Container.width;
                     FBmp.y += Container.height > CONST_COMMON.STAGE_Height ? CONST_COMMON.STAGE_Height : Container.height;
                     Critical.addChild(FBmp);
                  }
               }
            }
         }
         clearInterval(FlickerTimerId);
         FlickerTimerId = PlayFlicker(Critical,50);
         PlayShake(Container,10,ClearCritical);
      }
      
      public static function RemoveEffect(param1:DisplayObjectContainer, param2:uint = 0) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:Vector.<Object> = null;
         var _loc6_:DisplayObjectContainer = null;
         var _loc7_:Bitmap = null;
         _loc3_ = 0;
         while(_loc3_ < FRoleVect.length)
         {
            _loc5_ = FRoleVect[_loc3_];
            if(_loc5_ != null)
            {
               _loc6_ = _loc5_[EFFECT_TARGET] as DisplayObjectContainer;
               _loc4_ = _loc5_[EFFECT_RESOURCE_ID] as uint;
               _loc7_ = _loc5_[EFFECT_BMP] as Bitmap;
               if(_loc6_ == param1 && _loc4_ == param2)
               {
                  FRoleVect.splice(_loc3_,1);
                  TPoolBitmap.SaveBitmap(_loc7_);
                  return;
               }
            }
            _loc3_++;
         }
      }
      
      public static function RemoveContainerEffect(param1:DisplayObjectContainer) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<Object> = null;
         var _loc4_:DisplayObjectContainer = null;
         var _loc5_:Bitmap = null;
         _loc2_ = 0;
         while(_loc2_ < FRoleVect.length)
         {
            _loc3_ = FRoleVect[_loc2_];
            if(_loc3_ != null)
            {
               _loc4_ = _loc3_[EFFECT_TARGET] as DisplayObjectContainer;
               _loc5_ = _loc3_[EFFECT_BMP] as Bitmap;
               if(_loc4_ == param1)
               {
                  FRoleVect.splice(_loc2_,1);
                  TPoolBitmap.SaveBitmap(_loc5_);
               }
            }
            _loc2_++;
         }
      }
      
      public static function RemovePublicEffect(param1:DisplayObjectContainer, param2:uint = 0) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:Vector.<Object> = null;
         var _loc6_:DisplayObjectContainer = null;
         var _loc7_:Bitmap = null;
         _loc3_ = 0;
         while(_loc3_ < FPublicEffectVect.length)
         {
            _loc5_ = FPublicEffectVect[_loc3_];
            if(_loc5_ != null)
            {
               _loc6_ = _loc5_[EFFECT_PUBLIC_TARGET] as DisplayObjectContainer;
               _loc4_ = _loc5_[EFFECT_PUBLIC_RESOURCE_ID] as uint;
               _loc7_ = _loc5_[EFFECT_PUBLIC_BMP] as Bitmap;
               if(_loc6_ == param1 && _loc4_ == param2)
               {
                  FPublicEffectVect.splice(_loc3_,1);
                  TPoolBitmap.SaveBitmap(_loc7_);
                  return;
               }
            }
            _loc3_++;
         }
      }
      
      public static function RemoveContainerPublicEffect(param1:DisplayObjectContainer) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:Vector.<Object> = null;
         var _loc5_:DisplayObjectContainer = null;
         var _loc6_:Bitmap = null;
         _loc2_ = 0;
         while(_loc2_ < FPublicEffectVect.length)
         {
            _loc4_ = FPublicEffectVect[_loc2_];
            if(_loc4_ != null)
            {
               _loc5_ = _loc4_[EFFECT_PUBLIC_TARGET] as DisplayObjectContainer;
               _loc3_ = _loc4_[EFFECT_PUBLIC_RESOURCE_ID] as uint;
               _loc6_ = _loc4_[EFFECT_PUBLIC_BMP] as Bitmap;
               if(_loc5_ == param1)
               {
                  FPublicEffectVect.splice(_loc2_,1);
                  TPoolBitmap.SaveBitmap(_loc6_);
               }
            }
            _loc2_++;
         }
      }
      
      public static function RemoveAllEffect() : void
      {
         var _loc1_:Vector.<Object> = null;
         var _loc2_:Bitmap = null;
         while(FRoleVect.length)
         {
            _loc1_ = FRoleVect.pop();
            if(_loc1_ != null)
            {
               _loc2_ = _loc1_[EFFECT_BMP] as Bitmap;
               TPoolBitmap.SaveBitmap(_loc2_);
            }
         }
      }
      
      public static function RemoveAllSpecialChainEffect() : void
      {
         var _loc1_:Vector.<Object> = null;
         var _loc2_:Vector.<Sprite> = null;
         var _loc3_:Sprite = null;
         var _loc4_:Bitmap = null;
         while(FRoleSpecialChainVect.length)
         {
            _loc1_ = FRoleSpecialChainVect.pop();
            if(_loc1_ != null)
            {
               _loc2_ = _loc1_[EFFECT_SPECIALCHAIN_SPRITELIST] as Vector.<Sprite>;
               while(_loc2_.length)
               {
                  _loc3_ = _loc2_.pop();
                  _loc4_ = _loc3_.getChildAt(0) as Bitmap;
                  TPoolBitmap.SaveBitmap(_loc4_);
               }
            }
         }
      }
      
      public static function UpdataRoleEffect() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TAnimationFrame = null;
         var _loc4_:TAnimationSequence = null;
         var _loc5_:BitmapData = null;
         var _loc6_:Vector.<Object> = null;
         var _loc7_:DisplayObjectContainer = null;
         var _loc8_:uint = 0;
         var _loc9_:Object = null;
         var _loc10_:TRole = null;
         var _loc11_:TRole = null;
         var _loc12_:Vector.<TRole> = null;
         var _loc13_:Vector.<TTargetInfo> = null;
         var _loc14_:Bitmap = null;
         var _loc15_:int = 0;
         var _loc16_:Object = null;
         var _loc17_:Number = Number(NaN);
         var _loc18_:Number = Number(NaN);
         var _loc19_:Number = Number(NaN);
         var _loc20_:Number = Number(NaN);
         var _loc21_:Function = null;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         var _loc29_:Number = Number(NaN);
         var _loc30_:Number = Number(NaN);
         var _loc31_:Number = Number(NaN);
         var _loc32_:Number = Number(NaN);
         var _loc33_:Boolean = false;
         _loc28_ = int(FRoleVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc28_)
         {
            _loc6_ = FRoleVect[_loc1_];
            if(_loc6_ != null)
            {
               _loc7_ = _loc6_[EFFECT_TARGET] as DisplayObjectContainer;
               _loc8_ = _loc6_[EFFECT_RESOURCE_ID] as uint;
               _loc4_ = _loc6_[EFFECT_SEQUENCE] as TAnimationSequence;
               _loc9_ = _loc6_[EFFECT_LOGIC];
               _loc10_ = _loc6_[EFFECT_SOURCE] as TRole;
               _loc11_ = _loc6_[EFFECT_INITIATOR] as TRole;
               _loc12_ = _loc6_[EFFECT_TARGETS] as Vector.<TRole>;
               _loc13_ = _loc6_[EFFECT_RESULTS] as Vector.<TTargetInfo>;
               _loc17_ = _loc6_[EFFECT_RESETPOSINT_X] as Number;
               _loc18_ = _loc6_[EFFECT_RESETPOSINT_Y] as Number;
               _loc19_ = _loc6_[EFFECT_POINT_X] as Number;
               _loc20_ = _loc6_[EFFECT_POINT_Y] as Number;
               _loc14_ = _loc6_[EFFECT_BMP] as Bitmap;
               _loc15_ = _loc6_[EFFECT_TICK] as int;
               _loc21_ = _loc6_[EFFECT_TEXTFUNCTION] as Function;
               _loc22_ = _loc6_[EFFECT_SPEED_X] as int;
               _loc23_ = _loc6_[EFFECT_SPEED_Y] as int;
               _loc24_ = _loc6_[EFFECT_MOVE_TICK] as int;
               _loc25_ = _loc6_[EFFECT_MOVE_X] as int;
               _loc26_ = _loc6_[EFFECT_MOVE_Y] as int;
               _loc27_ = _loc6_[EFFECT_FRAME_INDEX] as int;
               if(_loc4_ == null)
               {
                  _loc3_ = null;
                  _loc27_++;
                  _loc6_[EFFECT_FRAME_INDEX] = _loc27_;
               }
               else
               {
                  _loc3_ = _loc4_.GetAnimationFrameByTick(_loc15_);
                  _loc27_ = _loc4_.Index;
               }
               if(_loc3_ != null)
               {
                  _loc5_ = _loc3_.Surface;
                  if(_loc14_.bitmapData != _loc5_)
                  {
                     if((_loc8_ == 13610004 || _loc8_ == 13610005) && _loc27_ == 0)
                     {
                        _loc29_ = 5 - Math.random() * 10;
                        _loc30_ = 5 - Math.random() * 10;
                        _loc19_ += _loc29_;
                        _loc20_ += _loc30_;
                        _loc6_[EFFECT_POINT_X] += _loc29_;
                        _loc6_[EFFECT_POINT_Y] += _loc30_;
                     }
                     _loc14_.bitmapData = _loc5_;
                     if(_loc14_.scaleX > 0)
                     {
                        _loc14_.x = -_loc3_.Pivot.X + _loc19_;
                     }
                     else
                     {
                        _loc14_.x = _loc3_.Pivot.X + _loc19_;
                     }
                     _loc14_.y = -_loc3_.Pivot.Y + _loc20_;
                     if(_loc9_ != null && _loc9_.newPoint != null)
                     {
                        _loc16_ = _loc9_.newPoint[_loc27_];
                        if(_loc16_ != null)
                        {
                           if(_loc16_.target == 1)
                           {
                              _loc6_[EFFECT_POINT_X] += _loc16_.newPointX ? _loc16_.newPointX : 0;
                              _loc6_[EFFECT_POINT_Y] += _loc16_.newPointY ? _loc16_.newPointY : 0;
                              _loc14_.x += _loc6_[EFFECT_POINT_X];
                              _loc14_.y += _loc6_[EFFECT_POINT_Y];
                           }
                           else if(_loc16_.target == 2)
                           {
                              _loc31_ = _loc10_.Camp == 0 ? -100 : 100;
                              _loc14_.x = _loc16_.newPointX ? Number(_loc16_.newPointX) : CONST_BATTLE.AverageX(_loc12_,_loc10_.Camp) + _loc31_;
                              _loc14_.y = _loc16_.newPointY ? Number(_loc16_.newPointY) : CONST_BATTLE.AverageY(_loc12_,_loc10_.Camp);
                           }
                           else if(_loc16_.target == 3)
                           {
                              _loc14_.x += _loc17_;
                              _loc14_.y += _loc18_;
                           }
                           else if(_loc16_.target == 4)
                           {
                              if(_loc11_.Camp == 0)
                              {
                                 _loc14_.x += SBattleConfig.GetPostionByCamyPos(1,6,SBattleConfig.Type_PostionX);
                                 _loc14_.y += SBattleConfig.GetPostionByCamyPos(1,6,SBattleConfig.Type_PostionY);
                              }
                              else
                              {
                                 _loc14_.x += SBattleConfig.GetPostionByCamyPos(0,6,SBattleConfig.Type_PostionX);
                                 _loc14_.y += SBattleConfig.GetPostionByCamyPos(0,6,SBattleConfig.Type_PostionY);
                              }
                           }
                           else if(_loc16_.target != 5)
                           {
                              if(_loc16_.target == 6)
                              {
                                 _loc14_.x = _loc16_.newPointX + _loc17_;
                                 _loc14_.y = _loc16_.newPointY + _loc18_;
                              }
                           }
                        }
                     }
                     if(_loc9_ != null && _loc9_.backPoint != null)
                     {
                        _loc16_ = _loc9_.backPoint[_loc27_];
                        if(_loc16_ != null)
                        {
                           (_loc7_ as TRole).FightMoveBack();
                           _loc9_.backPoint[_loc27_] = null;
                        }
                     }
                  }
               }
               if(_loc9_ != null)
               {
                  if(_loc9_.appendEffect != null)
                  {
                     _loc16_ = _loc9_.appendEffect[_loc27_];
                     if(_loc16_ != null)
                     {
                        if(_loc16_.target == 1)
                        {
                           if(_loc7_ is TRole)
                           {
                              (_loc7_ as TRole).AddEffect(_loc16_,_loc10_,_loc12_,_loc13_,_loc14_.x,_loc14_.y);
                           }
                        }
                        else if(_loc16_.target == 2)
                        {
                           if(_loc12_ != null)
                           {
                              _loc2_ = 0;
                              for(; _loc2_ < _loc12_.length; _loc2_++)
                              {
                                 if(_loc12_[_loc2_] == _loc10_)
                                 {
                                    if(_loc12_[_loc2_].Skilling)
                                    {
                                       if(_loc13_[_loc2_].ResultInfo.HurtAnger > 0)
                                       {
                                          continue;
                                       }
                                    }
                                    else if(_loc13_[_loc2_].ResultInfo.HurtAnger < 0)
                                    {
                                       continue;
                                    }
                                 }
                                 if(Boolean(_loc10_) && CONST_BATTLE.HasEnemy(_loc12_,_loc10_.Camp))
                                 {
                                    if(_loc12_[_loc2_].Camp != _loc10_.Camp)
                                    {
                                       _loc12_[_loc2_].AddEffect(TEffectControl.CopyObject(_loc16_),_loc10_,Vector.<TRole>([_loc12_[_loc2_]]),Vector.<TTargetInfo>([_loc13_[_loc2_]]),_loc14_.x,_loc14_.y);
                                       if(_loc13_[_loc2_].ResultInfo.HurtAnger > 0)
                                       {
                                          _loc12_[_loc2_].AddEffect({
                                             "target":2,
                                             "effectId":CONST_BATTLE.Public_Effect_DecAngle
                                          },_loc10_,Vector.<TRole>([_loc12_[_loc2_]]),Vector.<TTargetInfo>([_loc13_[_loc2_]]),_loc14_.x,_loc14_.y);
                                       }
                                    }
                                    else
                                    {
                                       if(_loc13_[_loc2_].ResultInfo.HurtHp < 0 && _loc13_[_loc2_].HealthGaining < 100)
                                       {
                                          _loc12_[_loc2_].AddEffect({
                                             "target":2,
                                             "effectId":CONST_BATTLE.Public_Effect_AddHp,
                                             "friendhp":{"2":100}
                                          },_loc10_,Vector.<TRole>([_loc12_[_loc2_]]),Vector.<TTargetInfo>([_loc13_[_loc2_]]),_loc14_.x,_loc14_.y);
                                       }
                                       if(_loc13_[_loc2_].ResultInfo.HurtAnger < 0 && _loc13_[_loc2_].AngerGaining < 100)
                                       {
                                          _loc12_[_loc2_].AddEffect({
                                             "target":2,
                                             "effectId":CONST_BATTLE.Public_Effect_AddAngle
                                          },_loc10_,Vector.<TRole>([_loc12_[_loc2_]]),Vector.<TTargetInfo>([_loc13_[_loc2_]]),_loc14_.x,_loc14_.y);
                                          _loc13_[_loc2_].AngerGaining = 100;
                                       }
                                    }
                                 }
                                 else
                                 {
                                    _loc12_[_loc2_].AddEffect(TEffectControl.CopyObject(_loc16_),_loc10_,Vector.<TRole>([_loc12_[_loc2_]]),Vector.<TTargetInfo>([_loc13_[_loc2_]]),_loc14_.x,_loc14_.y);
                                 }
                              }
                           }
                        }
                        else if(_loc16_.target == 3)
                        {
                           TEffectControl.ShowEffect(_loc11_.Parent,_loc16_.effectId,_loc16_,_loc10_,_loc11_,_loc12_,_loc13_,0,0,_loc11_.x,_loc11_.y,null,0,0,0,_loc11_.Camp == 0 ? 1 : -1,_loc11_.Parent.getChildIndex(_loc11_));
                        }
                        else if(_loc16_.target == 4)
                        {
                           if(_loc11_.Camp == 0)
                           {
                              TEffectControl.ShowEffect(_loc11_.BattleStage,_loc16_.effectId,_loc16_,_loc10_,_loc11_,_loc12_,_loc13_,0,0,CONST_COMMON.STAGE_Width,0,_loc21_,0,0,0,-1);
                           }
                           else
                           {
                              TEffectControl.ShowEffect(_loc11_.BattleStage,_loc16_.effectId,_loc16_,_loc10_,_loc11_,_loc12_,_loc13_,0,0,0,0,_loc21_,0,0,0,1);
                           }
                        }
                        else if(_loc16_.target == 5)
                        {
                           if(_loc11_.Camp == 0)
                           {
                              TEffectControl.ShowEffect(_loc11_.BattleStage,_loc16_.effectId,_loc16_,_loc10_,_loc11_,_loc12_,_loc13_,0,0,SBattleConfig.GetPostionByCamyPos(0,6,SBattleConfig.Type_PostionX),SBattleConfig.GetPostionByCamyPos(0,6,SBattleConfig.Type_PostionY),_loc21_);
                           }
                           else
                           {
                              TEffectControl.ShowEffect(_loc11_.BattleStage,_loc16_.effectId,_loc16_,_loc10_,_loc11_,_loc12_,_loc13_,0,0,SBattleConfig.GetPostionByCamyPos(1,6,SBattleConfig.Type_PostionX),SBattleConfig.GetPostionByCamyPos(1,6,SBattleConfig.Type_PostionY),_loc21_);
                           }
                        }
                        else if(_loc16_.target == 8)
                        {
                           _loc11_.BattleStage.ShowWhiteSprite();
                        }
                        else if(_loc16_.target == 11)
                        {
                           if(_loc11_.Camp == 0)
                           {
                              TEffectControl.ShowEffect(_loc11_.BattleStage,_loc16_.effectId,_loc16_,_loc10_,_loc11_,_loc12_,_loc13_,0,0,SBattleConfig.GetPostionByCamyPos(1,6,SBattleConfig.Type_PostionX),SBattleConfig.GetPostionByCamyPos(1,6,SBattleConfig.Type_PostionY),_loc21_,0,0,0,-1);
                           }
                           else
                           {
                              TEffectControl.ShowEffect(_loc11_.BattleStage,_loc16_.effectId,_loc16_,_loc10_,_loc11_,_loc12_,_loc13_,0,0,SBattleConfig.GetPostionByCamyPos(0,6,SBattleConfig.Type_PostionX),SBattleConfig.GetPostionByCamyPos(0,6,SBattleConfig.Type_PostionY),_loc21_,0,0,0,1);
                           }
                        }
                        if(_loc16_.blackwhite != null)
                        {
                           _loc11_.BattleStage.AntiColorBlackWhite(_loc11_,Boolean(_loc16_.blackwhite));
                        }
                        if(_loc16_.ChgBg != null)
                        {
                           _loc11_.BattleStage.ChangeBg(_loc11_,_loc16_.ChgBg);
                        }
                     }
                     _loc9_.appendEffect[_loc27_] = null;
                  }
                  if(_loc9_.red)
                  {
                     if(_loc9_.red[_loc27_] != null)
                     {
                        _loc11_.BattleStage.RedAntiColor(_loc11_,Boolean(_loc9_.red[_loc27_]));
                     }
                  }
                  if(_loc9_.ChgBg)
                  {
                     if(_loc9_.ChgBg[_loc27_] != null)
                     {
                        _loc11_.BattleStage.ChangeBg(_loc11_,_loc9_.ChgBg[_loc27_]);
                     }
                  }
                  if(_loc9_.FullScreenGradient)
                  {
                     if(_loc9_.FullScreenGradient[_loc27_] != null)
                     {
                        _loc11_.BattleStage.FSG(_loc11_,uint(_loc9_.FullScreenGradient[_loc27_].color),_loc9_.FullScreenGradient[_loc27_].time,_loc9_.FullScreenGradient[_loc27_].alpha);
                        _loc9_.FullScreenGradient[_loc27_] = null;
                     }
                  }
                  if(_loc9_.voice)
                  {
                     if(_loc9_.voice[_loc27_] != null)
                     {
                        SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_SOUND,CONST_MUSIC.PLAY_SOUND_EFFECT,_loc9_.voice[_loc27_],true);
                        _loc9_.voice[_loc27_] = null;
                     }
                  }
                  _loc2_ = 0;
                  while(_loc2_ < _loc12_.length)
                  {
                     _loc11_ = _loc12_[_loc2_];
                     _loc33_ = (_loc13_[_loc2_].TargetStatus & CONST_BATTLE.ActiveType_Crit) != 0;
                     _loc11_.CheckTextEffect(_loc13_[_loc2_]);
                     if(Boolean(_loc10_) && _loc10_.Camp == _loc11_.Camp)
                     {
                        if(Boolean(_loc9_.friendhp) && _loc9_.friendhp[_loc27_] != null && _loc13_[_loc2_].HealthGaining < 100)
                        {
                           _loc32_ = _loc13_[_loc2_].ResultInfo.HurtHp * _loc9_.friendhp[_loc27_] / 100;
                           _loc11_.ChangeHP(_loc32_);
                           if(_loc32_ != 0)
                           {
                              _loc13_[_loc2_].HealthGaining += _loc9_.friendhp[_loc27_];
                           }
                           if(_loc21_ != null)
                           {
                              _loc21_(TBattleStage.TYPETEXT_Float,_loc11_.Camp == 0 ? -1 : 1,_loc11_.x,_loc11_.y - _loc11_.RoleHeight,"+" + int(Math.abs(_loc32_)),_loc33_);
                           }
                        }
                        else if(_loc10_.Pos == _loc11_.Pos)
                        {
                           if(Boolean(_loc9_.anmyhp) && _loc9_.anmyhp[_loc27_] != null)
                           {
                              if(_loc13_[_loc2_].TargetStatus & CONST_BATTLE.ActiveType_Hit)
                              {
                                 if(_loc13_[_loc2_].TargetStatus & CONST_BATTLE.ActiveType_Invincible)
                                 {
                                    _loc13_[_loc2_].TargetStatus -= CONST_BATTLE.ActiveType_Invincible;
                                    _loc10_.AddTextEffect(CONST_BATTLE.ActiveType_Invincible);
                                 }
                                 if(_loc13_[_loc2_].TargetStatus & CONST_BATTLE.ActiveType_BeatBack)
                                 {
                                    _loc13_[_loc2_].TargetStatus -= CONST_BATTLE.ActiveType_BeatBack;
                                    _loc10_.AddTextEffect(CONST_BATTLE.ActiveType_BeatBack);
                                    if(_loc13_[_loc2_].TargetStatus & CONST_BATTLE.ActiveType_Died)
                                    {
                                       _loc10_.OnNextCommand(800);
                                    }
                                 }
                              }
                              _loc32_ = ConsecutiveHitDamage(_loc13_[_loc2_].ResultInfo.HurtHp,_loc9_,_loc27_);
                              if(_loc32_ != 0)
                              {
                                 _loc11_.ChangeHP(_loc32_);
                                 if(_loc21_ != null)
                                 {
                                    _loc21_(TBattleStage.TYPETEXT_Float,_loc11_.Camp == 0 ? -1 : 1,_loc11_.x,_loc11_.y - _loc11_.RoleHeight,String(int(_loc32_)),_loc33_,_loc13_[_loc2_].TargetStatus & CONST_BATTLE.ActiveType_Block ? CONST_BATTLE.TEXT_FIGHT_STATUS_Block : 0);
                                 }
                              }
                              if(Boolean(_loc9_.anmyhp.checkDie) && !(_loc13_[_loc2_].TargetStatus & CONST_BATTLE.ActiveType_Block))
                              {
                                 _loc11_.CheckDie();
                              }
                           }
                        }
                     }
                     else if(Boolean(_loc9_.anmyhp) && _loc9_.anmyhp[_loc27_] != null)
                     {
                        if(_loc13_[_loc2_].TargetStatus & CONST_BATTLE.ActiveType_Hit)
                        {
                           if(_loc13_[_loc2_].TargetStatus & CONST_BATTLE.ActiveType_Help)
                           {
                              _loc13_[_loc2_].TargetStatus -= CONST_BATTLE.ActiveType_Help;
                              _loc11_.AddTextEffect(CONST_BATTLE.ActiveType_Help);
                           }
                           if(_loc13_[_loc2_].TargetStatus & CONST_BATTLE.ActiveType_ImmCtrl)
                           {
                              _loc13_[_loc2_].TargetStatus -= CONST_BATTLE.ActiveType_ImmCtrl;
                              _loc11_.AddTextEffect(CONST_BATTLE.ActiveType_ImmCtrl);
                           }
                           if(_loc13_[_loc2_].TargetStatus & CONST_BATTLE.ActiveType_ImmCalm)
                           {
                              _loc13_[_loc2_].TargetStatus -= CONST_BATTLE.ActiveType_ImmCalm;
                              _loc11_.AddTextEffect(CONST_BATTLE.ActiveType_ImmCalm);
                           }
                           if(_loc13_[_loc2_].TargetStatus & CONST_BATTLE.ActiveType_Invincible)
                           {
                              _loc13_[_loc2_].TargetStatus -= CONST_BATTLE.ActiveType_Invincible;
                              _loc11_.AddTextEffect(CONST_BATTLE.ActiveType_Invincible);
                           }
                           _loc32_ = ConsecutiveHitDamage(_loc13_[_loc2_].ResultInfo.HurtHp,_loc9_,_loc27_);
                           if(_loc32_ != 0)
                           {
                              _loc11_.ChangeHP(_loc32_);
                              _loc11_.ActivePlay(TActive.TYPE_ACTIVE_ATTACKED,0,null,Vector.<TTargetInfo>([_loc13_[_loc2_]]));
                              if(_loc13_[_loc2_].TargetStatus & CONST_BATTLE.ActiveType_Block)
                              {
                                 TEffectControl.ShowPublicEffect(_loc11_,CONST_BATTLE.Public_Effect_Smoke,0,0);
                              }
                              if(_loc21_ != null)
                              {
                                 _loc21_(TBattleStage.TYPETEXT_Float,_loc11_.Camp == 0 ? -1 : 1,_loc11_.x,_loc11_.y - _loc11_.RoleHeight,String(int(_loc32_)),_loc33_,_loc13_[_loc2_].TargetStatus & CONST_BATTLE.ActiveType_Block ? CONST_BATTLE.TEXT_FIGHT_STATUS_Block : 0);
                              }
                           }
                           if(Boolean(_loc9_.anmyhp.checkDie) && !(_loc13_[_loc2_].TargetStatus & CONST_BATTLE.ActiveType_Block))
                           {
                              _loc11_.CheckDie();
                           }
                        }
                        else if(Boolean(_loc13_[_loc2_].TargetStatus & CONST_BATTLE.ActiveType_ImmCtrl) || Boolean(_loc13_[_loc2_].TargetStatus & CONST_BATTLE.ActiveType_ImmCalm))
                        {
                           if(_loc21_ != null)
                           {
                              _loc21_(TBattleStage.TYPETEXT_Float,_loc11_.Camp == 0 ? -1 : 1,_loc11_.x,_loc11_.y - _loc11_.RoleHeight,0,false,CONST_BATTLE.TEXT_FIGHT_STATUS_Lost);
                           }
                        }
                        else if(!(_loc13_[_loc2_].TargetStatus & CONST_BATTLE.ActiveType_Punch))
                        {
                           _loc11_.ActivePlay(TActive.TYPE_ACTIVE_DODGE,0,null,null,null,0,_loc13_[_loc2_].CMD == 0);
                        }
                        if(_loc33_)
                        {
                           if(_loc7_ is TRole)
                           {
                              (_loc7_ as TRole).BattleStage.IsCrit = false;
                              (_loc7_ as TRole).BattleStage.CriticalUI();
                           }
                           else if(_loc7_ is TBattleStage)
                           {
                              (_loc7_ as TBattleStage).IsCrit = false;
                              (_loc7_ as TBattleStage).CriticalUI();
                           }
                        }
                     }
                     _loc2_++;
                  }
                  if(Boolean(_loc9_.anmyhp) && Boolean(_loc9_.anmyhp[_loc27_]))
                  {
                     _loc9_.anmyhp[_loc27_] = null;
                  }
                  if(Boolean(_loc9_.friendhp) && Boolean(_loc9_.friendhp[_loc27_]))
                  {
                     _loc9_.friendhp[_loc27_] = null;
                  }
               }
               if(_loc22_ != 0 || _loc23_ != 0)
               {
                  _loc14_.x = -_loc3_.Pivot.X + _loc19_ + _loc25_;
                  _loc14_.y = -_loc3_.Pivot.Y + _loc20_ + _loc26_;
                  _loc6_[EFFECT_MOVE_X] += _loc22_;
                  _loc6_[EFFECT_MOVE_Y] += _loc23_;
               }
               if((_loc22_ > 0 || _loc23_ > 0) && _loc24_ < _loc15_)
               {
                  FRoleVect.splice(_loc1_,1);
                  TPoolBitmap.SaveBitmap(_loc14_);
                  _loc28_--;
                  _loc1_--;
               }
               else
               {
                  _loc15_ += 1000 / (_loc7_.stage ? _loc7_.stage.frameRate : 33);
                  FRoleVect[_loc1_][EFFECT_TICK] = _loc15_;
                  if(_loc4_ == null)
                  {
                     if(_loc27_ > 30)
                     {
                        FRoleVect.splice(_loc1_,1);
                        TPoolBitmap.SaveBitmap(_loc14_);
                        _loc28_--;
                        _loc1_--;
                     }
                  }
                  else if(_loc3_ == null)
                  {
                     FRoleVect.splice(_loc1_,1);
                     TPoolBitmap.SaveBitmap(_loc14_);
                     _loc28_--;
                     _loc1_--;
                  }
               }
            }
            _loc1_++;
         }
      }
      
      public static function UpdataPublicEffect() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TAnimationFrame = null;
         var _loc3_:BitmapData = null;
         var _loc4_:Vector.<Object> = null;
         var _loc5_:DisplayObjectContainer = null;
         var _loc6_:TAnimationSequence = null;
         var _loc7_:Bitmap = null;
         var _loc8_:Number = Number(NaN);
         var _loc9_:Number = Number(NaN);
         var _loc10_:int = 0;
         var _loc11_:Function = null;
         var _loc12_:int = 0;
         _loc12_ = int(FPublicEffectVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc12_)
         {
            _loc4_ = FPublicEffectVect[_loc1_];
            if(_loc4_ != null)
            {
               _loc5_ = _loc4_[EFFECT_PUBLIC_TARGET] as DisplayObjectContainer;
               _loc6_ = _loc4_[EFFECT_PUBLIC_SEQUENCE] as TAnimationSequence;
               _loc7_ = _loc4_[EFFECT_PUBLIC_BMP] as Bitmap;
               _loc8_ = _loc4_[EFFECT_PUBLIC_POINT_X] as Number;
               _loc9_ = _loc4_[EFFECT_PUBLIC_POINT_Y] as Number;
               _loc10_ = _loc4_[EFFECT_PUBLIC_TICK] as int;
               _loc11_ = _loc4_[EFFECT_PUBLIC_CALLBACK] as Function;
               if(_loc6_ != null)
               {
                  _loc2_ = _loc6_.GetAnimationFrameByTick(_loc10_);
                  if(_loc2_ != null)
                  {
                     _loc3_ = _loc2_.Surface;
                     if(_loc7_.bitmapData != _loc3_)
                     {
                        _loc7_.bitmapData = _loc3_;
                        _loc7_.x = -_loc2_.Pivot.X + _loc8_;
                        _loc7_.y = -_loc2_.Pivot.Y + _loc9_;
                     }
                  }
                  _loc10_ += 1000 / (_loc5_.stage ? _loc5_.stage.frameRate : 33);
                  FPublicEffectVect[_loc1_][EFFECT_PUBLIC_TICK] = _loc10_;
                  if(_loc2_ == null)
                  {
                     FPublicEffectVect.splice(_loc1_,1);
                     TPoolBitmap.SaveBitmap(_loc7_);
                     _loc12_--;
                     _loc1_--;
                     if(_loc11_ != null)
                     {
                        _loc11_();
                     }
                  }
               }
            }
            _loc1_++;
         }
      }
      
      public static function UpdataSpecialChainEffect() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<Object> = null;
         var _loc6_:TAnimationFrame = null;
         var _loc7_:BitmapData = null;
         var _loc8_:Bitmap = null;
         var _loc9_:Vector.<Sprite> = null;
         var _loc10_:TAnimationSequence = null;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:Vector.<TRole> = null;
         var _loc14_:Vector.<TTargetInfo> = null;
         var _loc15_:int = 0;
         var _loc16_:uint = 0;
         var _loc17_:Vector.<uint> = null;
         var _loc18_:Function = null;
         var _loc19_:int = 0;
         var _loc20_:TRole = null;
         var _loc21_:TTargetInfo = null;
         _loc3_ = int(FRoleSpecialChainVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            _loc5_ = FRoleSpecialChainVect[_loc1_];
            if(_loc5_ != null)
            {
               _loc9_ = _loc5_[EFFECT_SPECIALCHAIN_SPRITELIST] as Vector.<Sprite>;
               _loc10_ = _loc5_[EFFECT_SPECIALCHAIN_SEQUENCE] as TAnimationSequence;
               _loc11_ = _loc5_[EFFECT_SPECIALCHAIN_SOUND_ID] as uint;
               _loc12_ = _loc5_[EFFECT_SPECIALCHAIN_ATTACKEFFECT] as uint;
               _loc13_ = _loc5_[EFFECT_SPECIALCHAIN_TARGETS] as Vector.<TRole>;
               _loc14_ = _loc5_[EFFECT_SPECIALCHAIN_RESULTS] as Vector.<TTargetInfo>;
               _loc15_ = _loc5_[EFFECT_SPECIALCHAIN_SHOWINDEX] as int;
               _loc16_ = _loc5_[EFFECT_SPECIALCHAIN_INDEXTICK] as uint;
               _loc17_ = _loc5_[EFFECT_SPECIALCHAIN_TICK] as Vector.<uint>;
               _loc18_ = _loc5_[EFFECT_SPECIALCHAIN_TEXTFUNCTION] as Function;
               _loc16_ += 30;
               if(_loc10_ != null)
               {
                  _loc4_ = int(_loc9_.length);
                  _loc2_ = 0;
                  while(_loc2_ < _loc4_)
                  {
                     _loc6_ = _loc10_.GetAnimationFrameByTick(_loc17_[_loc2_]);
                     if(_loc6_ != null)
                     {
                        _loc7_ = _loc6_.Surface;
                        if(_loc9_[_loc2_].visible)
                        {
                           _loc8_ = _loc9_[_loc2_].getChildAt(0) as Bitmap;
                           if(_loc8_.bitmapData != _loc7_)
                           {
                              _loc8_.bitmapData = _loc7_;
                              _loc8_.x = -_loc6_.Pivot.X;
                              _loc8_.y = -_loc6_.Pivot.Y;
                           }
                           _loc17_[_loc2_] += 30;
                        }
                     }
                     _loc2_++;
                  }
                  FRoleSpecialChainVect[_loc1_][EFFECT_SPECIALCHAIN_TICK] = _loc17_;
               }
               if(_loc16_ > 300)
               {
                  _loc16_ -= 300;
                  if(++_loc15_ >= _loc9_.length)
                  {
                     _loc4_ = int(_loc9_.length);
                     _loc2_ = 0;
                     while(_loc2_ < _loc4_)
                     {
                        _loc9_[_loc2_].visible = false;
                        TPoolBitmap.SaveBitmap(_loc9_[_loc2_].getChildAt(0) as Bitmap);
                        _loc2_++;
                     }
                     _loc9_.length = 0;
                     FRoleSpecialChainVect.splice(_loc1_,1);
                     return;
                  }
                  _loc9_[_loc15_].visible = true;
                  _loc20_ = _loc13_[_loc15_ + 1];
                  _loc21_ = _loc14_[_loc15_];
                  if(_loc14_[_loc15_].TargetStatus & CONST_BATTLE.ActiveType_Hit)
                  {
                     if(_loc21_.TargetStatus & CONST_BATTLE.ActiveType_Help)
                     {
                        _loc21_.TargetStatus -= CONST_BATTLE.ActiveType_Help;
                        _loc20_.AddTextEffect(CONST_BATTLE.ActiveType_Help);
                     }
                     if(_loc21_.TargetStatus & CONST_BATTLE.ActiveType_ImmCtrl)
                     {
                        _loc21_.TargetStatus -= CONST_BATTLE.ActiveType_ImmCtrl;
                        _loc20_.AddTextEffect(CONST_BATTLE.ActiveType_ImmCtrl);
                     }
                     if(_loc21_.TargetStatus & CONST_BATTLE.ActiveType_ImmCalm)
                     {
                        _loc21_.TargetStatus -= CONST_BATTLE.ActiveType_ImmCalm;
                        _loc20_.AddTextEffect(CONST_BATTLE.ActiveType_ImmCalm);
                     }
                     _loc19_ = _loc21_.ResultInfo.HurtHp;
                     if(_loc19_ != 0)
                     {
                        _loc20_.ChangeHP(_loc19_);
                        if(_loc19_ > 0)
                        {
                           _loc20_.ActivePlay(TActive.TYPE_ACTIVE_ATTACKED,0,null,Vector.<TTargetInfo>([_loc21_]));
                           TEffectControl.ShowPublicEffect(_loc20_,_loc12_,0,0);
                           SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_SOUND,CONST_MUSIC.PLAY_SOUND_EFFECT,_loc11_,true);
                        }
                        if(_loc21_.TargetStatus & CONST_BATTLE.ActiveType_Block)
                        {
                           TEffectControl.ShowPublicEffect(_loc20_,CONST_BATTLE.Public_Effect_Smoke,0,0);
                        }
                        if(_loc18_ != null)
                        {
                           _loc18_(TBattleStage.TYPETEXT_Float,_loc20_.Camp == 0 ? -1 : 1,_loc20_.x,_loc20_.y - _loc20_.RoleHeight,String(_loc19_),_loc21_.TargetStatus & CONST_BATTLE.ActiveType_Crit,_loc21_.TargetStatus & CONST_BATTLE.ActiveType_Block ? CONST_BATTLE.TEXT_FIGHT_STATUS_Block : 0);
                        }
                     }
                     if(!(_loc21_.TargetStatus & CONST_BATTLE.ActiveType_Block))
                     {
                        _loc20_.CheckDie();
                     }
                  }
                  else if(Boolean(_loc21_.TargetStatus & CONST_BATTLE.ActiveType_ImmCtrl) || Boolean(_loc21_.TargetStatus & CONST_BATTLE.ActiveType_ImmCalm))
                  {
                     if(_loc18_ != null)
                     {
                        _loc18_(TBattleStage.TYPETEXT_Float,_loc20_.Camp == 0 ? -1 : 1,_loc20_.x,_loc20_.y - _loc20_.RoleHeight,0,false,CONST_BATTLE.TEXT_FIGHT_STATUS_Lost);
                     }
                  }
                  else if(!(_loc21_.TargetStatus & CONST_BATTLE.ActiveType_Punch))
                  {
                     _loc20_.ActivePlay(TActive.TYPE_ACTIVE_DODGE,0,null,null,null,0,_loc21_.CMD == 0);
                  }
               }
               FRoleSpecialChainVect[_loc1_][EFFECT_SPECIALCHAIN_SHOWINDEX] = _loc15_;
               FRoleSpecialChainVect[_loc1_][EFFECT_SPECIALCHAIN_INDEXTICK] = _loc16_;
            }
            _loc1_++;
         }
      }
      
      public static function PlayFlicker(param1:DisplayObject, param2:int) : uint
      {
         var IntervalTimeId:uint = 0;
         var Filcker:Function = null;
         var Display:DisplayObject = param1;
         var TimeStamp:int = param2;
         Filcker = function():void
         {
            Display.visible = !Display.visible;
         };
         IntervalTimeId = uint(setInterval(Filcker,TimeStamp));
         return IntervalTimeId;
      }
      
      public static function PlayShake(param1:DisplayObject, param2:int, param3:Function = null, param4:Boolean = true) : void
      {
         if(param3 == null)
         {
            return;
         }
         var duration:int = 0;
         var margin:int = param2;
         while(margin != 0)
         {
            duration += 100;
            margin = int(-margin / 1.2);
         }
         if(duration == 0)
         {
            param3();
         }
         else
         {
            setTimeout(param3,duration / Math.max(0.1,TBattleHandle.PlaybackRate));
         }
      }
      
      public static function Retreat(param1:TRole, param2:int = 40, param3:int = 20, param4:uint = 1000) : void
      {
         var RetreatBack:Function = null;
         var Target:TRole = param1;
         var MoveX:int = param2;
         var MoveY:int = param3;
         var Delay:uint = param4;
         RetreatBack = function():void
         {
            Target.filters = [];
            TweenUtil.to(Target,0.3 / TBattleHandle.PlaybackRate,{
               "x":Target.IdlePositionX,
               "y":Target.IdlePositionY,
               "delay":Delay
            });
         };
         if(Target.Camp == 0)
         {
            Target.filters = [TUtilityFilter.MissBlurFilter,TUtilityFilter.MissDropShadowFilter_Left];
            TweenUtil.to(Target,0.3 / TBattleHandle.PlaybackRate,{
               "x":Target.IdlePositionX - MoveX,
               "y":Target.IdlePositionY - MoveY,
               "onComplete":RetreatBack
            });
         }
         else
         {
            Target.filters = [TUtilityFilter.MissBlurFilter,TUtilityFilter.MissDropShadowFilter_Right];
            TweenUtil.to(Target,0.3 / TBattleHandle.PlaybackRate,{
               "x":Target.IdlePositionX + MoveX,
               "y":Target.IdlePositionY - MoveY,
               "onComplete":RetreatBack
            });
         }
      }
      
      public static function CopyObject(param1:Object) : Object
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeObject(param1);
         _loc2_.position = 0;
         return _loc2_.readObject();
      }
      
      public static function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:Sprite = null;
         var _loc7_:Bitmap = null;
         var _loc8_:TAnimationSequence = null;
         var _loc9_:Class = null;
         var _loc10_:Vector.<Object> = null;
         _loc2_ = int(FPublicEffectVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc10_ = FPublicEffectVect[_loc1_];
            _loc4_ = int(_loc10_.length);
            _loc3_ = 0;
            for(; _loc3_ < _loc4_; _loc3_++)
            {
               _loc5_ = _loc10_[_loc3_];
               if(_loc5_ == null)
               {
                  continue;
               }
               _loc9_ = TUtilityRTTI.GetClassByInstance(_loc5_);
               switch(_loc9_)
               {
                  case Sprite:
                     _loc6_ = _loc5_ as Sprite;
                     if(_loc6_.mouseChildren > 0)
                     {
                        _loc6_.removeChildren();
                     }
                     _loc6_ = null;
                     break;
                  case Bitmap:
                     _loc7_ = _loc5_ as Bitmap;
                     if(_loc7_.parent != null)
                     {
                        _loc7_.parent.removeChild(_loc7_);
                     }
                     _loc7_.bitmapData = null;
                     TPoolBitmap.SaveBitmap(_loc7_);
                     _loc7_ = null;
                     break;
                  case TAnimationSequence:
                     _loc8_ = _loc5_ as TAnimationSequence;
                     _loc8_ = null;
                     break;
                  default:
                     _loc5_ = 0;
               }
            }
            _loc10_.length = 0;
            _loc1_++;
         }
         FPublicEffectVect.length = 0;
      }
      
      public static function ConsecutiveHitDamage(total:Number, config:Object, frame:int) : Number
      {
         if(config.hitCount == null || config.hitIndex == null)
         {
            return total * config.anmyhp[frame] / 100;
         }
         var count:int = int(config.hitCount);
         var index:int = int(config.hitIndex);
         if(count != 4 && count != 5 || index < 0 || index >= count)
         {
            return total * config.anmyhp[frame] / 100;
         }
         return Math.floor(total * (index + 1) / count) - Math.floor(total * index / count);
      }
   }
}

