package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDTreasureHunt extends THDActivityBase
   {
      
      protected var FVipIndex:uint;
      
      protected var FItemIndex:uint;
      
      protected var FTimeIndex:uint;
      
      protected var FUTCIndex:uint;
      
      protected var FStartIndex:uint;
      
      protected var FFinishIndex:uint;
      
      protected var FScore:uint;
      
      protected var FItems:Vector.<Object>;
      
      protected var FEvents:Vector.<Object>;
      
      protected var FGolds:Vector.<int>;
      
      protected var FHint:Object;
      
      public function THDTreasureHunt()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FVipIndex = param1.readInt();
         this.FItemIndex = param1.readInt();
         this.FTimeIndex = param1.readInt();
         this.FUTCIndex = param1.readInt();
         this.FStartIndex = param1.readInt();
         this.FFinishIndex = param1.readInt();
         this.FScore = param1.readInt();
         this.FItems = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FEvents = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FGolds = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FHint = TUtilityString.FetchUTF(param1);
      }
      
      public function get VipIndex() : uint
      {
         return this.FVipIndex;
      }
      
      public function get ItemIndex() : uint
      {
         return this.FItemIndex;
      }
      
      public function get TimeIndex() : uint
      {
         return this.FTimeIndex;
      }
      
      public function get UTCIndex() : uint
      {
         return this.FUTCIndex;
      }
      
      public function get StartIndex() : uint
      {
         return this.FStartIndex;
      }
      
      public function get FinishIndex() : uint
      {
         return this.FFinishIndex;
      }
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function get Events() : Vector.<Object>
      {
         return this.FEvents;
      }
      
      public function get Golds() : Vector.<int>
      {
         return this.FGolds;
      }
      
      public function get Hint() : Object
      {
         return this.FHint;
      }
      
      public function get Items() : Vector.<Object>
      {
         return this.FItems;
      }
   }
}

