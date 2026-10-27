package Processors.Game.Lobby.Chat.Window
{
   import Components.Standard.TUITab;
   import Foundation.Common.*;
   import Foundation.Display.*;
   import Foundation.UI.*;
   import Processors.Game.Common.Effects.Display.TEffectBaseGlow;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TWindowChannelFilter extends TUIComponent
   {
      
      protected static const SIZE_Padding:uint = 2;
      
      protected static const SIZE_Width:uint = 33;
      
      public static const CAPACITY_ChannelsFilter:uint = CONST_CHAT.CAPACITY_ChannelsFilter;
      
      public static const CHANNELS_FILTER:Vector.<uint> = CONST_CHAT.CHANNELS_FILTER;
      
      public static const FILTERINDEX_Whisper:uint = CONST_CHAT.CHANNEL_FILTER_TYPE_Whisper;
      
      protected var FResource:Sprite;
      
      protected var FUITab:TUITab;
      
      protected var FEffectsBaseGlow:Vector.<TEffectBaseGlow>;
      
      protected var FCurChannelFilterIndex:uint;
      
      protected var FBounds:TBounds;
      
      protected var FModified:Boolean;
      
      protected var FInitialization:Boolean;
      
      protected var FChannelUsable:Vector.<Boolean>;
      
      protected var FChannelsName:Vector.<String>;
      
      protected var FChannelIsEffect:Vector.<Boolean>;
      
      protected var FOnSelect:Function;
      
      public function TWindowChannelFilter(param1:TUIComponent)
      {
         super(param1);
         this.FEffectsBaseGlow = new Vector.<TEffectBaseGlow>(CAPACITY_ChannelsFilter);
         this.FChannelUsable = new Vector.<Boolean>(CAPACITY_ChannelsFilter);
         this.FChannelsName = new Vector.<String>(CAPACITY_ChannelsFilter);
         this.FChannelIsEffect = new Vector.<Boolean>(CAPACITY_ChannelsFilter);
         this.FBounds = new TBounds();
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TEffectBaseGlow = null;
         this.addChild(this.FResource);
         this.FUITab = new TUITab(this);
         _loc2_ = int(CAPACITY_ChannelsFilter);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FResource[CONST_COMMON.RESOURCE_Link_MC_Tab + _loc1_];
            this.FUITab.SetTabByIndex(_loc3_,_loc1_);
            _loc1_++;
         }
      }
      
      protected function Initialization() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = int(CAPACITY_ChannelsFilter);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FUITab.GetTabByIndex(_loc1_);
            this.FUITab.SetTabCaptionByIndex(this.FChannelsName[_loc1_],_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         this.FInitialization = true;
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
         this.FBounds.Width = 0;
         _loc2_ = int(CAPACITY_ChannelsFilter);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FUITab.GetTabByIndex(_loc1_);
            _loc4_ = this.FChannelUsable[_loc1_];
            if(_loc4_)
            {
               _loc3_.x = this.FBounds.X + this.FBounds.Width;
               _loc3_.y = this.FBounds.Y;
               this.FBounds.Width += SIZE_Width + SIZE_Padding;
            }
            _loc3_.visible = _loc4_;
            _loc1_++;
         }
         this.FModified = false;
      }
      
      protected function UpdateEffectsGlow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:Boolean = false;
         var _loc5_:TEffectBaseGlow = null;
         _loc2_ = int(this.FChannelIsEffect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FChannelIsEffect[_loc1_];
            if(_loc4_)
            {
               if(this.FCurChannelFilterIndex != FILTERINDEX_Whisper)
               {
                  _loc3_ = this.FUITab.GetTabByIndex(_loc1_);
                  if(_loc3_.filters.length == 0)
                  {
                     _loc5_ = new TEffectBaseGlow();
                     _loc5_.SetParameters(_loc3_,8453888,0.7);
                     this.FEffectsBaseGlow[_loc1_] = _loc5_;
                  }
                  _loc5_ = this.FEffectsBaseGlow[_loc1_];
                  _loc5_.Run();
               }
            }
            _loc1_++;
         }
      }
      
      protected function TerminationButtonEffect() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:TEffectBaseGlow = null;
         _loc1_ = this.FChannelIsEffect[this.FCurChannelFilterIndex];
         if(_loc1_)
         {
            this.FChannelIsEffect[this.FCurChannelFilterIndex] = false;
            _loc2_ = this.FEffectsBaseGlow[this.FCurChannelFilterIndex];
            _loc2_.Stop();
            this.FEffectsBaseGlow.splice(this.FCurChannelFilterIndex,1);
            _loc2_.Dispose();
            _loc2_ = null;
         }
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         var _loc2_:uint = 0;
         this.FCurChannelFilterIndex = param1 as int;
         this.TerminationButtonEffect();
         _loc2_ = CHANNELS_FILTER[this.FCurChannelFilterIndex];
         if(this.FOnSelect != null)
         {
            this.FOnSelect(this,_loc2_);
         }
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
         return this.FChannelUsable[this.FCurChannelFilterIndex];
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
         return this.FChannelsName[this.FCurChannelFilterIndex];
      }
      
      public function GetChannelsIsEffect(param1:int) : Boolean
      {
         return this.FChannelIsEffect[param1];
      }
      
      public function SetChannelsIsEffect(param1:uint, param2:Boolean) : void
      {
         this.FChannelIsEffect[param1] = param2;
      }
      
      public function set SwithTabByIndex(param1:int) : void
      {
         this.FUITab.SwithTagManual(param1);
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
         this.EvaluationPerform_Context();
         this.UpdateEffectsGlow();
      }
   }
}

