package Logics.Streamization.VipShop
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.VipShop.TVipShopData;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerVipShop extends TUnstreamizer
   {
      
      public function TUnstreamizerVipShop()
      {
         super();
      }
      
      protected function UnstreamizationPerform_VipShopInit(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TVipShopData = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         _loc6_ = param2 as TVipShopData;
         _loc5_ = param1.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = param1.readUnsignedInt();
            _loc8_ = param1.readUnsignedInt();
            _loc6_.ProcessorSetMallCount(_loc7_,_loc8_);
            _loc4_++;
         }
      }
      
      protected function UnstreamizationPerform_VipShopNotify(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TVipShopData = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc4_ = param2 as TVipShopData;
         _loc5_ = param1.readUnsignedInt();
         _loc6_ = param1.readUnsignedInt();
         _loc4_.ProcessorSetMallCount(_loc5_,_loc6_);
      }
      
      public function UnstreamizeVipShopInit(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_VipShopInit(param1,param2,param3);
      }
      
      public function UnstreamizerVipShopNotify(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_VipShopNotify(param1,param2,param3);
      }
   }
}

