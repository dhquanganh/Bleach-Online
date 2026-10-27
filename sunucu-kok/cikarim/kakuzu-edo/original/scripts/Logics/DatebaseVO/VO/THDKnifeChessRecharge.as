package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDKnifeChessRecharge extends THDActivityBase
   {
      
      protected var FGlobalIndex:int;
      
      protected var FTotalGold:int;
      
      protected var FRecharge:Vector.<Object>;
      
      protected var FCollectBag:Object;
      
      protected var FDayCollectIndex:uint;
      
      public function THDKnifeChessRecharge()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FGlobalIndex = param1.readInt();
         this.FTotalGold = param1.readInt();
         this.FRecharge = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FCollectBag = Json.decode(TUtilityString.FetchUTF(param1));
         this.FDayCollectIndex = param1.readInt();
      }
      
      public function get GlobalIndex() : int
      {
         return this.FGlobalIndex;
      }
      
      public function get TotalGold() : int
      {
         return this.FTotalGold;
      }
      
      public function get Recharge() : Vector.<Object>
      {
         return this.FRecharge;
      }
      
      public function get CollectBag() : Object
      {
         return this.FCollectBag;
      }
      
      public function get DayCollectIndex() : uint
      {
         return this.FDayCollectIndex;
      }
   }
}

