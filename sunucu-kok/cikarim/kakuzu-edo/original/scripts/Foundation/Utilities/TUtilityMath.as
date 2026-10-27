package Foundation.Utilities
{
   public class TUtilityMath
   {
      
      public static const SinLookTable:Vector.<Number> = new Vector.<Number>(361);
      
      public static const CosLookTable:Vector.<Number> = new Vector.<Number>(361);
      
      public function TUtilityMath()
      {
         super();
         throw new Error("UtilityMath Class Is Static Container Only");
      }
      
      public static function ForceRange(param1:int, param2:int, param3:int) : int
      {
         if(param1 < param2)
         {
            return param2;
         }
         if(param1 > param3)
         {
            return param3;
         }
         return param1;
      }
      
      public static function RandomRange(param1:Number, param2:Number, param3:Boolean = true) : Number
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         _loc4_ = param2 - param1;
         _loc5_ = param1 + Math.random() * _loc4_;
         if(param3)
         {
            _loc5_ = Math.round(_loc5_);
         }
         return _loc5_;
      }
      
      public static function InitLookTable() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         _loc2_ = Math.PI / 180;
         _loc1_ = 0;
         while(_loc1_ <= 360)
         {
            SinLookTable[_loc1_] = Math.sin(_loc2_ * _loc1_);
            CosLookTable[_loc1_] = Math.cos(_loc2_ * _loc1_);
            _loc1_++;
         }
      }
      
      public static function FastDistance(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         param1 = Math.abs(param1);
         param2 = Math.abs(param2);
         _loc3_ = Math.min(param1,param2);
         return param1 + param2 - (_loc3_ >> 1) - (_loc3_ >> 2) + (_loc3_ >> 4);
      }
   }
}

