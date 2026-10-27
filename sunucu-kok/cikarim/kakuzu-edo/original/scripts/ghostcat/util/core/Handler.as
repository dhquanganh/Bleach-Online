package ghostcat.util.core
{
   import ghostcat.util.ReflectUtil;
   
   public class Handler
   {
      
      public var caller:*;
      
      public var handler:*;
      
      public var para:Array;
      
      private var _toFunction:Function;
      
      public function Handler(param1:* = null, param2:Array = null, param3:* = null)
      {
         super();
         this.handler = param1;
         this.para = param2;
         this.caller = param3;
      }
      
      public function call(... rest) : *
      {
         var _loc2_:* = undefined;
         if(this.handler is String)
         {
            _loc2_ = ReflectUtil.eval(this.handler.toString());
         }
         else
         {
            _loc2_ = this.handler;
         }
         if(_loc2_ is Function)
         {
            if(Boolean(rest) && rest.length > 0)
            {
               return _loc2_.apply(this.caller,rest);
            }
            return _loc2_.apply(this.caller,this.para);
         }
         return _loc2_;
      }
      
      public function toFunction() : Function
      {
         if(this._toFunction == null)
         {
            this._toFunction = function(... rest):*
            {
               return call();
            };
         }
         return this._toFunction;
      }
      
      public function destory() : void
      {
         this._toFunction = null;
      }
   }
}

