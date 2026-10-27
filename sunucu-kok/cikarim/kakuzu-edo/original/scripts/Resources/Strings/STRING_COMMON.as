package Resources.Strings
{
   import Logics.Agent.SParametersCore;
   
   public class STRING_COMMON
   {
      
      public static const FORMAT_01:String = "+%0";
      
      public static const FORMAT_02:String = " +%0 (+%1)";
      
      public static const FORMAT_03:String = " +%0";
      
      public static const FORMAT_05:String = "Lv.%0";
      
      public static const COMMON_BATTLEREPORTURL:String = "%0?rid=%1&aid=%2&t=1&lang=%3";
      
      public static const BATTLEREPORT_FOLDERNAME:String = getBattleReportFolderName();
      
      public function STRING_COMMON()
      {
         super();
      }
      
      protected static function getBattleReportFolderName() : String
      {
         var _loc2_:String = null;
         var _loc1_:String = "";
         if(false)
         {
            _loc1_ = "zh_CN";
         }
         if(false)
         {
            _loc1_ = "en_US";
         }
         if(false)
         {
            _loc1_ = "ru_RU";
         }
         _loc2_ = SParametersCore.VersionDir;
         switch(_loc2_)
         {
            case "Mix_de_DE":
               _loc2_ = "de_DE";
               break;
            case "Mix_fr_FR":
               _loc2_ = "fr_FR";
               break;
            case "Mix_en_Eu":
               _loc2_ = "en_Eu";
               break;
            case "en_Eu":
               _loc2_ = "en_Eu";
               break;
            case "Mix_es_ES":
               _loc2_ = "es_ES";
         }
         return _loc2_;
      }
   }
}

