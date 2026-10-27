package Logics.HDActivitySingle
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivitySingleEspada extends TActivityOSBase
   {
      
      protected var FTotalPay:uint;
      
      protected var FAwardStatus:Vector.<int>;
      
      protected var FBuyStatus:Vector.<int>;
      
      protected var FCurIndex:int;
      
      public function TActivitySingleEspada()
      {
         super();
      }
      
      public function get TotalPay() : uint
      {
         return this.FTotalPay;
      }
      
      public function set TotalPay(param1:uint) : void
      {
         this.FTotalPay = param1;
      }
      
      public function get AwardStatus() : Vector.<int>
      {
         return this.FAwardStatus;
      }
      
      public function set AwardStatus(param1:Vector.<int>) : void
      {
         this.FAwardStatus = param1;
      }
      
      public function get BuyStatus() : Vector.<int>
      {
         return this.FBuyStatus;
      }
      
      public function set BuyStatus(param1:Vector.<int>) : void
      {
         this.FBuyStatus = param1;
      }
      
      public function get CurIndex() : int
      {
         return this.FCurIndex;
      }
      
      public function set CurIndex(param1:int) : void
      {
         this.FCurIndex = param1;
      }
   }
}

