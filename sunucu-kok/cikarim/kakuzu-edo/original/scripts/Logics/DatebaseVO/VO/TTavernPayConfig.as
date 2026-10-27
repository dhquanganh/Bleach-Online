package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TTavernPayConfigTypes;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TTavernPayConfig extends TDatebaseVO
   {
      
      protected var FKey:String;
      
      protected var FTypesVect:TTavernPayConfigTypes;
      
      protected var FValue:int;
      
      protected var FDesc:String;
      
      protected var FTypes:String;
      
      public function TTavernPayConfig()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         this.FKey = TUtilityString.FetchUTF(param1);
         this.FTypes = TUtilityString.FetchUTF(param1);
         this.FTypesVect = new TTavernPayConfigTypes(this.FTypes);
         this.FValue = param1.readUnsignedInt();
         this.FDesc = TUtilityString.FetchUTF(param1);
      }
      
      public function get Key() : String
      {
         return this.FKey;
      }
      
      public function get TypesVect() : TTavernPayConfigTypes
      {
         return this.FTypesVect;
      }
      
      public function get Value() : int
      {
         return this.FValue;
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function get Types() : String
      {
         return this.FTypes;
      }
   }
}

