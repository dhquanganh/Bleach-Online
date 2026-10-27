package Resources.Constants
{
   public class CONST_INSPECTOR
   {
      
      public static const SYNCHRONIZE_SEVERY_TIME:uint = 5 * 60 * 1000;
      
      public static const TIME_INTERVAL_InspectorAntiAddiction:int = 1 * 60 * 1000;
      
      public static const TIME_Radix_InspectorAntiAddictions:Vector.<int> = Vector.<int>([1 * 60 * 60 * 1000,2 * 60 * 60 * 1000,3 * 60 * 60 * 1000,3 * 60 * 60 * 1000 + 50 * 60 * 1000,3 * 60 * 60 * 1000 + 59 * 60 * 1000,4 * 60 * 60 * 1000]);
      
      public static const TIME_AntiAddictionUpperLimit:int = TIME_Radix_InspectorAntiAddictions.length;
      
      public static const TYPE_ANTIADDICTION_UNREGISTERED:uint = 0;
      
      public static const TYPE_ANTIADDICTION_ADULTHOOD:uint = 1;
      
      public static const TYPE_ANTIADDICTION_UNDERAGE:uint = 2;
      
      public function CONST_INSPECTOR()
      {
         super();
      }
   }
}

