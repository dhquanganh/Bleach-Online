package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TSlaveGainExp extends TDatebaseVO
   {
      
      protected var FLevel:uint;
      
      protected var FExtractable:uint;
      
      protected var FPressible:uint;
      
      protected var FOperation:uint;
      
      public function TSlaveGainExp()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FLevel = param1.readUnsignedInt();
         this.FExtractable = param1.readUnsignedInt();
         this.FPressible = param1.readUnsignedInt();
         this.FOperation = param1.readUnsignedInt();
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function get Extractable() : uint
      {
         return this.FExtractable;
      }
      
      public function get Pressible() : uint
      {
         return this.FPressible;
      }
      
      public function get Operation() : uint
      {
         return this.FOperation;
      }
   }
}

