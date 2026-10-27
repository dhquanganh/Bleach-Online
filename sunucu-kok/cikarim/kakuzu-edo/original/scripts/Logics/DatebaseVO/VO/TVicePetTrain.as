package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TVicePetTrain extends TDatebaseVO
   {
      
      protected var FNeedTime:uint;
      
      protected var FSilver:uint;
      
      protected var FGetExp:uint;
      
      protected var FNeedGold:Vector.<int>;
      
      protected var FNeedExp:Vector.<int>;
      
      protected var FVipLimit:uint;
      
      public function TVicePetTrain()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         this.FNeedTime = param1.readUnsignedInt();
         this.FSilver = param1.readUnsignedInt();
         this.FGetExp = param1.readUnsignedInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FNeedGold = Vector.<int>(_loc3_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FNeedExp = Vector.<int>(_loc3_);
         this.FVipLimit = param1.readUnsignedInt();
      }
      
      public function get NeedTime() : uint
      {
         return this.FNeedTime;
      }
      
      public function set NeedTime(param1:uint) : void
      {
         this.FNeedTime = param1;
      }
      
      public function get Silver() : uint
      {
         return this.FSilver;
      }
      
      public function set Silver(param1:uint) : void
      {
         this.FSilver = param1;
      }
      
      public function get GetExp() : uint
      {
         return this.FGetExp;
      }
      
      public function set GetExp(param1:uint) : void
      {
         this.FGetExp = param1;
      }
      
      public function get NeedGold() : Vector.<int>
      {
         return this.FNeedGold;
      }
      
      public function set NeedGold(param1:Vector.<int>) : void
      {
         this.FNeedGold = param1;
      }
      
      public function get NeedExp() : Vector.<int>
      {
         return this.FNeedExp;
      }
      
      public function set NeedExp(param1:Vector.<int>) : void
      {
         this.FNeedExp = param1;
      }
      
      public function get VipLimit() : uint
      {
         return this.FVipLimit;
      }
      
      public function set VipLimit(param1:uint) : void
      {
         this.FVipLimit = param1;
      }
   }
}

