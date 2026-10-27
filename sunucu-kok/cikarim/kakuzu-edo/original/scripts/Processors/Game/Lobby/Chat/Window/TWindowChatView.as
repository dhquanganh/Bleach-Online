package Processors.Game.Lobby.Chat.Window
{
   import Components.HyperStrings.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.HyperStrings.*;
   import Logics.HyperStrings.Elements.*;
   import Processors.Game.Lobby.Chat.HyperString.Data.*;
   import Rendering.HyperStrings.*;
   import Rendering.HyperStrings.Data.*;
   import Resources.Constants.*;
   import Resources.RTTIs.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TWindowChatView extends TUIComponent
   {
      
      protected static const POSITION_Unknown:int = -1;
      
      public static const CAPACITY_ChannelsFilter:uint = CONST_CHAT.CAPACITY_ChannelsFilter;
      
      public static const CHANNELS_FILTER:Vector.<uint> = CONST_CHAT.CHANNELS_FILTER;
      
      public static const CHANNEL_TYPE_Composite:uint = CONST_CHAT.CHANNEL_TYPE_Composite;
      
      protected static const TYPE_ELEMENT_Text:int = RTTI_HYPERSTRING.ELEMENTCLASS_Text;
      
      protected static const TYPE_ELEMENT_LinkURL:int = RTTI_HYPERSTRING.ELEMENTCLASS_LinkURL;
      
      protected static const TYPE_ELEMENT_Icon:int = RTTI_HYPERSTRING.ELEMENTCLASS_Icon;
      
      protected static const TYPE_ELEMENT_LinkInventory:int = RTTI_HYPERSTRING.ELEMENTCLASS_LinkInventory;
      
      protected static const TYPE_ELEMENT_LinkCharacter:int = RTTI_HYPERSTRING.ELEMENTCLASS_LinkCharacter;
      
      protected static const TYPE_ELEMENT_LinkItem:int = RTTI_HYPERSTRING.ELEMENTCLASS_LinkItem;
      
      protected static const TYPE_ELEMENT_LinkHero:int = RTTI_HYPERSTRING.ELEMENTCLASS_LinkHero;
      
      protected static const TYPE_ELEMENT_LinkEvent:int = RTTI_HYPERSTRING.ELEMENTCLASS_LinkEvent;
      
      public static const MOUSECURSOR_AUTO:String = CONST_CURSOR.MOUSECURSOR_AUTO;
      
      public static const MOUSECURSOR_BUTTON:String = CONST_CURSOR.MOUSECURSOR_BUTTON;
      
      protected var FHyperStringElementFontSheet:THyperStringFontSheet;
      
      protected var FHyperStringElementFormatSheet:THyperStringFormatSheet;
      
      protected var FPoolSketcherHyperString:TPoolSketcherHyperString;
      
      protected var FChannelsSketcherHyperStrings:Vector.<TSketcherHyperStrings>;
      
      protected var FHyperStringElement:THyperStringElement;
      
      protected var FScrollBar:TUIScrollBarVertical;
      
      protected var FSubstrate:Sprite;
      
      protected var FCoordinateRendering:TCoordinate;
      
      protected var FSketcherClipBounds:TBounds;
      
      protected var FCurChannelSketcherIndex:uint;
      
      protected var FViewportYLogical:int;
      
      protected var FTextHeights:Vector.<uint>;
      
      protected var FRowsCount:Vector.<uint>;
      
      protected var FViewPortTargetY:int;
      
      protected var FViewPortOffset:int;
      
      protected var FMouseCoordinate:TCoordinate;
      
      protected var FElementHovering:Boolean;
      
      protected var FMousePressed:Boolean;
      
      protected var FInitialization:Boolean;
      
      protected var FTextureExpression:TTexture;
      
      protected var FMaxRows:int;
      
      protected var FLineMinimumHeight:int;
      
      protected var FOnHyperStringClick:Function;
      
      protected var FOnOver:Function;
      
      protected var FOnOut:Function;
      
      public function TWindowChatView(param1:TUIComponent, param2:THyperStringFontSheet, param3:THyperStringFormatSheet)
      {
         super(param1);
         FBoundsClient.Width = 250;
         FBoundsClient.Height = 146;
         this.FPoolSketcherHyperString = new TPoolSketcherHyperString();
         this.FChannelsSketcherHyperStrings = new Vector.<TSketcherHyperStrings>(CAPACITY_ChannelsFilter);
         this.FHyperStringElementFontSheet = param2;
         this.FHyperStringElementFormatSheet = param3;
         this.FScrollBar = new TUIScrollBarVertical(this);
         this.FScrollBar.Min = 0;
         this.FScrollBar.ThumbSizeMin = 29;
         this.FScrollBar.MouseWheelScale = 5;
         this.FScrollBar.OnChange = this.ScrollBarOnChange;
         this.FTextHeights = new Vector.<uint>(CAPACITY_ChannelsFilter);
         this.FRowsCount = new Vector.<uint>(CAPACITY_ChannelsFilter);
         this.FCoordinateRendering = new TCoordinate();
         this.FSketcherClipBounds = new TBounds();
         this.FMouseCoordinate = new TCoordinate();
         this.addEventListener(MouseEvent.MOUSE_MOVE,this.UIMessagePerform_MouseMove,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.UIMessagePerform_MouseOut,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.UIMessagePerform_MouseDown,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_UP,this.UIMessagePerform_MouseUp,false,0,true);
         this.FLineMinimumHeight = 18;
         this.FViewPortTargetY = POSITION_Unknown;
      }
      
      protected function Initialization() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TCoordinate = null;
         var _loc4_:TSketcherHyperStrings = null;
         addChild(this.FSubstrate);
         this.FSubstrate.alpha = 0;
         this.FSubstrate.mouseEnabled = false;
         this.FSubstrate.mouseChildren = false;
         this.FScrollBar.Init();
         this.FScrollBar.X = this.FSubstrate.width - this.FScrollBar.Width - 5;
         this.FScrollBar.EvaluateBoundScreen();
         _loc3_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(this);
         FBoundsScreen.X = _loc3_.X;
         FBoundsScreen.Y = _loc3_.Y;
         FBoundsScreen.Width = this.FSubstrate.width;
         FBoundsScreen.Height = this.FSubstrate.height;
         _loc2_ = int(CAPACITY_ChannelsFilter);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = new TSketcherHyperStrings();
            this.FChannelsSketcherHyperStrings[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FInitialization = true;
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
      }
      
      protected function YScreenByLogical(param1:int) : int
      {
         return FBoundsClient.Y - this.FViewportYLogical + param1;
      }
      
      protected function ProcessorAddMessage(param1:uint, param2:THyperString, param3:Boolean) : void
      {
         var _loc4_:TSketcherHyperString = null;
         var _loc5_:TSketcherHyperStrings = null;
         _loc5_ = this.FChannelsSketcherHyperStrings[param1];
         _loc4_ = this.FPoolSketcherHyperString.Acquire(this);
         _loc4_.FontSheet = this.FHyperStringElementFontSheet;
         _loc4_.FormatSheet = this.FHyperStringElementFormatSheet;
         _loc4_.AlignmentLineVertical = TAlignment.VERTICAL_Center;
         _loc4_.LineMinimumHeight = this.FLineMinimumHeight;
         _loc4_.OnQuerySequence = this.SketcherHyperStringOnQuerySequence;
         _loc4_.Sketch(param2,FBoundsClient.Width);
         _loc5_.Add(_loc4_);
         this.TextHeightAdjust(param1);
         this.SetVisibleSketcherHyperStrings(param1,param3);
      }
      
      protected function TextHeightAdjust(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:TSketcherHyperString = null;
         var _loc6_:TSketcherHyperStrings = null;
         _loc6_ = this.FChannelsSketcherHyperStrings[param1];
         _loc3_ = this.FRowsCount[param1];
         _loc2_ = _loc6_.Count;
         if(_loc3_ <= this.FMaxRows)
         {
            _loc5_ = _loc6_.GetSketcherByIndex(_loc2_ - 1);
            _loc3_ += 1;
            _loc4_ = _loc5_.SketchHeight;
         }
         if(_loc3_ > this.FMaxRows)
         {
            _loc3_--;
            _loc5_ = _loc6_.GetSketcherByIndex(0);
            _loc4_ -= _loc5_.SketchHeight;
            _loc5_ = _loc6_.DeleteSketcherByIndex(0);
         }
         this.FTextHeights[param1] += _loc4_;
         this.FRowsCount[param1] = _loc3_;
      }
      
      protected function UpdateSlotsPosition() : void
      {
         this.FViewPortTargetY = this.FScrollBar.Value;
      }
      
      protected function UpdateScroolBar() : void
      {
         var _loc1_:int = 0;
         _loc1_ = FBoundsClient.Height;
         this.FScrollBar.PageSize = _loc1_;
         this.FScrollBar.Max = this.FTextHeights[this.FCurChannelSketcherIndex];
      }
      
      protected function UpdateChatViewHeight() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:uint = 0;
         _loc2_ = this.FTextHeights[this.FCurChannelSketcherIndex];
         if(_loc2_ > FBoundsClient.Height)
         {
            _loc1_ = true;
         }
         else
         {
            this.FViewPortOffset = 0;
            _loc1_ = false;
         }
         this.FScrollBar.Visible = _loc1_;
         return _loc1_;
      }
      
      protected function PageRollAdjust(param1:int) : int
      {
         return Math.log(param1 * 100000) * Math.LOG2E;
      }
      
      protected function ViewportAdjust() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc1_ = this.FTextHeights[this.FCurChannelSketcherIndex];
         _loc2_ = this.FViewportYLogical;
         _loc4_ = this.FViewPortOffset;
         _loc3_ = FBoundsClient.Height;
         if(_loc1_ < _loc3_)
         {
            _loc2_ = int(_loc1_);
            if(_loc2_ < _loc1_)
            {
               _loc2_ = int(_loc1_);
            }
         }
         if(_loc1_ >= _loc2_ + _loc3_)
         {
            _loc2_ = _loc1_ - _loc3_;
         }
         if(_loc1_ <= _loc2_ + _loc3_)
         {
            _loc2_ = _loc1_ - _loc3_;
            if(_loc2_ < 0)
            {
               _loc2_ = 0;
            }
         }
         if(this.FViewPortTargetY >= 0)
         {
            if(this.FViewPortTargetY > this.FViewportYLogical)
            {
               _loc5_ = this.FViewPortTargetY - this.FViewportYLogical;
               _loc4_ += this.PageRollAdjust(_loc5_);
               if(_loc4_ + _loc2_ > this.FViewPortTargetY)
               {
                  _loc4_ = this.FViewPortTargetY - _loc2_;
               }
               if(_loc4_ + _loc2_ > _loc1_ - FBoundsClient.Height)
               {
                  _loc4_ = _loc1_ - _loc3_ - _loc2_;
               }
            }
            else if(this.FViewPortTargetY < this.FViewportYLogical)
            {
               _loc5_ = this.FViewportYLogical - this.FViewPortTargetY;
               _loc4_ -= this.PageRollAdjust(_loc5_);
               if(_loc2_ + _loc4_ < this.FViewPortTargetY)
               {
                  _loc4_ = 0 - (_loc2_ - this.FViewPortTargetY);
               }
               if(_loc2_ + _loc4_ < 0)
               {
                  _loc4_ = 0 - _loc2_;
               }
            }
         }
         this.FViewportYLogical = _loc2_ + _loc4_;
         this.FViewPortOffset = _loc4_;
         if(this.FViewPortTargetY == this.FViewportYLogical)
         {
            this.FViewPortTargetY = POSITION_Unknown;
         }
         else if(this.FViewPortTargetY != POSITION_Unknown)
         {
            this.FScrollBar.Value = this.FViewPortTargetY;
         }
         else
         {
            this.FScrollBar.Value = this.FViewportYLogical;
         }
      }
      
      protected function UpdateCursorStyleByElement(param1:THyperStringElement) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         _loc2_ = this.GetElementTypeByElement(param1);
         switch(_loc2_)
         {
            case TYPE_ELEMENT_LinkCharacter:
               _loc3_ = true;
               break;
            case TYPE_ELEMENT_LinkURL:
               _loc3_ = true;
               break;
            case TYPE_ELEMENT_LinkItem:
               _loc3_ = true;
               break;
            case TYPE_ELEMENT_LinkHero:
               _loc3_ = true;
               break;
            case TYPE_ELEMENT_LinkEvent:
               _loc3_ = true;
               break;
            default:
               _loc3_ = false;
         }
         return _loc3_;
      }
      
      protected function GetElementTypeByElement(param1:THyperStringElement) : int
      {
         var _loc2_:int = 0;
         var _loc3_:Class = null;
         _loc3_ = TUtilityRTTI.GetClassByInstance(param1);
         switch(_loc3_)
         {
            case THyperStringElementText:
               _loc2_ = TYPE_ELEMENT_Text;
               break;
            case THyperStringElementLinkCharacter:
               _loc2_ = TYPE_ELEMENT_LinkCharacter;
               break;
            case THyperStringElementLinkURL:
               _loc2_ = TYPE_ELEMENT_LinkURL;
               break;
            case THyperStringElementIcon:
               _loc2_ = TYPE_ELEMENT_Icon;
               break;
            case THyperStringElementLinkItem:
               _loc2_ = TYPE_ELEMENT_LinkItem;
               break;
            case THyperStringElementLinkHero:
               _loc2_ = TYPE_ELEMENT_LinkHero;
               break;
            case THyperStringElementLinkEvent:
               _loc2_ = TYPE_ELEMENT_LinkEvent;
               break;
            default:
               _loc2_ = -1;
         }
         return _loc2_;
      }
      
      protected function HitHyperStringTest(param1:TCoordinate) : THyperStringElement
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THyperStringElement = null;
         var _loc6_:TSketcherHyperString = null;
         var _loc7_:TSketcherHyperStrings = null;
         var _loc8_:TCoordinate = null;
         _loc8_ = new TCoordinate();
         _loc7_ = this.FChannelsSketcherHyperStrings[this.FCurChannelSketcherIndex];
         _loc3_ = _loc7_.Count;
         _loc8_.X = param1.X;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = _loc7_.GetSketcherByIndex(_loc2_);
            _loc8_.Y = param1.Y - _loc4_ + this.FViewportYLogical;
            _loc5_ = _loc6_.GetElementByCoordinate(_loc8_);
            if(_loc5_ != null)
            {
               return _loc5_;
            }
            _loc4_ += _loc6_.SketchHeight;
            _loc2_++;
         }
         return null;
      }
      
      protected function UIMessagePerform_MouseMove(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:TCoordinate = null;
         var _loc4_:THyperStringElement = null;
         _loc3_ = this.FMouseCoordinate;
         _loc3_.X = FUICore.MouseCoordinate.X - FBoundsScreen.X;
         _loc3_.Y = FUICore.MouseCoordinate.Y - FBoundsScreen.Y;
         _loc4_ = this.HitHyperStringTest(_loc3_);
         if(this.FOnOver != null)
         {
            this.FOnOver(this);
         }
         if(_loc4_ != null)
         {
            _loc2_ = this.UpdateCursorStyleByElement(_loc4_);
         }
         if(_loc2_)
         {
            FUICore.MouseSetCursor(MOUSECURSOR_BUTTON);
         }
         else
         {
            FUICore.MouseSetCursor(MOUSECURSOR_AUTO);
         }
         this.FElementHovering = _loc2_;
      }
      
      protected function UIMessagePerform_MouseOut(param1:MouseEvent) : void
      {
         if(this.FOnOut != null)
         {
            this.FOnOut(this);
         }
      }
      
      protected function UIMessagePerform_MouseDown(param1:MouseEvent) : void
      {
         var _loc2_:TCoordinate = null;
         _loc2_ = this.FMouseCoordinate;
         _loc2_.X = FUICore.MouseCoordinate.X - FBoundsScreen.X;
         _loc2_.Y = FUICore.MouseCoordinate.Y - FBoundsScreen.Y;
         if(this.FElementHovering)
         {
            this.FHyperStringElement = this.HitHyperStringTest(_loc2_);
            this.FMousePressed = true;
         }
      }
      
      protected function UIMessagePerform_MouseUp(param1:MouseEvent) : void
      {
         var _loc2_:TCoordinate = null;
         var _loc3_:THyperStringElement = null;
         if(this.FMousePressed)
         {
            _loc2_ = this.FMouseCoordinate;
            _loc2_.X = FUICore.MouseCoordinate.X - FBoundsScreen.X;
            _loc2_.Y = FUICore.MouseCoordinate.Y - FBoundsScreen.Y;
            _loc3_ = this.HitHyperStringTest(_loc2_);
            if(this.FHyperStringElement != null && this.FHyperStringElement == _loc3_)
            {
               this.HyperStringOnClick();
            }
            this.FMousePressed = false;
            param1.stopPropagation();
         }
      }
      
      protected function RenderingPerform_SketcherHyperStrings() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:TSketcherHyperString = null;
         var _loc6_:TSketcherHyperStrings = null;
         _loc6_ = this.FChannelsSketcherHyperStrings[this.FCurChannelSketcherIndex];
         if(this.UpdateChatViewHeight())
         {
            this.UpdateScroolBar();
         }
         this.ViewportAdjust();
         _loc2_ = _loc6_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = _loc6_.GetSketcherByIndex(_loc1_);
            TUtilityCartisian.CoordinateSet(this.FCoordinateRendering,FBoundsClient.X,this.YScreenByLogical(0) + _loc3_);
            TUtilityCartisian.BoundsSet(this.FSketcherClipBounds,this.FCoordinateRendering.X,this.FCoordinateRendering.Y,_loc5_.SketchWidth,_loc5_.SketchHeight);
            _loc3_ += _loc5_.SketchHeight;
            if(TUtilityCartisian.BoundsIntersect(null,this.FSketcherClipBounds,FBoundsClient))
            {
               _loc5_.X = this.FCoordinateRendering.X;
               _loc5_.Y = this.FCoordinateRendering.Y;
               _loc5_.Render(this.FCoordinateRendering);
               _loc4_ = true;
            }
            else
            {
               _loc4_ = false;
            }
            if(_loc5_.Visible != _loc4_)
            {
               _loc5_.Visible = _loc4_;
            }
            _loc1_++;
         }
      }
      
      protected function SetVisibleSketcherHyperStrings(param1:int, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TSketcherHyperString = null;
         var _loc5_:TSketcherHyperStrings = null;
         _loc5_ = this.FChannelsSketcherHyperStrings[param1];
         _loc3_ = _loc5_.Count;
         param1 = 0;
         while(param1 < _loc3_)
         {
            _loc4_ = _loc5_.GetSketcherByIndex(param1);
            _loc4_.Visible = param2;
            param1++;
         }
      }
      
      override protected function ProcessorResize() : void
      {
         var _loc1_:TCoordinate = null;
         _loc1_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(this);
         FBoundsScreen.X = _loc1_.X;
         FBoundsScreen.Y = _loc1_.Y;
      }
      
      protected function ScrollBarOnChange(param1:Object) : void
      {
         this.UpdateSlotsPosition();
      }
      
      protected function HyperStringOnClick() : void
      {
         if(this.FOnHyperStringClick != null)
         {
            this.FOnHyperStringClick(this,this.FHyperStringElement);
         }
      }
      
      protected function SketcherHyperStringOnQuerySequence(param1:Object, param2:THyperStringElementGraphical, param3:TQueryAnimationSequence) : void
      {
         var _loc4_:THyperStringElementIcon = null;
         var _loc5_:uint = 0;
         _loc4_ = param2 as THyperStringElementIcon;
         _loc5_ = _loc4_.IDIcon;
         if(_loc4_ != null)
         {
            if(this.FTextureExpression != null)
            {
               param3.Value = this.FTextureExpression.GetAnimationSequenceByIdentifier(_loc5_);
            }
         }
      }
      
      public function get Substrate() : Sprite
      {
         return this.FSubstrate;
      }
      
      public function set Substrate(param1:Sprite) : void
      {
         this.FSubstrate = param1;
      }
      
      public function get MCScrollBar() : Sprite
      {
         return this.FScrollBar.Resource;
      }
      
      public function set MCScrollBar(param1:Sprite) : void
      {
         this.FScrollBar.Resource = param1;
      }
      
      public function get ScrollBar() : TUIScrollBarVertical
      {
         return this.FScrollBar;
      }
      
      public function get MaxRows() : int
      {
         return this.FMaxRows;
      }
      
      public function set MaxRows(param1:int) : void
      {
         if(param1 >= 0)
         {
            this.FMaxRows = param1;
         }
         else
         {
            this.FMaxRows = 0;
         }
      }
      
      public function get LineMinimumHeight() : int
      {
         return this.FLineMinimumHeight;
      }
      
      public function set LineMinimumHeight(param1:int) : void
      {
         this.FLineMinimumHeight = param1;
      }
      
      public function get OnHyperStringClick() : Function
      {
         return this.FOnHyperStringClick;
      }
      
      public function set OnHyperStringClick(param1:Function) : void
      {
         this.FOnHyperStringClick = param1;
      }
      
      public function get TextureExpression() : TTexture
      {
         return this.FTextureExpression;
      }
      
      public function set TextureExpression(param1:TTexture) : void
      {
         this.FTextureExpression = param1;
      }
      
      public function get OnOver() : Function
      {
         return this.FOnOver;
      }
      
      public function set OnOver(param1:Function) : void
      {
         this.FOnOver = param1;
      }
      
      public function get OnOut() : Function
      {
         return this.FOnOut;
      }
      
      public function set OnOut(param1:Function) : void
      {
         this.FOnOut = param1;
      }
      
      public function Perform_UIDispatch() : void
      {
         this.ResourcesPerform_UIDispatch();
      }
      
      public function Init() : void
      {
         if(this.FInitialization)
         {
            return;
         }
         this.Initialization();
      }
      
      public function Update() : void
      {
         this.FPoolSketcherHyperString.Update();
      }
      
      public function RenderingPerform() : void
      {
         this.RenderingPerform_SketcherHyperStrings();
         this.FScrollBar.RenderingPerform();
      }
      
      public function AddMessage(param1:THyperString, param2:uint, param3:THyperString = null) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         _loc4_ = CHANNELS_FILTER.indexOf(CHANNEL_TYPE_Composite);
         _loc5_ = false;
         if(_loc4_ == this.FCurChannelSketcherIndex)
         {
            _loc5_ = true;
         }
         this.ProcessorAddMessage(_loc4_,param2 == CONST_CHAT.CHANNEL_TYPE_Nation ? param3 : param1,_loc5_);
         if(param1 != null)
         {
            _loc4_ = CHANNELS_FILTER.indexOf(param2);
            _loc5_ = false;
            if(_loc4_ == this.FCurChannelSketcherIndex)
            {
               _loc5_ = true;
            }
            this.ProcessorAddMessage(_loc4_,param1,_loc5_);
         }
         if(param3 != null)
         {
            if(param2 == CONST_CHAT.CHANNEL_TYPE_Nation)
            {
               _loc4_ = CHANNELS_FILTER.indexOf(CONST_CHAT.CHANNEL_TYPE_World);
               this.ProcessorAddMessage(_loc4_,param3,false);
            }
            else
            {
               _loc4_ = CHANNELS_FILTER.indexOf(CONST_CHAT.CHANNEL_TYPE_Nation);
               this.ProcessorAddMessage(_loc4_,param3,false);
            }
         }
      }
      
      public function SetChannelSketcherByIndex(param1:int) : void
      {
         this.SetVisibleSketcherHyperStrings(this.FCurChannelSketcherIndex,false);
         this.SetVisibleSketcherHyperStrings(param1,true);
         this.FViewPortOffset = 0;
         this.FCurChannelSketcherIndex = param1;
      }
      
      public function Clear(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TSketcherHyperStrings = null;
         _loc2_ = 0;
         while(_loc2_ < CAPACITY_ChannelsFilter)
         {
            _loc3_ = this.FChannelsSketcherHyperStrings[_loc2_];
            _loc3_.Clear();
            this.FTextHeights[_loc2_] = 0;
            this.FRowsCount[_loc2_] = 0;
            _loc2_++;
         }
         this.FViewPortOffset = 0;
         this.FCurChannelSketcherIndex = 0;
      }
   }
}

