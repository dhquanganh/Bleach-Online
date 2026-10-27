package Logics.Streamization.Mentorship
{
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.Mentorship.Elements.TRescuePlayer;
   import Logics.Mentorship.TRescue;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerRescue extends TUnstreamizer
   {
      
      public function TUnstreamizerRescue()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:TRescue = null;
         var _loc7_:TRescuePlayer = null;
         _loc6_ = param2 as TRescue;
         _loc5_ = _loc6_.RescueList.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.RescueList.pop();
            _loc4_++;
         }
         _loc5_ = uint(param1.readShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = new TRescuePlayer();
            _loc7_.Identifier0 = param1.readUnsignedInt();
            _loc7_.Identifier1 = param1.readUnsignedInt();
            _loc7_.Name = TUtilityString.FetchUTF(param1);
            _loc7_.Level = param1.readUnsignedShort();
            _loc7_.MasterName = TUtilityString.FetchUTF(param1);
            _loc7_.InteractionCDTime = param1.readUnsignedInt();
            _loc7_.From = param1.readByte();
            _loc6_.RescueList.push(_loc7_);
            _loc4_++;
         }
      }
   }
}

