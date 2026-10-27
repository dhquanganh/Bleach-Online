package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TDrillHole extends TDatebaseVO
   {
      
      protected var FEquipLv:uint;
      
      protected var FDrillNum:uint;
      
      protected var FDrillCostMoney:uint;
      
      protected var FDrillCostItem:Vector.<uint>;
      
      protected var FCostItemNum:uint;
      
      public function TDrillHole()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         this.FEquipLv = param1.readUnsignedInt();
         this.FDrillNum = param1.readUnsignedInt();
         this.FDrillCostMoney = param1.readUnsignedInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FDrillCostItem = new Vector.<uint>(_loc5_);
         _loc5_ = _loc3_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FDrillCostItem[_loc4_] = _loc3_[_loc4_];
            _loc4_++;
         }
         this.FCostItemNum = param1.readUnsignedInt();
      }
      
      public function get EquipLv() : uint
      {
         return this.FEquipLv;
      }
      
      public function get DrillNum() : uint
      {
         return this.FDrillNum;
      }
      
      public function get DrillCostMoney() : uint
      {
         return this.FDrillCostMoney;
      }
      
      public function get DrillCostItem() : Vector.<uint>
      {
         return this.FDrillCostItem;
      }
      
      public function get CostItemNum() : uint
      {
         return this.FCostItemNum;
      }
   }
}

