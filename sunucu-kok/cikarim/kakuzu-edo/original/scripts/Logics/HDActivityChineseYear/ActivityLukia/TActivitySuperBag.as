package Logics.HDActivityChineseYear.ActivityLukia
{
   import Foundation.Utilities.TUtilityString;
   import Logics.Inventories.TInventories;
   
   public class TActivitySuperBag
   {
      
      public static const SuperBagUnbuyedIndex:int = 0;
      
      public static const SuperBagBuyedIndex:int = 1;
      
      public static const BagNum:int = 2;
      
      protected var FIndex:Vector.<int>;
      
      protected var FBagPrice:Vector.<Vector.<int>>;
      
      protected var FDescrptionTitle:Vector.<String>;
      
      protected var FDescrptionTwo:Vector.<Vector.<String>>;
      
      protected var FBagsID:Vector.<uint>;
      
      protected var FIfBuyed:Vector.<Boolean>;
      
      protected var FBagInventories:Vector.<TInventories>;
      
      protected var FRewardInfor:Vector.<String>;
      
      public function TActivitySuperBag(param1:Object)
      {
         super();
         this.BuildDeployInfor(param1);
      }
      
      protected function BuildDeployInfor(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<int> = null;
         var _loc7_:Vector.<String> = null;
         var _loc8_:String = null;
         this.FIndex = new Vector.<int>();
         this.FBagPrice = new Vector.<Vector.<int>>();
         this.FDescrptionTitle = new Vector.<String>();
         this.FDescrptionTwo = new Vector.<Vector.<String>>();
         this.FBagsID = new Vector.<uint>();
         this.FIfBuyed = new Vector.<Boolean>();
         this.FRewardInfor = new Vector.<String>();
         _loc2_ = param1 as Array;
         _loc4_ = 0;
         while(_loc4_ < BagNum)
         {
            _loc3_ = _loc2_[_loc4_];
            this.FIndex.push(_loc3_.index);
            _loc6_ = Vector.<int>(_loc3_.cost);
            this.FBagPrice.push(_loc6_);
            this.FDescrptionTitle.push(_loc3_.title);
            _loc7_ = Vector.<String>(_loc3_.description);
            this.FDescrptionTwo.push(_loc7_);
            this.FRewardInfor.push(this.FormatStr(_loc3_.rewardInfor));
            _loc4_++;
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
      
      public function get DescrptionTitle() : Vector.<String>
      {
         return this.FDescrptionTitle;
      }
      
      public function get IfBuyed() : Vector.<Boolean>
      {
         return this.FIfBuyed;
      }
      
      public function get BagInventories() : Vector.<TInventories>
      {
         return this.FBagInventories;
      }
      
      public function get BagsID() : Vector.<uint>
      {
         return this.FBagsID;
      }
      
      public function get BagPrice() : Vector.<Vector.<int>>
      {
         return this.FBagPrice;
      }
      
      public function get DescrptionTwo() : Vector.<Vector.<String>>
      {
         return this.FDescrptionTwo;
      }
      
      public function set BagInventories(param1:Vector.<TInventories>) : void
      {
         this.FBagInventories = param1;
      }
      
      public function get RewardInfor() : Vector.<String>
      {
         return this.FRewardInfor;
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
                  this.FIfBuyed[_loc3_] = false;
               }
               else
               {
                  this.FIfBuyed[_loc3_] = true;
               }
            }
            _loc3_++;
         }
      }
   }
}

