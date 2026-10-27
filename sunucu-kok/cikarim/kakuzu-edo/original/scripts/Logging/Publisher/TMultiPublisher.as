package Logging.Publisher
{
   public class TMultiPublisher implements IPublisher
   {
      
      protected var FPublisherList:Array;
      
      public function TMultiPublisher(param1:Array = null)
      {
         super();
         this.FPublisherList = param1 || [];
      }
      
      public function get Length() : int
      {
         return this.FPublisherList.length;
      }
      
      public function get OutputType() : uint
      {
         return 0;
      }
      
      public function GetPublisherList() : Array
      {
         return this.FPublisherList;
      }
      
      public function Publish(param1:uint, param2:int, param3:*, ... rest) : void
      {
         var _loc5_:IPublisher = null;
         for each(_loc5_ in this.FPublisherList)
         {
            if(param1 == _loc5_.OutputType)
            {
               _loc5_.Publish(param1,param2,param3,rest);
            }
         }
      }
      
      public function Add(param1:IPublisher) : void
      {
         this.FPublisherList.push(param1);
      }
      
      public function Clear() : void
      {
         var _loc1_:IPublisher = null;
         for each(_loc1_ in this.FPublisherList)
         {
            _loc1_.Clear();
         }
      }
      
      public function Destroy() : void
      {
         var _loc1_:IPublisher = null;
         for each(_loc1_ in this.FPublisherList)
         {
            _loc1_.Destroy();
         }
      }
   }
}

