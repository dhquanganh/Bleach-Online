package Logics.Streamization.Mail
{
   import Foundation.Streamization.*;
   import Foundation.Utilities.*;
   import Logics.Inventories.*;
   import Logics.Mail.*;
   import Logics.Streamization.Inventories.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TUnstreamizerMail extends TUnstreamizer
   {
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      public function TUnstreamizerMail()
      {
         super();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:TMail = null;
         var _loc7_:Vector.<uint> = null;
         var _loc8_:Vector.<uint> = null;
         var _loc9_:TInventory = null;
         var _loc10_:Vector.<uint> = null;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         _loc7_ = new Vector.<uint>();
         _loc8_ = new Vector.<uint>();
         _loc10_ = new Vector.<uint>();
         _loc6_ = param2 as TMail;
         _loc6_.SortIndex.High = param1.readUnsignedInt();
         _loc6_.SortIndex.Low = param1.readUnsignedInt();
         _loc6_.Name = TUtilityString.FetchUTF(param1);
         _loc6_.Subject = TUtilityString.FetchUTF(param1);
         _loc6_.Detail = TUtilityString.FetchUTF(param1);
         _loc6_.CreatTime = param1.readUnsignedInt();
         _loc6_.HasRead = param1.readByte();
         param1.readUnsignedInt();
         _loc5_ = param1.readUnsignedShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc11_ = param1.readUnsignedInt();
            _loc12_ = param1.readUnsignedInt();
            if(!(_loc11_ < 10000 && CONST_MAIL.REWARDID_DATA_MAIL[_loc11_] == 0))
            {
               _loc7_.push(_loc11_);
               _loc8_.push(_loc12_);
            }
            _loc4_++;
         }
         _loc5_ = _loc7_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(_loc7_[_loc4_] < 10000)
            {
               _loc10_.push(CONST_MAIL.REWARDID_DATA_MAIL[_loc7_[_loc4_]]);
            }
            else
            {
               _loc10_.push(_loc7_[_loc4_]);
            }
            _loc4_++;
         }
         _loc6_.AccessoryInventories.Clear();
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,_loc6_.AccessoryInventories,_loc10_);
         _loc5_ = uint(_loc6_.AccessoryInventories.Count);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_ = _loc6_.AccessoryInventories.GetInventoryByIndex(_loc4_);
            _loc9_.Quantity = _loc8_[_loc4_];
            _loc4_++;
         }
         _loc6_.AccessoryInventories.Sort();
      }
   }
}

