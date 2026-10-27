package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TStarPointDesc extends TDatebaseVO
   {
      
      protected var FDesc:String;
      
      protected var FViewType:int;
      
      public function TStarPointDesc()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FDesc = TUtilityString.FetchUTF(param1);
         this.FViewType = param1.readUnsignedInt();
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function get ViewType() : int
      {
         return this.FViewType;
      }
   }
}

