package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TPetFamilyBag extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FUseerLevel:uint;
      
      protected var FMainPetStage:uint;
      
      protected var FVicePetNum:uint;
      
      protected var FAward:uint;
      
      public function TPetFamilyBag()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FName = TUtilityString.FetchUTF(param1);
         this.FUseerLevel = param1.readUnsignedInt();
         this.FMainPetStage = param1.readUnsignedInt();
         this.FVicePetNum = param1.readUnsignedInt();
         this.FAward = param1.readUnsignedInt();
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get UseerLevel() : uint
      {
         return this.FUseerLevel;
      }
      
      public function get MainPetStage() : uint
      {
         return this.FMainPetStage;
      }
      
      public function get VicePetNum() : uint
      {
         return this.FVicePetNum;
      }
      
      public function get Award() : uint
      {
         return this.FAward;
      }
   }
}

