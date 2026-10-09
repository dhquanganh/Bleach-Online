package
{
   import Logics.Agent.SParametersCore;
   import Logics.Agent.Spaces.ParametersSpace;
   import Processors_Mini.Accessories.TProcessorMiniLoad;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageQuality;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.system.Security;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import ǵ.Ǵ;
   
   use namespace ParametersSpace;
   
   [SWF(width="1250", height="650", backgroundColor="#000000", frameRate="30")]
   public class TMain extends MovieClip
   {
      
      public static const Ȏ:uint = 30;
      
      protected var ǿ:TProcessorMiniLoad;
      
      protected var Ȁ:Ǵ;
      
      protected var ȁ:Object;
      
      protected var Ȃ:Boolean;
      
      protected var ȃ:Boolean;
      
      protected var Ȅ:uint;
      
      public function TMain()
      {
         super();
         if(stage != null)
         {
            this.ȅ();
         }
         addEventListener(Event.ADDED,this.ȋ);
         addEventListener(Event.ENTER_FRAME,this.Ȍ);
      }
      
      protected function ȅ() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = 0;
         var _loc3_:DisplayObject = null;
         _loc1_ = this.numChildren;
         _loc2_ = int(_loc1_ - 1);
         while(_loc2_ >= 0)
         {
            this.removeChildAt(_loc2_);
            _loc2_--;
         }
      }
      
      protected function Ȇ() : void
      {
         this.ȇ(root.loaderInfo.parameters);
         this.Ȉ();
         this.ȉ();
         this.Ȃ = true;
      }
      
      protected function ȇ(param1:Object) : void
      {
         if(!this.ȃ)
         {
            Security.allowDomain("*");
            SParametersCore.CoerceProperties(param1);
            this.ȁ = param1;
            this.ȃ = true;
         }
      }
      
      protected function Ȉ() : void
      {
         stage.align = StageAlign.TOP_LEFT;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.quality = StageQuality.BEST;
         stage.frameRate = Ȏ;
         this.Ȁ = new Ǵ();
         this.contextMenu = this.Ȁ.Ȝ;
         stage.showDefaultContextMenu = false;
      }
      
      protected function ȉ() : void
      {
         this.ǿ = new TProcessorMiniLoad();
         this.ǿ.OnLoadingCompleted = this.ȍ;
         stage.addChild(this.ǿ);
      }
      
      protected function Ȋ() : void
      {
         clearTimeout(this.Ȅ);
         if(this.ǿ.parent != null)
         {
            this.ǿ.parent.removeChild(this.ǿ);
         }
         this.ǿ.Dispose();
         this.ǿ = null;
         this.Ȁ.Dispose();
         this.Ȁ = null;
      }
      
      protected function ȋ(param1:Event) : void
      {
         this.ȅ();
      }
      
      protected function Ȍ(param1:Event) : void
      {
         if(stage == null)
         {
            return;
         }
         if(!this.Ȃ)
         {
            this.Ȇ();
         }
         if(this.Ȃ)
         {
            removeEventListener(Event.ENTER_FRAME,this.Ȍ);
         }
      }
      
      protected function ȍ(param1:Object, param2:Object) : void
      {
         var _loc3_:* = undefined;
         _loc3_ = param2 as Sprite;
         stage.addChild(_loc3_);
         this.Ȅ = setTimeout(this.Ȋ,3000);
         removeEventListener(Event.ADDED,this.ȋ);
         removeEventListener(Event.ENTER_FRAME,this.Ȍ);
      }
   }
}

