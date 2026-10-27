package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class THeroTalent extends TDatebaseVO
   {
      
      protected var FTalentName:String;
      
      protected var FTalentDesc:String;
      
      public function THeroTalent()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FTalentName = TUtilityString.FetchUTF(param1);
         this.FTalentDesc = TUtilityString.FetchUTF(param1);
      }
      
      public function get TalentName() : String
      {
         return this.FTalentName;
      }
      
      public function get TalentDesc() : String
      {
         return this.FTalentDesc;
      }
   }
}

