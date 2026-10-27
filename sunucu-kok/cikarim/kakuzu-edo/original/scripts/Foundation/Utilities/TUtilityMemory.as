package Foundation.Utilities
{
   import flash.utils.ByteArray;
   
   public class TUtilityMemory
   {
      
      public function TUtilityMemory()
      {
         super();
         throw new Error("UtilityMemory Class Is Static Container Only");
      }
      
      public static function CopyMemory(param1:ByteArray, param2:ByteArray, param3:uint = 0, param4:uint = 0, param5:uint = 0) : void
      {
         var _loc6_:int = 0;
         _loc6_ = int(param2.position);
         param2.position = param5;
         param2.readBytes(param1,param4,param3);
         param2.position = _loc6_;
      }
      
      public static function MoveMemory(param1:ByteArray, param2:ByteArray, param3:uint = 0, param4:uint = 0, param5:uint = 0) : void
      {
         var _loc6_:int = 0;
         _loc6_ = int(param2.position);
         param2.position = param5;
         param2.readBytes(param1,param4,param3);
         param2.position = _loc6_;
      }
      
      public static function SetMemory(param1:ByteArray, param2:int, param3:int, param4:int = 0) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc6_ = int(param1.position);
         param1.position = param4;
         _loc5_ = 0;
         while(_loc5_ < param3)
         {
            param1.writeByte(param2);
            _loc5_++;
         }
         param1.position = _loc6_;
      }
      
      public static function SetMemoryByByteArray(param1:ByteArray, param2:ByteArray, param3:uint = 0, param4:uint = 0, param5:uint = 0) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc6_ = int(param1.position);
         param1.position = param4;
         _loc7_ = int(param2.position);
         param2.position = param5;
         param1.writeBytes(param2,param5,param3);
         param2.position = _loc7_;
         param1.position = _loc6_;
      }
      
      public static function HIBYTE(param1:uint) : uint
      {
         return (param1 & 0xFF00) >> 8;
      }
      
      public static function LOBYTE(param1:uint) : uint
      {
         return param1 & 0xFF;
      }
      
      public static function Min(param1:*, param2:*) : *
      {
         return param1 < param2 ? param1 : param2;
      }
      
      public static function Max(param1:*, param2:*) : *
      {
         return param1 > param2 ? param1 : param2;
      }
   }
}

