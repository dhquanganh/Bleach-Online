package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TSpiritSchool extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FLevelLimit:uint;
      
      protected var FEffectName:String;
      
      protected var FAddType:uint;
      
      public function TSpiritSchool()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FName = TUtilityString.FetchUTF(param1);
         this.FLevelLimit = param1.readUnsignedInt();
         this.FEffectName = TUtilityString.FetchUTF(param1);
         this.FAddType = param1.readUnsignedInt();
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get LevelLimit() : uint
      {
         return this.FLevelLimit;
      }
      
      public function get EffectName() : String
      {
         return this.FEffectName;
      }
      
      public function get AddType() : uint
      {
         return this.FAddType;
      }
   }
}

