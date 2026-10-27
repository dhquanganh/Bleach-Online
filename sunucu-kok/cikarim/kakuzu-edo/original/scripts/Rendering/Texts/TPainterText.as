package Rendering.Texts
{
   import Foundation.Common.Stubs.TStubModification;
   import Foundation.Common.TAlignment;
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Fonts.SFontCore;
   import Foundation.Fonts.TFont;
   import Foundation.UI.TUIComponent;
   import Localization.Strings.TStringParagraphParameters;
   import Resources.Constants.CONST_RENDERING;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class TPainterText extends TUIComponent
   {
      
      public static const TEXTFIELD_GutterX:int = CONST_RENDERING.TEXTFIELD_GutterX;
      
      public static const TEXTFIELD_GutterY:int = CONST_RENDERING.TEXTFIELD_GutterY;
      
      protected static var FParagrapher:TStringParagrapher = new TStringParagrapher();
      
      protected static var FParagraphParameters:TStringParagraphParameters = new TStringParagraphParameters();
      
      protected var FStubModification:TStubModification;
      
      protected var FTextField:TextField;
      
      protected var FTextFormat:TextFormat;
      
      protected var FCoordinateSketching:TCoordinate;
      
      protected var FCoordinateRendering:TCoordinate;
      
      protected var FBoundsText:TBounds;
      
      protected var FParagraphWidth:int;
      
      protected var FParagraphHeight:int;
      
      protected var FModified:Boolean;
      
      protected var FFont:TFont;
      
      protected var FText:String;
      
      protected var FWordWrap:Boolean;
      
      protected var FWordWrapWidth:int;
      
      protected var FWrapTrailingSpaces:Boolean;
      
      protected var FSelectable:Boolean;
      
      public function TPainterText(param1:TUIComponent)
      {
         super(param1);
         this.FStubModification = new TStubModification(this);
         this.ConstructFonts();
         this.FTextField = new TextField();
         this.FTextField.antiAliasType = AntiAliasType.ADVANCED;
         this.FTextField.autoSize = TextFieldAutoSize.LEFT;
         this.FTextField.mouseEnabled = false;
         addChild(this.FTextField);
         this.FTextFormat = new TextFormat();
         this.FCoordinateSketching = new TCoordinate();
         this.FCoordinateRendering = new TCoordinate();
         this.FBoundsText = new TBounds();
         this.FontSynchronize();
         this.FText = "";
         this.FWordWrap = false;
         this.FSelectable = false;
         this.FWordWrapWidth = 256;
         this.mouseEnabled = false;
      }
      
      protected function ConstructFonts() : void
      {
         this.FFont = new TFont(this.FStubModification);
      }
      
      protected function FontSynchronize() : void
      {
         this.FFont.FlushTextFormat(this.FTextFormat);
         this.FTextField.embedFonts = SFontCore.FontEmbedded(this.FFont.Name);
         this.FTextField.selectable = this.FSelectable;
      }
      
      protected function AlignCoordinateRenderingByCoordinate(param1:TCoordinate, param2:int, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc4_ = param1.X;
         switch(param2)
         {
            case TAlignment.HORIZONTAL_Center:
               _loc4_ -= this.FBoundsText.Width / 2;
               break;
            case TAlignment.HORIZONTAL_Right:
               _loc4_ -= this.FBoundsText.Width;
         }
         _loc5_ = param1.Y;
         switch(param3)
         {
            case TAlignment.VERTICAL_Center:
               _loc5_ -= this.FBoundsText.Height / 2;
               break;
            case TAlignment.VERTICAL_Bottom:
               _loc5_ -= this.FBoundsText.Height;
         }
         this.FCoordinateRendering.X = _loc4_;
         this.FCoordinateRendering.Y = _loc5_;
      }
      
      protected function AlignCoordinateRenderingByBounds(param1:TBounds, param2:int, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc4_ = param1.X;
         switch(param2)
         {
            case TAlignment.HORIZONTAL_Center:
               _loc4_ += (param1.Width - this.FBoundsText.Width) / 2;
               break;
            case TAlignment.HORIZONTAL_Right:
               _loc4_ += param1.Width - this.FBoundsText.Width;
         }
         _loc5_ = param1.Y;
         switch(param3)
         {
            case TAlignment.VERTICAL_Center:
               _loc5_ += (param1.Height - this.FBoundsText.Height) / 2;
               break;
            case TAlignment.VERTICAL_Bottom:
               _loc5_ += param1.Height - this.FBoundsText.Height;
         }
         this.FCoordinateRendering.X = _loc4_;
         this.FCoordinateRendering.Y = _loc5_;
      }
      
      protected function UpdatingPerform() : void
      {
         if(this.FModified || this.FStubModification.Modified)
         {
            this.EvaluationPerform();
            this.SketchingPerform();
            this.FModified = false;
            this.FSelectable = false;
            this.FStubModification.Modified = false;
         }
      }
      
      protected function EvaluationPerform() : void
      {
         this.EvaluationPerform_Font();
         this.EvaluationPerform_Text();
         this.EvaluationPerform_Dimension();
         this.EvaluationPerform_Bounds();
      }
      
      protected function EvaluationPerform_Font() : void
      {
         this.FontSynchronize();
      }
      
      protected function EvaluationPerform_Text() : void
      {
         if(this.FWordWrap)
         {
            FParagraphParameters.WrapTrailingSpaces = this.FWrapTrailingSpaces;
            FParagrapher.Paragraph(this.FText,this.FFont,this.FWordWrapWidth,FParagraphParameters);
         }
         else
         {
            FParagrapher.Paragraph(this.FText,this.FFont,0);
         }
      }
      
      protected function EvaluationPerform_Dimension() : void
      {
         this.FParagraphWidth = FParagrapher.ParagraphWidth;
         this.FParagraphHeight = FParagrapher.ParagraphHeight;
      }
      
      protected function EvaluationPerform_Bounds() : void
      {
         this.FBoundsText.Width = FParagrapher.ParagraphWidth;
         this.FBoundsText.Height = FParagrapher.ParagraphHeight;
      }
      
      protected function SketchingPerform() : void
      {
         this.SketchingPerform_Sketch();
         this.SketchingPerform_Text();
      }
      
      protected function SketchingPerform_Sketch() : void
      {
      }
      
      protected function SketchingPerform_Text() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.FTextField.text = "";
         this.FTextField.defaultTextFormat = this.FTextFormat;
         _loc3_ = -TEXTFIELD_GutterY;
         _loc1_ = FParagrapher.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FTextField.appendText(FParagrapher.GetLineTextByIndex(_loc2_));
            if(_loc2_ >= 0 && _loc2_ < _loc1_ - 1)
            {
               this.FTextField.appendText("\n");
            }
            this.FCoordinateSketching.X = FParagrapher.GetLineXByIndex(_loc2_) - TEXTFIELD_GutterX;
            this.FCoordinateSketching.Y = _loc3_;
            if(_loc2_ == 0)
            {
               this.FTextField.x = this.FCoordinateSketching.X;
               this.FTextField.y = this.FCoordinateSketching.Y;
            }
            _loc3_ += FParagrapher.GetLineHeightByIndex(_loc2_);
            _loc2_++;
         }
      }
      
      public function get Font() : TFont
      {
         return this.FFont;
      }
      
      public function get Text() : String
      {
         return this.FText;
      }
      
      public function set Text(param1:String) : void
      {
         if(param1 != this.FText)
         {
            this.FText = param1;
            this.FModified = true;
         }
      }
      
      public function get WordWrap() : Boolean
      {
         return this.FWordWrap;
      }
      
      public function set WordWrap(param1:Boolean) : void
      {
         if(param1 != this.FWordWrap)
         {
            this.FWordWrap = param1;
            this.FModified = true;
         }
      }
      
      public function get WordWrapWidth() : int
      {
         return this.FWordWrapWidth;
      }
      
      public function set WordWrapWidth(param1:int) : void
      {
         if(param1 < 1)
         {
            param1 = 1;
         }
         if(param1 != this.FWordWrapWidth)
         {
            this.FWordWrapWidth = param1;
            this.FModified = true;
         }
      }
      
      public function get WrapTrailingSpaces() : Boolean
      {
         return this.FWrapTrailingSpaces;
      }
      
      public function set WrapTrailingSpaces(param1:Boolean) : void
      {
         if(param1 != this.FWrapTrailingSpaces)
         {
            this.FWrapTrailingSpaces = param1;
            this.FModified = true;
         }
      }
      
      public function get TextWidth() : int
      {
         this.UpdatingPerform();
         return this.FBoundsText.Width;
      }
      
      public function get TextHeight() : int
      {
         this.UpdatingPerform();
         return this.FBoundsText.Height;
      }
      
      public function get Selectable() : Boolean
      {
         return this.FSelectable;
      }
      
      public function set Selectable(param1:Boolean) : void
      {
         this.FSelectable = param1;
      }
      
      public function get NumLines() : uint
      {
         return this.FTextField.numLines;
      }
      
      public function get Alpha() : Number
      {
         return this.FTextField.alpha;
      }
      
      public function set Alpha(param1:Number) : void
      {
         if(this.FTextField.alpha != param1)
         {
            this.FTextField.alpha = param1;
         }
      }
      
      public function get ScaleX() : Number
      {
         return this.scaleX;
      }
      
      public function set ScaleX(param1:Number) : void
      {
         if(this.scaleX != param1)
         {
            this.scaleX = param1;
         }
      }
      
      public function get ScaleY() : Number
      {
         return this.scaleY;
      }
      
      public function set ScaleY(param1:Number) : void
      {
         if(this.scaleY != param1)
         {
            this.scaleY = param1;
         }
      }
      
      public function get TextX() : int
      {
         return this.FCoordinateRendering.X;
      }
      
      public function get TextY() : int
      {
         return this.FCoordinateRendering.Y;
      }
      
      public function Evaluate(param1:TBounds) : void
      {
         this.UpdatingPerform();
         param1.Width = this.FBoundsText.Width;
         param1.Height = this.FBoundsText.Height;
         this.FTextField.width = this.FBoundsText.Width;
         this.FTextField.height = this.FBoundsText.Height;
      }
      
      public function Render(param1:TCoordinate, param2:int = 0, param3:int = 0) : void
      {
         this.UpdatingPerform();
         this.AlignCoordinateRenderingByCoordinate(param1,param2,param3);
         param1.X = this.FCoordinateRendering.X;
         param1.Y = this.FCoordinateRendering.Y;
      }
      
      public function RenderBounds(param1:TBounds, param2:int = 0, param3:int = 0) : void
      {
         this.UpdatingPerform();
         if(this.FTextField.text != null)
         {
            this.FBoundsText.Width = this.Width;
            this.FBoundsText.Height = this.Height;
            this.AlignCoordinateRenderingByBounds(param1,param2,param3);
            this.X = this.FCoordinateRendering.X;
            this.Y = this.FCoordinateRendering.Y;
         }
      }
   }
}

