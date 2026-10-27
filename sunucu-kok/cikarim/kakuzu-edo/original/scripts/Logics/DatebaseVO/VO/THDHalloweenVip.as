package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDHalloweenVip extends THDActivityBase
   {
      
      protected var FDayFreeGifts:Vector.<Object>;
      
      protected var FDayChargeGifts:Vector.<Object>;
      
      protected var FProgressChargeGifts:Vector.<Object>;
      
      protected var FRechargeIndex:int;
      
      protected var FProgressChargeIndex:int;
      
      protected var FMaskId:int;
      
      public function THDHalloweenVip()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FDayFreeGifts = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FDayChargeGifts = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FProgressChargeGifts = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FRechargeIndex = param1.readUnsignedInt();
         this.FProgressChargeIndex = param1.readUnsignedInt();
         this.FMaskId = param1.readUnsignedInt();
      }
      
      public function get DayFreeGifts() : Vector.<Object>
      {
         return this.FDayFreeGifts;
      }
      
      public function get DayChargeGifts() : Vector.<Object>
      {
         return this.FDayChargeGifts;
      }
      
      public function get ProgressChargeGifts() : Vector.<Object>
      {
         return this.FProgressChargeGifts;
      }
      
      public function get RechargeIndex() : int
      {
         return this.FRechargeIndex;
      }
      
      public function get ProgressChargeIndex() : int
      {
         return this.FProgressChargeIndex;
      }
      
      public function get MaskId() : int
      {
         return this.FMaskId;
      }
   }
}

