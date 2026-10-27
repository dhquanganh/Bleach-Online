package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TMall extends TDatebaseVO
   {
      
      protected var FModel:int;
      
      protected var FName:String;
      
      protected var FMajorType:int;
      
      protected var FItemID:int;
      
      protected var FType:String;
      
      protected var FIntegration:int;
      
      protected var FLevel:int;
      
      protected var FIsVip:Boolean;
      
      protected var FIsDisplay:Boolean;
      
      protected var FAmount:int;
      
      protected var FGold:int;
      
      protected var FDiscount:int;
      
      protected var FHotprice:int;
      
      protected var FPage:int;
      
      protected var FVip:int;
      
      protected var FIsHot:Boolean;
      
      protected var FIsnew:Boolean;
      
      protected var FTimes:int;
      
      protected var FTotalTimes:uint;
      
      protected var FItems:TFixedAward;
      
      protected var FHonour:uint;
      
      public function TMall()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         this.FModel = param1.readInt();
         this.FName = TUtilityString.FetchUTF(param1);
         this.FMajorType = param1.readUnsignedInt();
         this.FItemID = param1.readUnsignedInt();
         this.FType = TUtilityString.FetchUTF(param1);
         this.FIntegration = param1.readUnsignedInt();
         this.FLevel = param1.readInt();
         this.FIsVip = param1.readInt() != 0;
         this.FIsDisplay = param1.readInt() != 0;
         this.FAmount = param1.readUnsignedInt();
         this.FGold = param1.readUnsignedInt();
         this.FDiscount = param1.readUnsignedInt();
         this.FHotprice = param1.readUnsignedInt();
         this.FPage = param1.readInt();
         this.FVip = param1.readInt();
         this.FIsHot = param1.readInt() != 0;
         this.FIsnew = param1.readInt() != 0;
         this.FTimes = param1.readUnsignedInt();
         this.FTotalTimes = param1.readUnsignedInt();
         _loc3_ = TUtilityString.FetchUTF(param1);
         if(_loc3_ != "")
         {
            _loc2_ = Json.decode(_loc3_) as Object;
            this.FItems = new TFixedAward(_loc2_);
         }
         this.FHonour = param1.readUnsignedInt();
      }
      
      public function get Model() : int
      {
         return this.FModel;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get MajorType() : int
      {
         return this.FMajorType;
      }
      
      public function get ItemID() : int
      {
         return this.FItemID;
      }
      
      public function get Type() : String
      {
         return this.FType;
      }
      
      public function get Integration() : int
      {
         return this.FIntegration;
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function get IsVip() : Boolean
      {
         return this.FIsVip;
      }
      
      public function get IsDisplay() : Boolean
      {
         return this.FIsDisplay;
      }
      
      public function get Amount() : int
      {
         return this.FAmount;
      }
      
      public function get Gold() : int
      {
         return this.FGold;
      }
      
      public function get Discount() : int
      {
         return this.FDiscount;
      }
      
      public function get Hotprice() : int
      {
         return this.FHotprice;
      }
      
      public function get Page() : int
      {
         return this.FPage;
      }
      
      public function get Vip() : int
      {
         return this.FVip;
      }
      
      public function get IsHot() : Boolean
      {
         return this.FIsHot;
      }
      
      public function get Isnew() : Boolean
      {
         return this.FIsnew;
      }
      
      public function get Times() : int
      {
         return this.FTimes;
      }
      
      public function get Items() : TFixedAward
      {
         return this.FItems;
      }
      
      public function get Honour() : uint
      {
         return this.FHonour;
      }
      
      public function get TotalTimes() : uint
      {
         return this.FTotalTimes;
      }
   }
}

