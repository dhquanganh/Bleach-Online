package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDThanksFeast extends THDActivityBase
   {
      
      protected var FPuzzle:Object;
      
      protected var FPet:Object;
      
      protected var FRechargeIndex:int;
      
      protected var FDailyRechargeIndex:int;
      
      protected var FDailyGift:Object;
      
      public function THDThanksFeast()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FPuzzle = Json.decode(TUtilityString.FetchUTF(param1));
         this.FPet = Json.decode(TUtilityString.FetchUTF(param1));
         this.FRechargeIndex = param1.readInt();
         this.FDailyRechargeIndex = param1.readInt();
         this.FDailyGift = Json.decode(TUtilityString.FetchUTF(param1));
      }
      
      public function get Puzzle() : Object
      {
         return this.FPuzzle;
      }
      
      public function get Pet() : Object
      {
         return this.FPet;
      }
      
      public function get RechargeIndex() : int
      {
         return this.FRechargeIndex;
      }
      
      public function get DailyGift() : Object
      {
         return this.FDailyGift;
      }
      
      public function get DailyRechargeIndex() : int
      {
         return this.FDailyRechargeIndex;
      }
   }
}

