package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TButterfly extends TDatebaseVO
   {
      
      protected var FUpgradeExp:uint;
      
      protected var FModelId:uint;
      
      public function TButterfly()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FUpgradeExp = param1.readUnsignedInt();
         this.FModelId = param1.readUnsignedInt();
      }
      
      public function get UpgradeExp() : uint
      {
         return this.FUpgradeExp;
      }
      
      public function get ModelId() : uint
      {
         return this.FModelId;
      }
   }
}

