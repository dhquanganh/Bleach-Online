package Logics.HDActivityFund
{
   public class TFundInvestment
   {
      
      protected static const RANGE_NUM:uint = 2;
      
      protected var FIncome:uint;
      
      protected var FRange:Vector.<uint>;
      
      protected var FDecs:String;
      
      protected var FNeedGold:uint;
      
      protected var FState:int;
      
      public function TFundInvestment()
      {
         super();
         this.FRange = new Vector.<uint>(RANGE_NUM);
      }
      
      public function get Income() : uint
      {
         return this.FIncome;
      }
      
      public function set Income(param1:uint) : void
      {
         this.FIncome = param1;
      }
      
      public function get Range() : Vector.<uint>
      {
         return this.FRange;
      }
      
      public function set Range(param1:Vector.<uint>) : void
      {
         this.FRange = param1;
      }
      
      public function get Decs() : String
      {
         return this.FDecs;
      }
      
      public function set Decs(param1:String) : void
      {
         this.FDecs = param1;
      }
      
      public function get NeedGold() : uint
      {
         return this.FNeedGold;
      }
      
      public function set NeedGold(param1:uint) : void
      {
         this.FNeedGold = param1;
      }
      
      public function get State() : int
      {
         return this.FState;
      }
      
      public function set State(param1:int) : void
      {
         this.FState = param1;
      }
   }
}

