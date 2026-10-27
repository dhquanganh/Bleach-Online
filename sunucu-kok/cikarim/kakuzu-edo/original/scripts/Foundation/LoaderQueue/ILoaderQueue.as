package Foundation.LoaderQueue
{
   import flash.events.IEventDispatcher;
   
   public interface ILoaderQueue extends IEventDispatcher
   {
      
      function AddItem(param1:ILoaderAdapter) : void;
      
      function RemoveAllItem() : void;
      
      function RemoveItem(param1:ILoaderAdapter) : void;
      
      function RemoveItemByPriority(param1:uint) : void;
      
      function SaveItemByPriority(param1:uint) : void;
      
      function Dispose() : void;
   }
}

