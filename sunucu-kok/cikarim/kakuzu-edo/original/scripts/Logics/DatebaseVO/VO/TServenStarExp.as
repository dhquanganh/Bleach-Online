package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TServenStarExp extends TDatebaseVO
   {
      
      protected var FNeedExp:int;
      
      protected var FType:int;
      
      protected var FValue:String;
      
      public function TServenStarExp()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FNeedExp = param1.readUnsignedInt();
         this.FType = param1.readUnsignedInt();
         this.FValue = TUtilityString.FetchUTF(param1);
      }
      
      public function get NeedExp() : int
      {
         return this.FNeedExp;
      }
      
      public function get Type() : int
      {
         return this.FType;
      }
      
      public function get Value() : String
      {
         return this.FValue;
      }
   }
}

