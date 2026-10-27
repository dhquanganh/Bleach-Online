package Components.HyperStrings
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Fonts.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Registries.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Localization.Strings.*;
   import Logics.*;
   import Logics.HyperStrings.*;
   import Logics.HyperStrings.Atoms.*;
   import Logics.HyperStrings.Elements.*;
   import Processors.Game.Utilities.HyperStrings.TUtilityHyperString;
   import Rendering.Common.*;
   import Rendering.HyperStrings.*;
   import Rendering.HyperStrings.Data.*;
   import Rendering.Texts.*;
   import Resources.Constants.*;
   import Resources.RTTIs.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class THyperEditor extends TUIComponent
   {
      
      protected static const RENDERINGSTATE_Normal:int = 0;
      
      protected static const RENDERINGSTATE_Hovering:int = 1;
      
      protected static const RENDERINGSTATE_Focused:int = 2;
      
      protected static const RENDERINGSTATE_Disabled:int = 3;
      
      public static const MOUSECURSOR_AUTO:String = CONST_CURSOR.MOUSECURSOR_AUTO;
      
      public static const MOUSECURSOR_IBEAM:String = CONST_CURSOR.MOUSECURSOR_IBEAM;
      
      protected static const TYPE_ELEMENT_Text:int = RTTI_HYPERSTRING.ELEMENTCLASS_Text;
      
      protected static const TYPE_ELEMENT_Icon:int = RTTI_HYPERSTRING.ELEMENTCLASS_Icon;
      
      protected static const TYPE_ELEMENT_LinkItem:int = RTTI_HYPERSTRING.ELEMENTCLASS_LinkItem;
      
      protected static const CAPACITY_History:uint = 5;
      
      protected static const LOCATION_ELEMENT_Front:uint = 1;
      
      protected static const LOCATION_ELEMENT_Center:uint = 2;
      
      protected static const LOCATION_ELEMENT_Rear:uint = 3;
      
      protected static const OPERATOR_ELEMENT_Left:uint = 16;
      
      protected static const OPERATOR_ELEMENT_Right:uint = 32;
      
      protected static const OPERATOR_ELEMENT_Delete:uint = 48;
      
      protected static const OPERATOR_ELEMENT_Backspace:uint = 64;
      
      protected static const SIZE_IconWidth:int = CONST_CHAT.SIZE_IconWidth;
      
      protected static const SIZE_IconHeight:int = CONST_CHAT.SIZE_IconHeight;
      
      protected static const SIZE_CanvasWidth:int = 1000;
      
      protected static const SIZE_CanvasHeight:int = SIZE_IconHeight;
      
      public static const KEY_Ctrl:uint = 2147483648;
      
      public static const KEY_Shift:uint = 1073741824;
      
      public static const KEY_Alt:uint = 536870912;
      
      protected static const KEY_Left:uint = CONST_KEYCODE.KEY_LEFT;
      
      protected static const KEY_Right:uint = CONST_KEYCODE.KEY_RIGHT;
      
      protected static const KEY_Backspace:uint = CONST_KEYCODE.KEY_BACKSPACE;
      
      protected static const KEY_Delete:uint = CONST_KEYCODE.KEY_DELETE;
      
      protected static const KEY_Home:uint = CONST_KEYCODE.KEY_HOME;
      
      protected static const KEY_End:uint = CONST_KEYCODE.KEY_END;
      
      protected static const KEY_Enter:uint = CONST_KEYCODE.KEY_ENTER;
      
      protected static const KEY_UP:uint = CONST_KEYCODE.KEY_UP;
      
      protected static const CARET_Period:int = 800;
      
      protected static const TEXTFIELD_GutterX:int = CONST_RENDERING.TEXTFIELD_GutterX;
      
      protected static const TEXTFIELD_GutterY:int = CONST_RENDERING.TEXTFIELD_GutterY;
      
      protected var FHyperStringElementFontSheet:THyperStringFontSheet;
      
      protected var FHyperStringElementFormatSheet:THyperStringFormatSheet;
      
      protected var FUtilityHyperString:TUtilityHyperString;
      
      protected var FPoolHyperString:TPoolHyperString;
      
      protected var FGeometer:TStringGeometer;
      
      protected var FOperation:TStringOperation;
      
      protected var FSubstrate:Sprite;
      
      protected var FCaretSprite:Sprite;
      
      protected var FCaretBitmap:Bitmap;
      
      protected var FTextField:TextField;
      
      protected var FMeasureField:TextField;
      
      protected var FTextFormat:TextFormat;
      
      protected var FSketcherCanvas:TSketcherHyperString;
      
      protected var FHyperString:THyperString;
      
      protected var FHyperStringsHistory:Vector.<THyperString>;
      
      protected var FKeyDownRoutines:TRegistryRoutine;
      
      protected var FAddElementRoutines:TRegistryRoutine;
      
      protected var FOperatorElementRoutines:TRegistryRoutine;
      
      protected var FCoordinateRendering:TCoordinate;
      
      protected var FBoundsCursor:TBounds;
      
      protected var FHistoryIndex:int;
      
      protected var FRenderingState:int;
      
      protected var FCurChars:int;
      
      protected var FCaretIndex:int;
      
      protected var FCaretXLogical:int;
      
      protected var FHyperEditorWidth:int;
      
      protected var FElementIndex:int;
      
      protected var FElementsWidth:int;
      
      protected var FViewportXLogical:int;
      
      protected var FLineHeight:int;
      
      protected var FModifiedCaret:Boolean;
      
      protected var FMousePressed:Boolean;
      
      protected var FInputElement:Function;
      
      protected var FOperatorElement:Function;
      
      protected var FInitialization:Boolean;
      
      protected var FTextureExpression:TTexture;
      
      protected var FLineMinimumHeight:int;
      
      protected var FFont:TFontRendering;
      
      protected var FText:String;
      
      protected var FMaxChars:int;
      
      protected var FOnKeyDown:Function;
      
      public function THyperEditor(param1:TUIComponent, param2:THyperStringFontSheet, param3:THyperStringFormatSheet)
      {
         super(param1);
         FBoundsClient.Width = 154;
         FBoundsClient.Height = 18;
         this.FHyperStringElementFontSheet = param2;
         this.FHyperStringElementFormatSheet = param3;
         this.FUtilityHyperString = new TUtilityHyperString();
         this.FPoolHyperString = SLogicsCore.PoolHyperString;
         this.FHyperString = new THyperString();
         this.FHyperStringsHistory = new Vector.<THyperString>(CAPACITY_History);
         this.FGeometer = new TStringGeometer();
         this.FOperation = new TStringOperation();
         this.FTextField = new TextField();
         this.FTextField.type = TextFieldType.INPUT;
         this.FTextField.autoSize = TextFieldAutoSize.LEFT;
         this.FTextField.textColor = 8453888;
         this.FTextField.mouseEnabled = false;
         this.FTextField.alpha = 0;
         this.FMeasureField = new TextField();
         this.FMeasureField.autoSize = TextFieldAutoSize.LEFT;
         this.FTextField.addEventListener(Event.CHANGE,this.TextFieldOnChange);
         this.FTextField.addEventListener(KeyboardEvent.KEY_DOWN,this.TextFieldOnKeyDown);
         this.FTextField.addEventListener(KeyboardEvent.KEY_UP,this.TextFieldOnKeyUp);
         this.FTextField.addEventListener(FocusEvent.FOCUS_IN,this.TextFieldOnFocusIn);
         this.FTextField.addEventListener(FocusEvent.FOCUS_OUT,this.TextFieldOnFocusOut);
         this.addEventListener(MouseEvent.MOUSE_OVER,this.UIMessagePerform_MouseOver);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.UIMessagePerform_MouseOut);
         this.addEventListener(MouseEvent.CLICK,this.UIMessagePerform_MouseClick);
         this.FTextFormat = new TextFormat();
         this.FKeyDownRoutines = new TRegistryRoutine();
         this.KeyDownRegisterRoutines();
         this.FAddElementRoutines = new TRegistryRoutine();
         this.AddElementRegisterRoutines();
         this.FOperatorElementRoutines = new TRegistryRoutine();
         this.OperatorElementRoutines();
         this.FCoordinateRendering = new TCoordinate();
         this.FBoundsCursor = new TBounds();
         this.FFont = new TFontRendering();
         this.FText = "";
         this.FHyperEditorWidth = SIZE_CanvasWidth;
         this.FLineMinimumHeight = 18;
         this.FElementIndex = -1;
         this.FHistoryIndex = -1;
         this.FontUpdate();
      }
      
      protected function Initialization() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TCoordinate = null;
         var _loc4_:THyperString = null;
         addChild(this.FSubstrate);
         this.FSubstrate.alpha = 0.1;
         _loc3_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(this);
         FBoundsScreen.X = _loc3_.X;
         FBoundsScreen.Y = _loc3_.Y;
         FBoundsScreen.Width = this.FSubstrate.width;
         FBoundsScreen.Height = this.FSubstrate.height;
         this.FSketcherCanvas = new TSketcherHyperString(this);
         this.FSketcherCanvas.X = TEXTFIELD_GutterX;
         this.FSketcherCanvas.Y = TEXTFIELD_GutterY;
         this.FSketcherCanvas.FontSheet = this.FHyperStringElementFontSheet;
         this.FSketcherCanvas.LineMinimumHeight = SIZE_CanvasHeight;
         this.FSketcherCanvas.AlignmentLineVertical = TAlignment.VERTICAL_Center;
         this.FSketcherCanvas.OnQuerySequence = this.SketcherHyperStringOnQuerySequence;
         addChild(this.FTextField);
         this.FCaretSprite = new Sprite();
         addChild(this.FCaretSprite);
         this.FCaretBitmap = new Bitmap(new BitmapData(1,14,true,4286643968));
         this.FCaretSprite.addChild(this.FCaretBitmap);
         _loc2_ = int(CAPACITY_History);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = new THyperString();
            this.FHyperStringsHistory[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FInitialization = true;
      }
      
      override protected function RevokeInteraction() : void
      {
         super.RevokeInteraction();
      }
      
      protected function FontUpdate() : void
      {
         this.FFont.Update();
         this.FLineHeight = this.FLineMinimumHeight;
         this.FFont.FlushTextFormat(this.FTextFormat);
         this.FTextField.defaultTextFormat = this.FTextFormat;
         this.FMeasureField.defaultTextFormat = this.FTextFormat;
      }
      
      protected function GetElementWidthByString(param1:String) : int
      {
         this.FMeasureField.text = param1;
         return this.FMeasureField.textWidth;
      }
      
      protected function GetAtomWidthByIndex(param1:int) : TBounds
      {
         var _loc2_:THyperStringAtom = null;
         _loc2_ = this.FSketcherCanvas.GetAtomByIndex(param1);
         return _loc2_.Bounds;
      }
      
      protected function GetTextCaretIndexByElementIndex(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:THyperStringElement = null;
         var _loc8_:THyperStringElementTextual = null;
         _loc6_ = 0;
         if(this.FHyperString.Count == 0)
         {
            return _loc6_;
         }
         _loc2_ = 0;
         _loc2_ = 0;
         while(_loc2_ <= param1)
         {
            _loc7_ = this.FHyperString.GetElementByIndex(_loc2_);
            _loc4_ = this.GetElementTypeByElement(_loc7_);
            switch(_loc4_)
            {
               case TYPE_ELEMENT_Text:
                  _loc8_ = _loc7_ as THyperStringElementTextual;
                  _loc5_ = _loc8_.Text.length;
                  if(_loc3_ + _loc5_ < this.FCaretIndex)
                  {
                     _loc3_ += _loc5_;
                  }
                  else
                  {
                     _loc6_ = this.FCaretIndex - _loc3_;
                  }
                  break;
               case TYPE_ELEMENT_LinkItem:
                  _loc8_ = _loc7_ as THyperStringElementTextual;
                  _loc5_ = _loc8_.Text.length;
                  _loc3_++;
                  break;
               case TYPE_ELEMENT_Icon:
                  _loc3_++;
            }
            _loc2_++;
         }
         return _loc6_;
      }
      
      protected function GetEndCaretIndexByElements() : uint
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THyperStringElement = null;
         var _loc6_:THyperStringElementText = null;
         _loc2_ = this.FHyperString.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FHyperString.GetElementByIndex(_loc1_);
            _loc4_ = this.GetElementTypeByElement(_loc5_);
            switch(_loc4_)
            {
               case TYPE_ELEMENT_Text:
                  _loc6_ = _loc5_ as THyperStringElementText;
                  _loc3_ += _loc6_.Text.length;
                  break;
               case TYPE_ELEMENT_LinkItem:
                  _loc3_++;
                  break;
               case TYPE_ELEMENT_Icon:
                  _loc3_++;
            }
            _loc1_++;
         }
         return _loc3_;
      }
      
      protected function CaretAdjust() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TBounds = null;
         var _loc7_:int = 0;
         var _loc8_:THyperStringElement = null;
         var _loc9_:THyperStringElementTextual = null;
         _loc1_ = 0;
         _loc4_ = 0;
         if(this.FCaretIndex == 0 || this.FHyperString.Count == 0)
         {
            this.FCaretXLogical = 0;
            return;
         }
         if(this.FElementIndex == -1)
         {
            _loc3_ = 0;
         }
         else
         {
            _loc3_ = this.FElementIndex;
         }
         _loc1_ = 0;
         while(_loc1_ <= _loc3_)
         {
            _loc8_ = this.FHyperString.GetElementByIndex(_loc1_);
            _loc5_ = this.GetElementTypeByElement(_loc8_);
            _loc6_ = this.GetAtomWidthByIndex(_loc1_);
            switch(_loc5_)
            {
               case TYPE_ELEMENT_Text:
                  _loc9_ = _loc8_ as THyperStringElementTextual;
                  _loc7_ = _loc9_.Text.length;
                  if(_loc2_ + _loc7_ < this.FCaretIndex)
                  {
                     _loc2_ += _loc7_;
                     this.FCaretXLogical = this.FGeometer.XCompactByIndex(_loc9_.Text,this.FFont,_loc7_);
                  }
                  else
                  {
                     this.FCaretXLogical = this.FGeometer.XCompactByIndex(_loc9_.Text,this.FFont,this.FCaretIndex - _loc2_);
                  }
                  _loc4_ += this.FCaretXLogical;
                  break;
               case TYPE_ELEMENT_LinkItem:
                  _loc9_ = _loc8_ as THyperStringElementTextual;
                  _loc7_ = _loc9_.Text.length;
                  _loc4_ += _loc6_.Width;
                  _loc2_++;
                  break;
               case TYPE_ELEMENT_Icon:
                  _loc4_ += _loc6_.Width;
                  _loc2_++;
            }
            _loc1_++;
         }
         this.FCaretXLogical = _loc4_;
      }
      
      protected function UpdateCaretIndexByCoordinateScreen(param1:TCoordinate) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:THyperStringElement = null;
         var _loc10_:THyperStringElement = null;
         var _loc11_:THyperStringElementTextual = null;
         var _loc12_:TBounds = null;
         var _loc13_:int = 0;
         if(this.FHyperString.Count <= 0)
         {
            return;
         }
         _loc4_ = 0;
         _loc7_ = 0;
         _loc9_ = this.HitHyperStringTest(param1);
         _loc2_ = 0;
         while(_loc2_ < this.FHyperString.Count)
         {
            _loc10_ = this.FHyperString.GetElementByIndex(_loc2_);
            _loc12_ = this.GetAtomWidthByIndex(_loc2_);
            if(_loc10_ == _loc9_)
            {
               break;
            }
            _loc8_ = this.GetElementTypeByElement(_loc10_);
            switch(_loc8_)
            {
               case TYPE_ELEMENT_Text:
                  _loc11_ = _loc10_ as THyperStringElementTextual;
                  _loc13_ = _loc11_.Text.length;
                  _loc4_ += _loc13_;
                  break;
               case TYPE_ELEMENT_LinkItem:
                  _loc11_ = _loc10_ as THyperStringElementTextual;
                  _loc13_ = _loc11_.Text.length;
                  _loc4_++;
                  break;
               case TYPE_ELEMENT_Icon:
                  _loc4_++;
            }
            _loc7_ += _loc12_.Width;
            _loc2_++;
         }
         _loc6_ = _loc2_ - 1;
         _loc3_ = this.XLogicalByScreen(param1.X - FBoundsScreen.X);
         if(_loc9_ == null && this.FHyperString.Count > 0)
         {
            if(_loc3_ >= this.FElementsWidth)
            {
               this.FCaretIndex = _loc4_;
               this.FElementIndex = this.FHyperString.Count - 1;
               return;
            }
         }
         _loc3_ -= _loc7_;
         _loc8_ = this.GetElementTypeByElement(_loc10_);
         switch(_loc8_)
         {
            case TYPE_ELEMENT_Text:
               _loc11_ = _loc9_ as THyperStringElementTextual;
               _loc5_ = this.FGeometer.CharIndexByXCompact(_loc11_.Text,this.FFont,_loc3_,true);
               if(_loc5_ > 0)
               {
                  _loc6_++;
               }
               _loc4_ += _loc5_;
               break;
            case TYPE_ELEMENT_LinkItem:
               if(_loc3_ >= _loc12_.Width / 2)
               {
                  _loc4_++;
                  _loc6_++;
               }
               break;
            case TYPE_ELEMENT_Icon:
               if(_loc3_ >= _loc12_.Width / 2)
               {
                  _loc4_++;
                  _loc6_++;
               }
         }
         this.FCaretIndex = _loc4_;
         this.FElementIndex = _loc6_;
      }
      
      protected function UpdateSketcher() : void
      {
         this.FSketcherCanvas.Sketch(this.FHyperString,this.FHyperEditorWidth);
      }
      
      protected function ViewportAdjust() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = this.FViewportXLogical;
         _loc2_ = FBoundsClient.Width;
         _loc3_ = _loc2_ / 4;
         _loc4_ = this.FElementsWidth;
         if(this.FCaretXLogical < _loc1_)
         {
            _loc1_ = this.FCaretXLogical - _loc3_;
            if(_loc1_ < 0)
            {
               _loc1_ = 0;
            }
         }
         if(this.FCaretXLogical >= _loc1_ + _loc2_)
         {
            _loc1_ = this.FCaretXLogical - _loc2_ + _loc3_;
         }
         if(_loc4_ <= _loc1_ + _loc2_)
         {
            _loc1_ = _loc4_ - _loc2_ + 1;
            if(_loc1_ < 0)
            {
               _loc1_ = 0;
            }
         }
         this.FViewportXLogical = _loc1_;
      }
      
      protected function UpdateRenderingState() : void
      {
         if(FBacktrackedEnabled)
         {
            if(FUICore.UIStage.focus == this.FTextField)
            {
               this.FRenderingState = RENDERINGSTATE_Focused;
            }
            else if(FUICore.MouseHovering(this))
            {
               this.FRenderingState = RENDERINGSTATE_Hovering;
            }
            else
            {
               this.FRenderingState = RENDERINGSTATE_Normal;
            }
         }
         else
         {
            this.FRenderingState = RENDERINGSTATE_Disabled;
         }
      }
      
      protected function TextFieldStageAdd() : void
      {
         var _loc1_:Stage = null;
         if(FUICore == null)
         {
            return;
         }
         _loc1_ = FUICore.UIStage;
         if(_loc1_ != null)
         {
            _loc1_.addChildAt(this.FTextField,0);
         }
      }
      
      protected function TextFieldStageRemove() : void
      {
         var _loc1_:Stage = null;
         if(FUICore == null)
         {
            return;
         }
         _loc1_ = FUICore.UIStage;
         if(_loc1_ != null)
         {
            if(!_loc1_.contains(this.FTextField))
            {
               _loc1_.removeChild(this.FTextField);
            }
         }
      }
      
      protected function XLogicalByScreen(param1:int) : int
      {
         return this.FViewportXLogical - FBoundsClient.X + param1;
      }
      
      protected function XScreenByLogical(param1:int) : int
      {
         return FBoundsClient.X - this.FViewportXLogical + param1;
      }
      
      protected function AddTextToTextElement(param1:int, param2:String, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:THyperStringElementText = null;
         var _loc8_:int = 0;
         _loc7_ = this.FHyperString.GetElementByIndex(param1) as THyperStringElementText;
         _loc4_ = _loc7_.Text.length;
         _loc5_ = this.GetTextCaretIndexByElementIndex(param1);
         _loc6_ = this.GetElementWidthByString(_loc7_.Text);
         this.FOperation.Text = _loc7_.Text;
         this.FOperation.Index = _loc5_;
         TStringOperator.StringInsert(this.FOperation,param2,param3);
         _loc7_.Text = this.FOperation.Text;
         this.FCaretIndex = this.FCaretIndex + this.FOperation.Index - _loc5_;
         _loc8_ = _loc7_.Text.length;
         this.FCurChars = this.FCurChars + _loc8_ - _loc4_;
         this.FElementsWidth = this.FElementsWidth + this.GetElementWidthByString(_loc7_.Text) - _loc6_;
         this.FElementIndex = param1;
         this.FCaretXLogical += this.GetElementWidthByString(_loc7_.Text);
         this.FModifiedCaret = true;
      }
      
      protected function AddElement(param1:int, param2:THyperStringElement) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THyperStringElementTextual = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(param2 == null)
         {
            return;
         }
         _loc5_ = this.GetElementTypeByElement(param2);
         if(_loc5_ == TYPE_ELEMENT_Text)
         {
            _loc6_ = param2 as THyperStringElementTextual;
            _loc7_ = _loc6_.Text.length;
         }
         if(_loc5_ == TYPE_ELEMENT_LinkItem)
         {
            _loc6_ = param2 as THyperStringElementTextual;
            _loc6_.Text = this.FHyperStringElementFormatSheet.Format(_loc6_);
            _loc7_ = _loc6_.Text.length;
         }
         if(_loc5_ == TYPE_ELEMENT_Icon)
         {
            _loc7_ = 1;
         }
         _loc3_ = this.FMaxChars - this.FCurChars;
         if(_loc7_ > _loc3_)
         {
            return;
         }
         _loc4_ = this.GetElementLocationByIndex(param1);
         this.FInputElement = this.FAddElementRoutines.GetRoutineByIndentifier(_loc4_);
         if(this.FInputElement != null)
         {
            this.FInputElement(param1,_loc5_,param2);
         }
         switch(_loc5_)
         {
            case TYPE_ELEMENT_Text:
               _loc8_ = this.GetElementWidthByString(_loc6_.Text);
               break;
            case TYPE_ELEMENT_LinkItem:
               _loc8_ = this.GetElementWidthByString(_loc6_.Text);
               break;
            case TYPE_ELEMENT_Icon:
               _loc8_ = SIZE_IconWidth;
         }
         this.FElementsWidth += _loc8_;
         this.UpdateSketcher();
         this.FModifiedCaret = true;
      }
      
      protected function CreateNewTextElement(param1:int) : THyperStringElementText
      {
         var _loc2_:THyperStringElementText = null;
         _loc2_ = this.FPoolHyperString.AcquireElementText();
         _loc2_.ColorOverride(this.FFont.Color);
         this.FElementIndex = param1 + 1;
         return _loc2_;
      }
      
      protected function ComminuteTextElement(param1:int, param2:int) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:THyperStringElementText = null;
         var _loc6_:THyperStringElementText = null;
         _loc5_ = this.FHyperString.GetElementByIndex(param1) as THyperStringElementText;
         _loc6_ = this.FPoolHyperString.AcquireElementText();
         _loc6_.ColorOverride(this.FFont.Color);
         _loc3_ = _loc5_.Text.substr(0,param2);
         _loc4_ = _loc5_.Text.substring(param2);
         _loc5_.Text = _loc3_;
         _loc6_.Text = _loc4_;
         this.FHyperString.Insert(param1 + 1,_loc6_);
      }
      
      protected function CombinationTextElement(param1:int) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:THyperStringElementText = null;
         var _loc5_:THyperStringElementText = null;
         _loc4_ = this.FHyperString.GetElementByIndex(param1) as THyperStringElementText;
         _loc2_ = _loc4_.Text;
         _loc5_ = this.FHyperString.GetElementByIndex(param1 + 1) as THyperStringElementText;
         _loc3_ = _loc5_.Text;
         _loc2_ += _loc3_;
         _loc4_.Text = _loc2_;
         this.FHyperString.Delete(param1 + 1);
      }
      
      protected function GetElementTypeByElement(param1:THyperStringElement) : int
      {
         var _loc2_:int = 0;
         var _loc3_:Class = null;
         _loc2_ = -1;
         _loc3_ = TUtilityRTTI.GetClassByInstance(param1);
         switch(_loc3_)
         {
            case THyperStringElementText:
               _loc2_ = TYPE_ELEMENT_Text;
               break;
            case THyperStringElementIcon:
               _loc2_ = TYPE_ELEMENT_Icon;
               break;
            case THyperStringElementLinkItem:
               _loc2_ = TYPE_ELEMENT_LinkItem;
         }
         return _loc2_;
      }
      
      protected function GetElementLocationByIndex(param1:int) : int
      {
         var _loc2_:int = 0;
         if(param1 == -1)
         {
            return int(LOCATION_ELEMENT_Front);
         }
         if(param1 >= 0 && param1 < this.FHyperString.Count - 1)
         {
            return int(LOCATION_ELEMENT_Center);
         }
         if(param1 == this.FHyperString.Count - 1)
         {
            _loc2_ = int(LOCATION_ELEMENT_Rear);
         }
         return _loc2_;
      }
      
      protected function HitHyperStringTest(param1:TCoordinate) : THyperStringElement
      {
         var _loc2_:THyperStringElement = null;
         var _loc3_:TCoordinate = null;
         _loc3_ = new TCoordinate();
         _loc3_.X = param1.X - FBoundsScreen.X + this.FViewportXLogical + this.FSketcherCanvas.X;
         _loc3_.Y = param1.Y - FBoundsScreen.Y;
         return this.FSketcherCanvas.GetElementByCoordinate(_loc3_);
      }
      
      protected function RenderingPerform_Updating() : void
      {
         if(this.FFont.Modified)
         {
            this.FontUpdate();
         }
         if(this.FModifiedCaret)
         {
            this.CaretAdjust();
            this.FModifiedCaret = false;
         }
         this.ViewportAdjust();
      }
      
      protected function RenderingPerform_Glyphs() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TBounds = null;
         _loc2_ = new TBounds();
         this.ViewportAdjust();
         _loc1_ = FBoundsClient.Y + (FBoundsClient.Height - this.FSketcherCanvas.SketchHeight) / 2;
         TUtilityCartisian.CoordinateSet(this.FCoordinateRendering,this.XScreenByLogical(TEXTFIELD_GutterX),_loc1_);
         TUtilityCartisian.BoundsSet(_loc2_,this.FCoordinateRendering.X,this.FCoordinateRendering.Y,this.FSketcherCanvas.SketchWidth,this.FSketcherCanvas.SketchHeight);
         if(TUtilityCartisian.BoundsIntersect(null,_loc2_,FBoundsClient))
         {
            this.FSketcherCanvas.X = this.FCoordinateRendering.X;
            this.FSketcherCanvas.Y = this.FCoordinateRendering.Y;
            this.FSketcherCanvas.Render(this.FCoordinateRendering);
         }
      }
      
      protected function RenderingPerform_TextField() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         if(FUICore.UIStage.focus == this.FTextField)
         {
            _loc1_ = this.XScreenByLogical(this.FCaretXLogical) + 1;
            _loc2_ = FBoundsClient.Y + (FBoundsScreen.Height - this.FLineHeight) / 2 + TEXTFIELD_GutterY;
            this.FTextField.x = _loc1_;
            this.FTextField.y = _loc2_;
            _loc3_ = int(STimingCore.TickCount);
            if(_loc3_ % CARET_Period <= CARET_Period / 2)
            {
               this.FCaretSprite.x = _loc1_;
               this.FCaretSprite.y = _loc2_;
               _loc4_ = true;
            }
            else
            {
               _loc4_ = false;
            }
         }
         else
         {
            _loc4_ = false;
         }
         this.FCaretSprite.visible = _loc4_;
      }
      
      protected function UIMessagePerform_MouseOver(param1:MouseEvent) : void
      {
         FUICore.MouseSetCursor(MOUSECURSOR_IBEAM);
      }
      
      protected function UIMessagePerform_MouseOut(param1:MouseEvent) : void
      {
         FUICore.MouseSetCursor(MOUSECURSOR_AUTO);
      }
      
      protected function UIMessagePerform_MouseClick(param1:MouseEvent) : void
      {
         this.UpdateCaretIndexByCoordinateScreen(FUICore.MouseCoordinate);
         if(FUICore.UIStage.focus != this.FTextField)
         {
            FUICore.UIStage.focus = this.FTextField;
         }
         this.FTextField.setSelection(0,0);
         this.FModifiedCaret = true;
      }
      
      protected function AddElementRegisterRoutines() : void
      {
         this.FAddElementRoutines.Register(LOCATION_ELEMENT_Front,this.AddElementPerform_Front);
         this.FAddElementRoutines.Register(LOCATION_ELEMENT_Center,this.AddElementPerform_Center);
         this.FAddElementRoutines.Register(LOCATION_ELEMENT_Rear,this.AddElementPerform_Rear);
      }
      
      protected function AddElementPerform_Front(param1:int, param2:int, param3:THyperStringElement) : void
      {
         var _loc4_:THyperStringElementTextual = null;
         var _loc5_:int = 0;
         if(this.FHyperString.Count == 0)
         {
            this.FHyperString.Add(param3);
            param1++;
         }
         else
         {
            this.FHyperString.Insert(++param1,param3);
         }
         switch(param2)
         {
            case TYPE_ELEMENT_Text:
               _loc4_ = param3 as THyperStringElementTextual;
               _loc5_ = _loc4_.Text.length;
               this.FCurChars += _loc5_;
               this.FCaretIndex += _loc5_;
               break;
            case TYPE_ELEMENT_LinkItem:
               _loc4_ = param3 as THyperStringElementTextual;
               _loc5_ = _loc4_.Text.length;
               this.FCurChars += _loc5_;
               ++this.FCaretIndex;
               break;
            case TYPE_ELEMENT_Icon:
               ++this.FCurChars;
               ++this.FCaretIndex;
         }
         if(this.FElementIndex != param1)
         {
            this.FElementIndex = param1;
         }
      }
      
      protected function AddElementPerform_Center(param1:int, param2:int, param3:THyperStringElement) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THyperStringElementTextual = null;
         var _loc7_:int = 0;
         _loc5_ = this.GetElementTypeByElement(this.FHyperString.GetElementByIndex(param1));
         if(_loc5_ == TYPE_ELEMENT_Text)
         {
            _loc6_ = this.FHyperString.GetElementByIndex(param1) as THyperStringElementTextual;
            _loc4_ = this.GetTextCaretIndexByElementIndex(param1);
            _loc7_ = _loc6_.Text.length;
            if(_loc4_ < _loc7_)
            {
               this.ComminuteTextElement(param1,_loc4_);
            }
            this.FHyperString.Insert(++param1,param3);
         }
         else
         {
            this.FHyperString.Insert(++param1,param3);
         }
         if(param2 == TYPE_ELEMENT_LinkItem)
         {
            _loc6_ = param3 as THyperStringElementTextual;
            _loc7_ = _loc6_.Text.length;
            this.FCurChars += _loc7_;
            ++this.FCaretIndex;
         }
         if(param2 == TYPE_ELEMENT_Icon)
         {
            ++this.FCurChars;
            ++this.FCaretIndex;
         }
         if(this.FElementIndex != param1)
         {
            this.FElementIndex = param1;
         }
      }
      
      protected function AddElementPerform_Rear(param1:int, param2:int, param3:THyperStringElement) : void
      {
         this.AddElementPerform_Center(param1,param2,param3);
      }
      
      protected function OperatorElementRoutines() : void
      {
         this.FOperatorElementRoutines.Register(LOCATION_ELEMENT_Front | OPERATOR_ELEMENT_Left,this.OperatorElementPerform_Front_Left);
         this.FOperatorElementRoutines.Register(LOCATION_ELEMENT_Center | OPERATOR_ELEMENT_Left,this.OperatorElementPerform_Center_Left);
         this.FOperatorElementRoutines.Register(LOCATION_ELEMENT_Rear | OPERATOR_ELEMENT_Left,this.OperatorElementPerform_Rear_Left);
         this.FOperatorElementRoutines.Register(LOCATION_ELEMENT_Front | OPERATOR_ELEMENT_Right,this.OperatorElementPerform_Front_Right);
         this.FOperatorElementRoutines.Register(LOCATION_ELEMENT_Center | OPERATOR_ELEMENT_Right,this.OperatorElementPerform_Center_Right);
         this.FOperatorElementRoutines.Register(LOCATION_ELEMENT_Rear | OPERATOR_ELEMENT_Right,this.OperatorElementPerform_Rear_Right);
         this.FOperatorElementRoutines.Register(LOCATION_ELEMENT_Front | OPERATOR_ELEMENT_Delete,this.OperatorElementPerform_Front_Delete);
         this.FOperatorElementRoutines.Register(LOCATION_ELEMENT_Center | OPERATOR_ELEMENT_Delete,this.OperatorElementPerform_Center_Delete);
         this.FOperatorElementRoutines.Register(LOCATION_ELEMENT_Rear | OPERATOR_ELEMENT_Delete,this.OperatorElementPerform_Rear_Delete);
         this.FOperatorElementRoutines.Register(LOCATION_ELEMENT_Front | OPERATOR_ELEMENT_Backspace,this.OperatorElementPerform_Front_Backspace);
         this.FOperatorElementRoutines.Register(LOCATION_ELEMENT_Center | OPERATOR_ELEMENT_Backspace,this.OperatorElementPerform_Center_Backspace);
         this.FOperatorElementRoutines.Register(LOCATION_ELEMENT_Rear | OPERATOR_ELEMENT_Backspace,this.OperatorElementPerform_Rear_Backspace);
      }
      
      protected function OperatorElementPerform_Front_Left(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THyperStringElement = null;
         var _loc6_:THyperStringElementText = null;
         var _loc7_:int = 0;
         _loc5_ = this.FHyperString.GetElementByIndex(param1);
         _loc4_ = this.GetElementTypeByElement(_loc5_);
         if(_loc4_ == TYPE_ELEMENT_Text)
         {
            _loc6_ = _loc5_ as THyperStringElementText;
            _loc2_ = _loc7_ = _loc6_.Text.length;
            _loc3_ = this.GetTextCaretIndexByElementIndex(this.FElementIndex);
            this.FOperation.Index = _loc3_;
            this.FOperation.Text = _loc6_.Text;
            TStringOperator.IndexLeft(this.FOperation);
            this.FCaretIndex = this.FCaretIndex + this.FOperation.Index - _loc3_;
            if(this.FOperation.Index == 0)
            {
               --this.FElementIndex;
            }
         }
      }
      
      protected function OperatorElementPerform_Center_Left(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THyperStringElement = null;
         var _loc6_:THyperStringElementTextual = null;
         var _loc7_:int = 0;
         _loc5_ = this.FHyperString.GetElementByIndex(param1);
         _loc4_ = this.GetElementTypeByElement(_loc5_);
         if(_loc4_ == TYPE_ELEMENT_Text)
         {
            _loc6_ = _loc5_ as THyperStringElementTextual;
            _loc2_ = _loc7_ = _loc6_.Text.length;
            _loc3_ = this.GetTextCaretIndexByElementIndex(this.FElementIndex);
            this.FOperation.Index = _loc3_;
            this.FOperation.Text = _loc6_.Text;
            TStringOperator.IndexLeft(this.FOperation);
            this.FCaretIndex = this.FCaretIndex + this.FOperation.Index - _loc3_;
            if(this.FOperation.Index == 0)
            {
               --this.FElementIndex;
            }
         }
         if(_loc4_ == TYPE_ELEMENT_LinkItem)
         {
            _loc6_ = _loc5_ as THyperStringElementTextual;
            _loc7_ = _loc6_.Text.length;
            --this.FCaretIndex;
            --this.FElementIndex;
         }
         if(_loc4_ == TYPE_ELEMENT_Icon)
         {
            --this.FCaretIndex;
            --this.FElementIndex;
         }
      }
      
      protected function OperatorElementPerform_Rear_Left(param1:int) : void
      {
         this.OperatorElementPerform_Center_Left(param1);
      }
      
      protected function OperatorElementPerform_Front_Right(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THyperStringElement = null;
         var _loc6_:THyperStringElementTextual = null;
         var _loc7_:int = 0;
         if(param1 + 1 >= this.FHyperString.Count)
         {
            return;
         }
         _loc5_ = this.FHyperString.GetElementByIndex(++param1);
         _loc4_ = this.GetElementTypeByElement(_loc5_);
         if(_loc4_ == TYPE_ELEMENT_Text)
         {
            _loc6_ = _loc5_ as THyperStringElementTextual;
            _loc2_ = _loc7_ = _loc6_.Text.length;
            _loc3_ = this.GetTextCaretIndexByElementIndex(this.FElementIndex);
            this.FOperation.Index = _loc3_;
            this.FOperation.Text = _loc6_.Text;
            TStringOperator.IndexRight(this.FOperation);
            this.FCaretIndex = this.FCaretIndex + this.FOperation.Index - _loc3_;
         }
         if(_loc4_ == TYPE_ELEMENT_LinkItem)
         {
            _loc6_ = _loc5_ as THyperStringElementTextual;
            _loc7_ = _loc6_.Text.length;
            ++this.FCaretIndex;
         }
         if(_loc4_ == TYPE_ELEMENT_Icon)
         {
            ++this.FCaretIndex;
         }
         if(this.FElementIndex != param1)
         {
            this.FElementIndex = param1;
         }
      }
      
      protected function OperatorElementPerform_Center_Right(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THyperStringElement = null;
         var _loc6_:THyperStringElementTextual = null;
         var _loc7_:int = 0;
         _loc5_ = this.FHyperString.GetElementByIndex(param1);
         _loc4_ = this.GetElementTypeByElement(_loc5_);
         if(_loc4_ == TYPE_ELEMENT_Text)
         {
            _loc6_ = _loc5_ as THyperStringElementTextual;
            _loc2_ = _loc7_ = _loc6_.Text.length;
            _loc3_ = this.GetTextCaretIndexByElementIndex(param1);
            this.FOperation.Index = _loc3_;
            this.FOperation.Text = _loc6_.Text;
            if(this.FOperation.Index == _loc2_)
            {
               if(param1 + 1 < this.FHyperString.Count)
               {
                  param1++;
                  _loc5_ = this.FHyperString.GetElementByIndex(param1);
                  _loc4_ = this.GetElementTypeByElement(_loc5_);
                  if(_loc4_ == TYPE_ELEMENT_LinkItem)
                  {
                     _loc6_ = _loc5_ as THyperStringElementTextual;
                     _loc7_ = _loc6_.Text.length;
                     ++this.FCaretIndex;
                  }
                  if(_loc4_ == TYPE_ELEMENT_Icon)
                  {
                     ++this.FCaretIndex;
                  }
               }
               if(this.FElementIndex != param1)
               {
                  this.FElementIndex = param1;
               }
               return;
            }
            TStringOperator.IndexRight(this.FOperation);
            this.FCaretIndex = this.FCaretIndex + this.FOperation.Index - _loc3_;
         }
         if(_loc4_ == TYPE_ELEMENT_LinkItem || _loc4_ == TYPE_ELEMENT_Icon)
         {
            _loc5_ = this.FHyperString.GetElementByIndex(++param1);
            _loc4_ = this.GetElementTypeByElement(_loc5_);
            if(_loc4_ == TYPE_ELEMENT_Text || _loc4_ == TYPE_ELEMENT_Icon)
            {
               ++this.FCaretIndex;
            }
            if(_loc4_ == TYPE_ELEMENT_LinkItem)
            {
               _loc6_ = _loc5_ as THyperStringElementTextual;
               _loc7_ = _loc6_.Text.length;
               ++this.FCaretIndex;
            }
         }
         if(this.FElementIndex != param1)
         {
            this.FElementIndex = param1;
         }
      }
      
      protected function OperatorElementPerform_Rear_Right(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THyperStringElement = null;
         var _loc6_:THyperStringElementTextual = null;
         var _loc7_:int = 0;
         _loc5_ = this.FHyperString.GetElementByIndex(param1);
         _loc4_ = this.GetElementTypeByElement(_loc5_);
         if(_loc4_ == TYPE_ELEMENT_Text)
         {
            _loc6_ = _loc5_ as THyperStringElementTextual;
            _loc2_ = _loc7_ = _loc6_.Text.length;
            _loc3_ = this.GetTextCaretIndexByElementIndex(param1);
            this.FOperation.Index = _loc3_;
            this.FOperation.Text = _loc6_.Text;
            if(this.FOperation.Index == _loc2_)
            {
               return;
            }
            TStringOperator.IndexRight(this.FOperation);
            this.FCaretIndex = this.FCaretIndex + this.FOperation.Index - _loc3_;
         }
      }
      
      protected function OperatorElementPerform_Front_Delete(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THyperStringElement = null;
         var _loc7_:THyperStringElementTextual = null;
         var _loc8_:TBounds = null;
         var _loc9_:int = 0;
         _loc6_ = this.FHyperString.GetElementByIndex(++param1);
         _loc5_ = this.GetElementTypeByElement(_loc6_);
         if(_loc5_ == TYPE_ELEMENT_Text)
         {
            _loc7_ = this.FHyperString.GetElementByIndex(param1) as THyperStringElementTextual;
            _loc2_ = _loc9_ = _loc7_.Text.length;
            _loc3_ = 0;
            this.FOperation.Index = _loc3_;
            this.FOperation.Text = _loc7_.Text;
            _loc8_ = this.GetAtomWidthByIndex(param1);
            _loc4_ = _loc8_.Width;
            TStringOperator.StringDelete(this.FOperation);
            _loc7_.Text = this.FOperation.Text;
            _loc9_ = _loc7_.Text.length;
            this.FElementsWidth -= _loc4_ - this.GetElementWidthByString(this.FOperation.Text);
            this.FCurChars -= _loc2_ - _loc9_;
            if(this.FOperation.Index == 0 && _loc9_ == 0)
            {
               _loc4_ = this.GetElementWidthByString(this.FOperation.Text);
               this.FHyperString.Delete(param1);
               this.FElementsWidth -= _loc4_;
            }
         }
         if(_loc5_ == TYPE_ELEMENT_LinkItem || _loc5_ == TYPE_ELEMENT_Icon)
         {
            _loc6_ = this.FHyperString.GetElementByIndex(param1);
            _loc8_ = this.GetAtomWidthByIndex(param1);
            _loc4_ = _loc8_.Width;
            this.FHyperString.Delete(param1);
            this.FElementsWidth -= _loc4_;
         }
         if(_loc5_ == TYPE_ELEMENT_LinkItem)
         {
            _loc7_ = _loc6_ as THyperStringElementTextual;
            _loc9_ = _loc7_.Text.length;
            this.FCurChars -= _loc9_;
         }
         if(_loc5_ == TYPE_ELEMENT_Icon)
         {
            --this.FCurChars;
         }
      }
      
      protected function OperatorElementPerform_Center_Delete(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:THyperStringElement = null;
         var _loc9_:THyperStringElementTextual = null;
         var _loc10_:TBounds = null;
         var _loc11_:int = 0;
         _loc8_ = this.FHyperString.GetElementByIndex(param1);
         _loc5_ = this.GetElementTypeByElement(_loc8_);
         if(_loc5_ == TYPE_ELEMENT_Text)
         {
            _loc9_ = this.FHyperString.GetElementByIndex(param1) as THyperStringElementText;
            _loc10_ = this.GetAtomWidthByIndex(param1);
            _loc2_ = _loc11_ = _loc9_.Text.length;
            _loc3_ = this.GetTextCaretIndexByElementIndex(param1);
            this.FOperation.Index = _loc3_;
            this.FOperation.Text = _loc9_.Text;
            if(this.FOperation.Index == _loc2_)
            {
               if(param1 + 1 < this.FHyperString.Count)
               {
                  _loc8_ = this.FHyperString.GetElementByIndex(param1 + 1);
                  _loc10_ = this.GetAtomWidthByIndex(param1 + 1);
                  _loc5_ = this.GetElementTypeByElement(_loc8_);
                  _loc4_ = _loc10_.Width;
                  this.FHyperString.Delete(param1 + 1);
                  this.FElementsWidth -= _loc4_;
                  if(_loc5_ == TYPE_ELEMENT_LinkItem)
                  {
                     _loc9_ = _loc8_ as THyperStringElementText;
                     _loc11_ = _loc9_.Text.length;
                     this.FCurChars -= _loc11_;
                  }
                  if(_loc5_ == TYPE_ELEMENT_Icon)
                  {
                     --this.FCurChars;
                  }
                  if(param1 + 1 < this.FHyperString.Count)
                  {
                     _loc6_ = this.GetElementTypeByElement(this.FHyperString.GetElementByIndex(param1));
                     _loc7_ = this.GetElementTypeByElement(this.FHyperString.GetElementByIndex(param1 + 1));
                     if(_loc6_ == TYPE_ELEMENT_Text && _loc7_ == TYPE_ELEMENT_Text)
                     {
                        this.CombinationTextElement(param1);
                     }
                  }
                  _loc5_ = TYPE_ELEMENT_Text;
               }
            }
            else
            {
               _loc4_ = _loc10_.Width;
               TStringOperator.StringDelete(this.FOperation);
               _loc9_.Text = this.FOperation.Text;
               this.FElementsWidth -= _loc4_ - this.GetElementWidthByString(this.FOperation.Text);
               _loc11_ = _loc9_.Text.length;
               this.FCurChars -= _loc2_ - _loc11_;
            }
            if(this.FOperation.Index == 0 && _loc11_ == 0)
            {
               this.FHyperString.Delete(param1);
            }
         }
         if(_loc5_ == TYPE_ELEMENT_LinkItem || _loc5_ == TYPE_ELEMENT_Icon)
         {
            _loc8_ = this.FHyperString.GetElementByIndex(param1 + 1);
            _loc5_ = this.GetElementTypeByElement(_loc8_);
            _loc10_ = this.GetAtomWidthByIndex(param1 + 1);
            if(_loc5_ == TYPE_ELEMENT_Text)
            {
               _loc9_ = this.FHyperString.GetElementByIndex(param1 + 1) as THyperStringElementTextual;
               _loc11_ = _loc9_.Text.length;
               _loc3_ = 0;
               this.FOperation.Index = _loc3_;
               this.FOperation.Text = _loc9_.Text;
               _loc4_ = _loc10_.Width;
               TStringOperator.StringDelete(this.FOperation);
               _loc9_.Text = this.FOperation.Text;
               this.FElementsWidth -= _loc4_ - this.GetElementWidthByString(this.FOperation.Text);
               --this.FCurChars;
               if(_loc11_ == 0)
               {
                  this.FHyperString.Delete(param1 + 1);
               }
            }
            if(_loc5_ == TYPE_ELEMENT_LinkItem || _loc5_ == TYPE_ELEMENT_Icon)
            {
               _loc4_ = _loc10_.Width;
               this.FHyperString.Delete(param1 + 1);
               this.FElementsWidth -= _loc4_;
               if(_loc5_ == TYPE_ELEMENT_LinkItem)
               {
                  _loc9_ = _loc8_ as THyperStringElementTextual;
                  _loc11_ = _loc9_.Text.length;
                  this.FCurChars -= _loc11_;
               }
               if(_loc5_ == TYPE_ELEMENT_Icon)
               {
                  --this.FCurChars;
               }
               if(param1 + 1 < this.FHyperString.Count)
               {
                  _loc6_ = this.GetElementTypeByElement(this.FHyperString.GetElementByIndex(param1));
                  _loc7_ = this.GetElementTypeByElement(this.FHyperString.GetElementByIndex(param1 + 1));
                  if(_loc6_ == TYPE_ELEMENT_Text && _loc7_ == TYPE_ELEMENT_Text)
                  {
                     this.CombinationTextElement(param1);
                  }
               }
            }
         }
      }
      
      protected function OperatorElementPerform_Rear_Delete(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THyperStringElement = null;
         var _loc7_:THyperStringElementTextual = null;
         var _loc8_:TBounds = null;
         var _loc9_:int = 0;
         _loc6_ = this.FHyperString.GetElementByIndex(param1);
         _loc5_ = this.GetElementTypeByElement(_loc6_);
         if(_loc5_ == TYPE_ELEMENT_Text)
         {
            _loc7_ = this.FHyperString.GetElementByIndex(param1) as THyperStringElementTextual;
            _loc8_ = this.GetAtomWidthByIndex(param1);
            _loc2_ = _loc9_ = _loc7_.Text.length;
            _loc3_ = this.GetTextCaretIndexByElementIndex(param1);
            this.FOperation.Index = _loc3_;
            this.FOperation.Text = _loc7_.Text;
            if(this.FOperation.Index == _loc2_)
            {
               return;
            }
            _loc4_ = _loc8_.Width;
            TStringOperator.StringDelete(this.FOperation);
            _loc7_.Text = this.FOperation.Text;
            this.FElementsWidth -= _loc4_ - this.GetElementWidthByString(this.FOperation.Text);
            this.FCurChars -= _loc2_ - _loc9_;
         }
      }
      
      protected function OperatorElementPerform_Front_Backspace(param1:int) : void
      {
      }
      
      protected function OperatorElementPerform_Center_Backspace(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:THyperStringElement = null;
         var _loc10_:THyperStringElementTextual = null;
         var _loc11_:TBounds = null;
         var _loc12_:int = 0;
         _loc9_ = this.FHyperString.GetElementByIndex(param1);
         _loc11_ = this.GetAtomWidthByIndex(param1);
         _loc6_ = this.GetElementTypeByElement(_loc9_);
         if(_loc6_ == TYPE_ELEMENT_Text)
         {
            _loc10_ = this.FHyperString.GetElementByIndex(param1) as THyperStringElementText;
            _loc2_ = _loc12_ = _loc10_.Text.length;
            _loc3_ = this.GetTextCaretIndexByElementIndex(param1);
            this.FOperation.Index = _loc3_;
            this.FOperation.Text = _loc10_.Text;
            _loc4_ = _loc11_.Width;
            TStringOperator.StringBackspace(this.FOperation);
            this.FCaretIndex += this.FOperation.Index - _loc3_;
            _loc10_.Text = this.FOperation.Text;
            this.FElementsWidth -= _loc4_ - this.GetElementWidthByString(this.FOperation.Text);
            _loc12_ = _loc10_.Text.length;
            this.FCurChars -= _loc2_ - _loc12_;
            if(this.FOperation.Index == 0)
            {
               if(_loc12_ == 0)
               {
                  _loc9_ = this.FHyperString.GetElementByIndex(param1);
                  _loc11_ = this.GetAtomWidthByIndex(param1);
                  _loc4_ = _loc11_.Width;
                  this.FHyperString.Delete(param1--);
                  this.FElementsWidth -= _loc4_;
               }
               else
               {
                  param1--;
               }
            }
         }
         if(_loc6_ == TYPE_ELEMENT_LinkItem || _loc6_ == TYPE_ELEMENT_Icon)
         {
            _loc9_ = this.FHyperString.GetElementByIndex(param1);
            _loc11_ = this.GetAtomWidthByIndex(param1);
            _loc4_ = _loc11_.Width;
            this.FHyperString.Delete(param1--);
            this.FElementsWidth -= _loc4_;
            if(_loc6_ == TYPE_ELEMENT_LinkItem)
            {
               _loc10_ = _loc9_ as THyperStringElementTextual;
               _loc12_ = _loc10_.Text.length;
               this.FCurChars -= _loc12_;
               --this.FCaretIndex;
            }
            if(_loc6_ == TYPE_ELEMENT_Icon)
            {
               --this.FCurChars;
               --this.FCaretIndex;
            }
            _loc5_ = this.GetElementLocationByIndex(param1);
            if(_loc5_ == LOCATION_ELEMENT_Center)
            {
               if(param1 + 1 < this.FHyperString.Count)
               {
                  _loc7_ = this.GetElementTypeByElement(this.FHyperString.GetElementByIndex(param1));
                  _loc8_ = this.GetElementTypeByElement(this.FHyperString.GetElementByIndex(param1 + 1));
                  if(_loc7_ == TYPE_ELEMENT_Text && _loc8_ == TYPE_ELEMENT_Text)
                  {
                     this.CombinationTextElement(param1);
                  }
               }
            }
         }
         if(this.FElementIndex != param1)
         {
            this.FElementIndex = param1;
         }
      }
      
      protected function OperatorElementPerform_Rear_Backspace(param1:int) : void
      {
         this.OperatorElementPerform_Center_Backspace(param1);
      }
      
      protected function KeyDownRegisterRoutines() : void
      {
         this.FKeyDownRoutines.Register(KEY_Left,this.KeyDownPerform_Left);
         this.FKeyDownRoutines.Register(KEY_Right,this.KeyDownPerform_Right);
         this.FKeyDownRoutines.Register(KEY_Delete,this.KeyDownPerform_Delete);
         this.FKeyDownRoutines.Register(KEY_Backspace,this.KeyDownPerform_Backspace);
         this.FKeyDownRoutines.Register(KEY_Home,this.KeyDownPerform_Home);
         this.FKeyDownRoutines.Register(KEY_End,this.KeyDownPerform_End);
      }
      
      protected function KeyDownPerform(param1:uint) : void
      {
         var _loc2_:Function = null;
         _loc2_ = this.FKeyDownRoutines.GetRoutineByIndentifier(param1);
         if(_loc2_ != null)
         {
            _loc2_();
         }
      }
      
      protected function KeyDownPerform_Left() : void
      {
         var _loc1_:int = 0;
         if(this.FHyperString.Count == 0 || this.FCaretIndex == 0)
         {
            return;
         }
         _loc1_ = this.GetElementLocationByIndex(this.FElementIndex);
         this.FOperatorElement = this.FOperatorElementRoutines.GetRoutineByIndentifier(_loc1_ | OPERATOR_ELEMENT_Left);
         if(this.FOperatorElement != null)
         {
            this.FOperatorElement(this.FElementIndex);
         }
         this.FModifiedCaret = true;
      }
      
      protected function KeyDownPerform_Right() : void
      {
         var _loc1_:int = 0;
         if(this.FHyperString.Count == 0 || this.FCaretIndex >= this.FCurChars)
         {
            return;
         }
         _loc1_ = this.GetElementLocationByIndex(this.FElementIndex);
         this.FOperatorElement = this.FOperatorElementRoutines.GetRoutineByIndentifier(_loc1_ | OPERATOR_ELEMENT_Right);
         if(this.FOperatorElement != null)
         {
            this.FOperatorElement(this.FElementIndex);
         }
         this.FModifiedCaret = true;
      }
      
      protected function KeyDownPerform_Delete() : void
      {
         var _loc1_:int = 0;
         if(this.FCurChars == 0 || this.FHyperString.Count == 0)
         {
            return;
         }
         _loc1_ = this.GetElementLocationByIndex(this.FElementIndex);
         this.FOperatorElement = this.FOperatorElementRoutines.GetRoutineByIndentifier(_loc1_ | OPERATOR_ELEMENT_Delete);
         if(this.FOperatorElement != null)
         {
            this.FOperatorElement(this.FElementIndex);
         }
         if(this.FHyperString.Count == 0)
         {
            this.Clear();
         }
         this.UpdateSketcher();
         this.FModifiedCaret = true;
      }
      
      protected function KeyDownPerform_Backspace() : void
      {
         var _loc1_:int = 0;
         if(this.FCaretIndex == 0 || this.FHyperString.Count == 0)
         {
            return;
         }
         _loc1_ = this.GetElementLocationByIndex(this.FElementIndex);
         this.FOperatorElement = this.FOperatorElementRoutines.GetRoutineByIndentifier(_loc1_ | OPERATOR_ELEMENT_Backspace);
         if(this.FOperatorElement != null)
         {
            this.FOperatorElement(this.FElementIndex);
         }
         if(this.FHyperString.Count == 0)
         {
            this.Clear();
         }
         this.UpdateSketcher();
         this.FModifiedCaret = true;
      }
      
      protected function KeyDownPerform_Home() : void
      {
         if(0 != this.FCaretIndex)
         {
            this.FCaretIndex = 0;
            this.FElementIndex = -1;
            this.FModifiedCaret = true;
         }
      }
      
      protected function KeyDownPerform_End() : void
      {
         if(this.FCurChars != this.FCaretIndex)
         {
            this.FCaretIndex = this.GetEndCaretIndexByElements();
            this.FElementIndex = this.FHyperString.Count - 1;
            this.FModifiedCaret = true;
         }
      }
      
      protected function TextFieldOnChange(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:THyperStringElement = null;
         var _loc4_:THyperStringElementText = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FTextField.text.length)
         {
            if(this.FTextField.text.charCodeAt(_loc2_) == 9)
            {
               this.FTextField.replaceText(_loc2_,_loc2_ + 1," ");
            }
            _loc2_++;
         }
         _loc6_ = this.FTextField.text;
         this.FTextField.text = "";
         if(_loc6_.length == 0)
         {
            return;
         }
         _loc7_ = this.FMaxChars - this.FCurChars;
         if(this.FMaxChars > 0)
         {
            if(_loc7_ <= 0)
            {
               return;
            }
         }
         if(this.FHyperString.Count == 0)
         {
            _loc4_ = this.CreateNewTextElement(this.FElementIndex);
            this.FHyperString.Add(_loc4_);
            this.AddTextToTextElement(this.FElementIndex,_loc6_,_loc7_);
            this.UpdateSketcher();
            return;
         }
         if(this.FElementIndex == -1)
         {
            if(this.FElementIndex + 1 < this.FHyperString.Count)
            {
               _loc3_ = this.FHyperString.GetElementByIndex(this.FElementIndex + 1);
               _loc5_ = this.GetElementTypeByElement(_loc3_);
            }
            if(_loc5_ != TYPE_ELEMENT_Text)
            {
               _loc4_ = this.CreateNewTextElement(this.FElementIndex);
               if(this.FHyperString.Count == 0)
               {
                  this.FHyperString.Add(_loc4_);
               }
               else
               {
                  this.FHyperString.Insert(this.FElementIndex,_loc4_);
               }
               this.AddTextToTextElement(this.FElementIndex,_loc6_,_loc7_);
            }
            else
            {
               this.AddTextToTextElement(this.FElementIndex + 1,_loc6_,_loc7_);
            }
            this.UpdateSketcher();
            return;
         }
         _loc3_ = this.FHyperString.GetElementByIndex(this.FElementIndex);
         _loc5_ = this.GetElementTypeByElement(_loc3_);
         if(_loc5_ == TYPE_ELEMENT_Text)
         {
            this.AddTextToTextElement(this.FElementIndex,_loc6_,_loc7_);
            this.UpdateSketcher();
            return;
         }
         _loc4_ = this.CreateNewTextElement(this.FElementIndex);
         this.FHyperString.Insert(this.FElementIndex,_loc4_);
         this.AddTextToTextElement(this.FElementIndex,_loc6_,_loc7_);
         this.UpdateSketcher();
      }
      
      protected function TextFieldOnKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = 0;
         if(param1.ctrlKey)
         {
            _loc2_ |= KEY_Ctrl;
         }
         if(param1.shiftKey)
         {
            _loc2_ |= KEY_Shift;
         }
         if(param1.altKey)
         {
            _loc2_ |= KEY_Alt;
         }
         _loc3_ = param1.keyCode;
         _loc4_ = param1.charCode;
         if(param1.keyCode == KEY_UP)
         {
            this.SetHistoryToHyperEditor();
            return;
         }
         this.KeyDownPerform(_loc3_ | _loc2_);
         if(this.IsEmpty && _loc3_ == KEY_Enter)
         {
            if(this.FOnKeyDown != null)
            {
               this.FOnKeyDown(this,_loc2_,_loc3_,_loc4_);
            }
         }
      }
      
      protected function TextFieldOnKeyUp(param1:KeyboardEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = 0;
         if(param1.ctrlKey)
         {
            _loc2_ |= KEY_Ctrl;
         }
         if(param1.shiftKey)
         {
            _loc2_ |= KEY_Shift;
         }
         if(param1.altKey)
         {
            _loc2_ |= KEY_Alt;
         }
         _loc3_ = param1.keyCode;
         _loc4_ = param1.charCode;
      }
      
      protected function TextFieldOnFocusIn(param1:FocusEvent) : void
      {
      }
      
      protected function TextFieldOnFocusOut(param1:FocusEvent) : void
      {
      }
      
      protected function SketcherHyperStringOnQuerySequence(param1:Object, param2:THyperStringElement, param3:TQueryAnimationSequence) : void
      {
         var _loc4_:THyperStringElementIcon = null;
         var _loc5_:uint = 0;
         _loc4_ = param2 as THyperStringElementIcon;
         _loc5_ = _loc4_.IDIcon;
         if(_loc4_ != null)
         {
            if(this.FTextureExpression != null)
            {
               param3.Value = this.FTextureExpression.GetAnimationSequenceByIndex(_loc5_);
            }
         }
      }
      
      protected function SetHistoryToHyperEditor() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THyperString = null;
         if(this.FHistoryIndex < 0)
         {
            this.FHistoryIndex = CAPACITY_History - 1;
         }
         _loc3_ = this.FHistoryIndex;
         _loc2_ = int(CAPACITY_History);
         _loc1_ = _loc3_;
         while(_loc1_ >= 0)
         {
            _loc4_ = this.FHyperStringsHistory[_loc1_];
            if(_loc4_.Count > 0)
            {
               this.AddHyperString(_loc4_);
               this.FHistoryIndex = --_loc1_;
               break;
            }
            --this.FHistoryIndex;
            _loc1_--;
         }
      }
      
      protected function AddHyperString(param1:THyperString) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THyperStringElement = null;
         var _loc5_:THyperStringElement = null;
         this.Clear();
         _loc3_ = param1.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.GetElementByIndex(_loc2_);
            _loc5_ = this.FUtilityHyperString.CloneHyperString(_loc4_);
            this.Add(_loc5_);
            _loc2_++;
         }
      }
      
      protected function SetHyperEditorToHistory() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THyperString = null;
         var _loc4_:THyperString = null;
         _loc2_ = CAPACITY_History - 1;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FHyperStringsHistory[_loc1_ + 1];
            _loc4_ = this.FHyperStringsHistory[_loc1_];
            this.FUtilityHyperString.CopyHyperString(_loc3_,_loc4_);
            _loc1_++;
         }
         this.FUtilityHyperString.CopyHyperString(this.FHyperString,this.FHyperStringsHistory[CAPACITY_History - 1]);
      }
      
      public function get Substrate() : Sprite
      {
         return this.FSubstrate;
      }
      
      public function set Substrate(param1:Sprite) : void
      {
         this.FSubstrate = param1;
      }
      
      public function get TextureExpression() : TTexture
      {
         return this.FTextureExpression;
      }
      
      public function set TextureExpression(param1:TTexture) : void
      {
         this.FTextureExpression = param1;
      }
      
      public function get Font() : TFont
      {
         return this.FFont;
      }
      
      public function get MaxChars() : int
      {
         return this.FMaxChars;
      }
      
      public function set MaxChars(param1:int) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         this.FMaxChars = param1;
      }
      
      public function get HyperString() : THyperString
      {
         return this.FHyperString;
      }
      
      public function set Text(param1:String) : void
      {
         this.FTextField.text = param1;
         this.TextFieldOnChange(null);
      }
      
      public function get IsEmpty() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.FHyperString.Count > 0)
         {
            _loc1_ = true;
         }
         else
         {
            _loc1_ = false;
         }
         return _loc1_;
      }
      
      public function get OnKeyDown() : Function
      {
         return this.FOnKeyDown;
      }
      
      public function set OnKeyDown(param1:Function) : void
      {
         this.FOnKeyDown = param1;
      }
      
      public function get LineMinimumHeight() : int
      {
         return this.FLineMinimumHeight;
      }
      
      public function set LineMinimumHeight(param1:int) : void
      {
         this.FLineMinimumHeight = param1;
      }
      
      public function SetFocus() : void
      {
         if(FUICore != null)
         {
            FUICore.UIStage.focus = this.FTextField;
         }
      }
      
      public function Init() : void
      {
         if(this.FInitialization)
         {
            return;
         }
         this.Initialization();
      }
      
      public function Clear() : void
      {
         this.FHyperString.Clear();
         this.UpdateSketcher();
         this.FCurChars = 0;
         this.FElementIndex = -1;
         this.FCaretIndex = 0;
         this.FCaretXLogical = 0;
         this.FElementsWidth = 0;
         this.FHistoryIndex = -1;
         this.FModifiedCaret = true;
      }
      
      public function SaveHistory() : void
      {
         this.SetHyperEditorToHistory();
      }
      
      public function Add(param1:THyperStringElement) : void
      {
         this.AddElement(this.FElementIndex,param1);
      }
      
      public function RenderingPerform() : void
      {
         this.RenderingPerform_Updating();
         this.RenderingPerform_Glyphs();
         this.RenderingPerform_TextField();
      }
   }
}

