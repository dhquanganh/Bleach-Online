package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TVicePetRankUp extends TDatebaseVO
   {
      
      protected var FNextPetId:uint;
      
      protected var FCondition:Vector.<int>;
      
      protected var FPetLevel:uint;
      
      protected var FNeedSilver:uint;
      
      public function TVicePetRankUp()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         this.FNextPetId = param1.readUnsignedInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FCondition = Vector.<int>(_loc3_);
         this.FPetLevel = param1.readUnsignedInt();
         this.FNeedSilver = param1.readUnsignedInt();
      }
      
      public function get NextPetId() : uint
      {
         return this.FNextPetId;
      }
      
      public function get Condition() : Vector.<int>
      {
         return this.FCondition;
      }
      
      public function get PetLevel() : uint
      {
         return this.FPetLevel;
      }
      
      public function get NeedSilver() : uint
      {
         return this.FNeedSilver;
      }
   }
}

