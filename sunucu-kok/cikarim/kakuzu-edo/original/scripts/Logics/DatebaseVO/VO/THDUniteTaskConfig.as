package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDUniteTaskConfig extends THDActivityBase
   {
      
      protected var FTasks:Array;
      
      protected var FEmploy:Array;
      
      protected var FExtract:Object;
      
      protected var FFinalAward:Object;
      
      protected var FTotalTaskIndex:int;
      
      protected var FExtractIndex:int;
      
      protected var FLanguage:Object;
      
      protected var FLink:Array;
      
      public function THDUniteTaskConfig()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FTasks = Json.decode(TUtilityString.FetchUTF(param1));
         this.FEmploy = Json.decode(TUtilityString.FetchUTF(param1));
         this.FExtract = Json.decode(TUtilityString.FetchUTF(param1));
         this.FFinalAward = Json.decode(TUtilityString.FetchUTF(param1));
         this.FExtractIndex = param1.readInt();
         this.FLanguage = Json.decode(TUtilityString.FetchUTF(param1));
         this.FLink = Json.decode(TUtilityString.FetchUTF(param1));
      }
      
      public function get Tasks() : Array
      {
         return this.FTasks;
      }
      
      public function get Employ() : Array
      {
         return this.FEmploy;
      }
      
      public function get Extract() : Object
      {
         return this.FExtract;
      }
      
      public function get FinalAward() : Object
      {
         return this.FFinalAward;
      }
      
      public function get TotalTaskIndex() : int
      {
         return this.FTotalTaskIndex;
      }
      
      public function get ExtractIndex() : int
      {
         return this.FExtractIndex;
      }
      
      public function get Language() : Object
      {
         return this.FLanguage;
      }
      
      public function get Link() : Array
      {
         return this.FLink;
      }
   }
}

