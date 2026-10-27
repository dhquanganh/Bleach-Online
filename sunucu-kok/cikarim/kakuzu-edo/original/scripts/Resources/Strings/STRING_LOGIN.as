package Resources.Strings
{
   public class STRING_LOGIN
   {
      
      public static const STRING_Error:String = "Login Error";
      
      public static const STRING_ERROR_OK:String = "Ok.";
      
      public static const STRING_ERROR_Network:String = "Network connection failure!";
      
      public static const STRING_ERROR_Timeout:String = "Communication timeout!";
      
      public static const STRING_ERROR_Status:String = "Status Server Login failed!";
      
      public static const STRING_ERROR_Gate:String = "Gate Server Login failed!";
      
      public static const STRINGS_Error:Vector.<String> = Vector.<String>([STRING_ERROR_OK,STRING_ERROR_Network,STRING_ERROR_Timeout,STRING_ERROR_Status,STRING_ERROR_Gate]);
      
      public function STRING_LOGIN()
      {
         super();
      }
   }
}

