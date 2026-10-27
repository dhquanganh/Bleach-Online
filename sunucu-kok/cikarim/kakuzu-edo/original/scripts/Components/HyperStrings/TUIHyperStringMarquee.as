package Components.HyperStrings
{
   import Components.Standard.TUIButton;
   import Foundation.Common.TAlignment;
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Display.TZoom9Grid;
   import Foundation.Movements.TMovementLinear;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityCartisian;
   import Logics.HyperStrings.THyperString;
   import Rendering.HyperStrings.Data.THyperStringFontSheet;
   import Rendering.HyperStrings.TSketcherHyperString;
   import Resources.Constants.CONST_COMMON;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class TUIHyperStringMarquee extends TUIComponent
   {
      
      protected static const SPEED_COEFFICIENT:Number = Math.LOG2E;
      
      protected static const MAX_SPEEDY:uint = 110;
      
      protected static const SIZE_ParagraphWidth:uint = 2500;
      
      protected var FSketcher:TSketcherHyperString;
      
      protected var FMovement:TMovementLinear;
      
      protected var FZoom9Grid:TZoom9Grid;
      
      protected var FAnimationSubstrate:BitmapData;
      
      protected var FOvarlaySubstrate:Bitmap;
      
      protected var FBtn_Close:TUIButton;
      
      protected var FCoordinateRendering:TCoordinate;
      
      protected var FCoordinateHyperString:TCoordinate;
      
      protected var FMask:Shape;
      
      protected var FBoundsSubstrate:TBounds;
      
      protected var FHyperStringWidth:int;
      
      protected var FHyperStringHeight:int;
      
      protected var FTickReference:int;
      
      protected var FModified:Boolean;
      
      protected var FUIMessageBypassing:Boolean;
      
      protected var FSpeedCoefficient:uint;
      
      protected var FOnClickAtom:Function;
      
      public function TUIHyperStringMarquee(param1:TUIComponent)
      {
         super(param1);
         FBoundsClient.Width = 800;
         FBoundsClient.Height = 30;
         this.FAnimationSubstrate = new BitmapData(1,1);
         this.FZoom9Grid = new TZoom9Grid(this.FAnimationSubstrate.clone());
         this.FZoom9Grid.GridRect = new Rectangle(CONST_COMMON.COORDINATE_ZOOM9GRID_X,CONST_COMMON.COORDINATE_ZOOM9GRID_Y,CONST_COMMON.SIZE_ZOOM9GRID_WIDTH,CONST_COMMON.SIZE_ZOOM9GRID_HEIGHT);
         this.FOvarlaySubstrate = new Bitmap();
         this.FOvarlaySubstrate.alpha = 0.8;
         addChild(this.FOvarlaySubstrate);
         this.FMovement = new TMovementLinear();
         this.FCoordinateRendering = new TCoordinate();
         this.FCoordinateHyperString = new TCoordinate();
         this.FBoundsSubstrate = new TBounds();
         this.FSketcher = new TSketcherHyperString(this);
         this.FSketcher.AlignmentLineVertical = TAlignment.VERTICAL_Center;
         this.FSketcher.WrapTrailingSpaces = true;
         this.FMask = new Shape();
         this.FMask.graphics.beginFill(0,0);
         this.FMask.graphics.drawRect(0,0,790,30);
         this.FMask.graphics.endFill();
         this.addChild(this.FMask);
         this.mask = this.FMask;
         this.FBtn_Close = new TUIButton();
         this.FModified = true;
         this.FSketcher.mouseEnabled = false;
         this.FSketcher.mouseChildren = false;
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         this.addChild(this.FBtn_Close.Substrate);
         this.FBtn_Close.X = this.Width - this.FBtn_Close.Substrate.width - 1;
         this.FBtn_Close.Y = (this.Height - this.FBtn_Close.Substrate.height) / 2;
         this.FBtn_Close.OnClick = this.Btn_CloseOnClick;
      }
      
      protected function RenderingPerform() : void
      {
         this.RenderingPerform_Substrate();
         this.RenderingPerform_Movement();
         this.RenderingPerform_HyperString();
      }
      
      protected function RenderingPerform_Substrate() : void
      {
         if(this.FModified)
         {
            this.SketchingPerform();
            this.FModified = false;
         }
      }
      
      protected function RenderingPerform_Movement() : void
      {
         var _loc1_:int = 0;
         if(this.FTickReference != 0)
         {
            _loc1_ = STimingCore.TickCount - this.FTickReference;
            this.FMovement.Move(_loc1_);
            if(this.FMovement.X < -this.FHyperStringWidth * 2)
            {
               this.FTickReference = 0;
            }
         }
      }
      
      protected function RenderingPerform_HyperString() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.FTickReference == 0)
         {
            return;
         }
         _loc3_ = this.FMovement.X + FBoundsScreen.X;
         _loc4_ = this.FMovement.Y + FBoundsScreen.Y + (FBoundsScreen.Height - this.FHyperStringHeight) / 2;
         _loc1_ = this.FSketcher.LineCount;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            TUtilityCartisian.CoordinateSet(this.FCoordinateRendering,_loc3_,_loc4_);
            this.FSketcher.RenderLine(this.FCoordinateRendering,_loc2_,true);
            _loc3_ += this.FSketcher.GetLineWidthByIndex(_loc2_);
            this.FSketcher.X = _loc3_;
            _loc2_++;
         }
      }
      
      protected function SketchingPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = FBoundsClient.Width;
         _loc2_ = FBoundsClient.Height;
         TUtilityCartisian.BoundsSetSize(this.FBoundsSubstrate,_loc1_,_loc2_);
         if(this.FBoundsSubstrate.Width == this.FZoom9Grid.Width && this.FBoundsSubstrate.Height == this.FZoom9Grid.Height)
         {
            return;
         }
         this.FZoom9Grid.Width = this.FBoundsSubstrate.Width;
         this.FZoom9Grid.Height = this.FBoundsSubstrate.Height;
         if(this.FOvarlaySubstrate.bitmapData != this.FZoom9Grid.ImageData)
         {
            if(this.FOvarlaySubstrate.bitmapData != null)
            {
               this.FOvarlaySubstrate.bitmapData.dispose();
            }
            this.FOvarlaySubstrate.bitmapData = this.FZoom9Grid.ImageData;
         }
      }
      
      protected function Btn_CloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FTickReference = 0;
      }
      
      override public function set Width(param1:int) : void
      {
         if(param1 != FBoundsClient.Width)
         {
            FBoundsClient.Width = param1;
            this.FModified = true;
         }
      }
      
      override public function set Height(param1:int) : void
      {
         if(param1 != FBoundsClient.Height)
         {
            FBoundsClient.Height = param1;
            this.FModified = true;
         }
      }
      
      public function get Animating() : Boolean
      {
         return this.FTickReference != 0;
      }
      
      public function get UIMessageBypassing() : Boolean
      {
         return this.FUIMessageBypassing;
      }
      
      public function set UIMessageBypassing(param1:Boolean) : void
      {
         this.FUIMessageBypassing = param1;
      }
      
      public function get OnClickAtom() : Function
      {
         return this.FOnClickAtom;
      }
      
      public function set OnClickAtom(param1:Function) : void
      {
         this.FOnClickAtom = param1;
      }
      
      public function get FontSheet() : THyperStringFontSheet
      {
         return this.FSketcher.FontSheet;
      }
      
      public function set FontSheet(param1:THyperStringFontSheet) : void
      {
         this.FSketcher.FontSheet = param1;
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
      
      public function get Btn_Resource() : MovieClip
      {
         return this.FBtn_Close.Substrate;
      }
      
      public function set Btn_Resource(param1:MovieClip) : void
      {
         this.FBtn_Close.Substrate = param1;
      }
      
      public function get SpeedCoefficient() : uint
      {
         return this.FSpeedCoefficient;
      }
      
      public function set SpeedCoefficient(param1:uint) : void
      {
         if(param1 == 0)
         {
            param1 = 1;
         }
         this.FSpeedCoefficient = param1;
      }
      
      public function ResourcesUpdate() : void
      {
         this.ResourcesPerform_UIDispatch();
      }
      
      public function UpdateRenderingPerform() : void
      {
         this.RenderingPerform();
      }
      
      public function Animate(param1:THyperString) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(param1 == null)
         {
            this.FSketcher.Reset();
            this.FTickReference = 0;
            return;
         }
         this.FSketcher.Sketch(param1,SIZE_ParagraphWidth);
         _loc6_ = 0;
         _loc7_ = 0;
         _loc2_ = this.FSketcher.LineCount;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FSketcher.GetLineWidthByIndex(_loc3_);
            _loc5_ = this.FSketcher.GetLineHeightByIndex(_loc3_);
            _loc6_ += _loc4_;
            if(_loc5_ > _loc7_)
            {
               _loc7_ = _loc5_;
            }
            _loc3_++;
         }
         this.FHyperStringWidth = _loc6_;
         this.FHyperStringHeight = _loc7_;
         this.FSketcher.Y = (this.Height - this.FSketcher.Height) / 2 + 1;
         _loc8_ = SPEED_COEFFICIENT * (this.FSpeedCoefficient * 4) + 55;
         if(_loc8_ > MAX_SPEEDY)
         {
            _loc8_ = int(MAX_SPEEDY);
         }
         _loc8_ *= -1;
         this.FMovement.SetupRay(FBoundsClient.Width - _loc6_ + 30,0,_loc8_,0,0,0);
         this.FTickReference = STimingCore.TickCount;
      }
   }
}

