package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TSkillConfig extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FDesc:String;
      
      protected var FIcon:uint;
      
      protected var FSortId:uint;
      
      protected var FSkillId:uint;
      
      public function TSkillConfig()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FSkillId = param1.readUnsignedInt();
         this.FName = TUtilityString.FetchUTF(param1);
         this.FDesc = TUtilityString.FetchUTF(param1);
         this.FIcon = param1.readUnsignedInt();
         this.FSortId = param1.readUnsignedInt();
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function get Icon() : uint
      {
         return this.FIcon;
      }
      
      public function get SortId() : uint
      {
         return this.FSortId;
      }
      
      public function get SkillId() : uint
      {
         return this.FSkillId;
      }
   }
}

