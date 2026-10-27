package Logics.HDActivityLimitBuy
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityLimitBuyItem extends TActivityEntity
   {
      
      protected var FLimitBuyCount:uint;
      
      protected var FCost:uint;
      
      protected var FServerLimitCount:uint;
      
      protected var FBuyCondition:uint;
      
      protected var FBuyCount:uint;
      
      protected var FServerCount:uint;
      
      protected var FAwards:Vector.<uint>;
      
      protected var FValue:uint;
      
      public function TActivityLimitBuyItem(param1:uint)
      {
         super(param1);
         this.FAwards = new Vector.<uint>();
      }
      
      public function get LimitBuyCount() : uint
      {
         return this.FLimitBuyCount;
      }
      
      public function set LimitBuyCount(param1:uint) : void
      {
         this.FLimitBuyCount = param1;
      }
      
      public function get Cost() : uint
      {
         return this.FCost;
      }
      
      public function set Cost(param1:uint) : void
      {
         this.FCost = param1;
      }
      
      public function get ServerLimitCount() : uint
      {
         return this.FServerLimitCount;
      }
      
      public function set ServerLimitCount(param1:uint) : void
      {
         this.FServerLimitCount = param1;
      }
      
      public function get BuyCondition() : uint
      {
         return this.FBuyCondition;
      }
      
      public function set BuyCondition(param1:uint) : void
      {
         this.FBuyCondition = param1;
      }
      
      public function get ServerCount() : uint
      {
         return this.FServerCount;
      }
      
      public function set ServerCount(param1:uint) : void
      {
         this.FServerCount = param1;
      }
      
      public function get Awards() : Vector.<uint>
      {
         return this.FAwards;
      }
      
      public function set Awards(param1:Vector.<uint>) : void
      {
         this.FAwards = param1;
      }
      
      public function get Value() : uint
      {
         return this.FValue;
      }
      
      public function set Value(param1:uint) : void
      {
         this.FValue = param1;
      }
      
      public function get IsReachCondition() : Boolean
      {
         if(this.FValue < this.FBuyCondition)
         {
            return false;
         }
         return true;
      }
      
      public function get BuyCount() : uint
      {
         return this.FBuyCount;
      }
      
      public function set BuyCount(param1:uint) : void
      {
         this.FBuyCount = param1;
      }
   }
}

