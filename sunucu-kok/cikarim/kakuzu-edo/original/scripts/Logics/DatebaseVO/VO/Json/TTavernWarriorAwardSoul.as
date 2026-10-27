package Logics.DatebaseVO.VO.Json
{
   import ghostcat.util.data.Json;
   
   public class TTavernWarriorAwardSoul
   {
      
      protected var FType:uint;
      
      protected var FValue:uint;
      
      public function TTavernWarriorAwardSoul(param1:Object)
      {
         var _loc2_:Object = null;
         super();
         _loc2_ = Json.decode(String(param1));
         this.FType = _loc2_.type;
         this.FValue = _loc2_.value;
      }
      
      public function get Type() : uint
      {
         return this.FType;
      }
      
      public function get Value() : uint
      {
         return this.FValue;
      }
   }
}

