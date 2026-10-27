package Logics.Military
{
   import Foundation.Common.Integer.UInt64;
   
   public class THeroExpData
   {
      
      protected var FUpgradeNeedExp:Vector.<UInt64>;
      
      public function THeroExpData(param1:int)
      {
         super();
         this.FUpgradeNeedExp = new Vector.<UInt64>(param1);
      }
      
      public function UpgradeNeedExp(param1:int) : UInt64
      {
         return this.FUpgradeNeedExp[param1 - 1];
      }
      
      public function SetNeedExpByIndex(param1:int, param2:UInt64) : void
      {
         this.FUpgradeNeedExp[param1] = param2;
      }
   }
}

