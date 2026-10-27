package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class THD_YDBuyGold extends TDatebaseVO
   {
      
      protected var FGoldNum:int;
      
      protected var FNormalPrice:int;
      
      protected var FYellowVipPrice:uint;
      
      protected var FVipLevel:uint;
      
      public function THD_YDBuyGold()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FGoldNum = param1.readUnsignedInt();
         this.FNormalPrice = param1.readUnsignedInt();
         this.FYellowVipPrice = param1.readUnsignedInt();
         this.FVipLevel = param1.readUnsignedInt();
      }
      
      public function get GoldNum() : int
      {
         return this.FGoldNum;
      }
      
      public function get NormalPrice() : int
      {
         return this.FNormalPrice;
      }
      
      public function get YellowVipPrice() : uint
      {
         return this.FYellowVipPrice;
      }
      
      public function get VipLevel() : uint
      {
         return this.FVipLevel;
      }
   }
}

