package ghostcat.operation
{
   import flash.events.IEventDispatcher;
   
   public interface IOper extends IEventDispatcher
   {
      
      function execute() : void;
      
      function result(param1:* = null) : void;
      
      function fault(param1:* = null) : void;
      
      function commit(param1:Queue = null) : void;
      
      function halt() : void;
   }
}

