package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDKnifeHeroCollect extends THDActivityBase
   {
      
      public static const MaxAwardCount:uint = 1000;
      
      protected var FConsumeGold:Vector.<Object>;
      
      protected var FKnifeCondition:Vector.<Object>;
      
      protected var FKnifeAward:Vector.<Object>;
      
      protected var FRechargeGold:Vector.<Object>;
      
      protected var FHeroCondition:Vector.<Object>;
      
      protected var FHeroAward:Vector.<Object>;
      
      protected var FConsumeGoldIndex:int;
      
      protected var FRechargeGoldIndex:int;
      
      protected var FLanguage:Object;
      
      protected var FKnifeConditionDict:Dictionary = new Dictionary();
      
      protected var FKnifeAwardDict:Dictionary = new Dictionary();
      
      protected var FHeroConditionDict:Dictionary = new Dictionary();
      
      protected var FHeroAwardDict:Dictionary = new Dictionary();
      
      public function THDKnifeHeroCollect()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FConsumeGold = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FKnifeCondition = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FKnifeAward = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FRechargeGold = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FHeroCondition = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FHeroAward = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FConsumeGoldIndex = param1.readInt();
         this.FRechargeGoldIndex = param1.readInt();
         this.FLanguage = Json.decode(TUtilityString.FetchUTF(param1));
         this.ToDict(this.FKnifeCondition,this.FKnifeConditionDict);
         this.ToDict(this.FKnifeAward,this.FKnifeAwardDict);
         this.ToDict(this.FHeroCondition,this.FHeroConditionDict);
         this.ToDict(this.FHeroAward,this.FHeroAwardDict);
      }
      
      protected function ToDict(param1:Vector.<Object>, param2:Dictionary) : void
      {
         var _loc3_:Object = null;
         for each(_loc3_ in param1)
         {
            param2[_loc3_.key] = _loc3_.value;
         }
      }
      
      public function get ConsumeGold() : Vector.<Object>
      {
         return this.FConsumeGold;
      }
      
      public function get KnifeCondition() : Vector.<Object>
      {
         return this.FKnifeCondition;
      }
      
      public function get KnifeAward() : Vector.<Object>
      {
         return this.FKnifeAward;
      }
      
      public function get RechargeGold() : Vector.<Object>
      {
         return this.FRechargeGold;
      }
      
      public function get HeroCondition() : Vector.<Object>
      {
         return this.FHeroCondition;
      }
      
      public function get HeroAward() : Vector.<Object>
      {
         return this.FHeroAward;
      }
      
      public function get ConsumeGoldIndex() : int
      {
         return this.FConsumeGoldIndex;
      }
      
      public function get RechargeGoldIndex() : int
      {
         return this.FRechargeGoldIndex;
      }
      
      public function get Language() : Object
      {
         return this.FLanguage;
      }
      
      public function get KnifeConditionDict() : Dictionary
      {
         return this.FKnifeConditionDict;
      }
      
      public function get KnifeAwardDict() : Dictionary
      {
         return this.FKnifeAwardDict;
      }
      
      public function get HeroConditionDict() : Dictionary
      {
         return this.FHeroConditionDict;
      }
      
      public function get HeroAwardDict() : Dictionary
      {
         return this.FHeroAwardDict;
      }
   }
}

