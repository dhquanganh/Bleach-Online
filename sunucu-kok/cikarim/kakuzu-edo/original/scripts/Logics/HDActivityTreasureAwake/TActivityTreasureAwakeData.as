package Logics.HDActivityTreasureAwake
{
   import Logics.DatebaseVO.VO.THDTreasureShop;
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityTreasureAwakeData extends TActivityOSBase
   {
      
      protected var FHDTreasueShopeApply:THDTreasureShop;
      
      protected var FBuyTimes:Vector.<int>;
      
      public function TActivityTreasureAwakeData()
      {
         super();
         this.FBuyTimes = new Vector.<int>();
      }
      
      public function get HDTreasueShopeApply() : THDTreasureShop
      {
         return this.FHDTreasueShopeApply;
      }
      
      public function get BuyTimes() : Vector.<int>
      {
         return this.FBuyTimes;
      }
      
      public function set HDTreasueShopeApply(param1:THDTreasureShop) : void
      {
         this.FHDTreasueShopeApply = param1;
      }
      
      public function ActivityDataUpdate(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FHDTreasueShopeApply.Indexs.indexOf(param1);
         this.FBuyTimes[_loc3_] = param2;
      }
   }
}

