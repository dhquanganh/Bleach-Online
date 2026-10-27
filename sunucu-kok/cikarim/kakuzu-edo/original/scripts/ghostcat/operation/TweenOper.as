package ghostcat.operation
{
   import ghostcat.operation.effect.IEffect;
   import ghostcat.util.ReflectUtil;
   import ghostcat.util.easing.TweenEvent;
   import ghostcat.util.easing.TweenUtil;
   
   public class TweenOper extends Oper implements IEffect
   {
      
      protected var _target:*;
      
      public var duration:int;
      
      public var params:Object;
      
      public var updateWhenInvent:Boolean = true;
      
      public var clearTarget:*;
      
      public var tween:TweenUtil;
      
      public function TweenOper(param1:* = null, param2:int = 100, param3:Object = null, param4:Boolean = false, param5:* = 0, param6:Boolean = false)
      {
         super();
         this._target = param1;
         this.duration = param2;
         this.params = param3;
         this.immediately = param6;
         if(param4)
         {
            this.invert = param4;
         }
         this.clearTarget = param5;
      }
      
      public function get target() : *
      {
         return this._target;
      }
      
      public function set target(param1:*) : void
      {
         this._target = param1;
      }
      
      public function get invert() : Boolean
      {
         return this.params ? Boolean(this.params.invert) : false;
      }
      
      public function set invert(param1:Boolean) : void
      {
         if(!this.params)
         {
            this.params = new Object();
         }
         this.params.invert = param1;
      }
      
      override public function execute() : void
      {
         super.execute();
         if(this._target is String)
         {
            this._target = ReflectUtil.eval(this._target);
         }
         if(this.clearTarget is Boolean)
         {
            TweenUtil.removeTween(this._target,this.clearTarget);
         }
         else if(this.clearTarget >= 0)
         {
            TweenUtil.removeTween(this._target,this.clearTarget == 1);
         }
         this.tween = new TweenUtil(this._target,this.duration,this.params);
         this.tween.addEventListener(TweenEvent.TWEEN_END,result);
         if(this.invert && this.updateWhenInvent)
         {
            this.tween.update();
         }
      }
      
      override protected function end(param1:* = null) : void
      {
         if(this.tween)
         {
            this.tween.removeEventListener(TweenEvent.TWEEN_END,result);
            this.tween.remove(false);
         }
         super.end(param1);
      }
      
      public function submit() : void
      {
         if(this.tween)
         {
            this.tween.remove(true);
         }
      }
   }
}

