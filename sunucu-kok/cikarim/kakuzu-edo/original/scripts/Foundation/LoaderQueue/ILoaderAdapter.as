package Foundation.LoaderQueue
{
   import flash.events.IEventDispatcher;
   
   public interface ILoaderAdapter extends IEventDispatcher
   {
      
      function get Identifier() : uint;
      
      function set Identifier(param1:uint) : void;
      
      function get IsStarted() : Boolean;
      
      function get IsCompleted() : Boolean;
      
      function get Priority() : uint;
      
      function get State() : String;
      
      function set State(param1:String) : void;
      
      function get BytesLoaded() : Number;
      
      function get LastBytesLoaded() : Number;
      
      function set LastBytesLoaded(param1:Number) : void;
      
      function get BytesTotal() : Number;
      
      function get CustomData() : *;
      
      function set CustomData(param1:*) : void;
      
      function get MaxTries() : int;
      
      function set MaxTries(param1:int) : void;
      
      function get NumTries() : int;
      
      function get MaxTimeOutTries() : int;
      
      function set MaxTimeOutTries(param1:int) : void;
      
      function get NumTimeOutTries() : int;
      
      function set NumTimeOutTries(param1:int) : void;
      
      function get MaxBlockTries() : int;
      
      function set MaxBlockTries(param1:int) : void;
      
      function get NumBlockTries() : int;
      
      function set NumBlockTries(param1:int) : void;
      
      function get Url() : String;
      
      function get PreventCache() : Boolean;
      
      function set PreventCache(param1:Boolean) : void;
      
      function get StartTime() : int;
      
      function set StartTime(param1:int) : void;
      
      function get EndTime() : int;
      
      function set EndTime(param1:int) : void;
      
      function Start() : void;
      
      function Stop() : void;
      
      function Dispose() : void;
   }
}

