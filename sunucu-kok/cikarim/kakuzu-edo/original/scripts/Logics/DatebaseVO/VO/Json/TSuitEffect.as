package Logics.DatebaseVO.VO.Json
{
   public class TSuitEffect
   {
      
      protected static const KEY_01:uint = 0;
      
      protected static const KEY_02:uint = 1;
      
      protected static const KEY_03:uint = 2;
      
      protected var FSuitQuantity:uint;
      
      protected var FCategory:Vector.<uint>;
      
      protected var FValue:Vector.<String>;
      
      protected var FPercentage:Vector.<uint>;
      
      public function TSuitEffect(param1:String, param2:Object)
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         super();
         this.FSuitQuantity = parseInt(param1);
         _loc5_ = param2 as Array;
         _loc4_ = int(_loc5_.length);
         this.FCategory = new Vector.<uint>(_loc4_);
         this.FValue = new Vector.<String>(_loc4_);
         this.FPercentage = new Vector.<uint>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = _loc5_[_loc3_];
            _loc7_ = _loc6_.split("_");
            this.FCategory[_loc3_] = _loc7_[KEY_01];
            this.FValue[_loc3_] = _loc7_[KEY_02];
            this.FPercentage[_loc3_] = _loc7_[KEY_03];
            _loc3_++;
         }
      }
      
      public function get SuitQuantity() : uint
      {
         return this.FSuitQuantity;
      }
      
      public function get Category() : Vector.<uint>
      {
         return this.FCategory;
      }
      
      public function get Value() : Vector.<String>
      {
         return this.FValue;
      }
      
      public function get Percentage() : Vector.<uint>
      {
         return this.FPercentage;
      }
   }
}

