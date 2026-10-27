package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TTemplePVP extends TDatebaseVO
   {
      
      protected var FLayerID:uint;
      
      protected var FAwardID:uint;
      
      public function TTemplePVP()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         this.FLayerID = param1.readUnsignedInt();
         this.FAwardID = param1.readUnsignedInt();
      }
      
      public function get LayerID() : uint
      {
         return this.FLayerID;
      }
      
      public function get AwardID() : uint
      {
         return this.FAwardID;
      }
   }
}

