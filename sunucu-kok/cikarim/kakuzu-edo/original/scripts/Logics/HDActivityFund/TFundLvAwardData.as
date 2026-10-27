package Logics.HDActivityFund
{
   import Logics.HDActivityRecharge.TAwardData;
   
   public class TFundLvAwardData extends TAwardData
   {
      
      protected var FLevel:uint;
      
      protected var FGold:uint;
      
      protected var FInventoriesId:Vector.<uint>;
      
      public function TFundLvAwardData()
      {
         super();
         FItemIdList = new Vector.<uint>();
      }
      
      public function get Gold() : uint
      {
         return this.FGold;
      }
      
      public function set Gold(param1:uint) : void
      {
         this.FGold = param1;
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function set Level(param1:uint) : void
      {
         this.FLevel = param1;
      }
      
      public function get InventoriesId() : Vector.<uint>
      {
         return this.FInventoriesId;
      }
      
      public function set InventoriesId(param1:Vector.<uint>) : void
      {
         this.FInventoriesId = param1;
      }
   }
}

