package Logics.HDActivitySingle
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivitySingleSuperTreasure extends TActivityOSBase
   {
      
      protected var FPage3BuyedCountVect:Vector.<int>;
      
      protected var FStatusInfos:TStatusInfos;
      
      public function TActivitySingleSuperTreasure()
      {
         super();
         this.FStatusInfos = new TStatusInfos();
      }
      
      public function get Page3BuyedCount() : Vector.<int>
      {
         return this.FPage3BuyedCountVect;
      }
      
      public function set Page3BuyedCount(param1:Vector.<int>) : void
      {
         this.FPage3BuyedCountVect = param1;
      }
      
      public function get StatusInfos() : TStatusInfos
      {
         return this.FStatusInfos;
      }
      
      public function set StatusInfos(param1:TStatusInfos) : void
      {
         this.FStatusInfos = param1;
      }
   }
}

