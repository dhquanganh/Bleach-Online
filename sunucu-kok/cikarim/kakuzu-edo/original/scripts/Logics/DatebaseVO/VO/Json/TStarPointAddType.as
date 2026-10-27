package Logics.DatebaseVO.VO.Json
{
   import ghostcat.util.data.Json;
   
   public class TStarPointAddType
   {
      
      protected var FType:Vector.<uint>;
      
      protected var FTarget:Vector.<uint>;
      
      protected var FValue:Vector.<Number>;
      
      public function TStarPointAddType(param1:Object)
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         super();
         _loc4_ = Json.decode(String(param1));
         _loc3_ = int(_loc4_.add.length);
         this.FType = new Vector.<uint>(_loc3_);
         this.FTarget = new Vector.<uint>(_loc3_);
         this.FValue = new Vector.<Number>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FType[_loc2_] = _loc4_.add[_loc2_].type;
            this.FTarget[_loc2_] = _loc4_.add[_loc2_].target;
            this.FValue[_loc2_] = _loc4_.add[_loc2_].value;
            _loc2_++;
         }
      }
      
      public function get Type() : Vector.<uint>
      {
         return this.FType;
      }
      
      public function get Target() : Vector.<uint>
      {
         return this.FTarget;
      }
      
      public function get Value() : Vector.<Number>
      {
         return this.FValue;
      }
   }
}

