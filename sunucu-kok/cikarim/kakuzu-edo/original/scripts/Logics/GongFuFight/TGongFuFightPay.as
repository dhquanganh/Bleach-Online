package Logics.GongFuFight
{
   import Logics.DatebaseVO.VO.TGSPVPDailyAward;
   import Logics.Inventories.TInventories;
   
   public class TGongFuFightPay
   {
      
      protected var FGSPVPDailyAward:TGSPVPDailyAward;
      
      protected var FPayReward:TInventories;
      
      public function TGongFuFightPay()
      {
         super();
         this.FPayReward = new TInventories();
      }
      
      public function get GSPVPDailyAward() : TGSPVPDailyAward
      {
         return this.FGSPVPDailyAward;
      }
      
      public function set GSPVPDailyAward(param1:TGSPVPDailyAward) : void
      {
         this.FGSPVPDailyAward = param1;
      }
      
      public function get PayReward() : TInventories
      {
         return this.FPayReward;
      }
   }
}

