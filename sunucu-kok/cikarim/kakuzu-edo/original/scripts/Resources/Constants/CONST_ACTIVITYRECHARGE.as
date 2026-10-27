package Resources.Constants
{
   import Processors.Game.Lobby.Activity.HDActivityRecharge.windows.*;
   import Processors.Game.Lobby.Activity.HDHalloween.windows.TProcessorHDWindowWelfare;
   import Processors.Game.Lobby.Activity.HDHalloween.windows.TprocessorWindowHDHalloweenTree;
   import Processors.Game.Lobby.Activity.HDMaskFright.Window.*;
   import Processors.Game.Lobby.Activity.HDRechargeSuit.Window.*;
   import Processors.Game.Lobby.Activity.HDSoulBox.Window.TProcessorHDWindowMoneyPenny;
   import Processors.Game.Lobby.Activity.HDSoulBox.Window.TProcessorHDWindowSoulBox;
   
   public class CONST_ACTIVITYRECHARGE
   {
      
      public static const REFERENCE_ACTIVITYRECHARGE_Vector:Vector.<Class> = Vector.<Class>([TProcessorWindowHDDailyCost,TProcessorWindowHDDailyPay,TProcessorWindowHDSinglePay,TProcessorWindowHDTotaleCost,TProcessorWindowHDTotalePay,TProcessorWindowHDVipBox,TProcessorWindowHDDailyTotaleCost,TProcessorWindowHDDailyTotalePay]);
      
      public static const REFERENCE_MaskFright_Vector:Vector.<Class> = Vector.<Class>([TProcessorWindowMaskLegion,TProcessorWindowVirtualKing]);
      
      public static const REFERENCE_SoulBox_Vector:Vector.<Class> = Vector.<Class>([TProcessorHDWindowSoulBox,TProcessorHDWindowMoneyPenny]);
      
      public static const REFERENCE_Halloween_Vector:Vector.<Class> = Vector.<Class>([TProcessorHDWindowWelfare,TprocessorWindowHDHalloweenTree]);
      
      public static const REFERENCE_ACTIVITYRECHARGESUIT_Vector:Vector.<Class> = Vector.<Class>([TProcessorHDWindowRSReturnGold,TProcessorHDWindowRSSinglePay,TProcessorHDWindowRSTotalPay,TProcessorWindowHDDailyCost,TProcessorWindowHDDailyPay,TProcessorWindowHDTotaleCost,TProcessorWindowHDDailyTotaleCost,TProcessorWindowHDDailyTotalePay]);
      
      public function CONST_ACTIVITYRECHARGE()
      {
         super();
      }
   }
}

