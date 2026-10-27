package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDEveryDayAward extends THDActivityBase
   {
      
      protected var FRechargeGift:Vector.<Object>;
      
      protected var FRechargeIndex:int;
      
      protected var FRechargeGiftIndex:int;
      
      protected var FParticipateIndex:int;
      
      protected var FShareGift:Vector.<Object>;
      
      protected var FRechargeIndexs:Vector.<int>;
      
      protected var FBuyIndexs:Vector.<int>;
      
      protected var FLanguage:Object;
      
      public function THDEveryDayAward()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FRechargeGift = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FRechargeIndex = param1.readInt();
         this.FRechargeGiftIndex = param1.readInt();
         this.FParticipateIndex = param1.readInt();
         this.FShareGift = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FRechargeIndexs = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FBuyIndexs = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FLanguage = Json.decode(TUtilityString.FetchUTF(param1));
      }
      
      public function get RechargeGift() : Vector.<Object>
      {
         return this.FRechargeGift;
      }
      
      public function get RechargeIndex() : int
      {
         return this.FRechargeIndex;
      }
      
      public function get RechargeGiftIndex() : int
      {
         return this.FRechargeGiftIndex;
      }
      
      public function get ParticipateIndex() : int
      {
         return this.FParticipateIndex;
      }
      
      public function get ShareGift() : Vector.<Object>
      {
         return this.FShareGift;
      }
      
      public function get RechargeIndexs() : Vector.<int>
      {
         return this.FRechargeIndexs;
      }
      
      public function get BuyIndexs() : Vector.<int>
      {
         return this.FBuyIndexs;
      }
      
      public function get Language() : Object
      {
         return this.FLanguage;
      }
   }
}

