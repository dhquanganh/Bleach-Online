package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TTreasureUpgrade extends TDatebaseVO
   {
      
      protected var FItemid:uint;
      
      protected var FLevel:uint;
      
      protected var FCostItemCount:uint;
      
      protected var FAddValue:Vector.<int>;
      
      protected var FCostGold:uint;
      
      protected var FProductCount:uint;
      
      protected var FCostStoneCount:uint;
      
      public function TTreasureUpgrade()
      {
         super();
         this.FAddValue = new Vector.<int>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         this.FItemid = param1.readUnsignedInt();
         this.FLevel = param1.readUnsignedInt();
         this.FCostItemCount = param1.readUnsignedInt();
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_) as Array;
         _loc3_ = int(_loc5_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAddValue.push(_loc5_[_loc2_]);
            _loc2_++;
         }
         this.FCostGold = param1.readUnsignedInt();
         this.FProductCount = param1.readUnsignedInt();
         this.FCostStoneCount = param1.readUnsignedInt();
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function set Level(param1:uint) : void
      {
         this.FLevel = param1;
      }
      
      public function get CostItemCount() : uint
      {
         return this.FCostItemCount;
      }
      
      public function set CostItemCount(param1:uint) : void
      {
         this.FCostItemCount = param1;
      }
      
      public function get CostGold() : uint
      {
         return this.FCostGold;
      }
      
      public function set CostGold(param1:uint) : void
      {
         this.FCostGold = param1;
      }
      
      public function get Itemid() : uint
      {
         return this.FItemid;
      }
      
      public function get AddValue() : Vector.<int>
      {
         return this.FAddValue;
      }
      
      public function get ProductCount() : uint
      {
         return this.FProductCount;
      }
      
      public function set ProductCount(param1:uint) : void
      {
         this.FProductCount = param1;
      }
      
      public function get CostStoneCount() : uint
      {
         return this.FCostStoneCount;
      }
      
      public function set CostStoneCount(param1:uint) : void
      {
         this.FCostStoneCount = param1;
      }
   }
}

