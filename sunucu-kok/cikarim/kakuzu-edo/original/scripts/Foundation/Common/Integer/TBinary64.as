package Foundation.Common.Integer
{
   import flash.utils.ByteArray;
   
   public class TBinary64
   {
      
      internal var FInternalHigh:uint;
      
      protected var FLow:uint;
      
      public function TBinary64(param1:uint = 0, param2:uint = 0)
      {
         super();
         this.FLow = param1;
         this.FInternalHigh = param2;
      }
      
      final public function Div(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         _loc2_ = this.FInternalHigh % param1;
         var _loc3_:uint = (this.FLow % param1 + _loc2_ * 6) % param1;
         this.FInternalHigh /= param1;
         var _loc4_:Number = (_loc2_ * 4294967296 + this.FLow) / param1;
         this.FInternalHigh += uint(_loc4_ / 4294967296);
         this.FLow = _loc4_;
         return _loc3_;
      }
      
      final public function Mul(param1:uint) : void
      {
         var _loc2_:Number = Number(this.FLow) * param1;
         this.FInternalHigh *= param1;
         this.FInternalHigh += uint(_loc2_ / 4294967296);
         this.FLow *= param1;
      }
      
      final public function Add(param1:uint) : void
      {
         var _loc2_:Number = Number(this.FLow) + param1;
         this.FInternalHigh += uint(_loc2_ / 4294967296);
         this.FLow = _loc2_;
      }
      
      final public function BitwiseNot() : void
      {
         this.FLow = ~this.FLow;
         this.FInternalHigh = ~this.FInternalHigh;
      }
      
      public function get Low() : uint
      {
         return this.FLow;
      }
      
      public function set Low(param1:uint) : void
      {
         this.FLow = param1;
      }
      
      public function Equal(param1:int, param2:int, param3:int, param4:int) : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:ByteArray = null;
         var _loc8_:ByteArray = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Boolean = false;
         _loc11_ = true;
         _loc7_ = new ByteArray();
         _loc8_ = new ByteArray();
         _loc7_.writeInt(param1);
         _loc7_.writeInt(param3);
         _loc8_.writeInt(param3);
         _loc8_.writeInt(param4);
         if(_loc7_.length != _loc8_.length)
         {
            _loc11_ = false;
         }
         if(_loc11_)
         {
            _loc7_.position = 0;
            _loc8_.position = 0;
            _loc6_ = int(_loc7_.length);
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc9_ = _loc7_.readByte();
               _loc10_ = _loc8_.readByte();
               if(_loc9_ != _loc10_)
               {
                  _loc11_ = false;
                  break;
               }
               _loc5_++;
            }
         }
         _loc7_.clear();
         _loc8_.clear();
         return _loc11_;
      }
   }
}

