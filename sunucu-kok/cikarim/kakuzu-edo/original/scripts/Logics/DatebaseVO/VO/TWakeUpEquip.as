package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TAddOther;
   import Logics.HeroNew.TWakeSource;
   import Logics.TypeCodeAmount.TTypeCodeAmount;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TWakeUpEquip extends TDatebaseVO
   {
      
      protected var FNeedLevel:int;
      
      protected var FCostPrice:int;
      
      protected var FPropertyItems:Vector.<TAddOther>;
      
      protected var FComposeItems:Vector.<TTypeCodeAmount>;
      
      protected var FSourceItems:Vector.<TWakeSource>;
      
      public function TWakeUpEquip()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:Array = null;
         this.FNeedLevel = param1.readInt();
         this; //unpopped
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc2_);
         _loc8_ = _loc7_ as Array;
         _loc6_ = int(_loc8_.length);
         this.FPropertyItems = new Vector.<TAddOther>(_loc6_);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            this.FPropertyItems[_loc5_] = new TAddOther(_loc8_[_loc5_]);
            _loc5_++;
         }
         _loc8_.length = 0;
         _loc3_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc3_);
         _loc8_ = _loc7_ as Array;
         _loc6_ = int(_loc8_.length);
         this.FComposeItems = new Vector.<TTypeCodeAmount>(_loc6_);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            this.FComposeItems[_loc5_] = new TTypeCodeAmount();
            this.FComposeItems[_loc5_].Amount = _loc8_[_loc5_].amount;
            this.FComposeItems[_loc5_].Code = _loc8_[_loc5_].code;
            this.FComposeItems[_loc5_].Type = _loc8_[_loc5_].type;
            _loc5_++;
         }
         this.FCostPrice = param1.readInt();
         _loc8_.length = 0;
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc4_);
         _loc8_ = _loc7_ as Array;
         _loc6_ = int(_loc8_.length);
         this.FSourceItems = new Vector.<TWakeSource>(_loc6_);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            this.FSourceItems[_loc5_] = new TWakeSource(_loc8_[_loc5_]);
            _loc5_++;
         }
      }
      
      public function get NeedLevel() : int
      {
         return this.FNeedLevel;
      }
      
      public function get CostPrice() : int
      {
         return this.FCostPrice;
      }
      
      public function get PropertyCount() : int
      {
         return this.FPropertyItems.length;
      }
      
      public function get ComposeItemsCount() : int
      {
         return this.FComposeItems.length;
      }
      
      public function get SourceCount() : int
      {
         return this.FSourceItems.length;
      }
      
      public function GetPropertyByIndex(param1:int) : TAddOther
      {
         return this.FPropertyItems[param1];
      }
      
      public function GetComposeByIndex(param1:int) : TTypeCodeAmount
      {
         return this.FComposeItems[param1];
      }
      
      public function GetSourceByIndex(param1:int) : TWakeSource
      {
         return this.FSourceItems[param1];
      }
   }
}

