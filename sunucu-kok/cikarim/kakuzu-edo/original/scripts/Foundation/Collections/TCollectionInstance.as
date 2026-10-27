package Foundation.Collections
{
   public class TCollectionInstance
   {
      
      protected var FInstances:Vector.<Object>;
      
      protected var FCapacity:int;
      
      public function TCollectionInstance(param1:int)
      {
         super();
         this.FInstances = new Vector.<Object>();
         if(param1 > 0)
         {
            this.CapacitySet(param1);
         }
      }
      
      protected function CapacitySet(param1:int) : void
      {
         var _loc2_:int = 0;
         if(param1 > this.FCapacity)
         {
            this.FInstances.length = param1;
            this.FCapacity = param1;
            return;
         }
         if(param1 < this.FCapacity)
         {
            _loc2_ = param1;
            while(_loc2_ < this.FCapacity)
            {
               this.InstanceReplace(_loc2_,null);
               _loc2_++;
            }
            this.FInstances.length = param1;
            this.FCapacity = param1;
            return;
         }
      }
      
      protected function InstanceReplace(param1:int, param2:Object) : void
      {
         this.FInstances[param1] = param2;
      }
      
      public function get Capacity() : int
      {
         return this.FCapacity;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = int(this.FInstances.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.InstanceReplace(_loc2_,null);
            _loc2_++;
         }
      }
   }
}

