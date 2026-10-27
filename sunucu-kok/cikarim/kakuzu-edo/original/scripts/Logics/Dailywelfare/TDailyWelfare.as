package Logics.Dailywelfare
{
   public class TDailyWelfare
   {
      
      protected var FGetBackItems:Vector.<TGetBackItem>;
      
      protected var FWelfareItems:Vector.<TWelfareItem>;
      
      protected var FWorldBossLv:uint;
      
      public function TDailyWelfare()
      {
         super();
      }
      
      public function get WorldBossLv() : uint
      {
         return this.FWorldBossLv;
      }
      
      public function set WorldBossLv(param1:uint) : void
      {
         this.FWorldBossLv = param1;
      }
      
      public function get GetBackItems() : Vector.<TGetBackItem>
      {
         return this.FGetBackItems;
      }
      
      public function set GetBackItems(param1:Vector.<TGetBackItem>) : void
      {
         this.FGetBackItems = param1;
      }
      
      public function get WelfareItems() : Vector.<TWelfareItem>
      {
         return this.FWelfareItems;
      }
      
      public function set WelfareItems(param1:Vector.<TWelfareItem>) : void
      {
         this.FWelfareItems = param1;
      }
   }
}

