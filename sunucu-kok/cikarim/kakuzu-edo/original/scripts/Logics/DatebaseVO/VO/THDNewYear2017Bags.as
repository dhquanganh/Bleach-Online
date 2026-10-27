package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDNewYear2017Bags extends THDActivityBase
   {
      
      protected var FOrangeAward:Vector.<Object>;
      
      protected var FRedAward:Vector.<Object>;
      
      protected var FOrangeIndex:uint;
      
      protected var FRedIndex:uint;
      
      protected var FRechargeIndex:uint;
      
      protected var FScoreIndex:uint;
      
      protected var FOrangeCond:uint;
      
      protected var FRedCond:uint;
      
      protected var FMall:Vector.<Object>;
      
      protected var FBag:Object;
      
      protected var FText:String;
      
      public function THDNewYear2017Bags()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FOrangeAward = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FRedAward = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FOrangeIndex = param1.readUnsignedInt();
         this.FRedIndex = param1.readUnsignedInt();
         this.FRechargeIndex = param1.readUnsignedInt();
         this.FScoreIndex = param1.readUnsignedInt();
         this.FOrangeCond = param1.readUnsignedInt();
         this.FRedCond = param1.readUnsignedInt();
         this.FMall = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FBag = Json.decode(TUtilityString.FetchUTF(param1));
         this.FText = TUtilityString.FetchUTF(param1);
      }
      
      public function get OrangeAward() : Vector.<Object>
      {
         return this.FOrangeAward;
      }
      
      public function get RedAward() : Vector.<Object>
      {
         return this.FRedAward;
      }
      
      public function get OrangeIndex() : uint
      {
         return this.FOrangeIndex;
      }
      
      public function get RedIndex() : uint
      {
         return this.FRedIndex;
      }
      
      public function get RechargeIndex() : uint
      {
         return this.FRechargeIndex;
      }
      
      public function get ScoreIndex() : uint
      {
         return this.FScoreIndex;
      }
      
      public function get OrangeCond() : uint
      {
         return this.FOrangeCond;
      }
      
      public function get RedCond() : uint
      {
         return this.FRedCond;
      }
      
      public function get Mall() : Vector.<Object>
      {
         return this.FMall;
      }
      
      public function get Text() : String
      {
         return this.FText;
      }
      
      public function get Bag() : Object
      {
         return this.FBag;
      }
   }
}

