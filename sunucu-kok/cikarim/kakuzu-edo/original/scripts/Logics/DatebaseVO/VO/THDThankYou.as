package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDThankYou extends THDActivityBase
   {
      
      protected var FWitness:Object;
      
      protected var FGrowth:Object;
      
      protected var FVip:Object;
      
      protected var FSuperVip:Object;
      
      protected var FOnlineIndex:int;
      
      public function THDThankYou()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FWitness = Json.decode(TUtilityString.FetchUTF(param1));
         this.FGrowth = Json.decode(TUtilityString.FetchUTF(param1));
         this.FVip = Json.decode(TUtilityString.FetchUTF(param1));
         this.FSuperVip = Json.decode(TUtilityString.FetchUTF(param1));
         this.FOnlineIndex = param1.readInt();
      }
      
      public function get Witness() : Object
      {
         return this.FWitness;
      }
      
      public function get Growth() : Object
      {
         return this.FGrowth;
      }
      
      public function get Vip() : Object
      {
         return this.FVip;
      }
      
      public function get SuperVip() : Object
      {
         return this.FSuperVip;
      }
      
      public function get OnlineIndex() : int
      {
         return this.FOnlineIndex;
      }
   }
}

