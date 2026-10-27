package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TOrnamentUpgrade extends TDatebaseVO
   {
      
      protected var FOldItemID:uint;
      
      protected var FCostItems:Vector.<TFixedAward>;
      
      protected var FNewItemID:uint;
      
      public function TOrnamentUpgrade()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TFixedAward = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         this.FOldItemID = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_) as Array;
         _loc3_ = int(_loc6_.length);
         this.FCostItems = new Vector.<TFixedAward>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new TFixedAward(_loc6_[_loc2_]);
            this.FCostItems[_loc2_] = _loc4_;
            _loc2_++;
         }
         this.FNewItemID = param1.readUnsignedInt();
      }
      
      public function get OldItemID() : uint
      {
         return this.FOldItemID;
      }
      
      public function get CostItems() : Vector.<TFixedAward>
      {
         return this.FCostItems;
      }
      
      public function get NewItemID() : uint
      {
         return this.FNewItemID;
      }
   }
}

