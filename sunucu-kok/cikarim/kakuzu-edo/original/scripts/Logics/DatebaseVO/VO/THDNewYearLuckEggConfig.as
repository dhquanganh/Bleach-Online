package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDNewYearLuckEggConfig extends THDActivityBase
   {
      
      protected var FLoginAward:Array;
      
      protected var FCopperEgg:Object;
      
      protected var FSilverEgg:Object;
      
      protected var FGoldEgg:Object;
      
      protected var FEggTicketAward:Array;
      
      protected var FHammerCostGold:int;
      
      protected var FFreeTimes:int;
      
      protected var FFreeTimeIndex:int;
      
      protected var FHammerIndex:int;
      
      protected var FEggTicketIndex:int;
      
      protected var FTimeIndex:int;
      
      protected var FLanguage:Array;
      
      public function THDNewYearLuckEggConfig()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FLoginAward = Json.decode(TUtilityString.FetchUTF(param1));
         this.FCopperEgg = Json.decode(TUtilityString.FetchUTF(param1));
         this.FSilverEgg = Json.decode(TUtilityString.FetchUTF(param1));
         this.FGoldEgg = Json.decode(TUtilityString.FetchUTF(param1));
         this.FEggTicketAward = Json.decode(TUtilityString.FetchUTF(param1));
         this.FHammerCostGold = param1.readInt();
         this.FFreeTimes = param1.readInt();
         this.FFreeTimeIndex = param1.readInt();
         this.FHammerIndex = param1.readInt();
         this.FEggTicketIndex = param1.readInt();
         this.FTimeIndex = param1.readInt();
         this.FLanguage = Json.decode(TUtilityString.FetchUTF(param1));
      }
      
      public function get LoginAward() : Array
      {
         return this.FLoginAward;
      }
      
      public function get CopperEgg() : Object
      {
         return this.FCopperEgg;
      }
      
      public function get SilverEgg() : Object
      {
         return this.FSilverEgg;
      }
      
      public function get GoldEgg() : Object
      {
         return this.FGoldEgg;
      }
      
      public function get EggTicketAward() : Array
      {
         return this.FEggTicketAward;
      }
      
      public function get FreeTimes() : int
      {
         return this.FFreeTimes;
      }
      
      public function get FreeTimeIndex() : int
      {
         return this.FFreeTimeIndex;
      }
      
      public function get HammerIndex() : int
      {
         return this.FHammerIndex;
      }
      
      public function get EggTicketIndex() : int
      {
         return this.FEggTicketIndex;
      }
      
      public function get TimeIndex() : int
      {
         return this.FTimeIndex;
      }
      
      public function get HammerCostGold() : int
      {
         return this.FHammerCostGold;
      }
      
      public function get Language() : Array
      {
         return this.FLanguage;
      }
   }
}

