package Logics.HDNewYear.VO
{
   import Logics.Inventories.TInventories;
   import Logics.TypeCodeAmount.TTypeCodeAmount;
   
   public class TNewYearLuckEggVO
   {
      
      protected var FGetEggRollCount:uint;
      
      protected var FNeedHammerCount:uint;
      
      protected var FNeedGold:uint;
      
      protected var FInventories:TInventories;
      
      protected var FGetArticle:TTypeCodeAmount;
      
      protected var FIsFree:Boolean;
      
      protected var FRemainTime:Number;
      
      protected var FTotalCount:uint;
      
      protected var FCurCount:uint;
      
      public function TNewYearLuckEggVO()
      {
         super();
      }
      
      public function get GetEggRollCount() : uint
      {
         return this.FGetEggRollCount;
      }
      
      public function set GetEggRollCount(param1:uint) : void
      {
         this.FGetEggRollCount = param1;
      }
      
      public function get NeedHammerCount() : uint
      {
         return this.FNeedHammerCount;
      }
      
      public function set NeedHammerCount(param1:uint) : void
      {
         this.FNeedHammerCount = param1;
      }
      
      public function get NeedGold() : uint
      {
         return this.FNeedGold;
      }
      
      public function set NeedGold(param1:uint) : void
      {
         this.FNeedGold = param1;
      }
      
      public function get GetArticle() : TTypeCodeAmount
      {
         return this.FGetArticle;
      }
      
      public function set GetArticle(param1:TTypeCodeAmount) : void
      {
         this.FGetArticle = param1;
      }
      
      public function get IsFree() : Boolean
      {
         return this.FIsFree;
      }
      
      public function set IsFree(param1:Boolean) : void
      {
         this.FIsFree = param1;
      }
      
      public function get RemainTime() : Number
      {
         return this.FRemainTime;
      }
      
      public function set RemainTime(param1:Number) : void
      {
         this.FRemainTime = param1;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function set Inventories(param1:TInventories) : void
      {
         this.FInventories = param1;
      }
      
      public function get TotalCount() : uint
      {
         return this.FTotalCount;
      }
      
      public function set TotalCount(param1:uint) : void
      {
         this.FTotalCount = param1;
      }
      
      public function get CurCount() : uint
      {
         return this.FCurCount;
      }
      
      public function set CurCount(param1:uint) : void
      {
         this.FCurCount = param1;
      }
   }
}

