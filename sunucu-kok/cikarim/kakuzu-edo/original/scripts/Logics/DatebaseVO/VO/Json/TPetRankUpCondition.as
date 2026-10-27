package Logics.DatebaseVO.VO.Json
{
   import ghostcat.util.data.Json;
   
   public class TPetRankUpCondition
   {
      
      protected var FPetIds:Vector.<int>;
      
      protected var FLevels:Vector.<int>;
      
      public function TPetRankUpCondition(param1:Object)
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         super();
         _loc4_ = Json.decode(String(param1));
         _loc5_ = _loc4_ as Array;
         _loc3_ = int(_loc5_.length);
         this.FPetIds = new Vector.<int>(_loc3_);
         this.FLevels = new Vector.<int>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc5_[_loc2_];
            this.FPetIds[_loc2_] = _loc4_.petId;
            this.FLevels[_loc2_] = _loc4_.level;
            _loc2_++;
         }
      }
      
      public function get PetIds() : Vector.<int>
      {
         return this.FPetIds;
      }
      
      public function get Levels() : Vector.<int>
      {
         return this.FLevels;
      }
   }
}

