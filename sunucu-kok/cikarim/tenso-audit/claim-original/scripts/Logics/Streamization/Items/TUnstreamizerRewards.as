package Logics.Streamization.Items
{
   import Logics.Items.TItem;
   import Logics.Items.TItems;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerRewards extends TUnstreamizerItemUnknown
   {
      
      private var FUnstreamizerItem:TUnstreamizerItem;
      
      public function TUnstreamizerRewards()
      {
         super();
         this.FUnstreamizerItem = new TUnstreamizerItem();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:TItem = null;
         var _loc6_:uint = 0;
         var _loc7_:TItems = null;
         _loc7_ = param2 as TItems;
         _loc6_ = uint(param1.readShort());
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            _loc5_ = FPoolItem.AcquireItem();
            this.FUnstreamizerItem.Unstreamize(param1,_loc5_,param3);
            _loc7_.Add(_loc5_);
            _loc4_++;
         }
      }
   }
}

