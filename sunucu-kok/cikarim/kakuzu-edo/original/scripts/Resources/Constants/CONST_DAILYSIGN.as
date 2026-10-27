package Resources.Constants
{
   public class CONST_DAILYSIGN
   {
      
      public static const RESOURCESID_Swf_DailySign:uint = 889192448;
      
      public static const GirlID:uint = 22100028;
      
      public static const AchievementIDMin:int = 6000191;
      
      public static const AchievementIDMax:int = 6000300;
      
      public static const RESOURCE_ClassName_MC_DailySign:String = "MC_DailySign";
      
      public static const RESOURCE_Link_MC_Sign:String = "MC_Sign";
      
      public static const RESOURCE_Link_MC_IntegralExchange:String = "MC_IntegralExchange";
      
      public static const RESOURCE_Link_MC_EffectLeft:String = "MC_EffectLeft";
      
      public static const RESOURCE_Link_MC_EffectRight:String = "MC_EffectRight";
      
      public static const RESOURCE_Link_TF_Today:String = "TF_Today";
      
      public static const RESOURCE_Link_MC_Alldays:String = "MC_Alldays";
      
      public static const RESOURCE_Link_MC_Day:String = "day_";
      
      public static const RESOURCE_Link_TF_TodaySignReward:String = "TF_TodaySignReward";
      
      public static const RESOURCE_Link_BTN_DailySign:String = "BTN_DailySign";
      
      public static const RESOURCE_Link_BTN_GetReward:String = "BTN_GetReward";
      
      public static const RESOURCE_Link_MC_RewardBG:String = "mc_rewardBG";
      
      public static const RESOURCE_Link_TF_SignIntegral:String = "TF_SignIntegral";
      
      public static const RESOURCE_Link_TF_IntegralCost:String = "TF_IntegralCost";
      
      public static const RESOURCE_Link_TF_DailySign:String = "TF_DailySign_";
      
      public static const RESOURCE_Link_MC_Reward:String = "MC_Reward";
      
      public static const RESOURCE_Link_MC_RewardHero:String = "MC_RewardHero";
      
      public static const RESOURCE_Link_MC_RewardItem:String = "MC_RewardItem";
      
      public static const RESOURCE_Link_MC_SelectBox:String = "MC_SelectBox";
      
      public static const RESOURCE_Link_TF_Day:String = "TF_Day";
      
      public static const RESOURCE_Link_MC_Hook:String = "MC_Hook";
      
      public static const RESOURCE_Link_BTN_Compensate:String = "BTN_Compensate";
      
      public static const RESOURCE_Link_MC_IntegralItem:String = "MC_IntegralItem_";
      
      public static const RESOURCE_Link_MC_Equip:String = "MC_Equip_";
      
      public static const RESOURCE_Link_MC_Page:String = "MC_Page";
      
      public static const RESOURCE_Link_TF_Page:String = "TF_Page";
      
      public static const RESOURCE_Link_MC_PageLeft:String = "MC_PageLeft";
      
      public static const RESOURCE_Link_MC_PageRight:String = "MC_PageRight";
      
      public static const RESOURCE_Link_MC_Lock:String = "MC_Lock";
      
      public static const RESOURCE_Link_MC_Slot:String = "MC_Slot";
      
      public static const RESOURCE_Link_TF_Integral:String = "TF_Integral";
      
      public static const RESOURCE_Link_BTN_Exchange:String = "BTN_Exchange";
      
      public static const RESOURCE_Link_MC_Level:String = "MC_Level";
      
      public static const RESOURCE_Link_TF_Level:String = "TF_Level";
      
      public static const RESOURCE_Link_TF_VIP:String = "TF_VIP";
      
      public static const RESOURCE_Link_TF_Name:String = "TF_Name";
      
      public static const AwardBase:uint = 100;
      
      public static const Multiple:uint = 10;
      
      public static const IndicesLog:Number = 1.21;
      
      public static const CertificateList:Vector.<uint> = Vector.<uint>([10,15,20,25,30,35,40,45,50,55]);
      
      public function CONST_DAILYSIGN()
      {
         super();
      }
      
      public static function GetGiftCertificateByDay(param1:int) : uint
      {
         switch(param1)
         {
            case 3:
               return CertificateList[0];
            case 6:
               return CertificateList[1];
            case 9:
               return CertificateList[2];
            case 12:
               return CertificateList[3];
            case 15:
               return CertificateList[4];
            case 18:
               return CertificateList[5];
            case 21:
               return CertificateList[6];
            case 24:
               return CertificateList[7];
            case 27:
               return CertificateList[8];
            case 30:
               return CertificateList[9];
            default:
               return 0;
         }
      }
   }
}

