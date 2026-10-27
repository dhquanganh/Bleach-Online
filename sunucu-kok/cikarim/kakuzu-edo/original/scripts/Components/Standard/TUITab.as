package Components.Standard
{
   import Foundation.UI.*;
   import Processors.Game.Common.Effects.Display.TEffectBaseGlowTwo;
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUITab extends TUIComponent
   {
      
      protected static const RENDERINGSTATE_Select:int = 1;
      
      protected static const RENDERINGSTATE_UnSelect:int = 2;
      
      protected static const RENDERINGSTATE_Hovering:int = 3;
      
      protected static const RENDERINGSTATE_Disabled:int = 4;
      
      protected static const DEFAULT_FilterColor:uint = 16776960;
      
      protected static const RESOURCE_Link_TF_Caption:String = "TF_Caption";
      
      protected static const FilterGlowWidth:int = 4;
      
      protected static const FilterGlowStrength:int = 20;
      
      protected var FTabs:Vector.<MovieClip>;
      
      protected var FGlowsFilter:Vector.<TEffectBaseGlowTwo>;
      
      protected var FCaption:String;
      
      protected var FTabIndexPressed:int;
      
      protected var FInitialization:Boolean;
      
      protected var FTabIndex:int;
      
      protected var FOnSwitch:Function;
      
      protected var FOnOver:Function;
      
      protected var FOnOut:Function;
      
      protected var FFilterColor:uint;
      
      public function TUITab(param1:TUIComponent)
      {
         super(param1);
         this.FTabs = new Vector.<MovieClip>();
         this.FGlowsFilter = new Vector.<TEffectBaseGlowTwo>();
         this.FCaption = "";
         this.FTabIndex = -1;
         this.FTabIndexPressed = -1;
         this.FFilterColor = DEFAULT_FilterColor;
         this.FInitialization = false;
      }
      
      protected function Initialization() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TEffectBaseGlowTwo = null;
         _loc2_ = int(this.FTabs.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FTabs[_loc1_];
            _loc3_.addEventListener(MouseEvent.CLICK,this.TabOnClick,false,0,true);
            _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.TabOnOver,false,0,true);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.TabOnOut,false,0,true);
            _loc3_.addEventListener(MouseEvent.MOUSE_DOWN,this.TabOnDown,false,0,true);
            if(_loc1_ == 0)
            {
               this.FTabIndex = 0;
               _loc3_.gotoAndStop(RENDERINGSTATE_Select);
            }
            else
            {
               _loc3_.gotoAndStop(RENDERINGSTATE_UnSelect);
            }
            _loc4_ = new TEffectBaseGlowTwo();
            _loc4_.SetParameters(_loc3_,this.FFilterColor,FilterGlowWidth,FilterGlowStrength);
            this.FGlowsFilter.push(_loc4_);
            _loc1_++;
         }
         this.FInitialization = true;
      }
      
      protected function UpdateBinding(param1:int) : void
      {
      }
      
      protected function SwitchTab(param1:int) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = this.FTabs[this.FTabIndex];
         if(_loc2_.currentFrame != RENDERINGSTATE_Disabled)
         {
            _loc2_.buttonMode = true;
            _loc2_.gotoAndStop(RENDERINGSTATE_UnSelect);
         }
         _loc2_ = this.FTabs[param1];
         _loc2_.buttonMode = false;
         _loc2_.gotoAndStop(RENDERINGSTATE_Select);
         this.FTabIndex = param1;
         if(this.FOnSwitch != null)
         {
            this.FOnSwitch(this.FTabIndex);
         }
      }
      
      protected function TabOnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc3_ = param1.currentTarget as MovieClip;
         _loc2_ = this.FTabs.indexOf(_loc3_);
         if(_loc3_.currentFrame == RENDERINGSTATE_Disabled)
         {
            return;
         }
         this.SwitchTab(_loc2_);
      }
      
      protected function TabOnOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:Boolean = false;
         _loc3_ = param1.currentTarget as MovieClip;
         if(_loc3_.currentFrame == RENDERINGSTATE_UnSelect)
         {
            _loc3_.gotoAndStop(RENDERINGSTATE_Hovering);
         }
         if(_loc3_.currentFrame == RENDERINGSTATE_Disabled)
         {
            _loc4_ = false;
         }
         else
         {
            _loc4_ = true;
         }
         _loc2_ = this.FTabs.indexOf(_loc3_);
         if(this.FOnOver != null)
         {
            this.FOnOver(this,_loc2_,_loc4_);
         }
      }
      
      protected function TabOnOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:Boolean = false;
         _loc3_ = param1.currentTarget as MovieClip;
         if(_loc3_ != this.FTabs[this.FTabIndex])
         {
            if(_loc3_.currentFrame == RENDERINGSTATE_Disabled)
            {
               _loc3_.gotoAndStop(RENDERINGSTATE_Disabled);
            }
            else
            {
               _loc3_.gotoAndStop(RENDERINGSTATE_UnSelect);
            }
         }
         else
         {
            _loc3_.gotoAndStop(RENDERINGSTATE_Select);
         }
         if(_loc3_.currentFrame == RENDERINGSTATE_Disabled)
         {
            _loc4_ = false;
         }
         else
         {
            _loc4_ = true;
         }
         _loc2_ = this.FTabs.indexOf(_loc3_);
         if(this.FOnOut != null)
         {
            this.FOnOut(this,_loc2_,_loc4_);
         }
      }
      
      protected function TabOnDown(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc3_ = param1.currentTarget as MovieClip;
         if(_loc3_.currentFrame == RENDERINGSTATE_Disabled)
         {
            return;
         }
         if(_loc3_ != this.FTabs[this.FTabIndex])
         {
            _loc3_.gotoAndStop(RENDERINGSTATE_UnSelect);
         }
         else
         {
            _loc3_.gotoAndStop(RENDERINGSTATE_Select);
         }
      }
      
      public function get Count() : int
      {
         return this.FTabs.length;
      }
      
      public function SetTabCaptionByIndex(param1:String, param2:int, param3:uint = 0) : void
      {
         var _loc4_:TextField = null;
         _loc4_ = this.FTabs[param2][RESOURCE_Link_TF_Caption] as TextField;
         this.FCaption = param1;
         if(_loc4_ != null)
         {
            _loc4_.text = param1;
            if(param3 != 0)
            {
               _loc4_.textColor = param3;
            }
            _loc4_.mouseEnabled = false;
         }
      }
      
      public function SetTabCanClickByIndex(param1:int) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = this.FTabs[param1];
         _loc2_.gotoAndStop(RENDERINGSTATE_UnSelect);
      }
      
      public function SetTabEnabledByIndex(param1:int, param2:Boolean, param3:Boolean = false) : void
      {
         var _loc4_:MovieClip = null;
         _loc4_ = this.FTabs[param1];
         if(param2)
         {
            if(!_loc4_.hasEventListener(MouseEvent.CLICK))
            {
               _loc4_.addEventListener(MouseEvent.CLICK,this.TabOnClick,false,0,true);
            }
            if(!_loc4_.hasEventListener(MouseEvent.MOUSE_MOVE))
            {
               _loc4_.addEventListener(MouseEvent.MOUSE_MOVE,this.TabOnOver,false,0,true);
            }
            if(!_loc4_.hasEventListener(MouseEvent.MOUSE_OUT))
            {
               _loc4_.addEventListener(MouseEvent.MOUSE_OUT,this.TabOnOut,false,0,true);
            }
            if(!_loc4_.hasEventListener(MouseEvent.MOUSE_DOWN))
            {
               _loc4_.addEventListener(MouseEvent.MOUSE_DOWN,this.TabOnDown,false,0,true);
            }
            _loc4_.gotoAndStop(RENDERINGSTATE_UnSelect);
            _loc4_.buttonMode = true;
         }
         else
         {
            if(_loc4_.hasEventListener(MouseEvent.CLICK))
            {
               _loc4_.removeEventListener(MouseEvent.CLICK,this.TabOnClick);
            }
            if(_loc4_.hasEventListener(MouseEvent.MOUSE_DOWN))
            {
               _loc4_.removeEventListener(MouseEvent.MOUSE_DOWN,this.TabOnDown);
            }
            if(!param3)
            {
               if(_loc4_.hasEventListener(MouseEvent.MOUSE_MOVE))
               {
                  _loc4_.removeEventListener(MouseEvent.MOUSE_MOVE,this.TabOnOver);
               }
               if(_loc4_.hasEventListener(MouseEvent.MOUSE_OUT))
               {
                  _loc4_.removeEventListener(MouseEvent.MOUSE_OUT,this.TabOnOut);
               }
            }
            _loc4_.gotoAndStop(RENDERINGSTATE_Disabled);
            _loc4_.buttonMode = false;
         }
      }
      
      public function GetTabByIndex(param1:int) : MovieClip
      {
         return this.FTabs[param1];
      }
      
      public function SetTabByIndex(param1:MovieClip, param2:int) : void
      {
         if(param1 != null)
         {
            param1.mouseChildren = false;
         }
         this.FTabs[param2] = param1;
      }
      
      public function SetTabShowByIndex(param1:int) : void
      {
         this.FTabs[param1].visible = true;
      }
      
      public function SetTabHideByIndex(param1:int) : void
      {
         this.FTabs[param1].visible = false;
      }
      
      public function SetTabToTopByIndex(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:DisplayObjectContainer = null;
         _loc3_ = this.FTabs[0].parent;
         _loc2_ = 0;
         while(_loc2_ < this.FTabs.length)
         {
            _loc3_.addChildAt(this.FTabs[_loc2_],0);
            _loc2_++;
         }
         _loc3_.addChild(this.FTabs[param1]);
      }
      
      public function get TabIndex() : int
      {
         return this.FTabIndex;
      }
      
      public function set TabIndex(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         if(this.FTabIndex != param1)
         {
            this.FTabIndex = param1;
            _loc3_ = int(this.FTabs.length);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc4_ = this.FTabs[_loc2_];
               _loc4_.gotoAndStop(RENDERINGSTATE_UnSelect);
               _loc2_++;
            }
            _loc4_ = this.FTabs[param1];
            _loc4_.gotoAndStop(RENDERINGSTATE_Select);
         }
      }
      
      public function get OnSwitch() : Function
      {
         return this.FOnSwitch;
      }
      
      public function set OnSwitch(param1:Function) : void
      {
         this.FOnSwitch = param1;
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
      
      public function get FilterColor() : uint
      {
         return this.FFilterColor;
      }
      
      public function set FilterColor(param1:uint) : void
      {
         this.FFilterColor = param1;
      }
      
      public function Init() : void
      {
         if(this.FInitialization)
         {
            return;
         }
         this.Initialization();
      }
      
      override public function Dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TEffectBaseGlowTwo = null;
         Vector.<MovieClip>; //unpopped
         Vector.<TEffectBaseGlowTwo>; //unpopped
         _loc2_ = int(this.FTabs.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FGlowsFilter[_loc1_];
            _loc4_.Dispose();
            _loc4_ = null;
            _loc3_ = this.FTabs[_loc1_];
            _loc3_.removeEventListener(MouseEvent.CLICK,this.TabOnClick);
            _loc3_.removeEventListener(MouseEvent.MOUSE_MOVE,this.TabOnOver);
            _loc3_.removeEventListener(MouseEvent.MOUSE_OUT,this.TabOnOut);
            _loc3_.removeEventListener(MouseEvent.MOUSE_DOWN,this.TabOnDown);
            _loc1_++;
         }
         this.FGlowsFilter.length = 0;
         this.FTabs.length = 0;
         this.FCaption = "";
         this.FCaption = null;
         this.FOnSwitch = null;
         this.FOnOver = null;
         this.FOnOut = null;
         if(this.Parent != null)
         {
            this.Parent.removeChild(this);
         }
      }
      
      public function Clear() : void
      {
         this.FTabs.length = 0;
      }
      
      public function Reset() : void
      {
         this.SwitchTab(0);
      }
      
      public function SwithTagManual(param1:int) : void
      {
         this.SwitchTab(param1);
      }
      
      public function StartTabShowGlowByIndex(param1:int) : void
      {
         this.FGlowsFilter[param1].IsRunOver = false;
      }
      
      public function StopTabShowGlowByIndex(param1:int) : void
      {
         this.FGlowsFilter[param1].Stop();
      }
      
      public function StopGlow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TEffectBaseGlowTwo = null;
         _loc1_ = 0;
         while(_loc1_ < this.FGlowsFilter.length)
         {
            this.StopTabShowGlowByIndex(_loc1_);
            _loc1_++;
         }
      }
      
      public function Update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TEffectBaseGlowTwo = null;
         _loc1_ = 0;
         while(_loc1_ < this.FGlowsFilter.length)
         {
            _loc2_ = this.FGlowsFilter[_loc1_];
            if(!_loc2_.IsRunOver)
            {
               _loc2_.Run();
            }
            _loc1_++;
         }
      }
   }
}

