package Logics.BlackMarket
{
   public class TBlackMarketTotalData
   {
      
      protected var FBlackMarketData:TBlackMarketData;
      
      protected var FSecretMarketData:TSecretMarketData;
      
      protected var FInited:Boolean;
      
      public function TBlackMarketTotalData()
      {
         super();
         this.FBlackMarketData = new TBlackMarketData();
         this.FSecretMarketData = new TSecretMarketData();
      }
      
      public function get BlackMarketData() : TBlackMarketData
      {
         return this.FBlackMarketData;
      }
      
      public function get SecretMarketData() : TSecretMarketData
      {
         return this.FSecretMarketData;
      }
      
      public function get Inited() : Boolean
      {
         return this.FInited;
      }
      
      public function set Inited(param1:Boolean) : void
      {
         this.FInited = param1;
      }
   }
}

