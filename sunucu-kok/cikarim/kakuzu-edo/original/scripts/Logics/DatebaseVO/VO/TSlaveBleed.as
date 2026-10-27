package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TSlaveBleed extends TDatebaseVO
   {
      
      protected var FHours:uint;
      
      protected var FCost:uint;
      
      public function TSlaveBleed()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FHours = param1.readUnsignedInt();
         this.FCost = param1.readUnsignedInt();
      }
      
      public function get Hours() : uint
      {
         return this.FHours;
      }
      
      public function get Cost() : uint
      {
         return this.FCost;
      }
   }
}

