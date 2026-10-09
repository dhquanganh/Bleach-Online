package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TBlackMarket extends TDatebaseVO
   {
      
      protected var FModel:int;
      
      protected var FItemID:int;
      
      protected var FOldPrice:Object;
      
      protected var FPrice:Object;
      
      protected var FNumber:int;
      
      protected var FTotalTimes:int;
      
      public function TBlackMarket()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FModel = param1.readInt();
         this.FItemID = param1.readInt();
         this.FOldPrice = Json.decode(TUtilityString.FetchUTF(param1));
         this.FPrice = Json.decode(TUtilityString.FetchUTF(param1));
         this.FNumber = param1.readInt();
         this.FTotalTimes = param1.readInt();
         if(this.Identifier == 20000001)
         {
            this.ApplyLocalOffer({itemID:14100005,number:50,price:{type:0,code:1,amount:50},totalTimes:1});
         }
      }
      
      public function ApplyLocalOffer(o:Object) : void
      {
         this.FItemID = int(o.itemID);
         this.FNumber = int(o.number);
         this.FPrice = o.price;
         this.FOldPrice = o.price;
         this.FTotalTimes = int(o.totalTimes);
      }
      public function get Model() : int
      {
         return this.FModel;
      }
      
      public function get ItemID() : int
      {
         return this.FItemID;
      }
      
      public function get OldPrice() : Object
      {
         return this.FOldPrice;
      }
      
      public function get Price() : Object
      {
         return this.FPrice;
      }
      
      public function get Number() : int
      {
         return this.FNumber;
      }
      
      public function get TotalTimes() : int
      {
         return this.FTotalTimes;
      }
   }
}

