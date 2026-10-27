package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class THDActivityBase extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FTName:String;
      
      protected var FDesc:String;
      
      protected var FTip:String;
      
      protected var FPrice:uint;
      
      protected var FImageID:uint;
      
      public function THDActivityBase()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FName = TUtilityString.FetchUTF(param1);
         this.FTName = TUtilityString.FetchUTF(param1);
         this.FDesc = TUtilityString.FetchUTF(param1);
         this.FTip = TUtilityString.FetchUTF(param1);
         this.FPrice = param1.readUnsignedInt();
         this.FImageID = param1.readUnsignedInt();
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get TName() : String
      {
         return this.FTName;
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function get Tip() : String
      {
         return this.FTip;
      }
      
      public function get Price() : uint
      {
         return this.FPrice;
      }
      
      public function get ImageID() : uint
      {
         return this.FImageID;
      }
   }
}

