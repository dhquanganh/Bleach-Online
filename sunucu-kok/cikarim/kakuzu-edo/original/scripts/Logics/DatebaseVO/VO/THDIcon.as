package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class THDIcon extends TDatebaseVO
   {
      
      protected var FCountID:uint;
      
      protected var FIconType:uint;
      
      protected var FMainType:uint;
      
      protected var FIconID:uint;
      
      public function THDIcon()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FCountID = param1.readUnsignedInt();
         this.FIconType = param1.readUnsignedInt();
         this.FMainType = param1.readUnsignedInt();
         this.FIconID = param1.readUnsignedInt();
      }
      
      public function get IconType() : uint
      {
         return this.FIconType;
      }
      
      public function get CountID() : uint
      {
         return this.FCountID;
      }
      
      public function get MainType() : uint
      {
         return this.FMainType;
      }
      
      public function get IconID() : uint
      {
         return this.FIconID;
      }
   }
}

