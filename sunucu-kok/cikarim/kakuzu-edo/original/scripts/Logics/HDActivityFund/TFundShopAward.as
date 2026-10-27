package Logics.HDActivityFund
{
   public class TFundShopAward
   {
      
      protected var FAwardIDs:Vector.<uint>;
      
      protected var FShopName:String;
      
      protected var FReturnMoney:uint;
      
      protected var FNeedGold:uint;
      
      public function TFundShopAward()
      {
         super();
         this.FAwardIDs = new Vector.<uint>();
      }
      
      public function get ShopName() : String
      {
         return this.FShopName;
      }
      
      public function set ShopName(param1:String) : void
      {
         this.FShopName = param1;
      }
      
      public function get ReturnMoney() : uint
      {
         return this.FReturnMoney;
      }
      
      public function set ReturnMoney(param1:uint) : void
      {
         this.FReturnMoney = param1;
      }
      
      public function get AwardIDs() : Vector.<uint>
      {
         return this.FAwardIDs;
      }
      
      public function set AwardIDs(param1:Vector.<uint>) : void
      {
         this.FAwardIDs = param1;
      }
      
      public function get NeedGold() : uint
      {
         return this.FNeedGold;
      }
      
      public function set NeedGold(param1:uint) : void
      {
         this.FNeedGold = param1;
      }
   }
}

