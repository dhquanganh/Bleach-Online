package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TFirecrackersConfig extends THDActivityBase
   {
      
      protected var FFirecrackersAward:Vector.<Object>;
      
      protected var FPackageAward:Vector.<int>;
      
      protected var FFirecrackersRelate:Vector.<Object>;
      
      protected var FFinalAward:Vector.<Object>;
      
      protected var FLightingAndReset:Vector.<Object>;
      
      protected var FFreeTimeIndex:Vector.<Object>;
      
      protected var FFreeTime:Vector.<Object>;
      
      protected var FFinalAwardState:int;
      
      protected var FFirecrackersNumIndex:int;
      
      protected var FInsideAwardState:int;
      
      protected var FOutsideAwardState:int;
      
      protected var FOneKeyLighting:int;
      
      protected var FOneKeyDraw:int;
      
      protected var FDiscount:int;
      
      protected var FLanguage:Object;
      
      public function TFirecrackersConfig()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FFirecrackersAward = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FPackageAward = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FFirecrackersRelate = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FFinalAward = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FLightingAndReset = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FFreeTimeIndex = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FFreeTime = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FFinalAwardState = param1.readInt();
         this.FFirecrackersNumIndex = param1.readInt();
         this.FInsideAwardState = param1.readInt();
         this.FOutsideAwardState = param1.readInt();
         this.FOneKeyLighting = param1.readInt();
         this.FOneKeyDraw = param1.readInt();
         this.FDiscount = param1.readInt();
         this.FLanguage = Json.decode(TUtilityString.FetchUTF(param1));
      }
      
      public function get FirecrackersAward() : Vector.<Object>
      {
         return this.FFirecrackersAward;
      }
      
      public function get PackageAward() : Vector.<int>
      {
         return this.FPackageAward;
      }
      
      public function get FinalAward() : Vector.<Object>
      {
         return this.FFinalAward;
      }
      
      public function get LightingAndReset() : Vector.<Object>
      {
         return this.FLightingAndReset;
      }
      
      public function get FreeTimeIndex() : Vector.<Object>
      {
         return this.FFreeTimeIndex;
      }
      
      public function get FreeTime() : Vector.<Object>
      {
         return this.FFreeTime;
      }
      
      public function get FirecrackersRelate() : Vector.<Object>
      {
         return this.FFirecrackersRelate;
      }
      
      public function get FirecrackersNumIndex() : int
      {
         return this.FFirecrackersNumIndex;
      }
      
      public function get OneKeyLighting() : int
      {
         return this.FOneKeyLighting;
      }
      
      public function get OneKeyDraw() : int
      {
         return this.FOneKeyDraw;
      }
      
      public function get Discount() : int
      {
         return this.FDiscount;
      }
      
      public function get FinalAwardState() : int
      {
         return this.FFinalAwardState;
      }
      
      public function get InsideAwardState() : int
      {
         return this.FInsideAwardState;
      }
      
      public function set InsideAwardState(param1:int) : void
      {
         this.FInsideAwardState = param1;
      }
      
      public function get OutsideAwardState() : int
      {
         return this.FOutsideAwardState;
      }
      
      public function set OutsideAwardState(param1:int) : void
      {
         this.FOutsideAwardState = param1;
      }
      
      public function get Language() : Object
      {
         return this.FLanguage;
      }
      
      public function set Language(param1:Object) : void
      {
         this.FLanguage = param1;
      }
   }
}

