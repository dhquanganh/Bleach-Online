package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TEquipAdditional extends TDatebaseVO
   {
      
      protected var INDEX_Category:uint = 0;
      
      protected var INDEX_MINVALUE:uint = 1;
      
      protected var INDEX_MAXVALUE:uint = 2;
      
      protected var INDEX_Divisor:uint = 3;
      
      protected var INDEX_Percentage:uint = 4;
      
      protected var FEquipLevel:uint;
      
      protected var FSortNumber:uint;
      
      protected var FCategory:uint;
      
      protected var FDivisor:uint;
      
      protected var FPercentage:uint;
      
      protected var FMaxValue:uint;
      
      protected var FMinValue:uint;
      
      protected var FTypeEffect:String;
      
      public function TEquipAdditional()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         this.FEquipLevel = param1.readUnsignedInt();
         this.FSortNumber = param1.readUnsignedInt();
         this.FTypeEffect = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(this.FTypeEffect);
         _loc4_ = String(_loc3_.typeEffect).split("_");
         this.FCategory = _loc4_[this.INDEX_Category];
         this.FDivisor = _loc4_[this.INDEX_Divisor];
         this.FPercentage = _loc4_[this.INDEX_Percentage];
         this.FMaxValue = _loc4_[this.INDEX_MAXVALUE];
         this.FMinValue = _loc4_[this.INDEX_MINVALUE];
      }
      
      public function get EquipLevel() : uint
      {
         return this.FEquipLevel;
      }
      
      public function get SortNumber() : uint
      {
         return this.FSortNumber;
      }
      
      public function get Category() : uint
      {
         return this.FCategory;
      }
      
      public function get Divisor() : uint
      {
         return this.FDivisor;
      }
      
      public function get Percentage() : uint
      {
         return this.FPercentage;
      }
      
      public function get MaxValue() : uint
      {
         return this.FMaxValue;
      }
      
      public function get MinValue() : uint
      {
         return this.FMinValue;
      }
      
      public function get TypeEffect() : String
      {
         return this.FTypeEffect;
      }
   }
}

