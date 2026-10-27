package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class THDChildrenDayHero extends THDActivityBase
   {
      
      protected var FBuyScoreIndex:uint;
      
      protected var FBuyGoldIndex:uint;
      
      protected var FScale:uint;
      
      protected var FRelatedId:uint;
      
      public function THDChildrenDayHero()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FBuyScoreIndex = param1.readUnsignedInt();
         this.FBuyGoldIndex = param1.readUnsignedInt();
         this.FScale = param1.readUnsignedInt();
         this.FRelatedId = param1.readUnsignedInt();
      }
      
      public function get BuyScoreIndex() : uint
      {
         return this.FBuyScoreIndex;
      }
      
      public function get BuyGoldIndex() : uint
      {
         return this.FBuyGoldIndex;
      }
      
      public function get Scale() : uint
      {
         return this.FScale;
      }
      
      public function get RelatedId() : uint
      {
         return this.FRelatedId;
      }
   }
}

