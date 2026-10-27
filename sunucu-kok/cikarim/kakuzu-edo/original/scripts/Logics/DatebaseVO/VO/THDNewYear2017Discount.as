package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDNewYear2017Discount extends THDActivityBase
   {
      
      public var FOneAward:Vector.<Object>;
      
      public var FTwoAward:Vector.<Object>;
      
      public var FThreeAward:Vector.<Object>;
      
      public var FScoreRatio:int;
      
      public var FOneMall:Vector.<int>;
      
      public var FTwoMall:Vector.<int>;
      
      public var FThreeMall:Vector.<int>;
      
      public var FChargeOrgIndex:int;
      
      public var FChargeRedIndex:int;
      
      public var FScoreIndex:int;
      
      public var FFreshOneAward:int;
      
      public var FFreshTwoAward:int;
      
      public var FFreshThreeAward:int;
      
      public var FBuyIndex:int;
      
      public var FSaleIndex:int;
      
      public var FSaleCost:int;
      
      public var FAwardCost:int;
      
      public var FOrgRatio:int;
      
      public var FRedRatio:int;
      
      public var FRand:Vector.<int>;
      
      public var FText:String;
      
      public function THDNewYear2017Discount()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FOneAward = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FTwoAward = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FThreeAward = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FScoreRatio = param1.readUnsignedInt();
         this.FOneMall = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FTwoMall = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FThreeMall = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FChargeOrgIndex = param1.readUnsignedInt();
         this.FChargeRedIndex = param1.readUnsignedInt();
         this.FScoreIndex = param1.readUnsignedInt();
         this.FFreshOneAward = param1.readUnsignedInt();
         this.FFreshTwoAward = param1.readUnsignedInt();
         this.FFreshThreeAward = param1.readUnsignedInt();
         this.FBuyIndex = param1.readUnsignedInt();
         this.FSaleIndex = param1.readUnsignedInt();
         this.FSaleCost = param1.readUnsignedInt();
         this.FAwardCost = param1.readUnsignedInt();
         this.FOrgRatio = param1.readUnsignedInt();
         this.FRedRatio = param1.readUnsignedInt();
         this.FRand = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FText = TUtilityString.FetchUTF(param1);
      }
   }
}

