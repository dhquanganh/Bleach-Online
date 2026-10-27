package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TBuildConsume extends TDatebaseVO
   {
      
      protected var FBuildLevel:int;
      
      protected var FQuality:uint;
      
      protected var FConsume:int;
      
      public function TBuildConsume()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FBuildLevel = param1.readUnsignedInt();
         this.FQuality = param1.readUnsignedInt();
         this.FConsume = param1.readUnsignedInt();
      }
      
      public function get Consume() : int
      {
         return this.FConsume;
      }
      
      public function get BuildLevel() : int
      {
         return this.FBuildLevel;
      }
      
      public function get Quality() : uint
      {
         return this.FQuality;
      }
   }
}

