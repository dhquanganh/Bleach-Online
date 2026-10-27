package Rendering.HyperStrings
{
   import Debugging.*;
   import Foundation.Common.*;
   import Foundation.Common.Stubs.*;
   import Foundation.Fonts.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Localization.Strings.*;
   import Logics.*;
   import Logics.HyperStrings.*;
   import Logics.HyperStrings.Atoms.*;
   import Logics.HyperStrings.Elements.*;
   import Rendering.HyperStrings.Data.*;
   import Resources.Constants.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TSketcherHyperString extends TUIComponent
   {
      
      protected static var FParagrapher:TStringParagrapher = new TStringParagrapher();
      
      protected static var FParagraphParameters:TStringParagraphParameters = new TStringParagraphParameters();
      
      protected static var FDefaultFontSheet:THyperStringFontSheet = new THyperStringFontSheet();
      
      protected static var FDefaultFormatSheet:THyperStringFormatSheet = new THyperStringFormatSheet();
      
      protected static var FPoolHyperString:TPoolHyperString = SLogicsCore.PoolHyperString;
      
      protected var FFont:TFont;
      
      protected var FFontEffect:TFontEffect;
      
      protected var FTextFormat:TextFormat;
      
      protected var FParagraphWidth:int;
      
      protected var FEvaluationWidth:int;
      
      protected var FEvaluationHeight:int;
      
      protected var FEvaluationX:int;
      
      protected var FEvaluationY:int;
      
      protected var FEvaluationLineHeight:int;
      
      protected var FAtomsLine:THyperStringAtoms;
      
      protected var FAtomsGraphical:THyperStringAtoms;
      
      protected var FAtomsMonolithic:THyperStringAtoms;
      
      protected var FCoordinateSketch:TCoordinate;
      
      protected var FCoordinateRendering:TCoordinate;
      
      protected var FCoordinateFetching:TCoordinate;
      
      protected var FBoundsSketch:TBounds;
      
      protected var FBoundsRendering:TBounds;
      
      protected var FQueryAnimationSequence:TQueryAnimationSequence;
      
      protected var FQueryInventoryIcon:TQueryAnimationSequence;
      
      protected var FStubReferences:TStubReferences;
      
      protected var FAtoms:THyperStringAtoms;
      
      protected var FLineCount:int;
      
      protected var FLinesY:Vector.<int>;
      
      protected var FLinesWidth:Vector.<int>;
      
      protected var FLinesHeight:Vector.<int>;
      
      protected var FLinesHeightCompensation:Vector.<int>;
      
      protected var FLineMinimumHeight:int;
      
      protected var FAlignmentLineVertical:int;
      
      protected var FWrapTrailingSpaces:Boolean;
      
      protected var FFontSheet:THyperStringFontSheet;
      
      protected var FFormatSheet:THyperStringFormatSheet;
      
      protected var FOnQuerySequence:Function;
      
      protected var FOnQuerySequencesInventory:Function;
      
      public function TSketcherHyperString(param1:TUIComponent)
      {
         super(param1);
         this.FStubReferences = new TStubReferences(this);
         this.FFont = new TFont();
         this.FFontEffect = new TFontEffect();
         this.FTextFormat = new TextFormat();
         this.FAtomsLine = new THyperStringAtoms();
         this.FAtomsGraphical = new THyperStringAtoms();
         this.FAtomsMonolithic = new THyperStringAtoms();
         this.FCoordinateRendering = new TCoordinate();
         this.FCoordinateSketch = new TCoordinate();
         this.FCoordinateFetching = new TCoordinate();
         this.FBoundsSketch = new TBounds();
         this.FBoundsRendering = new TBounds();
         this.FQueryAnimationSequence = new TQueryAnimationSequence();
         this.FQueryInventoryIcon = new TQueryAnimationSequence();
         this.FAtoms = new THyperStringAtoms();
         this.FLinesY = new Vector.<int>();
         this.FLinesWidth = new Vector.<int>();
         this.FLinesHeight = new Vector.<int>();
         this.FLinesHeightCompensation = new Vector.<int>();
         this.FAlignmentLineVertical = TAlignment.VERTICAL_Bottom;
      }
      
      protected function AcquireAtomTextual() : THyperStringAtomTextual
      {
         return FPoolHyperString.AcquireAtomTextual(this);
      }
      
      protected function AcquireAtomGraphical() : THyperStringAtomGraphical
      {
         return FPoolHyperString.AcquireAtomGraphical(this);
      }
      
      protected function AcquireAtomMonolithic() : THyperStringAtomMonolithic
      {
         return FPoolHyperString.AcquireAtomMonolithic(this);
      }
      
      protected function EvaluationPerform(param1:THyperString, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THyperStringElement = null;
         this.EvaluationPerform_Initialization(param2);
         _loc3_ = param1.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1.GetElementByIndex(_loc4_);
            if(_loc5_ is THyperStringElementTextual)
            {
               this.EvaluationPerform_ElementTextual(_loc5_ as THyperStringElementTextual);
            }
            else if(_loc5_ is THyperStringElementGraphical)
            {
               this.EvaluationPerform_ElementGraphical(_loc5_ as THyperStringElementGraphical);
            }
            else if(_loc5_ is THyperStringElementMonolithic)
            {
               this.EvaluationPerform_ElementMonolithic(_loc5_ as THyperStringElementMonolithic);
            }
            _loc4_++;
         }
         this.EvaluationPerform_Finalization();
      }
      
      protected function EvaluationPerform_Initialization(param1:int) : void
      {
         FParagraphParameters.WrapTrailingSpaces = this.FWrapTrailingSpaces;
         this.FParagraphWidth = param1;
         this.FEvaluationWidth = 0;
         this.FEvaluationHeight = 0;
         this.FEvaluationX = 0;
         this.FEvaluationY = 0;
         this.FEvaluationLineHeight = 0;
         this.FAtomsLine.Clear();
         this.FAtomsGraphical.Clear();
         this.FAtomsMonolithic.Clear();
         this.FAtoms.Clear();
         this.FLineCount = 0;
         this.FLinesY.length = 0;
         this.FLinesWidth.length = 0;
         this.FLinesHeight.length = 0;
         this.FLinesHeightCompensation.length = 0;
      }
      
      protected function EvaluationPerform_Finalization() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.FAtomsLine.Count != 0)
         {
            this.EvaluationPerform_LineFinalization();
         }
         if(this.FParagraphWidth > 0)
         {
            if(this.FEvaluationWidth > this.FParagraphWidth)
            {
               this.FEvaluationWidth = this.FParagraphWidth;
            }
         }
         this.FEvaluationHeight = this.FEvaluationY;
         _loc1_ = this.FLineCount;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FLinesHeight[_loc2_];
            switch(this.FAlignmentLineVertical)
            {
               case TAlignment.VERTICAL_Top:
                  _loc4_ = 0;
                  break;
               case TAlignment.VERTICAL_Center:
                  _loc4_ = (this.FEvaluationLineHeight - _loc3_) / 2;
                  break;
               default:
                  _loc4_ = this.FEvaluationLineHeight - _loc3_;
            }
            this.FLinesHeightCompensation[_loc2_] = _loc4_;
            _loc2_++;
         }
      }
      
      protected function EvaluationPerform_ElementTextual(param1:THyperStringElementTextual) : void
      {
         this.EvaluationPerform_ElementTextualInitialization(param1);
         this.EvaluationPerform_ElementTextualText(param1);
      }
      
      protected function EvaluationPerform_ElementTextualInitialization(param1:THyperStringElementTextual) : void
      {
         var _loc2_:THyperStringFontSheet = null;
         if(this.FFontSheet == null)
         {
            _loc2_ = FDefaultFontSheet;
         }
         else
         {
            _loc2_ = this.FFontSheet;
         }
         _loc2_.FlushFont(param1,this.FFont,this.FFontEffect);
         if(param1.ColorOverridden)
         {
            this.FFont.Color = param1.Color;
         }
      }
      
      protected function EvaluationPerform_ElementTextualText(param1:THyperStringElementTextual) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:THyperStringFormatSheet = null;
         var _loc12_:THyperStringAtomTextual = null;
         var _loc13_:TBounds = null;
         if(this.FFormatSheet == null)
         {
            _loc11_ = FDefaultFormatSheet;
         }
         else
         {
            _loc11_ = this.FFormatSheet;
         }
         FParagraphParameters.Indent = this.FEvaluationX;
         FParagrapher.Paragraph(_loc11_.Format(param1),this.FFont,this.FParagraphWidth,FParagraphParameters);
         _loc2_ = FParagrapher.Count - 1;
         if(_loc2_ < 0)
         {
            return;
         }
         _loc3_ = 0;
         while(_loc3_ <= _loc2_)
         {
            _loc4_ = FParagrapher.GetLineTextByIndex(_loc3_);
            _loc5_ = FParagrapher.GetLineXByIndex(_loc3_);
            _loc6_ = FParagrapher.GetLineWidthByIndex(_loc3_) + 1;
            _loc7_ = FParagrapher.GetLineHeightByIndex(_loc3_);
            _loc8_ = FParagrapher.GetLineCRByIndex(_loc3_);
            if(_loc4_ != "")
            {
               _loc12_ = this.AcquireAtomTextual();
               _loc12_.Element = param1;
               _loc13_ = _loc12_.Bounds;
               _loc13_.X = _loc5_;
               _loc13_.Y = this.FEvaluationY;
               _loc13_.Width = _loc6_;
               _loc13_.Height = _loc7_;
               _loc12_.Font.Assign(this.FFont);
               _loc12_.FontEffect.Assign(this.FFontEffect);
               _loc12_.Text = _loc4_;
               this.FAtomsLine.Add(_loc12_);
            }
            this.FEvaluationX = _loc5_ + _loc6_;
            if(_loc8_ || _loc3_ < _loc2_)
            {
               this.EvaluationPerform_LineFinalization(_loc7_);
            }
            else
            {
               this.FEvaluationX = _loc5_ + _loc6_;
            }
            _loc3_++;
         }
      }
      
      protected function EvaluationPerform_ElementGraphical(param1:THyperStringElementGraphical) : void
      {
         var _loc2_:TAnimationSequence = null;
         var _loc3_:THyperStringAtomGraphical = null;
         var _loc4_:TBounds = null;
         var _loc5_:TCoordinate = null;
         if(this.FOnQuerySequence == null)
         {
            return;
         }
         this.FQueryAnimationSequence.Value = null;
         this.FOnQuerySequence(this,param1,this.FQueryAnimationSequence);
         _loc2_ = this.FQueryAnimationSequence.Value;
         if(_loc2_ == null)
         {
            return;
         }
         _loc3_ = this.AcquireAtomGraphical();
         _loc4_ = _loc3_.Bounds;
         _loc5_ = _loc3_.Pivot;
         _loc5_.X = 0;
         _loc5_.Y = 0;
         _loc2_.Evaluate(_loc5_,_loc4_);
         if(this.FParagraphWidth > 0)
         {
            if(_loc4_.Width + this.FEvaluationX > this.FParagraphWidth)
            {
               this.EvaluationPerform_LineFinalization();
            }
         }
         _loc3_.Element = param1;
         _loc3_.Sequence = _loc2_;
         _loc5_.X = -_loc4_.X;
         _loc5_.Y = -_loc4_.Y;
         _loc4_.X = this.FEvaluationX;
         _loc4_.Y = this.FEvaluationY;
         this.FAtomsLine.Add(_loc3_);
         this.FEvaluationX = _loc4_.XEnd;
      }
      
      protected function EvaluationPerform_ElementMonolithic(param1:THyperStringElementMonolithic) : void
      {
         var _loc2_:THyperStringAtomMonolithic = null;
         var _loc3_:TBounds = null;
         _loc2_ = this.AcquireAtomMonolithic();
         _loc3_ = _loc2_.Bounds;
         param1.Evaluate(_loc3_);
         if(this.FParagraphWidth > 0 && this.FEvaluationX != 0)
         {
            if(_loc3_.Width + this.FEvaluationX > this.FParagraphWidth)
            {
               this.EvaluationPerform_LineFinalization();
            }
         }
         _loc2_.Element = param1;
         _loc3_.X = this.FEvaluationX;
         _loc3_.Y = this.FEvaluationY;
         this.FAtomsLine.Add(_loc2_);
         this.FEvaluationX = _loc3_.XEnd;
      }
      
      protected function EvaluationPerform_LineFinalization(param1:int = 0) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THyperStringAtom = null;
         var _loc5_:TBounds = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(param1 < this.FLineMinimumHeight)
         {
            param1 = this.FLineMinimumHeight;
         }
         _loc2_ = this.FAtomsLine.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FAtomsLine.GetAtomByIndex(_loc3_);
            _loc4_.LineIndex = this.FLineCount;
            _loc6_ = _loc4_.Bounds.Height;
            if(_loc6_ > param1)
            {
               param1 = _loc6_;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FAtomsLine.GetAtomByIndex(_loc3_);
            _loc5_ = _loc4_.Bounds;
            if(_loc5_.Width != 0)
            {
               _loc6_ = _loc5_.Height;
               _loc7_ = this.FEvaluationY;
               switch(this.FAlignmentLineVertical)
               {
                  case TAlignment.VERTICAL_Top:
                     break;
                  case TAlignment.VERTICAL_Center:
                     _loc7_ += (param1 - _loc6_) / 2;
                     break;
                  default:
                     _loc7_ += param1 - _loc6_;
               }
               _loc5_.Y = _loc7_;
               this.FAtoms.Add(_loc4_);
               if(_loc4_ is THyperStringAtomGraphical)
               {
                  this.FAtomsGraphical.Add(_loc4_);
               }
               if(_loc4_ is THyperStringAtomMonolithic)
               {
                  this.FAtomsMonolithic.Add(_loc4_);
               }
            }
            _loc3_++;
         }
         this.FLinesY.push(this.FEvaluationY);
         this.FLinesWidth.push(this.FEvaluationX);
         this.FLinesHeight.push(param1);
         ++this.FLineCount;
         if(this.FEvaluationX > this.FEvaluationWidth)
         {
            this.FEvaluationWidth = this.FEvaluationX;
         }
         if(param1 > this.FEvaluationLineHeight)
         {
            this.FEvaluationLineHeight = param1;
         }
         this.FEvaluationX = 0;
         this.FEvaluationY += param1;
         this.FAtomsLine.Clear();
      }
      
      protected function SketchingPerform() : void
      {
         this.FBoundsSketch.Width = this.FEvaluationWidth;
         this.FBoundsSketch.Height = this.FEvaluationHeight;
         this.SketchingPerform_Atoms();
      }
      
      protected function SketchingPerform_Atoms() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THyperStringAtom = null;
         _loc1_ = this.FAtoms.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FAtoms.GetAtomByIndex(_loc2_);
            if(_loc3_ is THyperStringAtomTextual)
            {
               this.SketchingPerform_AtomTextual(_loc3_ as THyperStringAtomTextual);
            }
            _loc2_++;
         }
      }
      
      protected function SketchingPerform_AtomTextual(param1:THyperStringAtomTextual) : void
      {
         var _loc2_:TBounds = null;
         var _loc3_:TFont = null;
         var _loc4_:TFontEffect = null;
         _loc2_ = param1.Bounds;
         param1.X = _loc2_.X;
         param1.Y = _loc2_.Y;
         param1.Render();
      }
      
      protected function RenderingPerform(param1:TCoordinate) : void
      {
         this.RenderingPerform_Sketch(param1);
         this.RenderingPerform_Graphical(param1);
         this.RenderingPerform_Monolithic(param1);
      }
      
      protected function RenderingPerform_Sketch(param1:TCoordinate) : void
      {
      }
      
      protected function RenderingPerform_Graphical(param1:TCoordinate) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THyperStringAtomGraphical = null;
         var _loc6_:TBounds = null;
         var _loc7_:TCoordinate = null;
         var _loc8_:TAnimationSequence = null;
         var _loc9_:TAnimationFrame = null;
         _loc2_ = int(STimingCore.TickCount);
         _loc3_ = this.FAtomsGraphical.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.FAtomsGraphical.GetAtomByIndex(_loc4_) as THyperStringAtomGraphical;
            _loc6_ = _loc5_.Bounds;
            _loc7_ = _loc5_.Pivot;
            this.FCoordinateRendering.X = _loc6_.X + _loc7_.X;
            this.FCoordinateRendering.Y = _loc6_.Y + _loc7_.Y;
            _loc5_.X = this.FCoordinateRendering.X;
            _loc5_.Y = this.FCoordinateRendering.Y;
            _loc5_.RenderingPerformByTick(_loc2_);
            _loc4_++;
         }
      }
      
      protected function RenderingPerform_Monolithic(param1:TCoordinate) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THyperStringAtom = null;
         var _loc5_:TBounds = null;
         var _loc6_:THyperStringElementMonolithic = null;
         _loc2_ = this.FAtomsMonolithic.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FAtomsMonolithic.GetAtomByIndex(_loc3_);
            _loc5_ = _loc4_.Bounds;
            TUtilityCartisian.BoundsSet(this.FBoundsRendering,param1.X + _loc5_.X,param1.Y + _loc5_.Y,_loc5_.Width,_loc5_.Height);
            _loc6_ = _loc4_.Element as THyperStringElementMonolithic;
            _loc6_.Render(this.FBoundsRendering);
            _loc3_++;
         }
      }
      
      protected function RenderingPerform_Line(param1:TCoordinate, param2:int, param3:Boolean) : void
      {
         this.RenderingPerform_LineSketch(param1,param2,param3);
         this.RenderingPerform_LineGraphical(param1,param2,param3);
         this.RenderingPerform_LineMonolithic(param1,param2,param3);
      }
      
      protected function RenderingPerform_LineSketch(param1:TCoordinate, param2:int, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         TUtilityCartisian.BoundsSet(this.FBoundsRendering,0,this.FLinesY[param2],this.FLinesWidth[param2],this.FLinesHeight[param2]);
         _loc4_ = param1.Y;
         if(param3)
         {
            _loc4_ += this.FLinesHeightCompensation[param2];
         }
         TUtilityCartisian.CoordinateSet(this.FCoordinateRendering,param1.X,_loc4_);
      }
      
      protected function RenderingPerform_LineGraphical(param1:TCoordinate, param2:int, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:THyperStringAtomGraphical = null;
         var _loc9_:TBounds = null;
         var _loc10_:TCoordinate = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:TAnimationSequence = null;
         var _loc14_:TAnimationFrame = null;
         _loc4_ = int(STimingCore.TickCount);
         _loc5_ = -this.FLinesY[param2];
         if(param3)
         {
            _loc5_ += this.FLinesHeightCompensation[param2];
         }
         _loc6_ = this.FAtomsGraphical.Count;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = this.FAtomsGraphical.GetAtomByIndex(_loc7_) as THyperStringAtomGraphical;
            if(param2 == _loc8_.LineIndex)
            {
               _loc9_ = _loc8_.Bounds;
               _loc10_ = _loc8_.Pivot;
               _loc11_ = param1.X + _loc9_.X + _loc10_.X;
               _loc12_ = param1.Y + _loc9_.Y + _loc10_.Y;
               TUtilityCartisian.CoordinateSet(this.FCoordinateRendering,_loc11_,_loc12_ + _loc5_);
               _loc13_ = _loc8_.Sequence;
               _loc14_ = _loc13_.GetAnimationFrameByTick(_loc4_);
            }
            _loc7_++;
         }
      }
      
      protected function RenderingPerform_LineMonolithic(param1:TCoordinate, param2:int, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:THyperStringAtom = null;
         var _loc8_:TBounds = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:THyperStringElementMonolithic = null;
         _loc4_ = -this.FLinesY[param2];
         if(param3)
         {
            _loc4_ += this.FLinesHeightCompensation[param2];
         }
         _loc5_ = this.FAtomsMonolithic.Count;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = this.FAtomsMonolithic.GetAtomByIndex(_loc6_);
            if(param2 == _loc7_.LineIndex)
            {
               _loc8_ = _loc7_.Bounds;
               _loc9_ = param1.X + _loc8_.X;
               _loc10_ = param1.Y + _loc8_.Y;
               TUtilityCartisian.BoundsSet(this.FBoundsRendering,_loc9_,_loc10_ + _loc4_,_loc8_.Width,_loc8_.Height);
               _loc11_ = _loc7_.Element as THyperStringElementMonolithic;
               _loc11_.Render(this.FBoundsRendering);
            }
            _loc6_++;
         }
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get AtomCount() : int
      {
         return this.FAtoms.Count;
      }
      
      public function GetAtomByIndex(param1:int) : THyperStringAtom
      {
         return this.FAtoms.GetAtomByIndex(param1);
      }
      
      public function get LineCount() : int
      {
         return this.FLinesY.length;
      }
      
      public function GetLineXByIndex(param1:int) : int
      {
         return 0;
      }
      
      public function GetLineYByIndex(param1:int) : int
      {
         return this.FLinesY[param1];
      }
      
      public function GetLineWidthByIndex(param1:int) : int
      {
         return this.FLinesWidth[param1];
      }
      
      public function GetLineHeightByIndex(param1:int) : int
      {
         return this.FLinesHeight[param1];
      }
      
      public function GetLineHeightCompensationByIndex(param1:int) : int
      {
         return this.FLinesHeightCompensation[param1];
      }
      
      public function get SketchWidth() : int
      {
         return this.FEvaluationWidth;
      }
      
      public function get SketchHeight() : int
      {
         return this.FEvaluationHeight;
      }
      
      public function get LineMinimumHeight() : int
      {
         return this.FLineMinimumHeight;
      }
      
      public function set LineMinimumHeight(param1:int) : void
      {
         this.FLineMinimumHeight = param1;
      }
      
      public function get AlignmentLineVertical() : int
      {
         return this.FAlignmentLineVertical;
      }
      
      public function set AlignmentLineVertical(param1:int) : void
      {
         this.FAlignmentLineVertical = param1;
      }
      
      public function get WrapTrailingSpaces() : Boolean
      {
         return this.FWrapTrailingSpaces;
      }
      
      public function set WrapTrailingSpaces(param1:Boolean) : void
      {
         this.FWrapTrailingSpaces = param1;
      }
      
      public function get FontSheet() : THyperStringFontSheet
      {
         return this.FFontSheet;
      }
      
      public function set FontSheet(param1:THyperStringFontSheet) : void
      {
         this.FFontSheet = param1;
      }
      
      public function get FormatSheet() : THyperStringFormatSheet
      {
         return this.FFormatSheet;
      }
      
      public function set FormatSheet(param1:THyperStringFormatSheet) : void
      {
         this.FFormatSheet = param1;
      }
      
      public function get OnQuerySequence() : Function
      {
         return this.FOnQuerySequence;
      }
      
      public function set OnQuerySequence(param1:Function) : void
      {
         this.FOnQuerySequence = param1;
      }
      
      public function get OnQuerySequencesInventory() : Function
      {
         return this.FOnQuerySequencesInventory;
      }
      
      public function set OnQuerySequencesInventory(param1:Function) : void
      {
         this.FOnQuerySequencesInventory = param1;
      }
      
      public function Reset() : void
      {
         this.FEvaluationWidth = 0;
         this.FEvaluationHeight = 0;
         this.FEvaluationX = 0;
         this.FEvaluationY = 0;
         this.FAtomsLine.Clear();
         this.FAtomsGraphical.Clear();
         this.FAtomsMonolithic.Clear();
         this.FAtoms.Clear();
         this.FLineCount = 0;
         this.FLinesY.length = 0;
         this.FLinesWidth.length = 0;
         this.FLinesHeight.length = 0;
         this.FLinesHeightCompensation.length = 0;
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      public function Sketch(param1:THyperString, param2:int) : void
      {
         if(param1 == null)
         {
            this.Reset();
            return;
         }
         if(param2 < 0)
         {
            param2 = 0;
         }
         this.EvaluationPerform(param1,param2);
         this.SketchingPerform();
      }
      
      public function Render(param1:TCoordinate) : void
      {
         this.RenderingPerform(param1);
      }
      
      public function RenderLine(param1:TCoordinate, param2:int = 0, param3:Boolean = true) : void
      {
         this.RenderingPerform_Line(param1,param2,param3);
      }
      
      public function GetAtomByCoordinate(param1:TCoordinate) : THyperStringAtom
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THyperStringAtom = null;
         var _loc7_:TBounds = null;
         var _loc8_:Boolean = false;
         _loc2_ = param1.X;
         _loc3_ = param1.Y;
         if(_loc2_ < 0 || _loc2_ >= this.FEvaluationWidth || _loc3_ < 0 || _loc3_ >= this.FEvaluationHeight)
         {
            return null;
         }
         _loc7_ = new TBounds();
         _loc4_ = this.FAtoms.Count;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = this.FAtoms.GetAtomByIndex(_loc5_);
            _loc8_ = TUtilityCartisian.BoundsContainsCoordinate(_loc6_.Bounds,param1);
            if(_loc8_)
            {
               return _loc6_;
            }
            _loc5_++;
         }
         return null;
      }
      
      public function GetAtomByCoordinateLine(param1:TCoordinate, param2:Boolean = true) : THyperStringAtom
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         _loc3_ = param1.X;
         _loc4_ = param1.Y;
         if(_loc3_ < 0 || _loc4_ < 0 || _loc4_ >= this.FEvaluationLineHeight)
         {
            return null;
         }
         _loc5_ = -1;
         _loc6_ = 0;
         _loc9_ = this.FLineCount;
         _loc10_ = 0;
         while(_loc10_ < _loc9_)
         {
            _loc8_ = this.FLinesWidth[_loc10_];
            if(_loc6_ + _loc8_ > _loc3_)
            {
               _loc5_ = _loc10_;
               _loc3_ -= _loc6_;
               break;
            }
            _loc6_ += _loc8_;
            _loc10_++;
         }
         if(_loc5_ < 0)
         {
            return null;
         }
         _loc7_ = this.FLinesY[_loc5_];
         if(param2)
         {
            _loc4_ -= this.FLinesHeightCompensation[_loc5_];
         }
         if(_loc4_ < 0 || _loc4_ >= this.FLinesHeight[_loc5_])
         {
            return null;
         }
         _loc4_ += _loc7_;
         TUtilityCartisian.CoordinateSet(this.FCoordinateFetching,_loc3_,_loc4_);
         return this.GetAtomByCoordinate(this.FCoordinateFetching);
      }
      
      public function GetElementByCoordinate(param1:TCoordinate) : THyperStringElement
      {
         var _loc2_:THyperStringAtom = null;
         _loc2_ = this.GetAtomByCoordinate(param1);
         if(_loc2_ != null)
         {
            return _loc2_.Element;
         }
         return null;
      }
   }
}

