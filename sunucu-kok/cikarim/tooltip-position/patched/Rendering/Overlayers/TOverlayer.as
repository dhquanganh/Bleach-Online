package Rendering.Overlayers
{
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Display.TZoom9Grid;
   import Foundation.Fonts.SFontCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityCartisian;
   import Rendering.Texts.TPainterHtmlTextEffect;
   import Rendering.Texts.TPainterText;
   import Rendering.Texts.TPainterTextEffect;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_OVERLAYER;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import ghostcat.operation.RepeatOper;
   import ghostcat.operation.TweenOper;
   import ghostcat.util.easing.Cubic;
   import ghostcat.util.easing.TweenEvent;
   
   public class TOverlayer extends TUIComponent
   {
      
      public static var STAGE_Width:Number = CONST_COMMON.STAGE_Width;
      
      public static var STAGE_Height:Number = CONST_COMMON.STAGE_Height;
      
      protected static const COLOR_ContextDefault:uint = 4294958161;
      
      protected static const SIZE_WordWrapWidthDefault:uint = 256;
      
      protected static const SIZE_MinWidth:uint = 60;
      
      protected static const SIZE_OutlineSize:uint = 2;
      
      protected var FRepeatOper:RepeatOper;
      
      protected var FTweenOperIn:TweenOper;
      
      protected var FTweenOperOut:TweenOper;
      
      protected var FZoom9Grid:TZoom9Grid;
      
      protected var FCoordinateOverlay:TCoordinate;
      
      protected var FBoundsRendering:TBounds;
      
      protected var FBoundsSubstrate:TBounds;
      
      protected var FBoundsContext:TBounds;
      
      protected var FWordWrapWidth:int;
      
      protected var FModified:Boolean;
      
      protected var FModifiedContext:Boolean;
      
      protected var FContext:Object;
      
      protected var FAnimationSubstrate:BitmapData;
      
      protected var FOvarlaySubstrate:Bitmap;
      
      protected var FAlphaSubstrate:Number;
      
      protected var FDividingLine:BitmapData;
      
      protected var FOverLayerVisible:Boolean;
      
      protected var FMarginLeft:int;
      
      protected var FMarginTop:int;
      
      protected var FMarginRight:int;
      
      protected var FMarginBottom:int;
      
      public function TOverlayer(param1:TUIComponent)
      {
         super(param1);
         this.ConstructTweens();
         this.FAnimationSubstrate = new BitmapData(1,1);
         this.FZoom9Grid = new TZoom9Grid(this.FAnimationSubstrate.clone());
         this.FZoom9Grid.GridRect = new Rectangle(CONST_COMMON.COORDINATE_ZOOM9GRID_X,CONST_COMMON.COORDINATE_ZOOM9GRID_Y,CONST_COMMON.SIZE_ZOOM9GRID_WIDTH,CONST_COMMON.SIZE_ZOOM9GRID_HEIGHT);
         this.FAlphaSubstrate = 1;
         this.FOvarlaySubstrate = new Bitmap();
         this.FOvarlaySubstrate.alpha = this.FAlphaSubstrate;
         addChild(this.FOvarlaySubstrate);
         this.FCoordinateOverlay = new TCoordinate();
         this.FBoundsRendering = new TBounds();
         this.FBoundsSubstrate = new TBounds();
         this.FBoundsContext = new TBounds();
         this.FWordWrapWidth = SIZE_WordWrapWidthDefault;
         this.FMarginLeft = 14;
         this.FMarginTop = 8;
         this.FMarginRight = 14;
         this.FMarginBottom = 10;
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      protected function ConstructTweens() : void
      {
         this.FRepeatOper = new RepeatOper();
         this.FTweenOperIn = new TweenOper();
         this.FTweenOperOut = new TweenOper();
         this.FTweenOperIn.duration = 100;
         this.FTweenOperIn.target = this;
         this.FTweenOperOut.duration = 100;
         this.FTweenOperOut.target = this;
         this.FRepeatOper.loop = 1;
         this.FRepeatOper.children = [this.FTweenOperIn,this.FTweenOperOut];
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
      }
      
      protected function ConstructPainterText(param1:uint = 4294958161) : TPainterText
      {
         var _loc2_:TPainterText = null;
         _loc2_ = new TPainterText(this);
         _loc2_.Font.Name = "Arial";
         _loc2_.Font.Color = param1;
         _loc2_.Font.Size = 12;
         _loc2_.WordWrap = true;
         _loc2_.WordWrapWidth = this.FWordWrapWidth;
         return _loc2_;
      }
      
      protected function ConstructPainterTextEffect(param1:uint = 4294958161) : TPainterTextEffect
      {
         var _loc2_:TPainterTextEffect = null;
         _loc2_ = new TPainterTextEffect(this);
         SFontCore.FontSelect(_loc2_.Font,CONST_OVERLAYER.TEXT_ANTIALIAS_FontSetName,CONST_OVERLAYER.TEXT_ANTIALIAS_FontSetSize,CONST_OVERLAYER.TEXT_ANTIALIAS_FontSetBold);
         _loc2_.Font.Color = param1;
         _loc2_.FontEffect.AntiAliased = true;
         _loc2_.FontEffect.Outlined = true;
         _loc2_.FontEffect.Shadowed = true;
         _loc2_.WordWrap = true;
         _loc2_.WordWrapWidth = this.FWordWrapWidth;
         if(false)
         {
            _loc2_.Font.Name = "Arial";
         }
         return _loc2_;
      }
      
      protected function ConstructPainterHtmlTextEffect(param1:uint = 4294958161) : TPainterHtmlTextEffect
      {
         var _loc2_:TPainterHtmlTextEffect = null;
         _loc2_ = new TPainterHtmlTextEffect(this);
         SFontCore.FontSelect(_loc2_.Font,CONST_OVERLAYER.TEXT_ANTIALIAS_FontSetName,CONST_OVERLAYER.TEXT_ANTIALIAS_FontSetSize,CONST_OVERLAYER.TEXT_ANTIALIAS_FontSetBold);
         _loc2_.Font.Color = param1;
         _loc2_.FontEffect.AntiAliased = true;
         _loc2_.FontEffect.Outlined = true;
         _loc2_.FontEffect.Shadowed = true;
         _loc2_.WordWrapWidth = this.FWordWrapWidth;
         return _loc2_;
      }
      
      protected function BoundsContextUnion(param1:TBounds) : void
      {
         TUtilityCartisian.BoundsUnion(this.FBoundsContext,this.FBoundsContext,param1);
      }
      
      protected function BoundsAlignDown(param1:TBounds, param2:TBounds = null, param3:int = 0) : void
      {
         if(param2 == null)
         {
            param2 = this.FBoundsContext;
         }
         TUtilityCartisian.CoordinateSet(param1,param2.X,param2.YEnd + param3);
      }
      
      protected function BoundsAlignRight(param1:TBounds, param2:TBounds = null, param3:int = 0) : void
      {
         if(param2 == null)
         {
            param2 = this.FBoundsContext;
         }
         TUtilityCartisian.CoordinateSet(param1,param2.XEnd + param3,param2.Y);
      }
      
      protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 != null;
      }
      
      protected function ContextModified() : Boolean
      {
         return false;
      }
      
      protected function ContextSynchronize() : void
      {
      }
      
      protected function UpdatingPeform(param1:TCoordinate) : void
      {
         if(this.FModified || this.ContextModified())
         {
            this.ContextSynchronize();
            this.EvaluationPerform(param1);
            this.SketchingPerform();
            this.FModified = false;
         }
      }
      
      protected function EvaluationPerform(param1:TCoordinate) : void
      {
         this.EvaluationPerform_Initialize();
         this.EvaluationPerform_Icon();
         this.EvaluationPerform_Context();
         this.EvaluationPerform_Substrate();
      }
      
      protected function EvaluationPerform_Initialize() : void
      {
         this.FBoundsContext.Reset();
      }
      
      protected function EvaluationPerform_Icon() : void
      {
      }
      
      protected function EvaluationPerform_Context() : void
      {
      }
      
      protected function EvaluationPerform_Substrate() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = this.FBoundsContext.Width + this.FMarginLeft + this.FMarginRight;
         _loc2_ = this.FBoundsContext.Height + this.FMarginTop + this.FMarginBottom;
         if(_loc1_ < SIZE_MinWidth)
         {
            _loc1_ = int(SIZE_MinWidth);
         }
         TUtilityCartisian.BoundsSetSize(this.FBoundsSubstrate,_loc1_,_loc2_);
      }
      
      protected function SketchingPerform() : void
      {
         this.SketchingPerform_Sketch();
         this.SketchingPerform_Context();
      }
      
      protected function SketchingPerform_Sketch() : void
      {
      }
      
      protected function SketchingPerform_Context() : void
      {
      }
      
      protected function RenderingPerform(param1:TCoordinate) : void
      {
         this.RenderingPerform_Position(param1);
         this.RenderingPerform_Substrate(param1);
         this.RenderingPerform_Context(param1);
      }
      
      protected function RenderingPerform_Position(param1:TCoordinate) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc4_ = this.FBoundsSubstrate.Width;
         _loc5_ = this.FBoundsSubstrate.Height;
         // Prefer the right side and clamp long descriptions inside the stage.
         _loc2_ = Math.max(8,Math.min(param1.X + 20,STAGE_Width - _loc4_ - 8));
         _loc3_ = Math.max(8,Math.min(param1.Y,STAGE_Height - _loc5_ - 8));
         TUtilityCartisian.CoordinateSet(this.FCoordinateOverlay,_loc2_,_loc3_);
      }
      
      protected function RenderingPerform_Substrate(param1:TCoordinate) : void
      {
         if(this.FOvarlaySubstrate != null)
         {
            TUtilityCartisian.BoundsSet(this.FBoundsRendering,this.FCoordinateOverlay.X,this.FCoordinateOverlay.Y,this.FBoundsSubstrate.Width,this.FBoundsSubstrate.Height);
            this.FZoom9Grid.Width = this.FBoundsRendering.Width;
            this.FZoom9Grid.Height = this.FBoundsRendering.Height;
            if(this.FOvarlaySubstrate.bitmapData != this.FZoom9Grid.ImageData)
            {
               if(this.FOvarlaySubstrate.bitmapData != null)
               {
                  this.FOvarlaySubstrate.bitmapData.dispose();
               }
               this.FOvarlaySubstrate.bitmapData = this.FZoom9Grid.ImageData;
            }
            this.X = this.FCoordinateOverlay.X;
            this.Y = this.FCoordinateOverlay.Y;
            BoundsClientSet(this.X,this.Y,this.FOvarlaySubstrate.width,this.FOvarlaySubstrate.height);
         }
      }
      
      protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         TUtilityCartisian.CoordinateSet(this.FBoundsRendering,this.FCoordinateOverlay.X + this.FMarginLeft,this.FCoordinateOverlay.Y + this.FMarginTop);
      }
      
      protected function Reset() : void
      {
      }
      
      protected function PerformTweenOperOnStart(param1:TweenEvent) : void
      {
         if(!this.Visible)
         {
            this.Visible = true;
         }
      }
      
      protected function PerformTweenOperOnComplete(param1:TweenEvent) : void
      {
         if(this.Visible)
         {
            this.Reset();
            this.Visible = false;
         }
      }
      
      public function get Context() : Object
      {
         return this.FContext;
      }
      
      public function set Context(param1:Object) : void
      {
         if(param1 != null)
         {
            if(!this.ContextVerificate(param1))
            {
               param1 = null;
            }
         }
         if(param1 != this.FContext)
         {
            this.FContext = param1;
            this.FModified = true;
         }
      }
      
      public function get AnimationSubstrate() : BitmapData
      {
         return this.FAnimationSubstrate;
      }
      
      public function set AnimationSubstrate(param1:BitmapData) : void
      {
         if(param1 != this.FAnimationSubstrate)
         {
            if(this.FAnimationSubstrate != null)
            {
               this.FAnimationSubstrate.dispose();
            }
            this.FAnimationSubstrate = param1;
            this.FZoom9Grid.Source = this.FAnimationSubstrate.clone();
            this.FModified = true;
         }
      }
      
      public function get DividingLine() : BitmapData
      {
         return this.FDividingLine;
      }
      
      public function set DividingLine(param1:BitmapData) : void
      {
         this.FDividingLine = param1;
      }
      
      public function get OverLayerVisible() : Boolean
      {
         return this.FOverLayerVisible;
      }
      
      public function set OverLayerVisible(param1:Boolean) : void
      {
         this.FOverLayerVisible = param1;
      }
      
      public function get CoordinateOverlay() : TCoordinate
      {
         return this.FCoordinateOverlay;
      }
      
      public function get BoundsSubstrate() : TBounds
      {
         return this.FBoundsSubstrate;
      }
      
      public function ResourcesUpdate() : void
      {
         this.ResourcesPerform_UIDispatch();
      }
      
      public function Render(param1:TCoordinate) : void
      {
         if(this.FContext == null)
         {
            return;
         }
         this.UpdatingPeform(param1);
         this.RenderingPerform(param1);
      }
      
      public function Show() : void
      {
         this.FTweenOperIn.params = {
            "alpha":this.alpha,
            "ease":Cubic.easeIn,
            "onStartHandler":this.PerformTweenOperOnStart
         };
         this.FTweenOperOut.params = {
            "alpha":1,
            "ease":Cubic.easeOut
         };
         this.FRepeatOper.execute();
      }
      
      public function Hide() : void
      {
         this.FTweenOperIn.params = {
            "alpha":this.alpha,
            "ease":Cubic.easeOut
         };
         this.FTweenOperOut.params = {
            "alpha":0,
            "ease":Cubic.easeIn,
            "onCompleteHandler":this.PerformTweenOperOnComplete
         };
         this.FRepeatOper.execute();
      }
   }
}

