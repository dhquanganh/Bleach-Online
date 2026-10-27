package Processors.Game.Lobby.Chat.Window
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Display.TZoom9Grid;
   import Foundation.Fonts.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Resources.Constants.*;
   import Resources.Fonts.*;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.*;
   
   public class TWindowExpression extends TUIComponent
   {
      
      protected static const CAPACITY_Expression:uint = CONST_CHAT.CAPACITY_Expression;
      
      protected static const SIZE_CellExpressionWidth:int = CONST_CHAT.SIZE_IconWidth;
      
      protected static const SIZE_CellExpressionHeight:int = CONST_CHAT.SIZE_IconHeight;
      
      protected static const SIZE_CellCount:int = 6;
      
      protected static const SIZE_Padding:uint = 4;
      
      protected static const SIZE_MarginLeft:uint = 5;
      
      protected static const SIZE_MarginTop:uint = 5;
      
      protected static const SIZE_MarginRight:uint = 5;
      
      protected static const SIZE_MarginBottom:uint = 5;
      
      protected var FZoom9Grid:TZoom9Grid;
      
      protected var FAnimationSubstrate:BitmapData;
      
      protected var FSubstrate:Sprite;
      
      protected var FOvarlaySubstrate:Bitmap;
      
      protected var FBounds:TBounds;
      
      protected var FImagesExpression:Vector.<TUIImage>;
      
      protected var FCoordinatePivot:TCoordinate;
      
      protected var FInitialization:Boolean;
      
      protected var FSequences:Vector.<TAnimationSequence>;
      
      protected var FOnIconClick:Function;
      
      public function TWindowExpression(param1:TUIComponent)
      {
         super(param1);
         this.ConstructBounds();
         this.ConstructSubstrate();
         this.ConstructButtonsExpression();
         this.ConstructSequences();
         this.FCoordinatePivot = new TCoordinate();
         this.Visible = false;
      }
      
      protected function ConstructBounds() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = Math.ceil(Number(CAPACITY_Expression / SIZE_CellCount));
         _loc1_ = SIZE_MarginLeft + SIZE_CellCount * SIZE_CellExpressionWidth + (SIZE_CellCount - 1) * SIZE_Padding + SIZE_MarginRight;
         _loc2_ = SIZE_MarginTop + _loc3_ * SIZE_CellExpressionHeight + (_loc3_ - 1) * SIZE_Padding + SIZE_MarginBottom;
         this.FBounds = new TBounds();
         this.FBounds.Width = _loc1_;
         this.FBounds.Height = _loc2_;
      }
      
      protected function ConstructSubstrate() : void
      {
         this.FSubstrate = new Sprite();
         addChild(this.FSubstrate);
         this.FOvarlaySubstrate = new Bitmap();
         this.FSubstrate.addChild(this.FOvarlaySubstrate);
      }
      
      protected function ConstructButtonsExpression() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TUIImage = null;
         this.FImagesExpression = new Vector.<TUIImage>(CAPACITY_Expression);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Expression)
         {
            _loc4_ = _loc1_ % SIZE_CellCount;
            _loc5_ = _loc1_ / SIZE_CellCount;
            _loc2_ = _loc4_ * SIZE_CellExpressionWidth + _loc4_ * SIZE_Padding;
            _loc3_ = _loc5_ * SIZE_CellExpressionHeight + _loc5_ * SIZE_Padding;
            if(_loc4_ == 0)
            {
               _loc2_ += SIZE_MarginLeft;
            }
            else
            {
               _loc2_ += SIZE_Padding;
            }
            if(_loc5_ == 0)
            {
               _loc3_ += SIZE_MarginTop;
            }
            else
            {
               _loc3_ += SIZE_Padding;
            }
            _loc6_ = new TUIImage(this);
            _loc6_.x = _loc2_;
            _loc6_.y = _loc3_;
            _loc6_.buttonMode = true;
            _loc6_.Tag = _loc1_;
            _loc6_.addEventListener(MouseEvent.CLICK,this.IconOnClick,false,0,true);
            this.FImagesExpression[_loc1_] = _loc6_;
            _loc1_++;
         }
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         this.FAnimationSubstrate = SUtilityResource.BtmDataTipsBG;
         this.FZoom9Grid = new TZoom9Grid(this.FAnimationSubstrate.clone());
         this.FZoom9Grid.GridRect = new Rectangle(CONST_COMMON.COORDINATE_ZOOM9GRID_X,CONST_COMMON.COORDINATE_ZOOM9GRID_Y,CONST_COMMON.SIZE_ZOOM9GRID_WIDTH,CONST_COMMON.SIZE_ZOOM9GRID_HEIGHT);
         this.FZoom9Grid.Width = this.FBounds.Width;
         this.FZoom9Grid.Height = this.FBounds.Height;
         if(this.FOvarlaySubstrate.bitmapData != this.FZoom9Grid.ImageData)
         {
            if(this.FOvarlaySubstrate.bitmapData != null)
            {
               this.FOvarlaySubstrate.bitmapData.dispose();
            }
            this.FOvarlaySubstrate.bitmapData = this.FZoom9Grid.ImageData;
         }
      }
      
      protected function ConstructSequences() : void
      {
         this.FSequences = new Vector.<TAnimationSequence>(CAPACITY_Expression);
      }
      
      protected function Initialization() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIImage = null;
         _loc2_ = int(CAPACITY_Expression);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FImagesExpression[_loc1_];
            _loc3_.Sequence = this.FSequences[_loc1_];
            _loc1_++;
         }
         this.FInitialization = true;
      }
      
      protected function IconOnClick(param1:MouseEvent) : void
      {
         var _loc2_:TUIImage = null;
         _loc2_ = param1.currentTarget as TUIImage;
         if(this.FOnIconClick != null)
         {
            this.FOnIconClick(this,_loc2_.Tag);
         }
      }
      
      public function get Count() : int
      {
         return this.FSequences.length;
      }
      
      public function GetSequenceByIndex(param1:int) : TAnimationSequence
      {
         return this.FSequences[param1];
      }
      
      public function SetSequenceByIndex(param1:int, param2:TAnimationSequence) : void
      {
         this.FSequences[param1] = param2;
      }
      
      public function get OnImageClick() : Function
      {
         return this.FOnIconClick;
      }
      
      public function set OnImageClick(param1:Function) : void
      {
         this.FOnIconClick = param1;
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
   }
}

