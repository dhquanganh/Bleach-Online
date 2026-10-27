package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.Inventories.TInventoryProperty;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TRelatedPartnerType extends TDatebaseVO
   {
      
      protected var FType:int;
      
      protected var FName:String;
      
      protected var FLevel:int;
      
      protected var FMaterialCount:int;
      
      protected var FProperties:Vector.<TInventoryProperty>;
      
      public function TRelatedPartnerType()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TInventoryProperty = null;
         this.FType = param1.readUnsignedInt();
         this.FName = TUtilityString.FetchUTF(param1);
         this.FLevel = param1.readUnsignedInt();
         this.FMaterialCount = param1.readUnsignedInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         _loc5_ = int(_loc3_.length);
         this.FProperties = new Vector.<TInventoryProperty>();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = new TInventoryProperty();
            _loc6_.Identifier = _loc3_[_loc4_].type;
            _loc6_.Value = _loc3_[_loc4_].value;
            _loc6_.Oper = _loc3_[_loc4_].oper;
            this.FProperties.push(_loc6_);
            _loc4_++;
         }
      }
      
      public function get Type() : int
      {
         return this.FType;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function get MaterialCount() : int
      {
         return this.FMaterialCount;
      }
      
      public function get Properties() : Vector.<TInventoryProperty>
      {
         return this.FProperties;
      }
   }
}

