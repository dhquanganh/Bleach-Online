package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TTemplePliesNumber extends TDatebaseVO
   {
      
      protected var FNumberPlies:int;
      
      protected var FAwardID:int;
      
      public function TTemplePliesNumber()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FNumberPlies = param1.readInt();
         this.FAwardID = param1.readUnsignedInt();
      }
      
      public function get NumberPlies() : int
      {
         return this.FNumberPlies;
      }
      
      public function get AwardID() : int
      {
         return this.FAwardID;
      }
   }
}

