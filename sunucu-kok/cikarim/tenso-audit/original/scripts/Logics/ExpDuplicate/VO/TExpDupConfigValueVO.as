package Logics.ExpDuplicate.VO
{
   public class TExpDupConfigValueVO
   {
      
      protected var FNumVipBase:Number;
      
      protected var FNumVipArg:Number;
      
      protected var FRefreshPrice:Vector.<int>;
      
      protected var FBattleCount:int;
      
      public function TExpDupConfigValueVO()
      {
         super();
      }
      
      public function get BattleCount() : int
      {
         return this.FBattleCount;
      }
      
      public function set BattleCount(param1:int) : void
      {
         this.FBattleCount = param1;
      }
      
      public function get RefreshPrice() : Vector.<int>
      {
         return this.FRefreshPrice;
      }
      
      public function get NumVipBase() : Number
      {
         return this.FNumVipBase;
      }
      
      public function set NumVipBase(param1:Number) : void
      {
         this.FNumVipBase = param1;
      }
      
      public function get NumVipArg() : Number
      {
         return this.FNumVipArg;
      }
      
      public function set NumVipArg(param1:Number) : void
      {
         this.FNumVipArg = param1;
      }
      
      public function set RefreshPrice(param1:Vector.<int>) : void
      {
         this.FRefreshPrice = param1;
      }
   }
}

