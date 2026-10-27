package Resources.Constants
{
   import Processors.Game.Lobby.Activity.HDActivityFund.Window.TProcessorWindowFundInvestment;
   import Processors.Game.Lobby.Activity.HDActivityFund.Window.TProcessorWindowFundLevel;
   import Processors.Game.Lobby.Activity.HDActivityFund.Window.TProcessorWindowFundShop;
   
   public class CONST_ACTIVITYFUND
   {
      
      public static const REFERENCE_ACTIVITY_Vector:Vector.<Class> = Vector.<Class>([TProcessorWindowFundLevel,TProcessorWindowFundInvestment,TProcessorWindowFundShop]);
      
      public function CONST_ACTIVITYFUND()
      {
         super();
      }
   }
}

