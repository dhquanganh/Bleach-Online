package ǽ
{
   import flash.utils.*;
   
   public class Ǽ
   {
      
      public function Ǽ()
      {
         super();
      }
      
      public static function Ȭ(param1:ByteArray, param2:ByteArray) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:Vector.<uint> = null;
         var _loc7_:uint = 0;
         var _loc8_:ByteArray = null;
         var _loc9_:String = null;
         _loc8_ = new ByteArray();
         _loc7_ = param2.readUnsignedInt();
         _loc8_.writeBytes(param2,param2.position,_loc7_);
         _loc8_.position = 0;
         _loc8_.uncompress();
         _loc9_ = _loc8_.readUTFBytes(_loc8_.length);
         _loc6_ = Vector.<uint>(_loc9_.split(","));
         _loc3_ = _loc6_.length;
         _loc4_ = _loc3_ - 1;
         while(_loc4_ > 0)
         {
            _loc5_ = uint(param1[_loc6_[_loc4_]]);
            param1[_loc6_[_loc4_]] = param1[_loc6_[_loc4_ - 1]];
            param1[_loc6_[_loc4_ - 1]] = _loc5_;
            _loc4_ -= 2;
         }
      }
   }
}

