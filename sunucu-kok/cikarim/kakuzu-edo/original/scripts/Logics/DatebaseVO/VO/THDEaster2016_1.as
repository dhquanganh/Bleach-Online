package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDEaster2016_1 extends THDActivityBase
   {
      
      protected var FRechargeTask:Vector.<Object>;
      
      protected var FConsumeTask:Vector.<Object>;
      
      protected var FRechargeGift:Vector.<Object>;
      
      protected var FConsumeGift:Vector.<Object>;
      
      protected var FBigAward:Object;
      
      protected var FEgg02Index:uint;
      
      protected var FEgg02Id:uint;
      
      protected var FEgg03Index:uint;
      
      protected var FEgg03Id:uint;
      
      protected var FEgg01Index:uint;
      
      protected var FRate:uint;
      
      protected var FRechargeIndex:uint;
      
      protected var FConsumeIndex:uint;
      
      protected var FPageIndex:uint;
      
      protected var FText:Object;
      
      public function THDEaster2016_1()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FRechargeTask = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FConsumeTask = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FRechargeGift = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FConsumeGift = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FBigAward = Json.decode(TUtilityString.FetchUTF(param1));
         this.FEgg02Index = param1.readUnsignedInt();
         this.FEgg02Id = param1.readUnsignedInt();
         this.FEgg03Index = param1.readUnsignedInt();
         this.FEgg03Id = param1.readUnsignedInt();
         this.FEgg01Index = param1.readUnsignedInt();
         this.FRate = param1.readUnsignedInt();
         this.FRechargeIndex = param1.readUnsignedInt();
         this.FConsumeIndex = param1.readUnsignedInt();
         this.FPageIndex = param1.readUnsignedInt();
         this.FText = Json.decode(TUtilityString.FetchUTF(param1));
      }
      
      public function get RechargeTask() : Vector.<Object>
      {
         return this.FRechargeTask;
      }
      
      public function get ConsumeTask() : Vector.<Object>
      {
         return this.FConsumeTask;
      }
      
      public function get RechargeGift() : Vector.<Object>
      {
         return this.FRechargeGift;
      }
      
      public function get ConsumeGift() : Vector.<Object>
      {
         return this.FConsumeGift;
      }
      
      public function get BigAward() : Object
      {
         return this.FBigAward;
      }
      
      public function get Egg02Index() : uint
      {
         return this.FEgg02Index;
      }
      
      public function get Egg02Id() : uint
      {
         return this.FEgg02Id;
      }
      
      public function get Egg03Index() : uint
      {
         return this.FEgg03Index;
      }
      
      public function get Egg03Id() : uint
      {
         return this.FEgg03Id;
      }
      
      public function get Egg01Index() : uint
      {
         return this.FEgg01Index;
      }
      
      public function get Rate() : uint
      {
         return this.FRate;
      }
      
      public function get RechargeIndex() : uint
      {
         return this.FRechargeIndex;
      }
      
      public function get ConsumeIndex() : uint
      {
         return this.FConsumeIndex;
      }
      
      public function get PageIndex() : uint
      {
         return this.FPageIndex;
      }
      
      public function get Text() : Object
      {
         return this.FText;
      }
   }
}

