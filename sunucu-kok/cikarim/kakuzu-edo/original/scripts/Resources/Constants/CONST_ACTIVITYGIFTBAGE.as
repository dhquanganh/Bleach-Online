package Resources.Constants
{
   import Processors.Game.Lobby.Activity.HDActivityGiftBag.windows.*;
   
   public class CONST_ACTIVITYGIFTBAGE
   {
      
      public static const KEY_Activity_Vector:Vector.<uint> = Vector.<uint>([CONST_ACTIVITY_MODE.Activity_OnlineGiftBag,CONST_ACTIVITY_MODE.Activity_GoldGiftBag,CONST_ACTIVITY_MODE.Activity_SevenDayGiftBag,CONST_ACTIVITY_MODE.Activity_OpenServerGiftBag,CONST_ACTIVITY_MODE.Activity_CollectGameGiftBag,CONST_ACTIVITY_MODE.Activity_LevelGiftBag,CONST_ACTIVITY_MODE.Activity_OrderGiftBag]);
      
      public static const REFERENCE_Activity_Vector:Vector.<Class> = Vector.<Class>([TProcessorWindowGBOnline,TProcessorWindowGBGold,TProcessorWindowGBSevenDayNew,TProcessorWindowGBOpenServer,TProcessorWindowGBCollectGame,TProcessorWindowGBLevel,TProcessorWindowGBOrder]);
      
      public function CONST_ACTIVITYGIFTBAGE()
      {
         super();
      }
   }
}

