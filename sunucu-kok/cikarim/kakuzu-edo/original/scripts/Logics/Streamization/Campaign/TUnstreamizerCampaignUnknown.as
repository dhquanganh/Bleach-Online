package Logics.Streamization.Campaign
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.Campaign.TPoolCampaign;
   import Logics.Items.TPoolItem;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerCampaignUnknown extends TUnstreamizer
   {
      
      protected static var FPoolCampaign:TPoolCampaign;
      
      protected static var FPoolItem:TPoolItem;
      
      public function TUnstreamizerCampaignUnknown()
      {
         super();
      }
      
      LogicsSpace static function PoolsSetup(param1:TPoolCampaign) : void
      {
         FPoolCampaign = param1;
      }
      
      LogicsSpace static function PoolsSetupItem(param1:TPoolItem) : void
      {
         FPoolItem = param1;
      }
   }
}

