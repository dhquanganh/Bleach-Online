package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class THomeGambleBox extends TDatebaseVO
   {
      
      protected var FNeedScore:int;
      
      protected var FBoxName:String;
      
      public function THomeGambleBox()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FNeedScore = param1.readUnsignedInt();
         this.FBoxName = TUtilityString.FetchUTF(param1);
      }
      
      public function get NeedScore() : int
      {
         return this.FNeedScore;
      }
      
      public function get BoxName() : String
      {
         return this.FBoxName;
      }
   }
}

