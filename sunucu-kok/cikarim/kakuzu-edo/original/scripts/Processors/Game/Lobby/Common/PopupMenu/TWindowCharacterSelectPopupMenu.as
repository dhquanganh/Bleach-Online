package Processors.Game.Lobby.Common.PopupMenu
{
   import Foundation.Common.*;
   import Foundation.Display.*;
   import Foundation.UI.*;
   import Processors.Game.Utilities.Common.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   
   public class TWindowCharacterSelectPopupMenu extends TUIComponent
   {
      
      protected static const RENDERINGSTATE_Hovering:int = 2;
      
      protected static const RENDERINGSTATE_Normal:int = 1;
      
      protected static const COORDINATE_X:uint = 5;
      
      protected static const COORDINATE_Y:uint = 4;
      
      protected static const SIZE_Width:uint = 62;
      
      protected static const SIZE_Height:uint = 19;
      
      protected static const SIZE_Padding:uint = 1;
      
      protected static const SIZE_MarginLeft:uint = 5;
      
      protected static const SIZE_MarginTop:uint = 5;
      
      protected static const SIZE_MarginRight:uint = 5;
      
      protected static const SIZE_MarginBottom:uint = 5;
      
      public static const CAPACITY_CharacterSelect:uint = CONST_CHAT.CAPACITY_CharacterSelect;
      
      public static const POPUPMENUINDEX_View:uint = CONST_CHAT.CHARACTER_SELECT_View;
      
      public static const POPUPMENUINDEX_Achievement:uint = CONST_CHAT.CHARACTER_SELECT_Achievement;
      
      public static const POPUPMENUINDEX_Whisper:uint = CONST_CHAT.CHARACTER_SELECT_Whisper;
      
      public static const POPUPMENUINDEX_CopyName:uint = CONST_CHAT.CHARACTER_SELECT_CopyName;
      
      public static const POPUPMENUINDEX_Friend:uint = CONST_CHAT.CHARACTER_SELECT_Friend;
      
      public static const POPUPMENUINDEX_Shield:uint = CONST_CHAT.CHARACTER_SELECT_Shield;
      
      protected var FZoom9Grid:TZoom9Grid;
      
      protected var FResource:Sprite;
      
      protected var FMC_Substrate:Sprite;
      
      protected var FMC_Menus:Vector.<MovieClip>;
      
      protected var FAnimationSubstrate:BitmapData;
      
      protected var FOvarlaySubstrate:Bitmap;
      
      protected var FBounds:TBounds;
      
      protected var FModified:Boolean;
      
      protected var FCurSelectIndex:uint;
      
      protected var FMenuUsable:Vector.<Boolean>;
      
      protected var FOnSelect:Function;
      
      public function TWindowCharacterSelectPopupMenu(param1:TUIComponent)
      {
         super(param1);
         this.FMC_Menus = new Vector.<MovieClip>(CAPACITY_CharacterSelect);
         this.FMenuUsable = new Vector.<Boolean>(CAPACITY_CharacterSelect);
         this.FBounds = new TBounds();
         this.FBounds.Width = SIZE_MarginLeft + SIZE_Width + SIZE_MarginRight;
         if(false)
         {
            this.FBounds.Width += 28;
         }
         this.FOvarlaySubstrate = new Bitmap();
         this.FModified = false;
         this.Visible = false;
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         this.addChild(this.FResource);
         this.FMC_Substrate = this.FResource[CONST_CHAT.RESOURCE_Link_MC_PopupMenuSubstrate] as Sprite;
         this.FMC_Substrate.addChild(this.FOvarlaySubstrate);
         _loc2_ = int(CAPACITY_CharacterSelect);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FResource[CONST_CHAT.RESOURCE_Link_MC_Menus + _loc1_] as MovieClip;
            _loc3_.buttonMode = true;
            _loc3_.gotoAndStop(RENDERINGSTATE_Normal);
            _loc3_.addEventListener(MouseEvent.MOUSE_OVER,this.BtnOnOver,false,0,true);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.BtnOnOut,false,0,true);
            _loc3_.addEventListener(MouseEvent.CLICK,this.BtnOnClick,false,0,true);
            this.FMC_Menus[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.FAnimationSubstrate = SUtilityResource.BtmDataTipsBG;
         this.FZoom9Grid = new TZoom9Grid(this.FAnimationSubstrate.clone());
         this.FZoom9Grid.GridRect = new Rectangle(CONST_COMMON.COORDINATE_ZOOM9GRID_X,CONST_COMMON.COORDINATE_ZOOM9GRID_Y,CONST_COMMON.SIZE_ZOOM9GRID_WIDTH,CONST_COMMON.SIZE_ZOOM9GRID_HEIGHT);
      }
      
      protected function EvaluationPerform_Context() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:Boolean = false;
         if(!this.FModified)
         {
            return;
         }
         this.FBounds.X = COORDINATE_X;
         this.FBounds.Y = COORDINATE_Y;
         this.FBounds.Height = SIZE_MarginTop;
         _loc2_ = int(CAPACITY_CharacterSelect);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FMenuUsable[_loc1_];
            _loc3_ = this.FMC_Menus[_loc1_];
            if(_loc4_)
            {
               _loc3_.x = this.FBounds.X;
               if(false)
               {
                  _loc3_.x -= 10;
               }
               _loc3_.y = this.FBounds.Y + this.FBounds.Height;
               this.FBounds.Height += SIZE_Height + SIZE_Padding;
            }
            _loc3_.visible = _loc4_;
            _loc1_++;
         }
         this.FBounds.Height += SIZE_MarginBottom + 5 + SIZE_Padding * (_loc1_ + 1);
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
         this.FModified = false;
      }
      
      protected function BtnOnOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         _loc2_.gotoAndStop(RENDERINGSTATE_Hovering);
      }
      
      protected function BtnOnOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         _loc2_.gotoAndStop(RENDERINGSTATE_Normal);
      }
      
      protected function BtnOnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         _loc4_ = param1.currentTarget as MovieClip;
         _loc3_ = int(CAPACITY_CharacterSelect);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FMC_Menus[_loc2_] == _loc4_)
            {
               this.FCurSelectIndex = _loc2_;
               if(this.FOnSelect != null)
               {
                  this.FOnSelect(this,_loc2_);
               }
               break;
            }
            _loc2_++;
         }
         this.Visible = false;
      }
      
      public function GetMenuUsable(param1:int) : Boolean
      {
         return this.FMenuUsable[param1];
      }
      
      public function SetMenuUsable(param1:int, param2:Boolean) : void
      {
         this.FMenuUsable[param1] = param2;
         this.FModified = true;
      }
      
      public function get GetCurMenuUsable() : Boolean
      {
         return this.FMenuUsable[this.FCurSelectIndex];
      }
      
      public function get CurSelectIndex() : uint
      {
         return this.FCurSelectIndex;
      }
      
      public function set CurSelectIndex(param1:uint) : void
      {
         this.FCurSelectIndex = param1;
      }
      
      public function get OnSelect() : Function
      {
         return this.FOnSelect;
      }
      
      public function set OnSelect(param1:Function) : void
      {
         this.FOnSelect = param1;
      }
      
      public function SetSequenceButton(param1:Sprite) : void
      {
         this.FResource = param1;
         this.ResourcesPerform_UIDispatch();
      }
      
      public function Update() : void
      {
         this.EvaluationPerform_Context();
      }
   }
}

