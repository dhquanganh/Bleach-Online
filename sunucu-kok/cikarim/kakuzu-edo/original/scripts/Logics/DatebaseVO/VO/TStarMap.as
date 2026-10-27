package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TStarMap extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FProfession:int;
      
      protected var FQuality:int;
      
      protected var FPointCount:int;
      
      protected var FPic:String;
      
      protected var FDesc:String;
      
      protected var FStartID:int;
      
      public function TStarMap()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FName = TUtilityString.FetchUTF(param1);
         this.FProfession = param1.readUnsignedInt();
         this.FQuality = param1.readUnsignedInt();
         this.FPointCount = param1.readUnsignedInt();
         this.FPic = TUtilityString.FetchUTF(param1);
         this.FDesc = TUtilityString.FetchUTF(param1);
         this.FStartID = param1.readUnsignedInt();
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get Profession() : int
      {
         return this.FProfession;
      }
      
      public function get Quality() : int
      {
         return this.FQuality;
      }
      
      public function get PointCount() : int
      {
         return this.FPointCount;
      }
      
      public function get Pic() : String
      {
         return this.FPic;
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function get StartID() : int
      {
         return this.FStartID;
      }
   }
}

