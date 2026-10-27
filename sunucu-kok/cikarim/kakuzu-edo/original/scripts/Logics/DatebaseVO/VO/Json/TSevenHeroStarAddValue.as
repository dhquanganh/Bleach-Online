package Logics.DatebaseVO.VO.Json
{
   public class TSevenHeroStarAddValue
   {
      
      protected var FAddType:uint;
      
      protected var FAddValue:uint;
      
      public function TSevenHeroStarAddValue(param1:Object)
      {
         super();
         this.FAddType = param1.addType;
         this.FAddValue = param1.addValue;
      }
      
      public function get AddType() : uint
      {
         return this.FAddType;
      }
      
      public function get AddValue() : uint
      {
         return this.FAddValue;
      }
   }
}

