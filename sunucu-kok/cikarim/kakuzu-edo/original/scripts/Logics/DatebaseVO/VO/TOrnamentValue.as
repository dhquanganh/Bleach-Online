package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TOrnamentValue extends TDatebaseVO
   {
      
      protected var FItemID:uint;
      
      protected var FLevel:uint;
      
      protected var FCostItems:Vector.<TFixedAward>;
      
      protected var FAddValue:uint;
      
      public function TOrnamentValue()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:TFixedAward = null;
         _loc4_ = TUtilityString.FetchUTF(param1);
         this.FItemID = _loc4_.split(":")[0];
         this.FLevel = param1.readUnsignedInt();
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_) as Array;
         _loc3_ = int(_loc5_.length);
         this.FCostItems = new Vector.<TFixedAward>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = new TFixedAward(_loc5_[_loc2_]);
            this.FCostItems[_loc2_] = _loc6_;
            _loc2_++;
         }
         this.FAddValue = param1.readUnsignedInt();
      }
      
      public function get ItemID() : uint
      {
         return this.FItemID;
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function get CostItems() : Vector.<TFixedAward>
      {
         return this.FCostItems;
      }
      
      public function get AddValue() : uint
      {
         return this.FAddValue;
      }
   }
}

