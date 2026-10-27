package Foundation.Utilities
{
   public class TUtilityHexadecimal
   {
      
      public function TUtilityHexadecimal()
      {
         super();
         throw new Error("UtilityHexadecimal Class Is Static Container Only");
      }
      
      public static function Format(param1:uint, param2:int = 8) : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc3_ = param1.toString(16).toUpperCase();
         _loc5_ = param2 - _loc3_.length;
         if(_loc5_ > 0)
         {
            _loc4_ = "";
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc4_ += "0";
               _loc6_++;
            }
            _loc3_ = _loc4_ + _loc3_;
         }
         return _loc3_;
      }
   }
}

