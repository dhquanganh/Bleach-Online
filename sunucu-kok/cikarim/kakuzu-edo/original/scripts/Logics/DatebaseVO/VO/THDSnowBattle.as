package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDSnowBattle extends THDActivityBase
   {
      
      protected var FCandy:int;
      
      protected var FBuyIndex:int;
      
      protected var FNotify:int;
      
      protected var FResultType:Vector.<int>;
      
      protected var FTitleGift:Object;
      
      protected var FGift:Vector.<Object>;
      
      protected var FTurn:int;
      
      protected var FGold:int;
      
      protected var FCountdown:int;
      
      public function THDSnowBattle()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FCandy = param1.readUnsignedInt();
         this.FBuyIndex = param1.readUnsignedInt();
         this.FNotify = param1.readUnsignedInt();
         this.FResultType = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FTitleGift = Json.decode(TUtilityString.FetchUTF(param1));
         this.FGift = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FTurn = param1.readUnsignedInt();
         this.FGold = param1.readUnsignedInt();
         this.FCountdown = param1.readUnsignedInt();
      }
      
      public function get Candy() : int
      {
         return this.FCandy;
      }
      
      public function get BuyIndex() : int
      {
         return this.FBuyIndex;
      }
      
      public function get Notify() : int
      {
         return this.FNotify;
      }
      
      public function get ResultType() : Vector.<int>
      {
         return this.FResultType;
      }
      
      public function get TitleGift() : Object
      {
         return this.FTitleGift;
      }
      
      public function get Gift() : Vector.<Object>
      {
         return this.FGift;
      }
      
      public function get Turn() : int
      {
         return this.FTurn;
      }
      
      public function get Gold() : int
      {
         return this.FGold;
      }
      
      public function get Countdown() : int
      {
         return this.FCountdown;
      }
   }
}

