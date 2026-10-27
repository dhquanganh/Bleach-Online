package ghostcat.display.transition
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import ghostcat.events.OperationEvent;
   import ghostcat.operation.Oper;
   import ghostcat.util.core.AbstractUtil;
   import ghostcat.util.core.Handler;
   
   public class TransitionLayerBase extends EventDispatcher
   {
      
      public static var currentTransition:TransitionLayerBase;
      
      public static const FADE_IN:String = "fade_in";
      
      public static const FADE_OUT:String = "fade_out";
      
      public static const WAIT:String = "wait";
      
      public static const END:String = "end";
      
      public var fadeIn:Oper;
      
      public var wait:Oper;
      
      public var fadeOut:Oper;
      
      public var switchHandler:Handler;
      
      public var resultAtEnd:Boolean = true;
      
      private var _state:String;
      
      public function TransitionLayerBase(param1:*, param2:Oper = null, param3:Oper = null, param4:Oper = null)
      {
         super();
         AbstractUtil.preventConstructor(this,TransitionLayerBase);
         if(param1 is Function)
         {
            this.switchHandler = new Handler(param1);
         }
         else
         {
            this.switchHandler = param1;
         }
         this.fadeIn = param2;
         this.fadeOut = param3;
         this.wait = param4;
      }
      
      public static function continueFadeOut() : void
      {
         currentTransition.state = FADE_OUT;
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function set state(param1:String) : void
      {
         if(this._state == param1)
         {
            return;
         }
         this._state = param1;
         switch(this._state)
         {
            case FADE_IN:
               this.playAnimate(this.fadeIn,WAIT);
               break;
            case WAIT:
               if(this.switchHandler)
               {
                  this.switchHandler.call();
               }
               if(!this.resultAtEnd)
               {
                  dispatchEvent(new Event(Event.COMPLETE));
               }
               this.playAnimate(this.wait,FADE_OUT);
               break;
            case FADE_OUT:
               this.playAnimate(this.fadeOut,END);
               break;
            case END:
               this.destory();
         }
      }
      
      protected function playAnimate(param1:Oper, param2:String) : void
      {
         var operCompleteHandler:Function = null;
         var oper:Oper = param1;
         var nextState:String = param2;
         operCompleteHandler = function(param1:Event):void
         {
            removeEventListener(OperationEvent.OPERATION_COMPLETE,operCompleteHandler);
            state = nextState;
         };
         if(oper)
         {
            oper.addEventListener(OperationEvent.OPERATION_COMPLETE,operCompleteHandler);
            oper.execute();
         }
         else
         {
            this.state = nextState;
         }
      }
      
      public function createTo(param1:DisplayObjectContainer) : TransitionLayerBase
      {
         this.state = FADE_IN;
         currentTransition = this;
         return currentTransition;
      }
      
      public function continueFadeOut() : void
      {
         this.state = FADE_OUT;
      }
      
      public function start() : void
      {
         this.state = FADE_IN;
      }
      
      public function destory() : void
      {
         if(currentTransition == this)
         {
            currentTransition = null;
         }
         if(this.resultAtEnd)
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
   }
}

