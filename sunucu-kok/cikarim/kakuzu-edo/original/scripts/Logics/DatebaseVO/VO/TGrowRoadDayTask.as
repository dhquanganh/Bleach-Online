package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TGrowRoadDayTask extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FDescription:String;
      
      protected var FUnlockCondition:uint;
      
      protected var FIsGoto:uint;
      
      protected var FPicture:uint;
      
      protected var FDescribeText:String;
      
      protected var FDropOutText:String;
      
      public function TGrowRoadDayTask()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FName = TUtilityString.FetchUTF(param1);
         this.FDescription = TUtilityString.FetchUTF(param1);
         this.FUnlockCondition = param1.readUnsignedInt();
         this.FIsGoto = param1.readUnsignedInt();
         this.FPicture = param1.readUnsignedInt();
         this.FDescribeText = TUtilityString.FetchUTF(param1);
         this.FDropOutText = TUtilityString.FetchUTF(param1);
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get Description() : String
      {
         return this.FDescription;
      }
      
      public function get UnlockCondition() : uint
      {
         return this.FUnlockCondition;
      }
      
      public function get IsGoto() : uint
      {
         return this.FIsGoto;
      }
      
      public function get Picture() : uint
      {
         return this.FPicture;
      }
      
      public function get DescribeText() : String
      {
         return this.FDescribeText;
      }
      
      public function get DropOutText() : String
      {
         return this.FDropOutText;
      }
   }
}

