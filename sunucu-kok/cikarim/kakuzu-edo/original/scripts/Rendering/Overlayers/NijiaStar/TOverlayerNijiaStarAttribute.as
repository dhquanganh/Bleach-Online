package Rendering.Overlayers.NijiaStar
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Characters.*;
   import Logics.NijiaStar.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Overlayers.*;
   import Rendering.Texts.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TOverlayerNijiaStarAttribute extends TOverlayer
   {
      
      protected static const SIZE_DividingLineOffset:uint = 3;
      
      protected static const CAPACITY_AppendAttributes:uint = 6;
      
      protected static const CAPACITY_ActivatedPoints:uint = 7;
      
      protected static const SIZE_Image_Width:uint = 50;
      
      protected static const SIZE_Image_Height:uint = 50;
      
      protected static const SIZE_DefaultIcon_Width:uint = 40;
      
      protected static const SIZE_DefaultIcon_Height:uint = 40;
      
      protected static const SIZE_Padding_01:uint = 3;
      
      protected static const SIZE_Padding_02:uint = 5;
      
      protected static const SIZE_Padding_03:uint = 15;
      
      protected static const COLOR_Context_White:uint = 4294967295;
      
      protected static const COLOR_Context_Invalid:uint = 4286611584;
      
      protected static const COLOR_Context_03:uint = 4294890346;
      
      protected static const COLOR_Context_Green:uint = 4284940032;
      
      protected static const SIZE_DividingLine_Max_Width:uint = 250;
      
      protected static const SIZE_DividingLine_Min_Width:uint = 240;
      
      protected var FQuerySequenceTimer:Timer;
      
      protected var FUpdateFrameTimer:Timer;
      
      protected var FHeroIcon:TUIImage;
      
      protected var FHeroDefaultIcon:TUIImage;
      
      protected var FSequenceDefaultIcon:TAnimationSequence;
      
      protected var FPainterHeroName:TPainterTextEffect;
      
      protected var FPainterHeroLevel:TPainterTextEffect;
      
      protected var FPainterActivated:TPainterTextEffect;
      
      protected var FPainterActivatedPoints:Vector.<TPainterTextEffect>;
      
      protected var FPainterAddtionalAttributes:TPainterTextEffect;
      
      protected var FPainterAppendAttributes:Vector.<TPainterTextEffect>;
      
      protected var FBoundsHeroName:TBounds;
      
      protected var FBoundsHeroLevel:TBounds;
      
      protected var FBoundsImage:TBounds;
      
      protected var FBoundsActivated:TBounds;
      
      protected var FBoundsActivatedPoints:Vector.<TBounds>;
      
      protected var FBoundsAddtionalAttributes:TBounds;
      
      protected var FBoundsAppendAttributes:Vector.<TBounds>;
      
      protected var FDividingLinePartCaption:Bitmap;
      
      protected var FBoundsPartCaption:TBounds;
      
      protected var FTextFormatHeroName:TextFormat;
      
      protected var FTextFormatHeroLevel:TextFormat;
      
      protected var FBoundsOffset:TBounds;
      
      public function TOverlayerNijiaStarAttribute(param1:TUIComponent)
      {
         var _loc2_:int = 0;
         var _loc3_:TBounds = null;
         var _loc4_:TPainterTextEffect = null;
         super(param1);
         this.FHeroIcon = new TUIImage(this);
         this.FHeroIcon.mouseEnabled = false;
         this.FBoundsImage = new TBounds();
         this.FPainterHeroName = ConstructPainterTextEffect(COLOR_Context_03);
         this.FBoundsHeroName = new TBounds();
         this.FPainterHeroLevel = ConstructPainterTextEffect(COLOR_Context_03);
         this.FBoundsHeroLevel = new TBounds();
         this.FPainterActivated = ConstructPainterTextEffect(COLOR_Context_White);
         this.FBoundsActivated = new TBounds();
         this.FPainterActivatedPoints = new Vector.<TPainterTextEffect>(CAPACITY_ActivatedPoints);
         this.FBoundsActivatedPoints = new Vector.<TBounds>(CAPACITY_ActivatedPoints);
         _loc2_ = 0;
         while(_loc2_ < CAPACITY_ActivatedPoints)
         {
            _loc4_ = ConstructPainterTextEffect(COLOR_Context_Green);
            this.FPainterActivatedPoints[_loc2_] = _loc4_;
            _loc3_ = new TBounds();
            this.FBoundsActivatedPoints[_loc2_] = _loc3_;
            _loc2_++;
         }
         this.FPainterAddtionalAttributes = ConstructPainterTextEffect(COLOR_Context_White);
         this.FBoundsAddtionalAttributes = new TBounds();
         this.FPainterAppendAttributes = new Vector.<TPainterTextEffect>(CAPACITY_AppendAttributes);
         this.FBoundsAppendAttributes = new Vector.<TBounds>(CAPACITY_AppendAttributes);
         _loc2_ = 0;
         while(_loc2_ < CAPACITY_AppendAttributes)
         {
            _loc4_ = ConstructPainterTextEffect(COLOR_Context_Green);
            this.FPainterAppendAttributes[_loc2_] = _loc4_;
            _loc3_ = new TBounds();
            this.FBoundsAppendAttributes[_loc2_] = _loc3_;
            _loc2_++;
         }
         this.FDividingLinePartCaption = new Bitmap();
         addChild(this.FDividingLinePartCaption);
         this.FBoundsPartCaption = new TBounds();
         this.FTextFormatHeroName = new TextFormat();
         this.FTextFormatHeroLevel = new TextFormat();
         this.FQuerySequenceTimer = new Timer(500,1);
         this.FQuerySequenceTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.TimeQuerySequence);
         this.FUpdateFrameTimer = new Timer(50);
         this.FUpdateFrameTimer.addEventListener(TimerEvent.TIMER,this.TimeUpdateFrame);
         FMarginLeft = 15;
         FMarginTop = 15;
         FMarginRight = 1;
         FMarginBottom = 15;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FSequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FHeroDefaultIcon = new TUIImage(this);
         this.FHeroDefaultIcon.mouseEnabled = false;
         this.FHeroDefaultIcon.Sequence = this.FSequenceDefaultIcon;
         this.FHeroDefaultIcon.Visible = false;
         this.FDividingLinePartCaption.bitmapData = FDividingLine;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THero = null;
         this.FDividingLinePartCaption.width = SIZE_DividingLine_Min_Width;
      }
      
      override protected function ContextModified() : Boolean
      {
         return true;
      }
      
      override protected function EvaluationPerform_Icon() : void
      {
         var _loc1_:THero = null;
         var _loc2_:TAnimationSequence = null;
         this.FHeroIcon.Sequence = null;
         _loc1_ = FContext as THero;
         _loc2_ = SResourcesCore.TexturesHeadIcon.GetAnimationSequenceByIdentifiers(_loc1_.SmallID,0);
         if(_loc2_ != null)
         {
            this.FHeroIcon.Sequence = _loc2_;
            if(this.FUpdateFrameTimer.running)
            {
               this.FUpdateFrameTimer.stop();
            }
         }
         else
         {
            this.FHeroIcon.Sequence = null;
            if(!this.FQuerySequenceTimer.running)
            {
               this.FQuerySequenceTimer.start();
            }
            if(!this.FUpdateFrameTimer.running)
            {
               this.FUpdateFrameTimer.start();
            }
         }
         this.FBoundsImage.Width = SIZE_Image_Width;
         this.FBoundsImage.Height = SIZE_Image_Height;
         BoundsAlignRight(this.FBoundsImage,null,SIZE_Padding_01);
         BoundsContextUnion(this.FBoundsImage);
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THero = null;
         var _loc4_:TPainterTextEffect = null;
         _loc3_ = FContext as THero;
         this.EvaluationPerform_HeroName(_loc3_);
         this.FBoundsOffset = this.FBoundsHeroName;
         this.EvaluationPerform_HeroLevel(_loc3_);
         this.FBoundsOffset = this.FBoundsHeroLevel;
         this.EvaluationPerform_PartCaption(_loc3_);
         this.FBoundsOffset = this.FBoundsPartCaption;
         this.EvaluationPerform_Activated(_loc3_);
         this.FBoundsOffset = this.FBoundsActivated;
         this.EvaluationPerform_ActivatedPoints(_loc3_);
         this.EvaluationPerform_AddtionalAttributes(_loc3_);
         this.FBoundsOffset = this.FBoundsAddtionalAttributes;
         this.EvaluationPerform_AppendAttributes(_loc3_);
      }
      
      protected function EvaluationPerform_HeroName(param1:THero) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         BoundsAlignRight(this.FBoundsHeroName);
         _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NIJIASTAR_STRING_07);
         _loc3_ = 0;
         _loc4_ = _loc2_.length - 2;
         this.FPainterHeroName.Text = TUtilityString.Format(_loc2_,param1.Name);
         this.FTextFormatHeroName.color = COLOR_Context_White;
         this.FBoundsHeroName.X += 10;
         this.FBoundsHeroName.Y += 10;
         this.FPainterHeroName.Evaluate(this.FBoundsHeroName);
         this.FPainterHeroName.SetTextFormat(this.FTextFormatHeroName,_loc3_,_loc4_);
         BoundsContextUnion(this.FBoundsHeroName);
      }
      
      protected function EvaluationPerform_HeroLevel(param1:THero) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         BoundsAlignDown(this.FBoundsHeroLevel,this.FBoundsOffset);
         _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NIJIASTAR_STRING_08);
         _loc3_ = 0;
         _loc4_ = _loc2_.length - 2;
         this.FPainterHeroLevel.Text = TUtilityString.Format(_loc2_,param1.RebirthLevel);
         this.FTextFormatHeroLevel.color = COLOR_Context_White;
         this.FBoundsHeroLevel.X += 10;
         this.FBoundsHeroLevel.Y += 10;
         this.FPainterHeroLevel.Evaluate(this.FBoundsHeroLevel);
         this.FPainterHeroLevel.SetTextFormat(this.FTextFormatHeroLevel,_loc3_,_loc4_);
         BoundsContextUnion(this.FBoundsHeroLevel);
      }
      
      protected function EvaluationPerform_PartCaption(param1:THero) : void
      {
         this.FBoundsPartCaption.Width = this.FDividingLinePartCaption.width;
         this.FBoundsPartCaption.Height = this.FDividingLinePartCaption.height;
         BoundsAlignDown(this.FBoundsPartCaption);
         this.FBoundsPartCaption.X = 0;
         this.FBoundsPartCaption.Y += 10;
         BoundsContextUnion(this.FBoundsPartCaption);
      }
      
      protected function EvaluationPerform_Activated(param1:THero) : void
      {
         BoundsAlignDown(this.FBoundsActivated);
         this.FPainterActivated.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NIJIASTAR_STRING_09);
         this.FPainterActivated.Evaluate(this.FBoundsActivated);
         this.FBoundsActivated.Y += 10;
         BoundsContextUnion(this.FBoundsActivated);
      }
      
      protected function EvaluationPerform_ActivatedPoints(param1:THero) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TBounds = null;
         var _loc5_:TPainterTextEffect = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:String = null;
         var _loc9_:TNijiaStar = null;
         var _loc10_:TNijiaStars = null;
         var _loc11_:int = 0;
         var _loc12_:uint = 0;
         var _loc13_:TNijiaStarAtom = null;
         var _loc14_:String = null;
         _loc10_ = param1.NijiaStars;
         _loc3_ = int(CAPACITY_ActivatedPoints);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FBoundsActivatedPoints[_loc2_];
            BoundsAlignDown(_loc4_,this.FBoundsOffset);
            this.FBoundsOffset = _loc4_;
            _loc5_ = this.FPainterActivatedPoints[_loc2_];
            _loc9_ = _loc10_.GetNijiaStarByIndex(_loc2_);
            _loc8_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRINGS_NIJIASTAR)[_loc2_];
            _loc12_ = _loc9_.Count;
            _loc14_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NIJIASTAR_STRING_06);
            _loc6_ = 0;
            _loc11_ = 0;
            while(_loc11_ < _loc12_)
            {
               _loc13_ = _loc9_.GetNijiaStarAtomByIndex(_loc11_);
               if(_loc9_.Identifier >= _loc13_.Identifier)
               {
                  _loc6_++;
                  if(_loc13_.IsLast)
                  {
                     _loc14_ += TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NIJIASTAR_STRING_11);
                  }
               }
               _loc11_++;
            }
            _loc5_.Text = TUtilityString.Format(_loc14_,_loc8_,_loc6_,CAPACITY_AppendAttributes);
            _loc5_.Evaluate(_loc4_);
            BoundsContextUnion(_loc4_);
            _loc2_++;
         }
      }
      
      protected function EvaluationPerform_AddtionalAttributes(param1:THero) : void
      {
         BoundsAlignDown(this.FBoundsAddtionalAttributes);
         this.FPainterAddtionalAttributes.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NIJIASTAR_STRING_10);
         this.FPainterAddtionalAttributes.Evaluate(this.FBoundsAddtionalAttributes);
         this.FBoundsAddtionalAttributes.Y += 10;
         BoundsContextUnion(this.FBoundsAddtionalAttributes);
      }
      
      protected function EvaluationPerform_AppendAttributes(param1:THero) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TBounds = null;
         var _loc5_:TPainterTextEffect = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:TNijiaStar = null;
         var _loc9_:TNijiaStars = null;
         var _loc10_:int = 0;
         var _loc11_:uint = 0;
         var _loc12_:int = 0;
         var _loc13_:uint = 0;
         var _loc14_:int = 0;
         var _loc15_:uint = 0;
         var _loc16_:TNijiaStarAtom = null;
         var _loc17_:Vector.<uint> = null;
         _loc17_ = new Vector.<uint>(CAPACITY_AppendAttributes);
         _loc9_ = param1.NijiaStars;
         _loc11_ = uint(_loc9_.Count);
         _loc10_ = 0;
         while(_loc10_ < _loc11_)
         {
            _loc8_ = _loc9_.GetNijiaStarByIndex(_loc10_);
            _loc13_ = _loc8_.Count;
            _loc12_ = 0;
            while(_loc12_ < _loc13_)
            {
               _loc16_ = _loc8_.GetNijiaStarAtomByIndex(_loc12_);
               if(_loc8_.Identifier >= _loc16_.Identifier)
               {
                  _loc15_ = _loc16_.AddValues.length;
                  _loc14_ = 0;
                  while(_loc14_ < _loc15_)
                  {
                     _loc17_[_loc14_] += _loc16_.AddValues[_loc14_];
                     if(_loc16_.IsLast)
                     {
                        _loc17_[_loc14_] += _loc8_.ExtraAddValues[_loc14_];
                     }
                     _loc14_++;
                  }
               }
               _loc12_++;
            }
            _loc10_++;
         }
         _loc3_ = int(CAPACITY_AppendAttributes);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FBoundsAppendAttributes[_loc2_];
            BoundsAlignDown(_loc4_,this.FBoundsOffset);
            this.FBoundsOffset = _loc4_;
            _loc5_ = this.FPainterAppendAttributes[_loc2_];
            _loc7_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRINGS_ATTRIBUTENIJIASTAR)[_loc2_];
            _loc6_ = _loc17_[_loc2_].toString();
            _loc5_.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NIJIASTAR_STRING_12),_loc7_,_loc6_);
            _loc5_.Evaluate(_loc4_);
            BoundsContextUnion(_loc4_);
            _loc2_++;
         }
      }
      
      override protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TBounds = null;
         var _loc5_:TPainterTextEffect = null;
         var _loc6_:THero = null;
         _loc6_ = FContext as THero;
         FBoundsRendering.X = FMarginLeft;
         FBoundsRendering.Y = FMarginTop;
         this.FHeroIcon.X = FBoundsRendering.X + this.FBoundsImage.X;
         this.FHeroIcon.Y = FBoundsRendering.Y + this.FBoundsImage.Y;
         if(this.FHeroDefaultIcon.Visible)
         {
            this.FHeroDefaultIcon.x = this.FHeroIcon.X + (SIZE_Image_Width - SIZE_DefaultIcon_Width) / 2;
            this.FHeroDefaultIcon.y = this.FHeroIcon.Y + (SIZE_Image_Height - SIZE_DefaultIcon_Height) / 2;
         }
         this.FPainterHeroName.X = FBoundsRendering.X + this.FBoundsHeroName.X;
         this.FPainterHeroName.Y = FBoundsRendering.Y + this.FBoundsHeroName.Y;
         this.FPainterHeroLevel.X = FBoundsRendering.X + this.FBoundsHeroLevel.X;
         this.FPainterHeroLevel.Y = FBoundsRendering.Y + this.FBoundsHeroLevel.Y;
         this.FDividingLinePartCaption.x = FBoundsRendering.X + this.FBoundsPartCaption.X - FMarginLeft + SIZE_DividingLineOffset;
         this.FDividingLinePartCaption.y = FBoundsRendering.Y + this.FBoundsPartCaption.Y;
         this.FPainterActivated.x = FBoundsRendering.X + this.FBoundsActivated.X;
         this.FPainterActivated.y = FBoundsRendering.Y + this.FBoundsActivated.Y;
         _loc3_ = int(CAPACITY_ActivatedPoints);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FPainterActivatedPoints[_loc2_];
            _loc4_ = this.FBoundsActivatedPoints[_loc2_];
            _loc5_.X = FBoundsRendering.X + _loc4_.X;
            _loc5_.Y = FBoundsRendering.Y + _loc4_.Y;
            _loc2_++;
         }
         _loc3_ = int(CAPACITY_AppendAttributes);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FPainterAppendAttributes[_loc2_];
            _loc4_ = this.FBoundsAppendAttributes[_loc2_];
            _loc5_.X = FBoundsRendering.X + _loc4_.X;
            _loc5_.Y = FBoundsRendering.Y + _loc4_.Y;
            _loc2_++;
         }
         this.FPainterAddtionalAttributes.x = FBoundsRendering.X + this.FBoundsAddtionalAttributes.X;
         this.FPainterAddtionalAttributes.y = FBoundsRendering.Y + this.FBoundsAddtionalAttributes.Y;
         this.FDividingLinePartCaption.width = SIZE_DividingLine_Max_Width;
      }
      
      protected function TimeQuerySequence(param1:TimerEvent) : void
      {
         var _loc2_:THero = null;
         var _loc3_:TResourceRepositoryTexture = null;
         var _loc4_:TTexture = null;
         _loc2_ = FContext as THero;
         _loc3_ = SResourcesCore.TexturesHeadIcon;
         _loc4_ = _loc3_.GetTextureByIdentifier(_loc2_.SmallID);
         if(_loc4_ != null)
         {
            this.FHeroIcon.Sequence = _loc4_.GetAnimationSequenceByIdentifier(0);
            this.FQuerySequenceTimer.reset();
            this.FQuerySequenceTimer.stop();
            this.FHeroDefaultIcon.Visible = false;
         }
         else
         {
            _loc3_.LoadSecondary(_loc2_.SmallID);
            this.FQuerySequenceTimer.reset();
            if(!this.FQuerySequenceTimer.running)
            {
               this.FQuerySequenceTimer.start();
            }
            this.FHeroDefaultIcon.Visible = true;
         }
      }
      
      protected function TimeUpdateFrame(param1:TimerEvent) : void
      {
         this.FHeroDefaultIcon.RenderingPerformByTick(STimingCore.TickCount);
      }
      
      override public function Show() : void
      {
         if(FContext == null)
         {
            return;
         }
         super.Show();
      }
   }
}

