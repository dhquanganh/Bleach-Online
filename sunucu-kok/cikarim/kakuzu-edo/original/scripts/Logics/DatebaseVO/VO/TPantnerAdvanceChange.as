package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TPantnerAdvanceChange extends TDatebaseVO
   {
      
      protected var FDesc:String;
      
      protected var FValue:Object;
      
      protected var FClientDeec:String;
      
      protected var FViewList:String;
      
      public function TPantnerAdvanceChange()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FDesc = TUtilityString.FetchUTF(param1);
         this.FValue = Json.decode(TUtilityString.FetchUTF(param1));
         this.FClientDeec = TUtilityString.FetchUTF(param1);
         this.FViewList = TUtilityString.FetchUTF(param1);
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function get Value() : Object
      {
         return this.FValue;
      }
      
      public function get ClientDeec() : String
      {
         return this.FClientDeec;
      }
      
      public function get ViewList() : String
      {
         return this.FViewList;
      }
   }
}

