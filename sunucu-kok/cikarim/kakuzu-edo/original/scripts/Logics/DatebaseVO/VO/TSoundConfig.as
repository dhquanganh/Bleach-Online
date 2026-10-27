package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TSoundConfig extends TDatebaseVO
   {
      
      protected var FSoundID:int;
      
      public function TSoundConfig()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FSoundID = param1.readUnsignedInt();
      }
      
      public function get SoundID() : int
      {
         return this.FSoundID;
      }
   }
}

