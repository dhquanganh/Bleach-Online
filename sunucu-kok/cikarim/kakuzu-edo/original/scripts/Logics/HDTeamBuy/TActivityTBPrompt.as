package Logics.HDTeamBuy
{
   public class TActivityTBPrompt
   {
      
      protected var FStrNoSign:String;
      
      protected var FStrEndSign:String;
      
      protected var FStrPeople:String;
      
      protected var FStrEndBuy:String;
      
      protected var FStrBoughtPeople:String;
      
      protected var FStrBtnSign:String;
      
      protected var FStrBtnSigned:String;
      
      protected var FStrBtnBuy:String;
      
      protected var FStrBtnBought:String;
      
      public function TActivityTBPrompt(param1:Object)
      {
         super();
         this.FStrNoSign = param1.strNoSign;
         this.FStrEndSign = param1.strEndSign;
         this.FStrPeople = param1.strPeople;
         this.FStrEndBuy = param1.strEndBuy;
         this.FStrBoughtPeople = param1.strBoughtPeople;
         this.FStrBtnSign = param1.strBtnSign;
         this.FStrBtnSigned = param1.strBtnSigned;
         this.FStrBtnBuy = param1.strBtnBuy;
         this.FStrBtnBought = param1.strBtnBought;
      }
      
      public function get StrNoSign() : String
      {
         return this.FStrNoSign;
      }
      
      public function get StrEndSign() : String
      {
         return this.FStrEndSign;
      }
      
      public function get StrPeople() : String
      {
         return this.FStrPeople;
      }
      
      public function get StrEndBuy() : String
      {
         return this.FStrEndBuy;
      }
      
      public function get StrBoughtPeople() : String
      {
         return this.FStrBoughtPeople;
      }
      
      public function get StrBtnSign() : String
      {
         return this.FStrBtnSign;
      }
      
      public function get StrBtnSigned() : String
      {
         return this.FStrBtnSigned;
      }
      
      public function get StrBtnBuy() : String
      {
         return this.FStrBtnBuy;
      }
      
      public function get StrBtnBought() : String
      {
         return this.FStrBtnBought;
      }
   }
}

