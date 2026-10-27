package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TSingleResetCharge extends TDatebaseVO
   {
      
      protected var FValue:uint;
      
      public function TSingleResetCharge()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FValue = param1.readUnsignedInt();
      }
      
      public function get Value() : uint
      {
         return this.FValue;
      }
   }
}

