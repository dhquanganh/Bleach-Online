package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TEquipUpgrade extends TDatebaseVO
   {
      
      protected static const SYMBOLB:String = "_";
      
      protected static const COUNT:uint = 2;
      
      protected var FGotEquipId:int;
      
      protected var FDatum:String;
      
      protected var FMaterial:int;
      
      protected var FQuantity:int;
      
      public function TEquipUpgrade()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FGotEquipId = param1.readUnsignedInt();
         this.FDatum = TUtilityString.FetchUTF(param1);
         this.FMaterial = this.FDatum.split(SYMBOLB)[0];
         this.FQuantity = this.FDatum.split(SYMBOLB)[1];
      }
      
      public function get Material() : int
      {
         return this.FMaterial;
      }
      
      public function get Quantity() : int
      {
         return this.FQuantity;
      }
      
      public function get GotEquipId() : int
      {
         return this.FGotEquipId;
      }
      
      public function get Datum() : String
      {
         return this.FDatum;
      }
   }
}

