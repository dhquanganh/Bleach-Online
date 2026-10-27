package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TPetYearConfig extends THDActivityBase
   {
      
      protected var FFreeAward:Object;
      
      protected var FVicePet:Object;
      
      protected var FChipBox:Vector.<Object>;
      
      protected var FTask:Vector.<Object>;
      
      protected var FLanguage:Object;
      
      protected var FLink:Object;
      
      public function TPetYearConfig()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FFreeAward = Json.decode(TUtilityString.FetchUTF(param1));
         this.FVicePet = Json.decode(TUtilityString.FetchUTF(param1));
         this.FChipBox = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FTask = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FLanguage = Json.decode(TUtilityString.FetchUTF(param1));
         this.FLink = Json.decode(TUtilityString.FetchUTF(param1));
      }
      
      public function get FreeAward() : Object
      {
         return this.FFreeAward;
      }
      
      public function set FreeAward(param1:Object) : void
      {
         this.FFreeAward = param1;
      }
      
      public function get VicePet() : Object
      {
         return this.FVicePet;
      }
      
      public function set VicePet(param1:Object) : void
      {
         this.FVicePet = param1;
      }
      
      public function get ChipBox() : Vector.<Object>
      {
         return this.FChipBox;
      }
      
      public function set ChipBox(param1:Vector.<Object>) : void
      {
         this.FChipBox = param1;
      }
      
      public function get Task() : Vector.<Object>
      {
         return this.FTask;
      }
      
      public function set Task(param1:Vector.<Object>) : void
      {
         this.FTask = param1;
      }
      
      public function get Language() : Object
      {
         return this.FLanguage;
      }
      
      public function set Language(param1:Object) : void
      {
         this.FLanguage = param1;
      }
      
      public function get Link() : Object
      {
         return this.FLink;
      }
      
      public function set Link(param1:Object) : void
      {
         this.FLink = param1;
      }
   }
}

