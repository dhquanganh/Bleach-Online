package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class THomeFortune extends TDatebaseVO
   {
      
      protected var FPlayerLv:uint;
      
      protected var FBaseMoney:uint;
      
      public function THomeFortune()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FPlayerLv = param1.readInt();
         this.FBaseMoney = param1.readInt();
      }
      
      public function get PlayerLv() : uint
      {
         return this.FPlayerLv;
      }
      
      public function get BaseMoney() : uint
      {
         return this.FBaseMoney;
      }
   }
}

