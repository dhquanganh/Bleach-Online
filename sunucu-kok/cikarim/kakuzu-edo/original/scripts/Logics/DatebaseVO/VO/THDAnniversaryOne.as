package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDAnniversaryOne extends THDActivityBase
   {
      
      protected var FOnRushIndex:uint;
      
      protected var FLoginAwardList:Vector.<Object>;
      
      protected var FExtraAwardList:Vector.<Object>;
      
      public function THDAnniversaryOne()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FOnRushIndex = param1.readUnsignedInt();
         this.FLoginAwardList = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FExtraAwardList = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
      }
      
      public function get OnRushIndex() : uint
      {
         return this.FOnRushIndex;
      }
      
      public function get LoginAwardList() : Vector.<Object>
      {
         return this.FLoginAwardList;
      }
      
      public function get ExtraAwardList() : Vector.<Object>
      {
         return this.FExtraAwardList;
      }
   }
}

