package Logging.Publisher
{
   public interface IPublisher
   {
      
      function Publish(param1:uint, param2:int, param3:*, ... rest) : void;
      
      function get OutputType() : uint;
      
      function Clear() : void;
      
      function Destroy() : void;
   }
}

