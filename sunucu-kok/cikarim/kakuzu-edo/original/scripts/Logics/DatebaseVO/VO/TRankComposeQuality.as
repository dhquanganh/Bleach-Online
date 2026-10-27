package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TRankComposeQuality extends TDatebaseVO
   {
      
      protected var FFrom:int;
      
      protected var FTo:int;
      
      protected var FQuality:int;
      
      protected var FDesc:String;
      
      public function TRankComposeQuality()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FFrom = param1.readUnsignedInt();
         this.FTo = param1.readUnsignedInt();
         this.FQuality = param1.readUnsignedInt();
         this.FDesc = TUtilityString.FetchUTF(param1);
      }
      
      public function get From() : int
      {
         return this.FFrom;
      }
      
      public function get To() : int
      {
         return this.FTo;
      }
      
      public function get Quality() : int
      {
         return this.FQuality;
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
   }
}

