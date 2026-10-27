package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDFeedbackConfig extends THDActivityBase
   {
      
      protected var FSignInIndex:int;
      
      protected var FRechargeIndex:int;
      
      protected var FConsumeIndex:int;
      
      protected var FSignInReceiveIndex:int;
      
      protected var FRechargeReceiveIndex:int;
      
      protected var FConsumeReceiveIndex:int;
      
      protected var FFinalReceiveIndex:int;
      
      protected var FSignInGift:Vector.<Object>;
      
      protected var FRechargeGift:Vector.<Object>;
      
      protected var FConsumeGift:Vector.<Object>;
      
      protected var FFinalGift:Object;
      
      protected var FLink:Object;
      
      protected var FLanguage:Object;
      
      public function THDFeedbackConfig()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FSignInIndex = param1.readInt();
         this.FRechargeIndex = param1.readInt();
         this.FConsumeIndex = param1.readInt();
         this.FSignInReceiveIndex = param1.readInt();
         this.FRechargeReceiveIndex = param1.readInt();
         this.FConsumeReceiveIndex = param1.readInt();
         this.FFinalReceiveIndex = param1.readInt();
         this.FSignInGift = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FRechargeGift = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FConsumeGift = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FFinalGift = Json.decode(TUtilityString.FetchUTF(param1));
         this.FLink = Json.decode(TUtilityString.FetchUTF(param1));
         this.FLanguage = Json.decode(TUtilityString.FetchUTF(param1));
      }
      
      public function get SignInIndex() : int
      {
         return this.FSignInIndex;
      }
      
      public function get RechargeIndex() : int
      {
         return this.FRechargeIndex;
      }
      
      public function get ConsumeIndex() : int
      {
         return this.FConsumeIndex;
      }
      
      public function get SignInGift() : Vector.<Object>
      {
         return this.FSignInGift;
      }
      
      public function get RechargeGift() : Vector.<Object>
      {
         return this.FRechargeGift;
      }
      
      public function get ConsumeGift() : Vector.<Object>
      {
         return this.FConsumeGift;
      }
      
      public function get FinalGift() : Object
      {
         return this.FFinalGift;
      }
      
      public function get Language() : Object
      {
         return this.FLanguage;
      }
      
      public function get Link() : Object
      {
         return this.FLink;
      }
      
      public function get SignInReceiveIndex() : int
      {
         return this.FSignInReceiveIndex;
      }
      
      public function get RechargeReceiveIndex() : int
      {
         return this.FRechargeReceiveIndex;
      }
      
      public function get ConsumeReceiveIndex() : int
      {
         return this.FConsumeReceiveIndex;
      }
      
      public function get FinalReceiveIndex() : int
      {
         return this.FFinalReceiveIndex;
      }
   }
}

