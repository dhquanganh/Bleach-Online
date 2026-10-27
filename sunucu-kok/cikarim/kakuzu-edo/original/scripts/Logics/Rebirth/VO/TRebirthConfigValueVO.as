package Logics.Rebirth.VO
{
   import Logics.Inventories.TInventory;
   
   public class TRebirthConfigValueVO
   {
      
      protected var FRebirthNeedLevel:Vector.<uint>;
      
      protected var FReduceExp:Vector.<Object>;
      
      protected var FRebirthStoneID:int;
      
      protected var FSoulStoneCost:Object;
      
      protected var FRefineSoulStoneCost:Object;
      
      protected var FSuperPropCost:int;
      
      protected var FExpBook:TInventory;
      
      protected var FDailyBuyExpBookCost:int;
      
      protected var FRebirthCostCount:Vector.<uint>;
      
      protected var FRebirthEffectID:Vector.<uint>;
      
      protected var FPropPowerBaseID:Vector.<uint>;
      
      protected var FAttEffectBaseID:Vector.<uint>;
      
      protected var FAttEffectOpenZone:Vector.<Array>;
      
      protected var FMaxRebirthNum:int;
      
      protected var FPropPowerZone:Vector.<uint>;
      
      protected var FExpBookID:int;
      
      public function TRebirthConfigValueVO()
      {
         super();
      }
      
      public function get RebirthNeedLevel() : Vector.<uint>
      {
         return this.FRebirthNeedLevel;
      }
      
      public function set RebirthNeedLevel(param1:Vector.<uint>) : void
      {
         this.FRebirthNeedLevel = param1;
      }
      
      public function get ReduceExp() : Vector.<Object>
      {
         return this.FReduceExp;
      }
      
      public function set ReduceExp(param1:Vector.<Object>) : void
      {
         this.FReduceExp = param1;
      }
      
      public function get ExpBook() : TInventory
      {
         return this.FExpBook;
      }
      
      public function set ExpBook(param1:TInventory) : void
      {
         this.FExpBook = param1;
      }
      
      public function get MaxRebirthNum() : int
      {
         return this.FMaxRebirthNum;
      }
      
      public function set MaxRebirthNum(param1:int) : void
      {
         this.FMaxRebirthNum = param1;
      }
      
      public function get RebirthStoneID() : int
      {
         return this.FRebirthStoneID;
      }
      
      public function set RebirthStoneID(param1:int) : void
      {
         this.FRebirthStoneID = param1;
      }
      
      public function get SoulStoneCost() : Object
      {
         return this.FSoulStoneCost;
      }
      
      public function set SoulStoneCost(param1:Object) : void
      {
         this.FSoulStoneCost = param1;
      }
      
      public function get RefineSoulStoneCost() : Object
      {
         return this.FRefineSoulStoneCost;
      }
      
      public function set RefineSoulStoneCost(param1:Object) : void
      {
         this.FRefineSoulStoneCost = param1;
      }
      
      public function get SuperPropCost() : int
      {
         return this.FSuperPropCost;
      }
      
      public function set SuperPropCost(param1:int) : void
      {
         this.FSuperPropCost = param1;
      }
      
      public function get DailyBuyExpBookCost() : int
      {
         return this.FDailyBuyExpBookCost;
      }
      
      public function set DailyBuyExpBookCost(param1:int) : void
      {
         this.FDailyBuyExpBookCost = param1;
      }
      
      public function get RebirthCostCount() : Vector.<uint>
      {
         return this.FRebirthCostCount;
      }
      
      public function set RebirthCostCount(param1:Vector.<uint>) : void
      {
         this.FRebirthCostCount = param1;
      }
      
      public function get RebirthEffectID() : Vector.<uint>
      {
         return this.FRebirthEffectID;
      }
      
      public function set RebirthEffectID(param1:Vector.<uint>) : void
      {
         this.FRebirthEffectID = param1;
      }
      
      public function get PropPowerBaseID() : Vector.<uint>
      {
         return this.FPropPowerBaseID;
      }
      
      public function set PropPowerBaseID(param1:Vector.<uint>) : void
      {
         this.FPropPowerBaseID = param1;
      }
      
      public function get AttEffectBaseID() : Vector.<uint>
      {
         return this.FAttEffectBaseID;
      }
      
      public function set AttEffectBaseID(param1:Vector.<uint>) : void
      {
         this.FAttEffectBaseID = param1;
      }
      
      public function get AttEffectOpenZone() : Vector.<Array>
      {
         return this.FAttEffectOpenZone;
      }
      
      public function set AttEffectOpenZone(param1:Vector.<Array>) : void
      {
         this.FAttEffectOpenZone = param1;
      }
      
      public function get PropPowerZone() : Vector.<uint>
      {
         return this.FPropPowerZone;
      }
      
      public function set PropPowerZone(param1:Vector.<uint>) : void
      {
         this.FPropPowerZone = param1;
      }
      
      public function get ExpBookID() : int
      {
         return this.FExpBookID;
      }
      
      public function set ExpBookID(param1:int) : void
      {
         this.FExpBookID = param1;
      }
   }
}

