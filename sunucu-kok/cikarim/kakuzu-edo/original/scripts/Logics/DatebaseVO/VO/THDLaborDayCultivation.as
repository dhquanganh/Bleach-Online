package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDLaborDayCultivation extends THDActivityBase
   {
      
      protected var FWater:Object;
      
      protected var FWeeding:Object;
      
      protected var FScore:uint;
      
      protected var FGift:Object;
      
      protected var FItemId:uint;
      
      protected var FText:String;
      
      public function THDLaborDayCultivation()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FWater = Json.decode(TUtilityString.FetchUTF(param1));
         this.FWeeding = Json.decode(TUtilityString.FetchUTF(param1));
         this.FScore = Json.decode(TUtilityString.FetchUTF(param1)).index;
         this.FGift = Json.decode(TUtilityString.FetchUTF(param1));
         this.FItemId = param1.readUnsignedInt();
         this.FText = TUtilityString.FetchUTF(param1);
      }
      
      public function get Water() : Object
      {
         return this.FWater;
      }
      
      public function get Weeding() : Object
      {
         return this.FWeeding;
      }
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function get Gift() : Object
      {
         return this.FGift;
      }
      
      public function get ItemId() : uint
      {
         return this.FItemId;
      }
      
      public function get Text() : String
      {
         return this.FText;
      }
   }
}

