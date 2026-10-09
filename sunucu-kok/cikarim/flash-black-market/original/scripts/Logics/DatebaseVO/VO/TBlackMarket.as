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

