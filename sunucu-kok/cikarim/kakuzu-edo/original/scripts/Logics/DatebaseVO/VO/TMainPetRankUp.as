package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TPetRankUpCondition;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TMainPetRankUp extends TDatebaseVO
   {
      
      protected var FAddExp:uint;
      
      protected var FStage:uint;
      
      protected var FPetRankUpCondition:TPetRankUpCondition;
      
      public function TMainPetRankUp()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FPetRankUpCondition = new TPetRankUpCondition(_loc2_);
         this.FAddExp = param1.readUnsignedInt();
         this.FStage = param1.readUnsignedInt();
      }
      
      public function get AddExp() : uint
      {
         return this.FAddExp;
      }
      
      public function get Stage() : uint
      {
         return this.FStage;
      }
      
      public function get PetRankUpCondition() : TPetRankUpCondition
      {
         return this.FPetRankUpCondition;
      }
   }
}

