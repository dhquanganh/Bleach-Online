package Logics.HDSwiftChange
{
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TActivitySwiftChangData extends TActivityOSBase
   {
      
      protected var FDataList:Vector.<SwiftChangeVO>;
      
      protected var FHeroList:Vector.<int>;
      
      protected var FExchangeInventories:Vector.<TInventories>;
      
      public function TActivitySwiftChangData()
      {
         super();
         this.FDataList = new Vector.<SwiftChangeVO>();
         this.FExchangeInventories = new Vector.<TInventories>();
      }
      
      public function get DataList() : Vector.<SwiftChangeVO>
      {
         return this.FDataList;
      }
      
      public function set DataList(param1:Vector.<SwiftChangeVO>) : void
      {
         this.FDataList = param1;
      }
      
      public function get HeroList() : Vector.<int>
      {
         return this.FHeroList;
      }
      
      public function set HeroList(param1:Vector.<int>) : void
      {
         this.FHeroList = param1;
      }
      
      public function get ExchangeInventories() : Vector.<TInventories>
      {
         return this.FExchangeInventories;
      }
      
      public function set ExchangeInventories(param1:Vector.<TInventories>) : void
      {
         this.FExchangeInventories = param1;
      }
   }
}

