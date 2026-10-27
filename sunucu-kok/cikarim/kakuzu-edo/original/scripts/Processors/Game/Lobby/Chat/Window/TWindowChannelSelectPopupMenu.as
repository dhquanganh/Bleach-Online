package Processors.Game.Lobby.Chat.Window
{
   import Foundation.Common.*;
   import Foundation.Display.*;
   import Foundation.UI.*;
   import Processors.Game.Utilities.Common.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   
   public class TWindowChannelSelectPopupMenu extends TUIComponent
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
      
      public static const CAPACITY_ChannelLists:uint = CONST_CHAT.CAPACITY_ChannelLists;
      
      public static const CHANNELS_TYPE_LIST:Vector.<uint> = CONST_CHAT.CHANNELS_TYPE_LIST;
      
      public static const POPUPMENUINDEX_World:uint = CONST_CHAT.CHANNEL_LIST_World;
      
      public static const POPUPMENUINDEX_Country:uint = CONST_CHAT.CHANNEL_LIST_Country;
      
      public static const POPUPMENUINDEX_Organization:uint = CONST_CHAT.CHANNEL_LIST_Organization;
      
      public static const POPUPMENUINDEX_Whisper:uint = CONST_CHAT.CHANNEL_LIST_Whisper;
      
      protected var FZoom9Grid:TZoom9Grid;
      
      protected var FResource:Sprite;
      
      protected var FMC_Substrate:Sprite;
      
      protected var FMC_Menus:Vector.<MovieClip>;
      
      protected var FAnimationSubstrate:BitmapData;
      
      protected var FOvarlaySubstrate:Bitmap;
      
      protected var FBounds:TBounds;
      
      protected var FModified:Boolean;
      
      protected var FCurChannelIndex:uint;
      
      protected var FChannelUsable:Vector.<Boolean>;
      
      protected var FChannelsCooling:Vector.<uint>;
      
      protected var FChannelsName:Vector.<String>;
      
      protected var FChannelsCoolingPeriod:Vector.<uint>;
      
      protected var FOnSelect:Function;
      
      public function TWindowChannelSelectPopupMenu(param1:TUIComponent)
      {
         super(param1);
         this.FMC_Menus = new Vector.<MovieClip>(CAPACITY_ChannelLists);
         this.FChannelUsable = new Vector.<Boolean>(CAPACITY_ChannelLists);
         this.FChannelsCooling = new Vector.<uint>(CAPACITY_ChannelLists);
         this.FChannelsName = new Vector.<String>(CAPACITY_ChannelLists);
         this.FChannelsCoolingPeriod = new Vector.<uint>(CAPACITY_ChannelLists);
         this.FBounds = new TBounds();
         this.FBounds.Width = SIZE_MarginLeft + SIZE_Width + SIZE_MarginRight;
         this.FOvarlaySubstrate = new Bitmap();
         this.Visible = false;
         this.FModified = false;
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         this.addChild(this.FResource);
         this.FMC_Substrate = this.FResource[CONST_CHAT.RESOURCE_Link_MC_PopupMenuSubstrate] as Sprite;
         this.FMC_Substrate.addChild(this.FOvarlaySubstrate);
         _loc2_ = int(CAPACITY_ChannelLists);
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
         _loc2_ = int(CAPACITY_ChannelLists);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FChannelUsable[_loc1_];
            _loc3_ = this.FMC_Menus[_loc1_];
            if(_loc4_)
            {
               _loc3_.x = this.FBounds.X;
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
         var _loc4_:uint = 0;
         var _loc5_:MovieClip = null;
         _loc5_ = param1.currentTarget as MovieClip;
         _loc3_ = int(CAPACITY_ChannelLists);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FMC_Menus[_loc2_] == _loc5_)
            {
               _loc4_ = CHANNELS_TYPE_LIST[_loc2_];
               this.FCurChannelIndex = _loc2_;
               if(this.FOnSelect != null)
               {
                  this.FOnSelect(this,_loc4_);
               }
               break;
            }
            _loc2_++;
         }
         this.Visible = false;
      }
      
      public function GetChannelsUsable(param1:int) : Boolean
      {
         return this.FChannelUsable[param1];
      }
      
      public function SetChannelsUsable(param1:int, param2:Boolean) : void
      {
         this.FChannelUsable[param1] = param2;
         this.FModified = true;
      }
      
      public function get GetCurChannelUsable() : Boolean
      {
         return this.FChannelUsable[this.FCurChannelIndex];
      }
      
      public function GetChannelsCooling(param1:int) : uint
      {
         return this.FChannelsCooling[param1];
      }
      
      public function SetChannelsCooling(param1:uint, param2:uint) : void
      {
         this.FChannelsCooling[param1] = param2;
         this.FModified = true;
      }
      
      public function get GetCurChannelCooling() : uint
      {
         return this.FChannelsCooling[this.FCurChannelIndex];
      }
      
      public function get CurChannelsCoolingPeriod() : uint
      {
         return this.FChannelsCoolingPeriod[this.FCurChannelIndex];
      }
      
      public function set CurChannelsCoolingPeriod(param1:uint) : void
      {
         this.FChannelsCoolingPeriod[this.FCurChannelIndex] = param1;
      }
      
      public function GetChannelsName(param1:int) : String
      {
         return this.FChannelsName[param1];
      }
      
      public function SetChannelsName(param1:uint, param2:String) : void
      {
         this.FChannelsName[param1] = param2;
         this.FModified = true;
      }
      
      public function get GetCurChannelName() : String
      {
         return this.FChannelsName[this.FCurChannelIndex];
      }
      
      public function get CurChannelIndex() : uint
      {
         return this.FCurChannelIndex;
      }
      
      public function set CurChannelIndex(param1:uint) : void
      {
         this.FCurChannelIndex = param1;
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

