package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TMagicStoneSkills;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TMagicStone extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FFunc:String;
      
      protected var FMagicSkills:TMagicStoneSkills;
      
      public function TMagicStone()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FName = TUtilityString.FetchUTF(param1);
         this.FFunc = TUtilityString.FetchUTF(param1);
         this.FMagicSkills = new TMagicStoneSkills(this.FFunc);
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get MagicSkills() : TMagicStoneSkills
      {
         return this.FMagicSkills;
      }
   }
}

