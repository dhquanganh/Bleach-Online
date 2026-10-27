package ghostcat.util.easing
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.filters.BlurFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.media.SoundTransform;
   import ghostcat.events.TickEvent;
   import ghostcat.util.MathUtil;
   import ghostcat.util.Tick;
   import ghostcat.util.core.Handler;
   import ghostcat.util.display.ColorUtil;
   
   public class TweenUtil extends EventDispatcher
   {
      
      private static var effects:Array = [];
      
      public static var enabledRelativeValue:Boolean = true;
      
      public static var updateWithCurrentTime:Boolean = false;
      
      public static var enabledDispatchEvent:Boolean = true;
      
      Tick.instance.addEventListener(TickEvent.TICK,tickHandler);
      
      public var invert:Boolean = false;
      
      public var started:Boolean = false;
      
      public var paused:Boolean = false;
      
      public var target:*;
      
      public var currentTime:int;
      
      public var duration:int;
      
      public var ease:Function;
      
      public var lockInv:int;
      
      public var fromValues:Object = new Object();
      
      public var toValues:Object = new Object();
      
      public var onStart:Function;
      
      public var onUpdate:Function;
      
      public var onComplete:Function;
      
      public var renderOnStart:Boolean = true;
      
      public var enabledDispatchEvent:Boolean = true;
      
      public function TweenUtil(param1:Object, param2:int, param3:Object, param4:Boolean = true)
      {
         var _loc5_:String = null;
         var _loc6_:ColorTransform = null;
         var _loc7_:Object = null;
         this.target = this.target;
         super();
         if(!param3)
         {
            param3 = new Object();
         }
         this.target = param1;
         this.duration = param2;
         this.enabledDispatchEvent = TweenUtil.enabledDispatchEvent;
         for(_loc5_ in param3)
         {
            switch(_loc5_)
            {
               case "ease":
               case "invert":
               case "lockInv":
               case "renderOnStart":
               case "onStart":
               case "onUpdate":
               case "onComplete":
               case "enabledDispatchEvent":
                  this[_loc5_] = param3[_loc5_];
                  break;
               case "onStartHandler":
                  this.addEventListener(TweenEvent.TWEEN_START,param3[_loc5_],false,0,true);
                  break;
               case "onUpdateHandler":
                  this.addEventListener(TweenEvent.TWEEN_UPDATE,param3[_loc5_],false,0,true);
                  break;
               case "onCompleteHandler":
                  this.addEventListener(TweenEvent.TWEEN_END,param3[_loc5_],false,0,true);
                  break;
               case "delay":
                  this.currentTime = -param3[_loc5_];
                  break;
               case "volume":
               case "pan":
                  if(param1.hasOwnProperty("soundTransform"))
                  {
                     this.fromValues[_loc5_] = param1["soundTransform"][_loc5_];
                  }
                  else
                  {
                     this.fromValues[_loc5_] = param1[_loc5_];
                  }
                  this.toValues[_loc5_] = param3[_loc5_];
                  break;
               case "frame":
                  this.fromValues[_loc5_] = (param1 as MovieClip).currentFrame;
                  this.toValues[_loc5_] = param3[_loc5_];
                  break;
               case "tint":
                  this.fromValues[_loc5_] = (param1 as DisplayObject).transform.colorTransform.color & 0xFFFFFF;
                  this.toValues[_loc5_] = param3[_loc5_];
                  break;
               case "tint2":
                  _loc6_ = (param1 as DisplayObject).transform.colorTransform;
                  this.fromValues[_loc5_] = _loc6_.redOffset << 16 | _loc6_.greenOffset << 8 | _loc6_.blueOffset;
                  this.toValues[_loc5_] = param3[_loc5_];
                  break;
               case "autoAlpha":
                  this.fromValues[_loc5_] = (param1 as DisplayObject).alpha;
                  this.toValues[_loc5_] = param3[_loc5_];
                  break;
               case "dynamicPoint":
               case "motionBlur":
                  this.fromValues[_loc5_] = new Point((param1 as DisplayObject).x,(param1 as DisplayObject).y);
                  this.toValues[_loc5_] = param3[_loc5_];
                  break;
               case "startAt":
                  break;
               default:
                  this.fromValues[_loc5_] = param1[_loc5_];
                  this.toValues[_loc5_] = param3[_loc5_];
            }
            if(enabledRelativeValue && this.toValues[_loc5_] is String)
            {
               this.toValues[_loc5_] = this.fromValues[_loc5_] + Number(this.toValues[_loc5_]);
            }
         }
         if(param3.hasOwnProperty("startAt"))
         {
            _loc7_ = param3["startAt"];
            for(_loc5_ in _loc7_)
            {
               this.fromValues[_loc5_] = _loc7_[_loc5_];
            }
         }
         if(this.ease == null)
         {
            this.ease = Linear.easeOut;
         }
         if(param4)
         {
            this.effects.push(this);
         }
      }
      
      public static function callLater(param1:Function, param2:Array = null, param3:int = 0) : void
      {
         new TweenUtil({},param3,{"onComplete":new Handler(param1,param2).toFunction()});
      }
      
      public static function to(param1:Object, param2:int, param3:Object) : TweenUtil
      {
         return new TweenUtil(param1,param2,param3);
      }
      
      public static function from(param1:Object, param2:int, param3:Object) : TweenUtil
      {
         param3.invert = true;
         return new TweenUtil(param1,param2,param3);
      }
      
      public static function test(param1:Object, param2:int, param3:Object, param4:String, param5:int) : TweenUtil
      {
         return new TweenUtil(param1,param2,param3,false);
      }
      
      private static function tickHandler(param1:TickEvent) : void
      {
         update(param1.interval);
      }
      
      public static function update(param1:int = 0) : void
      {
         var _loc3_:TweenUtil = null;
         var _loc2_:* = int(effects.length - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = effects[_loc2_] as TweenUtil;
            if(_loc3_)
            {
               _loc3_.update(param1);
            }
            _loc2_--;
         }
      }
      
      public static function getTween(param1:Object) : Array
      {
         var _loc3_:TweenUtil = null;
         var _loc2_:Array = [];
         for each(_loc3_ in effects)
         {
            if(_loc3_.target == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public static function pauseTween(param1:Object, param2:Boolean = true) : void
      {
         var _loc3_:TweenUtil = null;
         for each(_loc3_ in effects)
         {
            if(_loc3_.target == param1)
            {
               _loc3_.paused = true;
            }
         }
         if(param2)
         {
            update();
         }
      }
      
      public static function continueTween(param1:Object) : void
      {
         var _loc2_:TweenUtil = null;
         for each(_loc2_ in effects)
         {
            if(_loc2_.target == param1)
            {
               _loc2_.paused = false;
            }
         }
      }
      
      public static function removeTween(param1:Object, param2:Boolean = true) : void
      {
         var _loc4_:TweenUtil = null;
         var _loc3_:* = int(effects.length - 1);
         while(_loc3_ >= 0)
         {
            _loc4_ = effects[_loc3_] as TweenUtil;
            if(_loc4_.target == param1)
            {
               if(param2)
               {
                  _loc4_.duration = 0;
               }
               else
               {
                  effects.splice(_loc3_,1);
               }
            }
            _loc3_--;
         }
         if(param2)
         {
            update();
         }
      }
      
      public static function removeAllTween(param1:Boolean = true) : void
      {
         var _loc2_:TweenUtil = null;
         if(param1)
         {
            for each(_loc2_ in effects)
            {
               _loc2_.duration = 0;
            }
            update();
         }
         else
         {
            effects = [];
         }
      }
      
      public static function hasTween(param1:Object, param2:String = null) : Boolean
      {
         var _loc3_:TweenUtil = null;
         for each(_loc3_ in getTween(param1))
         {
            if(_loc3_.toValues.hasOwnProperty(param2))
            {
               return true;
            }
         }
         return false;
      }
      
      protected function get effects() : Array
      {
         return TweenUtil.effects;
      }
      
      public function update(param1:int = 0) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         if(this.lockInv)
         {
            param1 = this.lockInv;
         }
         if(this.invert && this.renderOnStart)
         {
            for(_loc2_ in this.toValues)
            {
               this.updateValue(_loc2_,this.toValues[_loc2_]);
            }
            this.renderOnStart = false;
         }
         if(this.paused)
         {
            return;
         }
         this.currentTime += param1;
         if(this.currentTime < 0)
         {
            return;
         }
         if(!this.started)
         {
            this.started = true;
            if(this.onStart != null)
            {
               this.onStart();
            }
            if(this.enabledDispatchEvent)
            {
               this.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_START));
            }
         }
         if(this.currentTime >= this.duration)
         {
            for(_loc2_ in this.toValues)
            {
               this.updateValue(_loc2_,this.invert ? this.fromValues[_loc2_] : this.toValues[_loc2_]);
            }
         }
         else
         {
            for(_loc2_ in this.toValues)
            {
               _loc3_ = this.invert ? int(this.duration - this.currentTime) : this.currentTime;
               _loc4_ = this.calculateValue(_loc3_,_loc2_);
               this.updateValue(_loc2_,_loc4_);
            }
         }
         if(this.onUpdate != null)
         {
            if(updateWithCurrentTime)
            {
               this.onUpdate(this.currentTime / this.duration);
            }
            else
            {
               this.onUpdate();
            }
         }
         if(this.enabledDispatchEvent)
         {
            this.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_UPDATE));
         }
         if(this.currentTime >= this.duration)
         {
            if(this.toValues.hasOwnProperty("motionBlur"))
            {
               (this.target as DisplayObject).filters = [];
            }
            _loc5_ = this.effects.indexOf(this);
            if(_loc5_ != -1)
            {
               this.effects.splice(this.effects.indexOf(this),1);
            }
            if(this.onComplete != null)
            {
               this.onComplete();
            }
            if(this.enabledDispatchEvent)
            {
               this.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_END));
            }
         }
      }
      
      public function calculateValue(param1:int, param2:String) : *
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc3_:* = this.fromValues[param2];
         var _loc4_:* = this.toValues[param2];
         if(_loc3_ is Point)
         {
            return new Point(this.ease(param1,_loc3_.x,_loc4_.x - _loc3_.x,this.duration),this.ease(param1,_loc3_.y,_loc4_.y - _loc3_.y,this.duration));
         }
         if(_loc3_ is Rectangle)
         {
            return new Rectangle(this.ease(param1,_loc3_.x,_loc4_.x - _loc3_.x,this.duration),this.ease(param1,_loc3_.y,_loc4_.y - _loc3_.y,this.duration),this.ease(param1,_loc3_.width,_loc4_.width - _loc3_.width,this.duration),this.ease(param1,_loc3_.height,_loc4_.height - _loc3_.height,this.duration));
         }
         if(_loc3_ is Array)
         {
            _loc5_ = [];
            _loc6_ = 0;
            while(_loc6_ < _loc3_.length)
            {
               _loc5_.push(this.ease(param1,_loc3_[_loc6_],_loc4_[_loc6_] - _loc3_[_loc6_],this.duration));
               _loc6_++;
            }
            return _loc5_;
         }
         if(param2 == "tint" || param2 == "tint2")
         {
            _loc7_ = _loc3_ >> 16 & 0xFF;
            _loc8_ = _loc3_ >> 8 & 0xFF;
            _loc9_ = _loc3_ & 0xFF;
            _loc10_ = _loc4_ >> 16 & 0xFF;
            _loc11_ = _loc4_ >> 8 & 0xFF;
            _loc12_ = _loc4_ & 0xFF;
            _loc13_ = MathUtil.limitIn(this.ease(param1,_loc7_,_loc10_ - _loc7_,this.duration),0,255);
            _loc14_ = MathUtil.limitIn(this.ease(param1,_loc8_,_loc11_ - _loc8_,this.duration),0,255);
            _loc15_ = MathUtil.limitIn(this.ease(param1,_loc9_,_loc12_ - _loc9_,this.duration),0,255);
            return ColorUtil.RGB(_loc13_,_loc14_,_loc15_);
         }
         return this.ease(param1,_loc3_,_loc4_ - _loc3_,this.duration);
      }
      
      protected function updateValue(param1:String, param2:*) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:Point = null;
         var _loc5_:SoundTransform = null;
         _loc3_ = this.target as DisplayObject;
         switch(param1)
         {
            case "volume":
            case "pan":
               if(this.target.hasOwnProperty("soundTransform"))
               {
                  _loc5_ = this.target["soundTransform"];
                  _loc5_[param1] = param2;
                  this.target["soundTransform"] = _loc5_;
               }
               else
               {
                  this.target[param1] = param2;
               }
               break;
            case "autoAlpha":
               _loc3_.alpha = param2;
               _loc3_.visible = param2 > 0;
               break;
            case "frame":
               (this.target as MovieClip).gotoAndStop(int(param2));
               break;
            case "tint":
               _loc3_.transform.colorTransform = ColorUtil.getColorTransform(param2 as uint);
               break;
            case "tint2":
               _loc3_.transform.colorTransform = ColorUtil.getColorTransform2(param2 as uint);
               break;
            case "dynamicPoint":
               _loc3_.x = param2.x;
               _loc3_.y = param2.y;
               break;
            case "motionBlur":
               _loc4_ = new Point(Math.abs(param2.x - _loc3_.x),Math.abs(param2.y - _loc3_.y));
               if(_loc4_.length > 0)
               {
                  _loc3_.filters = [new BlurFilter(_loc4_.x,_loc4_.y)];
               }
               else
               {
                  _loc3_.filters = [];
               }
               _loc3_.x = param2.x;
               _loc3_.y = param2.y;
               break;
            default:
               this.target[param1] = param2;
         }
      }
      
      public function remove(param1:Boolean = true) : void
      {
         var _loc2_:int = 0;
         if(param1)
         {
            this.duration = 0;
            this.update();
         }
         else
         {
            _loc2_ = this.effects.indexOf(this);
            if(_loc2_ != -1)
            {
               this.effects.splice(this.effects.indexOf(this),1);
            }
         }
      }
   }
}

