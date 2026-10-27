package Logics.HDActivityChineseYear.ActivityLukia
{
   import Foundation.Utilities.TUtilityString;
   import Logics.Inventories.TInventories;
   import Logics.Items.TItem;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TActivityNiceBag
   {
      
      protected static const BagNum:int = 6;
      
      protected var FIndex:Vector.<int>;
      
      protected var FBagsID:Vector.<uint>;
      
      protected var FPrices:Vector.<int>;
      
      protected var FMoneyForBuy:Vector.<TItem>;
      
      protected var FBagsIfBuyed:Vector.<Boolean>;
      
      protected var FBagInventories:Vector.<TInventories>;
      
      protected var FRewardInfor:Vector.<String>;
      
      public function TActivityNiceBag(param1:Object)
      {
         super();
         this.BuildDeployInfor(param1);
      }
      
      protected function BuildDeployInfor(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         this.FIndex = new Vector.<int>();
         this.FBagsID = new Vector.<uint>();
         this.FPrices = new Vector.<int>();
         this.FBagsIfBuyed = new Vector.<Boolean>();
         this.FRewardInfor = new Vector.<String>();
         _loc3_ = param1 as Array;
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            _loc4_ = _loc3_[_loc2_];
            this.FIndex.push(_loc4_.index);
            this.FPrices.push(_loc4_.cost);
            this.FRewardInfor.push(this.FormatStr(_loc4_.rewardInfor));
            _loc2_++;
         }
      }
      
      protected function FormatStr(param1:String) : String
      {
         return TUtilityString.Replace(param1,"#","\n");
      }
      
      public function get Count() : int
      {
         return this.FIndex.length;
      }
      
      public function get Index() : Vector.<int>
      {
         return this.FIndex;
      }
      
      public function get BagsID() : Vector.<uint>
      {
         return this.FBagsID;
      }
      
      public function get MoneyForBuy() : Vector.<TItem>
      {
         return this.FMoneyForBuy;
      }
      
      public function get BagsIfBuyed() : Vector.<Boolean>
      {
         return this.FBagsIfBuyed;
      }
      
      public function get BagInventories() : Vector.<TInventories>
      {
         return this.FBagInventories;
      }
      
      public function set BagInventories(param1:Vector.<TInventories>) : void
      {
         this.FBagInventories = param1;
      }
      
      public function get RewardInfor() : Vector.<String>
      {
         return this.FRewardInfor;
      }
      
      public function get Prices() : Vector.<int>
      {
         return this.FPrices;
      }
      
      public function UpdateState(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FBagsID.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.FIndex[_loc3_] == param1)
            {
               if(param2 == CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
               {
                  this.FBagsIfBuyed[_loc3_] = true;
               }
               else
               {
                  this.FBagsIfBuyed[_loc3_] = false;
               }
            }
            _loc3_++;
         }
      }
      
      public function FlushActivityData(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FIndex.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.FIndex[_loc3_] == param1)
            {
               if(param2 == 0)
               {
                  this.FBagsIfBuyed[_loc3_] = false;
               }
               else
               {
                  this.FBagsIfBuyed[_loc3_] = true;
               }
            }
            _loc3_++;
         }
      }
   }
}

