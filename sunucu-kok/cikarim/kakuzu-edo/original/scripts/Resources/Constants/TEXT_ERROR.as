package Resources.Constants
{
   public class TEXT_ERROR
   {
      
      public static const TEXT_ERROR_STATIC:String = "An static class may not be instantiated.";
      
      public static const TEXT_ERROR_ABSTRACT:String = "An abstract class may not be instantiated. must be implemented by subclasses.";
      
      public static const TEXT_ERROR_LOG:String = "Can\'t log. Please define a publisher or disable the Logger.";
      
      public static const TEXT_ERROR_RANGE:String = "Invalid Packet Length.";
      
      public static const TEXT_ERROR_ARRAYRANGE:String = "Array index out of range.";
      
      public static const TEXT_ERROR_ARGUMENT:String = "Cannot put a value with undefined or null key!";
      
      public static const TEXT_ERROR_LOADFAILED:String = "加载失败,请检查文件是否存在！";
      
      public static const TEXT_ERROR_CHECKDATEBASE:String = "请检查配置表中的数据！";
      
      public static const TEXT_ERROR_VERIFICATIONFAILED:String = "数据验证失败！";
      
      public static const TEXT_ERROR_NULL:String = "对象为NULL！";
      
      public static const TEXT_ERROR_ZERO:String = "ID不能为0！";
      
      public static const TEXT_ERROR_UNREGISTEREDMODULE:String = "Find an unregistered module!";
      
      public static const TEXT_ERROR_PROTOCOL_PROCESSING_FAILURE:String = "接收到一个还未开启功能的协议消息！！！";
      
      public static const TEXT_ERROR_UNKNOWN:String = "未知错误!";
      
      public static const TEXT_ERROR_FUNCTIONMODES:String = "未在 FUNCTIONMODES 表中找到匹配的数据,请检查ModuleID!";
      
      public static const TEXT_ERROR_NETWORK_DATA:String = "Network data error,some data changed!";
      
      public static const TEXT_ERROR_UNKNOWN_RESOURCES_TYPE:String = "未知的加载器类型!";
      
      public function TEXT_ERROR()
      {
         super();
      }
   }
}

