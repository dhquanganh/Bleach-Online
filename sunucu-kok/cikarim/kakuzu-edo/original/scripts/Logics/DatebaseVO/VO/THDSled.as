package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDSled extends THDActivityBase
   {
      
      protected var FRobbery:Object;
      
      protected var FTransport:Object;
      
      protected var FChristmasCardsIndex:int;
      
      protected var FRefreshQuality:Object;
      
      protected var FOneKeyRed:Object;
      
      protected var FBeginTransport:Object;
      
      protected var FSledInfos:Object;
      
      protected var FRobberyInterfaceIndex:int;
      
      protected var FOnekeyArrival:Object;
      
      protected var FReceiveAwardIndex:int;
      
      protected var FBigGift:Object;
      
      protected var FMaxSize:int;
      
      protected var FTransportTime:int;
      
      protected var FTransportProtect:int;
      
      protected var FRobberyPersonIndex:int;
      
      protected var FRobberyIndex:Object;
      
      protected var FShop:Vector.<Object>;
      
      protected var FGoldCards:Vector.<int>;
      
      protected var FLanguage:Object;
      
      public function THDSled()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FRobbery = Json.decode(TUtilityString.FetchUTF(param1));
         this.FTransport = Json.decode(TUtilityString.FetchUTF(param1));
         this.FChristmasCardsIndex = param1.readUnsignedInt();
         this.FRefreshQuality = Json.decode(TUtilityString.FetchUTF(param1));
         this.FOneKeyRed = Json.decode(TUtilityString.FetchUTF(param1));
         this.FBeginTransport = Json.decode(TUtilityString.FetchUTF(param1));
         this.FSledInfos = Json.decode(TUtilityString.FetchUTF(param1));
         this.FRobberyInterfaceIndex = param1.readUnsignedInt();
         this.FOnekeyArrival = Json.decode(TUtilityString.FetchUTF(param1));
         this.FReceiveAwardIndex = param1.readUnsignedInt();
         this.FBigGift = Json.decode(TUtilityString.FetchUTF(param1));
         this.FMaxSize = param1.readUnsignedInt();
         this.FTransportTime = param1.readUnsignedInt();
         this.FTransportProtect = param1.readUnsignedInt();
         this.FRobberyPersonIndex = param1.readUnsignedInt();
         this.FRobberyIndex = Json.decode(TUtilityString.FetchUTF(param1));
         this.FShop = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FGoldCards = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FLanguage = Json.decode(TUtilityString.FetchUTF(param1));
      }
      
      public function get Robbery() : Object
      {
         return this.FRobbery;
      }
      
      public function get Transport() : Object
      {
         return this.FTransport;
      }
      
      public function get ChristmasCardsIndex() : int
      {
         return this.FChristmasCardsIndex;
      }
      
      public function get RefreshQuality() : Object
      {
         return this.FRefreshQuality;
      }
      
      public function get OneKeyRed() : Object
      {
         return this.FOneKeyRed;
      }
      
      public function get BeginTransport() : Object
      {
         return this.FBeginTransport;
      }
      
      public function get SledInfos() : Object
      {
         return this.FSledInfos;
      }
      
      public function get RobberyInterfaceIndex() : int
      {
         return this.FRobberyInterfaceIndex;
      }
      
      public function get OnekeyArrival() : Object
      {
         return this.FOnekeyArrival;
      }
      
      public function get ReceiveAwardIndex() : int
      {
         return this.FReceiveAwardIndex;
      }
      
      public function get BigGift() : Object
      {
         return this.FBigGift;
      }
      
      public function get MaxSize() : int
      {
         return this.FMaxSize;
      }
      
      public function get TransportTime() : int
      {
         return this.FTransportTime;
      }
      
      public function get TransportProtect() : int
      {
         return this.FTransportProtect;
      }
      
      public function get RobberyIndex() : Object
      {
         return this.FRobberyIndex;
      }
      
      public function get Shop() : Vector.<Object>
      {
         return this.FShop;
      }
      
      public function get GoldCards() : Vector.<int>
      {
         return this.FGoldCards;
      }
      
      public function get Language() : Object
      {
         return this.FLanguage;
      }
      
      public function get RobberyPersonIndex() : int
      {
         return this.FRobberyPersonIndex;
      }
   }
}

