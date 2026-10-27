package Logics.DatebaseVO.VO.Json
{
   import ghostcat.util.data.Json;
   
   public class TTavernPayConfigTypes
   {
      
      protected var FType:uint;
      
      public function TTavernPayConfigTypes(param1:Object)
      {
         var _loc2_:Object = null;
         super();
         _loc2_ = Json.decode(String(param1));
         this.FType = _loc2_.type;
      }
      
      public function get Type() : uint
      {
         return this.FType;
      }
   }
}

