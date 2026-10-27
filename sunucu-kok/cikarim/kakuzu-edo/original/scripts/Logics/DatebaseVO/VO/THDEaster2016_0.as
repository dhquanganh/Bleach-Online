package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDEaster2016_0 extends THDActivityBase
   {
      
      protected var FTimeAwardIndex:uint;
      
      protected var FTimeAwardObj:Object;
      
      protected var FGift00:Object;
      
      protected var FGift01:Object;
      
      protected var FGift02:Object;
      
      protected var FGift03:Object;
      
      protected var FBigAward:Object;
      
      protected var FEggIndex:uint;
      
      protected var FServerLimit:uint;
      
      protected var FEgg02Index:uint;
      
      protected var FEgg03Index:uint;
      
      protected var FEggId:uint;
      
      protected var FText:String;
      
      public function THDEaster2016_0()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FTimeAwardIndex = param1.readUnsignedInt();
         this.FTimeAwardObj = Json.decode(TUtilityString.FetchUTF(param1));
         this.FGift00 = Json.decode(TUtilityString.FetchUTF(param1));
         this.FGift01 = Json.decode(TUtilityString.FetchUTF(param1));
         this.FGift02 = Json.decode(TUtilityString.FetchUTF(param1));
         this.FGift03 = Json.decode(TUtilityString.FetchUTF(param1));
         this.FBigAward = Json.decode(TUtilityString.FetchUTF(param1));
         this.FEggIndex = param1.readUnsignedInt();
         this.FServerLimit = param1.readUnsignedInt();
         this.FEgg02Index = param1.readUnsignedInt();
         this.FEgg03Index = param1.readUnsignedInt();
         this.FEggId = param1.readUnsignedInt();
         this.FText = param1.readUTF();
      }
      
      public function get TimeAwardIndex() : uint
      {
         return this.FTimeAwardIndex;
      }
      
      public function get Gift01() : Object
      {
         return this.FGift01;
      }
      
      public function get Gift02() : Object
      {
         return this.FGift02;
      }
      
      public function get Gift03() : Object
      {
         return this.FGift03;
      }
      
      public function get BigAward() : Object
      {
         return this.FBigAward;
      }
      
      public function get EggIndex() : uint
      {
         return this.FEggIndex;
      }
      
      public function get EggId() : uint
      {
         return this.FEggId;
      }
      
      public function get Gift00() : Object
      {
         return this.FGift00;
      }
      
      public function get TimeAwardObj() : Object
      {
         return this.FTimeAwardObj;
      }
      
      public function get ServerLimit() : uint
      {
         return this.FServerLimit;
      }
      
      public function get Egg02Index() : uint
      {
         return this.FEgg02Index;
      }
      
      public function get Egg03Index() : uint
      {
         return this.FEgg03Index;
      }
      
      public function get Text() : String
      {
         return this.FText;
      }
   }
}

