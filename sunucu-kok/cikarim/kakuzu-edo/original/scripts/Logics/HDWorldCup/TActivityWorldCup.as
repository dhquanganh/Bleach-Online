package Logics.HDWorldCup
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityWorldCup extends TActivityOSBase
   {
      
      protected var FScore:uint;
      
      protected var FFlags:Vector.<int>;
      
      protected var FHadMoney:Vector.<int>;
      
      protected var FFinalStatus:int;
      
      public function TActivityWorldCup()
      {
         super();
         this.FFlags = new Vector.<int>(2);
         this.FHadMoney = new Vector.<int>(2);
      }
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function set Score(param1:uint) : void
      {
         this.FScore = param1;
      }
      
      public function get Flags() : Vector.<int>
      {
         return this.FFlags;
      }
      
      public function set Flags(param1:Vector.<int>) : void
      {
         this.FFlags = param1;
      }
      
      public function get HadMoney() : Vector.<int>
      {
         return this.FHadMoney;
      }
      
      public function set HadMoney(param1:Vector.<int>) : void
      {
         this.FHadMoney = param1;
      }
      
      public function get FinalStatus() : int
      {
         return this.FFinalStatus;
      }
      
      public function set FinalStatus(param1:int) : void
      {
         this.FFinalStatus = param1;
      }
   }
}

