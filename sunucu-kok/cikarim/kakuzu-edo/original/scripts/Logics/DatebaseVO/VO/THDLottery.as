package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDLottery extends THDActivityBase
   {
      
      protected var FItemsAward:Vector.<uint>;
      
      protected var FItemsCost:Vector.<uint>;
      
      protected var FItemIndex:Vector.<uint>;
      
      protected var FGoldRate:uint;
      
      protected var FBtnGetIndex:uint;
      
      protected var FBtnGetCost:uint;
      
      protected var FGoldPoolRate:uint;
      
      protected var FDay:uint;
      
      protected var FShow:Vector.<int>;
      
      public function THDLottery()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         _loc2_ = _loc6_.length;
         this.FItemsAward = new Vector.<uint>(_loc2_);
         this.FItemsCost = new Vector.<uint>(_loc2_);
         this.FItemIndex = new Vector.<uint>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FItemsAward[_loc3_] = _loc6_[_loc3_].award;
            this.FItemsCost[_loc3_] = _loc6_[_loc3_].cost;
            this.FItemIndex[_loc3_] = _loc6_[_loc3_].index;
            _loc3_++;
         }
         this.FGoldRate = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc5_);
         _loc2_ = uint(_loc7_.length);
         this.FBtnGetCost = _loc7_.costScore;
         this.FBtnGetIndex = _loc7_.index;
         this.FGoldPoolRate = param1.readUnsignedInt();
         this.FDay = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc5_);
         this.FShow = Vector.<int>(_loc7_);
      }
      
      public function get ItemsAward() : Vector.<uint>
      {
         return this.FItemsAward;
      }
      
      public function get ItemsCost() : Vector.<uint>
      {
         return this.FItemsCost;
      }
      
      public function get ItemIndex() : Vector.<uint>
      {
         return this.FItemIndex;
      }
      
      public function get GoldRate() : uint
      {
         return this.FGoldRate;
      }
      
      public function get BtnGetIndex() : uint
      {
         return this.FBtnGetIndex;
      }
      
      public function get BtnGetCost() : uint
      {
         return this.FBtnGetCost;
      }
      
      public function get GoldPoolRate() : uint
      {
         return this.FGoldPoolRate;
      }
      
      public function get Day() : uint
      {
         return this.FDay;
      }
      
      public function get Show() : Vector.<int>
      {
         return this.FShow;
      }
   }
}

