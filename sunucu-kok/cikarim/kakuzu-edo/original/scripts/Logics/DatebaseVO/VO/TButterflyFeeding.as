package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TRewards;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TButterflyFeeding extends TDatebaseVO
   {
      
      protected var FVipLevel:uint;
      
      protected var FPowderLevel:uint;
      
      protected var FButterflyRewards:TRewards;
      
      public function TButterflyFeeding()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         this.FVipLevel = param1.readUnsignedInt();
         this.FPowderLevel = param1.readUnsignedInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FButterflyRewards = new TRewards(_loc2_);
      }
      
      public function get VipLevel() : uint
      {
         return this.FVipLevel;
      }
      
      public function get PowderLevel() : uint
      {
         return this.FPowderLevel;
      }
      
      public function get ButterflyRewards() : TRewards
      {
         return this.FButterflyRewards;
      }
   }
}

