package Foundation.Common.Integer
{
   public final class UInt64 extends TBinary64
   {
      
      public static const MAX_VALUE:uint = 18446744073709552000;
      
      public static const MIN_VALUE:uint = 0;
      
      public function UInt64(param1:uint = 0, param2:uint = 0)
      {
         super(param1,param2);
      }
      
      public static function FromNumber(param1:Number) : UInt64
      {
         return new UInt64(param1,Math.floor(param1 / 4294967296));
      }
      
      public static function ParseUInt64(param1:String, param2:uint = 0) : UInt64
      {
         var _loc4_:uint = 0;
         var _loc3_:uint = 0;
         if(param2 == 0)
         {
            if(param1.search(/^0x/) == 0)
            {
               param2 = 16;
               _loc3_ = 2;
            }
            else
            {
               param2 = 10;
            }
         }
         if(param2 < 2 || param2 > 36)
         {
            throw new ArgumentError();
         }
         param1 = param1.toLowerCase();
         var _loc5_:UInt64 = new UInt64();
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1.charCodeAt(_loc3_);
            if(_loc4_ >= "0".charCodeAt() && _loc4_ <= "9".charCodeAt())
            {
               _loc4_ -= "0".charCodeAt();
            }
            else
            {
               if(!(_loc4_ >= "a".charCodeAt() && _loc4_ <= "z".charCodeAt()))
               {
                  throw new ArgumentError();
               }
               _loc4_ -= "a".charCodeAt();
            }
            if(_loc4_ >= param2)
            {
               throw new ArgumentError();
            }
            _loc5_.Mul(param2);
            _loc5_.Add(_loc4_);
            _loc3_++;
         }
         return _loc5_;
      }
      
      final public function set High(param1:uint) : void
      {
         FInternalHigh = param1;
      }
      
      final public function get High() : uint
      {
         return FInternalHigh;
      }
      
      final public function ToNumber() : Number
      {
         return this.High * 4294967296 + Low;
      }
      
      final public function ToString(param1:uint = 10) : String
      {
         var _loc4_:uint = 0;
         if(param1 < 2 || param1 > 36)
         {
            throw new ArgumentError();
         }
         if(this.High == 0)
         {
            return Low.toString(param1);
         }
         var _loc2_:Array = [];
         var _loc3_:UInt64 = new UInt64(Low,this.High);
         do
         {
            _loc4_ = _loc3_.Div(param1);
            _loc2_.push((_loc4_ < 10 ? "0" : "a").charCodeAt() + _loc4_);
         }
         while(_loc3_.High != 0);
         return _loc3_.Low.toString(param1) + String.fromCharCode.apply(String,_loc2_.reverse());
      }
      
      public function EqualMax(param1:UInt64) : Boolean
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         _loc2_ = new Number();
         _loc3_ = this.ToNumber();
         _loc4_ = param1.ToNumber();
         _loc2_ = _loc3_ - _loc4_;
         _loc2_ >>>= 31;
         if(_loc2_ > 0)
         {
            return false;
         }
         return true;
      }
   }
}

