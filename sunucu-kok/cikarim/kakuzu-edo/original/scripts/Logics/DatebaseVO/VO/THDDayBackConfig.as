package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDDayBackConfig extends THDActivityBase
   {
      
      protected var FLoginGift:Object;
      
      protected var FRechargeIndex:int;
      
      protected var FRechargeReceiveIndex:int;
      
      protected var FRechargeGift:Vector.<Object>;
      
      protected var FFinalGift:Object;
      
      protected var FLink:int;
      
      public function THDDayBackConfig()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FLoginGift = Json.decode(TUtilityString.FetchUTF(param1));
         this.FRechargeIndex = param1.readInt();
         this.FRechargeReceiveIndex = param1.readInt();
         this.FRechargeGift = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FFinalGift = Json.decode(TUtilityString.FetchUTF(param1));
         this.FLink = param1.readInt();
      }
      
      public function get LoginGift() : Object
      {
         return this.FLoginGift;
      }
      
      public function get RechargeIndex() : int
      {
         return this.FRechargeIndex;
      }
      
      public function get RechargeReceiveIndex() : int
      {
         return this.FRechargeReceiveIndex;
      }
      
      public function get RechargeGift() : Vector.<Object>
      {
         return this.FRechargeGift;
      }
      
      public function get FinalGift() : Object
      {
         return this.FFinalGift;
      }
      
      public function get Link() : int
      {
         return this.FLink;
      }
   }
}

