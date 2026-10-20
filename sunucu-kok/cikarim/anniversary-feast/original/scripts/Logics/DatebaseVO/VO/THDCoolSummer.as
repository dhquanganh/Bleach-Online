package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDCoolSummer extends THDActivityBase
   {
      
      protected var FRepository:Vector.<Object>;
      
      protected var FShellIndex:Vector.<int>;
      
      protected var FOpenOnce:Object;
      
      protected var FOpenAll:Object;
      
      protected var FRefresh:Object;
      
      protected var FChoose:int;
      
      protected var FScore:int;
      
      protected var FScoreShop:Vector.<Object>;
      
      protected var FMainAward:Object;
      
      protected var FLanguage:Object;
      
      public function THDCoolSummer()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FRepository = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FShellIndex = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FOpenOnce = Json.decode(TUtilityString.FetchUTF(param1));
         this.FOpenAll = Json.decode(TUtilityString.FetchUTF(param1));
         this.FRefresh = Json.decode(TUtilityString.FetchUTF(param1));
         this.FChoose = param1.readInt();
         this.FScore = param1.readInt();
         this.FScoreShop = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FMainAward = Json.decode(TUtilityString.FetchUTF(param1));
         this.FLanguage = Json.decode(TUtilityString.FetchUTF(param1));
         this.FRepository.sort(this.SortRepository);
      }
      
      protected function SortRepository(param1:Object, param2:Object) : Number
      {
         if(param1.gold > param2.gold)
         {
            return -1;
         }
         if(param1.gold == param2.gold)
         {
            return 0;
         }
         return 1;
      }
      
      public function get Repository() : Vector.<Object>
      {
         return this.FRepository;
      }
      
      public function get OpenOnce() : Object
      {
         return this.FOpenOnce;
      }
      
      public function get OpenAll() : Object
      {
         return this.FOpenAll;
      }
      
      public function get Refresh() : Object
      {
         return this.FRefresh;
      }
      
      public function get Choose() : int
      {
         return this.FChoose;
      }
      
      public function get Score() : int
      {
         return this.FScore;
      }
      
      public function get ScoreShop() : Vector.<Object>
      {
         return this.FScoreShop;
      }
      
      public function get MainAward() : Object
      {
         return this.FMainAward;
      }
      
      public function get ShellIndex() : Vector.<int>
      {
         return this.FShellIndex;
      }
      
      public function get Language() : Object
      {
         return this.FLanguage;
      }
   }
}

