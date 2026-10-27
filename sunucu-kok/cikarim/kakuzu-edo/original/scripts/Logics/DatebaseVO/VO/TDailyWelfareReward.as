package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TDailyWelfareReward extends TDatebaseVO
   {
      
      protected var FExp:uint;
      
      protected var FGold:uint;
      
      public function TDailyWelfareReward()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FExp = param1.readUnsignedInt();
         this.FGold = param1.readUnsignedInt();
      }
      
      public function get Exp() : uint
      {
         return this.FExp;
      }
      
      public function get Gold() : uint
      {
         return this.FGold;
      }
   }
}

